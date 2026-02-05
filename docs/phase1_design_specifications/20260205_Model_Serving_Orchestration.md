# Model Serving & Orchestration Design
## Sovereign AI Infrastructure: Model Lifecycle Management & Warm Pool Strategy

**Document Version**: 1.0  
**Date**: February 5, 2026  
**Status**: Draft for Review  
**Owner**: ML Infrastructure Engineer

---

## Executive Summary

This document specifies the **Model Serving & Orchestration** subsystem responsible for:
1. Loading/unloading Worker models on GPU
2. Managing CPU-resident Router and Validator
3. Implementing warm pool strategy (RAM caching)
4. Orchestrating the Generate → Validate → Commit cycle
5. Optimizing model swap times and resource utilization

**Key Technologies**: llama.cpp (inference), Python (orchestration), CUDA (GPU), system RAM (warm pool)

**Performance Targets**:
- Model swap time: <3 seconds (RAM → VRAM)
- Worker inference: ≥20 tokens/second
- VRAM utilization: 90-95% (maximize efficiency)

---

## Table of Contents

1. [Model Serving Architecture](#1-model-serving-architecture)
2. [llama.cpp Configuration](#2-llamacpp-configuration)
3. [Model Loader & Warm Pool](#3-model-loader--warm-pool)
4. [Orchestration Engine](#4-orchestration-engine)
5. [Performance Optimization](#5-performance-optimization)
6. [Monitoring & Telemetry](#6-monitoring--telemetry)
7. [Failure Handling](#7-failure-handling)
8. [Appendices](#8-appendices)

---

## 1. Model Serving Architecture

### 1.1 Three-Tier Model Deployment

```
Tier 1: GPU (VRAM) - HOT
├── Current Worker Model (one at a time)
│   └── 12-18GB VRAM footprint
└── Inference Speed: 20-40 tok/s

Tier 2: CPU (RAM) - WARM
├── Router (Granite-Micro 3B) - always loaded
├── Validator (Granite-H-Small) - always loaded
├── Warm Pool (2-3 Worker models pre-loaded)
│   └── 60-80GB RAM total
└── Inference Speed: 3-10 tok/s (CPU models)

Tier 3: NVMe (Disk) - COLD
├── Model Vault (all models, all quantizations)
│   └── 500GB storage
└── Load Time: 10-15 seconds (cold start)
```

### 1.2 llama.cpp Server Instances

**Three separate llama.cpp servers**:

| Server | Hardware | Port | Model | Purpose | Auto-restart |
|--------|----------|------|-------|---------|--------------|
| `llama-gpu` | GPU | 8000 | Worker (dynamic) | Generation | Yes |
| `llama-router` | CPU | 8001 | Granite-Micro 3B | Routing | Yes |
| `llama-validator` | CPU | 8002 | Granite-H-Small | Validation | Yes |

---

## 2. llama.cpp Configuration

### 2.1 GPU Server (Worker)

**Startup Command**:
```bash
/opt/llama.cpp/server \
  --model /mnt/models/workers/qwen-coder-32b-q4_k_m.gguf \
  --ctx-size 4096 \
  --batch-size 512 \
  --threads 4 \
  --n-gpu-layers 999 \
  --port 8000 \
  --host 127.0.0.1 \
  --embedding false \
  --log-disable false
```

**Key Parameters**:
- `--n-gpu-layers 999`: Offload all layers to GPU (maximize VRAM usage)
- `--ctx-size 4096`: Context window size (4K tokens)
- `--batch-size 512`: Prompt processing batch (larger = faster prompt processing)
- `--threads 4`: CPU threads for prompt processing (before GPU inference)

### 2.2 CPU Server (Router)

**Startup Command**:
```bash
/opt/llama.cpp/server \
  --model /mnt/models/router/granite-micro-3b-q8.gguf \
  --ctx-size 2048 \
  --threads 6 \
  --n-gpu-layers 0 \
  --port 8001 \
  --host 127.0.0.1
```

**Key Parameters**:
- `--n-gpu-layers 0`: CPU-only (no GPU usage)
- `--threads 6`: Use all 6 CPU cores for maximum speed
- `--ctx-size 2048`: Smaller context (routing is short-form)

### 2.3 CPU Server (Validator)

**Startup Command**:
```bash
/opt/llama.cpp/server \
  --model /mnt/models/validator/granite-h-small-q4_k_m.gguf \
  --ctx-size 4096 \
  --threads 6 \
  --n-gpu-layers 0 \
  --port 8002 \
  --host 127.0.0.1
```

**KV Cache Quantization** (if memory constrained):
```bash
--cache-type-k q8_0 --cache-type-v q8_0
```
Reduces KV cache from FP16 → INT8, doubling context capacity.

---

## 3. Model Loader & Warm Pool

### 3.1 Python Implementation

```python
class ModelLoader:
    """
    Manages GPU model lifecycle and warm pool.
    """
    
    def __init__(self, config):
        self.config = config
        self.current_gpu_model = None
        self.warm_pool = {}  # {model_name: in_memory_model}
        self.model_vault = Path("/mnt/models")
        self.gpu_endpoint = "http://localhost:8000"
    
    def load_to_gpu(self, model_name: str) -> bool:
        """Load model to GPU (from warm pool or disk)."""
        # Check VRAM
        if not self._vram_available():
            self._unload_current_gpu_model()
        
        # Load from warm pool if available
        if model_name in self.warm_pool:
            start = time.time()
            self._transfer_ram_to_vram(model_name)
            swap_time = time.time() - start
            logger.info(f"Loaded {model_name} from warm pool in {swap_time:.2f}s")
        else:
            # Cold start from disk
            start = time.time()
            self._load_from_disk(model_name)
            swap_time = time.time() - start
            logger.info(f"Cold loaded {model_name} from disk in {swap_time:.2f}s")
        
        self.current_gpu_model = model_name
        metrics.model_swap_duration.observe(swap_time)
        return True
    
    def preload_to_warm_pool(self, model_name: str):
        """Pre-load model into RAM (warm pool)."""
        if model_name in self.warm_pool:
            return  # Already loaded
        
        if self._ram_available() < self._model_size(model_name):
            self._evict_from_warm_pool()  # LRU eviction
        
        logger.info(f"Pre-loading {model_name} to warm pool")
        # Load into RAM (not VRAM)
        self.warm_pool[model_name] = self._load_to_ram(model_name)
```

### 3.2 Warm Pool Strategy

**Predictive Loading**:
```python
def predict_next_model(current_domain: str, history: List[str]) -> str:
    """Predict which model to pre-load based on context."""
    # Rule-based prediction
    if current_domain == "coding_architecture":
        # Likely next: implementation (Nemotron)
        return "nemotron_30b"
    elif current_domain == "reasoning":
        # Could go to coding next
        return "qwen_coder_32b"
    
    # History-based prediction
    if history[-3:] == ["qwen", "nemotron", "qwen"]:
        # Pattern: architectural → implementation → architecture
        return "nemotron_30b"
    
    # Default: most frequently used
    return get_most_frequent_model(history)
```

**LRU Eviction**:
```python
def _evict_from_warm_pool(self):
    """Evict least recently used model from warm pool."""
    lru_model = min(self.warm_pool.keys(), 
                    key=lambda m: self.warm_pool[m]['last_access'])
    
    del self.warm_pool[lru_model]
    logger.info(f"Evicted {lru_model} from warm pool (LRU)")
```

---

## 4. Orchestration Engine

### 4.1 Main Execution Loop

```python
class Orchestrator:
    """
    Main coordinator for request processing.
    """
    
    def process_request(self, user_input: str) -> Dict:
        """End-to-end request processing."""
        request_id = generate_request_id()
        
        # Step 1: Routing
        routing_decision = self.router.classify(user_input)
        self.memory.append_to_scratchpad(
            f"## Routing Decision\n{routing_decision}"
        )
        
        # Step 2: Context preparation
        context = self._prepare_context(user_input, routing_decision)
        
        # Step 3: Load appropriate Worker
        model_name = routing_decision['recommended_model']
        self.model_loader.load_to_gpu(model_name)
        
        # Step 4: Generation (with or without validation)
        if routing_decision['validation_policy'] == 'block_by_block':
            output = self._generate_with_validation(user_input, context)
        else:
            output = self._generate_simple(user_input, context)
        
        # Step 5: Commit and return
        self.memory.commit_to_project_state(output)
        return output
    
    def _generate_with_validation(self, prompt, context):
        """Generate with block-by-block validation."""
        blocks = []
        max_retries = 3
        
        while not self._is_complete(blocks):
            # Generate next block
            block = self.worker_model.generate_block(prompt, context, blocks)
            
            # Validate block
            verdict = self.validator.validate(block, context)
            
            if verdict['status'] == 'PASS':
                blocks.append(block)
                self.memory.commit_to_project_state(block)
            else:
                # Retry with correction
                retries = 0
                while retries < max_retries and verdict['status'] == 'FAIL':
                    correction = verdict['correction']
                    self.memory.append_to_scratchpad(
                        f"[FAIL] {correction}"
                    )
                    block = self.worker_model.generate_block(
                        prompt, context, blocks, correction
                    )
                    verdict = self.validator.validate(block, context)
                    retries += 1
                
                if verdict['status'] == 'PASS':
                    blocks.append(block)
                else:
                    raise ValidationError("Max retries exceeded")
        
        return ''.join(blocks)
```

---

## 5. Performance Optimization

### 5.1 Model Quantization Strategy

| Model | Size | Quantization | VRAM (GB) | Quality Loss | Notes |
|-------|------|--------------|-----------|--------------|-------|
| Qwen 32B | 64GB (FP16) | Q4_K_M | 18 | ~5% | Architecture specialist |
| Nemotron 30B | 60GB (FP16) | Q4_K_M | 16 | ~5% | Implementation |
| GPT-OSS 20B | 40GB (FP16) | Q4_K_M | 12 | ~4% | MoE efficiency |
| MythoMax 13B | 26GB (FP16) | Q5_K_M | 9 | ~2% | Higher quality for creative |

### 5.2 Batch Processing

**Prompt Prefill Optimization**:
- Use large batch size (512) for prompt processing
- Single-token generation uses smaller batch (1)

### 5.3 KV Cache Management

**Problem**: KV cache grows with context, consuming VRAM.

**Solutions**:
1. **INT8 KV Cache**: Reduces cache size by 50%
2. **Sliding Window**: Keep only last N tokens in cache
3. **CPU Offloading**: Move old KV cache entries to RAM

---

## 6. Monitoring & Telemetry

### 6.1 Metrics

```python
from prometheus_client import Histogram, Gauge, Counter

# Model swap metrics
model_swap_duration = Histogram('model_swap_duration_seconds', 
                                'Time to swap models')

# Inference metrics
inference_tokens_per_second = Gauge('inference_tokens_per_second',
                                   'Token generation speed',
                                   ['model'])

# Resource metrics
vram_used_bytes = Gauge('vram_used_bytes', 'VRAM usage')
ram_used_bytes = Gauge('ram_used_bytes', 'RAM usage')

# Error metrics
model_load_failures = Counter('model_load_failures_total',
                             'Failed model loads',
                             ['model'])
```

---

## 7. Failure Handling

### 7.1 OOM Recovery

```python
def handle_oom():
    """Handle Out-of-Memory errors."""
    logger.error("OOM detected")
    
    # Step 1: Unload current model
    unload_gpu_model()
    
    # Step 2: Try more aggressive quantization
    fallback_model = get_fallback_model()  # Smaller or Q3
    load_to_gpu(fallback_model)
    
    # Step 3: Retry request
    return "retry"
```

---

## Appendices

### A. System Prompts

**Worker Prompt (Qwen Coder)**:
```
You are an expert software architect. Generate code in small, logical blocks.
Output ONE function or class at a time. Use type hints. Be explicit about dependencies.
```

**Validator Prompt (Granite)**:
```
You are a strict code validator. Check for:
- Syntax errors
- Logical consistency
- Hallucinated APIs
- Missing edge cases

Output: [PASS] or [FAIL: reason]
```

**End of Document**

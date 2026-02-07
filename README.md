# **Bicameral‑AI: Sovereign AI Infrastructure for High‑Assurance Local Reasoning**

Bicameral‑AI is a sovereign, locally‑hosted AI orchestration system engineered to deliver **high‑assurance reasoning on constrained hardware**. It implements a *bicameral cognitive architecture*:  
- a **GPU Generative Chamber** for creative and synthetic work  
- a **CPU Logical Chamber** for routing, validation, and constitutional governance  

This separation allows small, open‑weight models to behave like much larger systems through iterative refinement, validation, and symbolic oversight — without cloud dependence, data exposure, or frontier‑scale compute.

---

## **Why Bicameral‑AI Exists**

Modern AI forces a trade‑off between capability, privacy, and trust. Bicameral‑AI rejects that compromise. It is built to solve three foundational problems:

### **1. Data Sovereignty**  
100% local, air‑gapped execution with no external APIs. All inference, routing, validation, and memory remain on‑premise.

### **2. Economic Feasibility**  
Frontier‑level reliability on consumer hardware by **trading latency for correctness**. Time becomes a resource, not a constraint.

### **3. Auditability & Robustness**  
A governed AI system that can be **tested, validated, and traced** like traditional software — capable of building large, complex codebases under constitutional constraints.

---

## **The Philosophy: Accuracy Over Latency**

Historically, correctness mattered more than speed — programs ran overnight, or for days, to ensure reliability. Bicameral‑AI returns to that mindset.

The GPU chamber generates.  
The CPU chamber governs.  
The system iterates until the output is *correct*, not merely plausible.

This architecture enables smaller models to outperform their size class through structured refinement, validator feedback, and symbolic routing.

---

## **The Ralph‑Prolog‑TDD Triad**

Bicameral‑AI is governed by a three‑part constitutional mechanism:

### **• The Constitution (Prolog)**  
A symbolic logic engine that determines domain, stakes, model selection, and required validation. It is the system’s law.

### **• The Invariant (TDD)**  
Every task begins with a Test‑Driven Development harness. Tests encode the contract, invariants, and expected behaviour.

### **• The Enforcer (Ralph)**  
A naive persistence loop — a BASH primitive that runs tests repeatedly. If they fail, the system refines the output until they pass.

Together, these components transform generative models into a **governed software‑construction engine**.

---

## **Technical Stack**

### **Model Zoo (Orchestrated via Prolog)**  
Each model is selected based on domain, stakes, and required guarantees:

- **Qwen2.5‑Coder‑32B** — Primary Worker for architecture and complex implementation  
- **IBM Granite‑4.0** — Line‑by‑line Validator and constitutional enforcer  
- **GPT‑OSS‑20B** — General reasoning and planning  
- **Nemotron‑3‑8B** — Performance‑oriented implementation and ops tasks  
- **MythoMax‑L2‑13B** — Creative and narrative generation  
- **Granite‑3.0‑8B‑Instruct** — Efficiency specialist for low‑stakes tasks
- **PaddleOCR-VL-0.9B** - High‑accuracy, fully local OCR engine for document ingestion, provenance extraction, and grounding within the multimodal pipeline.

### **Infrastructure & Governance**

- **Inference Engine:** llama.cpp (GGUF quantization for 16GB VRAM envelopes)  
- **Governance Spine:** SWI‑Prolog (deterministic routing and policy enforcement)  
- **Orchestration Layer:** Python 3.11  
- **Memory System:** Markdown Memory Ledger (transparent, durable, human‑readable audit trail)

---

## **Hardware Profile**

Bicameral‑AI is designed to run on a single‑GPU workstation with a large RAM warm‑pool:

- **OS:** Fedora 42  
- **CPU:** Intel Xeon W‑2135  
- **RAM:** 128GB ECC (warm‑pool for model swapping)  
- **GPU (Compute):** Nvidia Tesla A2 (16GB VRAM)  
- **GPU (Display):** Nvidia GT710  
- **Storage:** Samsung 990 EVO Plus 1TB NVMe  
- **Motherboard:** Supermicro X11SRA  
- **Chassis/Power:** Antec P20CE / MSI MAG A750GL  

This configuration demonstrates that **high‑assurance AI does not require frontier‑scale compute**.

---

## **Project Status**

**Current Phase:** Documentation & Architectural Specification  
The repository currently includes:

- Formal specifications  
- Prolog routing schemas  
- Architectural design documents  
- Memory and governance models  

Next milestone: **Python‑Prolog bridge implementation**.

### **Repository Structure**

```
├── docs/               # Formal specifications and PRDs
├── router/             # Prolog Constitution (The Law)
├── orchestrator/       # Python bridge and llama.cpp management
├── models/             # Model-specific prompt wrappers
└── ledger/             # Markdown-based audit trails
```

---

## **The Ralph Loop (Conceptual)**

1. Prolog determines stakes and selects the model  
2. Qwen generates a TDD test and initial solution  
3. Ralph runs the test  
4. If it fails, Granite analyses the error  
5. The loop repeats until the test passes  

This transforms generative AI into a **deterministic, governed build system**.

---

## **License**

MIT License — see `LICENSE` for details.

**Author:** William Murray

---

# Multimodal Pipeline Design Document
## Sovereign AI Infrastructure: OCR, Vision, and Embedding Integration

**Document Version**: 1.0  
**Date**: February 5, 2026  
**Status**: Draft for Review  
**Owner**: Multimodal Systems Engineer

---

## Executive Summary

This document specifies the **Multimodal Pipelines** that enable the Sovereign AI Infrastructure to process text, documents (OCR), and images (vision encoding), with full provenance tracking.

**Three Core Pipelines**:
1. **OCR Pipeline**: Extract text from scanned documents/images
2. **Vision Pipeline**: Generate captions and features from images
3. **Embedding Pipeline**: Semantic search and retrieval

**Key Requirement**: All multimodal outputs must include **provenance** (source attribution, confidence scores, grounding citations).

---

## Table of Contents

1. [OCR Pipeline](#1-ocr-pipeline)
2. [Vision Encoding Pipeline](#2-vision-encoding-pipeline)
3. [Embedding & Retrieval Pipeline](#3-embedding--retrieval-pipeline)
4. [Integration with Routing](#4-integration-with-routing)
5. [Provenance Tracking](#5-provenance-tracking)
6. [Performance & Quality](#6-performance--quality)

---

## 1. OCR Pipeline

### 1.1 Technology Choice

**Primary**: Tesseract 5.0+
- **Pros**: Open-source, free, good accuracy (90-95% on clean prints)
- **Cons**: Lower accuracy on handwriting, low-resolution scans

**Alternative**: PaddleOCR
- **Pros**: Better accuracy (95-98%), handles handwriting
- **Cons**: Larger model, slower

**Deployment**: CPU (concurrent with Router/Validator)

### 1.2 OCR Process Flow

```
Input: Image/PDF
    ↓
[1. Preprocessing]
   - Convert to grayscale
   - Noise reduction
   - Deskew/orientation correction
    ↓
[2. Text Extraction] (Tesseract)
   - Extract text
   - Bounding boxes
   - Confidence scores
    ↓
[3. Post-processing]
   - Spell check
   - Format cleanup
    ↓
[4. Provenance Tagging]
   - Source file
   - Page numbers
   - Coordinates
    ↓
Output: {text, metadata, confidence}
```

### 1.3 Python Implementation

```python
import pytesseract
from PIL import Image

class OCRPipeline:
    def extract_text(self, image_path: str) -> Dict:
        """Extract text with provenance."""
        img = Image.open(image_path)
        
        # Preprocess
        img = self._preprocess(img)
        
        # Extract with bounding boxes
        data = pytesseract.image_to_data(
            img, 
            output_type=pytesseract.Output.DICT
        )
        
        # Parse results
        extracted_text = " ".join(data['text'])
        confidence = sum(data['conf']) / len(data['conf'])
        
        return {
            "text": extracted_text,
            "source": image_path,
            "confidence": confidence,
            "bounding_boxes": self._extract_boxes(data),
            "metadata": {
                "ocr_engine": "Tesseract 5.0.3",
                "timestamp": datetime.utcnow().isoformat()
            }
        }
```

### 1.4 Grounding Requirements

**Every OCR-based fact must include**:
- Source file name and page number
- Confidence score
- Bounding box coordinates (if available)

**Example**:
```markdown
**Extracted Text**: "Patient diagnosed with Type 2 Diabetes"  
**Source**: medical_record.pdf, page 3, bbox (120, 450, 680, 490)  
**Confidence**: 0.94  
**Uncertain Regions**: "Type 2" (0.89, possible "Type 1")
```

---

## 2. Vision Encoding Pipeline

### 2.1 Technology Choice

**Primary**: CLIP (OpenAI)
- **Pros**: Good for general image understanding, fast
- **Cons**: Generic captions, limited detail

**Alternative**: BLIP (Salesforce)
- **Pros**: Detailed captions, better for complex images
- **Cons**: Slower

**Deployment**: CPU (can optionally use GPU if available)

### 2.2 Vision Process Flow

```
Input: Image
    ↓
[1. Image Encoding] (CLIP/BLIP)
   - Generate embeddings
   - Extract features
    ↓
[2. Caption Generation]
   - Dense caption
   - Object detection
   - Layout description
    ↓
[3. Confidence Scoring]
   - Per-object confidence
   - Overall caption confidence
    ↓
[4. Provenance Tagging]
   - Source image
   - Model version
   - Timestamp
    ↓
Output: {caption, objects, features, metadata}
```

### 2.3 Python Implementation

```python
from transformers import CLIPProcessor, CLIPModel

class VisionPipeline:
    def __init__(self):
        self.model = CLIPModel.from_pretrained("openai/clip-vit-base-patch32")
        self.processor = CLIPProcessor.from_pretrained("openai/clip-vit-base-patch32")
    
    def encode_image(self, image_path: str) -> Dict:
        """Generate caption and features."""
        img = Image.open(image_path)
        
        # Generate embeddings
        inputs = self.processor(images=img, return_tensors="pt")
        features = self.model.get_image_features(**inputs)
        
        # Generate caption (simplified)
        caption = self._generate_caption(img)
        objects = self._detect_objects(img)
        
        return {
            "caption": caption,
            "objects": objects,
            "features": features.tolist(),
            "source": image_path,
            "confidence": 0.85,  # Placeholder
            "metadata": {
                "vision_model": "CLIP ViT-B/32",
                "timestamp": datetime.utcnow().isoformat()
            }
        }
```

---

## 3. Embedding & Retrieval Pipeline

### 3.1 Technology Choice

**Model**: `sentence-transformers/all-MiniLM-L6-v2`
- 384-dimensional embeddings
- Fast (CPU-efficient)
- Good quality for semantic search

**Vector Store**: FAISS (see Data Architecture doc)

### 3.2 Embedding Process

```python
from sentence_transformers import SentenceTransformer

class EmbeddingPipeline:
    def __init__(self):
        self.model = SentenceTransformer('all-MiniLM-L6-v2')
        self.index = faiss.read_index('/data/vector_store/memory.index')
    
    def embed_text(self, text: str) -> np.ndarray:
        """Generate embedding vector."""
        return self.model.encode([text])[0]
    
    def retrieve_similar(self, query: str, top_k: int = 5) -> List[Dict]:
        """Semantic search."""
        query_vector = self.embed_text(query)
        distances, indices = self.index.search(
            np.array([query_vector], dtype=np.float32), 
            top_k
        )
        
        return [
            {
                "content": self.metadata[idx]["content"],
                "source": self.metadata[idx]["source"],
                "relevance": 1.0 / (1.0 + dist)
            }
            for idx, dist in zip(indices[0], distances[0])
        ]
```

---

## 4. Integration with Routing

### 4.1 Automatic Tool Detection

**Router detects multimodal inputs**:

```python
def detect_tools(request: str, attachments: List) -> List[str]:
    """Detect which tools are needed."""
    tools = []
    
    # Check attachments
    for file in attachments:
        if file.mime_type in ['image/jpeg', 'image/png']:
            if 'scanned' in file.name or 'document' in request:
                tools.append('ocr')
            else:
                tools.append('vision')
    
    # Check keywords
    if any(kw in request for kw in ['similar', 'related', 'find']):
        tools.append('embeddings')
    
    return tools
```

### 4.2 Pipeline Orchestration

```python
def prepare_context(request, routing_decision):
    """Run required tools before Worker generation."""
    context = {}
    
    if 'ocr' in routing_decision['tools_required']:
        ocr_output = ocr_pipeline.extract_text(request.attachments[0])
        context['ocr_text'] = ocr_output
    
    if 'vision' in routing_decision['tools_required']:
        vision_output = vision_pipeline.encode_image(request.attachments[0])
        context['vision_caption'] = vision_output
    
    if 'embeddings' in routing_decision['tools_required']:
        similar = embedding_pipeline.retrieve_similar(request.text)
        context['relevant_memory'] = similar
    
    return context
```

---

## 5. Provenance Tracking

### 5.1 Multimodal Provenance Schema

```python
@dataclass
class MultimodalProvenance:
    source_file: str              # Original image/PDF filename
    source_page: Optional[int]    # Page number (if PDF)
    bounding_box: Optional[Tuple] # (x1, y1, x2, y2) coordinates
    confidence: float             # 0.0-1.0
    tool: str                     # "ocr", "vision", "embeddings"
    tool_version: str             # "Tesseract 5.0.3", "CLIP ViT-B/32"
    timestamp: datetime           # UTC
    uncertainty_notes: str        # E.g., "Low confidence on handwriting"
```

### 5.2 Grounding Validation

**Validator checks grounding**:

```python
def validate_grounding(claim: str, provenance: MultimodalProvenance) -> bool:
    """Check if claim is backed by source material."""
    # Extract entities from claim
    entities = extract_entities(claim)
    
    # Check if entities appear in OCR text / vision caption
    if provenance.tool == 'ocr':
        return all(entity in provenance.text for entity in entities)
    elif provenance.tool == 'vision':
        return all(entity in provenance.caption for entity in entities)
    
    return False
```

---

## 6. Performance & Quality

### 6.1 Performance Targets

| Pipeline | Latency Target | Quality Target | Notes |
|----------|---------------|----------------|-------|
| **OCR** | ≤5s per page | ≥90% accuracy | Clean printed text |
| **Vision** | ≤3s per image | ≥80% caption accuracy | Subjective assessment |
| **Embeddings** | ≤100ms retrieval | ≥0.7 relevance | Top-5 results |

### 6.2 Quality Assurance

**OCR Quality Checks**:
- Confidence thresholding (reject if <70%)
- Spell-check post-processing
- Manual spot-checks (10% of documents)

**Vision Quality Checks**:
- Compare captions across multiple models
- Flag low-confidence regions
- User feedback loop

---

## Appendices

### A. Tool Configuration

**YAML Configuration** (`config/tools.yaml`):
```yaml
ocr:
  engine: tesseract
  version: 5.0.3
  language: eng
  confidence_threshold: 0.70
  preprocessing:
    grayscale: true
    noise_reduction: true
    deskew: true

vision:
  model: openai/clip-vit-base-patch32
  caption_max_length: 200
  confidence_threshold: 0.65

embeddings:
  model: sentence-transformers/all-MiniLM-L6-v2
  index_path: /data/vector_store/memory.index
  top_k_default: 5
  relevance_threshold: 0.7
```

**End of Document**

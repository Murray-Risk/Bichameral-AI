## 2026‑02‑14  

### Completed  
- Consolidated the Sovereign AI architecture into the v1.1.0 Comprehensive Analysis Report, including hardware, routing, and validation layers.  
- Formalised the Bicameral architecture and Validator Ladder as the canonical governance model for generation and review.  
- Defined the updated sovereign model stack (Qwen3‑Coder‑Next 80B‑A3B, IBM Granite Code 20B, GPT‑OSS‑20B, Granite validator family, MythoMax in cold storage).  
- Specified RAG integration components (embedding model, vector store, document store) and aligned them with the warm‑pool memory strategy.  

### Changed  
- Replaced Nemotron‑3 Nano 30B with IBM Granite Code 20B as the performance‑oriented implementation model.  
- Demoted MythoMax‑L3‑13B to cold storage with a targeted fine‑tuning plan for tone, Australian style, and referencing systems.  
- Elevated Granite‑4.0‑H‑Small into dual roles: constitutional validator and TDD specialist via separate fine‑tunes.  
- Proposed a 2‑of‑3 lightweight router consensus mechanism for high‑stakes routing decisions.  

### TODO  
1. Benchmark GPT‑OSS‑20B against Qwen3‑Next‑80B‑A3B‑Instruct for general reasoning and planning before locking in the strategist model.
2. Design and implement the router consensus logic, including disagreement handling and escalation paths.
3. Specify the Adversarial Chamber architecture, interfaces, and threat models to move it beyond a conceptual placeholder.
4. Define datasets, pipelines, and evaluation criteria for fine‑tuning Granite validators and MythoMax variants.
5. Integrate the RAG lifecycle with the Markdown Memory Manager and `project_state.md` so retrieved context becomes first‑class, auditable state.

---

## 2026‑02‑10

### Completed
- Debugged and tested the Router using Codex 5.2.
- All tests pass and outputs are correct.

### TODO
1. Add a reasoning string to the output  
   The Router’s decisions are correct but not yet explainable. You’ll need explicit reasoning for the audit trail.

2. Add a confidence score  
   Even a simple heuristic (e.g., keyword‑match ratio) will help trigger fallback paths.

3. Add tool inference from attachments  
   Once integrated with the Orchestrator, tools should be inferred from file types, not only keywords.

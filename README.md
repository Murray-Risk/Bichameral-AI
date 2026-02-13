# **Bicameral‑AI: Sovereign AI Infrastructure for High‑Assurance Local Reasoning**

Bicameral‑AI is a sovereign, locally‑hosted AI orchestration system engineered to deliver **high‑assurance reasoning on constrained hardware**. It implements a *bicameral cognitive architecture*:
- **GPU Generative Chamber** for creative and synthetic work
- **CPU Logical Chamber** for routing, validation, and constitutional governance

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

## **What Bicameral‑AI Is Not**

Bicameral‑AI is intentionally narrow in scope. It is not:
- an agent framework. There are no autonomous loops, no self‑initiated actions, and no hidden state. All cognition is governed, explicit, and test‑driven.
- a chatbot wrapper. Bicameral‑AI is a constitutional reasoning system, not a conversational interface.
- a cloud‑dependent orchestration layer. All inference, routing, validation, and memory occur locally. No external APIs, telemetry, or remote dependencies.
- a speed‑optimised system. Latency is traded for correctness. Bicameral‑AI prioritises reliability, determinism, and auditability over throughput.
- a frontier‑model playground. The architecture is designed for small, open‑weight models running on constrained hardware — not for chasing state‑of‑the‑art benchmarks.

---

## **The Philosophy: Accuracy Over Latency**

Historically, correctness mattered more than speed — programs ran overnight, or for days, to ensure reliability. Bicameral‑AI returns to that mindset.

The GPU chamber generates.
The CPU chamber governs.
The system iterates until the output is *correct*, not merely plausible.

This architecture enables smaller models to outperform their size class through structured refinement, validator feedback, and symbolic routing.

---

## **Design Principles**

Bicameral‑AI is built on a set of architectural principles that guide every component of the system:
### **1. Sovereignty First**
All computation, memory, and governance remain local. No cloud dependencies, no external inference, no data exposure.
### **2. Accuracy Over Latency**
Time is treated as a resource. The system iterates until outputs satisfy constitutional tests, even if this requires multiple refinement cycles.
### **3. Deterministic Governance**
Routing, validation, and policy enforcement are handled by symbolic logic (Prolog), ensuring predictable, auditable behaviour.
### **4. Transparent Memory**
All state is stored as human‑readable Markdown. No vector stores, no embeddings, no opaque drift.
### **5. Small Models, Large Systems**
Capability emerges from orchestration, not parameter count. The architecture enables small models to behave like larger ones through structured refinement.
### **6. Test‑Driven Cognition**
Every task begins with a test harness. Tests define the contract, invariants, and acceptable behaviour before generation begins.
### **7. Separation of Powers**
The GPU generates.
The CPU governs.
The constitution constrains.
This bicameral structure prevents collapse into uncontrolled generative behaviour.
### **8. Auditability as a Feature**
Every decision, refinement, and failure is logged. The system is designed to be inspected, traced, and verified.

These principles make the architecture legible, durable, and resistant to drift — the opposite of the “fast‑and‑loose” agent ecosystems dominating the current landscape.

---

## **Risk Management**

Bicameral‑AI is governed by a formal, lifecycle‑wide risk management framework aligned with ISO 31000:2018 and the project’s Risk Management Roadmap v2.0.0. The system treats risk as a constitutional concern: explicit, auditable, and continuously governed.
Risk governance spans all phases of the project:

**- Foundation (Phase 0)** — Establishes the risk approach and initial register, defining appetite, categories, and assessment methodology.
**- Design (Phase 1)** — Technical and security risk assessments identify architectural, integration, and threat‑model risks before implementation begins.
**- Implementation (Phase 2)** — A continuously updated Risk Monitoring Log tracks mitigation progress, new risks, and triggered events.
**- Operations (Phase 3)** — An Operational Risk Register governs availability, capacity, incident response, and business continuity risks.
**- Post‑Implementation (Phase 4)** — A formal review evaluates which risks materialised and strengthens future governance.
**- Continuous Oversight (Phase 5)** — Quarterly risk reports, incident analyses, vendor assessments, and compliance reviews maintain long‑term visibility.

Risk controls are embedded directly into the architecture: deterministic routing, constitutional constraints, test‑driven cognition, transparent memory, and iterative refinement all function as systemic safeguards. Every risk has an owner, a mitigation strategy, and a traceable audit trail in the Markdown Memory Ledger, ensuring that sovereignty extends not only to computation but to governance itself.

---

## **The Ralph‑Prolog‑TDD Triad**

Bicameral‑AI is governed by a three‑part constitutional mechanism:
### **The Constitution (Prolog)**
A symbolic logic engine that determines domain, stakes, model selection, and required validation. It is the system’s law.
### **The Invariant (TDD)**
Every task begins with a Test‑Driven Development harness. Tests encode the contract, invariants, and expected behaviour.
### **The Enforcer (Ralph)**
A naive persistence loop — a BASH primitive that runs tests repeatedly. If they fail, the system refines the output until they pass.

Together, these components transform generative models into a **governed software‑construction engine**.

---

## **Technical Stack**

### **Model Zoo (Orchestrated via Prolog)**
* **Qwen3-coder-next:q4_K_M** — Primary Worker for architecture and complex implementation
* **IBM Granite‑4.0** — Line‑by‑line Validator and constitutional enforcer. It is my intention to fine tune this model.
* **GPT‑OSS‑20B** — General reasoning and planning
* **Granite‑4.0‑H‑Small** — Fine‑tuned TDD specialist for structured module development, automated test drafting, and governed Red → Green → Refactor workflows
* **granite-20b-code-instruct-8k-GGUF** — Performance‑oriented implementation and ops tasks
* **MythoMax‑L2‑13B** — Creative and narrative generation. It is my intention to fine tune MythoMax to reflect my tone and style, the Australian Government Style Manual, Australian spelling and grammar, and various academic referencing standards i.e. Harvard, Chicago, AGLC, APA, etc.
* **Granite‑3.0‑8B‑Instruct** — Efficiency specialist for low‑stakes tasks

### **Infrastructure & Governance**
* **Inference Engine** — llama.cpp (GGUF quantization for 16GB VRAM envelopes)
* **Governance Spine** — SWI‑Prolog (deterministic routing and policy enforcement)
* **Orchestration Layer** — Python 3.11
* **Memory System** — Markdown Memory Ledger (transparent, durable, human‑readable audit trail)

---

## **System Requirements**

Bicameral‑AI is designed to run on a single‑GPU workstation with a large RAM warm‑pool:

* **OS:** Fedora 42 Workstation
* **CPU:** Intel Xeon W‑2135
* **RAM:** 128GB ECC (warm‑pool for model swapping)
* **GPU (Compute):** Nvidia Tesla A2 (16GB VRAM)
* **GPU (Display):** Nvidia GT710
* **Storage:** Samsung 990 EVO Plus 1TB NVMe
* **Motherboard:** Supermicro X11SRA
* **Chassis/Power:** Antec P20CE / MSI MAG A750GL

This configuration demonstrates that **high‑assurance AI does not require frontier‑scale compute**.

---

## **Project Status**

**Current Phase:** Router Validation & Testing

The repository currently includes:
* Phase 0 - Foundation and Planning documents:
  - Technical Analysis Report
  - Comprehensive Architecture Report
  - Product Requirements Document
  - Initial Risk Register
  - Risk Management Plan
  - Project Roadmap
* Phase 1 - Design and Specification documents:
  - System Architecture Document
  - Data Architecture and Memory Design Document
  - API Specification Document
  - Security and Governance Design
  - Testing Strategy and Test Plan
  - Domain Logic Specification
  - Security Risk Assessment
  - Technical Risk Assessment
  - Routing Logic Specification
  - Model Serving Orchestration
  - Domain and Taxonomy
  - Routing Policies
  - Router Specifications
* Phase 2 - Implementation Documents
  - Multimodal Pipeline Design
* CHANGELOG
* Code:
  - router_service.py   # Python wrapper that loads and executes the Prolog router
  - routing_rules.pl    # Prolog routing logic and domain rules
  - test_router.py      # Unit tests for the routing layer

---

**Status (2026‑02‑10):** Completed. Debugged and tested the Router using Codex 5.2. All tests pass and outputs are correct.

**Next milestone:** Reasoning & Inference Enhancements
* **Add a reasoning string to the output** — The Router’s decisions are correct but not yet explainable. Explicit reasoning is required for the audit trail.
* **Add a confidence score** — A simple heuristic (e.g., keyword‑match ratio) to help trigger fallback paths.
* **Add tool inference from attachments** — Integration with the Orchestrator to infer tools from file types, not only keywords.

---

### **Repository Structure**
```
├── docs/ # Formal specifications and PRDs
├── router/ # Prolog Constitution (The Law)
├── orchestrator/ # Python bridge and llama.cpp management
├── models/ # Model-specific prompt wrappers
└── ledger/ # Markdown-based audit trails
```

---

## **License**

MIT License — see `LICENSE` for details.

**Author:** William Murray

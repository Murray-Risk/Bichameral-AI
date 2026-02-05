#Bicameral-AI: Sovereign Infrastructure & The Ralph Protocol#

_Bicameral-AI_ is intended to be a high-accuracy, locally-hosted AI orchestration engine designed to deliver performance approaching frontier-model levels on a budget-conscious, consumer-grade workstation.
I am building this project to solve two primary problems:
1.	_Data Sovereignty_: Ensuring 100% privacy by running entirely air-gapped with no external API dependencies.
2.	_Economic Feasibility_: Proving that "diabolical" frontier-system costs can be bypassed by trading latency for accuracy on local hardware.

##The Philosophy: Accuracy Over Latency##

In this system, I treat time as a resource to be traded for correctness. By utilizing a "Bicameral" architecture - splitting the system into a Generative GPU Chamber and a Logical CPU Chamber - I can force smaller models to behave like much larger ones through iterative refinement.

##The Ralph-Prolog-TDD Triad##

The core of my methodology is a three-way interaction:

•	_The Constitution (Prolog)_: A symbolic logic engine that acts as the system's "Law." It determines model selection and validation requirements.

•	_The Invariant (TDD)_: Every task begins with the generation of a Test-Driven Development (TDD) harness.

•	_The Enforcer (Ralph)_: Named as a nod to the "Ralph Wiggum" primitive (a BASH loop that runs until a test passes). Ralph is the mechanism of naive persistence – it forces the system to refine its output until the TDD invariants are met.
________________________________________

##Technical Stack##

The system is engineered to maximize performance on constrained hardware by utilizing a Bicameral Architecture, separating generative tasks (GPU) from logical governance (CPU).

###The Model Zoo (Orchestrated via Prolog)###

The system utilizes a specialized ensemble of models, each selected by the Prolog Router based on the task domain and required "stakes":

• _Primary Worker (Code/Reasoning)_: Qwen2.5-Coder-32B — The heavy-lifter for architectural design and complex implementation.

• _The Critic (Validation)_: IBM Granite-3.0/4.0 — Specialized for line-by-line verification and ensuring adherence to the "Constitution."

• _General Reasoning_: GPT-OSS-8B/20B — Used for high-level planning and internal system reasoning.

• _Performance/Ops_: Nemotron-3-8B — Optimized for system operations and performance-critical tasks.

• _Creative/Narrative_: MythoMax-L2-13B — Deployed for creative content generation and brand-safe narrative tasks.

• _Efficiency Specialist_: Granite-3.0-8B-Instruct — Used for low-stakes, high-speed processing to preserve resources.

###Infrastructure & Governance###

• _Inference Engine_: llama.cpp — Leverages GGUF quantization to fit the Model Zoo within a 16GB VRAM envelope.

• _Governance Spine_: SWI-Prolog — A deterministic, symbolic "Constitution" for domain routing and policy enforcement.

• _Orchestration Layer: Python 3.11 — The bridge between symbolic logic and neural inference.

• _Memory System_: Markdown Memory Ledger — A durable, human-readable audit trail recording every Prolog decision, Ralph loop iteration, and validator verdict.
________________________________________
 
##Hardware Constraints## 

I’m designing this software specifically to maximize the following hardware configuration. This project is intended to serve as a benchmark for what is possible on a high-memory, low-VRAM workstation:

•	_OS_: Fedora 42 Workstation

•	_CPU_: Intel Xeon W-2135 (LGA2066)

•	_RAM_: 128GB DDR4-2133 ECC (8x 16GB) – Enables a "Warm Pool" for model swapping.

•	_GPU 1 (Compute)_: Nvidia Tesla A2 (16GB VRAM)

•	_GPU 2 (Display)_: Nvidia GT710 (2GB)

•	_Storage_: Samsung 990 EVO PLUS 1TB NVMe (PCIe 4.0/5.0)

•	_Motherboard_: Supermicro X11SRA

•	_Chassis/Power_: Antec P20CE / MSI MAG A750GL (750W)
________________________________________

##Project Status##

_Current Phase_: Documentation & Architectural Specification.
This repository currently contains the formal specifications, Prolog routing schemas, and architectural designs for the Bicameral-AI system. I am currently moving toward the initial implementation of the Python-Prolog bridge.

_Planned Structure_
```
├── docs/               # Formal specifications and PRDs
├── router/             # Prolog Constitution (The Law)
├── orchestrator/       # Python bridge and llama.cpp management
├── models/             # Model-specific prompt wrappers (Qwen/Granite)
└── ledger/             # Markdown-based audit trails
```
________________________________________
 
##The Ralph Loop (Conceptual)##

The system doesn't just "guess" an answer. It iterates:
1.	Prolog decides the stakes and selects the model.
2.	Qwen generates a TDD test and an initial solution.
3.	Ralph runs the test.
4.	If it fails, Granite analyses the error, and the loop repeats until the test passes.
________________________________________

_License_: This project is licensed under the MIT License – see the Licence file for details. 

_Author_: William Murray 


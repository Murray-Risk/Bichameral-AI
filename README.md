#Bicameral-AI: Sovereign Infrastructure & The Ralph Protocol

_Bicameral-AI_ is intended to be a high-accuracy, locally-hosted AI orchestration engine designed to deliver performance approaching frontier-model levels on a budget-conscious, consumer-grade workstation.
I am building this project to solve two primary problems:
1.	_Data Sovereignty_: Ensuring 100% privacy by running entirely air-gapped with no external API dependencies.
2.	_Economic Feasibility_: Proving that "diabolical" frontier-system costs can be bypassed by trading latency for accuracy on local hardware.

##The Philosophy: Accuracy Over Latency

In this system, I treat time as a resource to be traded for correctness. By utilizing a "Bicameral" architecture—splitting the system into a Generative GPU Chamber and a Logical CPU Chamber—I can force smaller models to behave like much larger ones through iterative refinement.

##The Ralph-Prolog-TDD Triad

The core of my methodology is a three-way interaction:
•	_The Constitution (Prolog)_: A symbolic logic engine that acts as the system's "Law." It determines model selection and validation requirements.
•	_The Invariant (TDD)_: Every task begins with the generation of a Test-Driven Development (TDD) harness.
•	_The Enforcer (Ralph)_: Named as a nod to the "Ralph Wiggum" primitive (a BASH loop that runs until a test passes). Ralph is the mechanism of naive persistence – it forces the system to refine its output until the TDD invariants are met.
________________________________________

##Technical Stack
•	_Inference Engine_: llama.cpp (Optimized for GGUF quantization to fit 32B models into 16GB VRAM).
•	_Governance_: SWI-Prolog (Deterministic routing and policy enforcement).
•	_Orchestration_: Python 3.11.
•	_Primary Worker_: Qwen-Coder-32B (For complex reasoning and implementation).
•	_The Critic_: IBM Granite-4.0 (Specialized for validation and verification).
•	_Memory_: Markdown-based "Memory Ledger" for durable, human-readable audit trails.
________________________________________
 
##Hardware Constraints 

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

##Project Status

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
 
##The Ralph Loop (Conceptual)

The system doesn't just "guess" an answer. It iterates:
1.	Prolog decides the stakes and selects the model.
2.	Qwen generates a TDD test and an initial solution.
3.	Ralph runs the test.
4.	If it fails, Granite analyses the error, and the loop repeats until the test passes.
________________________________________

_License_: This project is licensed under the MIT License – see the Licence file for details. 

_Author_: William Murray 


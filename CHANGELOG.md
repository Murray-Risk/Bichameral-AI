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

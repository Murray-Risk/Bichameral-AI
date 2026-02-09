import os
from pyswip import Prolog

class RouterService:
    def __init__(self, rules_file="routing_rules.pl"):
        self.prolog = Prolog()
        
        # Ensure the file path is absolute to avoid pyswip loading errors
        abs_path = os.path.abspath(rules_file)
        # Fix for Windows paths in Prolog (swaps \ to /)
        clean_path = abs_path.replace("\\", "/")
        
        try:
            self.prolog.consult(clean_path)
        except Exception as e:
            print(f"Error loading Prolog rules: {e}")
            raise

    def _tokenize(self, text):
        """Simple tokenizer: lowercase and strip punctuation."""
        # Remove common punctuation
        clean_text = text.lower().replace(".", "").replace(",", "").replace("?", "")
        return clean_text.split()

    def route_request(self, user_input):
        """
        Main entry point.
        1. Tokenize input
        2. Query Prolog
        3. Format result
        """
        tokens = self._tokenize(user_input)
        
        # Convert Python list to Prolog list string: ['word1', 'word2']
        prolog_list_str = "[" + ",".join([f"'{t}'" for t in tokens]) + "]"
        
        query = f"route({prolog_list_str}, Decision)"
        
        try:
            # Run the query (returns a generator)
            results = list(self.prolog.query(query))
            
            if not results:
                return self._fallback_response("No routing decision found")
            
            # Extract the 'Decision' variable from the first result
            decision_data = results[0]['Decision']
            
            # Convert Prolog output to clean Python Dict
            return {
                "domain": str(decision_data['domain']),
                "stakes": str(decision_data['stakes']),
                "model": str(decision_data['model']),
                "validation_policy": str(decision_data['validation']),
                "tools_required": [str(t) for t in decision_data['tools']],
                "complexity_score": int(decision_data['score'])
            }
            
        except Exception as e:
            print(f"Routing Error: {e}")
            return self._fallback_response(str(e))

    def _fallback_response(self, reason):
        return {
            "domain": "unknown",
            "stakes": "medium",
            "model": "gpt_oss_20b",
            "validation_policy": "end_stage",
            "tools_required": ["embeddings"],
            "error": reason
        }

# --- Quick Test Block ---
if __name__ == "__main__":
    router = RouterService()
    
    test_inputs = [
        "Refactor the payment architecture for microservices.",
        "Write a creative story about a robot.",
        "Scan this pdf and find similar documents."
    ]
    
    for txt in test_inputs:
        print(f"\nInput: {txt}")
        print(f"Result: {router.route_request(txt)}")

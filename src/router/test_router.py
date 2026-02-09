import unittest
from router_service import RouterService

class TestRouterLogic(unittest.TestCase):
    
    @classmethod
    def setUpClass(cls):
        # Initialize the router once
        cls.router = RouterService("routing_rules.pl")

    def test_high_stakes_architecture(self):
        """Test: Coding Architecture should trigger High Stakes & Qwen Coder"""
        prompt = "Refactor the system architecture to use dependency injection."
        result = self.router.route_request(prompt)
        
        self.assertEqual(result['domain'], 'coding_architecture')
        self.assertEqual(result['stakes'], 'high') # Policy: Arch is always high
        self.assertEqual(result['model'], 'qwen_coder_32b')
        self.assertEqual(result['validation_policy'], 'block_by_block')

    def test_low_stakes_creative(self):
        """Test: Creative writing should be Low Stakes & MythoMax"""
        prompt = "Write a creative poem about the sun."
        result = self.router.route_request(prompt)
        
        self.assertEqual(result['domain'], 'creative')
        self.assertEqual(result['stakes'], 'low')
        self.assertEqual(result['model'], 'mythomax_13b')
        self.assertEqual(result['validation_policy'], 'none')

    def test_implementation_optimization(self):
        """Test: Implementation with optimization keywords"""
        prompt = "Optimize this python function loop for better performance."
        result = self.router.route_request(prompt)
        
        self.assertEqual(result['domain'], 'coding_implementation')
        # 'optimize' (2) + 'function' (0) = Score 2 -> Medium Stakes
        self.assertEqual(result['stakes'], 'medium') 
        # Nemotron is best for implementation
        self.assertEqual(result['model'], 'nemotron_30b') 

    def test_tool_detection(self):
        """Test: Multimodal tool triggers"""
        prompt = "Scan this pdf image and find similar files."
        result = self.router.route_request(prompt)
        
        self.assertIn('ocr', result['tools_required']) # 'scan', 'pdf'
        self.assertIn('vision', result['tools_required']) # 'image'
        self.assertIn('embeddings', result['tools_required']) # 'find', 'similar'

    def test_unknown_fallback(self):
        """Test: Nonsense input should default to unknown"""
        prompt = "Banana burger sky blue."
        result = self.router.route_request(prompt)
        
        self.assertEqual(result['domain'], 'unknown')
        self.assertEqual(result['model'], 'gpt_oss_20b') # Default fallback

if __name__ == '__main__':
    unittest.main()

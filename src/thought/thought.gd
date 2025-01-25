extends Node

class Combination:
	var firstThought: Thought
	var secondThought: Thought
	
	func _init(first: Thought, second: Thought):
		firstThought = first;
		secondThought = second;
	
	func isEqualToThoughts(first: Thought, second: Thought):
		return (firstThought == first and secondThought == second) or \
		(firstThought == second and secondThought == first)

class Thought:
	var unicodeSymbol: String
	
	var optimismEffect: int
	var o2Effect: int
	var foodEffect: int
	var materialEffect: int
	
	var combinations: Array[Combination] = []
	
	func _init(symbol: String, optimism: int, o2: int, food: int, material: int):
		unicodeSymbol = symbol;
		optimismEffect = optimism;
		o2Effect = o2;
		foodEffect = food;
		materialEffect = material;
	
	func applyEffect():
		GameState.currentOptimism += optimismEffect;
		GameState.currentO2 += o2Effect;
		GameState.currentFood += foodEffect;
		GameState.currentMaterial += materialEffect;
	
	func addCombination(first: Thought, second: Thought) -> Thought:
		self.combinations.append(Combination.new(first, second))
		return self;

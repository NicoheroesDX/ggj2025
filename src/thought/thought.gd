extends Node

class_name Thought

var unicodeSymbol: String

var displayName: String = ""
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

func addCombination(first: String, second: String) -> Thought:
	var firstThought = GameState.allThoughtsDictionary[first];
	var secondThought = GameState.allThoughtsDictionary[second];
	
	if (firstThought == null):
		print("ERROR: Unknown thought: " + first)
		return null;
	if (secondThought == null):
		print("ERROR: Unknown thought: " + second)
		return null;
	
	self.combinations.append(Combination.new(firstThought, secondThought))
	return self;

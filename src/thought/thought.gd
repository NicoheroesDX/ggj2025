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
	GameState.applyThoughtEffect(optimismEffect, o2Effect, foodEffect, materialEffect)

func addCombination(first: String, second: String) -> Thought:
	var firstThought = GameState.allThoughtsDictionary[first];
	var secondThought = GameState.allThoughtsDictionary[second];
	
	if (firstThought == null):
		GameState.printToLog("Something unspeakable happened. Thought " + first + " does not exist. Please report to the developers.", false)
		print("ERROR: Unknown thought: " + first)
		return null;
	if (secondThought == null):
		GameState.printToLog("Something unspeakable happened. Thought " + second + " does not exist. Please report to the developers.", false)
		print("ERROR: Unknown thought: " + second)
		return null;
	
	self.combinations.append(Combination.new(firstThought, secondThought))
	return self;

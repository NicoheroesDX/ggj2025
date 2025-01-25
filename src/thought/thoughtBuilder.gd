extends Node

const ThoughtClass = preload("res://src/thought/thought.gd");

class ThoughtBuilder:
	
	func fillArrayOfAllThoughts() -> void:
		define("OPTIMISM", ThoughtClass.new("U+1F308", +1, 0, 0, 0));
		
		define("O2", ThoughtClass.new("U+1F32C", 0, +1, 0, 0));
		
		define("FOOD", ThoughtClass.new("U+1F35E", 0, 0, +1, 0));
		
		define("MATERIAL", ThoughtClass.new("U+1FAA8", 0, 0, 0, +1));
		
		define("AIR", ThoughtClass.new("U+2601", +2, +2, 0, 0)) \
		.setCombination(OPTIMISM, O2);
		
		define("TREE", ThoughtClass.new("U+1F333", 0, 0, +2, +2)) \
		.setCombination(FOOD, MATERIAL);
	
	func combineTwo(first: ThoughtClass, second: ThoughtClass) -> ThoughtClass:
		for name in GameState.allThoughtsDictionary.keys():
			const thought = GameState.allThoughtsDictionary[name]
			for combination in thought.combinations:
				if combination.isEqualToThoughts(first, second):
					return thought;

func define(name: String, value: ThoughtClass) -> ThoughtClass:
	GameState.allThoughtsDictionary[name] = value;
	return GameState.allThoughtsDictionary[name];

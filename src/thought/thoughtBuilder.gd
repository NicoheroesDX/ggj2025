extends Node

class_name ThoughtBuilder
	
func fillArrayOfAllThoughts() -> void:
	define("OPTIMISM", Thought.new("U+1F308", +1, 0, 0, 0));
	
	define("O2", Thought.new("U+1F32C", 0, +1, 0, 0));
	
	define("FOOD", Thought.new("U+1F35E", 0, 0, +1, 0));
	
	define("MATERIAL", Thought.new("U+1FAA8", 0, 0, 0, +1));
	
	define("AIR", Thought.new("U+2601", +2, +2, 0, 0)) \
	.addCombination("OPTIMISM", "O2");
	
	define("TREE", Thought.new("U+1F333", 0, 0, +2, +2)) \
	.addCombination("FOOD", "MATERIAL");

func combineTwo(first: Thought, second: Thought) -> Thought:
	for name in GameState.allThoughtsDictionary.keys():
		var thought = GameState.allThoughtsDictionary[name]
		for combination in thought.combinations:
			if combination.isEqualToThoughts(first, second):
				return thought;
	
	return null

func define(name: String, value: Thought) -> Thought:
	GameState.allThoughtsDictionary[name] = value;
	return GameState.allThoughtsDictionary[name];

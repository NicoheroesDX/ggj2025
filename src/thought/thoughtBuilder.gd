extends Node

class_name ThoughtBuilder
	
func fillArrayOfAllThoughts() -> void:
	define("Optimism", Thought.new("🌈", +1, 0, 0, 0));
	
	define("O2", Thought.new("🌬️", 0, +1, 0, 0));
	
	define("Food", Thought.new("🍞", 0, 0, +1, 0));
	
	define("Material", Thought.new("🪨", 0, 0, 0, +1));
	
	define("Air", Thought.new("🌪️", +2, +2, 0, 0)) \
	.addCombination("Optimism", "O2");
	
	define("Tree", Thought.new("🌳", 0, 0, +2, +2)) \
	.addCombination("Food", "Material");

func combineTwo(first: Thought, second: Thought) -> Thought:
	for name in GameState.allThoughtsDictionary.keys():
		var thought = GameState.allThoughtsDictionary[name]
		for combination in thought.combinations:
			if combination.isEqualToThoughts(first, second):
				return thought;
	
	return null

func define(name: String, value: Thought) -> Thought:
	value.displayName = name;
	GameState.allThoughtsDictionary[name] = value;
	return GameState.allThoughtsDictionary[name];

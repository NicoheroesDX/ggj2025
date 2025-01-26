extends Node

class_name ThoughtBuilder
	
func fillArrayOfAllThoughts() -> void:
	define("OPTIMISM", Thought.new("🌈", +1, 0, 0, 0));
	
	define("O2", Thought.new("🌬️", 0, +1, 0, 0));
	
	define("FOOD", Thought.new("🍞", 0, 0, +1, 0));
	
	define("MATERIAL", Thought.new("🪨", 0, 0, 0, +1));
	
	define("AIR", Thought.new("🌪️", +2, +2, 0, 0)) \
		.addCombination("OPTIMISM", "O2");
	
	define("TREE", Thought.new("🌳", 0, 0, 0, +10)) \
		.addCombination("FOOD", "MATERIAL");
		
	define("BLISS", Thought.new("🍭", 20, 0, -5, 0)) \
		.addCombination("FOOD", "OPTIMISM");
		
	define("SCIENCE", Thought.new("🧬", 5, 5, 0, 5)) \
		.addCombination("MATERIAL", "OPTIMISM");
		
	define("PLANTING", Thought.new("🌱", 5,5,5,0)) \
		.addCombination("TREE", "OPTIMISM");
		
	define("FRUIT", Thought.new("🍒", 5,0,5,0)) \
		.addCombination("PLANTING", "FOOD");
		
	define("GARDEN", Thought.new("🪴", 5,10,0,0)) \
		.addCombination("PLANTING", "OPTIMISM");
		
	define("HABITAT", Thought.new("🪹", 5,0,0,5)) \
		.addCombination("PLANTING", "OPTIMISM");
		
	define("STRUCTURE", Thought.new("🧱",5,0,0,10)) \
		.addCombination("MATERIAL", "MATERIAL");
		
	define("WEAVE", Thought.new("🧶", 0,0,0,10)) \
		.addCombination("O2", "MATERIAL");
		
	define("YEAST", Thought.new("🦠", 0,0,10,0)) \
		.addCombination("SCIENCE", "FOOD");
		
	define("FILTER", Thought.new("🕸️",0,10,0,5)) \
		.addCombination("O2", "WEAVE");
		
	define("WONDER", Thought.new("🌌", 15,-10,0,0)) \
		.addCombination("SCIENCE", "OPTIMISM");
		
	define("FARMING", Thought.new("🌾", 0,0,10,0)) \
		.addCombination("PLANTING", "FOOD");

	define("SHELTER", Thought.new("⛺", 10,5,-5,-5)) \
		.addCombination("FILTER", "HABITAT");
		
	define("SICKNESS", Thought.new("🤢 ",-10,-5,0,0))  \
		.addCombination("YEAST", "FOOD");
		
	define("CARE", Thought.new("🤒",+15,0,0,0))  \
		.addCombination("SICKNESS", "OPTIMISM");
		
	define("FIRE", Thought.new("🔥",0,0,-5,0))  \
		.addCombination("MATERIAL","SCIENCE");
		
	define("RESEARCH", Thought.new("🔬",10,5,5,5))  \
		.addCombination("SICKNESS","SCIENCE");
		
	define("LOVE", Thought.new("💕",+20,-5,-5,0))  \
		.addCombination("CARE","OPTIMISM");
		
	define("DEATHLY_ILL", Thought.new("🤮",-20,-5,-5,0))  \
		.addCombination("SICKNESS","SICKNESS")
		
	define("BOREDOM", Thought.new("☁", -5, 0, 0, 0)) \
		.addCombination("AIR", "AIR");
	
	define("PLAYFULNESS", Thought.new("🛝", +10, 0, 0, -5)) \
		.addCombination("BOREDOM", "BOREDOM");
		
	define("HATE", Thought.new("💔", -10, -5, -5, -5)) \
		.addCombination("BOREDOM", "BOREDOM");
		
	define("OPPOSITION", Thought.new("💢", 0, +5, 0, 0)) \
		.addCombination("HATE", "LOVE");
		
	define("BALANCE", Thought.new("☯️", 0, 0, 0, 0)) \
		.addCombination("STRUCTURE", "OPPOSITION");
		
	define("MISCHIEF", Thought.new("😈", 0, +5, -5, 0)) \
		.addCombination("PLAYFULNESS", "OPPOSITION");
		

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

extends Node

class_name Combination
	
var firstThought: Thought
var secondThought: Thought

func _init(first: Thought, second: Thought):
	firstThought = first;
	secondThought = second;

func isEqualToThoughts(first: Thought, second: Thought):
	return (firstThought == first and secondThought == second) or \
	(firstThought == second and secondThought == first)

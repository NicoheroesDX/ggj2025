extends Node

const Thought = preload("res://src/thought/thought.gd");

enum Idea { RAINBOW, AIR, BREAD, ROCK, XXX, YYY, ZZZ }

var maxAmountOfIdeas = 20
var ideaPool: Array[Idea] = [Idea.RAINBOW, Idea.AIR, Idea.BREAD, Idea.ROCK];

var currentOptimism = 0
var currentO2 = 0
var currentFood = 0
var currentMaterial = 0

var allThoughtsDictionary: Dictionary = {};

func _init():
	const thoughtBuilder = ThoughtBuilder.new();
	thoughtBuilder.createAllThoughts();

func addToAllThoughts(newThought: Thought):
	

func addNewIdea(newIdea: Idea):
	if not newIdea in ideaPool:
		ideaPool.append(newIdea);
		UIManager.updatePoolItem.emit(ideaPool.size() - 1)

func getIdeaFromPool(index: int):
	if index < ideaPool.size() and (ideaPool[index] != null):
		return ideaPool[index];
	else:
		return null;

func testPool1():
	addNewIdea(Idea.XXX);

func testPool2():
	addNewIdea(Idea.YYY);

func testPool3():
	addNewIdea(Idea.ZZZ);

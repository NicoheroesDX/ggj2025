extends Node

signal theyDEAD(char: CharacterBody2D)

var slotsInPool = 0;
var thoughtPool: Array[Thought] = [];
var baseThoughtNames: Array[String] = ["OPTIMISM", "O2", "FOOD", "MATERIAL"];

var currentRound: int = 0

var currentOptimism = 0
var currentO2 = 0
var currentFood = 0
var currentMaterial = 0

var allThoughtsDictionary: Dictionary = {};

# signal sending
signal combinationEventHappend(newThought: Thought, isNewToPool : bool)

func _ready():
	var thoughtBuilder = ThoughtBuilder.new();
	thoughtBuilder.fillArrayOfAllThoughts();
	slotsInPool = allThoughtsDictionary.keys().size();
	GameState.combinationEventHappend.connect(onCombinationEvent);
	addDefaultThoughtsToPool()

func addDefaultThoughtsToPool():
	for name in baseThoughtNames:
		thoughtPool.append(GameState.allThoughtsDictionary[name])

func addNewThought(newThought: Thought):
	thoughtPool.append(newThought);
	UIManager.updatePoolItem.emit(thoughtPool.size() - 1)

func getThoughtFromPool(index: int):
	if index < thoughtPool.size() and (thoughtPool[index] != null):
		return thoughtPool[index];
	else:
		return null;

# ui event
func onCombinationEvent(newThought: Thought, isNewToPool : bool):
	if isNewToPool:
		addNewThought(newThought);

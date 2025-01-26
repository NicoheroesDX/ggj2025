extends Node

var hackerModeActivated = false

signal heDEAD(char: CharacterBody2D)

signal theyDEAD(char: CharacterBody2D)

var maxAmountOfIdeas = 4
var currentRound: int = 0

@onready var overlay : StatBars = $Overlay

signal theyDEAD(char: CharacterBody2D)

signal updateStats(optimism: int, o2: int, food: int, material: int)

var slotsInPool = 0;

var thoughtPool: Array[Thought] = [];
var baseThoughtNames: Array[String] = ["OPTIMISM", "O2", "FOOD", "MATERIAL"];

var currentOptimism = 0
var currentO2 = 0
var currentFood = 0
var currentMaterial = 0

var allThoughtsDictionary: Dictionary = {};

signal combinationEventHappend(newThought: Thought, isNewToPool : bool)

func _ready():
	var thoughtBuilder = ThoughtBuilder.new();
	thoughtBuilder.fillArrayOfAllThoughts();
	slotsInPool = allThoughtsDictionary.keys().size();
	GameState.combinationEventHappend.connect(onCombinationEvent);
	addDefaultThoughtsToPool()

func addDefaultThoughtsToPool():
	if (hackerModeActivated):
		for name in allThoughtsDictionary.keys():
			thoughtPool.append(GameState.allThoughtsDictionary[name])
	else:
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
		
func applyThoughtEffect(optimism: int, o2: int, food: int, material: int):
	currentOptimism += optimism
	currentO2 += o2
	currentFood += food
	currentMaterial += material
	keepWithinLimits()
	updateStats.emit(currentOptimism, currentO2, currentFood, currentMaterial)
	#overlay.setStats(currentOptimism, currentO2, currentFood, currentMaterial)
	
func keepWithinLimits():
	for stat in [currentOptimism, currentO2, currentFood, currentMaterial]:
		if stat < 0:
			stat = 0;
		elif stat > 100:
			stat = 100

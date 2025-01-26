extends Node

var hackerModeActivated = false

signal theyDEAD(char: CharacterBody2D)

signal updateStats(optimism: int, o2: int, food: int, material: int)
signal statDifference(optimism: int, o2: int, food: int, material: int)

var slotsInPool = 0;
var thoughtPool: Array[Thought] = [];
var baseThoughtNames: Array[String] = ["OPTIMISM", "O2", "FOOD", "MATERIAL"];

var currentRound: int = 0

var currentOptimism = 20
var currentO2 = 20
var currentFood = 20
var currentMaterial = 20

var currentAstronauts: int = 0

var allThoughtsDictionary: Dictionary = {};

signal newRound

signal combinationEventHappend(newThought: Thought, isNewToPool : bool)

func _ready():
	var thoughtBuilder = ThoughtBuilder.new();
	thoughtBuilder.fillArrayOfAllThoughts();
	slotsInPool = allThoughtsDictionary.keys().size();
	GameState.combinationEventHappend.connect(onCombinationEvent);
	addDefaultThoughtsToPool()
	updateStats.emit(currentOptimism, currentO2, currentFood, currentMaterial)

func _process(delta: float):
	if Input.is_action_just_pressed("debug_2"):
		print(currentRound)

func nextRound():
	var o2DecayPerRound = int(0.05 * numberOfAstronauts) + 1
	var foodDecayPerRound = int(0.2 * numberOfAstronauts) + 1
	
	applyThoughtEffect(0, -o2DecayPerRound, -foodDecayPerRound, 0)
	
	currentRound += 1;
	newRound.emit();

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
		addNewThought(newThought)
	

		
func applyThoughtEffect(optimism: int, o2: int, food: int, material: int):
	GameState.statDifference.emit(optimism, o2, food, material);
	currentOptimism += optimism
	currentO2 += o2
	currentFood += food
	currentMaterial += material
	keepWithinLimits()
	updateStats.emit(currentOptimism, currentO2, currentFood, currentMaterial)
	
func keepWithinLimits():
	for stat in [currentOptimism, currentO2, currentFood, currentMaterial]:
		if stat < 0:
			stat = 0;
		elif stat > 100:
			stat = 100

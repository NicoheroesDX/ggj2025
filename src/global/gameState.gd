extends Node

var hackerModeActivated = false

signal theyDEAD(char: CharacterBody2D)
signal dyingByLowStat
signal updateStats(optimism: int, o2: int, food: int, material: int)

var slotsInPool = 0;
var thoughtPool: Array[Thought] = [];
var baseThoughtNames: Array[String] = ["OPTIMISM", "O2", "FOOD", "MATERIAL"];

var currentRound: int = 0
var currentOptimism = 50
var currentO2 = 50
var currentFood = 50
var currentMaterial = 50
var astronautsAreDying = false
var dyingTimer = 0

var currentAstronauts: int = 0

var allThoughtsDictionary: Dictionary = {};

signal newRound

signal showLog(text: String, isPositive: bool)

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
		print(currentO2, " ",  currentFood, " ", currentMaterial, " ", currentOptimism)

func printToLog(text: String, isPositive: bool):
	showLog.emit(text, isPositive)

func nextRound():
	var o2DecayPerRound = int(0.01 * currentAstronauts)
	var foodDecayPerRound = int(0.02 * currentAstronauts + 0.5)
	applyThoughtEffect(0, -o2DecayPerRound, -foodDecayPerRound, 0)
	print ("o2 decay")
	print(o2DecayPerRound)
	print("food Decay")
	print(foodDecayPerRound)
	checkDeath()
	currentRound += 1;
	newRound.emit();
	
func checkDeath():
	pass
	if astronautsAreDying:
		dyingTimer += 1
		if dyingTimer > 3:
			print("rm one astronaut")
			dyingTimer = 0
			dyingByLowStat.emit()

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
	currentOptimism += optimism
	currentO2 += o2
	currentFood += food
	currentMaterial += material
	keepWithinLimits()
	updateStats.emit(currentOptimism, currentO2, currentFood, currentMaterial)
	
func changeMaterialStat(material: int):
	currentMaterial += material
	keepWithinLimits()
	updateStats.emit(currentOptimism, currentO2, currentFood, currentMaterial)

func keepWithinLimits():
	for stat in [currentOptimism, currentO2, currentFood, currentMaterial]:
		if stat < 0:
			stat = 0;
		elif stat > 100:
			stat = 100

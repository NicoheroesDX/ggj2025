extends Node2D

@onready var grid: GridContainer = $Overlay/ScrollContainer/PoolGrid;
@onready var character = load("res://src/character/code/character.tscn");
@onready var discoveryPopUp : Discovery = %Discovery;
@onready var overlay : StatBars = $Overlay;
@onready var rng = RandomNumberGenerator.new()
@onready var emojiTheme = preload("res://src/global/theme/emojiTheme.tres")

var nextLogMessage: String
var nextLogMessageIsPositive: bool

func _ready():
	self.connect("move_east_signal_map", _on_domes_move_west_signal_map)
	self.connect("move_west_signal_map", _on_domes_move_west_signal_map)
	self.connect("new_dome", _on_domes_new_dome)
	GameState.theyDEAD.connect(popCharacter)
	GameState.dyingByLowStat.connect(removeOneCharacter)
	initPool()
	spawnInitialCharacters()
	GameState.combinationEventHappend.connect(onCombinationEvent);
	GameState.updateStats.connect(updateStatBars)

func initPool():
	UIManager.updatePoolItem.connect(rerenderGridCell);
	grid.columns = UIManager.poolColumns;
	renderGrid();

func renderGrid():
	for i in GameState.slotsInPool:
		renderGridCell(i)

func renderGridCell(index: int):
	var cellSize = Vector2(UIManager.poolCellWidth, UIManager.poolCellHeight);
	var optionalThought = GameState.getThoughtFromPool(index);
	var centerContainer = CenterContainer.new();

	var rect = ColorRect.new()
	rect.custom_minimum_size = cellSize
	rect.size = cellSize

	if (optionalThought != null):
		rect.color = Color(0, 0, 0, 0.5)

		var labelEmoji = Label.new()
		labelEmoji.theme = emojiTheme
		labelEmoji.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER;
		labelEmoji.text = optionalThought.unicodeSymbol;
		labelEmoji.add_theme_font_size_override("font_size", 24)
		var labelText = Label.new()
		labelText.text = optionalThought.displayName.replace("_", " ");

		var vBox = VBoxContainer.new();

		vBox.add_child(labelEmoji);
		vBox.add_child(labelText);

		centerContainer.add_child(rect);
		centerContainer.add_child(vBox);
	else:
		rect.color = Color(0, 0, 0, 0.2)
		centerContainer.add_child(rect);

	grid.add_child(centerContainer)
	grid.move_child(centerContainer, index)

func rerenderGridCell(index: int):
	var cell = grid.get_child(index)
	if cell != null:
		cell.queue_free();
		renderGridCell(index)

func spawnInitialCharacters():
	spawnNewCharacter(-500, 500)
	spawnNewCharacter(500, 500)

func spawnNewCharacter(x: float, y: float):
	var newCharacter = character.instantiate()
	newCharacter.position = Vector2(x, y)
	add_child(newCharacter)
	GameState.currentAstronauts += 1
	
func removeOneCharacter():
	if get_child_count() > 2:
		for node in get_children():
			if node is CharacterBody2D:
				GameState.theyDEAD.emit(node)
				return
	
func popCharacter(thisChar: CharacterBody2D):
	thisChar.queue_free()
	$DeathSound.play()
	GameState.currentAstronauts -= 1

func _on_east_pressed():
	var tween = get_tree().create_tween()

	tween.tween_property(
		$WorldCamera,
		"offset:x",
		$WorldCamera.offset.x + 9715,
		1.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_west_pressed():
	var tween = get_tree().create_tween()

	tween.tween_property(
		$WorldCamera,
		"offset:x",
		$WorldCamera.offset.x - 9715,
		1.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_domes_move_west_signal_map():
	_on_west_pressed()
func _on_domes_move_east_signal_map():
	_on_east_pressed()

func onCombinationEvent(newThought : Thought, isNewToPool : bool):
	reproductionEffect()
	if isNewToPool:
		newThought.applyEffect()
		discoveryPopUp.visualizeNewThought(newThought)
		newThought.applyEffect()
	
func reproductionEffect():
	var chance = float(GameState.currentOptimism) / 100
	var randi = rng.randf_range(0,1)
	if randi < chance:
		spawnNewCharacter(($WorldCamera.offset.x + randf_range(-250, 250)), $WorldCamera.offset.y + randf_range(-250, 250))
		nextLogMessage = "A new astronaut was born! Building their suit cost a bit of material."
		nextLogMessageIsPositive = true
		$LogMessageWithDelay.start()

func updateStatBars(optimism: int, o2: int, food: int, material: int):
	overlay.setStats(optimism, o2, food, material)
	checkThreshholds(optimism, o2, food)
			
func checkThreshholds(optimism: int, o2: int, food: int):
	if (o2 < 20) or (food < 20): # todo or (optimism < 20) : warn depression
		var timer : int = 0
		#if (optimism < 20):
			#GameState.printToLog
		if (food < 20):
			nextLogMessage = "Careful, if your food gets too low, your colony might starve"
			nextLogMessageIsPositive = false
			$LogMessageWithDelay.start()
		if (o2 < 20):
			nextLogMessage = "Careful, if your food gets too low, most astronauts cannot survive"
			nextLogMessageIsPositive = false
			$LogMessageWithDelay.start()
	if (o2 < 10) or (food < 10):
		print ("critical")
		GameState.astronautsAreDying = true
	else:
		GameState.astronautsAreDying = false
	
func _on_domes_new_dome(position: Vector2):
	spawnNewCharacter(position.x - 300, position.y - 800)
	spawnNewCharacter(position.x + 300, position.y - 800)

func _on_log_message_with_delay_timeout() -> void:
	GameState.printToLog(nextLogMessage, nextLogMessageIsPositive);

extends Node2D

@onready var grid: GridContainer = $Overlay/PoolGrid;
@onready var character = load("res://src/character/code/character.tscn");
@onready var discoveryPopUp : Discovery = %Discovery;
@onready var overlay : StatBars = $Overlay;

func _ready():
	self.connect("move_east_signal_map", _on_domes_move_west_signal_map)
	self.connect("move_west_signal_map", _on_domes_move_west_signal_map)
	GameState.theyDEAD.connect(popCharacter)
	initPool()

	spawnInitialCharacters()
	GameState.combinationEventHappend.connect(onCombinationEvent);

	GameState.heDEAD.connect(popCharacter)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_1"):
		GameState.testPool1()
	elif Input.is_action_just_pressed("debug_2"):
		GameState.testPool2()
	elif Input.is_action_just_pressed("debug_3"):
		GameState.testPool3()
	elif Input.is_action_just_pressed("debug_spawn"):
		spawnNewCharacter()

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
		labelEmoji.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER;
		labelEmoji.text = optionalThought.unicodeSymbol;
		var labelText = Label.new()
		labelText.text = optionalThought.displayName;
		
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

func popCharacter(thisChar: CharacterBody2D):
	thisChar.queue_free()

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
	newThought.applyEffect()
	if isNewToPool:
		discoveryPopUp.visualizeNewThought(newThought);
	
func popCharacter(thisChar: CharacterBody2D):
	thisChar.queue_free()

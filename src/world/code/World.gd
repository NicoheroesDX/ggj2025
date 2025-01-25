extends Node2D

@onready var grid: GridContainer = %PoolGrid;
@onready var character = load("res://src/character/code/character.tscn");
@onready var discoveryPopUp : Discovery = %Discovery;

func _ready():
	self.connect("move_east_signal_map", _on_domes_move_west_signal_map)
	self.connect("move_west_signal_map", _on_domes_move_west_signal_map)
	initPool()
	spawnInitialCharacters()
	GameState.combinationEventHappend.connect(onCombinationEvent);

func initPool():
	UIManager.updatePoolItem.connect(rerenderGridCell);
	grid.columns = UIManager.poolColumns;
	renderGrid();

func renderGrid():
	for i in GameState.slotsInPool:
		renderGridCell(i)

func renderGridCell(index: int):
	var cellSize = UIManager.poolCellSize;
	var optionalThought = GameState.getThoughtFromPool(index);
	var cell;
	
	if (optionalThought != null):
		var button = Button.new();
		button.custom_minimum_size = Vector2(cellSize, cellSize);
		button.text = optionalThought.unicodeSymbol;
		button.tooltip_text = optionalThought.displayName;
		
		cell = button;
	else:
		var rect = ColorRect.new()
		rect.custom_minimum_size = Vector2(cellSize, cellSize)
		rect.color = Color(0, 0, 0, 0.2)
		cell = rect;
		
	grid.add_child(cell)
	grid.move_child(cell, index)

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

func onCombinationEvent(newThought : Thought):
	discoveryPopUp.visualizeNewThought(newThought);

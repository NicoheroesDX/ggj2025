extends Node2D

@onready var grid: GridContainer = %PoolGrid;
@onready var character = load("res://src/character/code/character.tscn")

func _ready():
	self.connect("move_east_signal_map", _on_domes_move_west_signal_map)
	self.connect("move_west_signal_map", _on_domes_move_west_signal_map)
	initPool()

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
	for i in GameState.maxAmountOfIdeas:
		renderGridCell(i)

func renderGridCell(index: int):
	var cellSize = UIManager.poolCellSize;
	var optionalIdea = GameState.getThoughtFromPool(index);
	var cell;
	
	if (optionalIdea != null):
		var button = Button.new()
		button.custom_minimum_size = Vector2(cellSize, cellSize)
		button.text = GameState.Idea.keys()[optionalIdea].left(3) + "."
		cell = button
	else:
		var rect = ColorRect.new()
		rect.custom_minimum_size = Vector2(cellSize, cellSize)  # Cell size
		rect.color = Color.BLACK  # Fill with black
		cell = rect;
		
	grid.add_child(cell)
	grid.move_child(cell, index)

func rerenderGridCell(index: int):
	var cell = grid.get_child(index)
	
	if cell != null:
		cell.queue_free();
		renderGridCell(index)

func spawnNewCharacter():
	var newCharacter = character.instantiate()
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


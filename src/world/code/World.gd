extends Node2D

@onready var grid: GridContainer = %PoolGrid;
@onready var character = load("res://src/character/code/character.tscn")

func _ready():
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

func spawnNewCharacter():
	var newCharacter = character.instantiate()
	add_child(newCharacter)
	
func collisionEvent():
	# evtl. neuer Thought in den Pool (Jan und Nico)
	# evtl. Animation (Leon)
	pass

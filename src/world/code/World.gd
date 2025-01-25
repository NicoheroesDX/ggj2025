extends Node2D

@onready var grid: GridContainer = $Overlay/PoolGrid;

func _ready():
	initPool()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_1"):
		GameState.testPool1()
	elif Input.is_action_just_pressed("debug_2"):
		GameState.testPool2()
	elif Input.is_action_just_pressed("debug_3"):
		GameState.testPool3()

func initPool():
	UIManager.updatePoolItem.connect(rerenderGridCell);
	grid.columns = UIManager.poolColumns;
	renderGrid();

func renderGrid():
	for i in GameState.maxAmountOfIdeas:
		renderGridCell(i)

func renderGridCell(index: int):
	var cellSize = UIManager.poolCellSize;
	var optionalIdea = GameState.getIdeaFromPool(index);
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

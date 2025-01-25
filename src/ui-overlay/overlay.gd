extends CanvasLayer

@onready var pool = %PoolGrid;

func _on_button_pressed() -> void:
	pool.visible = !pool.visible;

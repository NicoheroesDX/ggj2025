extends CanvasLayer

@onready var pool = %PoolGrid;
@onready var back = $Backdrop;
@onready var close = $CloseButton;

func toggleInventory(isOpen: bool):
	pool.visible = isOpen;
	back.visible = isOpen;
	close.visible = isOpen;

func _on_button_pressed() -> void:
	toggleInventory(true)

func _on_close_button_pressed() -> void:
	toggleInventory(false)

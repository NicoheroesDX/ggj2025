extends CanvasLayer

@onready var optimismBar : TextureProgressBar = $CanvasGroup/foodBar/TextureProgressBar # : Bar
@onready var o2Bar : TextureProgressBar = $CanvasGroup/o2Bar/TextureProgressBar;
@onready var materialBar : TextureProgressBar = $CanvasGroup/materialBar/TextureProgressBar;
@onready var foodBar : TextureProgressBar = $CanvasGroup/foodBar/TextureProgressBar;

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

func changeStats(optimism: int, o2: int, food: int, material: int):
	optimismBar.FILL_CLOCKWISE
	pass;

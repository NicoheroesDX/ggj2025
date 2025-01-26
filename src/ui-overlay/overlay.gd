extends CanvasLayer
@onready var optimismBar : TextureProgressBar = $CanvasGroup/foodBar/TextureProgressBar # : Bar
@onready var o2Bar : TextureProgressBar = $CanvasGroup/o2Bar/TextureProgressBar;
@onready var materialBar : TextureProgressBar = $CanvasGroup/materialBar/TextureProgressBar;
@onready var foodBar : TextureProgressBar = $CanvasGroup/foodBar/TextureProgressBar;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func changeStats(optimism: int, o2: int, food: int, material: int):
	optimismBar.FILL_CLOCKWISE
	pass;

extends CanvasLayer
class_name StatBars

@onready var optimismBar : TextureProgressBar = $CanvasGroup/foodBar/TextureProgressBar # : Bar
@onready var o2Bar : TextureProgressBar = $CanvasGroup/o2Bar/TextureProgressBar;
@onready var materialBar : TextureProgressBar = $CanvasGroup/materialBar/TextureProgressBar;
@onready var foodBar : TextureProgressBar = $CanvasGroup/foodBar/TextureProgressBar;

@onready var logBase : Control = %LogBase
@onready var logLabel : RichTextLabel = %LogLabel

@onready var pool = %PoolGrid;
@onready var back = $Backdrop;
@onready var scroll = $ScrollContainer;
@onready var close = $CloseButton;

func _ready() -> void:
	GameState.showLog.connect(updateLabel)

func updateLabel(logText: String):
	$CanvasGroup/LogBase/Timer.wait_time = 3;
	logBase.visible = true
	logLabel.text = logText
	$CanvasGroup/LogBase/Timer.start();

func toggleInventory(isOpen: bool):
	pool.visible = isOpen;
	back.visible = isOpen;
	close.visible = isOpen;
	scroll.visible = isOpen;
	$Button/Click.play()

func _on_button_pressed() -> void:
	toggleInventory(true)

func _on_close_button_pressed() -> void:
	toggleInventory(false)

func setStats(optimism: int, o2: int, food: int, material: int):
	var debug = "updating. opt: %s"
	var debug_string = debug % optimism
	print(debug_string)
	optimismBar.value = optimism
	o2Bar.value = o2
	foodBar.value = food
	materialBar.value = material

func _on_timer_timeout() -> void:
	logBase.visible = false;

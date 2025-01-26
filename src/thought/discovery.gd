extends CanvasLayer
class_name Discovery

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func visualizeNewThought(newThought : Thought):
	self.visible = true;
	$Emoji.text = newThought.unicodeSymbol;
	$ThoughtTitle.text = newThought.displayName;
	$invisibleTimer.start();
	pass;

func _on_invisible_timer_timeout() -> void:
	self.visible = false;
	pass # Replace with function body.

extends Node2D

var selected = false
var mouse_offset = Vector2(0, 0)

func _ready():
	pass # Replace with function body.

func _process(_delta):
	if selected:
		followMouse()
	if Input.is_action_pressed("arrow_left"):
		changeEmoji()

func _on_area_2d_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			mouse_offset = position - get_global_mouse_position()
			selected = true
		else:
			selected = false

func followMouse():
	position = get_global_mouse_position() + mouse_offset

func changeEmoji():
	$CharacterBody2D/EmojiPlaceholder.texture = load("res://src/character/assets/emojis/emoji_attention.png")


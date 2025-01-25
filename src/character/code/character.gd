extends CharacterBody2D

var selected = false
var mouse_offset = Vector2(0, 0)

var float_speed: float = 2.0
var float_amplitude: float = 10.0

var original_position: Vector2
var time: float = 0.0

var scaleSize: float = 0.3
var upScaledSize: float = 0.35

var selectedColor : Color = Color(1, 0, 1)
var hoveringColor : Color = Color(0, 1, 0)
var standardColor : Color = Color(1, 1, 1)


func _ready():
	self.scale = Vector2(scaleSize, scaleSize)
	original_position = position
	z_index = 1
	

func _process(delta):
	if selected:
		z_index = 2
		followMouse()
		original_position = position
		self.scale = Vector2(upScaledSize, upScaledSize)
	else:
		z_index = 1
		time += delta * float_speed
		var offset_y = float_amplitude * sin(time)
		position.y = original_position.y + offset_y
		self.scale = Vector2(scaleSize, scaleSize)

func _physics_process(delta):
	var moveVelocity = Vector2.ZERO
	moveVelocity.y += 10 * delta
	velocity = moveVelocity

	move_and_slide()


func _on_area_2d_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			mouse_offset = position - get_global_mouse_position()
			selected = true
		else:
			selected = false
			for body in $Area2D.get_overlapping_bodies():
				if (body.get_groups().has("character") and (body != self and !body.selected)):
						print("collision")


					
func followMouse():
	position = get_global_mouse_position() + mouse_offset

func changeEmoji():
	$EmojiPlaceholder.texture = load("res://src/character/assets/emojis/emoji_attention.png")

func _on_area_2d_area_entered(area):
	area.get_parent().modulate = hoveringColor
	$Sprite2D.modulate = hoveringColor


func _on_area_2d_area_exited(area):
	area.get_parent().modulate = standardColor
	$Sprite2D.modulate = standardColor
	
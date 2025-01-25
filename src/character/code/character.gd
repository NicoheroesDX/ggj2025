extends CharacterBody2D

signal exited_area

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

var is_inside_area: bool = true

var startPosition : Vector2

var spawnPosition : Vector2 = Vector2(0, 500)

var randomColor : Color

var progress_time : float = 0
const MAX_PROGRESS_TIME : float = 1.5

var deathlyIll : bool = false

func _ready():
	self.scale = Vector2(scaleSize, scaleSize)
	z_index = 1
	exited_area.connect(on_area_exited)
	position = spawnPosition
	self.rotate(randf_range(-2,2))
	getInitialThought()
	$ProgressBar.show_percentage = false
	$ProgressBar.hide()
	$CombineTimer.wait_time = MAX_PROGRESS_TIME


func getInitialThought():
	var thought = GameState.getThoughtFromPool(randi() % GameState.maxAmountOfIdeas)
	if thought != null:
		changeEmoji()
		print("Thought found:", thought)
		if thought.name == "deathlyIll":
			deathlyIll = true
	else:
		print("No thought found")

	

func _process(delta):
	if selected:
		z_index = 2
		followMouse()
		original_position = position
		self.scale = Vector2(upScaledSize, upScaledSize)
	else:
		startPosition = position
		z_index = 1
		time += delta * float_speed
		var offset_y = float_amplitude * sin(time)
		position.y = position.y + offset_y * 0.3
		self.scale = Vector2(scaleSize, scaleSize)
		self.rotate(0.01)

	if $CombineTimer.is_stopped() == false:
		progress_time += delta
		var progress = min(progress_time / MAX_PROGRESS_TIME, 1.0) * 100
		$ProgressBar.value = progress
		if progress_time >= MAX_PROGRESS_TIME:
			$CombineTimer.stop()
			_on_combine_timer_timeout()
	else:
		progress_time = 0
		$ProgressBar.hide()
		
	if deathlyIll:
		_on_deathly_ill()
	

func _physics_process(delta):
	if is_inside_area:
		var moveVelocity = Vector2.ZERO
		moveVelocity.y += 10 * delta
		velocity = moveVelocity

		move_and_slide()
	else:
		velocity = Vector2.ZERO

# When moving an Astronaut through the game, this checks if it is still being moved,
# or colliding with another Astronaut
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
						RoundManager.updateEventStatus.emit()
						


					
func followMouse():
	position = get_global_mouse_position() + mouse_offset

func changeEmoji():
	$EmojiPlaceholder.texture = load("res://src/character/assets/emojis/emoji_attention.png")

func _on_area_2d_area_entered(area):
		area.get_parent().modulate = hoveringColor
		$Sprite2D.modulate = hoveringColor 
		$CombineTimer.start()
		$ProgressBar.value = 0
		$ProgressBar.show()
		print("start timer")


func _on_area_2d_area_exited(area):
		area.get_parent().modulate = standardColor
		$Sprite2D.modulate = standardColor
		$CombineTimer.stop()
		$ProgressBar.hide()
		print("stop timer")

func on_area_exited():
	print("Character exited area:", self.name)
	is_inside_area = false
	selected = false
	position = spawnPosition

func _on_combine_timer_timeout():
	print("Combine timer timeout")
	selected = false
	self.position = startPosition
	# GameState.combineIdeas(self)
	$ProgressBar.hide()
	
func _on_deathly_ill():
	GameState.heDEAD.emit(self)
	print("he ded")
	
	

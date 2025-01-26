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

var randomColor : Color

var currentThought: Thought
var thoughtToCombineWith: Thought

var progress_time : float = 0
const MAX_PROGRESS_TIME : float = 1.5

var deathlyIll : bool = false
func _ready():
	self.scale = Vector2(scaleSize, scaleSize)
	z_index = 1
	GameState.currentAstronauts += 1;
	exited_area.connect(on_area_exited)
	self.rotate(randf_range(-2,2))
	getNewThought()
	$ProgressBar.show_percentage = false
	$ProgressBar.hide()
	$CombineTimer.wait_time = MAX_PROGRESS_TIME

func getNewThought():
	currentThought = GameState.getThoughtFromPool(randi_range(0, GameState.thoughtPool.size() - 1))
	changeEmoji(currentThought)

func _process(delta):	
	if deathlyIll == true:
		_on_deathly_ill()
		
	if currentThought.displayName == "DEATHLY_ILL":
		deathlyIll = true
	
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

func followMouse():
	position = get_global_mouse_position() + mouse_offset

func changeEmoji(thought: Thought):
	$EmojiPlaceholder.text = thought.unicodeSymbol;

func _on_area_2d_area_entered(area):
	area.get_parent().modulate = hoveringColor
	$GPUParticles2D.emitting = true
	$Sprite2D.modulate = hoveringColor 
	$CombineTimer.start()
	$CombineSound.play()
	$ProgressBar.value = 0
	$ProgressBar.show()
	thoughtToCombineWith = area.get_parent().currentThought

func _on_area_2d_area_exited(area):
	area.get_parent().modulate = standardColor
	$GPUParticles2D.emitting = false
	$Sprite2D.modulate = standardColor
	$CombineTimer.stop()
	$CombineSound.stop()
	$ProgressBar.hide()
	thoughtToCombineWith = null

func on_area_exited():
	is_inside_area = false
	selected = false

func _on_combine_timer_timeout():
	var newPosition = Vector2(position.x + randf_range(-150, 150), position.y + randf_range(-150, 150))
	self.position = newPosition
	
	#if (selected):
	var thoughtBuilder = ThoughtBuilder.new();
	$ProgressBar.hide()
	var newThought = thoughtBuilder.combineTwo(currentThought, thoughtToCombineWith);
	if (newThought != null):
		GameState.showLog.emit("A new thought was created: " + newThought.displayName, true);

		GameState.combinationEventHappend.emit(newThought, !(newThought in GameState.thoughtPool));
		GameState.applyThoughtEffect(+3, 0, 0, +3)
		$SuccessSound.play()
	else:
		GameState.showLog.emit("The combination was not successful! A few materials were wasted and your people are ab bit down about it", false)
		var removalOfStats = int(GameState.thoughtPool.size() * 0.01)
		GameState.applyThoughtEffect(-removalOfStats, 0, 0, -removalOfStats)
		$FailSound.play()
	getNewThought()
	GameState.nextRound();
	selected = false

func _on_deathly_ill():
	if ($DeathTimer.is_stopped()):
		$DeathTimer.start();
	
func _on_death_timer_timeout() -> void:
	GameState.currentAstronauts -= 1;
	GameState.theyDEAD.emit(self)

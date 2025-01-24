extends Node2D

@onready var camera = $Camera2D;

var dragging: bool = false
var last_mouse_position: Vector2
var target_position: Vector2

var currentZoomLevel = 0;

var zoomLevels = [0.4, 0.7, 1.2];

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			dragging = event.pressed
			last_mouse_position = get_global_mouse_position()
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed() and not event.is_echo():
			currentZoomLevel += 1;
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_pressed() and not event.is_echo():
			currentZoomLevel -= 1;
	

func _process(delta):
	if currentZoomLevel < 0:
		currentZoomLevel = 0;
	elif currentZoomLevel >= zoomLevels.size():
		currentZoomLevel = zoomLevels.size() - 1;
	var speed: float = 1.0
	var smoothing: float = 10.0
	if dragging:
		var mouse_position = get_global_mouse_position()
		var mouse_delta = last_mouse_position - mouse_position  # Get movement difference
		target_position += mouse_delta * speed  # Move the camera
		last_mouse_position = mouse_position  # Update last position 
	camera.position = camera.position.lerp(target_position, smoothing * delta)
	camera.zoom.x = zoomLevels[currentZoomLevel];
	camera.zoom.y = zoomLevels[currentZoomLevel];

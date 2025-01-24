extends Camera2D

var isBeingDragged: bool = false;

var lastMousePosition: Vector2;
var targetPosition: Vector2;

var speed: float = 1.0
var smoothing: float = 10.0

var currentZoomLevel = 0;

var zoomLevels = [0.4, 0.7, 1.2];

func _input(event):
	if event is InputEventMouseButton:
		if Input.is_action_pressed("drag_camera"):
			isBeingDragged = true
			lastMousePosition = get_global_mouse_position()
		else:
			isBeingDragged = false
			
			
		if Input.is_action_just_pressed("zoom_in") and event.is_pressed() and not event.is_echo():
			currentZoomLevel += 1;
		elif Input.is_action_just_pressed("zoom_out") and event.is_pressed() and not event.is_echo():
			currentZoomLevel -= 1;
	

func _process(delta):
	if currentZoomLevel < 0:
		currentZoomLevel = 0;
	elif currentZoomLevel >= zoomLevels.size():
		currentZoomLevel = zoomLevels.size() - 1;
	
	if isBeingDragged:
		var mousePosition = get_global_mouse_position()
		var mouseDelta = lastMousePosition - mousePosition
		targetPosition += mouseDelta * speed
		lastMousePosition = mousePosition
	
	position = position.lerp(targetPosition, smoothing * delta)
	
	var zoomLevel = zoomLevels[currentZoomLevel];
	zoom = Vector2(zoomLevel, zoomLevel);

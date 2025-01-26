extends StaticBody2D

signal move_east
signal move_west
signal new_dome


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GameState.currentMaterial >= 70:
		$Button_Buy.disabled = false
	else:
		$Button_Buy.disabled = true

func _on_area_2d_body_exited(body:Node2D):
	pass
	body.emit_signal("exited_area")

func _on_area_2d_body_entered(body:Node2D):
	pass

func _on_east_pressed():
	move_east.emit()
	$ButtonSound.play()

func _on_west_pressed():
	move_west.emit()
	$ButtonSound.play()

func _on_button_buy_pressed():
	$Graphics.visible = true
	$Button_Buy.visible = false
	$Button_Buy.disabled = true
	GameState.printToLog("You bought a new home for your planetlings for 70 material.", true)
	new_dome.emit()

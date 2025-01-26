extends Node2D

signal move_east_signal_map
signal move_west_signal_map
signal new_dome

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("move_east_signal", move_east)
	self.connect("move_west_signal", move_west)

	$dome_eastier.get_node("Navigation/EAST").disabled=true
	$dome_eastier.get_node("Navigation/EAST").visible=false

	$dome_westier.get_node("Navigation/WEST").disabled=true
	$dome_westier.get_node("Navigation/WEST").visible=false


	$dome_west.get_node("Graphics").visible=false
	$dome_westier.get_node("Graphics").visible=false
	$dome_east.get_node("Graphics").visible=false
	$dome_eastier.get_node("Graphics").visible=false

	$dome_home.get_node("Button_Buy").visible=false
	$dome_home.get_node("Button_Buy").disabled=true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func move_east():
	move_east_signal_map.emit()

func move_west():
	move_west_signal_map.emit()

func _on_dome_west_move_west():
	move_west()


func _on_dome_west_move_east():
	move_east()


func _on_dome_east_move_west():
	move_west()


func _on_dome_east_move_east():
	move_east()


func _on_dome_eastier_move_west():
	move_west()


func _on_dome_eastier_move_east():
	move_east()


func _on_dome_westier_move_west():
	move_west()


func _on_dome_westier_move_east():
	move_east()


func _on_dome_home_move_west():
	move_west()

func _on_dome_home_move_east():
	move_east()


func _on_dome_westier_new_dome():
	new_dome.emit($dome_westier.position)


func _on_dome_eastier_new_dome():
	new_dome.emit($dome_eastier.position)


func _on_dome_east_new_dome():
	new_dome.emit($dome_east.position)


func _on_dome_west_new_dome():
	new_dome.emit($dome_west.position)

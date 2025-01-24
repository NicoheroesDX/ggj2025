extends Object

const Stat = preload("res://src/stat.gd")

var kind: Stat
var value: int

func _init(stat: Stat, value: int):
	kind = stat
	value = value

extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var combiEventOver = false
	var round = 0
	var newIdeaThreshold
	
	round = _nextRound(combiEventOver,round)
	if round >= newIdeaThreshold:
		#get new ideas (maybe random from an array or something)
		pass
	
	pass
	
func _nextRound(combiEventOver: bool, round: int) -> int:
	if combiEventOver == true:
		return round + 1
	return round

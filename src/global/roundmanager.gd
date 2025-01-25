extends Node
signal updateEventStatus

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RoundManager.updateEventStatus.connect(_nextRound)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var newIdeaThreshold: int = randi_range(5,7)
	
	if GameState.currentRound >= newIdeaThreshold:
		#get new ideas (maybe random from an array or something)
		pass
	pass
	
func _nextRound() -> void:
	GameState.currentRound += 1
	
func _on_Character_hasCollided(hasCollided):
	var combiEvent: bool = hasCollided
	return combiEvent
	

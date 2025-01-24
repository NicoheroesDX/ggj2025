class_name Emoji extends Object

const Experience = preload("res://src/experience.gd")
const Stat = preload("res://src/stat.gd")

var score: int
var stat: Stat

var code: String

func calculate_score(other: Emoji) -> Array[Experience]:
	if self.stat.Kind == other.ressource.Kind:
		return [Experience.new(stat, score)]
	
	return [Experience.new(stat, score), Experience.new(other.stat, other.score)]

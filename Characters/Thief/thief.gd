extends Character
class_name Thief
signal thief_exited(thief : Thief)

var numSteals := 0
var maxSteals := 5

func get_bricks() -> int:
	if(!get_parent().get_parent().has_warrior()):
		return rng.randi_range(-10,-5)
	return rng.randi_range(-10,-5)

func get_gold() -> int:
	if(!get_parent().get_parent().has_warrior()):
		numSteals += 1
		if(!stolen_enough()):
			return rng.randi_range(-10,-5)
	thief_exited.emit(self)
	return rng.randi_range(-10,-5)

func stolen_enough() -> bool:
	return (numSteals >= maxSteals)

func _to_string():
	return "thief"

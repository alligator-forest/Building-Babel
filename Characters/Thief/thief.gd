extends Character
class_name Thief
signal thief_exited(thief : Thief, waitTime : float)

var numSteals := 0
var maxSteals := 5

func get_bricks() -> int:
	return $BrickEffect.start_effect(rng.randi_range(-10,-5))

func get_gold() -> int:
	numSteals += 1
	if(stolen_enough()):
		$AnimatedSprite2D.hide()
		thief_exited.emit(self,$BrickEffect.get_effect_time())
	return $GoldEffect.start_effect(rng.randi_range(-10,-5))

func stolen_enough() -> bool:
	return (numSteals >= maxSteals) or (currentFloor.has_warrior())

func _to_string():
	return "thief"

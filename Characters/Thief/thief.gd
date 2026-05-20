extends Character
class_name Thief
signal thief_exited(thief : Thief, waitTime : float)

var numSteals := 0
var maxSteals := 5

func get_resource(r : String) -> int:
	if(r == "gold"):
		numSteals += 1
		if(stolen_enough()):
			$AnimatedSprite2D.hide()
			thief_exited.emit(self,$BrickEffect.get_effect_time())
		return rng.randi_range(minResource,maxResource)
	elif(r == "bricks" and get_current_floor().floorIndex % 2 == 1):
		return rng.randi_range(minResource,maxResource)
	elif(r == "wood" and get_current_floor().floorIndex % 2 == 0):
		return rng.randi_range(minResource,maxResource)
	return 0

func start_effect(resource : String, value : int) -> void:
	match(resource):
		"gold":
			$GoldEffect.start_effect(value, global_position)
		"bricks":
			$BrickEffect.start_effect(value, global_position)
		"wood":
			$WoodEffect.start_effect(value, global_position)

func stolen_enough() -> bool:
	return (numSteals >= maxSteals) or (currentFloor.has_warrior())

func _to_string():
	return "thief"

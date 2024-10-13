extends Character
class_name Thief

func getBricks() -> int:
	if(!get_parent().get_parent().has_warrior()):
		return rng.randi_range(-10,-1)
	return 0

func getGold() -> int:
	if(!get_parent().get_parent().has_warrior()):
		return rng.randi_range(-10,-1)
	return 0

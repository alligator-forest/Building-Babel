extends Character
class_name Thief

func getBricks() -> int:
	return rng.randi_range(-10,-1)

func getGold() -> int:
	return rng.randi_range(-10,-1)

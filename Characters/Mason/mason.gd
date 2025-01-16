extends Character
class_name Mason

func get_bricks() -> int:
	return $BrickEffect.start_effect(rng.randi_range(1,7))

func get_hubris() -> int:
	return 1

func get_price() -> int:
	return 20

func _to_string():
	return "mason"

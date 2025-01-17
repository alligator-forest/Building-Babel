extends Character
class_name Carpenter

func get_wood() -> int:
	return $WoodEffect.start_effect(rng.randi_range(1,7))

func get_hubris() -> int:
	return 1

func get_price() -> int:
	return 20

func _to_string():
	return "carpenter"

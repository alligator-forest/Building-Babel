extends Character
class_name Merchant

func get_gold() -> int:
	return $GoldEffect.start_effect(rng.randi_range(1,7))

func get_hubris() -> int:
	return 2
	
func get_price() -> int:
	return 15

func _to_string():
	return "merchant"

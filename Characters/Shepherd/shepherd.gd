extends Character
class_name Shepherd

func _ready() -> void:
	charWidth = 12

func get_hubris() -> int:
	return rng.randi_range(-7,0)

func get_price() -> int:
	return 30

func _to_string():
	return "shepherd"

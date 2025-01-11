extends Character
class_name Warrior

func _ready() -> void:
	charWidth = 20

func get_price() -> int:
	return 30

func _to_string():
	return "warrior"

extends Node2D
class_name ResourceEffect

@export var type : String = "gold"
@export var offset : Vector2
var amount : int = 0

func _ready() -> void:
	match type:
		"gold":
			$Sprite2D.region_rect.position.x = 0
		"bricks":
			$Sprite2D.region_rect.position.x = 6
		"wood":
			$Sprite2D.region_rect.position.x = 12

func get_effect_time() -> float:
	return $Timer.wait_time

func start_effect(a : int, pos : Vector2) -> int:
	self.amount = a
	if(amount != 0):
		if(amount < 0):
			$Label.text = ""
		else:
			$Label.text = "+"
		$Label.text += str(amount)
		var tween = create_tween()
		global_position = pos + offset
		show()
		$Timer.start($Timer.wait_time)
		tween.tween_property(self,"global_position:y",global_position.y - 20,$Timer.wait_time).set_trans(Tween.TRANS_EXPO)
		tween.parallel().tween_property(self,"modulate:a",0.0,$Timer.wait_time).set_trans(Tween.TRANS_EXPO)
	return self.amount

func _on_timer_timeout() -> void:
	hide()
	modulate.a = 1.0

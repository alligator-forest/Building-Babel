extends Node2D
class_name ResourceEffect

@export var type : String = "gold"
var amount : int = 0

func _ready() -> void:
	match type:
		"gold":
			$Sprite2D.region_rect.position.x = 0
		"bricks":
			$Sprite2D.region_rect.position.x = 12

func get_effect_time() -> float:
	return $Timer.wait_time

func start_effect(a : int) -> int:
	self.amount = a
	if(amount != 0):
		if(amount < 0):
			$Label.text = ""
		else:
			$Label.text = "+"
		$Label.text += str(amount)
		var tween = create_tween()
		var tween2 = create_tween()
		show()
		$Timer.start($Timer.wait_time)
		tween.tween_property(self,"position:y",position.y - 20,$Timer.wait_time).set_trans(Tween.TRANS_EXPO)
		tween2.tween_property(self,"modulate:a",0.0,$Timer.wait_time).set_trans(Tween.TRANS_EXPO)
	return self.amount

func _on_timer_timeout() -> void:
	hide()
	position.y = -35
	modulate.a = 1.0

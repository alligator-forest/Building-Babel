extends Node2D
class_name ResourceEffect

var type : String = ""
var amount : int = 0
func set_values(t : String, a : int) -> void:
	self.type = t
	self.amount = a

func spawn() -> void:
	if(amount != 0):
		match type:
			"gold":
				$Sprite2D.region_rect.position.x = 0
			"bricks":
				$Sprite2D.region_rect.position.x = 12
			_:
				queue_free()
		if(amount < 0):
			$Label.text = ""
		else:
			$Label.text = "+"
		$Label.text += str(amount)
		var tween = create_tween()
		var tween2 = create_tween()
		tween.tween_property(self,"global_position:y",global_position.y - 40,$Timer.wait_time).set_trans(Tween.TRANS_EXPO)
		tween2.tween_property(self,"modulate:a",0.0,$Timer.wait_time).set_trans(Tween.TRANS_EXPO)
	else:
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
	

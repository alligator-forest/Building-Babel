extends Control
class_name Character

@onready var rng := RandomNumberGenerator.new()

func _on_wait_timer_timeout():
	var tween = create_tween()
	$AnimatedSprite2D.play()
	var newPos = rng.randf_range(12,300)
	if(newPos > position.x):
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	var time = abs(newPos-position.x)/rng.randf_range(20,40)
	tween.tween_property(self, "position", Vector2(newPos, position.y), time)
	$MoveTimer.wait_time = time 
	$MoveTimer.start()


func _on_move_timer_timeout():
	$AnimatedSprite2D.stop()
	$WaitTimer.wait_time = rng.randf_range(2,7)
	$WaitTimer.start()

func getBricks() -> int:
	return 0

func getGold() -> int:
	return 0

func getGodFear() -> int:
	return 0

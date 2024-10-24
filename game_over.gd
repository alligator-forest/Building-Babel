extends Node2D

func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play("Game Over Loop")

var languages := ["Fin del Juego","انتهت اللعبة","Jeu terminé","遊戲結束","Игра закончена","Oyun bitti","ゲームオーバー","Konec igre","Game Over"]

var index := 0
func _on_timer_timeout():
	$GameOver.text = languages[index]
	index = (index + 1) % languages.size()


func _on_button_pressed():
	get_tree().change_scene_to_file("res://home_menu.tscn")

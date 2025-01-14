extends Node2D

var languages := ["Fin del Juego","Kraj igre","Jeu terminé","Vége a játéknak","Игра закончена","Oyun bitti","Fim de jogo","Konec igre","Game Over"]

var index := 0
func _on_timer_timeout():
	$GameOver.text = languages[index]
	index = (index + 1) % languages.size()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Screens/home_menu.tscn")

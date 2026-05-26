extends Node2D

@export var allowReset : bool = false
func _ready() -> void:
	$CheckBox.button_pressed = !SAVEOBJECT.data.seen_tutorial()

func _on_play_button_pressed():
	SAVEOBJECT._save_data()
	$SceneManager.change_scene("res://Screens/main.tscn")

func _on_leaderboard_button_pressed() -> void:
	$SceneManager.change_scene("res://Screens/leaderboard.tscn")

func _on_credits_button_pressed() -> void:
	$SceneManager.change_scene("res://Screens/credits.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_check_box_toggled(toggled_on: bool) -> void:
	SAVEOBJECT.data.set_seen_tutorial(!toggled_on)

func _input(event: InputEvent) -> void:
	if(Input.is_key_pressed(KEY_R) and allowReset):
		SAVEOBJECT.data.reset_all()
		SAVEOBJECT._save_data()

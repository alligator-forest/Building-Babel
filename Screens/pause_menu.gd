extends CanvasLayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(get_tree().paused):
		show()
	else:
		hide()

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_cancel")):
		if(get_tree().paused):
			print("UNPAUSED")
		else:
			print("PAUSED")
		_on_pause_button_pressed()
	
func _on_pause_button_pressed() -> void:
	get_tree().paused = !get_tree().paused


func _on_line_edit_text_submitted(new_text: String) -> void:
	new_text = new_text.to_lower()
	match new_text:
		"sans":
			$CodeConsole.text = "New skin unlocked!"
		_:
			$CodeConsole.text = "Invalid code. Try again!"


func _on_code_textbox_text_changed(_new_text: String) -> void:
	$CodeConsole.text = ""


func _on_music_slider_value_changed(value: float) -> void:
	$"Music Label".text = "Music: " + str($"Music Slider".value) + "%"


func _on_sfx_slider_value_changed(value: float) -> void:
	$"SFX Label".text = "SFX: " + str($"SFX Slider".value) + "%"

extends Control

@onready var musicPercent = $HBoxContainer2/VolumeSliders/PercentLabels/MusicPercent
@onready var sfxPercent = $HBoxContainer2/VolumeSliders/PercentLabels/SfxPercent
@onready var codeLabel = $HBoxContainer/BoxContainer/CodeLabel

@onready var goldConsoleButton = $HBoxContainer2/ConsoleNotifications/GoldConsole
@onready var brickConsoleButton = $HBoxContainer2/ConsoleNotifications/BrickConsole
@onready var stealConsoleButton = $HBoxContainer2/ConsoleNotifications/ThiefAppear
@onready var thiefConsoleButton = $HBoxContainer2/ConsoleNotifications/ThiefSteal

func _ready() -> void:
	$HBoxContainer2/VolumeSliders/Sliders/MusicSlider.value = SAVEOBJECT.saveData.get_music_volume()
	$HBoxContainer2/VolumeSliders/Sliders/SfxSlider.value = SAVEOBJECT.saveData.get_sfx_volume()
	
	goldConsoleButton.button_pressed = SAVEOBJECT.saveData.get_console_notif("gold")
	brickConsoleButton.button_pressed = SAVEOBJECT.saveData.get_console_notif("bricks")
	stealConsoleButton.button_pressed = SAVEOBJECT.saveData.get_console_notif("thief")
	thiefConsoleButton.button_pressed = SAVEOBJECT.saveData.get_console_notif("steal")

func _on_line_edit_text_submitted(new_text: String) -> void:
	new_text = new_text.to_lower()
	match new_text:
		"sans":
			codeLabel.text = "New skin unlocked!"
		_:
			codeLabel.text = "Invalid code. Try again!"

func _on_code_textbox_text_changed(_new_text: String) -> void:
	codeLabel.text = ""

func _on_music_slider_value_changed(value: float) -> void:
	musicPercent.text = str(value * 200) + "%"

func _on_sfx_slider_value_changed(value: float) -> void:
	sfxPercent.text = str(value * 200) + "%"

func _on_volume_slider_drag_ended(value_changed: bool) -> void:
	if(value_changed):
		SAVEOBJECT._save_data()

func _on_gold_console_button_pressed() -> void:
	SAVEOBJECT.saveData.set_console_notif("gold",goldConsoleButton.button_pressed)
	SAVEOBJECT._save_data()

func _on_brick_console_button_pressed() -> void:
	SAVEOBJECT.saveData.set_console_notif("bricks",brickConsoleButton.button_pressed)
	SAVEOBJECT._save_data()

func _on_thief_appear_button_pressed() -> void:
	SAVEOBJECT.saveData.set_console_notif("thief",thiefConsoleButton.button_pressed)
	SAVEOBJECT._save_data()

func _on_thief_steal_button_pressed() -> void:
	SAVEOBJECT.saveData.set_console_notif("steal",stealConsoleButton.button_pressed)
	SAVEOBJECT._save_data()

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Screens/home_menu.tscn")

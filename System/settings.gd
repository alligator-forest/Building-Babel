extends Control

@onready var musicPercent = $HBoxContainer2/VolumeSliders/PercentLabels/MusicPercent
@onready var sfxPercent = $HBoxContainer2/VolumeSliders/PercentLabels/SfxPercent
@onready var codeLabel = $HBoxContainer/BoxContainer/CodeLabel

@onready var timerButton = $HBoxContainer2/ConsoleNotifications/HideTimer
@onready var tooltipButton = $HBoxContainer2/ConsoleNotifications/HideTooltip
@onready var resourceConsoleButton = $HBoxContainer2/ConsoleNotifications/ResourceConsole
@onready var stealConsoleButton = $HBoxContainer2/ConsoleNotifications/ThiefSteal
@onready var thiefConsoleButton = $HBoxContainer2/ConsoleNotifications/ThiefAppear

@export var tooltipTheme : Theme
@export var tooltipStylebox : StyleBoxFlat

func _ready() -> void:
	$HBoxContainer2/VolumeSliders/Sliders/MusicSlider.value = SAVEOBJECT.data.get_music_volume()
	$HBoxContainer2/VolumeSliders/Sliders/SfxSlider.value = SAVEOBJECT.data.get_sfx_volume()
	
	timerButton.button_pressed = SAVEOBJECT.data.get_console_notif("timer")
	timerButton.pressed.emit()
	tooltipButton.button_pressed = SAVEOBJECT.data.get_console_notif("tooltip")
	tooltipButton.pressed.emit()
	resourceConsoleButton.button_pressed = SAVEOBJECT.data.get_console_notif("resource")
	stealConsoleButton.button_pressed = SAVEOBJECT.data.get_console_notif("steal")
	thiefConsoleButton.button_pressed = SAVEOBJECT.data.get_console_notif("thief")

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
	musicPercent.text = str(int(value * 200),"%")

func _on_sfx_slider_value_changed(value: float) -> void:
	sfxPercent.text = str(int(value * 200),"%")

func _on_resource_console_button_pressed() -> void:
	SAVEOBJECT.data.set_console_notif("resource",resourceConsoleButton.button_pressed)

func _on_thief_appear_button_pressed() -> void:
	SAVEOBJECT.data.set_console_notif("thief",thiefConsoleButton.button_pressed)

func _on_thief_steal_button_pressed() -> void:
	SAVEOBJECT.data.set_console_notif("steal",stealConsoleButton.button_pressed)

func _on_tooltip_button_pressed() -> void:
	if(!tooltipButton.button_pressed):
		tooltipTheme.set_theme_item(Theme.DATA_TYPE_COLOR, "font_color", "TooltipLabel", Color.TRANSPARENT);
		tooltipTheme.set_theme_item(Theme.DATA_TYPE_STYLEBOX, "panel", "TooltipPanel", StyleBoxEmpty.new());
	else:
		tooltipTheme.set_theme_item(Theme.DATA_TYPE_COLOR, "font_color", "TooltipLabel", Color.WHITE);
		tooltipTheme.set_theme_item(Theme.DATA_TYPE_STYLEBOX, "panel", "TooltipPanel", tooltipStylebox);
	SAVEOBJECT.data.set_console_notif("tooltip",tooltipButton.button_pressed)

func _on_quit_button_pressed() -> void:
	SAVEOBJECT._save_data()
	get_tree().change_scene_to_file("res://Screens/home_menu.tscn")

extends Control

@onready var musicPercent = $VolumeSliders/PercentLabels/MusicPercent
@onready var sfxPercent = $VolumeSliders/PercentLabels/SfxPercent
@onready var codeLabel = $HBoxContainer/BoxContainer/CodeLabel


func _ready() -> void:
	$VolumeSliders/Sliders/MusicSlider.value = SAVEOBJECT.saveData.getMusicVolume()
	$VolumeSliders/Sliders/SfxSlider.value = SAVEOBJECT.saveData.getSfxVolume()

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

extends Control

@onready var musicPercent = $SoundSliders/PercentLabels/MusicPercent
@onready var sfxPercent = $SoundSliders/PercentLabels/SfxPercent
@onready var codeLabel = $HBoxContainer/BoxContainer/CodeLabel

func _on_line_edit_text_submitted(new_text: String) -> void:
	new_text = new_text.to_lower()
	match new_text:
		"sans":
			codeLabel.text = "New skin unlocked!"
		_:
			codeLabel.text = "Not a code. Try again!"


func _on_code_textbox_text_changed(_new_text: String) -> void:
	codeLabel.text = ""


func _on_music_slider_value_changed(value: float) -> void:
	musicPercent.text = str(value) + "%"


func _on_sfx_slider_value_changed(value: float) -> void:
	sfxPercent.text = str(value) + "%"

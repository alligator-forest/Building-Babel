extends Node

var musicVolume : float = 100 #percent, 0 - 200
var sfxVolume : float = 100 #percent, 0 - 200

func play_sfx(key : String):
	key = key.to_lower()
	match key:
		"brick":
			$Brick.play()
		"gold":
			pass
		"steal":
			pass
		"new floor":
			pass

func _on_music_slider_value_changed(value: float) -> void:
	$BGMusic.volume_db = linear_to_db(value)

func _on_sfx_slider_value_changed(value: float) -> void:
	sfxVolume = value

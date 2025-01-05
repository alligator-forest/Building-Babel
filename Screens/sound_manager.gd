extends Node

var musicVolume : float = 100 #percent, 0 - 200
var sfxVolume : float = 100 #percent, 0 - 200

func play_effect(key : String):
	key = key.to_lower()
	match key:
		"bricks":
			$Brick.play(55)
		"gold":
			$Gold.play()
		"steal":
			$Steal.play()
		"new floor":
			$NewFloor.play(24)

func _on_music_slider_value_changed(value: float) -> void:
	$BGMusic.volume_db = linear_to_db(value)

func _on_sfx_slider_value_changed(value: float) -> void:
	sfxVolume = value

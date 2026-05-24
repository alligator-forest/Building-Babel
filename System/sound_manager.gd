extends Node

var musicVolume : float = linear_to_db(SAVEOBJECT.data.get_music_volume()) #percent, 0 - 200
var sfxVolume : float = linear_to_db(SAVEOBJECT.data.get_sfx_volume()) #percent, 0 - 200

func play_effect(key : String):
	key = key.to_lower()
	var pitch = randf_range(0.9,1.1)
	match key:
		"bricks":
			$SFX/Brick.play(55)
			$SFX/Brick.pitch_scale = pitch
		"wood":
			$SFX/Wood.play(0.5)
			$SFX/Wood.pitch_scale = pitch
		"gold":
			$SFX/Gold.play()
			$SFX/Gold.pitch_scale = pitch
		"steal":
			$SFX/Steal.play()
			$SFX/Steal.pitch_scale = pitch
		"new floor":
			$SFX/NewFloor.play(24)
			$SFX/NewFloor.pitch_scale = pitch

func _on_music_slider_value_changed(value: float) -> void:
	$BGMusic.volume_db = linear_to_db(value)
	SAVEOBJECT.data.set_music_volume(value)

func _on_sfx_slider_value_changed(value: float) -> void:
	for s in $SFX.get_children():
		s.volume_db = linear_to_db(value)
		SAVEOBJECT.data.set_sfx_volume(value)

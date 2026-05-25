extends Node2D

func change_scene(path : String):
	show()
	$AnimationPlayer.play("exit_scene")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(path)
	hide()

func _ready() -> void:
	show()
	$AnimationPlayer.play("enter_scene")
	await $AnimationPlayer.animation_finished
	hide()

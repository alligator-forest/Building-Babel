extends Node2D

@onready var root = get_tree()

func change_scene(path : String):
	show()
	$AnimationPlayer.play("exit_scene")
	await $AnimationPlayer.animation_finished
	root.change_scene_to_file(path)
	hide()

func _ready() -> void:
	show()
	$AnimationPlayer.play("enter_scene")
	await $AnimationPlayer.animation_finished
	hide()

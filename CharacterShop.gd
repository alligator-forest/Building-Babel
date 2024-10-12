extends Node2D

@export var characters : PackedScene

var mouseWithin = false

func is_mouse_within() -> bool:
	return mouseWithin

func _on_builder_mouse_entered():
	mouseWithin = true

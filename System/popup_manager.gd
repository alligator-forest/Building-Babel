extends Node2D

@export var showTutorial : bool = false
@export var tooltipCheck : CheckBox
@export var screen1 : MarginContainer
@export var screen2 : MarginContainer

var counter : int = 0

func _ready() -> void:
	$TutorialInfo1.visible = !SAVEOBJECT.data.seen_tutorial() or showTutorial

func _on_tutorial_info_confirmed() -> void:
	get_child(counter).hide()
	counter += 1
	if(counter < get_child_count()):
		get_child(counter).show()
	else:
		_on_tutorial_info_canceled()

func _on_tutorial_info_canceled() -> void:
	SAVEOBJECT.data.set_seen_tutorial(true)
	SAVEOBJECT._save_data()

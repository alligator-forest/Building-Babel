extends Node2D

@export var tooltipCheck : CheckBox

var counter : int = 0

func _ready() -> void:
	$TutorialInfo1.visible = SAVEOBJECT.data.get_console_notif("tooltip")

func _on_tutorial_info_confirmed() -> void:
	get_child(counter).hide()
	counter += 1
	if(counter < get_child_count()):
		get_child(counter).show()
	else:
		_on_tutorial_info_canceled()

func _on_tutorial_info_canceled() -> void:
	pass # Replace with function body.

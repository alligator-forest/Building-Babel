extends Node2D

@export var showTutorial : bool = false
@export var tooltipCheck : CheckBox
@export var screen1 : MarginContainer
@export var screen2 : MarginContainer

var counter : int = 0

func _ready() -> void:
	$TutorialInfo0.visible = !SAVEOBJECT.data.seen_tutorial()

func _on_tutorial_info_confirmed() -> void:
	get_child(counter).hide()
	counter += 1
	if(counter < get_child_count()):
		get_child(counter).show()
		if(counter == 3):
			%FloorsTab.show()
		if(counter == 4):
			%ResidentsTab.show()
	else:
		_on_tutorial_info_canceled()

func _on_tutorial_info_canceled() -> void:
	SAVEOBJECT.data.set_seen_tutorial(true)
	SAVEOBJECT._save_data()

extends Node2D

@export var tooltipCheck : CheckBox

func _ready() -> void:
	$TutorialInfo.visible = SAVEOBJECT.data.get_console_notif("tooltip")

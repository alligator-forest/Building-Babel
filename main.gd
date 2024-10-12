extends Node2D

@export var tiers : PackedScene

func new_floor():
	var tier = tiers.instantiate()
	$Tower.add_child(tier)
	if($Tower.get_child_count() >= 6):
		if(!$VScrollBar.visible):
			$VScrollBar.visible = true
		$VScrollBar.max_value = $Tower.get_child_count() - 4

func _input(event):
	if event.is_action_pressed("ui_accept"):
		new_floor()

func _on_v_scroll_bar_value_changed(value):
	pass # Replace with function body.

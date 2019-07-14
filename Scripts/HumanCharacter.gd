extends "res://Scripts/Character.gd"

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("set_move_target"):
		compute_path_to_target(event.global_position)
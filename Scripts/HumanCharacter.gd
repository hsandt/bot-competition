extends "res://Scripts/Character.gd"

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("set_move_target"):
		start_move_to(event.global_position)
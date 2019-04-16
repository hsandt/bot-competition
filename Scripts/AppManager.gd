extends Node

func _input(event):
	if event.is_action_pressed("app_exit"):
		get_tree().quit()

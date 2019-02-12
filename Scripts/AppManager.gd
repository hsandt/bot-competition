extends Node

func _process(delta):
	if Input.is_action_pressed("app_exit"):
		get_tree().quit()

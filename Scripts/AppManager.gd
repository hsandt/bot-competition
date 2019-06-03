extends Node

func _ready():
	print("viewport rect: " + str(get_viewport().get_visible_rect()))
	print("Project settings dimensions: " + str(ProjectSettings.get_setting("display/window/size/width")))
	print("window size: " + str(OS.get_window_size() ))
	var displaySize = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
	var scaleFactor = OS.get_window_size() / displaySize
	print("scaleFactor: " + str(scaleFactor))
	print("hi-dpi support: reset to " + str(displaySize / scaleFactor))
	OS.set_window_size(displaySize * 2)

func _input(event):
	if event.is_action_pressed("app_exit"):
		get_tree().quit()

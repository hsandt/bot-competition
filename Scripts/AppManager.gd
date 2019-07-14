extends Node

# Parameters
var initial_size = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))

# State
var hidpi_active: bool

func _ready():
	# debug
	print("viewport rect: " + str(get_viewport().get_visible_rect()))
	print("Project settings dimensions: " + str(ProjectSettings.get_setting("display/window/size/width")))
	print("window size: " + str(OS.get_window_size() ))
	var display_size = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
	var scaleFactor = OS.get_window_size() / display_size
	print("scaleFactor: " + str(scaleFactor))
	print("display_size / scaleFactor: " + str(display_size / scaleFactor))

func _input(event):
	if event.is_action_pressed("toggle_hidpi"):
		toggle_hidpi()
		
	if event.is_action_pressed("app_exit"):
		get_tree().quit()

# note: a bug makes the window maximized after 2x size on a non-hidpi screen like 1080p,
# basically if the resulting size is bigger than the scren size (even if set_window_maximized(false)
# so we must wait a few seconds or drag the window before it becomes unmaximized and we can toggle back
# on hi-dpi, this should work fine
func toggle_hidpi():
	if hidpi_active:
		# back to normal size
		OS.set_window_size(initial_size)
	else:
		# set hi-dpi size
		OS.set_window_size(initial_size * 2)
		
	# toggle
	hidpi_active = not hidpi_active
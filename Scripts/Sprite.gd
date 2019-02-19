extends KinematicBody2D

export var speed = 2.0

var path_follow_2d = null

func _ready():
	path_follow_2d = get_parent()	

func _process(delta):
	var previous_offset = path_follow_2d.get_offset()
	print(previous_offset)
	print(str("previous_offset: ", previous_offset))
	print(str("speed: ", speed))
	print(str("delta: ", delta))
	print(str("speed * delta: ", speed * delta))
	path_follow_2d.set_offset(previous_offset + speed * delta)
	print(str("new offset: ", path_follow_2d.get_offset()))
	
extends KinematicBody2D

# Reference to common Navigation 2D for this level
onready var navigation2D: Navigation2D = get_tree().get_nodes_in_group("navigation")[0]

# Debug line showing the current path
onready var line_2D : Line2D = $Line2D

# Character speed
export var speed = 2.0

# Current navigation path
var path = []

func _ready():
	assert(line_2D != null)

func _process(delta):
	pass
	
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("set_move_target"):
		path = navigation2D.get_simple_path(global_position, event.global_position)
		line_2D.points = path
		print("path: " + str(path))
		
		# path is relative, so in case this node is not at the origin, counter the offset
		for i in range(path.size()):
			line_2D.points[i] -= navigation2D.global_position
		
		# make sure draw is called to update custom rendering besides the Line2D
		update()

func _draw():
	pass
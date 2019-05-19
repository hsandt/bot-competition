extends KinematicBody2D

# Reference to common Navigation 2D for this level
onready var navigation2D : Navigation2D = get_tree().get_nodes_in_group("navigation")[0]

# Debug line showing the current path
onready var line_2D : Line2D = navigation2D.get_node("Line2D")

# Character speed
export var speed = 2.0

# Current navigation path
var path : Array = []

# Should the character move on the path now?
var moving : = false

# Current distance on path, from start to end point
var current_distance : float = 0.0

func _ready():
	# for some reason, adding node to root doesn't work,
	# so I use a preconstructed Line2D under navigation2D
#	line_2D = Line2D.new()
#	get_tree().get_root().add_child(line_2D)
	pass

func _process(delta):
	if moving:
		current_distance += speed * delta
		# for now, direct motion (may go into walls!)
		global_position = get_point_on_path(current_distance)

func get_point_on_path(distance):
	# first point
	if distance <= 0:
		return path[0]
		
	for i in range(len(path) - 1):
		var segment_length = path[i].distance_to(path[i + 1])
		if distance <= segment_length:
			# we are on segment [i, i+1]
			return path[i].linear_interpolate(path[i + 1], distance / segment_length)
		else:
			# we must check the next segment with the remaining distance after this one
			distance -= segment_length
			
	# last point, stop moving
	moving = false
	
	var last_point = path[-1]
	path.clear()
	update_debug_line()
	
	return last_point
	
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("set_move_target"):
		# compute path to target (cursor) position
		path = navigation2D.get_simple_path(global_position, event.global_position)
		
		# reset current point index
		moving = true
		current_distance = 0.0
		
		update_debug_line()

func update_debug_line():
	line_2D.points = path
	
	# path is relative, so in case this node is not at the origin, counter the offset
	for i in range(path.size()):
		line_2D.points[i] -= navigation2D.global_position

func pick_palet(palet):
	print("Pick palet: " + str(palet.name))
	palet.queue_free()

func _draw():
	pass
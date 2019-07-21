extends KinematicBody2D

# Reference to common Navigation 2D for this level
var navigation2D : Navigation2D

# Debug line showing the current path
var line_2D : Line2D

# Character speed (px/s)
export var speed = 100.0

# Current navigation path
var path : Array = []

# Should the character move on the path now?
var moving : = false

# Current distance on path, from start to end point
var current_distance : float = 0.0

func _ready():
	var navigation_group = get_tree().get_nodes_in_group("navigation")
	# will fail when playing Character prefab scene alone, don't do that!
	assert(not navigation_group.empty())
	navigation2D = navigation_group[0]
	# FIXME: support multiple characters by providing multiple debug lines
	line_2D = navigation2D.get_node("Line2D")
	
	# for some reason, adding node to root doesn't work,
	# so I use a preconstructed Line2D under navigation2D
#	line_2D = Line2D.new()
#	get_tree().get_root().add_child(line_2D)

	# initial update to clear debug line
	update_debug_line()

func _process(delta):
	if moving:
		current_distance += speed * delta
		
		# for now, direct motion (may go into walls! count on collision to block)
		var point_result = get_point_on_path(current_distance)
		global_position = point_result[0] 
		var reached_end = point_result[1]
		if reached_end:
			# last point reached, stop moving and clear path
			moving = false
			path.clear()
			update_debug_line()

func start_move_to(target_position):
	"""Compute a path to a new target position and start moving"""
	
	# compute path to target position
	path = navigation2D.get_simple_path(global_position, target_position)
	
	# start moving from the beginning of the path
	moving = true
	current_distance = 0.0
	
	update_debug_line()

func get_point_on_path(distance):
	"""
	Return an array [point: Vector2, reached_end: bool] where:
		- point is the position on the current path at `distance` from the start
		- reached_end is true iff the point is the end of the current path
		
	"""
	
	# first point
	if distance <= 0:
		return [path[0], false]
		
	for i in range(len(path) - 1):
		var segment_length = path[i].distance_to(path[i + 1])
		
		# we use < instead of <= just so that, in case distance reaches exactly the total path distance
		# this frame, we can immediately return with reached_end: true more below instead of waiting next frame
		if distance < segment_length:
			# we are on segment [i, i+1]
			return [path[i].linear_interpolate(path[i + 1], distance / segment_length), false]
		else:
			# we must check the next segment with the remaining distance after this one
			distance -= segment_length
	
	return [path[-1], true]

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
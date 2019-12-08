extends KinematicBody2D
class_name Character

## References

onready var game_manager = $"/root/Root/GameManager"

# Reference to common Navigation 2D for this level
var navigation2D : Navigation2D

# Debug line showing the current path
var line_2D : Line2D

## Parameters

# Character speed (px/s)
export var speed = 100.0

## State

# Current navigation path
var path : PoolVector2Array = []

# Should the character move on the path now?
var moving : = false

# Current distance on path, from start to end point
var current_distance : float = 0.0

# We MUST initialize the array to []
# or the array will initialize to some common []
# shared across Character instances (like exported arrays becoming static)
# causing havoc in Character behaviour
# Note that for now, we only allow 1 palet at a time, the array is only
#   to allow more later.
var picked_palets: Array = []

func _ready():
	# will fail when playing Character prefab scene alone, don't do that!
	navigation2D = Utils.get_single_node_by_tag(self, "navigation")
	line_2D = navigation2D.get_node("Line2D")
	
	# for some reason, adding node to root doesn't work,
	# so I use a preconstructed Line2D under navigation2D
#	line_2D = Line2D.new()
#	get_tree().get_root().add_child(line_2D)

	game_manager.emit_signal("register_character", self)

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
			path.resize(0)  # like Array.clear, but for PoolVector2Array
			update_debug_line()
		
		# Call _draw
		update()

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
	pass
#
#	line_2D.points = path
#
#	# path is relative, so in case this node is not at the origin, counter the offset
#	for i in range(path.size()):
#		line_2D.points[i] -= navigation2D.global_position

func try_pick_palet(palet) -> bool:
	# Character can only pick one palet at a time
	if not picked_palets.empty():
		# Failure (not code error, normal game behavior)
		return false
		
	# reparent palet to this character (character starts dragging palet)
	palet.get_parent().remove_child(palet)
	add_child(palet)
	
	# Characters have no forward direction/grabbing anchor so for now,
	#   just place the palet at a fixed offset
	palet.position = Vector2(10, 10)
	picked_palets.append(palet)
	
	# Set picker ref on palet side
	palet.picker = self
	
	print("[Character] " + name + " picks " + palet.name)
	
	# Notify
	game_manager.emit_signal("character_picked_palet", self, palet)
	
	# Success
	return true

func drop_palet(palet):
	var palet_index = picked_palets.find(palet)
	assert(palet_index != -1)
	picked_palets.remove(palet_index)
	
	# Reparent
	remove_child(palet)
	# probably add palet as child to some container box, or maybe just the arena
	
	# Clear ref
	palet.picker = null
	
	# Notify
	game_manager.emit_signal("character_dropped_palet", self, palet)
	
	print("[Character] " + name + " drops " + palet.name)

func _draw():
	# map navigation offset subtraction to copy of path (Pools are passed by value)
	var offset_path = path
	
	# new version using just draw_multiline, which is relative to Node2D position
	# looks like line_drawer.draw_multiline doesn't work despite line_drawer
	# being at the origin, so we must manually subtract the global position
	for i in range(len(offset_path)):
		offset_path[i] -= global_position
		pass
	
	# do not check if OS.is_debug_build() as we want to show navigation paths
	# in release too, for AI demonstration
	draw_multiline(offset_path, Color.red)
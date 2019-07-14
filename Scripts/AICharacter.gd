extends "res://Scripts/Character.gd"

# References
var goal: Node2D

# State
var located_goal: bool

func _ready():
	var goal_group = get_tree().get_nodes_in_group("goal")
	assert(not goal_group.empty())
	goal = goal_group[0]

func _process(delta):
	# run logic
	if not located_goal:
		# locate and target goal
		compute_path_to_target(goal.global_position)
extends "res://Scripts/Character.gd"

# References
var goal: Node2D

# State
enum Phase {
	PickPalets,
	MoveToGoal
}

var phase: int  # Phase

func _ready():
	var goal_group = get_tree().get_nodes_in_group("goal")
	assert(not goal_group.empty())
	goal = goal_group[0]

func setup():
	phase = Phase.PickPalets

func _process(delta):
	# run logic
	match phase:
		Phase.PickPalets:
			var next_palet = find_next_palet()
			if next_palet != null:
				start_move_to(next_palet.global_position)
			else:
				phase = Phase.MoveToGoal
			print("picking")
		Phase.MoveToGoal:
			start_move_to(goal.global_position)
		
func find_next_palet() -> Node2D:
	var palets = get_tree().get_nodes_in_group("palet")
	if palets.empty():
		return null
	else:
		return palets[0]
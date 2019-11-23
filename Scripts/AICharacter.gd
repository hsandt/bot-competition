extends "res://Scripts/Character.gd"

# References

var goal: Node2D

# State

enum Phase {
	Standby,
	PickPalet,
	DropPaletInGoal,
	MoveToGoal
}

var phase: int  # Phase

var next_palet: Palet = null

func _ready():
	var goal_group = get_tree().get_nodes_in_group("goal")
	assert(not goal_group.empty())
	goal = goal_group[0]
	game_manager.connect("character_picked_palet", self, "_on_character_picked_palet")
	game_manager.connect("character_dropped_palet", self, "_on_character_dropped_palet")

func setup():
	phase = Phase.Standby

func _process(delta):
	# run logic
	match phase:
		Phase.Standby:
			assert(not picked_palets)
			# search next objective
			next_palet = find_next_palet()
			if next_palet != null:
				start_move_to(next_palet.global_position)
				phase = Phase.PickPalet
				print("[AI] " + name + " found next palet " + next_palet.name + ". Moving toward it.")
			else:
				# nothing left to do, move to goal (in practice, game will end as soon as
				# last palet has been dropped, but if expected count is too high then it may happen)
				start_move_to(goal.global_position)
				phase = Phase.MoveToGoal
				print("[AI] " + name + " has nothing to do, moving toward Goal.")
		Phase.PickPalet:
			# continue moving toward palet as planned
			# (signal will handle the transition)
			pass
		Phase.DropPaletInGoal:
			# continue moving toward goal as planned 
			# (signal will handle the transition)
			pass
		Phase.MoveToGoal:
			# continue moving toward goal as planned 
			pass

func find_next_palet() -> Node2D:
	var palets = get_tree().get_nodes_in_group("palet")
	
	# for now, just return first palet in the list
	# later, prefer closest one
	for palet in palets:
		if not palet.picker:
			return palet
	
	return null
	
func _on_character_picked_palet(character, palet):
	# are we the one picking the palet?
	if character == self:
		# whatever the current phase is, dropping that palet to the goal
		#   becomes the new priority
		# clear next palet, whether it was actually palet as intended, or something else
		#   or even already null
		next_palet = null
		start_move_to(goal.global_position)
		phase = Phase.DropPaletInGoal
		print("[AI] " + name + " moves toward Goal to drop picked palet.")
	elif phase == Phase.PickPalet and next_palet == palet:
		# another bot picked our target palet before we did!
		# give up and go back to Standby
		phase = Phase.Standby
		print("[AI] " + name + " noticed that " + character.name + " picked " + palet.name +
			" which it was aiming for. Falling back to Standby.")
			
func _on_character_dropped_palet(character, palet):
	# are we the one picking the palet? and was this our current goal?
	if character == self and phase == Phase.DropPaletInGoal:
		# objective reached, go back to standby
		phase = Phase.Standby
		print("[AI] " + name + " -> Standby")
		
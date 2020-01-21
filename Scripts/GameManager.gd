extends Node

# Signals
signal register_character
signal character_picked_palet
signal character_dropped_palet

# Gameplay parameters
export var palets_to_drop_count = 4

# State
var total_dropped_palets = 0
var score_by_character = {}

func _ready():
	# note that those signals are bound to methods directly defined on GameManager,
	#   so we could also just call game_manager.do_stuff()
	#   instead of game_manager.emit_signal(...)
	# for now we keep it, in case methods move to some ScoreManager
	connect("register_character", self, "_on_register_character")
	connect("character_dropped_palet", self, "_on_character_dropped_palet")

func _on_register_character(character):
	# make sure stats are initialized for this character so we can modify them later
	score_by_character[character.id] = 0
	print("[GameManager] Registered character " + character.name + "(" + str(character.id) + ")")

func _on_character_dropped_palet(character, palet):
	score_by_character[character.id] += 1
	total_dropped_palets += 1
	print("[GameManager] Character " + character.name + " dropped palet " + palet.name +
		". New score for character: " + str(score_by_character[character.id]) + ". Total dropped: " + str(total_dropped_palets))
	if total_dropped_palets == palets_to_drop_count:
		# Finish game and show results screen
		get_tree().change_scene("res://Scenes/Result.tscn")
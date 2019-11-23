extends Node

# Signals
signal character_picked_palet
signal character_dropped_palet

# Gameplay parameters
export var palets_to_drop_count = 4

# State
var dropped_palets = 0

func _ready():
	connect("character_dropped_palet", self, "_on_character_dropped_palet")

func _on_character_dropped_palet(character, palet):
	dropped_palets = dropped_palets + 1
	print("[GameManager] Character " + character.name + " dropped palet " + palet.name +
		". Total dropped: " + str(dropped_palets))
	if dropped_palets == palets_to_drop_count:
		# Finish game and show results screen
		get_tree().change_scene("res://Scenes/Result.tscn")
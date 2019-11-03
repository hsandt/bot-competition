extends Node2D
class_name Palet

## State

var picker: Character = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	print("Palet._on_Area2D_body_entered: " + body.name)
	# if not picked yet, touching Character can pick it
	if not picker:
		# duck-type Character for being able to pick palet
		if body.has_method("try_pick_palet"):
			body.try_pick_palet(self)
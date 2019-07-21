extends Node2D
class_name Palet

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	# duck-type Character for being able to pick palet
	if body.has_method("pick_palet"):
		body.pick_palet(self)
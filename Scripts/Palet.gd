extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	# don't get_script, use the node directly
	if body.has_method("pick_palet"):
		body.pick_palet(self)
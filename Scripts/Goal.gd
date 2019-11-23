extends Node2D

# Signal for Goal Area2D, but detecting Palet KinematicBody2D, which is only
# used to be dropped. Unfortunately, both Palet Area2D and KinematicBody2D
# are required as Kinematic/Kinematic collision is not supported
# so character couldn't pick palet without Area2D.
func _on_Area2D_body_entered(body):
	var palet = body.get_parent() as Palet
	if palet:
		var picker = palet.picker as Character
		if picker:
			picker.drop_palet(palet)

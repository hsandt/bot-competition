extends KinematicBody2D


func _physics_process(delta):
	var velocity = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = 100
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -100
		
	if Input.is_action_pressed("ui_up"):
		velocity.y = -100
	elif Input.is_action_pressed("ui_down"):
		velocity.y = 100
		
	move_and_slide(velocity)
		

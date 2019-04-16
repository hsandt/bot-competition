extends Navigation2D

export var radius = 2

var path = []

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _input(event):
	if event.is_action_pressed("set_move_target"):
		print(event.position)
		var end = event.position
		for player in get_tree().get_nodes_in_group("player"):
			path = get_simple_path(player.position, end)
			print(path)
			update()

func _draw():
	for p in path:
		draw_circle(p, radius, ColorN("white"))

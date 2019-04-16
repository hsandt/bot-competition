extends Navigation2D

export var radius = 2

onready var line_2D : Line2D = $Line2D

var path = []

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("set_move_target"):
		for player in get_tree().get_nodes_in_group("player"):
			print(player.global_position)
			print(event.global_position)
			path = get_simple_path(player.global_position, event.global_position)
			line_2D.points = path
			# path is relative, so in case this node is not at the origin, counter the offset
			for i in range(path.size()):
				line_2D.points[i] -= global_position
			print(path)
			update()

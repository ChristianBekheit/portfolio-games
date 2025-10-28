extends Node2D

@onready var camera: Camera2D = $Path2D/PathFollow2D/Camera2D
@onready var pathfollower = $Path2D/PathFollow2D

var is_openingscene = false
var has_player_entered = false
var player = null
var is_pathfollowing = false


func _physics_process(delta: float) -> void:
	if is_openingscene and is_pathfollowing:
		var speed = .001 
		# Change speed at specific progress values
		if pathfollower.progress_ratio >= 0.0 and pathfollower.progress_ratio < 0.273:
			speed = 0.003
		elif pathfollower.progress_ratio >= 0.274 and pathfollower.progress_ratio < 0.334:
			speed = 0.0007  # Slow down
		elif pathfollower.progress_ratio >= 0.334 and pathfollower.progress_ratio < 0.434:
			speed = .001 # Slow down
		elif pathfollower.progress_ratio >= 0.5 and pathfollower.progress_ratio < 0.6:
			speed = 0.005  # Speed up
		elif pathfollower.progress_ratio >= 0.7 and pathfollower.progress_ratio < 0.71:
			speed = 0.1  # Pause
			# You can also run a timer here if you want to wait

		pathfollower.progress_ratio += speed
		
		if pathfollower.progress_ratio >= .9:
			cutscene_ending()
		if pathfollower.progress_ratio == 0.27:
			await get_tree().create_timer(1).timeout

func _on_playdetect_body_entered(body):
	if  body.is_in_group("player") and not has_player_entered and not is_openingscene:
		has_player_entered = true
		player = body
		cutscene_opening()
		
		
func cutscene_opening():
	is_openingscene = true
	is_pathfollowing = true
	pathfollower.progress_ratio = 0
	
	# Disable player camera
	var player_cam = player.get_node_or_null("Camera2D")
	if player_cam:
		player_cam.enabled = false
	# Enable and activate cutscene camera
	camera.enabled = true
	camera.make_current()

	# Disable player input
	player.can_move = false
	print_stack()

func cutscene_ending():
	is_pathfollowing = false
	is_openingscene = false

	# Fully disable the cutscene camera
	camera.enabled = false

	# Switch back to player camera
	var player_cam = player.get_node_or_null("Camera2D")
	if player_cam:
		player_cam.enabled = true
		player_cam.make_current()

	# Restore player control
	player.can_move = true


	

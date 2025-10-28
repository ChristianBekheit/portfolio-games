extends Node2D

@onready var animation_player: AnimationPlayer = $"opening cutscene/AnimationPlayer"
@onready var camera: Camera2D = $"opening cutscene/Path2D/PathFollow2D/Camera2D"

var is_openingscene = false

var has_player_enetered = false
var player = null

var is_pathfollowing = false

func _physics_process(delta: float) -> void:
	if is_openingscene:
		var pathfollower  = $"opening cutscene/Path2D/PathFollow2D"
		
		if is_pathfollowing:
			pathfollower.progress_ratio += 0.001
			
			if pathfollower.progress_ratio >= 1:
				cutsceneending()


func _on_playdetect_body_entered(body):
	if body.has_method("Player"):
		player = body
		if !has_player_enetered:
			has_player_enetered = true
			cutsceneopeneing()
			
func cutsceneopeneing():
	is_openingscene = true
	animation_player.play("open")
	player.camera.enabled = false
	#enable our own camera
	camera.enabled = true
	is_pathfollowing = true
	
func cutsceneending():
	is_pathfollowing = false
	is_openingscene = false
	camera.enabled = false
	player.camera.enabled = true

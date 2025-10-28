extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 200
const JUMP_VELOCITY = -350.0

@onready var camera_2d: Camera2D = $Camera2D

var can_move := true

func _physics_process(delta: float) -> void:
	if can_move:
		# Apply gravity
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Input direction (-1, 0, 1)
		var direction := Input.get_axis("left", "right")

		# Flip sprite
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true

		# Play animations
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")

		# Apply horizontal movement
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		# Stop all motion and animation
		velocity = Vector2.ZERO
		animated_sprite.play("idle")

	move_and_slide()


func _on_playdetect_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

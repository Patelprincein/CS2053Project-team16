extends CharacterBody2D


const speed = 50
const GRAVITY = 300  # Gravity
const fly_speed = 500

func _physics_process(delta: float) -> void:
	
	velocity.x = 0
	
	# Horizontal movement
	if Input.is_action_pressed("left"):
		velocity.x = -speed
		$AnimationPlayer.play("walk")
		if scale.x > 0:  # If currently facing right, flip to face left
			scale.x = -1
	if Input.is_action_pressed("right"):
		velocity.x = speed
		$AnimationPlayer.play("walk")
		if scale.x < 0:  # If currently facing left, flip to face right
			scale.x = 1

	# Flying (up key)
	if Input.is_action_pressed("up"):
		velocity.y -= fly_speed * delta
		$Body/ChestSprite/LLeg/LJet.visible = true
		$Body/ChestSprite/RLeg/RJet.visible = true
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			$AnimationPlayer.play("Fly")  # Play "fly" when moving and flying
		else:
			$AnimationPlayer.play("idle")  # Play "idle" when flying but not moving
	else:
		# Disable jets when not flying
		$Body/ChestSprite/LLeg/LJet.visible = false
		$Body/ChestSprite/RLeg/RJet.visible = false
	
	velocity.y += GRAVITY* delta
	move_and_slide()

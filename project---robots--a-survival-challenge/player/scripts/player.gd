extends CharacterBody2D

# Variables for aiming
const rotation_speed = 50.0  # Speed for rotating the Left_arm (degrees per second)
const min_angle = -75.0  # Minimum rotation angle (upwards limit)
const max_angle = 75.0   # Maximum rotation angle (downwards limit)

const speed = 200
const GRAVITY = 4  # Gravity
const fly_speed = 300

func _ready():
	# Set LJet and RJet to be invisible initially
	$"Player-Body/Body/ChestSprite/LLeg/LJet".visible = false
	$"Player-Body/Body/ChestSprite/RLeg/RJet".visible = false

func _process(delta):
	# Reference the Left_arm node
	var left_arm = $"Player-Body"/Left_arm
	
	# Rotate the Left_arm based on input (W/S keys)
	#if Input.is_action_pressed("arm_up"):  # W key
	#	left_arm.rotation_degrees -= rotation_speed * delta
	#elif Input.is_action_pressed("arm_down"):  # S key
	#	left_arm.rotation_degrees += rotation_speed * delta

	# Clamp the rotation angle within the specified range
	#left_arm.rotation_degrees = clamp(left_arm.rotation_degrees, min_angle, max_angle)

func _physics_process(delta: float) -> void:
			# Horizontal movement
	if Input.is_action_pressed("left"):
		velocity.x -= speed
		$AnimationPlayer.play("walk")
		if scale.x > 0:  # If currently facing right, flip to face left
			scale.x = -1
	elif Input.is_action_pressed("right"):
		velocity.x += speed
		$AnimationPlayer.play("walk")
		if scale.x < 0:  # If currently facing left, flip to face right
			scale.x = 1
	
		# Flying (up key)
	if Input.is_action_pressed("up"):
		velocity.y -= fly_speed
		$"Player-Body/Body/ChestSprite/LLeg/LJet".visible = true
		$"Player-Body/Body/ChestSprite/RLeg/RJet".visible = true
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			$"Player-Body/AnimationPlayer".play("Fly")  # Play "fly" when moving and flying
		else:
			$"Player-Body/AnimationPlayer".play("idle")  # Play "idle" when flywwwing but not moving
	else:
		# Disable jets when not flying
		$"Player-Body/Body/ChestSprite/LLeg/LJet".visible = false
		$"Player-Body/Body/ChestSprite/RLeg/RJet".visible = false

	# Apply gravity
	if not Input.is_action_pressed("up"):
		velocity.y += GRAVITY

	# Apply the movement
	position += velocity * delta

func _input(event):
	# Fire bullet if the player presses the shoot key
	if event.is_action_pressed("shoot"):  # Make sure "shoot" is added in Input Map
		$"Player-Body"/Left_arm/Gun._fire_bullet()

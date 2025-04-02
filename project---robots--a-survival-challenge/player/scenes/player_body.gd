extends CharacterBody2D


const speed = 100
const GRAVITY = 300  # Gravity
const fly_speed = 500
const JUMP_FORCE = 200

var left_arm
var body_scale_x

func _ready() -> void:
	left_arm = $Body/Left_arm
	$Body/ChestSprite/RLeg/RJet.visible = false
	$Body/ChestSprite/LLeg/LJet.visible = false
	body_scale_x = $Body.scale.x

func _process(delta):
	if $Body.scale.x > 0: # looking right
		left_arm.rotation = (get_global_mouse_position() - left_arm.global_position).angle()
	else: # looking left
		var dir = get_global_mouse_position() - left_arm.global_position
		dir.x = -dir.x
		left_arm.rotation = dir.angle()

func _physics_process(delta: float) -> void:
	
	velocity.x = 0
	
	# Moving Left ([LEFT]/[A])
	if Input.is_action_pressed("left"):
		velocity.x = -speed
		$AnimationPlayer.play("walk")
		if $Body.scale.x > 0:
			$Body.scale.x = -body_scale_x
	
	# Moving Right ([RIGHT]/[D])
	if Input.is_action_pressed("right"):
		velocity.x = speed
		$AnimationPlayer.play("walk")
		if $Body.scale.x < 0:
			$Body.scale.x = body_scale_x
	
	# Not Moving
	if not Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		$AnimationPlayer.play("idle")
	
	# Jump ([SPACE])
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = -JUMP_FORCE
	
	# Flying ([UP]/[W])
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
	
	# Add Gravity
	velocity.y += GRAVITY * delta
	
	move_and_slide()

func _input(event):
	# Fire ([LEFT_MOUSE_CLICK])
	if event.is_action_pressed("shoot"):
		$Body/Left_arm/Gun._fire_bullet()

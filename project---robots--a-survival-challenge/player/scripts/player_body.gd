extends CharacterBody2D

const speed = 100

@export var GRAVITY = 250  # Gravity
@export var fly_speed = 500
const JUMP_FORCE = 200

var left_arm
var body_scale_x

var can_move: bool
var can_end: bool

var tdleta
var flight_energy = 100.0

@onready var energy_bar = $FlightEnergyBar
@export var health: int = 20


func _ready() -> void:
	left_arm = $Body/Left_arm
	visible_jets(false)
	body_scale_x = $Body.scale.x
	can_end = false


@warning_ignore("unused_parameter")
func _process(dleta):
	if $Body.scale.x > 0:
		left_arm.rotation = (get_global_mouse_position() - left_arm.global_position).angle()
	else:
		var dir = get_global_mouse_position() - left_arm.global_position
		dir.x = -dir.x
		left_arm.rotation = dir.angle()


func _physics_process(delta: float) -> void:
	velocity.x = 0

	if (((left_arm.rotation_degrees < -90 && left_arm.rotation_degrees > -180) || (left_arm.rotation_degrees < 180 && left_arm.rotation_degrees > 90)) && ((get_global_mouse_position().x - left_arm.global_position.x) < 0)):
		$Body.scale.x = -$Body.scale.x
	if (((left_arm.rotation_degrees < -90 && left_arm.rotation_degrees > -180) || (left_arm.rotation_degrees < 180 && left_arm.rotation_degrees > 90)) && ((get_global_mouse_position().x - left_arm.global_position.x) > 0)):
		$Body.scale.x = -$Body.scale.x
	if can_move and Input.is_action_pressed("left"):
		velocity.x = -speed
		$AnimationPlayer.play("walk")
		#if $Body.scale.x > 0:
		#	$Body.scale.x = -body_scale_x
	
	# Moving Right ([RIGHT]/[D])
	if can_move and Input.is_action_pressed("right"):
		velocity.x = speed
		$AnimationPlayer.play("walk")
		#if $Body.scale.x < 0:
		#	$Body.scale.x = body_scale_x
	
	# Not Moving
	if not Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		$AnimationPlayer.play("idle")
	
	# Jump ([SPACE])
	if can_move and is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = -JUMP_FORCE
	
	# Flying ([UP]/[W])
	if can_move and Input.is_action_pressed("up"):
		velocity.y -= fly_speed * delta
		$Body/ChestSprite/LLeg/LJet.visible = true
		$Body/ChestSprite/RLeg/RJet.visible = true

		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			$AnimationPlayer.play("Fly")
		else:
			$AnimationPlayer.play("idle")
	else:
		visible_jets(false)
	velocity.y += GRAVITY * delta
	move_and_slide()

func _input(event):
	# Fire ([LEFT_MOUSE_CLICK])
	if event.is_action_pressed("shoot"):
		$Body/Left_arm/Gun._fire_bullet()

func got_hit():
	health -= 1
	$HealthBar.value = health
	if health <= 0:
		
		get_tree().reload_current_scene()

func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.is_in_group("enemyBullet"):
		got_hit()
		area.queue_free()

func visible_jets(ans):
	$Body/ChestSprite/RLeg/RJet.visible = ans
	$Body/ChestSprite/LLeg/LJet.visible = ans

func player_faces():
	if (((left_arm.rotation_degrees < -90 && left_arm.rotation_degrees > -180) || (left_arm.rotation_degrees < 180 && left_arm.rotation_degrees > 90)) && ((get_global_mouse_position().x - left_arm.global_position.x) < 0)):
		$Body.scale.x = -$Body.scale.x
	if (((left_arm.rotation_degrees < -90 && left_arm.rotation_degrees > -180) || (left_arm.rotation_degrees < 180 && left_arm.rotation_degrees > 90)) && ((get_global_mouse_position().x - left_arm.global_position.x) > 0)):
		$Body.scale.x = -$Body.scale.x


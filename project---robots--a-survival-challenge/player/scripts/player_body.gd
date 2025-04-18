extends CharacterBody2D

const speed = 100
const JUMP_FORCE = 200

@export var GRAVITY = 250
@export var fly_speed = 40
@onready var energy_bar = $FlightEnergyBar
@onready var health_bar = $HealthBar

var health = 50.0
var left_arm
var body_scale_x
var can_move = false
var flight_energy = 100.0

func _ready() -> void:
	left_arm = $Body/Left_arm
	body_scale_x = $Body.scale.x
	visible_jets(false)
	$FlightEnergyBar.max_value = flight_energy
	$FlightEnergyBar.value = flight_energy
	$HealthBar.max_value = health
	$HealthBar.value = health


@warning_ignore("unused_parameter")
func _process(dleta):
	if can_move:
		if $Body.scale.x > 0:
			left_arm.rotation = (get_global_mouse_position() - left_arm.global_position).angle()
		else:
			var dir = get_global_mouse_position() - left_arm.global_position
			dir.x = -dir.x
			left_arm.rotation = dir.angle()


func _physics_process(delta: float) -> void:
	velocity.x = 0
	if can_move and health < 50:
		health += 0.7 * delta
		health_bar.value = health
	if can_move:
		player_faces()
	# Moving Right ([LEFT]/[A])
	if can_move and Input.is_action_pressed("left"):
		velocity.x = -speed
		$AnimationPlayer.play("walk")
	
	# Moving Right ([RIGHT]/[D])
	if can_move and Input.is_action_pressed("right"):
		velocity.x = speed
		$AnimationPlayer.play("walk")
	
	# Jump ([SPACE])
	if can_move and is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = -JUMP_FORCE
	
	if not Input.is_action_pressed("up") and can_move:
		if flight_energy < 100:
			flight_energy += 0.8
			energy_bar.value = flight_energy
		
	# Flying ([UP]/[W])
	if can_move and Input.is_action_pressed("up") and flight_energy > 0:
		velocity.y -= fly_speed * 0.18
		
		# Fuel uses to Fly
		flight_energy -= 0.5
		energy_bar.value = flight_energy
		
		# Jets visible
		visible_jets(true)
		
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			$AnimationPlayer.play("Fly")
		else:
			$AnimationPlayer.play("idle")
	else:
		# Jets invisible
		visible_jets(false)
	
	
	velocity.y += GRAVITY * delta
	move_and_slide()


func _input(event):
	if event.is_action_pressed("shoot"):
		$Body/Left_arm/Gun._fire_bullet()


func got_hit():
	health -= 1
	$HealthBar.value = health
	if health <= 0:
		get_tree().reload_current_scene()


func _on_area_2d_area_entered(area):
	if area.is_in_group("enemyBullet"):
		got_hit()
		area.queue_free()


func visible_jets(val):
	$Body/ChestSprite/RLeg/RJet.visible = val
	$Body/ChestSprite/LLeg/LJet.visible = val


func player_faces():
	if can_move:
		if get_global_mouse_position().x < global_position.x:
			$Body.scale.x = -abs(body_scale_x) # Ensure it's flipped
		else:
			$Body.scale.x = abs(body_scale_x)  # Ensure it's not flipped

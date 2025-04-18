extends CharacterBody2D

const speed = 100
const GRAVITY = 250
const fly_speed = 40
const JUMP_FORCE = 200

var left_arm
var body_scale_x
var tdleta
var flight_energy = 100.0

@onready var energy_bar = $FlightEnergyBar
@export var health: int = 20

func _ready() -> void:
	left_arm = $Body/Left_arm
	visible_jets(false)
	body_scale_x = $Body.scale.x
	$FlightEnergyBar.max_value = flight_energy
	$FlightEnergyBar.value = flight_energy
	$HealthBar.max_value = health
	$HealthBar.value = health

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
	player_faces()
	if Input.is_action_pressed("left"):
		velocity.x = -speed
		$AnimationPlayer.play("walk")
	if Input.is_action_pressed("right"):
		velocity.x = speed
		$AnimationPlayer.play("walk")

	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = -JUMP_FORCE
	
	if not Input.is_action_pressed("up"):
		if flight_energy < 100:
			flight_energy += 0.8 * delta * 60
			energy_bar.value = flight_energy
	
	if Input.is_action_pressed("up") and flight_energy > 0:
		velocity.y -= fly_speed * 0.18
		visible_jets(true)
		flight_energy -= 0.5
		energy_bar.value = flight_energy
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

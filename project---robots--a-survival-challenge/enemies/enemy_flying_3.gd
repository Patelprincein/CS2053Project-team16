extends CharacterBody2D

var speed: int = 70
var patrolling: bool = true
var seePlayer: bool = false
var raycast_length: float = 300.0
var last_pos: Vector2

var rotation_speed: float = 2.0

var bullet_scene = preload("res://enemies/enemy_bullet.tscn")

@export var player: Node2D
@export var health: int = 5
@onready var pathfollow: PathFollow2D = get_parent()


func _ready() -> void:
	$HealthBar.max_value = health
	$HealthBar.value = health


func _physics_process(delta: float) -> void:
	last_pos = global_position
	
	if patrolling:
		patrol(delta)
	else:
		if seePlayer:
			shooting_motion()
		else:
			return_to_path()
	
	check_if_sees_player()
	set_animation(delta)


# Patrol around the Path2D line
func patrol(delta):
	velocity = Vector2.ZERO
	pathfollow.progress += speed * delta
	global_position = pathfollow.global_position


# Raycast a ray to the player
func check_if_sees_player():
	var direction = (player.global_position - global_position).normalized()
	$RayCast2D.target_position = direction * raycast_length
	
	
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		
		if collider and collider.is_in_group("player"):
			patrolling = false
			seePlayer = true
			return
	
	seePlayer = false


# Shoot the player
func shooting_motion():
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func shoot():
	
	for i in range(4):
		var bullet = bullet_scene.instantiate()
		
		bullet.global_position = position
		bullet.direction = Vector2.RIGHT.rotated($Body.rotation + (i*PI/2)).normalized()
		get_parent().add_child(bullet)


# Return to Path
func return_to_path():
	var direction = (pathfollow.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
	if global_position.distance_to(pathfollow.global_position) < 1:
		patrolling = true
		global_position = pathfollow.global_position


# Set Animation
func set_animation(delta):
	$Body.rotation += delta * rotation_speed

# Ouch
func got_hit():
	health -= 1
	$HealthBar.value = health
	if health <= 0:
		queue_free()



func _on_bullet_timer_timeout() -> void:
	if seePlayer:
		shoot()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("playerBullet"):
		got_hit()
		area.queue_free()

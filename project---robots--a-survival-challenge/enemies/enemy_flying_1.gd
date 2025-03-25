extends CharacterBody2D

var speed: int = 70
var patrolling: bool = true
var seePlayer: bool = false
var raycast_length: float = 300.0
var last_pos: Vector2

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
	set_animation()


# Patrol around the Path2D line
func patrol(delta):
	velocity = Vector2.ZERO
	pathfollow.progress += speed * delta
	if pathfollow.progress_ratio >= 0.5:
		$AnimatedSprite2D.play("left")
	else:
		$AnimatedSprite2D.play("right")
	
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
			$AnimatedSprite2D.play("idle")
			return
	
	seePlayer = false


# Shoot the player
func shooting_motion():
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func shoot():
	var bullet = bullet_scene.instantiate()
	
	bullet.global_position = position
	bullet.direction = (player.global_position - global_position).normalized()
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
func set_animation():
	var v: Vector2
	if velocity == Vector2.ZERO:
		v = (global_position - last_pos) * 20.0
	else:
		v = velocity
	
	
	var vertical_threshold: float = 10.0
	
	if abs(v.y) < vertical_threshold:
		if v.x < 0:
			$AnimatedSprite2D.play("idle-left")
		else:
			$AnimatedSprite2D.play("idle-right")
	else:
		if v.y < 0:
			if v.x < 0:
				$AnimatedSprite2D.play("up-left")
			else:
				$AnimatedSprite2D.play("up-right")
		else:
			if v.x < 0:
				$AnimatedSprite2D.play("down-left")
			else:
				$AnimatedSprite2D.play("down-right")

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
		area.get_parent().queue_free()

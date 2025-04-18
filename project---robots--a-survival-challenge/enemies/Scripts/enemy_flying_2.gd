extends CharacterBody2D

var speed: int = 70
var attack_speed: int = 140
var patrolling: bool = true
var seePlayer: bool = false
var raycast_length: float = 300.0
var last_pos: Vector2

var bullet_scene = preload("res://enemies/Scenes/enemy_bullet.tscn")
var score_label

@export var player: Node2D
@export var health: int = 5
@onready var pathfollow: PathFollow2D = get_parent()


func _ready() -> void:
	$HealthBar.max_value = health
	$HealthBar.value = health
	score_label = get_parent().get_parent().get_parent().get_parent().get_node("Camera2D").get_node("ScoreLabel")


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
	global_position = pathfollow.global_position


# Raycast a ray to the player
func check_if_sees_player():
	var vector_diff = player.global_position - global_position
	if vector_diff.length() <= 50:
		explode()
	
	var direction = (vector_diff).normalized()
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
	velocity = direction * attack_speed
	move_and_slide()


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
		add_score()
		queue_free()

func add_score():
	print("aa")
	score_label.enemy_killed()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("playerBullet"):
		got_hit()
		area.queue_free()


func explode():
	print("bim bam boum")
	score_label.enemy_killed()
	queue_free()

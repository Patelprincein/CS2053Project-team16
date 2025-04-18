extends CharacterBody2D

var speed: int = 70
var patrolling: bool = true
var raycast_length: float = 200.0

var bullet_scene = preload("res://enemies/enemy_bullet.tscn")
var score_label

@export var player: CharacterBody2D
@export var health: int = 10

@onready var pathfollow: PathFollow2D = get_parent()

func _ready() -> void:
	$HealthBar.max_value = health
	$HealthBar.value = health
	score_label = get_parent().get_parent().get_parent().get_parent().get_node("Camera2D").get_node("ScoreLabel")

func _physics_process(delta: float) -> void:
	if patrolling:
		patrol(delta)
	
	check_if_sees_player()


# Patrol around the Path2D line
func patrol(delta):
	pathfollow.progress += speed * delta
	if pathfollow.progress_ratio >= 0.5:
		$AnimatedSprite2D.play("left")
	else:
		$AnimatedSprite2D.play("right")


# Raycast a ray to the player
func check_if_sees_player():
	var direction = (player.global_position - global_position).normalized()
	$RayCast2D.target_position = direction * raycast_length
	
	patrolling = true
	
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		
		if collider and collider.is_in_group("player"):
			patrolling = false
			$AnimatedSprite2D.play("idle")


# Shoot the player
func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = position
	bullet.direction = (player.global_position - global_position).normalized()
	get_parent().add_child(bullet)

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

func _on_bullet_timer_timeout() -> void:
	if not patrolling:
		shoot()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("playerBullet"):
		got_hit()
		area.queue_free()

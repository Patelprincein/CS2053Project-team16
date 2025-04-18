extends CharacterBody2D

@export var move_speed: float = 70.0
@export var detection_range: float = 1100.0
@export var attack_range: float = 250.0
@export var bullet_path: PackedScene = preload("res://enemies/Scenes/enemy_bullet.tscn") # Link to your bullet scene
@export var fire_rate: float = 1.0

var player: Node2D
var can_attack: bool = true
@export var health: int = 50
var time_since_last_shot: float = 0.0

func _ready():
	player = get_tree().get_first_node_in_group("player")
	$HealthBar.max_value = health
	$HealthBar.value = health

func _physics_process(delta):
	if player and global_position.distance_to(player.global_position) <= detection_range:
		look_at(player.global_position)

		# Move towards the player (basic chasing)
		if global_position.distance_to(player.global_position) > attack_range:
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * move_speed
		else:
			velocity = Vector2.ZERO 
		move_and_slide()

		if global_position.distance_to(player.global_position) <= attack_range and can_attack:
			_attack()
			can_attack = false
			time_since_last_shot = 0.0
	else:
		velocity = Vector2.ZERO # Stop moving if player is out of detection range
		# Potentially add patrol behavior here later

	# Handle fire rate
	if not can_attack:
		time_since_last_shot += delta
		if time_since_last_shot >= 1.0 / fire_rate:
			can_attack = true

func _attack():
	if not bullet_path:
		printerr("Error: Bullet scene path is not loaded.")
		return

	# Get the left and right fire points
	var left_fire_point: Marker2D = get_node("left_fire")
	var right_fire_point: Marker2D = get_node("right_fire")

	if not left_fire_point or not right_fire_point:
		printerr("Error: 'left_fire' or 'right_fire' Marker2D nodes not found.")
		return

	# Calculate the direction to the player from each fire point
	var left_direction = (player.global_position - left_fire_point.global_position).normalized()
	var right_direction = (player.global_position - right_fire_point.global_position).normalized()

	# Instantiate and launch bullets from both fire points, aiming at the player
	_spawn_bullet(left_fire_point.global_position, left_direction) # Fire left towards player
	_spawn_bullet(right_fire_point.global_position, right_direction) # Fire right towards player

func _spawn_bullet(spawn_position: Vector2, bullet_direction: Vector2):
	var bullet_instance = bullet_path.instantiate()
	get_parent().add_child(bullet_instance) # Add the bullet to the main game scene
	bullet_instance.global_position = spawn_position
	bullet_instance.direction = bullet_direction.normalized()

func got_hit():
	health -= 1
	$HealthBar.value = health
	if health <= 0:
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("playerBullet"):
		got_hit()
		area.queue_free()

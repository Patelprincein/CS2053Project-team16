extends CharacterBody2D

var speed: int = 70
var patrolling: bool = true
var raycast_length: float = 100.0

@export var player: Node2D
@onready var pathfollow: PathFollow2D = get_parent()


func _physics_process(delta: float) -> void:
	if patrolling:
		patrol(delta)
	else:
		shoot()
	
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
	pass

extends Area2D

@export var speed: float = 800.0
var direction: Vector2 = Vector2.RIGHT  # Default direction; will be overwritten by the gun.

func _physics_process(delta: float) -> void:
	# Move the bullet along its 'direction'.
	position += direction * speed * delta
	
	# Remove the bullet if it goes far off-screen.
	if position.x > 2000 or position.x < -2000 or position.y > 2000 or position.y < -2000:
		queue_free()

func _on_Bullet_body_entered(body: Node) -> void:
	# When the bullet collides with something, remove it.
	queue_free()	

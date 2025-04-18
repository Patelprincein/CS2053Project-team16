extends Area2D

@export var speed: float = 800.0
var direction: Vector2 = Vector2.RIGHT  # Default direction; will be overwritten by the gun.

func _physics_process(delta: float) -> void:
	# Move the bullet along its 'direction'.
	position += direction * speed * delta
	

func _on_Bullet_body_entered(body: Node) -> void:
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

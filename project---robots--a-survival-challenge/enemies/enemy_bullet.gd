extends Node2D

@export var speed: float = 500.0
@export var direction: Vector2 = Vector2.RIGHT
@export var damage: int = 1


func _process(delta: float) -> void:
	position += direction * speed * delta
	
	# Destroy when off-screen
	if not get_viewport_rect().has_point(global_position):
		queue_free()

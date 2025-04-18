extends Node2D

@export var speed: float = 500.0
@export var direction: Vector2 = Vector2.RIGHT
@export var damage: int = 1


func _process(delta: float) -> void:
	position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

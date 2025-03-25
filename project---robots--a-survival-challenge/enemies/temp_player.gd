extends Node2D

func _process(delta: float) -> void:
	
	if Input.is_action_pressed("left"):
		position.x -= 1
	if Input.is_action_pressed("right"):
		position.x += 1
	if Input.is_action_pressed("up"):
		position.y -= 1
	if Input.is_action_pressed("down"):
		position.y += 1

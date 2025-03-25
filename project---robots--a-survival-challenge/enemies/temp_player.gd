extends Node2D

var bullet_scene = preload("res://enemies/player_bullet.tscn")
@export var health: int = 10


func _ready() -> void:
	$HealthBar.max_value = health
	$HealthBar.value = health


func _process(delta: float) -> void:
	
	if Input.is_action_pressed("left"):
		position.x -= 1
	if Input.is_action_pressed("right"):
		position.x += 1
	if Input.is_action_pressed("up"):
		position.y -= 1
	if Input.is_action_pressed("down"):
		position.y += 1


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		shoot()



func shoot():
	var bullet = bullet_scene.instantiate()
	
	bullet.global_position = position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	get_parent().add_child(bullet)


# Ouch
func got_hit():
	health -= 1
	$HealthBar.value = health
	if health <= 0:
		queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemyBullet"):
		got_hit()
		area.get_parent().queue_free()

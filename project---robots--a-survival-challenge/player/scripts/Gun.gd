extends Node2D

@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.2  # Seconds between shots

var firing: bool = false
var fire_timer: Timer

func _ready() -> void:
	# Create a Timer node dynamically for repeated firing.
	fire_timer = Timer.new()
	fire_timer.wait_time = fire_rate
	fire_timer.one_shot = false  # Continuously fire while active.
	fire_timer.autostart = false
	fire_timer.connect("timeout", Callable(self, "_fire_bullet"))
	add_child(fire_timer)

func _process(delta: float) -> void:
	# Start the timer if the player is holding down the "shoot" action.
	if Input.is_action_pressed("shoot") and not firing:
		firing = true
		fire_timer.start()
	# Stop the timer when the "shoot" action is released.
	elif not Input.is_action_pressed("shoot") and firing:
		firing = false
		fire_timer.stop()

func _fire_bullet() -> void:
	if bullet_scene == null:
		print("Error: Bullet scene not assigned!")
		return
		
	var bullet = bullet_scene.instantiate()
	bullet.position = global_position
	bullet.direction = Vector2.RIGHT.rotated(global_rotation)
	
	get_tree().current_scene.add_child(bullet)

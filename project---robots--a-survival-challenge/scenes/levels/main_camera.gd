extends Camera2D

@export var left_frame = 460
@export var right_frame = 1880
@export var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Vector2(left_frame, 200)

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if player.global_position.x > left_frame and player.global_position.x < right_frame:
		global_position.x = player.global_position.x

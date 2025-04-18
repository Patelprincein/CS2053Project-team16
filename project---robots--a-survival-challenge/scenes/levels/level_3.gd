extends Node2D

const NEXT_LEVEL: String = "res://scenes/levels/level_4.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("level3")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_end_level_2_body_entered(body: Node2D) -> void:
	if body.name == "Player-Body" and body.can_end:
		get_tree().change_scene_to_file(NEXT_LEVEL)

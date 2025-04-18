extends Node2D

# Go back to level-1 (temporary)
const NEXT_LEVEL: String = "res://scenes/levels/level_1.tscn"
@onready var score_node = get_node("Camera2D/ScoreLabel")

var max_score = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("level6")

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if(score_node.score1 == max_score):
		pass

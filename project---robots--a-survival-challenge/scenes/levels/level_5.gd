extends Node2D

const NEXT_LEVEL: String = "res://scenes/levels/level_6.tscn"
@onready var score_node = get_node("Camera2D/ScoreLabel")

var max_score = 9
var can_move = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("level5")

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	visible_flag(can_move)
	
	if(score_node.score1 == max_score):
		can_move = true

func visible_flag(val):
	$Flag.visible = val

func _on_end_level_5_body_entered(body: Node2D) -> void:
	if body.name == "Player-Body" and can_move:
		get_tree().change_scene_to_file(NEXT_LEVEL)

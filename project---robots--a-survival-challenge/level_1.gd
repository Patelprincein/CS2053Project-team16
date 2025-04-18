extends Node2D

const NEXT_LEVEL: String = "res://scenes/levels/level_2.tscn"
@onready var score_node = get_node("Camera2D/ScoreLabel")

var max_score = 3
var can_move = false


func _ready() -> void:
	pass

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	
	visible_flag(can_move)
	
	if(score_node.score1 == max_score):
		can_move = true


func visible_flag(val):
	$Flag.visible = val


func _on_end_level_2_body_entered(body: Node2D) -> void:
	if body.name == "Player-Body" and can_move:
		get_tree().change_scene_to_file(NEXT_LEVEL)

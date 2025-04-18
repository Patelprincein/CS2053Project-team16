extends Label

var score1 = 0
@export var MAX_SCORE1 = 5
@export var player: Node2D

func _ready() -> void:
	text = "Enemy left: %s" % MAX_SCORE1
	score1 = 0

func enemy_killed() -> void:
	score1 += 1
	text = "Enemy left: %s" % (MAX_SCORE1 - score1)

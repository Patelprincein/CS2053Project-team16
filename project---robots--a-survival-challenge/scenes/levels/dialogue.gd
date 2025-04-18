extends Panel

@onready var dialogue_box : Panel = get_node("/root/level_2/CanvasLayer/DialogueBox")
@export var player: Node2D

func _ready() -> void:
	pass 

func _on_start_button_pressed() -> void:
	var dialogue_box = get_parent()
	dialogue_box.visible = false
	player.can_move = true

extends Panel

@onready var dialogue_box : Panel = get_node("/root/level6/Camera2D/CanvasLayer/DialogueBox")
@export var player: Node2D

func _ready() -> void:
	pass 

func _on_start_button_pressed() -> void:
	@warning_ignore("shadowed_variable")
	var dialogue_box = get_parent()
	dialogue_box.visible = false
	player.can_move = true

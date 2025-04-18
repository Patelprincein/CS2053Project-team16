extends Control

const FIRST_LEVEL: String = "res://scenes/levels/level_1.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/VBoxContainer/PlayButton.connect("pressed", _on_play_pressed)
	$MarginContainer/VBoxContainer/QuitButton.connect("pressed", _on_quit_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func _on_play_pressed():
	get_tree().change_scene_to_file(FIRST_LEVEL)

func _on_quit_pressed():
	get_tree().quit()

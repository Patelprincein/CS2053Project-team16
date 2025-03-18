extends CanvasLayer

const MENU: String = "res://scenes/main_menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/RestartButton.connect("pressed", _on_restart_pressed)
	$VBoxContainer/MenuButton.connect("pressed", _on_menu_pressed)
	hide()
	set_process_input(true) # To depause the Pause Menu


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if visible:
			hide()
			Engine.time_scale = 1
		else:
			show()
			Engine.time_scale = 0



func _on_restart_pressed():
	get_tree().reload_current_scene()


func _on_menu_pressed():
	get_tree().change_scene_to_file(MENU)

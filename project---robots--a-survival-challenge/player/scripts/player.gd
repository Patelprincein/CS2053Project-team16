extends CharacterBody2D

# Variables for aiming
const rotation_speed = 50.0  # Speed for rotating the Left_arm (degrees per second)
const min_angle = -75.0  # Minimum rotation angle (upwards limit)
const max_angle = 75.0   # Maximum rotation angle (downwards limit)

func _ready():
	# Set LJet and RJet to be invisible initially
	$"Player-Body/Body/ChestSprite/LLeg/LJet".visible = false
	$"Player-Body/Body/ChestSprite/RLeg/RJet".visible = false

func _process(delta):
	var left_arm = $"Player-Body/Left_arm"
	left_arm.rotation = (get_global_mouse_position() - left_arm.global_position).angle()

func _input(event):
	# Fire bullet if the player presses the shoot key
	if event.is_action_pressed("shoot"):  # Make sure "shoot" is added in Input Map
		$"Player-Body"/Left_arm/Gun._fire_bullet()

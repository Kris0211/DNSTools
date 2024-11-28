@tool
extends Sprite2D

@export var speed: float = 1.0:
	set(new_speed):
		speed = new_speed
	get:
		return speed

@onready var label: Label = $Label


func _process(delta: float) -> void:
	# Runs in editor
	if Engine.is_editor_hint():
		rotation += delta * speed
	
	# Runs in game
	if not Engine.is_editor_hint():
		rotation -= delta * speed
	
	# Runs everywhere
	if rotation >= deg_to_rad(360):
		rotation = 0.0
	label.text = str(rad_to_deg(rotation))

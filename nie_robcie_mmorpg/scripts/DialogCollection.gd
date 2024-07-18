class_name DialogCollection extends Resource

@export var speaker_name: String

@export_group("Dialog", "dialog_")
@export_multiline var dialog_greetings := "Hello there"
@export_multiline var dialog_idle := "I used to be an adventurer like you"
@export_multiline var dialog_farewell := "Bywaj"

@export_group("Colors", "color_")
@export var color_friendly := Color.GREEN
@export var color_neutral := Color(Color("#808080"), 0.82)
@export_color_no_alpha var color_evil := Color(1.0, 0.0, 0.0)

@tool
extends ScrollContainer

const TODO_FIELD = preload("res://addons/todo/todo_field.tscn")

@onready var todo_container = $VBoxContainer/ScrollContainer/VBoxContainer

func _on_button_pressed() -> void:
	var new_field = TODO_FIELD.instantiate()
	todo_container.add_child(new_field)

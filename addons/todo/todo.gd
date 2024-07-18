@tool
extends EditorPlugin

var dock = null

func _enter_tree():
	# Initialization of the plugin goes here.
	dock = load("res://addons/todo/todo_dock.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_control_from_docks(dock)
	dock.free() # <- remember to free dock from memory!

@tool
extends EditorPlugin

var bottom = null

func _enter_tree():
	bottom = load("res://addons/bottom/bottom.tscn").instantiate()
	add_control_to_bottom_panel(bottom, "Bottom")


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_control_from_bottom_panel(bottom)
	bottom.free()

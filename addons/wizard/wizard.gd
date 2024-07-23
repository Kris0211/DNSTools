@tool
extends EditorPlugin

const PLUGIN_NAME = "Wizard"
const MAIN_PANEL = preload("res://addons/wizard/scenes/wiz_main.tscn")

var main_panel_instance: Node = null


func _enter_tree():
	main_panel_instance = MAIN_PANEL.instantiate()
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
	_make_visible(false)


func _exit_tree():
	if main_panel_instance != null:
		main_panel_instance.queue_free()


func _has_main_screen():
	# Must return true for main screen plugins.
	return true


func _make_visible(visible):
	if main_panel_instance != null:
		main_panel_instance.set_visible(visible)


func _get_plugin_name():
	return PLUGIN_NAME


func _get_plugin_icon():
	var editor_gui = EditorInterface.get_base_control()
	return editor_gui.get_theme_icon("Node", "EditorIcons")


# This method is not needed in our case.
#func _handles(object: Object) -> bool:
#	return false

@tool
extends EditorPlugin

func _enter_tree():
	add_tool_menu_item("Hello There", Callable(self, &"hello_there"))


func _exit_tree():
	remove_tool_menu_item("Hello There")


func hello_there():
	var popup_window := AcceptDialog.new()
	
	popup_window.set_hide_on_ok(false)
	popup_window.set_initial_position(
			Window.WINDOW_INITIAL_POSITION_CENTER_SCREEN_WITH_MOUSE_FOCUS)
	popup_window.set_title("Hello There!")
	popup_window.set_text("General Kenobi!")
	
	popup_window.confirmed.connect(
		func(): popup_window.call_deferred(&"free")
	)
	popup_window.canceled.connect(
		func(): popup_window.call_deferred(&"free")
	)
	
	add_child(popup_window)
	popup_window.popup()

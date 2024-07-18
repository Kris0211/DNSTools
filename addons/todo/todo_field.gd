@tool
extends HBoxContainer

@onready var textedit: TextEdit = $TextEdit

func _on_check_box_toggled(toggled_on: bool) -> void:
	# When task is completed, we can't edit it
	textedit.editable = !toggled_on


func _on_button_pressed() -> void:
	# Delete task on idle frame
	call_deferred(&"free")
	# We cannot just call "free" 
	# as the node might be busy processing
	# and cannot be freed immediately.

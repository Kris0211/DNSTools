extends EditorInspectorPlugin

var validate_button: ValidateButton
var _attached_object: Object


func _can_handle(object: Object) -> bool:
	if object is Resource:
		_attached_object = object
		return true
	return false


func _parse_end(object: Object) -> void:
	# Godot's equivalent of centering a div.
	var validate_button_instance = ValidateButton.new(_attached_object)
	var vbox := VBoxContainer.new()
	var hbox := HBoxContainer.new()
	
	validate_button_instance.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	validate_button_instance.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_child(validate_button_instance)
	
	vbox.add_child(hbox)
	add_custom_control(vbox)

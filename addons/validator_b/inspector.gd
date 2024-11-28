extends EditorInspectorPlugin

var validate_button: ValidateButton
var _attached_object: Object


func _can_handle(object: Object) -> bool:
	if object is Resource:
		_attached_object = object
		return true
	return false


func _parse_end(object: Object) -> void:
	var validate_button_instance = ValidateButton.new(_attached_object)
	
	# Godot's equivalent of centering a div.
	validate_button_instance.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	validate_button_instance.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	add_custom_control(validate_button_instance)

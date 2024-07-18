class_name ValidateButton extends EditorProperty

# On successful validation
const MSG_OK := "SUCCESS: Resource validation successful!\n
No errors found."

# On missing validator
const MSG_WARN := "WARNING: Resource could not be validated.\n
Register a Validator first."

# On failed validation
const MSG_ERROR := "ERROR: Resource validation failed!\n
Check output log for details."

# The main control for editing the property.
var property_control := Button.new()
# A guard against internal changes when the property is updated.
var updating := false
# A reference to the resource we are going to validate.
var _resource: Resource
var _validator: Validator

func _init(r: Resource):
	_resource = r
	_validator = ValidatorFactory.create_validator(r)
	
	# Set minimum size to ensure the button is visible.
	property_control.custom_minimum_size = Vector2(160, 20)
	property_control.set_text("Validate!")
	
	property_control.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	# Add the control as a direct child of EditorProperty node.
	add_child(property_control)
	# Make sure the control is able to retain the focus.
	add_focusable(property_control)
	
	property_control.pressed.connect(_on_button_pressed)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			_resource = null
			_validator = null


func _show_popup(_dialog: String, _label: String = "Alert!") -> void:
	var popup_window := AcceptDialog.new()
	
	popup_window.set_hide_on_ok(false)
	popup_window.set_initial_position(
			Window.WINDOW_INITIAL_POSITION_CENTER_SCREEN_WITH_MOUSE_FOCUS)
	popup_window.get_label().set_text(_label)
	popup_window.set_text(_dialog)
	
	popup_window.confirmed.connect(
		func(): popup_window.call_deferred(&"free")
	)
	popup_window.canceled.connect(
		func(): popup_window.call_deferred(&"free")
	)
	
	EditorInterface.popup_dialog(popup_window)


func _on_button_pressed():
	# Ignore the signal if the property is currently being updated.
	if updating:
		return
	
	if _validator == null:
		_show_popup(MSG_WARN)
		return
	
	if _validator.validate():
		_show_popup(MSG_OK)
	else:
		_show_popup(MSG_ERROR)

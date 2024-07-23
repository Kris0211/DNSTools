@tool
extends PanelContainer

const LEVEL_STAT_SCENE: PackedScene = \
	preload("res://addons/wizard/scenes/wiz_stat_container.tscn")
const TARGET_DIR: String = "res://nie_robcie_mmorpg/resources/"
const CURRENTLY_OPEN_TEXT := "Currently open: "

enum {
	TOTAL_XP, XP, MHP, MMP, ATK, DEF, SPD
}

## [TraitSet] which is currently being edited.
var trait_set: TraitSet = null

## Dirty flag. 
## Indicates this [TraitSet] was modified and not saved.
## When set to [code]true[/code], shows an asterisk in the UI.
var _dirty: bool = false:
	set(value):
		_dirty = value
		if _dirty:
			_on_dirty_flag_changed()


## Cached previous value of MaxLevelSpinBox.
var _prev_lvl: int = 10

var exp_formula_expression := Expression.new()
var growth_formula_expression := Expression.new()


@onready var edit_panel: PanelContainer = $VBoxContainer/EditPanel
@onready var current_open_label: Label = $VBoxContainer/HBoxContainer/Label
@onready var save_as_button: Button = \
	$VBoxContainer/HBoxContainer/SaveTraitSetAs
@onready var close_button: Button = $VBoxContainer/HBoxContainer/CloseTraitSet
@onready var edit_area: Control = \
	$VBoxContainer/EditPanel/HBoxContainer/OverviewContainer
@onready var exp_formula_line_edit: LineEdit = %ExpFormulaLineEdit
@onready var growth_formula_line_edit: LineEdit = %GrowthFormulaLineEdit
@onready var max_level_spin_box: SpinBox = %MaxLevelSpinBox
@onready var level_stats_area: VBoxContainer = %LevelStatsArea


func _ready() -> void:
	edit_panel.set_visible(false)
	save_as_button.set_disabled(true)


#region MENU BUTTONS
## Callback for New button.
func _on_new_trait_set_pressed() -> void:
	if trait_set != null && _dirty:
		_show_save_popup("Save current file?")
		return
	
	_clear_edit_area()
	trait_set = TraitSet.new()
	current_open_label.set_text(CURRENTLY_OPEN_TEXT + "(unsaved)")
	edit_panel.set_visible(true)
	save_as_button.set_disabled(false)
	_dirty = true
	
	# Generate empty TraitSet
	_clear_edit_area()
	for i: int in range(max_level_spin_box.value):
		var stat_container_instance: = LEVEL_STAT_SCENE.instantiate()
		stat_container_instance.setup(i)
		stat_container_instance.value_changed.connect(_on_value_changed)
		level_stats_area.add_child(stat_container_instance)
	
	_resize_arrays(max_level_spin_box.get_value())
	edit_area.set_visible(true)
	close_button.set_disabled(false)


## Callback for Open button.
func _on_open_trait_set_pressed() -> void:
	_clear_edit_area()
	var file_dialog := FileDialog.new()
	
	file_dialog.set_access(FileDialog.ACCESS_RESOURCES)
	file_dialog.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
	file_dialog.set_initial_position(
			Window.WINDOW_INITIAL_POSITION_CENTER_SCREEN_WITH_MOUSE_FOCUS)
	file_dialog.set_size(Vector2i(800, 600))
	file_dialog.set_current_dir(TARGET_DIR)
	file_dialog.set_filters(PackedStringArray(
		["*.tres ; Trait Set Resource"]
	))
	
	file_dialog.file_selected.connect(_load_table)
	file_dialog.close_requested.connect(
		func(): file_dialog.call_deferred(&"free")
	)
	
	add_child(file_dialog)
	file_dialog.popup()


## Callback for Save As button.
func _on_save_trait_set_as_pressed() -> void:
	var file_dialog := FileDialog.new()
	
	file_dialog.set_access(FileDialog.ACCESS_RESOURCES)
	file_dialog.set_file_mode(FileDialog.FILE_MODE_SAVE_FILE)
	file_dialog.set_initial_position(
			Window.WINDOW_INITIAL_POSITION_CENTER_SCREEN_WITH_MOUSE_FOCUS)
	file_dialog.set_size(Vector2i(800, 600))
	file_dialog.set_current_dir(TARGET_DIR)
	file_dialog.set_filters(PackedStringArray(
		["*.tres ; Trait Set Resource"]
	))
	
	file_dialog.file_selected.connect(_save_file)
	file_dialog.close_requested.connect(
		func(): file_dialog.call_deferred(&"free")
	)
	
	add_child(file_dialog)
	file_dialog.popup()



## Callback for Close button.
func _on_close_trait_set_pressed():
	##TODO: add save confirmation on dirty flag
	_clear_edit_area()
	edit_panel.hide()
	save_as_button.set_disabled(true)
	close_button.set_disabled(true)
	trait_set = null
	current_open_label.set_text(CURRENTLY_OPEN_TEXT + "none")
#endregion MENU BUTTONS


## Callback for Generate button.
func _on_generate_trait_set_button_pressed() -> void:
	_dirty = true
	# Parse expressions
	if exp_formula_line_edit.get_text() != "":
		if exp_formula_expression.parse(
			exp_formula_line_edit.get_text(),
			["i", "l", "lvl", "level"]
		) != OK:
			_show_popup(exp_formula_expression.get_error_text(), "Error")
			return
	
	if growth_formula_line_edit.get_text() != "":
		if growth_formula_expression.parse(
			growth_formula_line_edit.get_text(),
			["i", "l", "lvl", "level"]
		) != OK:
			_show_popup(growth_formula_expression.get_error_text(), "Error")
			return
	
	# Cached total exp value for correct display.
	var total_exp: int = trait_set.required_experience[0]
	
	for i: int in range(1, level_stats_area.get_child_count()):
		# Execute expressions
		var exp_formula_value = exp_formula_expression.execute([i, i, i, i])
		if exp_formula_expression.has_execute_failed():
			_show_popup(exp_formula_expression.get_error_text(), "Error")
			return
			
		var growth_formula_value = growth_formula_expression.execute([i, i, i, i])
		if growth_formula_expression.has_execute_failed():
			_show_popup(growth_formula_expression.get_error_text(), "Error")
			return
		
		var stat_container = level_stats_area.get_child(i)
		# Calculate exp
		# (using "Diff" method here)
		trait_set.required_experience[i] = \
			trait_set.required_experience[i - 1] + (exp_formula_value * i)
		total_exp += trait_set.required_experience[i]
		stat_container.get_node(^"ExpLineEdit")\
			.set_text(str(trait_set.required_experience[i]))
		stat_container.get_node(^"TotalLineEdit")\
			.set_text(str(total_exp))
		
		# Calculate stats
		_calculate_stat(trait_set.stat_max_hp, ^"MaxHPLineEdit",
				growth_formula_value, i)
			
		_calculate_stat(trait_set.stat_max_mp, ^"MaxMPLineEdit",
				growth_formula_value, i)
		
		_calculate_stat(trait_set.stat_attack, ^"AtkLineEdit",
				growth_formula_value, i)
		
		_calculate_stat(trait_set.stat_defense, ^"DefLineEdit",
				growth_formula_value, i)
		
		_calculate_stat(trait_set.stat_speed, ^"SpdLineEdit",
				growth_formula_value, i)


func _calculate_stat(stat_array: Array, node_path: NodePath, 
		growth_formula_value: float, i: int) -> void:
	var stat_container = level_stats_area.get_child(i)
	stat_array[i] = \
		ceili(stat_array[i - 1] * growth_formula_value)
	stat_container.get_node(node_path)\
		.set_text(str(stat_array[i]))


#region FILE
## Loads a TraitSet from file.
func _load_table(path: String) -> void:
	trait_set = null
	var resource = load(path)
	if !_validate_file(resource):
		resource = null
		return
	
	trait_set = resource.duplicate() # pass by value
	current_open_label.set_text(
		CURRENTLY_OPEN_TEXT + path.get_file().get_slice(".", 0)
	)
	_clear_edit_area()
	
	var total_exp: int = 0
	for i: int in range(max_level_spin_box.value):
		var stat_container_instance: = LEVEL_STAT_SCENE.instantiate()
		stat_container_instance.setup(i)
		if i == trait_set.required_experience.size():
			break
		total_exp += trait_set.required_experience[i]
		var stats: Array = [
			total_exp,
			trait_set.required_experience[i],
			trait_set.stat_max_hp[i],
			trait_set.stat_max_mp[i],
			trait_set.stat_attack[i],
			trait_set.stat_defense[i],
			trait_set.stat_speed[i]
		]
		stat_container_instance.fill(stats)
		stat_container_instance.value_changed.connect(_on_value_changed)
		level_stats_area.add_child(stat_container_instance)
	
	max_level_spin_box.set_value_no_signal(level_stats_area.get_child_count())
	_prev_lvl = level_stats_area.get_child_count()
	edit_panel.set_visible(true)
	save_as_button.set_disabled(false)
	close_button.set_disabled(false)


## Validates the loaded file. 
## Returns [code]true[/code] if provided file is a TraitSet
## and it has been successfully loaded.
func _validate_file(file: Resource) -> bool:
	if file == null:
		_show_popup("Falied to load file!", "Error")
		return false
	
	if !file is TraitSet:
		_show_popup("Selected file is not a TraitSet resource.", "Error")
		return false
	
	return true


## Saves data to file.
func _save_file(path: String) -> void:
	var err: Error = ResourceSaver.save(trait_set, path)
	if err != OK:
		_show_popup("Error code %s: %s" % [err, error_string(err)])
		return
	
	_dirty = false
	current_open_label.set_text(
		CURRENTLY_OPEN_TEXT + path.get_file().get_slice(".", 0)
	)
#endregion FILE


## Removes all StatContainers from EditArea.
func _clear_edit_area() -> void:
	for child: Node in level_stats_area.get_children():
		child.call_deferred(&"free")


#region POPUPS
## Show a generic popup with one "OK" button.
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
	
	add_child(popup_window)
	popup_window.popup()


## Show save popup.
func _show_save_popup(_dialog: String, _label: String = "Save now?") -> void:
	var popup_window := ConfirmationDialog.new()
	
	popup_window.set_hide_on_ok(false)
	popup_window.set_initial_position(
			Window.WINDOW_INITIAL_POSITION_CENTER_SCREEN_WITH_MOUSE_FOCUS)
	popup_window.add_button("Cancel", true, &"cancel")
	popup_window.get_label().set_text(_label)
	popup_window.set_text(_dialog)
	
	# Why would I do that...
	popup_window.get_ok_button().set_text("Save")
	popup_window.get_cancel_button().set_text("Don't save")
	
	popup_window.confirmed.connect( #save
		func():
			_on_save_trait_set_as_pressed()
			popup_window.call_deferred(&"free")
	)
	
	popup_window.canceled.connect( # don't save
		func():
			popup_window.call_deferred(&"free")
	)
	
	popup_window.custom_action.connect(
		func(action: StringName):
			if action == &"cancel":
				popup_window.call_deferred(&"free")
	)
	
	add_child(popup_window)
	popup_window.get_cancel_button().grab_focus()
	popup_window.popup()
#endregion POPUP


## Called when dirty flag has changed.
func _on_dirty_flag_changed() -> void:
	if !current_open_label.get_text().ends_with("(*)") && _dirty:
		current_open_label.set_text(current_open_label.get_text() + "(*)")


## Callback for max level SpinBox value change.
func _on_max_level_spin_box_value_changed(value: float) -> void:
	_dirty = true
	var _new_val := int(value)
	if _prev_lvl > _new_val:
		for i: int in range(_prev_lvl, _new_val, -1):
			var instance = level_stats_area.get_child(i - 1)
			instance.value_changed.disconnect(_on_value_changed)
			instance.call_deferred(&"free")
	
	elif _prev_lvl < _new_val:
		for i: int in range(_prev_lvl, _new_val):
			var stat_container_instance := LEVEL_STAT_SCENE.instantiate()
			stat_container_instance.setup(i)
			stat_container_instance.value_changed.connect(_on_value_changed)
			level_stats_area.add_child(stat_container_instance)
	
	_resize_arrays(_new_val)
	_prev_lvl = _new_val


## Resize [TraitSet] to match maximum level value.
func _resize_arrays(new_size: int) -> void:
	trait_set.required_experience.resize(new_size)
	trait_set.stat_max_hp.resize(new_size)
	trait_set.stat_max_mp.resize(new_size)
	trait_set.stat_attack.resize(new_size)
	trait_set.stat_defense.resize(new_size)
	trait_set.stat_speed.resize(new_size)


## Callback for StatContainer value change.
func _on_value_changed(value: int, for_level: int, value_type: int) -> void:
	match value_type:
		TOTAL_XP, XP: # prevents mismatch
			trait_set.required_experience[for_level - 1] = value
		MHP:
			trait_set.stat_max_hp[for_level - 1] = value
		MMP:
			trait_set.stat_max_mp[for_level - 1] = value
		ATK:
			trait_set.stat_attack[for_level - 1] = value
		DEF:
			trait_set.stat_defense[for_level - 1] = value
		SPD:
			trait_set.stat_speed[for_level - 1] = value

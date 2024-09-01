@tool
extends HBoxContainer

signal value_changed(value: int, for_level: int, value_type: int)

enum { TOTAL_XP, NEXT_XP, MHP, MMP, ATK, DEF, SPD }

@onready var level_line_edit := $LevelLineEdit as LineEdit

var node_refs: Array[LineEdit] = []

## Called by main window after initialization.
func setup(level: int) -> void:
	level_line_edit.set_text(str(level + 1))
	node_refs = [
		$TotalLineEdit,
		$ExpLineEdit,
		$MaxHPLineEdit,
		$MaxMPLineEdit,
		$AtkLineEdit,
		$DefLineEdit,
		$SpdLineEdit
	]


func fill(stats: Array) -> void:
	for i in node_refs.size():
		node_refs[i].set_text(str(stats[i]))


#region SIGNALS
func _on_exp_line_edit_focus_exited() -> void:
	value_changed.emit(
		int($ExpLineEdit.get_text()),
		int(level_line_edit.get_text()),
		NEXT_XP
	)


func _on_max_hp_line_edit_focus_exited():
	value_changed.emit(
		int($MaxHPLineEdit.get_text()),
		int(level_line_edit.get_text()),
		MHP
	)

# and it goes on and on...
func _on_max_mp_line_edit_focus_exited():
	value_changed.emit(
		int($MaxMPLineEdit.get_text()),
		int(level_line_edit.get_text()),
		MMP
	)


func _on_atk_line_edit_focus_exited():
	value_changed.emit(
		int($AtkLineEdit.get_text()),
		int(level_line_edit.get_text()),
		ATK
	)


func _on_def_line_edit_focus_exited():
	value_changed.emit(
		int($DefLineEdit.get_text()),
		int(level_line_edit.get_text()),
		DEF
	)


func _on_spd_line_edit_focus_exited():
	value_changed.emit(
		int($SpdLineEdit.get_text()),
		int(level_line_edit.get_text()),
		SPD
	)
#endregion

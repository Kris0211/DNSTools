class_name TraitSet extends Resource

@export_group("Experience")
@export var required_experience: Array[int]

@export_group("Stats", "stat_")
@export var stat_max_hp: Array[int]
@export var stat_max_mp: Array[int]
@export var stat_attack: Array[int]
@export var stat_defense: Array[int]
@export var stat_speed: Array[int]


func validate() -> bool:
	var res := true
	var _args := {
		&"required_experience": required_experience,
		&"stat_max_hp": stat_max_hp,
		&"stat_max_mp": stat_max_mp,
		&"stat_attack": stat_attack,
		&"stat_defense": stat_defense,
		&"stat_speed": stat_speed,
	}
	
	for i: int in (len(_args) - 1):
		var name = _args.keys()[i]
		if !_check_array(_args[name], name):
			res = false
	return res


func _check_array(array: Array, name: StringName) -> bool:
	if array.size() < 1:
		printerr("Error: Array %s is empty." % name)
		return false
	for i: int in array.size():
		if array[i] < 0:
			printerr("Error: Value in array %s at index %s less than 0." %
					[name, i])
			return false
	return true

@tool
class_name TraitSetValidator extends Validator

var trait_set: TraitSet
var _args: Dictionary


func _init(_trait_set: TraitSet):
	trait_set = _trait_set
	_args = {
		&"required_experience": trait_set.required_experience,
		&"stat_max_hp": trait_set.stat_max_hp,
		&"stat_max_mp": trait_set.stat_max_mp,
		&"stat_attack": trait_set.stat_attack,
		&"stat_defense": trait_set.stat_defense,
		&"stat_speed": trait_set.stat_speed,
	}


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE: # pseudo-destructor
			_args.clear()
			trait_set = null


func validate() -> bool:
	var res := true
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

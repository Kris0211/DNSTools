@tool
class_name DialogCollectionValidator extends Validator

var dialog_collection: DialogCollection

var _args: Array


func _init(_dialog_collection: DialogCollection):
	dialog_collection = _dialog_collection


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE: # pseudo-destructor
			dialog_collection = null


func validate() -> bool:
	var res := true
	return res


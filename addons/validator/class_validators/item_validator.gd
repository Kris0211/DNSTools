@tool
class_name ItemValidator extends Validator

var item: Item

var _args: Array


func _init(_item: Item):
	item = _item


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE: # pseudo-destructor
			item = null


func validate() -> bool:
	var res := true
	return res


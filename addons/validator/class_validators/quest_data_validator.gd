@tool
class_name QuestDataValidator extends Validator

var quest: QuestData

var _args: Array


func _init(_quest: QuestData):
	quest = _quest


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE: # pseudo-destructor
			quest = null


func validate() -> bool:
	var res := true
	return res


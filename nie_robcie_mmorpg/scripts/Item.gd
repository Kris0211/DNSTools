class_name Item extends Resource

@export var item_name: String
@export_multiline var item_description: String
@export_range(0, 1, 1, "or_greater") var item_hp_restore: int
@export_range(0, 1, 0.01, "suffix:*100%") var item_atk_buff: float


func validate() -> bool:
	if item_name == "":
		printerr("Name cannot be empty.")
		return false
	
	return true

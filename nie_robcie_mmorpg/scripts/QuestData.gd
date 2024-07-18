class_name QuestData extends Resource

@export_group("Quest Info", "quest_")
@export var quest_name: String = "SYSOPMAX"
@export_multiline var quest_description: String = "Zaliczenie wykładowcy"

@export var required_items: Array[Item]
@export var rewards: Array[Item]

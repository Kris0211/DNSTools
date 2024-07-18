@tool
extends Button

@export_category("CustomNPC Data")
@export var sprite: Texture2D

@export var dialog: DialogCollection:
	set(p_dialog):
		if p_dialog != dialog:
			dialog = p_dialog
			update_configuration_warnings()

@export var shop: ShopOffer:
	set(p_shop):
		if p_shop != shop:
			shop = p_shop
			update_configuration_warnings()

@export var stats: TraitSet:
	set(p_stats):
		if p_stats != stats:
			stats = p_stats
			update_configuration_warnings()

@export var quest: QuestData:
	set(p_quest):
		if p_quest != quest:
			quest = p_quest
			update_configuration_warnings()


func _enter_tree():
	if dialog != null:
		print(dialog.speaker_name + ": " + dialog.dialog_greetings)


func _exit_tree():
	pass


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if dialog == null:
		warnings.append("Dialog Collection not assigned.")
	
	if shop == null:
		warnings.append("Shop Offer not assigned.")
	
	if stats == null:
		warnings.append("Trait Set not assigned.")
	
	if quest == null:
		warnings.append("Quest Data not assigned.")
	
	return warnings

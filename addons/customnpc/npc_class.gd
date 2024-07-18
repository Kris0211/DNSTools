@icon("res://icon.svg")
class_name CustomNPC extends Button

@export_category("CustomNPC Data")
@export var sprite: Texture2D
@export var dialog: DialogCollection
@export var shop: ShopOffer
@export var stats: TraitSet
@export var quest: QuestData


func _ready() -> void:
	if dialog != null:
		print(dialog.speaker_name + ": " + dialog.dialog_greetings)


@tool
extends Control

@export_group("Card Properties", "card_")
@export var card_icon: Texture2D
@export var card_name: String
@export var card_flavour: String
@export_multiline var card_text: String

@export var offset_text: bool = true

@onready var ref_card_name: RichTextLabel = $Name
@onready var ref_card_text: RichTextLabel = %CardText
@onready var ref_card_flavour: RichTextLabel = get_node("Flavour")
@onready var ref_card_icon: TextureRect = get_node(^"Image")

func _process(_delta) -> void:
	ref_card_name.text = "[center]" + card_name + "[/center]"
	ref_card_flavour.text = "[center][i]" + card_flavour + "[/i][/center]"
	if offset_text:
		ref_card_text.text = "\n[center]" + card_text + "[/center]"
	else:
		ref_card_text.text = "[center]" + card_text + "[/center]"
	ref_card_icon.set_texture(card_icon)

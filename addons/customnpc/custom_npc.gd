@tool
extends EditorPlugin

var npc_script = load("res://addons/customnpc/npc.gd")
var npc_icon = load("res://icon.svg")

func _enter_tree():
	add_custom_type("NPC", "Button", npc_script, npc_icon)


func _exit_tree():
	remove_custom_type("NPC")


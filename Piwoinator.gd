@tool
extends EditorScript

var piwo := preload("res://studenty/images/piwo.png") as Texture2D

func _run():
	for node: Node in get_all_children(get_scene()):
		var sprite := node as Sprite2D
		if sprite == null: # If cast failed, we move on - not a Sprite2D
			return
		
		var is_instanced_subscene_child = node != get_scene() \
				and node.owner != get_scene()
		if !is_instanced_subscene_child:
			sprite.set_texture(piwo)


func get_all_children(in_node: Node, children: Array[Node] = []) -> Array:
	children.push_back(in_node)
	for child: Node in in_node.get_children():
		children = get_all_children(child, children)
	
	return children

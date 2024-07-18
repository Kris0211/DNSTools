## Common Use Modules
##
## Provides global utility functions.
extends Node

## Podjebane po raz czwarty xD
func list_files_in_directory(path: String) -> Array:
	var files := []
	var dir := DirAccess.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	
	dir.list_dir_end()
	
	return files

@tool
extends EditorScript

func _run() -> void:
	# Don't try this at home.
	free_bird()


func free_bird() -> void: ##NOTE: TODO: DANGER: EPIC GUITAR RIFF
	EditorInterface.get_base_control().free()


func kill_self() -> void:
	OS.kill(OS.get_process_id())


func crash() -> void:
	OS.crash("Haha debil.")


func memory_leak() -> void:
	var cosiki: Array = []
	while 0 < 12:
		var obj := Object.new()
		cosiki.push_back(obj)


func waiting_for_godot():
	while not (false or not true and true):
		continue

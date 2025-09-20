extends Node

func sleep(time: float):
	return await get_tree().create_timer(time).timeout
	
func debug(str1: Variant, str2: Variant = "")-> void:
	prints('[DEBUG]', str1, str2)

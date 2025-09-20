extends Node

signal room_changed(room_name)

var current_room: Node
var transition_active: bool = false

var THREAD_LOAD_IN_PROGRESS = 1

func change_room(room_name: String, player_spawn: Vector2 = Vector2.ZERO):
	if transition_active:
		return
	
	transition_active = true
	#show_transition_effect()
	
	var tree = get_tree()
	
	var room_scene = PreloadManager.get_preloaded_room(room_name)
	
	tree.change_scene_to_packed(room_scene)
	GameState.player_state.position = player_spawn
	
	#hide_transition_effect()
	transition_active = false
	room_changed.emit(room_name)

extends Node

const ROOM_PATHS = {
	"menu": "res://scenes/ui/MainMenu/MainMenu.tscn",
	"hub": "res://scenes/rooms/hub/hub.tscn",
	"market": "res://scenes/rooms/market/market.tscn",
}

var preloaded_rooms: Dictionary = {}

func preload_room(room_name: String):
	if not preloaded_rooms.has(room_name) and ROOM_PATHS.has(room_name):
		var room_path = ROOM_PATHS[room_name]
		ResourceLoader.load_threaded_request(room_path)
		while ResourceLoader.load_threaded_get_status(room_path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			await get_tree().physics_frame
			preloaded_rooms[room_name] = ResourceLoader.load_threaded_get(room_path)

func get_preloaded_room(room_name: String) -> PackedScene:
	if not preloaded_rooms.has(room_name):
		assert(false, 'Room ' + room_name + ' not loaded')
	return preloaded_rooms[room_name]

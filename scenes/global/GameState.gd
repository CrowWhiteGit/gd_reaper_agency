extends Node

var player_state: Dictionary = {}
var world_state: Dictionary = {}
var visited_rooms: Array = []

var player_node = preload("res://scenes/game/characters/Player/player.tscn")

func init():
	pass

func save_room_state(room_name: String, state: Dictionary):
	world_state[room_name] = state

func get_room_state(room_name: String) -> Dictionary:
	return world_state.get(room_name, {})

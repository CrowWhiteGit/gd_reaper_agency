extends Node
class_name BaseRoom

@export var _name: String

@onready var camera = $Camera
@onready var transitions = $Transitions

var _player: BaseCharacter

func _ready():
	_player = GameState.player_node.instantiate()
	_player.position = GameState.player_state.get('position', Vector2.ZERO)
	add_child(_player)
	camera.enabled = true

	_get_adjacent_rooms().all(PreloadManager.preload_room)
	
func _physics_process(_delta: float) -> void:
	camera.position = _player.position
	
func _exit_tree() -> void:
	camera.enabled = false
	
func _get_adjacent_rooms():
	return transitions.get_children().map(func(item): return item.target_room)

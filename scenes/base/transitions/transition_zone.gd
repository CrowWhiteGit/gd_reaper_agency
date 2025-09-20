extends Area2D

@export var target_room: String
@export var target_spawn: Vector2

func _on_body_entered(body):
	#pass
	WorldManager.change_room(target_room, target_spawn)

extends Node


func _on_button_pressed() -> void:
	GameState.init()
	WorldManager.change_room('hub', Vector2(1500, 800))

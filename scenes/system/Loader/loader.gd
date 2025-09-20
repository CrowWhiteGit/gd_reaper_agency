extends Control

var scenes_to_preload: Dictionary[String, String] = {
	"menu": "res://scenes/ui/MainMenu/MainMenu.tscn",
	"hub": "res://scenes/rooms/hub/hub.tscn"
}

func _ready():
	# Показываем заставку
	show_splash_screen()
	
	# Инициализируем системы
	initialize_core_systems()
	
	# Предзагружаем сцены
	preload_scenes()
	
	#TODO
	await Helpers.sleep(0.2)
	
	# Переходим к меню
	transition_to_menu()

func show_splash_screen():
	# Анимация заставки
	pass

func initialize_core_systems():
	# Важные системы которые должны быть готовы до меню
	pass

func preload_scenes():
	for scene_name in scenes_to_preload:
		#ResourceLoader.load_threaded_request(scenes_to_preload.get(scene_name))
		PreloadManager.preload_room(scene_name)

func transition_to_menu():
	#var menu = ResourceLoader.load_threaded_get(scenes_to_preload.get('menu'))
	var menu = PreloadManager.get_preloaded_room('menu')
	get_tree().change_scene_to_packed(menu)

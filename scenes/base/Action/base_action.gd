extends Node
class_name BaseAction

@export_category("BaseAction")
@export var actionName: String

var _parent: BaseCharacter

var started = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_parent = get_parent().get_parent()
	if _parent is not BaseCharacter:
		var error_mes = 'Action ' + actionName + ' has no parent character'
		push_error(error_mes)
		assert(false, error_mes)
	_parent.actions[actionName] = {
		'handle': handle,
		'start': start,
		'finish': finish,
		'cancel': cancel,
	}
	
func handle(params: Dictionary = {}) -> void:
	#print('Action called ' + actionName)
	pass
	
func start(params: Dictionary = {}) -> void:
	#print('Action started ' + actionName)
	pass
	
func finish(params: Dictionary = {}) -> void:
	#print('Action finished ' + actionName)
	pass
	
func cancel(params: Dictionary = {}) -> void:
	#print('Action canceled ' + actionName)
	pass

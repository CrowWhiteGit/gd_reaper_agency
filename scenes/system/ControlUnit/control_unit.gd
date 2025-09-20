extends Node

class_name ControlUnit

var _parent: BaseCharacter

func _ready() -> void:
	_parent = get_parent()


func _physics_process(_delta: float) -> void:
	getInputAction()

func getInputAction() -> void:
	var _dir = Input.get_axis("left", "right")
	if(_parent._direction != _dir):
		_parent.change_direction(_dir)
	
	#TODO убрать копипаст
	if Input.is_action_just_pressed('jump') && _parent.actions.has('jump'):
		_parent.actions['jump'].start.call()
	if Input.is_action_just_released('jump') && _parent.actions.has('jump'):
		_parent.actions['jump'].finish.call()
	
	if Input.is_action_just_pressed('attack') && _parent.actions.has('attack'):
		_parent.actions['attack'].start.call()
	if Input.is_action_just_released('attack') && _parent.actions.has('attack'):
		_parent.actions['attack'].finish.call()
		
	if Input.is_action_just_pressed('block') && _parent.actions.has('block'):
		_parent.actions['block'].start.call()
	if Input.is_action_just_released('block') && _parent.actions.has('block'):
		_parent.actions['block'].finish.call()
		
	if Input.is_action_just_pressed("shift") && _parent.actions.has('shift'):
		if Input.is_action_pressed("up") && _parent.actions.has('shift_up'):
			_parent.actions['shift_up'].start.call()
		else:
			_parent.actions['shift'].start.call({'forward': _dir == _parent._rotate_direction})
		
	#TODO
	if Input.is_action_pressed("down") && _parent.actions.has('jump_down'):
		_parent.actions['jump_down'].start.call()

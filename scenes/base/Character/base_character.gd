extends CharacterBody2D
class_name BaseCharacter

@export var speed: float
@export var acceleration: float
@export var gravity: float
@export var AI_enabled: bool = true
@export var priority: int

# number from 0 to 8, on start sets collisions
# 2 - player units, 3 - ally, 4 - enemy, could change later but seems fine for now
# 0 is empty
@export var fraction: int = 0

#TODO
@export var max_hp = 120
var hp

@export var max_stamina = 100
var stamina

var actions: Dictionary = {}

var state: Dictionary = {}

var _hooks: Dictionary = {}

var _current_speed = 0.0
var _target_speed = 0.0
var _direction = 0
var _rotate_direction = 1
var _direction_locked = false

#@onready var animation: AnimationPlayer = $Animation
#@onready var sprite: Sprite2D = $Sprite

func _physics_process(delta: float) -> void:
	if state.get('disabled', false):
		if state.get('disabled_to', 0) < Time.get_ticks_msec():
			state['disabled'] = false
			stamina = max_stamina
	
	var on_floor = is_on_floor()
	var on_wall = is_on_wall()
	
	if not on_floor:
		velocity.y += get_gravity().y * delta * gravity
	
	if on_wall:
		#TODO
		pass
		
	if speed > 0 && acceleration > 0:
		_target_speed = _direction * speed
		
		var diff = _target_speed - _current_speed
		var speed_change = diff if abs(diff) < abs(acceleration) else abs(diff) / diff * acceleration
		_current_speed += speed_change
		velocity.x = _current_speed * delta

	move_and_slide()

func _on_ready() -> void:
	#TODO CRUTCH
	var group = 'ally' if fraction == 0 else 'enemy'
	add_to_group(group)
	
	collision_layer = pow(2, fraction + 4)
	hp = max_hp
	stamina = max_stamina
	#_invalidate()
		
#func _invalidate() -> void:
	#var bars_visible = !(hp == max_hp || hp <= 0)
	#bar_hp_current.visible = bars_visible
	#bar_hp_bg.visible = bars_visible
	#
	#var new_size = 150 * hp / max_hp
	#bar_hp_current.position.x = -(new_size / 2)
	#bar_hp_current.size.x = new_size
	#bar_hp_bg.size.x = 150
	
func _die() -> void:
	queue_free()
	
func _stagger() -> void:
	state['disabled'] = true
	state['disabled_to'] = Time.get_ticks_msec() + 2000
	change_direction(0)
	
func take_damage(attack_info: Dictionary = {}, apply_hooks = true) -> Dictionary:
	if _hooks.has(EHook.BEFORE_DAMAGE) && apply_hooks:
		for key in _hooks[EHook.BEFORE_DAMAGE].keys():
			var hook = _hooks[EHook.BEFORE_DAMAGE][key] as Callable
			attack_info = hook.call(attack_info)
			
	var damage = attack_info.get('damage', 0)
	if not state.get('disabled'): 
		#TODO add armor to base
		damage *= 0.4
	if damage > 0:
		hp -= damage
	stamina -= attack_info.get('stagger', 0)
	
	#_invalidate()
	if hp <= 0:
		_die()
	if stamina <= 0:
		_stagger()
		
	return attack_info
	
func heal(amount: int):
	#TODO add hooks
	var injures = max_hp - hp
	if amount > injures:
		amount = injures
	hp += amount
	#_invalidate()
	
func push(params: Dictionary) -> void:
	var push_x = params.vector.x
	var push_y = params.vector.y
	
	_current_speed += 100 * push_x
	velocity.y += push_y
	
func change_direction(new_direction: int, lock = false) -> void:
	_direction = new_direction
	if !_direction_locked: _handle_direction_change()
	if lock: change_direction_lock(true)
	
func change_direction_lock(value: bool, caller: String = 'idk'):
	_direction_locked = value;
	if !_direction_locked: _handle_direction_change()
	
func _handle_direction_change() -> void:
	if _direction != _rotate_direction && _direction != 0:
		scale.x *= -1
		_rotate_direction = _direction
	
func add_hook(hook_name: Variant, id: String, value: Callable) -> void:
	if !_hooks.has(hook_name):
		_hooks[hook_name] = {}
		
	_hooks[hook_name][id] = value
		
func remove_hook(hook_name: Variant, id: String) -> void:
	if !_hooks.has(hook_name):
		return
	
	(_hooks[hook_name] as Dictionary).erase(id)
	
func set_state(key: String, value: Variant):
	state[key] = value

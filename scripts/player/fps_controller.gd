extends CharacterBody3D
## FPS Controller - First person player movement

@export var walk_speed: float = 5.0
@export var run_speed: float = 8.0
@export var jump_velocity: float = 5.0
@export var mouse_sensitivity: float = 0.002
@export var gravity: float = 25.0

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var weapon_holder: Node3D = $Head/Camera3D/WeaponHolder

var current_weapon: Node3D = null
var health: float = 100.0
var max_health: float = 100.0
var is_dead: bool = false
var current_sensitivity: float = 0.002
var touch_move_vector: Vector2 = Vector2.ZERO
var touch_look_vector: Vector2 = Vector2.ZERO
var touch_jump: bool = false
var is_mobile: bool = false

signal health_changed(health: float, max_health: float)
signal died

func _ready() -> void:
	is_mobile = GameManager.is_mobile
	current_sensitivity = 0.005 if is_mobile else mouse_sensitivity
	if not is_mobile:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_equip_weapon(GameManager.selected_weapon)

func _physics_process(delta: float) -> void:
	if is_dead: return
	if not is_on_floor():
		velocity.y -= gravity * delta
	var input_dir := _get_movement_input()
	var speed := run_speed
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	if touch_jump and is_on_floor():
		velocity.y = jump_velocity
		touch_jump = false
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if is_dead: return
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_rotate_look(-event.relative.x * current_sensitivity, -event.relative.y * current_sensitivity)
	if is_mobile and touch_look_vector != Vector2.ZERO:
		_rotate_look(-touch_look_vector.x * current_sensitivity * 0.5, -touch_look_vector.y * current_sensitivity * 0.5)
		touch_look_vector = Vector2.ZERO
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_fire()
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE and is_on_floor():
		velocity.y = jump_velocity

func _get_movement_input() -> Vector2:
	if is_mobile:
		return touch_move_vector
	return Input.get_vector("move_left", "move_right", "move_forward", "move_back")

func _rotate_look(yaw: float, pitch: float) -> void:
	rotate_y(yaw)
	head.rotate_x(pitch)
	head.rotation.x = clamp(head.rotation.x, -PI/2, PI/2)

func _fire() -> void:
	if current_weapon and current_weapon.has_method("trigger"):
		current_weapon.trigger()

func take_damage(amount: float) -> void:
	if is_dead: return
	health -= amount
	health_changed.emit(health, max_health)
	if health <= 0:
		die()

func die() -> void:
	is_dead = true
	GameManager.add_death()
	died.emit()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func heal(amount: float) -> void:
	health = min(health + amount, max_health)
	health_changed.emit(health, max_health)

func _equip_weapon(weapon_id: String) -> void:
	for child in weapon_holder.get_children():
		child.queue_free()
	var weapon_path := "res://scenes/game/weapons/%s.tscn" % weapon_id
	if ResourceLoader.exists(weapon_path):
		var inst: Node3D = load(weapon_path).instantiate()
		weapon_holder.add_child(inst)
		current_weapon = inst

func set_touch_movement(vec: Vector2) -> void:
	touch_move_vector = vec

func set_touch_look(delta: Vector2) -> void:
	touch_look_vector = delta

func set_touch_fire(_firing: bool) -> void:
	_fire()

func set_touch_jump() -> void:
	touch_jump = true

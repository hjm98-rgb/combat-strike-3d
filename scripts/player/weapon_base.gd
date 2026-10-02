extends Node3D
## WeaponBase - All weapons inherit this

@export var weapon_name: String = "AK-47"
@export var damage: float = 25.0
@export var fire_rate: float = 0.1
@export var magazine_size: int = 30
@export var reserve_ammo: int = 90
@export var reload_time: float = 2.5
@export var range: float = 100.0
@export var spread: float = 0.02
@export var var auto_aim: bool = true
@export var recoil: float = 0.5
@export var is_full_auto: bool = true

@onready var raycast: RayCast3D = $RayCast3D

var current_ammo: int = 30
var is_reloading: bool = false
var is_firing: bool = false
var fire_cooldown: float = 0.0

signal ammo_changed(current: int, reserve: int)
signal fired(hit_position: Vector3)
signal reloading
signal reload_complete

func _ready() -> void:
	current_ammo = magazine_size
	ammo_changed.emit(current_ammo, reserve_ammo)

func _process(delta: float) -> void:
	if fire_cooldown > 0:
		fire_cooldown -= delta
	if is_firing and is_full_auto and fire_cooldown <= 0 and not is_reloading:
		_shoot()

func trigger() -> void:
	if is_reloading or fire_cooldown > 0: return
	if current_ammo <= 0:
		reload()
		return
	if is_full_auto:
		is_firing = true
	else:
		_shoot()

func release_trigger() -> void:
	is_firing = false

func _shoot() -> void:
	if current_ammo <= 0 or is_reloading:
		reload()
		return
	current_ammo -= 1
	fire_cooldown = fire_rate
	ammo_changed.emit(current_ammo, reserve_ammo)
	var space_state := get_world_3d().direct_space_state
	var from := global_position
	var to := from - global_transform.basis.z * range
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [get_parent()] if get_parent() else []
	var hit := space_state.intersect_ray(query)
	var hit_point := to
	if hit:
		hit_point = hit.position
		var hit_body: Object = hit.collider
		if hit_body and hit_body.has_method("take_damage"):
			hit_body.take_damage(damage)
	fired.emit(hit_point)
	if current_ammo <= 0:
		reload()

func reload() -> void:
	if is_reloading or current_ammo == magazine_size or reserve_ammo <= 0: return
	is_reloading = true
	reloading.emit()
	await get_tree().create_timer(reload_time).timeout
	var needed := magazine_size - current_ammo
	var taken := mini(needed, reserve_ammo)
	current_ammo += taken
	reserve_ammo -= taken
	is_reloading = false
	reload_complete.emit()
	ammo_changed.emit(current_ammo, reserve_ammo)

func set_aim(_down: bool) -> void:
	pass

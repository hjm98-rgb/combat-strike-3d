extends Node3D
## WeaponBase - Base weapon script for FPS

signal fired
signal reloaded

export var weapon_name: String = "Rifle"
export var damage: float = 25.0
export var fire_rate: float = 0.1
export var magazine_size: int = 30
export var reload_time: float = 2.5
export var spread: float = 0.025
export var recoil: float = 0.6
export var is_full_auto: bool = true

var current_ammo: int = 30
var reserve_ammo: int = 90
var can_fire: bool = true
var is_reloading: bool = false

@onready var muzzle: Node3D = $Muzzle
@onready var raycast: RayCast3D = $RayCast3D

func _ready() -> void:
	current_ammo = magazine_size

func try_fire() -> bool:
	if not can_fire or is_reloading or current_ammo <= 0:
		return false
	can_fire = false
	current_ammo -= 1
	fired.emit()
	if raycast and raycast.is_colliding():
		var target: Object = raycast.get_collider()
		if target and target.has_method("take_damage"):
			target.take_damage(damage)
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true
	return true

func start_reload() -> void:
	if is_reloading or current_ammo == magazine_size:
		return
	is_reloading = true
	reloaded.emit()
	await get_tree().create_timer(reload_time).timeout
	var need: int = magazine_size - current_ammo
	var take: int = min(need, reserve_ammo)
	current_ammo += take
	reserve_ammo -= take
	is_reloading = false

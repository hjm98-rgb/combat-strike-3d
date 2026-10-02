extends CharacterBody3D
## Bot AI - Enemy soldier with navigation and shooting

@export var bot_name: String = "Enemy Bot"
@export var max_health: float = 100.0
@export var move_speed: float = 4.0
@export var sight_range: float = 30.0
@export var attack_range: float = 25.0
@export var accuracy: float = 0.5
@export var reaction_time: float = 1.0
@export var fire_rate: float = 0.15
@export var damage: float = 15.0

enum State { PATROL, CHASE, ATTACK, SEARCH, DEAD }

var state: State = State.PATROL
var health: float = 100.0
var target: Node3D = null
var sight_timer: float = 0.0
var attack_timer: float = 0.0
var reaction_timer: float = 0.0
var has_seen_target: bool = false
var last_known_pos: Vector3 = Vector3.ZERO
var is_dead: bool = false

@onready var head: Node3D = get_node_or_null("Head")
@onready var body_mesh: MeshInstance3D = get_node_or_null("BodyMesh")
@onready var gun_muzzle: Node3D = get_node_or_null("Head/Camera3D/GunMuzzle")
@onready var collision: CollisionShape3D = get_node_or_null("CollisionShape3D")

func _ready() -> void:
	health = max_health
	target = get_tree().current_scene.get_node_or_null("Player")

func _physics_process(delta: float) -> void:
	if is_dead: return
	match state:
		State.PATROL: _patrol(delta)
		State.CHASE: _chase(delta)
		State.ATTACK: _attack(delta)
		State.SEARCH: _search(delta)
	sight_timer -= delta
	if sight_timer <= 0:
		sight_timer = 0.1
		_check_sight()

func _patrol(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 25.0 * delta
	move_and_slide()

func _chase(delta: float) -> void:
	if not target:
		state = State.PATROL
		return
	var face_dir := target.global_position - global_position
	face_dir.y = 0
	if face_dir.length() > 0.1:
		look_at(global_position + face_dir, Vector3.UP)
	velocity.x = face_dir.normalized().x * move_speed
	velocity.z = face_dir.normalized().z * move_speed
	if not is_on_floor():
		velocity.y -= 25.0 * delta
	move_and_slide()

func _attack(delta: float) -> void:
	if not target:
		state = State.PATROL
		return
	var face_dir := target.global_position - global_position
	face_dir.y = 0
	if face_dir.length() > 0.1:
		look_at(global_position + face_dir, Vector3.UP)
	velocity.x = move_toward(velocity.x, 0, move_speed)
	velocity.z = move_toward(velocity.z, 0, move_speed)
	attack_timer -= delta
	if attack_timer <= 0:
		attack_timer = fire_rate
		_shoot_at_target()
	var dist := global_position.distance_to(target.global_position)
	if dist > attack_range * 1.5:
		state = State.CHASE

func _search(delta: float) -> void:
	if head: head.rotate_y(0.02)
	if not is_on_floor():
		velocity.y -= 25.0 * delta
	move_and_slide()

func _check_sight() -> void:
	if not target or is_dead: return
	var dist := global_position.distance_to(target.global_position)
	if dist > sight_range:
		if has_seen_target:
			state = State.SEARCH
			last_known_pos = target.global_position
			has_seen_target = false
		return
	var from: Vector3 = gun_muzzle.global_position if gun_muzzle else global_position + Vector3(0, 1.5, 0)
	var to: Vector3 = target.global_position + Vector3(0, 0.5, 0)
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [self]
	var hit := space_state.intersect_ray(query)
	if hit and hit.collider == target:
		has_seen_target = true
		last_known_pos = target.global_position
		if dist <= attack_range:
			state = State.ATTACK
		else:
			state = State.CHASE
	else:
		if has_seen_target:
			state = State.SEARCH
			last_known_pos = target.global_position
			has_seen_target = false

func _shoot_at_target() -> void:
	if not target: return
	var dist := global_position.distance_to(target.global_position)
	var distance_mod: float = clamp(1.0 - dist / sight_range, 0.2, 1.0)
	var hit_chance := accuracy * distance_mod
	if randf() < hit_chance:
		if target.has_method("take_damage"):
			target.take_damage(damage * randf_range(0.8, 1.2))

func take_damage(amount: float) -> void:
	if is_dead: return
	health -= amount
	has_seen_target = true
	reaction_timer = 0.0
	if target:
		last_known_pos = target.global_position
	state = State.CHASE
	if health <= 0:
		die()

func die() -> void:
	is_dead = true
	state = State.DEAD
	GameManager.add_kill()
	EventManager.update_mission_progress("first_blood")
	EventManager.update_mission_progress("killer_5")
	if body_mesh:
		body_mesh.rotate_z(PI / 2)
		body_mesh.position.y = -0.5
	if collision:
		collision.disabled = true
	await get_tree().create_timer(3.0).timeout
	if is_inside_tree():
		queue_free()

func set_difficulty(acc: float, reaction: float, dmg: float) -> void:
	accuracy = acc
	reaction_time = reaction
	damage = dmg

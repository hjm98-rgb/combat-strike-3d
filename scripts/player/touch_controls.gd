extends Control
## TouchControls - Mobile on-screen buttons

var player: CharacterBody3D = null
var joystick_id: int = -1
var look_id: int = -1
var joystick_center: Vector2 = Vector2.ZERO
var joystick_radius: float = 80.0
var look_last_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	visible = GameManager.is_mobile
	if not visible: return
	await get_tree().process_frame
	player = get_tree().current_scene.get_node_or_null("Player")

func _input(event: InputEvent) -> void:
	if not visible: return
	if event is InputEventScreenTouch:
		if event.pressed:
			if joystick_id == -1:
				joystick_id = event.index
				joystick_center = event.position
			elif look_id == -1:
				look_id = event.index
				look_last_pos = event.position
		else:
			if event.index == joystick_id:
				joystick_id = -1
				if player: player.set_touch_movement(Vector2.ZERO)
			elif event.index == look_id:
				look_id = -1
	elif event is InputEventScreenDrag:
		if event.index == joystick_id:
			var diff: Vector2 = event.position - joystick_center
			diff = diff.limit_length(joystick_radius)
			var move_vec := Vector2(diff.x / joystick_radius, diff.y / joystick_radius)
			if player: player.set_touch_movement(move_vec)
		elif event.index == look_id:
			var delta: Vector2 = event.position - look_last_pos
			look_last_pos = event.position
			if player: player.set_touch_look(delta)

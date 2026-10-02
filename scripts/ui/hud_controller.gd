extends Control
## HUD - In-game heads-up display (null-safe)

@onready var health_bar: ProgressBar = get_node_or_null("HealthBar")
@onready var ammo_label: Label = get_node_or_null("AmmoLabel")
@onready var score_label: Label = get_node_or_null("ScoreLabel")
@onready var damage_overlay: ColorRect = get_node_or_null("DamageOverlay")
@onready var respawn_panel: PanelContainer = get_node_or_null("RespawnPanel")
@onready var respawn_timer: Label = get_node_or_null("RespawnTimer")

var player: CharacterBody3D = null
var respawn_countdown: float = 3.0
var respawning: bool = false

func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().current_scene.get_node_or_null("Player")
	if player:
		if player.has_signal("health_changed"):
			player.health_changed.connect(_on_health_changed)
		if player.has_signal("died"):
			player.died.connect(_on_player_died)

func _process(delta: float) -> void:
	if score_label:
		score_label.text = "我方: %d  敌方: %d" % [GameManager.match_score, GameManager.enemy_score]
	if respawning:
		respawn_countdown -= delta
		if respawn_timer:
			respawn_timer.text = "重生中... %.1f" % max(respawn_countdown, 0)
		if respawn_countdown <= 0:
			_respawn()

func _on_health_changed(hp: float, _max_hp: float) -> void:
	if health_bar:
		health_bar.value = hp
		health_bar.modulate = Color.RED if hp < 30 else Color.GREEN

func _on_player_died() -> void:
	respawning = true
	respawn_countdown = 3.0
	if respawn_panel: respawn_panel.visible = true
	if damage_overlay: damage_overlay.color = Color(0.5, 0, 0, 0.5)

func _respawn() -> void:
	respawning = false
	if respawn_panel: respawn_panel.visible = false
	if damage_overlay: damage_overlay.color = Color(0, 0, 0, 0)
	if player:
		player.is_dead = false
		player.health = 100.0
		player.health_changed.emit(100.0, 100.0)
		var spawn: Node3D = get_tree().current_scene.get_node_or_null("SpawnPoint")
		if spawn: player.global_position = spawn.global_position

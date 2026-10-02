extends Node
## GameManager - Global game state and scene transition

signal scene_changed(scene_path: String)

var current_scene: String = ""
var is_logged_in: bool = false
var account_type: String = ""
var player_name: String = "Recruit"
var player_level: int = 1
var xp: int = 0
var credits: int = 500
var kd_ratio: float = 1.0
var total_kills: int = 0
var total_deaths: int = 0
var wins: int = 0
var losses: int = 0
var selected_weapon: String = "rifle_ak47"
var owned_weapons: Array = ["rifle_ak47"]
var maps_unlocked: Array = ["urban"]
var current_map: String = "urban"
var in_match: bool = false
var match_score: int = 0
var enemy_score: int = 0
var max_score: int = 40
var use_bots: bool = false
var bot_count: int = 5
var is_mobile: bool = OS.has_feature("mobile")

func _ready() -> void:
	detect_platform()
	SaveSystem.load_game()

func detect_platform() -> void:
	is_mobile = OS.has_feature("mobile")
	if OS.has_feature("web"):
		is_mobile = DisplayServer.screen_get_size().x < 800

func change_scene(scene_path: String) -> void:
	current_scene = scene_path
	get_tree().change_scene_to_file(scene_path)
	scene_changed.emit(scene_path)

func add_kill() -> void:
	total_kills += 1
	match_score += 1
	_recalc_kd()
	SaveSystem.save_game()

func add_death() -> void:
	total_deaths += 1
	_recalc_kd()
	SaveSystem.save_game()

func _recalc_kd() -> void:
	if total_deaths > 0:
		kd_ratio = float(total_kills) / float(total_deaths)
	else:
		kd_ratio = float(total_kills)

func add_xp(amount: int) -> void:
	xp += amount
	var xp_needed = player_level * 1000
	if xp >= xp_needed:
		xp -= xp_needed
		player_level += 1
		credits += 200

func add_credits(amount: int) -> void:
	credits += amount

func purchase_weapon(weapon_id: String, cost: int) -> bool:
	if owned_weapons.has(weapon_id):
		return false
	if credits >= cost:
		credits -= cost
		owned_weapons.append(weapon_id)
		SaveSystem.save_game()
		return true
	return false

func select_weapon(weapon_id: String) -> void:
	if owned_weapons.has(weapon_id):
		selected_weapon = weapon_id
		SaveSystem.save_game()

func reset_match() -> void:
	in_match = false
	match_score = 0
	enemy_score = 0

extends Node
## GameManager - Global game state with weapon upgrades

signal scene_changed(scene_path: String)
signal player_stats_changed
signal match_score_changed
signal level_up(new_level: int)

var current_scene: String = ""
var is_logged_in: bool = false
var account_type: String = ""
var player_name: String = "士兵"
var player_level: int = 1
var xp: int = 0
var credits: int = 500
var kd_ratio: float = 1.0
var total_kills: int = 0
var total_deaths: int = 0
var wins: int = 0
var losses: int = 0
var selected_weapon: String = "rifle_ak47"
var owned_weapons: Dictionary = {}
var weapon_kills: Dictionary = {}
var maps_unlocked: Array = ["urban"]
var current_map: String = "urban"
var current_mode: String = "team_deathmatch"
var in_match: bool = false
var match_score: int = 0
var enemy_score: int = 0
var match_kills: int = 0
var match_deaths: int = 0
var max_score: int = 50
var max_players: int = 15
var use_bots: bool = false
var bot_count: int = 12
var is_mobile: bool = OS.has_feature("mobile")

var game_modes: Dictionary = {
	"team_deathmatch": {"name": "团队竞技", "desc": "15人分组对抗，先到50杀获胜", "team_size": 7, "score_target": 50},
	"metro_battle": {"name": "地铁逃生", "desc": "收集物资，安全区缩小，活到最后", "team_size": 15, "score_target": 0, "battle_royale": true},
	"free_for_all": {"name": "个人竞技", "desc": "15人各自为战，先到40杀获胜", "team_size": 15, "score_target": 40},
	"search_destroy": {"name": "爆破模式", "desc": "攻方安放炸弹，守方拆除", "team_size": 5, "score_target": 8, "round_based": true}
}

func _ready() -> void:
	detect_platform()
	owned_weapons["rifle_ak47"] = {"level": 1, "stars": 0}
	weapon_kills["rifle_ak47"] = 0
	SaveSystem.load_game()

func detect_platform() -> void:
	is_mobile = OS.has_feature("mobile")
	if OS.has_feature("web"):
		is_mobile = DisplayServer.screen_get_size().x < 800

func change_scene(scene_path: String) -> void:
	current_scene = scene_path
	get_tree().change_scene_to_file(scene_path)
	scene_changed.emit(scene_path)

func add_kill(weapon_id: String = "") -> void:
	total_kills += 1
	match_kills += 1
	match_score += 1
	if weapon_id != "":
		weapon_kills[weapon_id] = weapon_kills.get(weapon_id, 0) + 1
	_recalc_kd()
	SaveSystem.save_game()

func add_death() -> void:
	total_deaths += 1
	match_deaths += 1
	enemy_score += 1
	_recalc_kd()

func _recalc_kd() -> void:
	if total_deaths > 0:
		kd_ratio = float(total_kills) / float(total_deaths)
	else:
		kd_ratio = float(total_kills)

func add_xp(amount: int) -> void:
	xp += amount
	var xp_needed: int = player_level * 1000
	if xp >= xp_needed:
		xp -= xp_needed
		player_level += 1
		credits += 200
		level_up.emit(player_level)

func add_credits(amount: int) -> void:
	credits += amount

func purchase_weapon(weapon_id: String, cost: int) -> bool:
	if owned_weapons.has(weapon_id): return false
	if credits >= cost:
		credits -= cost
		owned_weapons[weapon_id] = {"level": 1, "stars": 0}
		weapon_kills[weapon_id] = 0
		SaveSystem.save_game()
		return true
	return false

func upgrade_weapon(weapon_id: String) -> Dictionary:
	if not owned_weapons.has(weapon_id): return {"success": false, "reason": "未拥有"}
	var w: Dictionary = owned_weapons[weapon_id]
	var cost: int = w.level * 500
	if credits < cost: return {"success": false, "reason": "金币不足"}
	if w.level >= 10: return {"success": false, "reason": "已满级"}
	credits -= cost
	w.level += 1
	if w.level % 3 == 0: w.stars += 1
	owned_weapons[weapon_id] = w
	SaveSystem.save_game()
	return {"success": true, "new_level": w.level, "cost": cost}

func get_weapon_level(weapon_id: String) -> int:
	if owned_weapons.has(weapon_id):
		return owned_weapons[weapon_id].level
	return 0

func select_weapon(weapon_id: String) -> void:
	if owned_weapons.has(weapon_id):
		selected_weapon = weapon_id
		SaveSystem.save_game()

func start_match(mode: String, map: String) -> void:
	current_mode = mode
	current_map = map
	in_match = true
	match_kills = 0
	match_deaths = 0
	match_score = 0
	enemy_score = 0
	var md: Dictionary = game_modes.get(mode, game_modes["team_deathmatch"])
	max_score = md.get("score_target", 50)

func end_match(did_win: bool) -> Dictionary:
	in_match = false
	if did_win:
		wins += 1
		add_credits(500 + match_kills * 20)
		add_xp(800)
	else:
		losses += 1
		add_credits(200)
		add_xp(300)
	SaveSystem.save_game()
	return {"win": did_win, "kills": match_kills, "deaths": match_deaths, "kd": float(match_kills)/max(match_deaths,1), "credits": 500 if did_win else 200, "xp": 800 if did_win else 300, "mode": game_modes[current_mode]["name"], "map": current_map}

func get_meta(key: String, default=null):
	return SaveSystem.get_data(key, default)

func set_meta(key: String, value) -> void:
	SaveSystem.set_data(key, value)
	SaveSystem.save_game()

func reset_match() -> void:
	in_match = false
	match_score = 0
	enemy_score = 0

extends Node
## Matchmaking - KD-based bot difficulty & server selection

signal matchmaking_started
signal matchmaking_found(server_info: Dictionary)

const BOT_TIERS := {
	"easy": {"kd_threshold": 0.8, "accuracy": 0.35, "reaction_time": 1.5, "bot_count": 7, "name": "新兵训练场"},
	"normal": {"kd_threshold": 1.5, "accuracy": 0.50, "reaction_time": 1.0, "bot_count": 5, "name": "标准竞技场"},
	"hard": {"kd_threshold": 3.0, "accuracy": 0.65, "reaction_time": 0.6, "bot_count": 3, "name": "精英战区"},
	"pro": {"kd_threshold": 999.0, "accuracy": 0.75, "reaction_time": 0.4, "bot_count": 2, "name": "职业排位赛"}
}

const SERVERS := [
	{"id": "cn-east-1", "region": "华东", "ping": 32, "players": 24, "max": 32, "name": "上海-01"},
	{"id": "cn-north-1", "region": "华北", "ping": 45, "players": 18, "max": 32, "name": "北京-03"},
	{"id": "cn-south-1", "region": "华南", "ping": 38, "players": 30, "max": 32, "name": "广州-02"},
	{"id": "cn-west-1", "region": "西南", "ping": 55, "players": 12, "max": 32, "name": "成都-01"},
	{"id": "cn-central-1", "region": "华中", "ping": 41, "players": 22, "max": 32, "name": "武汉-05"}
]

func find_match(selected_server: String = "") -> void:
	matchmaking_started.emit()
	await get_tree().create_timer(1.5).timeout
	var tier := _get_bot_tier()
	var bot_settings: Dictionary = BOT_TIERS[tier]
	var server: Dictionary
	if selected_server != "":
		server = _find_server_by_id(selected_server)
	else:
		server = _get_best_server()
	var bot_probability := _calc_bot_probability()
	var use_bots: bool = randf() < bot_probability
	var server_info := {
		"server_name": server.name,
		"region": server.region,
		"ping": server.ping,
		"tier": tier,
		"tier_name": bot_settings.name,
		"bot_accuracy": bot_settings.accuracy,
		"bot_reaction": bot_settings.reaction_time,
		"bot_count": bot_settings.bot_count if use_bots else 0,
		"use_bots": use_bots
	}
	GameManager.use_bots = use_bots
	GameManager.bot_count = bot_settings.bot_count if use_bots else 0
	GameManager.in_match = true
	matchmaking_found.emit(server_info)

func _get_bot_tier() -> String:
	var kd: float = GameManager.kd_ratio
	if kd < 0.8: return "easy"
	elif kd < 1.5: return "normal"
	elif kd < 3.0: return "hard"
	else: return "pro"

func _calc_bot_probability() -> float:
	var kd: float = GameManager.kd_ratio
	if kd < 0.5: return 0.85
	elif kd < 1.0: return 0.70
	elif kd < 1.5: return 0.50
	elif kd < 2.5: return 0.30
	elif kd < 4.0: return 0.15
	else: return 0.05

func _get_best_server() -> Dictionary:
	var best: Dictionary = SERVERS[0]
	for s in SERVERS:
		if s.ping < best.ping and s.players < s.max:
			best = s
	return best

func _find_server_by_id(server_id: String) -> Dictionary:
	for s in SERVERS:
		if s.id == server_id:
			return s
	return _get_best_server()

func get_server_list() -> Array:
	return SERVERS.duplicate(true)

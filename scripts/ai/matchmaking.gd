extends Node
## Matchmaking - 15 players: real online players + bot filler based on KD

signal matchmaking_started
signal matchmaking_progress(current: int, needed: int)
signal matchmaking_found(server_info: Dictionary)
signal matchmaking_failed(reason: String)

const SERVERS := [
	{"id": "cn-east-1", "region": "华东", "ping": 32, "players": 24, "max": 32, "name": "上海-01"},
	{"id": "cn-north-1", "region": "华北", "ping": 45, "players": 18, "max": 32, "name": "北京-03"},
	{"id": "cn-south-1", "region": "华南", "ping": 38, "players": 30, "max": 32, "name": "广州-02"},
	{"id": "cn-west-1", "region": "西南", "ping": 55, "players": 12, "max": 32, "name": "成都-01"},
	{"id": "cn-central-1", "region": "华中", "ping": 41, "players": 22, "max": 32, "name": "武汉-05"}
]

const MATCH_SIZE: int = 15

func find_match(selected_server: String = "", mode: String = "team_deathmatch") -> void:
	matchmaking_started.emit()
	GameManager.start_match(mode, GameManager.current_map)

	var server: Dictionary = _find_server_by_id(selected_server) if selected_server != "" else _get_best_server()
	# Real players currently online on this server
	var real_remaining: int = mini(server.players, MATCH_SIZE - 1)
	# Bot fill probability based on KD
	var bot_prob: float = _calc_bot_probability()

	var filled: int = 1
	var bots_added: int = 0

	while filled < MATCH_SIZE:
		await get_tree().create_timer(0.5).timeout
		if real_remaining > 0 and randf() < 0.7:
			real_remaining -= 1
			filled += 1
		else:
			if randf() < bot_prob:
				bots_added += 1
				filled += 1
			else:
				real_remaining -= 1
				filled += 1
		matchmaking_progress.emit(filled, MATCH_SIZE)

	var bot_settings: Dictionary = _get_bot_settings()
	var info := {
		"server_name": server.name,
		"region": server.region,
		"ping": server.ping,
		"tier_name": bot_settings.name,
		"bot_accuracy": bot_settings.accuracy,
		"bot_reaction": bot_settings.reaction_time,
		"bot_count": bots_added,
		"use_bots": bots_added > 0,
		"real_players": MATCH_SIZE - bots_added,
		"mode": mode
	}

	GameManager.use_bots = bots_added > 0
	GameManager.bot_count = bots_added
	GameManager.in_match = true
	matchmaking_found.emit(info)

func _get_bot_settings() -> Dictionary:
	var kd: float = GameManager.kd_ratio
	if kd < 0.8: return {"accuracy": 0.35, "reaction_time": 1.5, "name": "新兵训练场"}
	elif kd < 1.5: return {"accuracy": 0.50, "reaction_time": 1.0, "name": "标准竞技场"}
	elif kd < 3.0: return {"accuracy": 0.65, "reaction_time": 0.6, "name": "精英战区"}
	else: return {"accuracy": 0.75, "reaction_time": 0.4, "name": "职业排位赛"}

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
		if s.ping < best.ping and s.players < s.max: best = s
	return best

func _find_server_by_id(sid: String) -> Dictionary:
	for s in SERVERS:
		if s.id == sid: return s
	return _get_best_server()

func get_server_list() -> Array:
	return SERVERS.duplicate(true)

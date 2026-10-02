extends Node
## EventManager - Daily rewards, missions, events

signal reward_claimed(reward_name: String, reward_value: int)
signal level_up(level: int)

var active_events: Array = []
var daily_streak: int = 0
var last_claim_date: String = ""

const EVENTS := [
	{"id": "daily_login", "name": "每日登录奖励", "description": "每天登录领取金币，连续登录奖励递增", "rewards": [100,150,200,300,500,800,1200], "type": "daily", "claimed": false},
	{"id": "first_blood", "name": "首杀任务", "description": "在一局游戏中完成首次击杀", "reward": 200, "type": "mission", "target": 1, "progress": 0, "claimed": false},
	{"id": "killer_5", "name": "五杀达人", "description": "单局获得5次击杀", "reward": 500, "type": "mission", "target": 5, "progress": 0, "claimed": false},
	{"id": "weekly_win", "name": "周常胜利", "description": "本周赢得3场比赛", "reward": 1000, "type": "weekly", "target": 3, "progress": 0, "claimed": false},
	{"id": "double_xp", "name": "双倍经验时段", "description": "周末18:00-22:00 经验翻倍", "type": "buff", "active": true},
	{"id": "weekend_sale", "name": "周末特惠", "description": "所有武器7折优惠", "type": "discount", "discount": 0.7, "active": true}
]

func _ready() -> void:
	active_events = EVENTS.duplicate(true)

func claim_daily_reward() -> Dictionary:
	var today := Time.get_date_dict_from_system()
	var today_str := "%d-%02d-%02d" % [today.year, today.month, today.day]
	if last_claim_date == today_str:
		return {"success": false, "reason": "今日已领取"}
	daily_streak += 1
	if daily_streak > 7:
		daily_streak = 1
	var event = _get_event("daily_login")
	var reward_idx := mini(daily_streak - 1, event.rewards.size() - 1)
	var reward_amount: int = event.rewards[reward_idx]
	GameManager.add_credits(reward_amount)
	last_claim_date = today_str
	event["claimed"] = true
	SaveSystem.save_game()
	reward_claimed.emit("每日登录 Day%d" % daily_streak, reward_amount)
	return {"success": true, "day": daily_streak, "reward": reward_amount}

func update_mission_progress(mission_id: String, amount: int = 1) -> void:
	var event = _get_event(mission_id)
	if event.is_empty() or event.get("claimed", false):
		return
	event["progress"] = mini(event.get("progress", 0) + amount, event.get("target", 1))
	if event["progress"] >= event["target"]:
		claim_mission_reward(mission_id)

func claim_mission_reward(mission_id: String) -> bool:
	var event = _get_event(mission_id)
	if event.is_empty() or event.get("claimed", false):
		return false
	if event.get("progress", 0) < event.get("target", 1):
		return false
	event["claimed"] = true
	var reward: int = event.get("reward", 100)
	GameManager.add_credits(reward)
	SaveSystem.save_game()
	reward_claimed.emit(event["name"], reward)
	return true

func _get_event(event_id: String) -> Dictionary:
	for e in active_events:
		if e.get("id", "") == event_id:
			return e
	return {}

func get_discount_multiplier() -> float:
	var sale = _get_event("weekend_sale")
	if sale.get("active", false):
		return sale.get("discount", 1.0)
	return 1.0

func get_xp_multiplier() -> float:
	var buff = _get_event("double_xp")
	if buff.get("active", false):
		var time_dict: Dictionary = Time.get_datetime_dict_from_system()
		var day_of_week: int = time_dict.weekday
		if day_of_week >= 6 and time_dict.hour >= 18 and time_dict.hour < 22:
			return 2.0
	return 1.0

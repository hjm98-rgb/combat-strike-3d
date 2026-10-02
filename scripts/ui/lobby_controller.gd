extends Control
## LobbyScreen - Main menu with weapon shop, servers, events

const WeaponData = preload("res://scripts/data/weapon_data.gd")

@onready var player_name_label: Label = $TopBar/PlayerInfo/NameLabel
@onready var level_label: Label = $TopBar/PlayerInfo/LevelLabel
@onready var credits_label: Label = $TopBar/CreditsLabel
@onready var kd_label: Label = $TopBar/PlayerInfo/KDLabel
@onready var weapon_list: VBoxContainer = $LeftPanel/WeaponList
@onready var weapon_name: Label = $RightPanel/WeaponDetail/Panel/WeaponName
@onready var weapon_stats: Label = $RightPanel/WeaponDetail/Panel/WeaponStats
@onready var weapon_desc: Label = $RightPanel/WeaponDetail/Panel/WeaponDesc
@onready var buy_btn: Button = $RightPanel/WeaponDetail/Panel/BuyButton
@onready var select_btn: Button = $RightPanel/WeaponDetail/Panel/SelectButton
@onready var upgrade_btn: Button = $RightPanel/WeaponDetail/Panel/UpgradeButton
@onready var server_list: ItemList = $BottomPanel/ServerList
@onready var start_btn: Button = $BottomPanel/StartButton
@onready var event_list: VBoxContainer = $RightPanel/EventPanel/Panel/EventList
@onready var daily_reward_btn: Button = $TopBar/DailyRewardButton

var selected_weapon_id: String = ""

func _ready() -> void:
	_refresh_player_info()
	_refresh_weapon_list()
	_refresh_server_list()
	_refresh_events()
	start_btn.pressed.connect(_on_start_matchmaking)
	buy_btn.pressed.connect(_on_buy_weapon)
	select_btn.pressed.connect(_on_select_weapon)
	upgrade_btn.pressed.connect(_on_upgrade_weapon)
	daily_reward_btn.pressed.connect(_on_claim_daily)

func _refresh_player_info() -> void:
	player_name_label.text = GameManager.player_name
	level_label.text = "Lv.%d" % GameManager.player_level
	credits_label.text = "%d 金币" % GameManager.credits
	kd_label.text = "KD: %.2f" % GameManager.kd_ratio

func _refresh_weapon_list() -> void:
	for child in weapon_list.get_children():
		child.queue_free()
	var weapons: Array = WeaponData.get_all_weapons()
	for w in weapons:
		var btn := Button.new()
		var owned: bool = GameManager.owned_weapons.has(w.id)
		var price_text: String = "" if owned else " (%d金币)" % w.price
		btn.text = "%s%s" % [w.name, price_text]
		if w.id == GameManager.selected_weapon:
			btn.text += " ✓"
		btn.pressed.connect(_on_weapon_selected.bind(w.id))
		weapon_list.add_child(btn)

func _on_weapon_selected(weapon_id: String) -> void:
	selected_weapon_id = weapon_id
	var w: Dictionary = WeaponData.get_by_id(weapon_id)
	if w.is_empty(): return
	weapon_name.text = w.name
	weapon_stats.text = "伤害: %d | 射速: %.2f | 弹匣: %d" % [w.damage, w.fire_rate, w.magazine]
	weapon_desc.text = w.desc
	buy_btn.visible = not GameManager.owned_weapons.has(weapon_id)
	select_btn.visible = GameManager.owned_weapons.has(weapon_id)
	upgrade_btn.visible = GameManager.owned_weapons.has(weapon_id)

func _on_buy_weapon() -> void:
	if selected_weapon_id == "": return
	var w: Dictionary = WeaponData.get_by_id(selected_weapon_id)
	var price: int = w.price
	if GameManager.purchase_weapon(selected_weapon_id, price):
		_refresh_player_info()
		_refresh_weapon_list()
		_on_weapon_selected(selected_weapon_id)

func _on_select_weapon() -> void:
	if selected_weapon_id == "": return
	GameManager.select_weapon(selected_weapon_id)
	_refresh_weapon_list()

func _on_upgrade_weapon() -> void:
	if selected_weapon_id == "": return
	var result: Dictionary = GameManager.upgrade_weapon(selected_weapon_id)
	if result.success:
		_refresh_player_info()
		upgrade_btn.text = "升级 (Lv.%d)" % result.new_level

func _refresh_server_list() -> void:
	server_list.clear()
	for s in Matchmaking.get_server_list():
		server_list.add_item("%s | %s | %dms | %d/%d人" % [s.name, s.region, s.ping, s.players, s.max])

func _refresh_events() -> void:
	for child in event_list.get_children():
		child.queue_free()
	var events: Array = EventManager.active_events
	for e in events:
		var card := Label.new()
		card.text = "★ " + e.name
		card.add_theme_color_override("font_color", Color(1, 0.9, 0.3))
		event_list.add_child(card)

func _on_claim_daily() -> void:
	GameManager.add_credits(200)
	GameManager.add_xp(100)
	_refresh_player_info()
	daily_reward_btn.text = "今日已领"

func _on_start_matchmaking() -> void:
	start_btn.text = "匹配中..."
	start_btn.disabled = true
	Matchmaking.find_match("", GameManager.current_mode)
	Matchmaking.matchmaking_found.connect(_on_match_found)

func _on_match_found(_info: Dictionary) -> void:
	GameManager.change_scene("res://scenes/game/%s.tscn" % GameManager.current_map)

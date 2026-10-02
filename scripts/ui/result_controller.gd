extends Control
## ResultScreen - Settlement after match

@onready var result_title: Label = $Panel/VBox/ResultTitle
@onready var result_subtitle: Label = $Panel/VBox/ResultSubtitle
@onready var kills_label: Label = $Panel/VBox/StatsGrid/KillsRow/Value
@onready var deaths_label: Label = $Panel/VBox/StatsGrid/DeathsRow/Value
@onready var kd_label: Label = $Panel/VBox/StatsGrid/KDRow/Value
@onready var credits_label: Label = $Panel/VBox/StatsGrid/CreditsRow/Value
@onready var xp_label: Label = $Panel/VBox/StatsGrid/XPRow/Value
@onready var mode_label: Label = $Panel/VBox/StatsGrid/ModeRow/Value
@onready var map_label: Label = $Panel/VBox/StatsGrid/MapRow/Value
@onready var return_btn: Button = $Panel/VBox/ReturnButton
@onready var replay_btn: Button = $Panel/VBox/ReplayButton

func _ready() -> void:
	return_btn.pressed.connect(_on_return_to_lobby)
	replay_btn.pressed.connect(_on_play_again)
	_show_results()

func _show_results() -> void:
	var did_win: bool = GameManager.match_score >= GameManager.max_score
	var r: Dictionary = GameManager.end_match(did_win)
	if r.win:
		result_title.text = "胜 利"
		result_title.add_theme_color_override("font_color", Color(0.3, 1.0, 0.4))
		result_subtitle.text = "恭喜！你赢得了这场15人竞技"
	else:
		result_title.text = "失 败"
		result_title.add_theme_color_override("font_color", Color(1.0, 0.3, 0.3))
		result_subtitle.text = "再接再厉，士兵！"
	kills_label.text = str(r.kills)
	deaths_label.text = str(r.deaths)
	kd_label.text = "%.2f" % r.kd
	credits_label.text = "+%d" % r.credits
	xp_label.text = "+%d" % r.xp
	mode_label.text = r.mode
	map_label.text = r.map

func _on_return_to_lobby() -> void:
	GameManager.change_scene("res://scenes/lobby/lobby_screen.tscn")

func _on_play_again() -> void:
	GameManager.change_scene("res://scenes/game/%s.tscn" % GameManager.current_map)

extends Node3D
## TutorialScene - Commander-guided first mission

@onready var commander_name: Label = $CommanderPanel/VBox/NameLabel
@onready var commander_dialog: RichTextLabel = $CommanderPanel/VBox/DialogBox
@onready var next_btn: Button = $CommanderPanel/VBox/NextButton
@onready var objective_label: Label = $ObjectiveLabel

var tutorial_steps: Array = []
var current_step: int = 0

func _ready() -> void:
	next_btn.pressed.connect(_next_step)
	commander_name.text = "指挥官 华莱士"
	objective_label.text = "目标：跟随指引完成基础训练"
	tutorial_steps = [
		"欢迎来到战场，新兵。我是你的指挥官华莱士。今天教你如何活下来。",
		"用 WASD 移动（手机用左侧摇杆）。向前走。",
		"移动鼠标转动视角（手机滑动右侧屏幕）。",
		"点击鼠标左键开枪试试。",
		"按 R 键换弹匣。永远不要让弹匣打空。",
		"按空格跳跃。",
		"右键瞄准可以放大视野提高精度。",
		"记住：利用掩体、保持移动、不要孤军深入。去赢得第一场比赛吧！"
	]
	_show_step(0)

func _show_step(step: int) -> void:
	if step >= tutorial_steps.size():
		_complete_tutorial()
		return
	current_step = step
	commander_dialog.text = tutorial_steps[step]
	objective_label.text = "训练 %d/%d" % [step + 1, tutorial_steps.size()]

func _next_step() -> void:
	_show_step(current_step + 1)

func _complete_tutorial() -> void:
	GameManager.set_save_data("tutorial_completed", true)
	SaveSystem.save_game()
	GameManager.add_credits(300)
	GameManager.add_xp(500)
	commander_dialog.text = "训练完成！奖励300金币和500经验。欢迎加入，士兵！"
	next_btn.text = "进入大厅"
	next_btn.pressed.connect(func():
		GameManager.change_scene("res://scenes/lobby/lobby_screen.tscn")
	)

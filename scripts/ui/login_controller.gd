extends Control
## LoginScreen - Phone/Email/Guest with name selection

@onready var phone_input: LineEdit = $CenterPanel/PhoneTab/PhoneInput
@onready var phone_pw: LineEdit = $CenterPanel/PhoneTab/PasswordInput
@onready var email_input: LineEdit = $CenterPanel/EmailTab/EmailInput
@onready var email_pw: LineEdit = $CenterPanel/EmailTab/PasswordInput
@onready var tab_selector: TabContainer = $CenterPanel
@onready var login_btn: Button = $LoginButton
@onready var guest_btn: Button = $GuestButton
@onready var status_label: Label = $StatusLabel
@onready var loading_bar: ProgressBar = $LoadingBar
@onready var name_input: LineEdit = $CenterPanel/NameTab/NameInput

func _ready() -> void:
	login_btn.pressed.connect(_on_login_pressed)
	guest_btn.pressed.connect(_on_guest_pressed)
	AuthSystem.login_success.connect(_on_login_success)
	AuthSystem.login_failed.connect(_on_login_failed)
	loading_bar.visible = false
	var saved: String = GameManager.get_meta("player_name", "")
	if saved != "": name_input.text = saved

func _get_name() -> String:
	var n: String = name_input.text.strip_edges()
	if n.length() < 2:
		status_label.text = "请输入至少2个字的昵称"
		return ""
	return n

func _on_login_pressed() -> void:
	var pn: String = _get_name()
	if pn == "": return
	GameManager.player_name = pn
	GameManager.set_meta("player_name", pn)
	loading_bar.visible = true
	status_label.text = "正在连接服务器..."
	if tab_selector.current_tab == 1:
		AuthSystem.login_with_phone(phone_input.text.strip_edges(), phone_pw.text)
	else:
		AuthSystem.login_with_email(email_input.text.strip_edges(), email_pw.text)

func _on_guest_pressed() -> void:
	var pn: String = _get_name()
	if pn == "": return
	GameManager.player_name = pn
	GameManager.set_meta("player_name", pn)
	loading_bar.visible = true
	status_label.text = "正在以游客身份进入..."
	AuthSystem.login_as_guest()

func _on_login_success(_t: String, _i: String) -> void:
	loading_bar.visible = false
	status_label.text = "登录成功！欢迎，%s" % GameManager.player_name
	await get_tree().create_timer(0.8).timeout
	_enter_game()

func _on_login_failed(reason: String) -> void:
	loading_bar.visible = false
	status_label.text = "错误：" + reason

func _enter_game() -> void:
	if not GameManager.get_meta("tutorial_completed", false):
		GameManager.change_scene("res://scenes/tutorial/tutorial_scene.tscn")
	else:
		GameManager.change_scene("res://scenes/lobby/lobby_screen.tscn")

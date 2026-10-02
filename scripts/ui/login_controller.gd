extends Control
## LoginScreen - Phone / Email / Guest login

@onready var phone_input: LineEdit = $CenterPanel/PhoneTab/PhoneInput
@onready var phone_pw: LineEdit = $CenterPanel/PhoneTab/PasswordInput
@onready var email_input: LineEdit = $CenterPanel/EmailTab/EmailInput
@onready var email_pw: LineEdit = $CenterPanel/EmailTab/PasswordInput
@onready var tab_selector: TabContainer = $CenterPanel
@onready var login_btn: Button = $LoginButton
@onready var guest_btn: Button = $GuestButton
@onready var status_label: Label = $StatusLabel
@onready var loading_bar: ProgressBar = $LoadingBar

func _ready() -> void:
	login_btn.pressed.connect(_on_login_pressed)
	guest_btn.pressed.connect(_on_guest_pressed)
	AuthSystem.login_success.connect(_on_login_success)
	AuthSystem.login_failed.connect(_on_login_failed)
	loading_bar.visible = false

func _on_login_pressed() -> void:
	loading_bar.visible = true
	status_label.text = "正在连接服务器..."
	if tab_selector.current_tab == 0:
		AuthSystem.login_with_phone(phone_input.text.strip_edges(), phone_pw.text)
	else:
		AuthSystem.login_with_email(email_input.text.strip_edges(), email_pw.text)

func _on_guest_pressed() -> void:
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

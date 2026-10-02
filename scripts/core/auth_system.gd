extends Node
## AuthSystem - Phone / Email / Guest login

signal login_success(account_type: String, account_id: String)
signal login_failed(reason: String)

const USERS_PATH := "user://users.cfg"

func login_with_phone(phone: String, password: String) -> void:
	if phone.length() != 11 or not phone.begins_with("1"):
		login_failed.emit("请输入正确的11位手机号")
		return
	if password.length() < 6:
		login_failed.emit("密码至少6位")
		return
	await get_tree().create_timer(0.8).timeout
	GameManager.account_type = "phone"
	GameManager.player_name = "Soldier_" + phone.right(4)
	GameManager.is_logged_in = true
	SaveSystem.save_game()
	login_success.emit("phone", phone)

func login_with_email(email: String, password: String) -> void:
	if not email.contains("@") or not email.contains("."):
		login_failed.emit("请输入正确的邮箱地址")
		return
	if password.length() < 6:
		login_failed.emit("密码至少6位")
		return
	await get_tree().create_timer(0.8).timeout
	GameManager.account_type = "email"
	GameManager.player_name = "Agent_" + email.split("@")[0]
	GameManager.is_logged_in = true
	SaveSystem.save_game()
	login_success.emit("email", email)

func login_as_guest() -> void:
	GameManager.account_type = "guest"
	GameManager.player_name = "Guest_" + str(randi() % 10000)
	GameManager.is_logged_in = true
	SaveSystem.save_game()
	login_success.emit("guest", GameManager.player_name)

func logout() -> void:
	GameManager.is_logged_in = false
	GameManager.account_type = ""
	SaveSystem.save_game()

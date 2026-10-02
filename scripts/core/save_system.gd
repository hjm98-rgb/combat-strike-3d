extends Node
## SaveSystem - Persistent data storage

const SAVE_PATH := "user://savegame.cfg"

func save_game() -> void:
	var config := ConfigFile.new()
	config.set_value("account", "account_type", GameManager.account_type)
	config.set_value("account", "player_name", GameManager.player_name)
	config.set_value("progression", "level", GameManager.player_level)
	config.set_value("progression", "xp", GameManager.xp)
	config.set_value("progression", "credits", GameManager.credits)
	config.set_value("progression", "kills", GameManager.total_kills)
	config.set_value("progression", "deaths", GameManager.total_deaths)
	config.set_value("progression", "wins", GameManager.wins)
	config.set_value("progression", "losses", GameManager.losses)
	config.set_value("inventory", "selected_weapon", GameManager.selected_weapon)
	config.set_value("inventory", "owned_weapons", GameManager.owned_weapons)
	config.set_value("inventory", "maps_unlocked", GameManager.maps_unlocked)
	var d := Time.get_date_dict_from_system()
	config.set_value("events", "last_login_date", "%d-%02d-%02d" % [d.year, d.month, d.day])
	config.save(SAVE_PATH)

func load_game() -> void:
	var config := ConfigFile.new()
	var err := config.load(SAVE_PATH)
	if err != OK:
		print("No save file found, starting fresh")
		return
	GameManager.account_type = config.get_value("account", "account_type", "")
	GameManager.player_name = config.get_value("account", "player_name", "Recruit")
	GameManager.player_level = config.get_value("progression", "level", 1)
	GameManager.xp = config.get_value("progression", "xp", 0)
	GameManager.credits = config.get_value("progression", "credits", 500)
	GameManager.total_kills = config.get_value("progression", "kills", 0)
	GameManager.total_deaths = config.get_value("progression", "deaths", 0)
	GameManager.wins = config.get_value("progression", "wins", 0)
	GameManager.losses = config.get_value("progression", "losses", 0)
	GameManager.selected_weapon = config.get_value("inventory", "selected_weapon", "rifle_ak47")
	GameManager.owned_weapons = config.get_value("inventory", "owned_weapons", ["rifle_ak47"])
	GameManager.maps_unlocked = config.get_value("inventory", "maps_unlocked", ["urban"])
	if GameManager.total_deaths > 0:
		GameManager.kd_ratio = float(GameManager.total_kills) / float(GameManager.total_deaths)
	else:
		GameManager.kd_ratio = float(GameManager.total_kills)

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

class_name WeaponData
extends Resource
## Weapon and map definitions

static func get_weapons() -> Array:
	return [
		{"id": "rifle_ak47", "name": "AK-47 突击步枪", "damage": 25.0, "fire_rate": 0.1, "magazine": 30, "reload_time": 2.5, "spread": 0.025, "recoil": 0.6, "price": 0, "description": "经典可靠的全自动突击步枪"},
		{"id": "rifle_m4a1", "name": "M4A1 卡宾枪", "damage": 22.0, "fire_rate": 0.085, "magazine": 30, "reload_time": 2.2, "spread": 0.015, "recoil": 0.4, "price": 1500, "description": "精准稳定的卡宾枪"},
		{"id": "smg_mp5", "name": "MP5 冲锋枪", "damage": 16.0, "fire_rate": 0.06, "magazine": 35, "reload_time": 2.0, "spread": 0.03, "recoil": 0.3, "price": 1200, "description": "高射速冲锋枪"},
		{"id": "sniper_awm", "name": "AWM 狙击枪", "damage": 100.0, "fire_rate": 1.5, "magazine": 5, "reload_time": 3.5, "spread": 0.001, "recoil": 1.5, "price": 3000, "description": "一击必杀的远程狙击之王"},
		{"id": "shotgun_s12k", "name": "S12K 霰弹枪", "damage": 12.0, "fire_rate": 0.8, "magazine": 8, "reload_time": 3.0, "spread": 0.08, "recoil": 1.0, "price": 1800, "description": "近距离毁灭性伤害"},
		{"id": "pistol_deagle", "name": "沙漠之鹰", "damage": 40.0, "fire_rate": 0.5, "magazine": 7, "reload_time": 1.8, "spread": 0.02, "recoil": 0.8, "price": 800, "description": "高威力手枪副武器"}
	]

static func get_weapon_by_id(id: String) -> Dictionary:
	for w in get_weapons():
		if w.id == id: return w
	return {}

static func get_maps() -> Array:
	return [
		{"id": "urban", "name": "都市废墟", "description": "废弃城市街道，中距离交火", "unlock_level": 1},
		{"id": "desert", "name": "沙漠基地", "description": "开阔沙漠军事基地，远距离狙击", "unlock_level": 5},
		{"id": "factory", "name": "工业工厂", "description": "室内工厂设施，近距离巷战", "unlock_level": 10}
	]

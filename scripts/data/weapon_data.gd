class_name WeaponData
extends Resource
## 50+ weapons with stats, upgrade scaling

static func get_all_weapons() -> Array:
	return [
		{"id": "rifle_ak47", "name": "AK-47", "type": "assault_rifle", "damage": 25, "fire_rate": 0.1, "magazine": 30, "reload": 2.5, "spread": 0.025, "recoil": 0.6, "price": 0, "unlock_level": 1},
		{"id": "rifle_m4a1", "name": "M4A1", "type": "assault_rifle", "damage": 22, "fire_rate": 0.085, "magazine": 30, "reload": 2.2, "spread": 0.015, "recoil": 0.4, "price": 1500, "unlock_level": 1},
		{"id": "rifle_groza", "name": "Groza", "type": "assault_rifle", "damage": 28, "fire_rate": 0.09, "magazine": 30, "reload": 2.8, "spread": 0.02, "recoil": 0.55, "price": 3500, "unlock_level": 5},
		{"id": "rifle_scar", "name": "SCAR-H", "type": "assault_rifle", "damage": 27, "fire_rate": 0.1, "magazine": 20, "reload": 2.6, "spread": 0.018, "recoil": 0.5, "price": 2800, "unlock_level": 4},
		{"id": "rifle_famas", "name": "FAMAS", "type": "assault_rifle", "damage": 20, "fire_rate": 0.07, "magazine": 25, "reload": 2.3, "spread": 0.02, "recoil": 0.35, "price": 2000, "unlock_level": 3},
		{"id": "rifle_aug", "name": "AUG A3", "type": "assault_rifle", "damage": 21, "fire_rate": 0.08, "magazine": 30, "reload": 2.4, "spread": 0.012, "recoil": 0.38, "price": 2500, "unlock_level": 4},
		{"id": "rifle_hk416", "name": "HK416", "type": "assault_rifle", "damage": 23, "fire_rate": 0.08, "magazine": 30, "reload": 2.1, "spread": 0.014, "recoil": 0.38, "price": 4000, "unlock_level": 6},
		{"id": "rifle_type95", "name": "95式", "type": "assault_rifle", "damage": 24, "fire_rate": 0.09, "magazine": 30, "reload": 2.4, "spread": 0.019, "recoil": 0.45, "price": 2200, "unlock_level": 3},
		{"id": "rifle_an94", "name": "AN-94", "type": "assault_rifle", "damage": 26, "fire_rate": 0.095, "magazine": 30, "reload": 2.5, "spread": 0.016, "recoil": 0.48, "price": 3200, "unlock_level": 5},
		{"id": "rifle_l85", "name": "L86A2", "type": "assault_rifle", "damage": 22, "fire_rate": 0.085, "magazine": 30, "reload": 2.3, "spread": 0.015, "recoil": 0.4, "price": 2600, "unlock_level": 4},
		{"id": "smg_mp5", "name": "MP5", "type": "smg", "damage": 16, "fire_rate": 0.06, "magazine": 35, "reload": 2.0, "spread": 0.03, "recoil": 0.3, "price": 1200, "unlock_level": 1},
		{"id": "smg_ump45", "name": "UMP45", "type": "smg", "damage": 18, "fire_rate": 0.08, "magazine": 25, "reload": 2.1, "spread": 0.025, "recoil": 0.35, "price": 1800, "unlock_level": 2},
		{"id": "smg_vector", "name": "Vector", "type": "smg", "damage": 15, "fire_rate": 0.045, "magazine": 30, "reload": 1.9, "spread": 0.028, "recoil": 0.25, "price": 3000, "unlock_level": 5},
		{"id": "smg_p90", "name": "P90", "type": "smg", "damage": 14, "fire_rate": 0.05, "magazine": 50, "reload": 2.2, "spread": 0.032, "recoil": 0.28, "price": 2800, "unlock_level": 5},
		{"id": "smg_uzi", "name": "Uzi", "type": "smg", "damage": 13, "fire_rate": 0.055, "magazine": 32, "reload": 1.8, "spread": 0.035, "recoil": 0.32, "price": 800, "unlock_level": 1},
		{"id": "smg_bizon", "name": "PP-19", "type": "smg", "damage": 15, "fire_rate": 0.065, "magazine": 64, "reload": 2.4, "spread": 0.03, "recoil": 0.3, "price": 2000, "unlock_level": 3},
		{"id": "smg_thompson", "name": "Thompson", "type": "smg", "damage": 19, "fire_rate": 0.07, "magazine": 30, "reload": 2.3, "spread": 0.028, "recoil": 0.38, "price": 2500, "unlock_level": 4},
		{"id": "smg_mac10", "name": "MAC-10", "type": "smg", "damage": 12, "fire_rate": 0.04, "magazine": 30, "reload": 1.7, "spread": 0.04, "recoil": 0.35, "price": 1500, "unlock_level": 2},
		{"id": "sniper_awm", "name": "AWM", "type": "sniper", "damage": 100, "fire_rate": 1.5, "magazine": 5, "reload": 3.5, "spread": 0.001, "recoil": 1.5, "price": 3000, "unlock_level": 3},
		{"id": "sniper_kar98", "name": "Kar98k", "type": "sniper", "damage": 85, "fire_rate": 1.2, "magazine": 5, "reload": 3.0, "spread": 0.002, "recoil": 1.2, "price": 2500, "unlock_level": 2},
		{"id": "sniper_m24", "name": "M24", "type": "sniper", "damage": 90, "fire_rate": 1.3, "magazine": 5, "reload": 3.2, "spread": 0.002, "recoil": 1.3, "price": 3500, "unlock_level": 5},
		{"id": "sniper_svd", "name": "SVD", "type": "sniper", "damage": 60, "fire_rate": 0.5, "magazine": 10, "reload": 2.8, "spread": 0.01, "recoil": 0.8, "price": 2800, "unlock_level": 4},
		{"id": "sniper_barrett", "name": "Barrett M82", "type": "sniper", "damage": 120, "fire_rate": 2.0, "magazine": 10, "reload": 4.0, "spread": 0.003, "recoil": 2.0, "price": 6000, "unlock_level": 8},
		{"id": "sniper_ssg69", "name": "SSG 69", "type": "sniper", "damage": 75, "fire_rate": 1.4, "magazine": 5, "reload": 3.3, "spread": 0.002, "recoil": 1.1, "price": 2000, "unlock_level": 3},
		{"id": "sniper_mosin", "name": "Mosin", "type": "sniper", "damage": 80, "fire_rate": 1.3, "magazine": 5, "reload": 3.1, "spread": 0.003, "recoil": 1.15, "price": 2200, "unlock_level": 3},
		{"id": "sniper_win94", "name": "Win94", "type": "sniper", "damage": 55, "fire_rate": 0.8, "magazine": 8, "reload": 2.5, "spread": 0.01, "recoil": 0.7, "price": 1800, "unlock_level": 2},
		{"id": "shotgun_s12k", "name": "S12K", "type": "shotgun", "damage": 12, "fire_rate": 0.8, "magazine": 8, "reload": 3.0, "spread": 0.08, "recoil": 1.0, "price": 1800, "unlock_level": 2},
		{"id": "shotgun_s686", "name": "S686双管", "type": "shotgun", "damage": 18, "fire_rate": 0.6, "magazine": 2, "reload": 2.5, "spread": 0.1, "recoil": 1.2, "price": 1500, "unlock_level": 1},
		{"id": "shotgun_dbs", "name": "DBS", "type": "shotgun", "damage": 14, "fire_rate": 0.5, "magazine": 14, "reload": 3.5, "spread": 0.09, "recoil": 1.1, "price": 3500, "unlock_level": 6},
		{"id": "shotgun_m1014", "name": "M1014", "type": "shotgun", "damage": 13, "fire_rate": 0.7, "magazine": 6, "reload": 2.8, "spread": 0.085, "recoil": 1.0, "price": 2200, "unlock_level": 3},
		{"id": "shotgun_origin", "name": "Origin 12", "type": "shotgun", "damage": 15, "fire_rate": 0.55, "magazine": 12, "reload": 3.2, "spread": 0.08, "recoil": 1.1, "price": 4000, "unlock_level": 7},
		{"id": "shotgun_m1897", "name": "M1897", "type": "shotgun", "damage": 16, "fire_rate": 0.9, "magazine": 5, "reload": 3.0, "spread": 0.09, "recoil": 1.15, "price": 2000, "unlock_level": 3},
		{"id": "pistol_deagle", "name": "沙漠之鹰", "type": "pistol", "damage": 40, "fire_rate": 0.5, "magazine": 7, "reload": 1.8, "spread": 0.02, "recoil": 0.8, "price": 800, "unlock_level": 1},
		{"id": "pistol_p92", "name": "P92", "type": "pistol", "damage": 18, "fire_rate": 0.2, "magazine": 15, "reload": 1.5, "spread": 0.025, "recoil": 0.4, "price": 300, "unlock_level": 1},
		{"id": "pistol_usp", "name": "USP", "type": "pistol", "damage": 22, "fire_rate": 0.25, "magazine": 12, "reload": 1.6, "spread": 0.02, "recoil": 0.45, "price": 600, "unlock_level": 1},
		{"id": "pistol_glock", "name": "Glock 17", "type": "pistol", "damage": 19, "fire_rate": 0.18, "magazine": 17, "reload": 1.4, "spread": 0.022, "recoil": 0.38, "price": 500, "unlock_level": 1},
		{"id": "pistol_revolver", "name": "R1895左轮", "type": "pistol", "damage": 35, "fire_rate": 0.6, "magazine": 6, "reload": 2.0, "spread": 0.03, "recoil": 0.9, "price": 700, "unlock_level": 2},
		{"id": "pistol_p30", "name": "P30L", "type": "pistol", "damage": 21, "fire_rate": 0.22, "magazine": 13, "reload": 1.5, "spread": 0.018, "recoil": 0.42, "price": 1000, "unlock_level": 2},
		{"id": "pistol_apc9", "name": "APC9", "type": "pistol", "damage": 20, "fire_rate": 0.15, "magazine": 20, "reload": 1.7, "spread": 0.02, "recoil": 0.4, "price": 1500, "unlock_level": 3},
		{"id": "pistol_flare", "name": "信号枪", "type": "pistol", "damage": 10, "fire_rate": 1.0, "magazine": 1, "reload": 3.0, "spread": 0.05, "recoil": 0.5, "price": 5000, "unlock_level": 10},
		{"id": "lmg_m249", "name": "M249", "type": "lmg", "damage": 20, "fire_rate": 0.075, "magazine": 100, "reload": 5.0, "spread": 0.03, "recoil": 0.5, "price": 4500, "unlock_level": 6},
		{"id": "lmg_mk48", "name": "MK48", "type": "lmg", "damage": 23, "fire_rate": 0.08, "magazine": 100, "reload": 5.2, "spread": 0.028, "recoil": 0.55, "price": 5000, "unlock_level": 7},
		{"id": "lmg_dp28", "name": "DP-28", "type": "lmg", "damage": 24, "fire_rate": 0.09, "magazine": 47, "reload": 4.5, "spread": 0.025, "recoil": 0.5, "price": 3000, "unlock_level": 4},
		{"id": "lmg_mg3", "name": "MG-3", "type": "lmg", "damage": 19, "fire_rate": 0.06, "magazine": 75, "reload": 5.0, "spread": 0.032, "recoil": 0.52, "price": 5500, "unlock_level": 8},
		{"id": "lmg_rpk", "name": "RPK", "type": "lmg", "damage": 22, "fire_rate": 0.085, "magazine": 60, "reload": 4.0, "spread": 0.026, "recoil": 0.48, "price": 3500, "unlock_level": 5},
		{"id": "special_crossbow", "name": "十字弩", "type": "special", "damage": 70, "fire_rate": 2.0, "magazine": 1, "reload": 3.5, "spread": 0.005, "recoil": 0.3, "price": 2500, "unlock_level": 5},
		{"id": "special_grenade", "name": "榴弹发射器", "type": "special", "damage": 80, "fire_rate": 3.0, "magazine": 1, "reload": 4.0, "spread": 0.02, "recoil": 1.0, "price": 6000, "unlock_level": 9},
		{"id": "melee_pan", "name": "平底锅", "type": "melee", "damage": 50, "fire_rate": 0.5, "magazine": 999, "reload": 0, "spread": 0, "recoil": 0, "price": 100, "unlock_level": 1},
		{"id": "melee_machete", "name": "砍刀", "type": "melee", "damage": 45, "fire_rate": 0.4, "magazine": 999, "reload": 0, "spread": 0, "recoil": 0, "price": 300, "unlock_level": 1},
		{"id": "melee_bat", "name": "棒球棍", "type": "melee", "damage": 40, "fire_rate": 0.35, "magazine": 999, "reload": 0, "spread": 0, "recoil": 0, "price": 200, "unlock_level": 1}
	]

static func get_by_id(id: String) -> Dictionary:
	for w in get_all_weapons():
		if w.id == id: return w
	return {}

static func get_upgraded_stats(base: Dictionary, level: int) -> Dictionary:
	var mult: float = 1.0 + (level - 1) * 0.08
	return {
		"damage": int(base.damage * mult),
		"fire_rate": base.fire_rate * (1.0 - (level - 1) * 0.02),
		"spread": base.spread * (1.0 - (level - 1) * 0.05),
		"recoil": base.recoil * (1.0 - (level - 1) * 0.04)
	}

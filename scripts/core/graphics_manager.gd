extends Node
## GraphicsManager - Auto quality scaling: PC Ultra vs Mobile

enum Quality { ULTRA, HIGH, MEDIUM, LOW }

var current_quality: Quality = Quality.HIGH
var is_mobile: bool = false

func _ready() -> void:
	is_mobile = OS.has_feature("mobile") or OS.has_feature("web")
	if is_mobile:
		current_quality = Quality.MEDIUM
		_apply_mobile_quality()
	else:
		current_quality = Quality.ULTRA
		_apply_pc_quality()

func _apply_pc_quality() -> void:
	ProjectSettings.set_setting("rendering/quality/directional_shadow/size", 4096)
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", 3)
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/use_taa", true)
	ProjectSettings.set_setting("rendering/quality/ssao/intensity", 2.0)
	ProjectSettings.set_setting("rendering/quality/reflections/screen_space_reflections", true)

func _apply_mobile_quality() -> void:
	ProjectSettings.set_setting("rendering/quality/directional_shadow/size", 2048)
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", 1)
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/use_taa", false)
	ProjectSettings.set_setting("rendering/quality/ssao/intensity", 1.0)
	ProjectSettings.set_setting("rendering/quality/reflections/screen_space_reflections", false)
	ProjectSettings.set_setting("rendering/quality/internal_resolution/scale", 0.85)

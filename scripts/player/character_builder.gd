extends Node3D
## CharacterBuilder - Procedurally builds a detailed humanoid character

static func build_player_character(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = "Character"
	parent.add_child(root)

	# Torso
	var torso_mesh := BoxMesh.new()
	torso_mesh.size = Vector3(0.42, 0.55, 0.25)
	var torso_mat := StandardMaterial3D.new()
	torso_mat.albedo_color = Color(0.25, 0.28, 0.35)
	torso_mat.roughness = 0.8
	var torso := MeshInstance3D.new()
	torso.mesh = torso_mesh
	torso.material_override = torso_mat
	torso.position = Vector3(0, 1.25, 0)
	root.add_child(torso)

	# Vest
	var vest_mesh := BoxMesh.new()
	vest_mesh.size = Vector3(0.38, 0.35, 0.05)
	var vest_mat := StandardMaterial3D.new()
	vest_mat.albedo_color = Color(0.15, 0.18, 0.22)
	vest_mat.roughness = 0.9
	var vest := MeshInstance3D.new()
	vest.mesh = vest_mesh
	vest.material_override = vest_mat
	vest.position = Vector3(0, 1.25, -0.14)
	root.add_child(vest)

	# Head
	var head_mesh := BoxMesh.new()
	head_mesh.size = Vector3(0.18, 0.22, 0.18)
	var head_mat := StandardMaterial3D.new()
	head_mat.albedo_color = Color(0.75, 0.6, 0.5)
	head_mat.roughness = 0.7
	var head := MeshInstance3D.new()
	head.mesh = head_mesh
	head.material_override = head_mat
	head.position = Vector3(0, 1.7, 0)
	root.add_child(head)

	# Helmet
	var helmet_mesh := BoxMesh.new()
	helmet_mesh.size = Vector3(0.22, 0.12, 0.22)
	var helmet_mat := StandardMaterial3D.new()
	helmet_mat.albedo_color = Color(0.2, 0.25, 0.18)
	helmet_mat.roughness = 0.85
	var helmet := MeshInstance3D.new()
	helmet.mesh = helmet_mesh
	helmet.material_override = helmet_mat
	helmet.position = Vector3(0, 1.82, 0)
	root.add_child(helmet)

	# Left arm
	var arm_l := _build_limb(Vector3(0.12, 0.5, 0.08), Color(0.25, 0.28, 0.35))
	arm_l.position = Vector3(-0.28, 1.35, 0)
	root.add_child(arm_l)

	# Right arm
	var arm_r := _build_limb(Vector3(0.12, 0.5, 0.08), Color(0.25, 0.28, 0.35))
	arm_r.position = Vector3(0.28, 1.35, 0)
	root.add_child(arm_r)

	# Left leg
	var leg_l := _build_limb(Vector3(0.14, 0.7, 0.12), Color(0.2, 0.22, 0.28))
	leg_l.position = Vector3(-0.12, 0.55, 0)
	root.add_child(leg_l)

	# Right leg
	var leg_r := _build_limb(Vector3(0.14, 0.7, 0.12), Color(0.2, 0.22, 0.28))
	leg_r.position = Vector3(0.12, 0.55, 0)
	root.add_child(leg_r)

	# Backpack
	var pack_mesh := BoxMesh.new()
	pack_mesh.size = Vector3(0.3, 0.4, 0.15)
	var pack_mat := StandardMaterial3D.new()
	pack_mat.albedo_color = Color(0.22, 0.2, 0.15)
	pack_mat.roughness = 0.9
	var backpack := MeshInstance3D.new()
	backpack.mesh = pack_mesh
	backpack.material_override = pack_mat
	backpack.position = Vector3(0, 1.3, 0.18)
	root.add_child(backpack)

	return root

static func _build_limb(size: Vector3, color: Color) -> MeshInstance3D:
	var mesh := BoxMesh.new()
	mesh.size = size
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.85
	var limb := MeshInstance3D.new()
	limb.mesh = mesh
	limb.material_override = mat
	return limb

static func build_weapon_viewmodel() -> Node3D:
	var root := Node3D.new()
	root.name = "WeaponViewModel"

	var recv_mesh := BoxMesh.new()
	recv_mesh.size = Vector3(0.04, 0.08, 0.3)
	var recv_mat := StandardMaterial3D.new()
	recv_mat.albedo_color = Color(0.15, 0.15, 0.18)
	recv_mat.roughness = 0.4
	recv_mat.metallic = 0.7
	var recv := MeshInstance3D.new()
	recv.mesh = recv_mesh
	recv.material_override = recv_mat
	recv.position = Vector3(0, 0, -0.15)
	root.add_child(recv)

	var barrel_mesh := BoxMesh.new()
	barrel_mesh.size = Vector3(0.02, 0.02, 0.25)
	var barrel_mat := StandardMaterial3D.new()
	barrel_mat.albedo_color = Color(0.1, 0.1, 0.12)
	barrel_mat.roughness = 0.3
	barrel_mat.metallic = 0.9
	var barrel := MeshInstance3D.new()
	barrel.mesh = barrel_mesh
	barrel.material_override = barrel_mat
	barrel.position = Vector3(0, 0.01, -0.42)
	root.add_child(barrel)

	var mag_mesh := BoxMesh.new()
	mag_mesh.size = Vector3(0.03, 0.12, 0.06)
	var mag_mat := StandardMaterial3D.new()
	mag_mat.albedo_color = Color(0.12, 0.12, 0.15)
	mag_mat.roughness = 0.6
	mag_mat.metallic = 0.3
	var mag := MeshInstance3D.new()
	mag.mesh = mag_mesh
	mag.material_override = mag_mat
	mag.position = Vector3(0, -0.09, -0.1)
	root.add_child(mag)

	var grip_mesh := BoxMesh.new()
	grip_mesh.size = Vector3(0.03, 0.1, 0.05)
	var grip_mat := StandardMaterial3D.new()
	grip_mat.albedo_color = Color(0.25, 0.18, 0.1)
	grip_mat.roughness = 0.9
	var grip := MeshInstance3D.new()
	grip.mesh = grip_mesh
	grip.material_override = grip_mat
	grip.position = Vector3(0, -0.08, -0.02)
	root.add_child(grip)

	var stock_mesh := BoxMesh.new()
	stock_mesh.size = Vector3(0.03, 0.06, 0.15)
	var stock_mat := StandardMaterial3D.new()
	stock_mat.albedo_color = Color(0.2, 0.15, 0.1)
	stock_mat.roughness = 0.85
	var stock := MeshInstance3D.new()
	stock.mesh = stock_mesh
	stock.material_override = stock_mat
	stock.position = Vector3(0, 0.01, 0.08)
	root.add_child(stock)

	var sight_mesh := BoxMesh.new()
	sight_mesh.size = Vector3(0.015, 0.03, 0.08)
	var sight_mat := StandardMaterial3D.new()
	sight_mat.albedo_color = Color(0.05, 0.05, 0.05)
	sight_mat.roughness = 0.3
	var sight := MeshInstance3D.new()
	sight.mesh = sight_mesh
	sight.material_override = sight_mat
	sight.position = Vector3(0, 0.06, -0.15)
	root.add_child(sight)

	return root

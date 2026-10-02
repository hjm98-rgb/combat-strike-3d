shader_type spatial;
// Procedural PBR detail shader

render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 albedo : source_color = vec4(0.4, 0.4, 0.4, 1.0);
uniform float roughness : hint_range(0.0, 1.0) = 0.9;
uniform float metallic : hint_range(0.0, 1.0) = 0.0;
uniform float detail_tiling = 8.0;
uniform float detail_strength = 0.3;
uniform vec3 detail_color : source_color = vec3(0.2, 0.2, 0.2, 1.0);

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	return mix(
		mix(hash(i), hash(i + vec2(1.0, 0.0)), f.x),
		mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), f.x),
		f.y
	);
}

void fragment() {
	vec2 uv = UV * detail_tiling;
	float n = noise(uv);
	float n2 = noise(uv * 3.0);
	float variation = (n * 0.6 + n2 * 0.4 - 0.5) * detail_strength;
	ALBEDO = albedo.rgb * (1.0 + variation);
	ALBEDO = mix(ALBEDO, detail_color, n2 * detail_strength * 0.3);
	ROUGHNESS = clamp(roughness + variation * 0.2, 0.0, 1.0);
	METALLIC = metallic;
	NORMAL_MAP = vec3(0.5 + variation * 0.3, 0.5, 0.5);
}

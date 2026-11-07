// FIGHTERLOOK1 MetaHuman eye with a gaze, a resting lid and blinks. The bodies have no eye or lid joints and no blend shapes
// (mh_boxer_NN.glb: 345 joints, 0 morph targets), so the eye is moved in its texture: the eye cap is mapped front-on (its
// front vertex at UV 0.5,0.5; u grows to the body's left, v grows down), so turning the eye slides the iris across the UV.
// The upper lid is drawn ON the eye surface in her skin colour from the top down: `lid` is how far it rests over the eye,
// `blink` closes it, looking down lowers it (as a real lid follows the eye).
shader_type spatial;

uniform sampler2D albedo_tex : source_color, filter_linear_mipmap_anisotropic, repeat_disable;
uniform vec2 gaze = vec2(0.0);          // radians: x = turn to her left (+), y = up (+)
uniform float gaze_k = 0.30;            // UV per unit sin(angle) (the cap is ~0.027 m across, ~22 UV per metre)
uniform float lid = 0.22;               // 0 = wide stare .. 1 = shut
uniform float blink = 0.0;              // 0 open .. 1 shut
uniform vec3 lid_col : source_color = vec3(0.55, 0.38, 0.28);
uniform float open_top = 0.36;          // the v where the lid edge sits when wide open
uniform float shut_v = 0.70;            // the v the lid edge reaches when shut
uniform bool toon = false;

void fragment() {
	vec2 suv = UV - vec2(sin(gaze.x), -sin(gaze.y)) * gaze_k;
	vec3 eye = texture(albedo_tex, clamp(suv, vec2(0.02), vec2(0.98))).rgb;
	// The upper lid rides with the iris up and down (round 1 critics: a look up rolled the iris under a still lid - all white).
	float close = clamp(lid + blink, 0.0, 1.0);
	float edge = mix(open_top, shut_v, close) - sin(gaze.y) * gaze_k * (1.0 - blink);
	float on_lid = 1.0 - smoothstep(edge - 0.012, edge + 0.012, UV.y);
	// A dark lash line just under the lid's edge, and the lid a little shaded under the brow.
	float lash = smoothstep(edge - 0.01, edge + 0.01, UV.y) * (1.0 - smoothstep(edge + 0.01, edge + 0.045, UV.y));
	vec3 lidc = lid_col * mix(0.72, 0.9, smoothstep(open_top - 0.2, edge, UV.y));
	eye = mix(eye, eye * 0.35, lash * 0.8);
	ALBEDO = mix(eye, lidc, on_lid);
	if (toon) {
		ROUGHNESS = 1.0;
		SPECULAR = 0.0;
	} else {
		ROUGHNESS = mix(0.04, 0.6, on_lid);
		SPECULAR = mix(0.6, 0.32, on_lid);
		CLEARCOAT = 1.0 - on_lid;
		CLEARCOAT_ROUGHNESS = 0.02;
	}
}

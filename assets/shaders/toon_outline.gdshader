// FIGHTERLOOK1 stylized look: the ink line. The back faces pushed out along the normal by a fixed width ON SCREEN (pixels), so
// a far boxer and a close-up carry the same line. Skinned meshes are skinned before this runs (Godot 4), so it follows poses.
shader_type spatial;
render_mode unshaded, cull_front, shadows_disabled;

uniform vec4 line_col : source_color = vec4(0.06, 0.05, 0.05, 1.0);
uniform float width_px = 1.6;

void vertex() {
	vec4 clip = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
	vec3 n = normalize((MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
	vec2 off = (PROJECTION_MATRIX * vec4(n, 0.0)).xy;
	float len = length(off);
	if (len > 1e-5) {
		clip.xy += off / len * width_px * 2.0 / VIEWPORT_SIZE * clip.w;
	}
	POSITION = clip;
}

void fragment() {
	ALBEDO = line_col.rgb;
}

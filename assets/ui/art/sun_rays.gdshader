shader_type canvas_item;
render_mode blend_add;
// S408: slow sunbeams from the top right of a painted gym, for the title screen.
uniform float strength = 0.2;

void fragment() {
	vec2 p = UV - vec2(1.05, -0.12);
	float a = atan(p.y, p.x);
	float rays = 0.5 + 0.28 * sin(a * 38.0 + TIME * 0.35) + 0.22 * sin(a * 71.0 - TIME * 0.22);
	float fall = smoothstep(1.4, 0.1, length(p));
	COLOR = vec4(1.0, 0.95, 0.82, rays * fall * strength);
}

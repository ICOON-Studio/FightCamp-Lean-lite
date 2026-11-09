shader_type canvas_item;
render_mode blend_mul;
// S412 the paper laid over the menus: its grain as a faint warm shade, none of its colour.
void fragment() {
	float g = dot(COLOR.rgb, vec3(0.3, 0.59, 0.11));
	COLOR.rgb = vec3(1.0, 0.985, 0.955) * mix(0.965, 1.0, smoothstep(0.86, 1.0, g));
}

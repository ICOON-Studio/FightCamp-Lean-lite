shader_type spatial;
render_mode unshaded, cull_front, depth_draw_opaque, specular_disabled;
// TRAINCLIPS1 r5: the inverted hull that draws the ink line. A second MeshInstance3D per surface shares the mesh and the
// skeleton and pushes every vertex `width_m` along its own model-space normal; the front faces are culled, so what shows
// is the back of the body, a rim outside the silhouette. The driver keeps width_m at 2.5 px of the finished 256 card
// (metres = 2.5 * cam.size / 256 for the orthographic camera), so the line keeps its weight at any render size.
uniform float width_m = 0.02;
uniform vec3 ink : source_color = vec3(0.0, 0.0, 0.0);
uniform sampler2D alpha_tex : hint_default_white, filter_linear;
uniform float use_alpha = 0.0;
uniform float alpha_cut = 0.42;

void vertex() {
	VERTEX += normalize(NORMAL) * width_m;
}

void fragment() {
	if (use_alpha > 0.5 && texture(alpha_tex, UV).a < alpha_cut) {
		discard;
	}
	ALBEDO = ink;
}
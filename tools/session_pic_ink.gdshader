shader_type spatial;
render_mode unshaded, cull_back, depth_draw_opaque, specular_disabled;
// TRAINCLIPS1 r5: the flat ink fill. Round 4 shaded the body with the PBR pipeline and tried to posterise the result in
// 2D - the tones came out as blobs and no line survived. Here the tone IS the material: the facet's angle to the key
// light picks one of three flat colours, so the picture is already the palette when it is rendered. All three colours
// equal = one flat tone (the trim, the hair). Surfaces whose texture carries alpha (her hair, brow and lash cards) cut
// out with it, so no card renders as a grey slab.
uniform vec3 col_lit : source_color = vec3(0.74, 0.74, 0.76);
uniform vec3 col_mid : source_color = vec3(0.46, 0.46, 0.48);
uniform vec3 col_dark : source_color = vec3(0.30, 0.30, 0.32);
uniform vec3 light_dir = vec3(0.4, 0.5, 0.8);
uniform float band_hi = 0.68;
uniform float band_lo = -0.02;
uniform sampler2D alpha_tex : hint_default_white, filter_linear;
uniform float use_alpha = 0.0;
uniform float alpha_cut = 0.42;

void fragment() {
	if (use_alpha > 0.5 && texture(alpha_tex, UV).a < alpha_cut) {
		discard;
	}
	vec3 n = normalize((INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
	float d = dot(n, normalize(light_dir));
	ALBEDO = d > band_hi ? col_lit : (d > band_lo ? col_mid : col_dark);
}
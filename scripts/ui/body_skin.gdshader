shader_type canvas_item;
// BodyFigure's skin: her own body pixels take each part's colour from the part mask (index * 32), hurt spots redden her.
// S334 (C153 still: hard straight edges between parts read as blocks): the part colour is averaged over a 5x5 patch of
// the mask, so parts meet in a soft blend instead of a cut line.
uniform sampler2D mask : filter_nearest;
uniform vec4 part_col[7];
uniform vec4 body_tint : source_color = vec4(0.7, 0.7, 0.74, 1.0);
uniform vec4 spot_box[3];
uniform vec4 spot_col[3];
uniform float soft_px = 2.0;   // mask texels between the 5x5 taps
void fragment() {
	vec4 c = texture(TEXTURE, UV);
	vec3 rgb = c.rgb * body_tint.rgb;
	float lum = dot(c.rgb, vec3(0.299, 0.587, 0.114));
	vec3 acc = vec3(0.0);
	float wa = 0.0;
	for (int dx = -2; dx <= 2; dx++) {
		for (int dy = -2; dy <= 2; dy++) {
			int j = int(round(texture(mask, UV + vec2(float(dx), float(dy)) * TEXTURE_PIXEL_SIZE * soft_px).r * 255.0 / 32.0));
			if (j > 0 && j < 7) {
				acc += part_col[j].rgb * part_col[j].a;
				wa += part_col[j].a;
			}
		}
	}
	if (wa > 0.0) {
		rgb = mix(rgb, (acc / wa) * clamp(0.62 + 0.85 * lum, 0.6, 1.25), wa / 25.0);
	}
	for (int k = 0; k < 3; k++) {
		vec4 b = spot_box[k];
		if (spot_col[k].a > 0.0 && b.z > 0.0) {
			float w = smoothstep(1.0, 0.35, length((UV - b.xy) / b.zw)) * spot_col[k].a;
			rgb = mix(rgb, spot_col[k].rgb * clamp(0.62 + 0.85 * lum, 0.6, 1.25), w);
		}
	}
	COLOR = vec4(rgb, c.a);
}

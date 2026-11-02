shader_type canvas_item;
// BodyFigure's skin: her own body pixels take each part's colour from the part mask (index * 32), hurt spots redden her.
// S334 (C153 still: hard straight edges between parts read as blocks): the part colour is averaged over a 5x5 patch of
// the mask, so parts meet in a soft blend instead of a cut line.
uniform sampler2D mask : filter_nearest;
uniform vec4 part_col[7];
uniform vec4 body_tint : source_color = vec4(0.86, 0.85, 0.86, 1.0);
uniform vec4 spot_box[3];
uniform vec4 spot_col[3];
uniform float soft_px = 5.0;   // mask texels between the 5x5 taps (S347: 2.0 still left a seam down her chest, C194)
// S347 (operator C194/C195 "still poor"): clay so a red vest never reads BURNING. S348 (C200 "the right holo has nothing to
// do with the actual fighter"): only her KIT goes clay - her skin, hair and face keep their own colours so she is herself.
// Kit = a red-hue pixel (skin leans orange: its green is above its blue) inside her body parts - outside them (head, hands)
// only a near-pure red, so her lips stay hers - or a blue one (skin is never bluer than red).
// 1 = kit all clay, 0 = her photo colours everywhere.
uniform float clay = 1.0;
// S353 the muscle holo (BodyHolo): no kit logic, the picture keeps its own cyan; a part's Burn colour and a hurt spot GLOW
// on the muscles (brighter where the holo is lit), and a hurt spot also fills the see-through inside a little.
uniform float holo = 0.0;
uniform vec4 clay_col : source_color = vec4(0.80, 0.78, 0.74, 1.0);
void fragment() {
	vec4 c = texture(TEXTURE, UV);
	float lum = dot(c.rgb, vec3(0.299, 0.587, 0.114));
	float lo = min(c.g, c.b);
	float hue = (c.g - c.b) / max(c.r - lo, 0.02);
	float sat = (c.r - lo) / max(c.r, 0.02);
	int j0 = int(round(texture(mask, UV).r * 255.0 / 32.0));
	float in_part = (j0 > 0 && j0 < 7) ? 1.0 : 0.0;
	float red_kit = smoothstep(0.30, 0.15, hue) * step(max(c.g, c.b), c.r)
		* mix(smoothstep(0.70, 0.85, sat), smoothstep(0.25, 0.40, sat), in_part);
	float blue_kit = smoothstep(0.06, 0.18, c.b - max(c.r, c.g));
	vec3 rgb = mix(c.rgb * body_tint.rgb, clay_col.rgb * clamp(0.35 + 1.6 * lum, 0.3, 1.15), max(red_kit, blue_kit) * clay);
	rgb = mix(rgb, c.rgb, holo);
	float glow = mix(1.0, 1.35, holo);
	float a = c.a;
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
		vec3 shade = mix(vec3(clamp(0.62 + 0.85 * lum, 0.6, 1.25)), vec3(clamp(0.30 + 1.9 * lum, 0.3, 1.6)), holo);
		rgb = mix(rgb, (acc / wa) * shade, wa / 25.0 * mix(1.0, 0.9, holo));
	}
	for (int k = 0; k < 3; k++) {
		vec4 b = spot_box[k];
		if (spot_col[k].a > 0.0 && b.z > 0.0) {
			float w = smoothstep(1.0, 0.35, length((UV - b.xy) / b.zw)) * spot_col[k].a;
			rgb = mix(rgb, spot_col[k].rgb * clamp(0.62 + 0.85 * lum, 0.6, 1.25) * glow, w);
			a = mix(a, max(a, 0.9), w * holo * step(0.05, c.a));
		}
	}
	COLOR = vec4(rgb, a);
}

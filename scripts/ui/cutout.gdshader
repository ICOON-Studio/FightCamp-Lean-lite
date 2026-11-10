shader_type canvas_item;
// S427 the outline for a cut-out picture (operator C273: "use proper outline effects throught all project not cheap
// solutions"): a line that follows the figures' own edge, and a soft shadow under them, instead of a pasted dark square.
// The texture needs clear room round the figures (>= width_px + shadow_px texture pixels).
uniform vec4 line : source_color = vec4(0.94, 0.90, 0.85, 1.0);
uniform float width_px = 4.0;     // in texture pixels
uniform float shadow_px = 14.0;   // in texture pixels
uniform float shadow = 0.5;
varying vec4 tone;

void vertex() {
	tone = COLOR;
}

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	vec2 px = TEXTURE_PIXEL_SIZE;
	float edge = 0.0;
	float shade = 0.0;
	for (int i = 0; i < 16; i++) {
		float a = float(i) * TAU / 16.0;
		vec2 dir = vec2(cos(a), sin(a));
		edge = max(edge, texture(TEXTURE, UV + dir * px * width_px).a);
		edge = max(edge, texture(TEXTURE, UV + dir * px * width_px * 0.55).a);
		shade += texture(TEXTURE, UV + (dir * shadow_px * 0.7 - vec2(0.0, shadow_px * 0.5)) * px).a;
		shade += texture(TEXTURE, UV + (dir * shadow_px * 0.3 - vec2(0.0, shadow_px * 0.5)) * px).a;
	}
	shade = shade / 32.0 * shadow;
	float la = edge * line.a;
	vec3 under = mix(vec3(0.0), line.rgb, la);
	float under_a = max(la, shade * (1.0 - la));
	vec3 rgb = mix(under, c.rgb, c.a);
	float alpha = c.a + under_a * (1.0 - c.a);
	COLOR = vec4(rgb * tone.rgb, alpha * tone.a);
}

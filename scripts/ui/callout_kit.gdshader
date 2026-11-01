shader_type canvas_item;
// BodyCallouts' close-ups (S348): her still portrait cut round a place. Below her face (UV.y > 0.2 of the portrait) her kit
// goes clay like the body view (body_skin.gdshader, C200): a red-hue or a blue pixel; her face keeps every colour (lips, eyes).
uniform vec4 clay_col : source_color = vec4(0.80, 0.78, 0.74, 1.0);
void fragment() {
	vec4 c = texture(TEXTURE, UV);
	float lum = dot(c.rgb, vec3(0.299, 0.587, 0.114));
	float lo = min(c.g, c.b);
	float hue = (c.g - c.b) / max(c.r - lo, 0.02);
	float sat = (c.r - lo) / max(c.r, 0.02);
	float red_kit = smoothstep(0.30, 0.15, hue) * step(max(c.g, c.b), c.r) * smoothstep(0.25, 0.40, sat);
	float blue_kit = smoothstep(0.06, 0.18, c.b - max(c.r, c.g));
	float kit = max(red_kit, blue_kit) * step(0.2, UV.y);
	// (COLOR here already holds the texture: multiplying by it again painted the kit back, S348 still)
	COLOR = vec4(mix(c.rgb * 0.92, clay_col.rgb * clamp(0.35 + 1.6 * lum, 0.3, 1.15), kit), c.a);
}

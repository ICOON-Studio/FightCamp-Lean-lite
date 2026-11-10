shader_type canvas_item;
render_mode blend_premul_alpha;
// S427 the project's ONE outline (operator C273: "use proper outline effects throught all project not cheap solutions").
// A rounded frame drawn from its distance field: a thin hot core line on the edge, a glow that fades outward (and a
// little inward), and a slow light that travels round it. The glow adds light (alpha 0), the core covers what is under it.
uniform vec2 rect_px = vec2(200.0, 100.0);   // the whole rect this shader paints, margin included
uniform float margin_px = 24.0;              // room for the glow outside the frame
uniform float radius_px = 10.0;
uniform vec4 tint : source_color = vec4(0.95, 0.76, 0.31, 1.0);
uniform float core_px = 2.5;
uniform float glow_px = 20.0;
uniform float power = 1.0;                   // 0 = off, 1 = chosen, ~0.5 = hover
uniform float breathe = 0.18;                // how much the glow swells; 0 in stills
uniform float travel = 0.35;                 // the moving light's strength; 0 in stills
uniform float clock = 0.0;                   // seconds, fed by Halo.gd (0 in stills and tests)

float round_box(vec2 p, vec2 half, float r) {
	vec2 q = abs(p) - half + vec2(r);
	return length(max(q, vec2(0.0))) + min(max(q.x, q.y), 0.0) - r;
}

void fragment() {
	vec2 p = (UV - vec2(0.5)) * rect_px;
	vec2 half = rect_px * 0.5 - vec2(margin_px);
	float d = round_box(p, half, min(radius_px, min(half.x, half.y)));
	float swell = 1.0 + breathe * sin(clock * 2.1);
	// the moving light: one soft arc going round, by angle (corrected for the frame's shape)
	float ang = atan(p.y / max(half.y, 1.0), p.x / max(half.x, 1.0));
	float arc = pow(0.5 + 0.5 * cos(ang - clock * 0.9), 6.0) * travel;
	float core = smoothstep(core_px * 0.5 + 1.0, core_px * 0.5 - 0.5, abs(d));
	float outer = exp(-max(d, 0.0) / (glow_px * 0.45 * swell)) * step(0.0, d);
	float inner = exp(min(d, 0.0) / (glow_px * 0.34)) * step(d, 0.0) * 0.7;
	float glow = (outer + inner) * (0.8 + arc);
	vec3 hot = mix(tint.rgb, vec3(1.0), 0.45 + 0.4 * arc);
	float a = core * tint.a * clamp(power, 0.0, 1.0);
	vec3 light = hot * a + tint.rgb * glow * 0.95 * power * tint.a * (1.0 - core);
	COLOR = vec4(light * COLOR.a, a * COLOR.a);
}

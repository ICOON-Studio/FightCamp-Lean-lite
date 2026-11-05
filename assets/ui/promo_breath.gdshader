shader_type canvas_item;
// S387 PromoShot.live: a still promo shot that breathes. The chest rises and widens with the breath, the head follows a little and
// sways slowly. region = the crop inside the full shot (x, y, w, h); the warp reads real pixels around it, so no edge shows.

uniform vec4 region = vec4(0.0, 0.0, 1.0, 1.0);
uniform float phase = 0.0;
uniform float rise = 0.012;
uniform float sway = 0.005;

void fragment() {
	vec2 p = (UV - region.xy) / region.zw;
	float t = TIME * 1.15 + phase;
	float breath = 0.5 + 0.5 * sin(t);
	float chest = smoothstep(0.52, 1.0, p.y);
	float head = 1.0 - smoothstep(0.1, 0.72, p.y);
	vec2 q = p;
	q.y += breath * rise * (chest + 0.3 * (1.0 - chest));
	q.x += (0.5 - p.x) * chest * breath * rise * 0.8;
	q.x += head * sway * sin(t * 0.37);
	q.y += head * sway * 0.5 * sin(t * 0.23 + 1.0);
	COLOR = texture(TEXTURE, region.xy + q * region.zw) * COLOR;
}

shader_type canvas_item;
// S361 the fight poster's portraits (FightPoster.gd): an old bill poster's halftone - ink dots on paper, each dot as big
// as the photo is dark there. Maria's M32/M34 "B Fight poster" look: cream paper, black ink, halftone portraits.

uniform vec4 ink : source_color = vec4(0.106, 0.098, 0.094, 1.0);
uniform vec4 paper : source_color = vec4(0.953, 0.918, 0.839, 1.0);
uniform float cells = 90.0;      // dots across the picture
uniform float contrast = 1.2;
uniform float lift = 0.55;       // < 1 brightens the midtones: a face in a dark ring stays readable
uniform bool flip = false;       // the blue corner faces the red one

void fragment() {
	vec2 uv = UV;
	if (flip) {
		uv.x = 1.0 - uv.x;
	}
	vec2 tex_size = vec2(textureSize(TEXTURE, 0));
	float aspect = tex_size.y / max(tex_size.x, 1.0);
	vec2 grid = vec2(cells, cells * aspect);
	// a 45-degree screen, as print shops set it
	mat2 rot = mat2(vec2(0.7071, 0.7071), vec2(-0.7071, 0.7071));
	vec2 p = rot * (uv * grid);
	vec2 cell = fract(p) - 0.5;
	vec2 centre_uv = (inverse(rot) * (floor(p) + 0.5)) / grid;
	vec3 c = texture(TEXTURE, clamp(centre_uv, vec2(0.0), vec2(1.0))).rgb;
	float lum = pow(dot(c, vec3(0.299, 0.587, 0.114)), lift);
	float dark = clamp((1.0 - lum - 0.5) * contrast + 0.5, 0.0, 1.0);
	float r = sqrt(dark) * 0.62;
	float d = length(cell);
	float aa = fwidth(d);
	float dot_ink = 1.0 - smoothstep(r - aa, r + aa, d);
	COLOR = vec4(mix(paper.rgb, ink.rgb, dot_ink), 1.0);
}

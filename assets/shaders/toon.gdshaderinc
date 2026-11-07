// FIGHTERLOOK1 stylized look (ArtStyle.gd, `art=toon`): flat colour, light in three hard bands, no specular (no glare), a
// soft rim to lift the figure off the dark hall. Keeps the material's own texture, colour, vertex colour and alpha cut.
uniform sampler2D albedo_tex : source_color, filter_linear_mipmap_anisotropic;
uniform vec4 albedo_col : source_color = vec4(1.0);
uniform bool use_tex = false;
uniform bool use_vcol = false;
uniform float alpha_cut = 0.0;          // > 0: alpha scissor at this threshold (hair cards)
uniform vec3 tint = vec3(1.0);
uniform bool use_band = false;          // the glove's cuff: vertex colour red marks the band (Gloves.gd)
uniform vec4 band_col : source_color = vec4(0.92, 0.92, 0.9, 1.0);
uniform float shade = 0.55;             // the shadow band's share of the lit colour
uniform float mid = 0.8;                // the middle band
uniform float rim_k = 0.06;
uniform float light_k = 0.17;           // the ring rig is five 3.0-3.6 spots: summed at full strength they wash flat colour out
uniform float sat = 1.12;
uniform vec3 flat_col : source_color = vec3(0.5);
uniform float flat_mix = 0.0;           // skin: this share of the photo texture is painted over in one skin tone (no photo face on a cel body)
uniform bool tex_alpha_only = false;   // STYLIZED1: hair cards of a painted body - the atlas gives coverage only, colour is albedo_col
uniform float tex_blur = 0.0;           // mip bias: skin pores and texture noise read as grime in flat colour (skin 2.5)

void fragment() {
	vec4 t = use_tex ? texture(albedo_tex, UV, tex_blur) : vec4(1.0);
	vec3 base = tex_alpha_only ? vec3(1.0) : t.rgb;
	vec3 c = mix(base, flat_col * (0.75 + 0.5 * dot(base, vec3(0.333)) / max(dot(flat_col, vec3(0.333)), 0.05)), flat_mix);
	c *= albedo_col.rgb * tint;
	if (use_vcol) {
		c *= COLOR.rgb;
	}
	if (use_band) {
		c = mix(c, band_col.rgb, smoothstep(0.35, 0.65, COLOR.r));
	}
	float l = dot(c, vec3(0.299, 0.587, 0.114));
	ALBEDO = clamp(mix(vec3(l), c, sat), 0.0, 1.0);
	if (alpha_cut > 0.0) {
		ALPHA = t.a * albedo_col.a;
		ALPHA_SCISSOR_THRESHOLD = alpha_cut;
	}
	ROUGHNESS = 1.0;
	float fres = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), 3.0);
	EMISSION = ALBEDO * fres * rim_k;
}

void light() {
	float ndl = dot(NORMAL, LIGHT) * ATTENUATION;
	float band = mix(shade, mid, smoothstep(0.02, 0.06, ndl));
	band = mix(band, 1.0, smoothstep(0.42, 0.48, ndl));
	DIFFUSE_LIGHT += LIGHT_COLOR * band * step(0.0, ndl + 0.35) * light_k / PI;
}

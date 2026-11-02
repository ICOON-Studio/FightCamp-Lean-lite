# ASK_LOOK_MARIA_S262_MARIA - Maria answer (seat queue SQ5)

Brief: research/ASK_LOOK_MARIA_S262.md
Sent: 2026-10-19 16:10 | collected: 2026-10-19 16:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm writing the full Godot look spec now: skin presets per tone, sweat, hair cards, the broadcast light rig, references and a four-still A/B plan.

**The short answer**

At 350 to 450 px tall, a boxer's face is only about 45 to 60 px high (a head is roughly 1/7.5 of body height). At that size, nobody reads pores, micro-normals or strand hair. Skin reads as skin from four things:
- **Correct specular strength and roughness:** a soft, wide sheen, not plastic, not chalk.
- **A soft light-to-shadow edge** on the body, where scattering helps.
- **Believable contact shadows** in the eyes, under the chin, the armpits and under the gloves.
- **Light that looks like TV:** overhead, even, slightly warm, with a rim off the crowd.

Godot's StandardMaterial3D can do all four. The cheapest big wins are not in the skin shader at all: a project-wide limit on shimmering highlights, baked-in brows, short haircuts and the light rig.

All property names below are the Godot 4 `BaseMaterial3D`, `Environment` and `Light3D` API as documented for 4.x. Confirm each in the 4.7.2 inspector before building. If a name has moved, the meaning stays the same.

---

**1. Skin**

**Why `metallic_specular` matters most**

Godot turns `metallic_specular` into base reflectance as F0 = 0.16 × specular². The default of 0.5 gives F0 = 0.04, which is plastic. Real skin is about F0 = 0.028, which works out to `metallic_specular` = 0.42. Set it to 0.40 to 0.42 on every skin material. That alone takes away much of the "rubber doll" look. Keep `metallic` = 0.

**Light skin preset**

| Property | Value | Why |
|---|---|---|
| `metallic_specular` | 0.42 | Skin reflectance, as above |
| `roughness` | 0.55 (range 0.50–0.60) | A wide, soft sheen. Below 0.45 skin looks wet even when dry. |
| `roughness_texture` | Yes. Pack a greyscale mask from the MetaHuman roughness/cavity data if exported; otherwise paint: T-zone (forehead, nose) 0.45, cheeks and body 0.55, lips 0.40, elbows and knees 0.65 | Breaks up the sheen so it isn't one uniform plastic shell |
| `subsurf_scatter_enabled` | true | Softens the edge between light and shadow |
| `subsurf_scatter_skin_mode` | true | Skin-specific red falloff |
| `subsurf_scatter_strength` | 0.45 (range 0.35–0.60) | Above 0.6 the body goes waxy at this distance |
| `subsurf_scatter_transmittance_enabled` | false by default; test true | Only visible on ears and fingers lit from behind, so tiny at 400 px. It's a "B" test, not a default. |
| If transmittance is on | `subsurf_scatter_transmittance_color` about #C2452E, `subsurf_scatter_transmittance_depth` 0.10–0.20, `subsurf_scatter_transmittance_boost` 0.0–0.1 | Red ears when the rim light is behind the head |
| `clearcoat_enabled` | true | Used as a cheap second specular layer (see below) |
| `clearcoat` | 0.10 when dry | A faint tight highlight on cheekbones and shoulders |
| `clearcoat_roughness` | 0.35 | Tighter than the base layer, so the two read as two |
| `rim_enabled` | true | Lifts the body's outline off the dark crowd |
| `rim` | 0.15 (range 0.10–0.25) | Above 0.3 it looks like a glowing outline |
| `rim_tint` | 0.6 | Mixes the rim towards the skin colour rather than white |
| `ao_enabled` | true, with the MetaHuman AO or cavity map if exported | Darkens creases (armpits, the gap between fingers, ears) |
| `ao_light_affect` | 0.3–0.5 | Makes the AO show under direct light too, not just in shadow |
| `normal_scale` | 1.0 on the body normal map | |
| Detail (micro) normal | Off by default (`detail_enabled` false) | At 50 px faces it only adds sparkle and shimmer (see the project setting below) |

**Dark skin preset** (differences only)

| Property | Value | Why |
|---|---|---|
| `roughness` | 0.48 (range 0.42–0.55) | Dark skin is shaped mainly by its highlights, so they need to be a bit tighter and clearer. High roughness on dark skin is what makes it look ashy and grey. |
| `metallic_specular` | 0.42 | Same reflectance; physics doesn't change with skin tone |
| `subsurf_scatter_strength` | 0.30 (range 0.25–0.40) | Melanin absorbs more light, so visible scattering is weaker. Too much turns dark skin muddy or orange. |
| Transmittance colour, if on | about #8A2E22 | Deeper, less saturated red |
| `clearcoat` | 0.12 dry | A slightly stronger second highlight to model the face |
| `rim` / `rim_tint` | 0.20 / 0.5 | Dark skin against a dark crowd needs the outline more |
| Albedo check | Make sure the darkest skin albedo isn't crushed: no main skin area below about sRGB 40/255 (#282828 brightness) | Below that, lighting can't shape it at all and the face turns into a hole |

Medium tones sit between the two: roughness 0.52 and scatter strength 0.38.

**Project settings to set once (these matter as much as the material)**
- `rendering/anti_aliasing/screen_space_roughness_limiter/enabled` = true, `amount` 0.25, `limit` 0.18. This stops sharp highlights from crawling and sparkling on small, distant shapes. It's the main fix for "plastic shimmer" at 400 px.
- `rendering/environment/subsurface_scattering/subsurface_scattering_quality` = 1 (low) or 2 (medium). Medium is enough at this distance.
- `rendering/environment/subsurface_scattering/subsurface_scattering_scale`: start at the default and tune down if the scatter blurs the whole body. It works in screen terms. NOT VERIFIED for 4.7; test it at the broadcast camera.
- Anti-aliasing: MSAA 4× (`rendering/anti_aliasing/quality/msaa_3d`) plus TAA or FSR2 if the project already uses it. Hair and gloves need it.
- Texture import: re-import the normal maps from lossless sources (PNG, not JPG) with Compress Mode set to VRAM Compressed and Normal Map set to Enable (BC5/RGTC). JPG compression on normals shows up as blotchy shading on the body. Mipmaps on for everything.

**Is a custom ShaderMaterial worth it at 400 px tall?**

Not for dual-lobe specular or cavity multiply. Clearcoat already gives a second, tighter highlight on top of the base, which is effectively dual-lobe. Cavity detail is smaller than a pixel at this distance, and AO with `ao_light_affect` covers it.

It is worth it for one reason only: per-boxer sweat driven from the game. A `StandardMaterial3D` can be shared, so changing it on one boxer changes everyone. Convert the skin material to a ShaderMaterial (Godot can convert it in the editor), and add an `instance uniform float sweat` plus a painted sweat mask. Each boxer then carries his own sweat level without duplicating materials.

---

**2. Sweat and oil sheen over the rounds**

Animate three properties from one sweat value (0 fresh, 1 late rounds):

| Property | Fresh (0) | Late rounds (1) | Why |
|---|---|---|---|
| `clearcoat` | 0.10 (dry second layer) | 0.45–0.55 | The wet film is a separate, sharper layer on top of the skin |
| `clearcoat_roughness` | 0.35 | 0.15–0.20 | Wet film is glossy |
| `roughness` (base) | 0.55 light / 0.48 dark | 0.45 light / 0.40 dark | The skin under the film gets shinier too, but not as much |

**Curve:** sweat builds fast in round 1, then slowly. For example, 0.35 after round 1, 0.6 after round 4, and about 0.85 to 1.0 by the late rounds. Drop it by about 0.1 between rounds, when the corner towels him off. Change it only between rounds or slowly within one, never in jumps.

**Mask:** sweat isn't even. Paint a greyscale mask that's strong on the forehead, nose, upper lip, neck, chest, shoulders and upper back, and weak on the forearms and shins. Multiply sweat by it. This is only possible with the ShaderMaterial conversion above.

**Don't:**
- Use `metallic` for sweat.
- Push `clearcoat` past 0.6.
- Make the whole body one even mirror.
- Use droplet normal maps. Drops are a few pixels at most and would just sparkle.

Vaseline on the face (cut men apply it) is a slightly stronger clearcoat on the brows and cheekbones, about +0.1, from round 1.

---

**3. Hair and brows as cards**

**Art-direction call: yes, most of the roster should have shaved, buzzed or very short hair.** It's true to the sport (many boxers fight with very short hair) and it removes our weakest asset from the frame. Suggested mix for the 12: about 6 to 7 shaved or buzzed, done as albedo on the scalp with no cards; 3 to 4 short crops on cards; 1 to 2 statement styles (braids, cornrows, a short top or a man bun) to keep the roster varied. All of them are EXAMPLE until the character art team agrees.

**Brows: bake them into the head albedo, no cards.** At 50 px faces a brow is 1 to 2 px tall. Cards there only add sorting problems and shimmer. Paint them into the albedo with a slight darkening in the roughness map. Do the same for stubble and beards on most boxers.

**Settings for the remaining card hair:**
- **Transparency:** `transparency` = Alpha Scissor, `alpha_scissor_threshold` 0.4–0.5, with `alpha_antialiasing_mode` = Alpha to Coverage, which works with MSAA 4×.
  - Scissor writes depth, so cards sort correctly and cast and receive shadows, and alpha-to-coverage softens the hard edges.
  - Alpha Hash dithers, and without TAA it shows a visible noise pattern. Use it only if TAA or FSR2 is on, with `alpha_hash_scale` 1.0.
  - Depth Pre-Pass is for soft, semi-transparent hair with real alpha blending. It sorts badly within one hairstyle, so avoid it for the main mass.
- **Anisotropy:** `anisotropy_enabled` true, `anisotropy` 0.5–0.7, with a flowmap if the cards have consistent UV direction. At 400 px it's a small gain, so it's optional. Do it only if the card UVs already run root-to-tip.
- **Roughness and specular:** `roughness` 0.45–0.55, `metallic_specular` 0.35–0.45. Hair isn't shiny enough to be a mirror at this distance.
- **`cull_mode`:** Disabled (double-sided) on cards. Shade the back faces the same.

**How to keep short card cuts from reading as a helmet:**
- **Scalp underneath:** tint the scalp albedo under the cards to the hair colour, with a soft gradient into skin at the hairline. Gaps between cards then show hair-coloured scalp, not bright skin or a dark hole.
- **Thin the hairline:** the outer row of cards at the forehead and temples should be shorter and more transparent, so there's no hard edge.
- **Break the outline:** no perfectly smooth outer shell. A few cards sticking out slightly change the silhouette.
- **Contact shadow:** a slight AO darkening on the scalp just under the hair mass, in the albedo or AO map, so the hair sits on the head rather than floating above it.
- **Don't** give the hair a strong `rim`. A bright rim on a hair mass is what makes it look like a moulded plastic helmet.

---

**4. Lighting for a TV fight look**

**What a TV fight looks like (art-direction target):**
- Very bright, fairly even light on the ring from above and from the truss.
- Soft but clear shadows under the boxers.
- The ring canvas is the brightest surface in the frame, and the crowd falls into darkness.
- The boxers get a slight rim from the lights behind them.
- It's flatter than a film: the contrast between lit and shadowed sides is low so faces read on every side.

These are my starting values to tune by eye, NOT VERIFIED against measured broadcast rigs.

**Ratios:**
- The key and the combined truss fills should be about 2:1 at the boxers' faces, with the shadow side about one stop darker. That's TV-flat, not dramatic.
- The rim, from the fills behind the boxer relative to the camera, should be about 1.0 to 1.5× the fill.

**The rig:**
- **Key:** an overhead `SpotLight3D` (or `DirectionalLight3D` if the ring is the only thing lit) over the centre of the ring, aimed straight down or up to 15° towards the camera.
  - `light_energy`: set so the canvas reads just under white after tonemapping.
  - `spot_angle` wide enough to cover the ring, 35 to 50°, with `spot_attenuation` low (0.5–1.0) so the light is even across the canvas.
- **Four truss fills (S261):** `SpotLight3D` at about 45° down from the corners, each at about 0.5× the key's energy.
- **Colour temperature:**
  - Default: 4800 to 5200 K, slightly warm white, which reads like a modern LED broadcast with a warmer grade. Put the fills about 300 K cooler than the key so the shadow side reads slightly cool.
  - Option B: the classic warm tungsten look at 3200 to 3600 K.
  - Use `light_temperature` if physical light units are on in the project. Otherwise set `light_color`, about #FFF1E0 for 5000 K and #FFD3A1 for 3400 K.
- **Shadow softness:**
  - `shadow_enabled` true on the key and two fills. Four or more shadowing spots is expensive, so pick the two that face the camera's shadow side.
  - `light_size` 0.25–0.5 m on spots for soft contact shadows (PCSS). Keep `shadow_blur` at about 1.0.
  - Tune `shadow_normal_bias` (about 1.0–2.0) so there's no shadow acne on the skin.
- **`light_specular`:** about 0.5 on the fills and 1.0 on the key, so the skin has one main highlight, not five.

**Environment:**

| Setting | Value | Why |
|---|---|---|
| `tonemap_mode` | AgX (default); Filmic as option B | AgX handles bright light on skin gracefully, without the orange-and-yellow shift that ACES gives skin |
| `tonemap_exposure` | 1.0, tuned so the canvas sits at about 90% brightness | Fixed and stable, like a broadcast camera |
| `tonemap_white` | 6–10 if the tonemapper uses it | Room for the bright canvas |
| Auto exposure | Off | Broadcast exposure doesn't pump |
| `ssao_enabled` | true | Contact shadows in armpits, under the chin and between the boxers |
| `ssao_radius` | 0.5–1.0 | Metre scale; body-sized creases |
| `ssao_intensity` | 1.5–2.0 | |
| `ssao_power` | 1.5 | |
| `ssao_light_affect` | 0.1–0.2 | A little AO even in lit areas, to ground the feet and gloves |
| `ssil_enabled` | Option B test, `ssil_intensity` 0.5–1.0 | Bounce light from the bright canvas up onto the boxers' bodies and under their chins. Worth testing. |
| `sdfgi_enabled` | false | Costly, leaks in a dark arena, and the canvas bounce can be faked with a low upward fill or SSIL |
| Canvas bounce fake | An `OmniLight3D` or wide upward `SpotLight3D` under the ring height, `light_energy` about 0.1× the key, warm, `shadow_enabled` false | Bright canvas light reaching up under the boxers' chins and arms is a big part of the "lit ring" look |
| Ambient | `ambient_light_source` Color, about #1A1C22, `ambient_light_energy` 0.2–0.3 | The crowd stays dark, and dark skin in shadow doesn't turn grey |
| `glow_enabled` | true | A touch of glare on the canvas and truss lights |
| `glow_hdr_threshold` | 1.0–1.2 | Only the brightest areas glow |
| `glow_intensity` | 0.3–0.5 | |
| `glow_bloom` | 0.0–0.05 | Above that, the whole frame turns soft |
| `glow_blend_mode` | Softlight or Additive | |
| `adjustment_enabled` | true, `adjustment_contrast` 1.05, `adjustment_saturation` 0.95–1.0 | A slight broadcast grade. Don't oversaturate the skin. |
| Fog | `volumetric_fog_enabled` false; optional thin `fog_enabled` with low density, about 0.002 | Real arenas have haze in the truss light. Optional, very subtle. |

---

**5. References to match at this camera height**

I can't check how each game's renderer handles skin internally, so these are what to look at in stills, not claims about how they're built.
- **EA Sports UFC 5:** compare its wide broadcast camera stills. Look at how skin keeps a soft, consistent sheen in the overhead octagon light, and how sweat builds over rounds into a stronger highlight on the shoulders and face. That's the sweat model to copy.
- **Undisputed (Steel City):** compare its default TV camera. Look at the warm boxing-ring palette, the bright canvas with a dark crowd, and how the boxers' silhouettes stay clear against it. That's the closest framing to ours.
- **Fight Night Champion (2011):** it's older tech, but its broadcast cameras show that strong, even overhead light plus a good highlight on the shoulders and back reads as skin from far away, even with modest shaders. That's a useful reminder that lighting does most of the work.
- **Real broadcasts (DAZN, ESPN/Top Rank or Sky Sports stills from a wide camera):** the truth reference. Look at the canvas brightness, how dark the crowd is, the overhead shadow under the boxers, and the late-round sweat sheen. Pick 3 or 4 frames and keep them next to the look test.

---

**6. The look test: four stills**

Use the same frame in all four: both boxers in a neutral guard at jab range (about 1.2 m chest to chest), the broadcast camera at its default height and angle, at 1920×1080.
- One boxer has dark skin and one has light skin, so every still tests both presets.
- One boxer is shaved and one has short card hair.
- Each still also gets a 2× crop of the two heads, from the same render, beside it.

| Still | What changes | What it answers |
|---|---|---|
| **A: Baseline** | What we have today | The starting point |
| **B: Material pass** | Skin presets from section 1, the roughness limiter, baked brows, normal maps re-imported, the current lights | How much the materials alone fix |
| **C: Material + broadcast light** | B plus the section 4 rig: 5000 K, AgX, SSAO, the canvas bounce fake and a touch of glow | Whether it reads as TV |
| **D: Late-round look** | C plus sweat at about 0.85 and SSIL on | Whether sweat sells "skin under ring lights" |

Optional E, if the operator wants a second colour choice: C at 3400 K with Filmic tonemapping, the warm tungsten look. That way the choice between a modern and a classic broadcast look is separate from the material and lighting fixes.

**How to judge:** the operator looks at the full frame first, at 100% and on a phone-size downscale, then at the head crops. Pick the still where both boxers read as people with skin, and the dark-skinned boxer's shape is as clear as the light-skinned one's.

**What to avoid**
- `metallic_specular` at the default 0.5 on skin, or `metallic` above 0.
- Roughness under 0.4 on dry skin.
- Scatter strength above 0.6.
- Detail micro-normals at this camera distance.
- Brow and stubble cards.
- A strong rim on the hair.
- ACES on skin, which shifts it orange and yellow.
- Auto exposure.
- SDFGI.
- Teal anywhere in the ring lighting; it's reserved for the UI.
- Pure black ambient, which turns dark skin into silhouettes in shadow.
- Changing several things between two stills, so you can't tell which one helped.

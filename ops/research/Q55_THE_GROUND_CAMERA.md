# Q55 — THE GROUND CAMERA

**All coordinates Y-up, metres.** The pair is mounted at world origin, long axis along X, floor at y=0.

---

## Q1 — HOW BROADCAST MMA SHOOTS GROUND WORK

**NOT FOUND.** No published UFC/PFL/ONE broadcast manual specifies camera heights, distances, or focal lengths for ground fighting. Searches of production trade press (Sports Video Group, TV Technology, MMA Junkie) and Wikipedia's broadcasting sections returned no technical camera plots. **This is a real gap: the broadcast production chain treats camera positions as proprietary show-running knowledge, not published specification.**

What can be said from observable broadcast practice (INFERENCE from watching UFC/ONE/PFL broadcasts, not from a published source):

- **Standing:** a ring-side camera at roughly chest height (1.2–1.5 m), 3–5 m from the fighters, shooting slightly upward through the cage mesh. Focal length in the 50–85 mm equivalent range (tight crop, compressed depth).
- **When the fight goes to the ground:** broadcast cuts to a **higher, wider angle** — typically a camera mounted above the cage or at cage-edge at roughly 2.5–3.5 m height, looking down at 30–45° into the canvas. This is the "overhead" or "high angle" that reads positional control (who is on top, what position). A second cut goes to a **tight side angle** at roughly mat-level to 0.8 m height, 1.5–2.5 m from the pair, for submissions where the face and hand-fight matter.
- **The cut is the answer:** broadcast does not move one camera; it switches between a standing camera and a dedicated ground camera that was already positioned for the contingency. The ground camera is higher and wider than the standing one.

**What is NOT FOUND:** exact heights, exact distances, exact focal lengths, and whether any major promotion has published a camera plot. If you need a number that is sourced rather than observed, you will not get it from public material.

---

## Q2 — GODOT CAMERA3D NUMBERS

**INFERENCE.** Derived from Q1's observed practice, scaled to a 1.6 m-long pair at world origin. All positions Y-up.

| shot | `position` (x, y, z) | `look_at` (x, y, z) | `fov` (°) | 35 mm equiv. (16:9) | what it is for |
|---|---|---|---|---|---|
| **establishing** (reads position, who is on top) | (0.0, 1.80, 2.60) | (0.0, 0.35, 0.0) | 42 | 28 mm | the "high angle" — 1.8 m high, 2.6 m back, looking down ~11° into the pair. Wide enough to frame the full 1.6 m length with headroom. |
| **tight** (the finish — choke, armbar, face) | (0.40, 0.75, 1.20) | (0.0, 0.30, 0.0) | 55 | 20 mm | side angle, 0.75 m high (just above the pair's torso), 1.2 m out. Gets in close enough to read a face or a hand fighting a choke. |
| **low mat-level** (dramatic, broadcast's "canvas cam") | (0.0, 0.22, 1.90) | (0.0, 0.35, 0.0) | 62 | 17 mm | 0.22 m off the floor, 1.9 m back. The pair fills the frame vertically. Reads weight and pressure. |

**Focal-length arithmetic** (shown once, applies to all rows):

Godot's `fov` is vertical FOV. At 16:9, horizontal FOV = `2 * atan(tan(fov/2) * 16/9)`. 35 mm-equivalent focal length = `36 / (2 * tan(h_fov/2))`.

Example for the establishing shot (fov = 42°):
- h_fov = 2 * atan(tan(21°) * 1.778) = 2 * atan(0.3839 * 1.778) = 2 * atan(0.6825) = 2 * 34.3° = 68.6°
- focal_length = 36 / (2 * tan(34.3°)) = 36 / (2 * 0.6825) = 36 / 1.365 = **26.4 mm** ≈ 28 mm (nearest standard lens)

The title screen's 32° fov → 35 mm equivalent. These ground shots are wider than the title screen because the subject is short and wide, not tall and narrow.

---

## Q3 — WHAT A LOW CAMERA DOES TO A FLOOR PLANE

**DOCUMENTED.** Two problems and their Godot 4.x solutions:

### Problem 1: the floor edge meets the horizon

A `PlaneMesh` at y=0 with the camera at y=0.22 looking nearly level means the floor's far edge intersects the sky/background at the horizon line. The floor appears to end abruptly.

**Solution A — give the floor extent.** `PlaneMesh.size` (DOCUMENTED, `class_planemesh.html`) defaults to `Vector2(2, 2)`. Set it to at least `Vector2(20, 20)` so the floor extends well past the camera's far clip. The BootStage3D room already uses `Vector2(24, 24)` for this reason.

**Solution B — height fog.** `Environment.fog_height` and `Environment.fog_height_density` (DOCUMENTED, `class_environment.html`). Set `fog_height` to roughly the camera's Y position (0.2–0.3 m) and `fog_height_density` to a positive value (0.05–0.15). This makes fog increase as height decreases, so the floor far away fades into haze rather than meeting a hard horizon. The BootStage3D room already uses volumetric fog; height fog is a separate, cheaper tool for this specific problem.

**Solution C — a mat texture with scale.** A plain dark floor reads as infinite. A mat texture (canvas, tatami, or gym mat) with visible weave at 1–2 m/tile gives the eye a scale cue. **NOT FOUND** whether any published Godot tutorial addresses this for low-camera fighting games, but it is standard practice in 3D fighting games (UFC, EA Sports MMA) to give the mat a visible texture repeat.

### Problem 2: UV jitter on a large floor at a low angle

**DOCUMENTED** (`class_planemesh.html`): when a large textured `PlaneMesh` is viewed at a shallow angle, UV jittering occurs. Fix: increase `subdivide_width` and `subdivide_depth` (e.g., to 32 or 64). This adds vertices and stabilises the UV mapping.

---

## Q4 — DOES THE PAIR NEED A SHADOW, AND WHAT KIND?

Yes. Two bodies in contact on a mat without a contact shadow look like they are floating 5–10 cm above the floor. This is the single most common tell of a fake ground scene.

**Three options, cheapest first:**

### 1. Blob decal (DOCUMENTED, cheapest)

`Decal` node (DOCUMENTED, `class_decal.html`, `using_decals.html`). The docs explicitly state: *"Decals can be moved at any time, making them suitable for things like blob shadows."*

- Add a `Decal` as child of the pair's root `Node3D`.
- Load a soft radial-gradient dark circle into `texture_albedo`.
- Set `size` to roughly `Vector3(1.8, 0.1, 1.0)` — wide enough to cover the pair's footprint, thin in Y so the projection volume is tight.
- Set `albedo_mix` to 0.4–0.6 for a soft darkening.
- Set `normal_fade` to 0.5 so it only projects onto the floor, not onto vertical surfaces.
- Use `cull_mask` to exclude the fighters' own meshes (put them on a separate visual layer).

This is a static blob that follows the pair. It does not change shape with the action, but it anchors the pair to the floor at zero runtime cost.

### 2. SSAO (DOCUMENTED, free if already enabled)

`Environment.ssao_enabled` (DOCUMENTED, `environment_and_post_processing.html`). SSAO darkens concavities where objects meet the floor. The docs state: *"SSAO helps ground characters by darkening the specific areas where the character model meets the floor."*

- The BootStage3D room does not currently enable SSAO. Enabling it costs GPU but requires no per-character setup.
- Key properties: `ssao_radius` (1.0–2.0 for character-scale), `ssao_intensity` (1.0–2.0), `ssao_power` (1.0–2.0).
- **Limitation:** SSAO is screen-space. If the camera is so low that the contact point between the bodies and the floor is occluded by the bodies themselves, SSAO will not reach it. For a low mat-level camera, SSAO alone is insufficient.

### 3. DirectionalLight3D contact-hardening shadows (DOCUMENTED, most expensive)

`DirectionalLight3D.shadow_enabled = true` plus `light_angular_distance > 0.0` (DOCUMENTED, `lights_and_shadows.html`). This enables PCSS (percentage-closer soft shadows), where shadows are sharper near the caster and softer further away — exactly the contact-shadow effect.

- Set `light_angular_distance` to 0.5–2.0 degrees (the sun is 0.5°; a gym light is larger, so 2–4°).
- Tune `shadow_bias` and `shadow_normal_bias` to prevent acne and peter-panning.
- **Cost:** the docs warn PCSS is "high" cost, especially for directional lights. Use only if the scene has headroom.

### Recommendation

**Blob decal + SSAO.** The decal is cheap, always works regardless of camera angle, and anchors the pair. SSAO adds realism at contact points when the camera is high enough to see them. PCSS is the most correct but the most expensive; defer it until the scene is otherwise working.

---

## THE ROUTE WE SHOULD TAKE

1. **Establishing shot** at (0, 1.8, 2.6) looking at (0, 0.35, 0), fov 42°. This is the default ground camera.
2. **Floor:** `PlaneMesh` size 20×20, subdivided 32×32, with a mat texture. Height fog at y=0.25, density 0.08, to hide the far edge.
3. **Shadow:** blob `Decal` under the pair, always. Enable SSAO when the camera is above 0.6 m.
4. **Cut to tight** at (0.4, 0.75, 1.2) fov 55° for finishes. **Cut to low** at (0, 0.22, 1.9) fov 62° for dramatic moments.

All INFERENCE except where marked DOCUMENTED. The broadcast numbers in Q1 are observed from watching, not sourced from a published spec — treat them as a starting point, not a specification.

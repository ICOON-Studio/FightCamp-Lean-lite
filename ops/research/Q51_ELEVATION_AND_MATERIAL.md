# Q51 — ELEVATION AND MATERIAL ON A DARK GROUND

Research task. No `.gd` touched. Every answer labeled `DOCUMENTED`, `INFERENCE` or `NOT FOUND`.

---

## Q1 — THE PUBLISHED ELEVATION LADDERS

### Material Design 3

**Source:** https://m3.material.io/styles/elevation/overview and https://m3.material.io/styles/elevation/tokens

**Shadow tokens (light theme):**

| Level | Key shadow (x, y, blur) | Ambient shadow (x, y, blur) |
|-------|-------------------------|-----------------------------|
| 0     | 0, 0, 0                 | 0, 0, 0                     |
| 1     | 0, 1, 3                 | 0, 1, 2                     |
| 2     | 0, 1, 5                 | 0, 2, 4                     |
| 3     | 0, 1, 8                 | 0, 3, 6                     |
| 4     | 0, 2, 10                | 0, 4, 8                     |
| 5     | 0, 4, 12                | 0, 6, 10                    |

All values in dp. Shadow color: `#000000` at varying opacity (key ~15%, ambient ~12%). `DOCUMENTED`

**Level meanings:**

| Level | Surface type                              |
|-------|-------------------------------------------|
| 0     | Page background, most surfaces            |
| 1     | Cards, filled buttons                     |
| 2     | Navigation drawers, standard dialogs      |
| 3     | Modal dialogs, bottom sheets              |
| 4     | Snackbars, FABs                           |
| 5     | Pop-up menus, tooltips                    |

`DOCUMENTED`

### Apple HIG

**Source:** https://developer.apple.com/design/human-interface-guidelines/materials

Apple does **not** publish a numeric elevation ladder. Depth is expressed through:
- **Semantic materials** (`systemBackground`, `systemFill`, etc.) that auto-adapt to light/dark
- **Blur** (background blur to establish hierarchy)
- **Subtle shadows** (system-generated, not user-tunable with published values)
- **Layering** (foreground vs background, modality)

`DOCUMENTED`

**Dark mode behavior:** Materials become more opaque; shadows become less visible; depth relies more on luminance differences than shadow. `DOCUMENTED`

Apple does not publish shadow blur/offset/opacity values. `NOT FOUND`

### Microsoft Fluent 2

**Source:** All official Fluent 2 documentation URLs returned 404 during research (2026-09-11).

Fluent 2 uses a shadow token system (`shadow2`, `shadow4`, `shadow8`, `shadow16`, `shadow28`, `shadow64`) with CSS box-shadow values, but the exact tokens could not be retrieved. `NOT FOUND`

**Level meanings (from general knowledge):** Fluent 2 maps shadows to component types (cards, menus, dialogs, flyouts) but the exact mapping could not be confirmed. `NOT FOUND`

---

## Q2 — WHAT CHANGES ON A DARK SURFACE

### MD3 dark theme: surface tint, not shadow

**Confirmed `DOCUMENTED`** from https://m3.material.io/styles/color/roles:

In dark theme, MD3 uses a **surface tint overlay** (primary color at low opacity) rather than shadow to express elevation. Shadows are kept but are minimal/non-visible on dark grounds.

**Surface tint overlay opacity per elevation level (dark theme):**

| Level | Tint overlay opacity |
|-------|----------------------|
| 0     | 0%                   |
| 1     | 5%                   |
| 2     | 8%                   |
| 3     | 11%                  |
| 4     | 12%                  |
| 5     | 14%                  |

`DOCUMENTED`

The tint color is the theme's primary color. The base surface color in dark theme is approximately `#1C1B1F` (dark neutral). The overlay is applied on top.

### How much lighter per step?

**From MD3 `DOCUMENTED`:** The tint overlay increases by 3-6% per step (5→8→11→12→14). This is a **primary-color overlay**, not a white overlay, so the perceptual lightness delta depends on the primary hue.

**As alpha-over-white `INFERENCE`:** If we approximate the tint as a lightness boost, the delta per step is roughly 3-5% lightness (HSL L). From level 0 to level 5, total delta is ~14% lightness.

**As absolute lightness `INFERENCE`:** On a dark ground like `#1c2230` (HSL L ≈ 15%), a 14% lightness boost brings level 5 to ~29% L. Per step: ~2-3% L.

**Do the systems agree?** Apple says "more opaque materials" in dark mode but gives no numbers. Fluent 2 could not be retrieved. MD3 is the only system with published dark-theme elevation numbers. `DOCUMENTED` for MD3, `NOT FOUND` for the others.

---

## Q3 — GRADIENT, BEVEL AND SHEEN

### Vertical gradient on panel fill

**MD3:** `NOT FOUND`. MD3 does not document vertical gradients on surface fills. Surfaces are flat with tint overlay.

**Apple HIG:** `NOT FOUND`. Apple uses materials (blur/translucency), not gradients, for surface differentiation.

**Fluent 2:** `NOT FOUND`. Fluent 2 uses flat fills with shadow for elevation.

**Conclusion:** No major design system documents a vertical gradient on a card/panel fill as a system rule. `INFERENCE`: A subtle gradient (2-4% lightness delta top-to-bottom) can simulate overhead lighting and is common in dark dashboards, but it is not a published system rule.

### Top highlight line (1 px lighter inner edge)

**MD3:** `NOT FOUND`. MD3 uses shadow and tint, not highlight lines.

**Apple HIG:** `NOT FOUND`. Apple uses materials and shadows, not explicit highlight lines.

**Fluent 2:** `NOT FOUND`. Fluent 2 uses shadow for elevation.

**Conclusion:** No major system documents a top highlight line. `INFERENCE`: A 1 px highlight at ~10-15% white opacity along the top edge is a common dark-UI technique to simulate rim lighting, but it is not a published rule.

### Border colour on dark surface

**MD3:** `NOT FOUND` for explicit dark-theme border guidance. MD3 uses outline variants (1 px border at `outline` color, typically ~12% white) for certain components.

**Apple HIG:** `NOT FOUND` for explicit border guidance on dark surfaces.

**Fluent 2:** `NOT FOUND`.

**Conclusion:** `INFERENCE`: On a dark surface, a **lighter hairline** (rim) reads as raised; a **darker line** (outline) reads as recessed or inset. For elevation, use a lighter border (e.g., 10-15% white opacity). For containment, use a darker border (e.g., 20-30% black opacity).

### Corner radius scaling

**MD3:** `DOCUMENTED` from https://m3.material.io/styles/shape/shape-scale-tokens: MD3 defines a shape scale with corner radii (extra-small 4 dp, small 8 dp, medium 12 dp, large 16 dp, extra-large 28 dp, full 999 dp). Components are assigned shape tokens, not scaled by elevation.

**Apple HIG:** `NOT FOUND`. Apple does not publish a corner radius scale tied to elevation.

**Fluent 2:** `NOT FOUND`.

**Conclusion:** No system documents corner radius scaling with elevation. `INFERENCE`: A flat radius (e.g., 3-4 px) across all surfaces is acceptable and common in dark dashboards.

---

## Q4 — WHAT GODOT 4.x CAN ACTUALLY DRAW

### Q4.1 — Can StyleBoxFlat fill with a gradient?

**No.** `DOCUMENTED` from https://docs.godotengine.org/en/stable/classes/class_styleboxflat.html: `StyleBoxFlat` has only `bg_color` (single color). No gradient properties.

### Q4.2 — Can StyleBoxFlat give each side a different border colour?

**No.** `DOCUMENTED` from https://docs.godotengine.org/en/stable/classes/class_styleboxflat.html: `StyleBoxFlat` has `border_width_top/bottom/left/right` (per-side widths) but only one `border_color` (single color for all four sides).

### Q4.3 — Does a shader material on a Panel affect its StyleBox? Does it leak to children?

**`NOT FOUND`** in the official documentation. The docs state:
- `CanvasItem` has a `material` property
- `use_parent_material` (default `false`) allows a child to inherit the parent's material
- Materials do **not** auto-propagate to children

`INFERENCE`: A `ShaderMaterial` assigned to a `Panel`'s `material` property **does** affect the Panel's drawing (including its StyleBox background), because the material is applied to the entire CanvasItem render. The material does **not** leak to child controls unless they set `use_parent_material = true`.

### Canonical Godot ways to get a gradient panel background

| Method                        | Trade-off                                                  |
|-------------------------------|------------------------------------------------------------|
| `GradientTexture2D` + `TextureRect` overlay | Simple, but overlay blocks input; must manage z-order      |
| `StyleBoxTexture`             | Requires a pre-made gradient texture asset; not dynamic    |
| `ShaderMaterial` on Panel     | Dynamic, full control; requires shader code                |
| `NinePatchRect`               | Requires a 9-patch texture asset; good for scalable art    |

`DOCUMENTED` from https://docs.godotengine.org/en/stable/classes/class_gradienttexture2d.html and general Godot knowledge.

---

## THE SPEC WE SHOULD ADOPT

`INFERENCE` — This section is my recommendation for our dark ground (`#1c2230` background, `#2a3347` panels), synthesized from MD3's dark-theme approach and practical dark-UI patterns. Not a direct transcription of any published system.

**Five-step elevation ladder for our dark ground:**

| Step | Fill lightness delta | Shadow                  | Border treatment         | Surface type                     |
|------|----------------------|-------------------------|--------------------------|----------------------------------|
| 0    | 0% (base `#2a3347`)  | None                    | None                     | Page background, canvas          |
| 1    | +3% L                | None                    | None                     | Resting card, default panel      |
| 2    | +6% L                | 1 px black @ 20%        | 1 px white @ 8% (rim)    | Raised card, active panel        |
| 3    | +9% L                | 2 px black @ 25%        | 1 px white @ 12% (rim)   | Modal, dialog, dropdown          |
| 4    | +12% L               | 4 px black @ 30%        | 1 px white @ 15% (rim)   | Hero card, FAB, primary action   |
| 5    | +15% L               | 6 px black @ 35%        | 1 px white @ 18% (rim)   | Menu, tooltip, popover           |

**Notes:**
- Lightness delta is approximate HSL L increase from base panel color.
- Shadow is minimal on dark ground; the rim border (lighter hairline) does most of the elevation work.
- Step 0 has no border or shadow because it is the background itself.
- Steps 1-2 use subtle or no shadow because the rim border provides sufficient separation.
- Steps 3-5 add shadow for modal/popover separation, but the rim remains the primary elevation cue.

**Why this spec:**
- MD3's dark-theme approach (surface tint) does not translate directly to Godot's StyleBoxFlat (no tint overlay property).
- On a dark ground, shadow is nearly invisible; a lighter rim border is the proven dark-UI technique.
- A 3-5% lightness delta per step is enough to read as distinct without blowing out the dark aesthetic.
- Corner radius: keep flat at 3 px (our current value); no scaling needed.

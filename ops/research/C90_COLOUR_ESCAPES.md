# C90 — Colour escapes census

## 1. Method

Counted against commit `a60285a1db69d212b62f3972937a4cdea5ab66a4` after rebasing `master` onto `origin/master` once at the start.

The raw pattern was `\bColor\b`. The filtered literal-start pattern was `Color\((?:"|[0-9])|Color\.[A-Z][A-Z0-9_]*`; the hex recogniser was `Color\("#[0-9A-Fa-f]{6}(?:[0-9A-Fa-f]{2})?"\)`. (`\x22` was used for `"` in the Windows command argument.) A component-form match begins only at `Color(` immediately followed by a digit, and its balanced closing parenthesis was retained verbatim. Named constants match `Color.NAME`. Type annotations, return types, token references, and constructors beginning with an identifier were therefore excluded.

- `Godot/scripts/*.gd`, excluding `UITokens.gd`: raw `Color` matches = **631**; filtered literals = **191** across **23 files** (**17 hex, 134 float, 40 named**).
- `Godot/scripts/UITokens.gd`, counted separately: raw `Color` matches = **72**; filtered literals = **59** (**57 hex, 2 float, 0 named**).

## 2. Per-file table

| script | hex | float | named | TOTAL |
|---|---:|---:|---:|---:|
| Godot/scripts/UIKit.gd | 12 | 52 | 30 | 94 |
| Godot/scripts/TechniqueGlyph.gd | 0 | 21 | 0 | 21 |
| Godot/scripts/TaleOfTheTape.gd | 0 | 13 | 2 | 15 |
| Godot/scripts/BootStage3D.gd | 0 | 11 | 0 | 11 |
| Godot/scripts/RingStagePanel.gd | 0 | 7 | 3 | 10 |
| Godot/scripts/ComboDecisionTimer.gd | 0 | 6 | 0 | 6 |
| Godot/scripts/ProfileRevampPanel.gd | 0 | 3 | 1 | 4 |
| Godot/scripts/SkillsMovesPanel.gd | 0 | 3 | 1 | 4 |
| Godot/scripts/BootRoot.gd | 0 | 3 | 0 | 3 |
| Godot/scripts/FeedbackOverlay.gd | 3 | 0 | 0 | 3 |
| Godot/scripts/IconKit.gd | 2 | 1 | 0 | 3 |
| Godot/scripts/SetpieceRoot.gd | 0 | 3 | 0 | 3 |
| Godot/scripts/ComboStrip.gd | 0 | 2 | 0 | 2 |
| Godot/scripts/ManagementChrome.gd | 0 | 2 | 0 | 2 |
| Godot/scripts/RankingsHubPanel.gd | 0 | 2 | 0 | 2 |
| Godot/scripts/CreationRoot.gd | 0 | 1 | 0 | 1 |
| Godot/scripts/FightContractScreen.gd | 0 | 0 | 1 | 1 |
| Godot/scripts/FightResultPanel.gd | 0 | 0 | 1 | 1 |
| Godot/scripts/FightWeekPanel.gd | 0 | 1 | 0 | 1 |
| Godot/scripts/MatRig.gd | 0 | 1 | 0 | 1 |
| Godot/scripts/ScorecardPanel.gd | 0 | 0 | 1 | 1 |
| Godot/scripts/SetpieceChrome.gd | 0 | 1 | 0 | 1 |
| Godot/scripts/ShellChrome.gd | 0 | 1 | 0 | 1 |

## 3. Every call site

| script:line | form | the literal as written | the enclosing line, trimmed |
|---|---|---|---|
| Godot/scripts/BootRoot.gd:180 | float | `Color(0.043, 0.055, 0.078)` | `var ground := Color(0.043, 0.055, 0.078)` |
| Godot/scripts/BootRoot.gd:344 | float | `Color(1.0, 1.0, 1.0, 0.0)` | `body.modulate = Color(1.0, 1.0, 1.0, 0.0)` |
| Godot/scripts/BootRoot.gd:370 | float | `Color(0.0, 0.0, 0.0, 1.0)` | `backdrop.color = Color(0.0, 0.0, 0.0, 1.0)` |
| Godot/scripts/BootStage3D.gd:117 | float | `Color(0.043, 0.055, 0.078)` | `env.background_color = Color(0.043, 0.055, 0.078)` |
| Godot/scripts/BootStage3D.gd:119 | float | `Color(0.22, 0.28, 0.42)` | `env.ambient_light_color = Color(0.22, 0.28, 0.42)` |
| Godot/scripts/BootStage3D.gd:130 | float | `Color(0.16, 0.21, 0.33)` | `env.fog_light_color = Color(0.16, 0.21, 0.33)` |
| Godot/scripts/BootStage3D.gd:142 | float | `Color(0.20, 0.27, 0.42)` | `env.volumetric_fog_albedo = Color(0.20, 0.27, 0.42)` |
| Godot/scripts/BootStage3D.gd:143 | float | `Color(0.03, 0.05, 0.09)` | `env.volumetric_fog_emission = Color(0.03, 0.05, 0.09)` |
| Godot/scripts/BootStage3D.gd:167 | float | `Color(0.72, 0.84, 1.0)` | `rim.light_color = Color(0.72, 0.84, 1.0)` |
| Godot/scripts/BootStage3D.gd:176 | float | `Color(1.0, 0.88, 0.72)` | `key.light_color = Color(1.0, 0.88, 0.72)` |
| Godot/scripts/BootStage3D.gd:190 | float | `Color(0.98, 0.86, 0.74)` | `bounce.light_color = Color(0.98, 0.86, 0.74)` |
| Godot/scripts/BootStage3D.gd:199 | float | `Color(0.45, 0.58, 0.85)` | `fill.light_color = Color(0.45, 0.58, 0.85)` |
| Godot/scripts/BootStage3D.gd:216 | float | `Color(0.030, 0.036, 0.050)` | `floor_material.albedo_color = Color(0.030, 0.036, 0.050)` |
| Godot/scripts/BootStage3D.gd:228 | float | `Color(0.017, 0.021, 0.031)` | `wall_material.albedo_color = Color(0.017, 0.021, 0.031)` |
| Godot/scripts/ComboDecisionTimer.gd:13 | float | `Color(0.30, 0.72, 0.38, 1.0)` | `const GOOD := Color(0.30, 0.72, 0.38, 1.0)` |
| Godot/scripts/ComboDecisionTimer.gd:14 | float | `Color(0.96, 0.79, 0.22, 1.0)` | `const WARN := Color(0.96, 0.79, 0.22, 1.0)` |
| Godot/scripts/ComboDecisionTimer.gd:15 | float | `Color(0.86, 0.20, 0.16, 1.0)` | `const DANGER := Color(0.86, 0.20, 0.16, 1.0)` |
| Godot/scripts/ComboDecisionTimer.gd:69 | float | `Color(0.05, 0.05, 0.04, 0.92)` | `draw_rect(Rect2(Vector2.ZERO, size), Color(0.05, 0.05, 0.04, 0.92), true)` |
| Godot/scripts/ComboDecisionTimer.gd:70 | float | `Color(0.38, 0.42, 0.31, 0.9)` | `draw_rect(Rect2(Vector2.ZERO, size), Color(0.38, 0.42, 0.31, 0.9), false, 1.0)` |
| Godot/scripts/ComboDecisionTimer.gd:75 | float | `Color(0.98, 0.98, 0.96, 1.0)` | `draw_string(BEBAS, Vector2(0.0, size.y * 0.5 + 6.0), text, HORIZONTAL_ALIGNMENT_CENTER, size.x, 16, Color(0.98, 0.98, 0.96, 1.0))` |
| Godot/scripts/ComboStrip.gd:22 | float | `Color(0.94, 0.96, 0.91, 1.0)` | `var _accent := Color(0.94, 0.96, 0.91, 1.0)` |
| Godot/scripts/ComboStrip.gd:69 | float | `Color(0.02, 0.026, 0.018, 0.74)` | `draw_rect(Rect2(Vector2.ZERO, size), Color(0.02, 0.026, 0.018, 0.74), true)` |
| Godot/scripts/CreationRoot.gd:332 | float | `Color(1.0, 1.0, 1.0, 0.0)` | `body.modulate = Color(1.0, 1.0, 1.0, 0.0)` |
| Godot/scripts/FeedbackOverlay.gd:16 | hex | `Color("#3f9dff")` | `const MOVE_BLUE := Color("#3f9dff")` |
| Godot/scripts/FeedbackOverlay.gd:556 | hex | `Color("#111111")` | `draw_arc(anchor, r, 0.0, TAU, 32, Color("#111111"), maxf(2.0, r / 7.0))` |
| Godot/scripts/FeedbackOverlay.gd:558 | hex | `Color("#111111")` | `draw_string(overlay.T.MONO, Vector2(anchor.x - r, anchor.y + font_size * 0.36), str(m["n"]), HORIZONTAL_ALIGNMENT_CENTER, r * 2.0, font_size, Color("#111111"))` |
| Godot/scripts/FightContractScreen.gd:939 | named | `Color.WHITE` | `var ink: Color = Color.WHITE if on else T.TEXT_2` |
| Godot/scripts/FightResultPanel.gd:483 | named | `Color.WHITE` | `var text := UIKit.display(str(value), 21, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)` |
| Godot/scripts/FightWeekPanel.gd:331 | float | `Color(1.0, 1.0, 1.0, 1.0 if open else 0.55)` | `counter_block.modulate = Color(1.0, 1.0, 1.0, 1.0 if open else 0.55)` |
| Godot/scripts/IconKit.gd:104 | hex | `Color("#3f4a62")` | `blank.fill(Color("#3f4a62"))` |
| Godot/scripts/IconKit.gd:115 | hex | `Color("#f0c233")` | `static func fx_material(glow: float = 0.0, emboss: float = 0.0, grain: float = 0.0, glow_color: Color = Color("#f0c233")) -> ShaderMaterial:` |
| Godot/scripts/IconKit.gd:129 | float | `Color(1, 1, 1, 0.85)` | `var c := Color(1, 1, 1, 0.85)` |
| Godot/scripts/ManagementChrome.gd:618 | float | `Color(0.01, 0.015, 0.01, 0.90)` | `overlay.color = Color(0.01, 0.015, 0.01, 0.90)` |
| Godot/scripts/ManagementChrome.gd:645 | float | `Color(0, 0, 0, 0.76)` | `style.shadow_color = Color(0, 0, 0, 0.76)` |
| Godot/scripts/MatRig.gd:206 | float | `Color(0.0, 0.0, 0.0, 1.0)` | `material.albedo_color = Color(0.0, 0.0, 0.0, 1.0)` |
| Godot/scripts/ProfileRevampPanel.gd:2294 | float | `Color(0.0, 0.0, 0.0, 0.0)` | `var fill: Color = Color(0.0, 0.0, 0.0, 0.0)` |
| Godot/scripts/ProfileRevampPanel.gd:2302 | named | `Color.WHITE` | `fg = Color.WHITE` |
| Godot/scripts/ProfileRevampPanel.gd:2463 | float | `Color(1.0, 1.0, 1.0)` | `var wash: Color = Color(1.0, 1.0, 1.0).lerp(tone, 0.28)` |
| Godot/scripts/ProfileRevampPanel.gd:3121 | float | `Color(0.03, 0.04, 0.07, 0.88)` | `backdrop.color = Color(0.03, 0.04, 0.07, 0.88)` |
| Godot/scripts/RankingsHubPanel.gd:1199 | float | `Color(0.0, 0.0, 0.0, 0.0)` | `return Color(0.0, 0.0, 0.0, 0.0)` |
| Godot/scripts/RankingsHubPanel.gd:1203 | float | `Color(0.0, 0.0, 0.0, 0.0)` | `return Color(0.0, 0.0, 0.0, 0.0)` |
| Godot/scripts/RingStagePanel.gd:548 | named | `Color.WHITE` | `button.modulate = ladder["hi"] if is_equal_approx(float(value), speed) else Color.WHITE` |
| Godot/scripts/RingStagePanel.gd:960 | float | `Color(1.0, 0.58, 0.48, 1.0)` | `_tween.tween_property(target, "modulate", Color(1.0, 0.58, 0.48, 1.0), 0.08)` |
| Godot/scripts/RingStagePanel.gd:966 | named | `Color.WHITE` | `_tween.tween_property(target, "modulate", Color.WHITE, 0.20)` |
| Godot/scripts/RingStagePanel.gd:989 | float | `Color(1.0, 0.55, 0.25, 1.0)` | `burst.tint = Color(1.0, 0.55, 0.25, 1.0)` |
| Godot/scripts/RingStagePanel.gd:991 | float | `Color(1.0, 0.80, 0.30, 1.0)` | `burst.tint = Color(1.0, 0.80, 0.30, 1.0)` |
| Godot/scripts/RingStagePanel.gd:1021 | named | `Color.WHITE` | `sprite.modulate = Color.WHITE` |
| Godot/scripts/RingStagePanel.gd:1373 | float | `Color(1.0, 0.95, 0.75, 1.0)` | `var tint := Color(1.0, 0.95, 0.75, 1.0)` |
| Godot/scripts/RingStagePanel.gd:1393 | float | `Color(1.0, 1.0, 0.96, alpha * 0.85)` | `draw_circle(Vector2.ZERO, reach * 0.30, Color(1.0, 1.0, 0.96, alpha * 0.85))` |
| Godot/scripts/RingStagePanel.gd:1413 | float | `Color(0.85, 0.90, 0.98, alpha)` | `draw_arc(Vector2(14.0 * direction * progress, 0), sweep, PI * 0.7, PI * 1.35, 20, Color(0.85, 0.90, 0.98, alpha), 4.0, true)` |
| Godot/scripts/RingStagePanel.gd:1414 | float | `Color(0.85, 0.90, 0.98, alpha * 0.6)` | `draw_arc(Vector2(26.0 * direction * progress, 4), sweep * 0.7, PI * 0.75, PI * 1.25, 16, Color(0.85, 0.90, 0.98, alpha * 0.6), 3.0, true)` |
| Godot/scripts/ScorecardPanel.gd:267 | named | `Color.WHITE` | `var ink: Color = Color.WHITE if marked else T.TEXT_2` |
| Godot/scripts/SetpieceChrome.gd:105 | float | `Color(1.0, 1.0, 1.0, 1.0 if armed else 0.42)` | `(way as Control).modulate = Color(1.0, 1.0, 1.0, 1.0 if armed else 0.42)` |
| Godot/scripts/SetpieceRoot.gd:309 | float | `Color(1.0, 1.0, 1.0, 0.0)` | `frame_root.modulate = Color(1.0, 1.0, 1.0, 0.0)` |
| Godot/scripts/SetpieceRoot.gd:311 | float | `Color(1.0, 1.0, 1.0, 0.0)` | `body.modulate = Color(1.0, 1.0, 1.0, 0.0)` |
| Godot/scripts/SetpieceRoot.gd:330 | float | `Color(1.0, 1.0, 1.0, 0.0)` | `body.modulate = Color(1.0, 1.0, 1.0, 0.0)` |
| Godot/scripts/ShellChrome.gd:135 | float | `Color(0, 0, 0, 0)` | `style.bg_color = T.gym_ladder(T.GYM_DEFAULT)["mid"] if active else Color(0, 0, 0, 0)` |
| Godot/scripts/SkillsMovesPanel.gd:317 | float | `Color(1.18, 1.18, 1.18, 1.0)` | `cell.modulate = Color(1.18, 1.18, 1.18, 1.0) if chosen else Color.WHITE` |
| Godot/scripts/SkillsMovesPanel.gd:317 | named | `Color.WHITE` | `cell.modulate = Color(1.18, 1.18, 1.18, 1.0) if chosen else Color.WHITE` |
| Godot/scripts/SkillsMovesPanel.gd:320 | float | `Color(0, 0, 0, 0)` | `var ring: Panel = UIKit.block(cell.size, Color(0, 0, 0, 0), T.RADIUS, 0.0)` |
| Godot/scripts/SkillsMovesPanel.gd:331 | float | `Color(0, 0, 0, 0)` | `ringed.bg_color = Color(0, 0, 0, 0)` |
| Godot/scripts/TaleOfTheTape.gd:11 | float | `Color(0.008, 0.010, 0.012, 0.985)` | `const C_BG := Color(0.008, 0.010, 0.012, 0.985)` |
| Godot/scripts/TaleOfTheTape.gd:12 | float | `Color(0.025, 0.028, 0.032, 0.98)` | `const C_PANEL := Color(0.025, 0.028, 0.032, 0.98)` |
| Godot/scripts/TaleOfTheTape.gd:13 | float | `Color(0.045, 0.048, 0.052, 0.92)` | `const C_PANEL_ALT := Color(0.045, 0.048, 0.052, 0.92)` |
| Godot/scripts/TaleOfTheTape.gd:14 | float | `Color(0.95, 0.96, 0.94, 1.0)` | `const C_TEXT := Color(0.95, 0.96, 0.94, 1.0)` |
| Godot/scripts/TaleOfTheTape.gd:15 | float | `Color(0.60, 0.63, 0.64, 1.0)` | `const C_MUTED := Color(0.60, 0.63, 0.64, 1.0)` |
| Godot/scripts/TaleOfTheTape.gd:16 | float | `Color(0.20, 0.22, 0.23, 1.0)` | `const C_LINE := Color(0.20, 0.22, 0.23, 1.0)` |
| Godot/scripts/TaleOfTheTape.gd:17 | float | `Color(0.88, 0.13, 0.16, 1.0)` | `const C_RED := Color(0.88, 0.13, 0.16, 1.0)` |
| Godot/scripts/TaleOfTheTape.gd:18 | float | `Color(0.08, 0.40, 0.82, 1.0)` | `const C_BLUE := Color(0.08, 0.40, 0.82, 1.0)` |
| Godot/scripts/TaleOfTheTape.gd:19 | float | `Color(0.96, 0.79, 0.22, 1.0)` | `const C_ACID := Color(0.96, 0.79, 0.22, 1.0)` |
| Godot/scripts/TaleOfTheTape.gd:20 | float | `Color(0.95, 0.78, 0.22, 1.0)` | `const C_GOLD := Color(0.95, 0.78, 0.22, 1.0)` |
| Godot/scripts/TaleOfTheTape.gd:139 | named | `Color.WHITE` | `var tag := _label("%s CORNER" % side_key.to_upper(), 17, Color.WHITE, BEBAS, HORIZONTAL_ALIGNMENT_CENTER)` |
| Godot/scripts/TaleOfTheTape.gd:216 | float | `Color(0.014, 0.016, 0.019, 0.98)` | `var panel := _panel(Rect2(458, 92, 1004, 732), Color(0.014, 0.016, 0.019, 0.98), C_LINE, 1, 4)` |
| Godot/scripts/TaleOfTheTape.gd:238 | float | `Color(0.020, 0.022, 0.025, 0.92)` | `strip.color = C_PANEL_ALT if index % 2 == 0 else Color(0.020, 0.022, 0.025, 0.92)` |
| Godot/scripts/TaleOfTheTape.gd:309 | float | `Color(0.03, 0.04, 0.02, 1.0)` | `begin.add_theme_color_override("font_color", Color(0.03, 0.04, 0.02, 1.0))` |
| Godot/scripts/TaleOfTheTape.gd:310 | named | `Color.BLACK` | `begin.add_theme_color_override("font_hover_color", Color.BLACK)` |
| Godot/scripts/TechniqueGlyph.gd:13 | float | `Color(0.96, 0.79, 0.22, 1.0)` | `const GOLD := Color(0.96, 0.79, 0.22, 1.0)` |
| Godot/scripts/TechniqueGlyph.gd:14 | float | `Color(0.03, 0.035, 0.03, 0.92)` | `const INK := Color(0.03, 0.035, 0.03, 0.92)` |
| Godot/scripts/TechniqueGlyph.gd:15 | float | `Color(0.86, 0.20, 0.16, 0.95)` | `const MISS_RED := Color(0.86, 0.20, 0.16, 0.95)` |
| Godot/scripts/TechniqueGlyph.gd:19 | float | `Color(0.94, 0.76, 0.20)` | `"boxing": Color(0.94, 0.76, 0.20), "kickboxing": Color(0.95, 0.52, 0.16),` |
| Godot/scripts/TechniqueGlyph.gd:19 | float | `Color(0.95, 0.52, 0.16)` | `"boxing": Color(0.94, 0.76, 0.20), "kickboxing": Color(0.95, 0.52, 0.16),` |
| Godot/scripts/TechniqueGlyph.gd:20 | float | `Color(0.32, 0.52, 0.76)` | `"muay_thai": Color(0.84, 0.18, 0.15), "wrestling": Color(0.32, 0.52, 0.76),` |
| Godot/scripts/TechniqueGlyph.gd:20 | float | `Color(0.84, 0.18, 0.15)` | `"muay_thai": Color(0.84, 0.18, 0.15), "wrestling": Color(0.32, 0.52, 0.76),` |
| Godot/scripts/TechniqueGlyph.gd:21 | float | `Color(0.25, 0.40, 0.85)` | `"brazilian_jiu_jitsu": Color(0.25, 0.40, 0.85), "judo": Color(0.85, 0.90, 0.98),` |
| Godot/scripts/TechniqueGlyph.gd:21 | float | `Color(0.85, 0.90, 0.98)` | `"brazilian_jiu_jitsu": Color(0.25, 0.40, 0.85), "judo": Color(0.85, 0.90, 0.98),` |
| Godot/scripts/TechniqueGlyph.gd:22 | float | `Color(0.20, 0.75, 0.85)` | `"karate": Color(0.92, 0.92, 0.92), "taekwondo": Color(0.20, 0.75, 0.85),` |
| Godot/scripts/TechniqueGlyph.gd:22 | float | `Color(0.92, 0.92, 0.92)` | `"karate": Color(0.92, 0.92, 0.92), "taekwondo": Color(0.20, 0.75, 0.85),` |
| Godot/scripts/TechniqueGlyph.gd:23 | float | `Color(0.20, 0.65, 0.60)` | `"sanda": Color(0.90, 0.35, 0.20), "sambo": Color(0.20, 0.65, 0.60),` |
| Godot/scripts/TechniqueGlyph.gd:23 | float | `Color(0.90, 0.35, 0.20)` | `"sanda": Color(0.90, 0.35, 0.20), "sambo": Color(0.20, 0.65, 0.60),` |
| Godot/scripts/TechniqueGlyph.gd:24 | float | `Color(0.30, 0.72, 0.38)` | `"savate": Color(0.60, 0.35, 0.80), "capoeira": Color(0.30, 0.72, 0.38),` |
| Godot/scripts/TechniqueGlyph.gd:24 | float | `Color(0.60, 0.35, 0.80)` | `"savate": Color(0.60, 0.35, 0.80), "capoeira": Color(0.30, 0.72, 0.38),` |
| Godot/scripts/TechniqueGlyph.gd:25 | float | `Color(0.60, 0.80, 0.25)` | `"arnis": Color(0.70, 0.50, 0.25), "pencak_silat": Color(0.60, 0.80, 0.25),` |
| Godot/scripts/TechniqueGlyph.gd:25 | float | `Color(0.70, 0.50, 0.25)` | `"arnis": Color(0.70, 0.50, 0.25), "pencak_silat": Color(0.60, 0.80, 0.25),` |
| Godot/scripts/TechniqueGlyph.gd:26 | float | `Color(0.55, 0.60, 0.68)` | `"mma": Color(0.55, 0.60, 0.68),` |
| Godot/scripts/TechniqueGlyph.gd:86 | float | `Color(0.94, 0.96, 0.91, alpha)` | `canvas.draw_string(font, Vector2(rect.position.x, rect.position.y + rect.size.y - 4.0), code, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 9, Color(0.94, 0.96, 0.91, alpha))` |
| Godot/scripts/TechniqueGlyph.gd:95 | float | `Color(0.32, 0.52, 0.76, alpha)` | `canvas.draw_rect(badge, Color(0.32, 0.52, 0.76, alpha), true)` |
| Godot/scripts/TechniqueGlyph.gd:96 | float | `Color(1, 1, 1, alpha)` | `canvas.draw_string(font, Vector2(badge.position.x, badge.position.y + 9.0), "R", HORIZONTAL_ALIGNMENT_CENTER, badge.size.x, 8, Color(1, 1, 1, alpha))` |
| Godot/scripts/UIKit.gd:51 | float | `Color(0.0, 0.0, 0.0, float(tier["shadow_alpha"]) if depth > 0 else 0.0)` | `style.shadow_color = Color(0.0, 0.0, 0.0, float(tier["shadow_alpha"]) if depth > 0 else 0.0)` |
| Godot/scripts/UIKit.gd:67 | float | `Color(1.0, 1.0, 1.0, strength * 1.35)` | `gradient.set_color(0, Color(1.0, 1.0, 1.0, strength * 1.35))` |
| Godot/scripts/UIKit.gd:68 | float | `Color(0.0, 0.0, 0.0, bottom)` | `gradient.set_color(1, Color(0.0, 0.0, 0.0, bottom))` |
| Godot/scripts/UIKit.gd:69 | float | `Color(1.0, 1.0, 1.0, strength * 0.55)` | `gradient.add_point(0.10, Color(1.0, 1.0, 1.0, strength * 0.55))` |
| Godot/scripts/UIKit.gd:70 | float | `Color(1.0, 1.0, 1.0, 0.0)` | `gradient.add_point(0.52, Color(1.0, 1.0, 1.0, 0.0))` |
| Godot/scripts/UIKit.gd:142 | float | `Color(1.0, 1.0, 1.0, 0.07)` | `style.shadow_color = Color(1.0, 1.0, 1.0, 0.07)` |
| Godot/scripts/UIKit.gd:159 | float | `Color(0, 0, 0, 0)` | `static func circle(diameter: float, bg: Color, edge: Color = T.EDGE, edge_width: int = 1, glow: Color = Color(0, 0, 0, 0)) -> Panel:` |
| Godot/scripts/UIKit.gd:219 | hex | `Color("#b8ffc4")` | `var tint: Color = T.INK if grade >= 2 else (Color("#b8ffc4") if up else Color("#ffd6d1"))` |
| Godot/scripts/UIKit.gd:219 | hex | `Color("#ffd6d1")` | `var tint: Color = T.INK if grade >= 2 else (Color("#b8ffc4") if up else Color("#ffd6d1"))` |
| Godot/scripts/UIKit.gd:244 | named | `Color.WHITE` | `var text := display(label_text.to_upper(), 16, Color.WHITE)` |
| Godot/scripts/UIKit.gd:316 | float | `Color(0.0, 0.0, 0.0, 0.5)` | `var dot := circle(diameter, color, Color(0.0, 0.0, 0.0, 0.5), 1, Color(color.r, color.g, color.b, 0.9))` |
| Godot/scripts/UIKit.gd:337 | hex | `Color("#3c475e")` | `draw_colored_polygon(points, T.GOLD if i < count else Color("#3c475e"))` |
| Godot/scripts/UIKit.gd:341 | hex | `Color("#5a6883")` | `draw_rect(body, Color("#5a6883"))` |
| Godot/scripts/UIKit.gd:342 | hex | `Color("#5a6883")` | `draw_arc(Vector2(x + star_size * 0.35, star_size * 0.42), star_size * 0.22, PI, TAU, 12, Color("#5a6883"), 2.5)` |
| Godot/scripts/UIKit.gd:378 | named | `Color.WHITE` | `var number := label(text, T.SIZE_MIN, Color.WHITE, T.MONO, HORIZONTAL_ALIGNMENT_CENTER)` |
| Godot/scripts/UIKit.gd:424 | named | `Color.WHITE` | `fg = Color.WHITE` |
| Godot/scripts/UIKit.gd:429 | named | `Color.WHITE` | `fg = Color.WHITE` |
| Godot/scripts/UIKit.gd:432 | hex | `Color("#ef5a50")` | `hover = Color("#ef5a50")` |
| Godot/scripts/UIKit.gd:434 | named | `Color.WHITE` | `fg = Color.WHITE` |
| Godot/scripts/UIKit.gd:466 | float | `Color(0.0, 0.0, 0.0, 0.35)` | `style.shadow_color = Color(0.0, 0.0, 0.0, 0.35)` |
| Godot/scripts/UIKit.gd:481 | named | `Color.WHITE` | `var fg: Color = Color.WHITE if i == selected else T.TEXT_2` |
| Godot/scripts/UIKit.gd:549 | named | `Color.WHITE` | `fg = Color.WHITE` |
| Godot/scripts/UIKit.gd:552 | named | `Color.WHITE` | `fg = Color.WHITE` |
| Godot/scripts/UIKit.gd:603 | named | `Color.WHITE` | `var fg: Color = Color.WHITE` |
| Godot/scripts/UIKit.gd:667 | float | `Color(0.0, 0.0, 0.0, 0.25)` | `var rest := block(Vector2(width - label_width + 6.0, 36.0), Color(0.0, 0.0, 0.0, 0.25), 0, 0.0)` |
| Godot/scripts/UIKit.gd:671 | named | `Color.WHITE` | `var title := display(text.to_upper(), T.SIZE_HEADER_BAR, Color.WHITE)` |
| Godot/scripts/UIKit.gd:712 | float | `Color(0.0, 0.0, 0.0, 0.5)` | `var crest := circle(crest_d, ladder["hi"], T.EDGE, 2, Color(0.0, 0.0, 0.0, 0.5))` |
| Godot/scripts/UIKit.gd:716 | named | `Color.WHITE` | `var crest_text := display(initials, 18, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)` |
| Godot/scripts/UIKit.gd:760 | float | `Color(1, 1, 1, 0.9)` | `var week := caps(week_line, T.SIZE_LABEL, Color(1, 1, 1, 0.9), HORIZONTAL_ALIGNMENT_RIGHT)` |
| Godot/scripts/UIKit.gd:764 | named | `Color.WHITE` | `var date := display(date_line, 22, Color.WHITE, HORIZONTAL_ALIGNMENT_RIGHT)` |
| Godot/scripts/UIKit.gd:775 | float | `Color(1, 1, 1, 0.85)` | `var sub_label := caps(sub, T.SIZE_LABEL, Color(1, 1, 1, 0.85))` |
| Godot/scripts/UIKit.gd:807 | float | `Color(1, 1, 1, 0.55)` | `cell.modulate = Color(1, 1, 1, 0.55)` |
| Godot/scripts/UIKit.gd:840 | hex | `Color("#e5433a")` | `var ramp: Array = [Color("#e5433a"), Color("#f0a020"), Color("#f0c233")]` |
| Godot/scripts/UIKit.gd:840 | hex | `Color("#f0a020")` | `var ramp: Array = [Color("#e5433a"), Color("#f0a020"), Color("#f0c233")]` |
| Godot/scripts/UIKit.gd:840 | hex | `Color("#f0c233")` | `var ramp: Array = [Color("#e5433a"), Color("#f0a020"), Color("#f0c233")]` |
| Godot/scripts/UIKit.gd:894 | hex | `Color("#1f2636")` | `draw_circle(center, r, Color("#1f2636"))` |
| Godot/scripts/UIKit.gd:977 | hex | `Color("#12141b")` | `var root := block(size, Color("#12141b"), T.RADIUS, -1.0, T.HERO)` |
| Godot/scripts/UIKit.gd:1020 | float | `Color(1, 1, 1, 0)` | `node.modulate = Color(1, 1, 1, 0)` |
| Godot/scripts/UIKit.gd:1024 | float | `Color(1, 1, 1, 1)` | `tween.tween_property(node, "modulate", Color(1, 1, 1, 1), 0.38).set_delay(delay).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)` |
| Godot/scripts/UIKit.gd:1040 | float | `Color(1, 1, 1, 0.35)` | `tween.tween_property(node, "modulate", Color(1, 1, 1, 0.35), period / 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)` |
| Godot/scripts/UIKit.gd:1041 | float | `Color(1, 1, 1, 1.0)` | `tween.tween_property(node, "modulate", Color(1, 1, 1, 1.0), period / 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)` |
| Godot/scripts/UIKit.gd:1063 | named | `Color.WHITE` | `fg = Color.WHITE` |
| Godot/scripts/UIKit.gd:1121 | float | `Color(1, 1, 1, 0.8)` | `var cap: Label = caps(caption, T.SIZE_MIN, Color(1, 1, 1, 0.8) if state == "learned" else glyph)` |
| Godot/scripts/UIKit.gd:1163 | named | `Color.WHITE` | `var _lit: Color = Color.WHITE` |
| Godot/scripts/UIKit.gd:1164 | named | `Color.GRAY` | `var _dim: Color = Color.GRAY` |
| Godot/scripts/UIKit.gd:1260 | named | `Color.WHITE` | `tint = Color.WHITE` |
| Godot/scripts/UIKit.gd:1295 | float | `Color(0.92, 0.92, 0.92, 1.0)` | `image.modulate = Color(0.92, 0.92, 0.92, 1.0)` |
| Godot/scripts/UIKit.gd:1585 | float | `Color(0, 0, 0, 0)` | `var glow: Color = Color(fill.r, fill.g, fill.b, 0.4) if i == 0 else Color(0, 0, 0, 0)` |
| Godot/scripts/UIKit.gd:1613 | hex | `Color("#161b27")` | `draw_circle(center, r, Color("#161b27"))` |
| Godot/scripts/UIKit.gd:1870 | named | `Color.WHITE` | `var rank_label := display(rank_text, 18, T.GOLD if champion else (Color.WHITE if you else T.TEXT_2), HORIZONTAL_ALIGNMENT_CENTER)` |
| Godot/scripts/UIKit.gd:1873 | named | `Color.WHITE` | `var name_label := display(str(row.get("name", "")).to_upper(), 18, Color.WHITE if you else T.TEXT)` |
| Godot/scripts/UIKit.gd:1879 | named | `Color.WHITE` | `var record_label := caps(str(row.get("record", "")), T.SIZE_MIN, Color.WHITE if you else T.MUTED, HORIZONTAL_ALIGNMENT_RIGHT)` |
| Godot/scripts/UIKit.gd:1884 | named | `Color.WHITE` | `var points_label := caps(str(row.get("points", "")), T.SIZE_MIN, Color.WHITE if you else T.TEXT_2, HORIZONTAL_ALIGNMENT_RIGHT)` |
| Godot/scripts/UIKit.gd:1928 | named | `Color.WHITE` | `var text_label := display(text, 20, Color.WHITE if active else T.MUTED)` |
| Godot/scripts/UIKit.gd:2014 | float | `Color(0.03, 0.04, 0.07, 0.72)` | `backdrop.color = Color(0.03, 0.04, 0.07, 0.72)` |
| Godot/scripts/UIKit.gd:2089 | float | `Color(0.0, 0.0, 0.0, 0.0)` | `hit.add_theme_stylebox_override("hover", _button_style(hover, Color(0.0, 0.0, 0.0, 0.0)))` |
| Godot/scripts/UIKit.gd:2090 | float | `Color(0.0, 0.0, 0.0, 0.0)` | `hit.add_theme_stylebox_override("pressed", _button_style(hover, Color(0.0, 0.0, 0.0, 0.0)))` |
| Godot/scripts/UIKit.gd:2330 | named | `Color.WHITE` | `var fg: Color = Color.WHITE if lit else T.TEXT_2` |
| Godot/scripts/UIKit.gd:3574 | named | `Color.WHITE` | `return [T.gym_ladder(gym)["mid"], Color.WHITE, T.EDGE]` |
| Godot/scripts/UIKit.gd:3578 | named | `Color.WHITE` | `return [T.BAD, Color.WHITE, T.BAD_EDGE]` |
| Godot/scripts/UIKit.gd:3841 | float | `Color(1.0, 1.0, 1.0, 0.05)` | `var hit := _flat_hit(Vector2(width, height), Color(1.0, 1.0, 1.0, 0.05))` |
| Godot/scripts/UIKit.gd:4001 | float | `Color(0.0, 0.0, 0.0, 0.0)` | `root.add_theme_stylebox_override("hover", _button_style(T.CONTROL_HI, Color(0.0, 0.0, 0.0, 0.0)))` |
| Godot/scripts/UIKit.gd:4002 | float | `Color(0.0, 0.0, 0.0, 0.0)` | `root.add_theme_stylebox_override("pressed", _button_style(T.CONTROL_HI, Color(0.0, 0.0, 0.0, 0.0)))` |
| Godot/scripts/UIKit.gd:4902 | float | `Color(1.0, 1.0, 1.0, 0.06)` | `var hit := _flat_hit(size, Color(1.0, 1.0, 1.0, 0.06))` |
| Godot/scripts/UIKit.gd:4906 | float | `Color(1.0, 1.0, 1.0, 0.42)` | `root.modulate = Color(1.0, 1.0, 1.0, 0.42)` |
| Godot/scripts/UIKit.gd:5237 | named | `Color.WHITE` | `var left_value := display(str(left), 22, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)` |
| Godot/scripts/UIKit.gd:5244 | named | `Color.WHITE` | `var right_value := display(str(right), 22, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)` |
| Godot/scripts/UIKit.gd:5417 | float | `Color(1.0, 1.0, 1.0, travelled)` | `title.modulate = Color(1.0, 1.0, 1.0, travelled)` |
| Godot/scripts/UIKit.gd:5423 | float | `Color(1.0, 1.0, 1.0, travelled)` | `cue.modulate = Color(1.0, 1.0, 1.0, travelled)` |
| Godot/scripts/UIKit.gd:5498 | named | `Color.WHITE` | `var mark_text := display("FC", 26, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)` |
| Godot/scripts/UIKit.gd:5585 | float | `Color(1.0, 1.0, 1.0, 0.05)` | `var hit := _flat_hit(Vector2(width, height), Color(1.0, 1.0, 1.0, 0.05))` |
| Godot/scripts/UIKit.gd:5764 | named | `Color.WHITE` | `var label_text := display(str(row.get("label", "")).to_upper(), 16, Color.WHITE)` |
| Godot/scripts/UIKit.gd:5786 | float | `Color(1.0, 1.0, 1.0, 0.08)` | `var hit := _flat_hit(Vector2(track_width, 22.0), Color(1.0, 1.0, 1.0, 0.08))` |
| Godot/scripts/UIKit.gd:5807 | float | `Color(1.0, 1.0, 1.0, 0.10)` | `var segment_hit := _flat_hit(segment.size, Color(1.0, 1.0, 1.0, 0.10))` |
| Godot/scripts/UIKit.gd:5839 | float | `Color(0.03, 0.04, 0.07, 0.78)` | `backdrop.color = Color(0.03, 0.04, 0.07, 0.78)` |
| Godot/scripts/UIKit.gd:5904 | float | `Color(1.0, 1.0, 1.0, travelled)` | `head.modulate = Color(1.0, 1.0, 1.0, travelled)` |
| Godot/scripts/UIKit.gd:5910 | float | `Color(1.0, 1.0, 1.0, travelled)` | `cue.modulate = Color(1.0, 1.0, 1.0, travelled)` |
| Godot/scripts/UIKit.gd:6257 | named | `Color.WHITE` | `var mark_text := display("FC", 26, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)` |
| Godot/scripts/UIKit.gd:6367 | named | `Color.WHITE` | `var mark_color: Color = Color.WHITE if here else (T.TEXT_2 if done else T.DIM)` |
| Godot/scripts/UIKit.gd:6799 | float | `Color(1.0, 1.0, 1.0, travelled)` | `head.modulate = Color(1.0, 1.0, 1.0, travelled)` |
| Godot/scripts/UIKit.gd:6805 | float | `Color(1.0, 1.0, 1.0, travelled)` | `cue.modulate = Color(1.0, 1.0, 1.0, travelled)` |
| Godot/scripts/UIKit.gd:7048 | float | `Color(1.0, 1.0, 1.0, 0.62)` | `root.modulate = Color(1.0, 1.0, 1.0, 0.62)` |
| Godot/scripts/UIKit.gd:7389 | float | `Color(0.96, 0.79, 0.22, 0.88)` | `var accent := Color(0.96, 0.79, 0.22, 0.88)` |
| Godot/scripts/UIKit.gd:7397 | float | `Color(0.12, 0.12, 0.10, 0.54)` | `var floor_color := Color(0.12, 0.12, 0.10, 0.54)` |
| Godot/scripts/UIKit.gd:7404 | float | `Color(0.22, 0.25, 0.20, 0.9)` | `draw_polyline(cage, Color(0.22, 0.25, 0.20, 0.9), 9.0, true)` |
| Godot/scripts/UIKit.gd:7406 | float | `Color(0.35, 0.38, 0.32, 0.23)` | `draw_line(Vector2(x, top + 40.0), Vector2(x + 130, base - 10.0), Color(0.35, 0.38, 0.32, 0.23), 2.0)` |
| Godot/scripts/UIKit.gd:7407 | float | `Color(0.35, 0.38, 0.32, 0.23)` | `draw_line(Vector2(x + 130, top + 40.0), Vector2(x, base - 10.0), Color(0.35, 0.38, 0.32, 0.23), 2.0)` |
| Godot/scripts/UIKit.gd:7409 | float | `Color(0.08, 0.20, 0.34, 0.72)` | `draw_colored_polygon(PackedVector2Array([Vector2(190, base), Vector2(w - 190, base), Vector2(w - 350, top), Vector2(350, top)]), Color(0.08, 0.20, 0.34, 0.72))` |
| Godot/scripts/UIKit.gd:7410 | float | `Color(0.95, 0.44, 0.14, 0.86)` | `draw_arc(Vector2(w * 0.5, h * 0.72), h * 0.30, 0, TAU, 96, Color(0.95, 0.44, 0.14, 0.86), 8.0, true)` |
| Godot/scripts/UIKit.gd:7412 | float | `Color(0.16, 0.37, 0.42, 0.70)` | `var tatami_color := Color(0.76, 0.69, 0.48, 0.70) if arena_profile == "judo_tatami" else Color(0.16, 0.37, 0.42, 0.70)` |
| Godot/scripts/UIKit.gd:7412 | float | `Color(0.76, 0.69, 0.48, 0.70)` | `var tatami_color := Color(0.76, 0.69, 0.48, 0.70) if arena_profile == "judo_tatami" else Color(0.16, 0.37, 0.42, 0.70)` |
| Godot/scripts/UIKit.gd:7420 | float | `Color(0.74, 0.12, 0.10, 0.88)` | `draw_line(Vector2(125, rope_y), Vector2(w - 125, rope_y), Color(0.74, 0.12, 0.10, 0.88) if i == 2 else Color(0.88, 0.86, 0.78, 0.82), 6.0, true)` |
| Godot/scripts/UIKit.gd:7420 | float | `Color(0.88, 0.86, 0.78, 0.82)` | `draw_line(Vector2(125, rope_y), Vector2(w - 125, rope_y), Color(0.74, 0.12, 0.10, 0.88) if i == 2 else Color(0.88, 0.86, 0.78, 0.82), 6.0, true)` |
| Godot/scripts/UIKit.gd:7422 | float | `Color(0.06, 0.06, 0.055, 0.98)` | `draw_line(Vector2(post_x, top - 18.0), Vector2(post_x, base + 20.0), Color(0.06, 0.06, 0.055, 0.98), 22.0, true)` |

## 4. The near-misses

**Exact-token duplicate count: 5.** Each row below is an in-scope hex literal whose exact hex string also appears as a scalar constant value in `UITokens.gd`.

| script:line | the literal | the UITokens constant with the same value |
|---|---|---|
| Godot/scripts/IconKit.gd:104 | `Color("#3f4a62")` | `SLATE` |
| Godot/scripts/IconKit.gd:115 | `Color("#f0c233")` | `GOLD` |
| Godot/scripts/UIKit.gd:840 | `Color("#e5433a")` | `BAD` |
| Godot/scripts/UIKit.gd:840 | `Color("#f0a020")` | `AMBER` |
| Godot/scripts/UIKit.gd:840 | `Color("#f0c233")` | `GOLD` |

No matching was attempted for float-component or named forms. Converting between representations would make this mechanical exact-string audit invent equivalences.

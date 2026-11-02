# M2 — Cage Desk asset replace manifest

Author: Maria Art Director (Grok Bot) · Tool: Cursor GenerateImage + Pillow · Date: 2026-09-06
Operator-cleared commercial/ship use. Nothing ripped from live games.
Style lock: Cage Desk (graphic broadcast plates + desk chrome; sodium `#F2C14E` / ice `#5EC8E0`).

## Supersedes (K2 root set)

All of the following K2 files under `Godot/assets/ui/` are replaced by this pack:

- `belt_empty_outline.png`
- `belt_regional.png`
- `belt_world.png`
- `body_muscle_map_front.png`
- `body_region_head_neck.png`
- `body_region_left_arm.png`
- `body_region_left_leg.png`
- `body_region_right_arm.png`
- `body_region_right_leg.png`
- `body_region_torso_core.png`
- `discipline_glyphs_sheet.png`
- `glyph_bjj.png`
- `glyph_boxing.png`
- `glyph_freestyle_wrestling.png`
- `glyph_greco_roman.png`
- `glyph_judo.png`
- `glyph_karate.png`
- `glyph_kickboxing.png`
- `glyph_mma.png`
- `glyph_muay_thai.png`
- `glyph_sambo.png`
- `glyph_taekwondo.png`
- `medal_rank.png`
- `plate_corner_stool.png`
- `plate_locked_cage.png`
- `trophy_fight_night.png`
- `trophy_grand_prix.png`
- `trophy_performance_night.png`

## Leaves standing

- `Godot/assets/ui/icons/moves/` — 273 move pictograms (live consumers). Untouched.
- `Godot/assets/ui/icons/disciplines/` — if present, untouched.
- `Godot/assets/ui/README.md` — Claude updates the licence table from this manifest on land.
- Any file under `Godot/assets/ui/` not named in the table below.

## File table

| Filename | Pixels | Replaces | Purpose |
| --- | --- | --- | --- |
| `plate_locked_cage.png` | 1280x720 | K2 plate_locked_cage.png | Locked Fight Camp empty-cage plate, Cage Desk graphic |
| `plate_corner_stool.png` | 1280x720 | K2 plate_corner_stool.png | Corner stool plate, Cage Desk graphic |
| `plate_gym_floor.png` | 1280x720 | new | Empty gym floor plate under sodium spot |
| `plate_fighter_identity.png` | 384x512 | new | Fighter identity silhouette poster for profile hero |
| `plate_ring_dual_sil.png` | 1280x720 | new | Dual-silhouette ring face-off plate (mild neon rim soft note) |
| `plate_fight_week.png` | 1280x720 | new | Fight Week aisle/tunnel plate toward the lights |
| `body_muscle_map_front.png` | 512x512 | K2 body_muscle_map_front.png | Front muscle map diagram, Cage Desk palette |
| `body_region_head_neck.png` | 97x121 | K2 body_region_head_neck.png | Tight silhouette hit mask — BodyReadiness head_neck |
| `body_region_torso_core.png` | 155x261 | K2 body_region_torso_core.png | Tight silhouette hit mask — BodyReadiness torso_core |
| `body_region_left_arm.png` | 119x292 | K2 body_region_left_arm.png | Tight silhouette hit mask — BodyReadiness left_arm (screen-left) |
| `body_region_right_arm.png` | 119x292 | K2 body_region_right_arm.png | Tight silhouette hit mask — BodyReadiness right_arm (screen-right) |
| `body_region_left_leg.png` | 162x336 | K2 body_region_left_leg.png | Tight silhouette hit mask — BodyReadiness left_leg (screen-left) |
| `body_region_right_leg.png` | 161x336 | K2 body_region_right_leg.png | Tight silhouette hit mask — BodyReadiness right_leg (screen-right) |
| `belt_world.png` | 512x288 | K2 belt_world.png | World belt graphic, no real promo marks |
| `belt_regional.png` | 512x288 | K2 belt_regional.png | Regional belt graphic |
| `belt_empty_outline.png` | 512x288 | K2 belt_empty_outline.png | Not-yet-won belt outline |
| `trophy_fight_night.png` | 512x288 | K2 trophy_fight_night.png | Fight of the Night trophy |
| `trophy_performance_night.png` | 512x288 | K2 trophy_performance_night.png | Performance of the Night trophy |
| `trophy_grand_prix.png` | 512x288 | K2 trophy_grand_prix.png | Grand Prix trophy |
| `medal_rank.png` | 512x288 | K2 medal_rank.png | Rank medallion |
| `glyph_bjj.png` | 256x256 | K2 glyph_bjj.png | Discipline glyph bjj |
| `glyph_boxing.png` | 256x256 | K2 glyph_boxing.png | Discipline glyph boxing |
| `glyph_freestyle_wrestling.png` | 256x256 | K2 glyph_freestyle_wrestling.png | Discipline glyph freestyle_wrestling |
| `glyph_greco_roman.png` | 256x256 | K2 glyph_greco_roman.png | Discipline glyph greco_roman |
| `glyph_judo.png` | 256x256 | K2 glyph_judo.png | Discipline glyph judo |
| `glyph_karate.png` | 256x256 | K2 glyph_karate.png | Discipline glyph karate |
| `glyph_kickboxing.png` | 256x256 | K2 glyph_kickboxing.png | Discipline glyph kickboxing |
| `glyph_mma.png` | 256x256 | K2 glyph_mma.png | Discipline glyph mma |
| `glyph_muay_thai.png` | 256x256 | K2 glyph_muay_thai.png | Discipline glyph muay_thai |
| `glyph_sambo.png` | 256x256 | K2 glyph_sambo.png | Discipline glyph sambo |
| `glyph_taekwondo.png` | 256x256 | K2 glyph_taekwondo.png | Discipline glyph taekwondo |
| `discipline_glyphs_sheet.png` | 1024x768 | K2 discipline_glyphs_sheet.png | Master sheet of eleven discipline glyphs |

## New files (no K2 counterpart)

- `plate_gym_floor.png` — Empty gym floor plate under sodium spot
- `plate_fighter_identity.png` — Fighter identity silhouette poster for profile hero
- `plate_ring_dual_sil.png` — Dual-silhouette ring face-off plate (mild neon rim soft note)
- `plate_fight_week.png` — Fight Week aisle/tunnel plate toward the lights

## BodyReadiness mask mapping

Tight silhouette partitions from `body_muscle_map_front.png` (upgrade invited by K2 README elliptical note).

| BodyReadiness key | File | Notes |
| --- | --- | --- |
| `head_neck` | `body_region_head_neck.png` | Top of figure incl. neck band |
| `torso_core` | `body_region_torso_core.png` | Chest/abs within torso width band |
| `left_arm` | `body_region_left_arm.png` | Screen-left arm (viewer left) |
| `right_arm` | `body_region_right_arm.png` | Screen-right arm |
| `left_leg` | `body_region_left_leg.png` | Screen-left leg |
| `right_leg` | `body_region_right_leg.png` | Screen-right leg |

Verify against `_body_regions_tight_preview.png` in the art-dir working set if needed; shipping copies are the six `body_region_*.png` above.

## Soft notes

- `plate_ring_dual_sil.png` — ice/sodium split is correct; outline still carries mild neon glow drift. Usable; redraw later if fight HUD wants flatter rims.
- K2 root set has no code consumers today (only `icons/moves/` is read). Landing is safe/invisible until a surface binds these files.

## Licence lines (for Claude → README table)

Form matches K2 README. One line per class:

| File / class | Tool / terms |
| --- | --- |
| `body_muscle_map_front.png` | Cursor GenerateImage (Maria, 2026-09-06) + Pillow resize. Operator-owned; may ship. Cage Desk diagram. |
| `body_region_*.png` | Pillow silhouette partition from the map (tight pass invited by K2). Operator-owned; may ship. |
| `belt_*.png`, `trophy_*.png`, `medal_rank.png` | Cursor GenerateImage (Maria, 2026-09-06). Generic marks — no real promotion logos. Operator-owned; may ship. |
| `glyph_*.png`, `discipline_glyphs_sheet.png` | Cursor GenerateImage (Maria, 2026-09-06) + Pillow. Flat Cage Desk glyphs for live `combat_rulesets.json` set (11). Operator-owned; may ship. |
| `plate_*.png` | Cursor GenerateImage (Maria, 2026-09-06). Graphic broadcast plates; no ripped game art. Operator-owned; may ship. |

## Drop paths for operator

1. Copy every file from this pack's `Godot/assets/ui/` into the checkout's `Godot/assets/ui/` (overwrite K2 names).
2. Copy `research/M2_CAGE_DESK_MANIFEST.md` into `research/`.
3. Copy `DesignLibrary/screens/cage_desk/cage_desk_pack_contact.png` into that folder (create if missing).
4. Claude verifies, runs technique_glyphs_test + smoke_test, commits, updates README licence table, writes HANDOFF block, pushes.

Pack file count: 32 PNGs + this manifest + 1 contact sheet.

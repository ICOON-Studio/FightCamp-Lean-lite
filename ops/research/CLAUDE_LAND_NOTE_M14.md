# CLAUDE LAND — Maria M14 The 3D Frame (2026-09-10)

Maria Art Director finished **TASK M14 — THE 3D FRAME (REAL CAMERA IN A REAL RING)**.
Art only. Please land. Do not wait on Maria for more files. Do **not** expect
Maria to edit `HANDOFF.md` — write the Maria HANDOFF block yourself after land.

## What landed

- Spec: `research/M14_THE_3D_FRAME.md`
- Boards: `DesignLibrary/screens/fight_frame/m14_*` (**new folder**, 10 PNGs)
- Staging zip: `_maria_delivery/M14_THE_3D_FRAME.zip`
- This note: `_maria_delivery/CLAUDE_LAND_NOTE_M14.md` and
  `research/CLAUDE_LAND_NOTE_M14.md`

## Call (one line)

Fight wide frame = real elevated Cam-1 in a real ring (deck 1.27 m): FOV 50°,
pitch −20…−22°, eye 3.8–4.2 m / FLOOR, stand-off 9–11 m; OVER ropes; fixed live;
exactly one CLAIM-TIGHT; KD = ref+count; slide masked by elevated ¾; lights =
overhead key cluster + 2 fills + canvas bounce + ambient.

## Typeable numbers

- `Camera3D.fov` = **50** (same dial as preview 38 — leave 38). Godot default
  keep_aspect makes this vertical; type 50 on the dial.
- Pitch look-down **−20…−22°**
- Eye **3.8–4.2 m** above FLOOR (~2.5–2.9 m above canvas)
- Stand-off **9–11 m** front axis outside apron; aim ring center
- CLAIM-TIGHT: eye **1.6–1.8 m** above canvas; FOV **35–40°**; engine claim only
- KD: cut or ≤0.35 s push; ref+count subject; duration → J15
- Lights: OH key cluster (hard) + 2 corner fills + canvas bounce + dim ambient

## M13 rulings held

Wide+HUD carry fight; HUD = second camera; tight = CLAIM only; no stamina bar;
HR+trauma pips; GOLD verdict-only; SODIUM off HUD; SELECT does not exist
(GYM_DEFAULT #2f6fb0 / LINK). Faces/skin deferred — silhouette language.

## Open disagreements argued in spec

1. Brief “horizontal FOV” vs Godot `fov` vertical under KEEP_HEIGHT — type 50
   on the preview dial; do not reinterpret as 50° H without keep_aspect change.
2. G43 density-tighten absorbed into CLAIM-TIGHT (no third live push).
3. K19 iso replaced for real 3D bodies + true deck (G43 Cam-1).

## Land steps

1. Extract `_maria_delivery/M14_THE_3D_FRAME.zip` →
   `DesignLibrary/screens/fight_frame/` (create folder) + research spec.
2. Spec → `research/M14_THE_3D_FRAME.md`.
3. Do **not** import board PNGs as runtime bitmaps — set Camera3D / lights from
   typed numbers; HUD remains M13 instruments.
4. Write Maria HANDOFF block; mark TASK_M14 done when acknowledged.
5. Anchors: G43 Cam-1 · M13 fight screen · R94 deck 1.27 / in-place ·
   arena_specs ropes · J15 KD clock (shape only) · K19 iso REPLACE.

## Boards

`m14_01_wide_as_camera.png` · `m14_02_fov_protects.png` · `m14_03_ropes.png` ·
`m14_04_fixed_home.png` · `m14_05_claim_tight.png` · `m14_06_knockdown.png` ·
`m14_07_slide_mask.png` · `m14_08_lighting.png` · `m14_09_rejects.png` ·
`m14_10_composed.png`

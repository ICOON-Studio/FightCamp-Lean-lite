# U39 DIGEST — the stage plays a beat

## Shipped
- `FightClipBinding.gd` — one const dict; only `strike_head` → `combo_jab_cross_hook.glb`
- `FightStagePlayer.gd` — bind grafts once via BoneTrackGraft; `present_beat` plays per side
- `fight_stage_playback_test.gd` — seeded bout, strike_head played, skipped>0, bones move, determinism
- Scene `FightWorldPreview.tscn` / `FightWorldStage.gd` **not touched** — test mounts via Stage helpers

## Finding (G42 / combo trap — not a failure)
`combo_jab_cross_hook.glb` is a **2.47 s jab+cross+hook combination**. A beat is
**one** scored strike. U39 plays the **whole** clip for `strike_head`, so the
stage currently shows **three punches where the engine scored one**. No slice
was authored; do not treat this as a single jab. Fix later: buy/author a single
strike clip, or play a timed slice and name which punch.

## Binding honesty
- bound: 1/10 (`strike_head`)
- missing: 9/10 — shopping list for Claude
- `reach_m`: **0.747** (R94 rear-hand forward travel), not guessed

## Gate
- own `fight_stage_playback_test`: TOTAL=25 fails=0; bones 22/22; skipped=102; strike_head played=44; deterministic=yes
- `--only world`: total=5 fails=0
- `--only fight`: total=41 fails=0

## Traps honoured
- Headless: local transforms / composed bone poses (no stale `global_*`)
- Did not invent substitute clips for unbound roles

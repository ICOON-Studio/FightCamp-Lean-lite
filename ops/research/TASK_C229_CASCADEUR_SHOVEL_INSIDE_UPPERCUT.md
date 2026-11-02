# TASK C229 - shovel hook + inside uppercut re-authored in Cascadeur, certified 4/4 (animation, Codex)
Model: gpt-6-astra, medium (operator 2026-10-01: "use astra model for 3d, luna for other things").
Owner: Codex. Worktree D:/FightCamp/wt/C229, branch codex/c229-cascadeur-hooks (from master 7847e6ae).
Operator ruling 2026-10-01, verbatim: "cascadeur for those two moves, go ahead then proceed according to roadmap".

## Why
The demo palette (D27) holds only C223-certified moves: 22 boxing strikes today. Two punches failed the roadmap's
engine route (source clip + strike_warp + pose_layer) because the defect is in the SOURCE motion:
- `boxing_shovel_hook` (RamsterZ H2H_HookPunch_InPlace + layer): the LEAD KNEE drives toward the centre line - G147 LEG
  2.7-5.8 cm thigh-into-thigh even with the S130 off-line fixture (S130_DIGEST s2; S129 foot_lock Left did not cure it).
- `boxing_inside_uppercut` (Mixamo Boxing_Lead_Hand_Uppercut + compact layer): HELD since S126 - the REAR ARM is flung
  behind the hip and the back turns away (side 0.367 s); rear glove rides to the temple mid-punch (S121 note). C223 rows:
  join_discontinuity, onset_to_impact_band, skin_floor_cm.
Fix them where a human animator would: in Cascadeur, on the source motion.

## Prior research (read first)
- `Tools/cascadeur/README.md` (the channel: script server 127.0.0.1:8765 is UP - `python Tools/cascadeur/csend.py -c
  "print(app.current_scene().name())"` must print a scene name; if not, `python Tools/cascadeur/ensure_server.py`).
- Your own C173/C174: `research/C173_DIGEST.md`, `C174_DIGEST.md`, `Tools/cascadeur/build_switch_step.py`,
  `author_switch_step.py`, `Tools/cascadeur/apply_clip.py` - the authoring -> export -> game route you already proved.
- `research/S31_THE_AUTHORED_CLINCH.md` (Cascadeur export into the game), traps in
  `C:/Users/user/.claude/...` are summarised here: relocate a character by its CONTROLLERS only; never write a joint the rig
  solves; never `dsm.close_scene()` a non-current tab (crashes the app).
- `research/C223_DIGEST.md` (gate rows), `S130_DIGEST.md` s2, `S126_DIGEST.md` (inside uppercut), `S121_DIGEST.md`.
- `Godot/scripts/FightClipBinding.gd`: `boxing_shovel_hook` (~line 1114) and `boxing_inside_uppercut` (~line 75) entries.

## What would a human do?
Load the existing source take, keep its timing and fist path, and re-key only what is wrong:
- shovel hook: lead knee stays over the lead foot and OUTSIDE the centre line (pivot on the ball, knee turns with the hip,
  not forward); the punch rises from a dropped lead shoulder, elbow near the hip, fist to the lower ribs/liver line.
- inside uppercut: short, rear glove stays at the chin the whole time, trunk turns <= ~30 deg, no back to the opponent,
  rear elbow never behind the hip line.
Then check it on the rig the game uses and certify. Do not invent a new move; keep the boxing read.

## Prefab check
Sources already owned (no purchases): RamsterZ H2H set (`Godot/assets/anim/audition/ramsterz_h2h/`), Mixamo pipeline A
(`Godot/assets/anim/c223/mixamo_pipeline_a/`), Meshy library clips on our MPFB man (`D:/FightCamp/sources/meshy/` -
hooks/uppercuts), Seedance reference videos (`D:/FightCamp/sources/higgsfield_video/` - shovel, inside uppercut). Pick
the best start take per move, say why in the digest.

## Owned files
- NEW `Tools/cascadeur/c229_<move>/` (scripts, .casc, exported .fbx/.glb, sheets) and `Tools/cascadeur/build_c229_*.py`.
- NEW clip files under `Godot/assets/anim/c223/cascadeur_c229/` (keep each < 2 MB).
- `Godot/scripts/FightClipBinding.gd`: ONLY the `boxing_shovel_hook` and `boxing_inside_uppercut` entries (path, reference,
  warp, layers). Nothing else in that file.
- `Godot/assets/data/certified_moves.json`: add the move(s) that pass + their certificate file; nothing else.
- `Godot/assets/asset_manifest.json`: claim the new folder (status approved, licence = authored in Cascadeur Pro, Monthly Pro
  active to 2026-10-27, commercial use + export flags in the app log) - `tests/asset_manifest_test.gd` fails otherwise.
- `Godot/tools/c223_production_gate.gd`: only if a TAKES key must be added for the new source.
- NEW certificates `previews/c223/c229_*.json`, stills/mp4 `previews/c229/`, digest
  `research/C229_DIGEST.md`.
- NOT yours: FightRealtime.gd, FightStagePlayer.gd, FightWorldLiveScreen.gd, ArenaRig.gd, any other binding.

## Work loop (one move at a time; commit + push after EACH move; never stop at "written")
1. Baseline: run the gate on the CURRENT binding so the digest has the before row:
   `python Tools/c223_parallel.py production --jobs 2 -- plant phase live_contact bound clips=<gate id> report=c229_<move>_before.json`
   Gate ids are the TAKES keys in `Godot/tools/c223_production_gate.gd` (grep it; a wrong id silently runs only
   reference_jab - check the report's clip column).
2. Author in Cascadeur through csend.py scripts (reproducible from repo root, like build_switch_step.py). Export.
3. Bind (new path/reference; keep hold_root_xz, plant_skin_floor, phase_matched_guard; strike_warp so the fist peak is
   mid-band). Parse gate, then gate again -> `c229_<move>.json`. PASS = all 4 legal generated rigs: mechanical_failures [],
   g147_pass true, fist peak in band, onset in band, 0 pin pops.
4. Stills + a silent mp4 of the certified take (C223 fixture, welter_a v welter_b) -> `docs/previews/c229/`. Open them:
   knee outside the line (shovel), rear glove at the chin and no turned back (inside uppercut). A gate pass with a wrong
   look is NOT done.
5. Certify: add to certified_moves.json `boxing.strikes` + certificate; run
   `python Godot/tools/run_tests.py --jobs 2 --only certified_palette,clip_binding,asset_manifest`.
6. A move that will not pass: keep the binding as it was, record the numbers and the stills, move on. Never loosen a gate.

## Tests
Parse gate before any test: `python Godot/tools/check_scripts.py <touched .gd>`. Watchdog before every heavy run:
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` (RED = wait). Windowed Godot only via
`Tools\godot_hidden.ps1`; never kill Godot or Cascadeur by image name. `run_tests.py` always `--jobs 2`; wait on its exit.

## The one trap
Cascadeur's `--run-python-code` and some csend paths swallow tracebacks - write errors to a file and read it; and a clip
exported on the Cascy rig must go through the same retarget the game uses (`retarget: true` + its `reference` rest file),
so export the rest pose beside every clip, as C173 did.

## Finish
`git add` by explicit path, commit, `git push -u origin codex/c229-cascadeur-hooks`. C229_DIGEST.md: per move before/after
gate rows, the source take chosen, stills, what failed.

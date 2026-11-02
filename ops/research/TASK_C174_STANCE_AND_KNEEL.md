# TASK_C174 — THE SWITCH FROM A REAL FIGHTING STANCE, AND A CLOSED GUARD THAT KNEELS

**Owner: codex. Model: `gpt-6-astra`, medium.** Assigned S59, 2026-09-23, operator go ("yes").
Follows C173, whose MECHANICS were verified on Claude's checkout and stand. This task fixes what the renders show.

## Owned files

- `Tools/cascadeur/` (your C173 build scripts; new dirs `c174_*`).
- `Godot/assets/anim/audition/cascadeur/Cascy_Switch_*.glb`, `Cascy_StepThrough_O2S*.glb`, `Cascy_ClosedGuard_*.glb` (re-exports).
- `Godot/tools/switch_step_probe.gd` (extend only - never loosen).
- `research/C174_DIGEST.md` (new).

## 1. THE SWITCH CLIPS STAND LIKE A MAN IN A QUEUE

Claude opened `Tools/cascadeur/c173_switch/Cascy_Switch_O2S_sheet.png`: the probe passes (lead +0.281 -> -0.286 m,
mirror <= 3.42 deg, hands up) but the man is **upright, knees straight, feet close together** - a standing idle
with gloves raised, not a fighting stance. C173 based it on `idle_A`.

**Re-base all three clips on the game's OWN live stance:** `res://assets/anim/audition/ramsterz_h2h/H2H_Idle.FBX`
- the clip `FightClipBinding.gd:193` binds as `"idle"`, the pose the 3D room actually plays. Start pose = a frame of
that idle; end pose = its exact mirror (as in C173). Then the switch blends in and out of the real stance with no snap.

**Extend the probe - add, never loosen:**
- knee flexion at start and end >= 15 deg on both legs (the stance is bent-kneed);
- stance width (lateral foot separation) >= 0.30 m and lead-rear separation >= 0.35 m at start and end;
- **start pose within 5 deg per bone of the H2H_Idle frame you chose** (proves it is the game's stance, not a lookalike).
Prove the new checks with a mutant each (feed the old C173 upright clip: it must now go RED).

## 2. THE KNEELING CLOSED GUARD DOES NOT YET KNEEL

`e5d9c032` holds the ankle lock (28.08%) but in `Tools/cascadeur/c173_kneeling_guard/comparison.png` the AFTER side
view still reads as a man lying on his opponent. **The target is now a checked image:**
`research/_captures/ground_video/closed_guard_kneeling_duo_still.png` - the same instant from two opposite side
cameras. Top man: torso UPRIGHT (spine within ~35 deg of vertical), BOTH knees on the canvas under his hips, gloves on
the bottom man's stomach. Bottom man: legs around the waist, ankles crossed behind the top man's back.

Add to the contact probe (or a sibling check) **the top man's spine angle from vertical** and **his hips above his
knees** - so "kneeling" is a number, not a picture. A two-camera video of this position is being generated and will
land in the same folder; use it if it is there.

## GATE - ceilings, over-delivery welcome

- Switch: extended `switch_step_probe.gd` RESULT failures=0 on all three clips, both mutants red.
- Closed guard: every declared contact <= 30%, spine-from-vertical <= 35 deg, hips above knees; hard controls
  unchanged (RamsterZ `0.302639 / 0.304671`, clinch <= 15%, side control <= 14.8173%).
- Parse gate; `--only clip` (10/0), `--only grapple` (10/0), `--only pair` (7/1, fight_pair_live PARKED). NEVER the
  full suite.
- **Put your render NEXT TO the target image** in the digest for each: the switch sheet beside a frame of H2H_Idle,
  the guard sheet beside `closed_guard_kneeling_duo_still.png`. Say in one sentence whether they match.

One clip, one commit, push master, one `agent_comms.py send --from codex --to claude --subject C174` line per item.
Do not fetch or rebase. Do not edit HANDOFF.md, FightRealtime.gd, FightStance.gd or the catalogue.

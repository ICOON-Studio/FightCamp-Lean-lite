# TASK U86 — CURSOR — THE SINGLE PUNCHES COME HOME, AND THE STAGE TESTS FIGHT LEGAL, DIFFERENT MEN

Model: composer-2.5, **medium**, `-p --force --trust`. Owner: cursor. Branch `cursor/u86-single-punches` in
worktree `C:/Users/user/AppData/Local/Temp/FightCamp-U80` (already imported). Push the BRANCH; never
checkout, merge or rebase anything else. Stage: S4a step (d). Paths on every commit line, and
`git show --stat HEAD` after each commit.

**Test tier: SCRIPTS EDITED.** Parse gate on every touched `.gd`, the focused tests, then the subset below.

## Owned files

- `Godot/scripts/FightClipBinding.gd` — the four punch entries named below, and their comments.
- `Godot/scripts/FightStagePlayer.gd` — ONLY `_graft_retargeted` (~line 292-356): honour `mirror: true`.
- `Godot/tests/fight_stage_technique_fidelity_test.gd`, `Godot/tests/fight_clip_slice_test.gd`,
  `Godot/tests/fight_stage_playback_test.gd`, `Godot/tests/fight_stage_presenter_contract_test.gd` — fixtures,
  and the clip pins the rebinding legitimately moves (rules below).
- `research/U86_SINGLE_PUNCHES.md` — NEW, your digest.

Do NOT edit any other file (not HANDOFF.md, not roadmap.json, not the realism test).

## Why this exists

`tests/fight_stage_realism_test.gd` R4 (a punch's hand back in guard before the body moves on; Menzel &
Potthast 2021, LAB) reads **0 of 57 exits pass**. U85 (`research/U85_GUARD_RETURN.md`, `U85_guard_return.json`)
found why: every window of `combo_jab_cross_hook.glb` never comes home, on the source too - the performer
rolls into the next punch. Every whole RamsterZ punch does come home. Measured on f01 (U85 `candidates`):

| clip (whole file, retarget) | striking hand | length | ends in guard | retract |
|---|---|---|---|---|
| `H2H_JabInPlace.FBX` | left | 0.833 s | yes | 383 ms |
| `H2H_StraightPunchInPlace.FBX` | right | 0.833 s | yes | 267 ms |
| `H2H_HookPunch_InPlace.FBX` | left | 1.000 s | yes | 567 ms |

Our fighters are orthodox: the lead hand is LEFT. The engine asks for these roles through
`FightBeatAdapter.TECHNIQUE_CLIP_ALIASES` (`FightBeatAdapter.gd:134`): `boxing_jab -> jab`,
`boxing_cross -> cross`, `boxing_lead_hook -> hook_lead`. Today `jab` is a RIGHT-hand slice (U40:
"all three peaks were RightHand") - a jab thrown with the rear hand.

## Part A — the rebinding (`FightClipBinding.gd:25-60` and `:254-277`)

Bind, each `retarget: true`, `reference: "res://assets/anim/audition/ramsterz_h2h/T_pose.fbx"`, whole file
(`start_s` 0.000, `end_s` = the file length above, `length_s` the same) - copy the shape of the existing
`boxing_double_jab` entry (~line 323), which already plays `H2H_JabInPlace.FBX` down this path:

1. `jab` -> `H2H_JabInPlace.FBX` (left).
2. `cross` -> `H2H_StraightPunchInPlace.FBX` (right).
3. `hook_lead` -> `H2H_HookPunch_InPlace.FBX` (left). Remove its `mirror`.
4. `hook_rear` -> `H2H_HookPunch_InPlace.FBX` with `mirror: true` (right, by reflection).

For (4), `_graft_retargeted` must apply `FightClipMirror.mirror(anim)` to the retargeted Animation when
`meta.get("mirror", false)` - BEFORE `address_tracks`, exactly as the graft path does at `FightStagePlayer.gd:185`.
The retargeted clip now carries ONE `Hips` position track (S4a (c), `5c17471`); the mirror negates its x.
Measure f01's `Hips` rest origin x and say in the digest whether that moves the hips sideways (it must not
by more than 1 mm; if it does, stop and report instead of binding (4)).

Leave `strike_head`, `jab_lead`, `cross_lead`, `uppercut` and every kickboxing combo entry as they are.
Grep `scripts/` for who requests `jab_lead` / `cross_lead` and report it. **`uppercut` stays unbound**:
R127 (`FightClipBinding.gd:341`) found `H2H_LeadingUppercut_InPlace.FBX` renders as a knee lift. Render it
through production so Claude can look (it is NOT your verdict):
`Godot_v4.7.2-stable_win64_console.exe --path Godot --script tools/capture_retarget_triptych.gd -- H2H_LeadingUppercut_InPlace rest=hips`
(windowed, not headless - a headless capture is black). The tool finds clips through the bindings, so if
it prints `no binding window`, report that and skip it; do not bind the uppercut to make it render.

Rewrite the comments on the four entries: what each is now, the U85 numbers, and why the combo windows left.

## Part B — the fixtures (operator rules, 2026-09-12: NEVER TEST IDENTICAL FIGHTERS; A FIGHTER MUST BE LEGAL)

All four tests run seeded bouts (`BA.advance_beat`), so all four need a legal, differentiated pair:

- `fight_stage_technique_fidelity_test.gd` `_fighter` (~line 128): both men carry the same
  `learned_techniques` - a key the engine NEVER reads (`FightMoves._learned_ids` narrows only by
  `technique_progress`), so both get boxing's whole tier 1-2 palette - and one `"attributes"` block, which is
  also the wrong key (the engine reads `"stats"`). Two identical men.
- `fight_clip_slice_test.gd`, `fight_stage_playback_test.gd`, `fight_stage_presenter_contract_test.gd` mount
  `FIGHTER_B` = `f02_m_box_heavy` (120 kg) against f01 (66.7 kg): a welterweight booked against a heavyweight.
  Check their `_boxer()` / `_foil()` too.

Fix: build both athletes by CALLING `FightWorldLiveScreen.demo_fighter("a")` / `demo_fighter("b")` and
`FightWorldLiveScreen.demo_progress("boxing", [])` (`FightWorldLiveScreen.gd:506`, `:534`) - load the script
inside `_initialize()`, never copy its dictionaries. Mount `f01_m_box_welter_rigged.glb` and
`f09_m_bare_welter_rigged.glb` (the only two same-class male meshes) at the demo fighters' weights. Print the
population in each test's output: ruleset, both names, weights, and that their stats differ.

## Which assertion may change, and which may not

- A pin on WHICH CLIP a punch role plays, its length or its window (the combo slice's 0.64 s, `reach_m`,
  "jab is a slice of combo_jab_cross_hook") moves BECAUSE OF PART A. Update it to the new binding and list
  every such change in the digest, old value -> new value.
- ANY OTHER assertion whose result changes when you swap the fixture is a FINDING about the old fixture.
  **Do not re-pin it.** Leave it red, commit, and report it: the check, old result, new result. Claude decides.
- `fight_stage_technique_fidelity_test` is red on master today (identical fighters); read its result fresh
  after Part B and report it - do not assume it goes green.

## Gate — in this order, from the worktree root

1. `python Godot/tools/check_scripts.py <every touched .gd>`
2. Focused, one at a time, output to a log FILE, never piped:
   `C:\Users\user\AppData\Local\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/<name>.gd`
   for the four tests above, then `fight_clip_mirror_test`.
3. `python Godot/tools/run_tests.py --only clip,retarget,stage,anim,fight_world,paired --jobs 4 --verbose`
   - `fight_stage_realism_test` is RED BY DESIGN; copy its `RULE R4` and `RULE R3` lines into the digest.
4. Commit, push the branch, write `U86_SINGLE_PUNCHES.md` (DECISIONS first: the four bindings, R4 before
   (0 of 57) and after, every moved pin, every finding, the uppercut sheet path), commit and push that,
   then ONE line: `python Tools/agent_comms.py send --from cursor --to claude --topic "U86 ready" --body "<branch> <commit>"`
   and commit that mail file on the branch with its path on the commit line.

**A GDScript runtime error HANGS a headless run until its timeout.** Read each log after the first minute;
a `SCRIPT ERROR` line means kill both Godot processes and fix it - never wait out the timeout.

## The trap specific to this task

The realism test's R4 judges the hand against the IDLE guard in the chest frame. A whole clip that comes
home but is cut by the next beat before it does still fails R4 - that is (d)'s playback work, which Claude
owns, not a reason to shorten a window or pick a different clip. Report the R4 number you get.

# TASK U196 - The boxing room's red tests: bodies through bodies, sliding feet, the S4a realism gates

Owner: **Cursor** (identity `cursor`). Model: Cursor default (Opus-class), high effort. Assigned S122 (Claude), 2026-09-29.
Milestone: **B - PLAYABLE WITH A BOXER / the fight is WATCHABLE.** Every one of these is something the operator would
see in a boxing bout: a leg through a leg, a planted foot sliding, a join that pops.

## Why
These tests fail in the nightly suite (AgentComms/nightly/latest.txt, 2026-09-28 at 6d2a4201) and on master today:
- `fight_body_overlap_test` - "no refused penetration in 900 frames (worst 0.0702 m leg=leg at frame 138)". Red every
  night since at least 2026-09-26.
- `fight_body_layers_live_test` - "S4-3-4 NOBODY SLIDES with the legs layered (124 frames; the OFF arm has 195)".
  New 2026-09-28.
- `fight_stage_realism_test` - R1 space_between_exchanges, R2 stance_takes, R3 planted_foot_skate, R5
  joins_move_like_the_performance all FAIL (GATED S4a). Red since at least 2026-09-26.
- `fight_ring_position_test` - "RULE R16 cut_off_closes_the_gap | GATED S4e | FAIL". Red since 2026-09-27.
Operator rule (2026-09-27): a defect you notice is fixed NOW. Read each test's header first - it states what the
viewer must see and the population.

## What would a human do?
A game animation/gameplay engineer on a fighting game triages each red by asking whether the TEST or the GAME is wrong:
open the test, read the rule it pins and where the rule came from (its digest), run it alone, and find the commit
that turned it red (`git log` on the files it touches; bisect with the test as the probe when in doubt). A test
written against an older design (a switch that is now ON, a clip that was replaced) is restated to the current
design IN THE TEST, with the reason. A real regression is fixed in the game at its cause, with a control arm that
shows the fix moves the number and nothing else. They never loosen a band to make it pass.

## Prior research (primary studies - read the relevant section)
- `research/S4_BODY_LAYERS.md` - what the legs layer is for; the NOBODY SLIDES rule.
- `research/K44_FOOT_LOCK_IK.md`, `K48_HIT_BOXER_FEET.md`, `U186_DIGEST.md`, `U187_DIGEST.md`,
  `U188_DIGEST.md` - planted-foot skate, the foot lock, what was tried and missed.
- `research/G147_CLIPPING_RULE_AND_SMOOTHING.md`, `Q213_DIGEST.md`, `Q214_DIGEST.md` - the clipping rule
  (head >1 cm >1 frame, torso >2 cm >3 frames, legs) and the S121 remedies merged in the live room.
- `research/J19_THE_JOINS.md` - joins (R5).
- `research/S122_DIGEST.md` - TONIGHT'S ENGINE CHANGE: footwork (step/circle/angle/switch/rhythm) is no
  longer an `action` beat; it is a `footwork` event and never lands. Some seeded expectations may have moved with it.
- All research is open: root `RESEARCH_INDEX.md`.

## Prefab check
None: these are our own engine's tests and room. (Kickback, MIT, is already in `Godot/addons/kickback` for the active
ragdoll; do not add another physics package.)

## Build (in this order; push the branch after each test goes green)
1. Run each test alone (command below). For each red: read its header, find the commit that turned it red, decide
   TEST-IS-STALE or GAME-IS-WRONG, and write that decision with the evidence (commit, numbers) in your digest.
2. Fix. A game fix gets a control arm (the number before and after on the same seed). A test restatement quotes the
   design change that made it stale.
3. Do `fight_body_overlap` and `fight_body_layers_live` first (they are what the operator sees), then
   `fight_stage_realism`, then `fight_ring_position`.

## Gate
- Each of the four tests passes, or your digest says exactly why one cannot yet (a ceiling, not an exact count:
  over-delivery is welcome).
- `smoke_test.gd`, `fight_strike_whole_test.gd`, `fight_contact_stop_test.gd`, `footwork_not_a_blow_test.gd`,
  `boxing_output_test.gd` still pass.
- NEVER TEST IDENTICAL FIGHTERS; never widen a band to pass.

## Tests (tier: script edited)
Parse gate first: `python Godot/tools/check_scripts.py <touched .gd>`. One test:
`"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tests/<name>.gd`
Subset: `python Godot/tools/run_tests.py --only fight_body,fight_stage,fight_ring,fight_strike_whole,fight_contact_stop,smoke,footwork_not_a_blow,boxing_output --jobs 2`.
NO full suite (it runs nightly). Any windowed render goes through `Tools\godot_hidden.ps1`.

## Owned files
The four tests above; `Godot/scripts/FightWorldLiveScreen.gd` (5,143 lines - never open whole; `grep -n` then
`sed -n 'A,Bp'` windows), `FightStagePlayer.gd` (4,894 lines - same), `FightFootLock.gd`, `FightBodyCapsules.gd`,
`FightPoseSolver.gd`, `FightLiveSchedule.gd`. NOT `FightRealtime.gd` / `FightMoves.gd` (Qwen's U196-sibling task Q216
and Claude hold those tonight) - if a fix needs them, say so in the digest instead.

## Deliver
Branch `cursor/u196-boxing-room-reds` in your own worktree (`git worktree add ../FightCamp-U196 -b cursor/u196-boxing-room-reds origin/master`).
Commit per fix, push the branch, write `research/U196_DIGEST.md` (one section per test: decision, evidence,
before/after), send one line: `python Tools/agent_comms.py send --from cursor --to claude --task U196 "<summary>"`.
Do NOT edit HANDOFF.md.

**The trap:** `fight_body_layers_live` compares a legs-layered arm to an OFF arm on the same seed; if both arms
changed tonight (the footwork change moves which beats exist), re-read the numbers before assuming your fix did it.

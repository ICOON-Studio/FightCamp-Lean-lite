# TASK HUMAN2 - feet that step like a boxer: no hops, no skating, push-pull steps (Ludo step 2)

Model: Codex gpt-6.1-sol (CODEX_MODEL=gpt-6.1-sol - animation). Worktree E:/FightCamp/wt/HUMAN2, branch codex/human2 from master. Push
the branch; never master, never HANDOFF.md, never AgentComms/. Never open a window, viewer, video player or browser; windowed Godot
ONLY via `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>`; frames with your file tool. Headless:
`Godot_v4.7.2-stable_win64.exe` (NEVER `_console.exe`). `timeout` on every Godot run (300 s headless, 1300 s windowed).
`run_tests.py` always `--jobs 2`. Before any windowed/benchmark run: `powershell -NoProfile -ExecutionPolicy Bypass -File
Tools\pc_watchdog.ps1 -Once` - exit 1 (RED) = wait 5 min and re-check, never start on RED.

Operator S192: "ask ludo what is missing to make the animations like humanlike and do whatever it says". HUMAN1 (heads) is merged
(eac0a743); this is the next step of the same checklist.

## Owned files
- `Godot/tools/record_room.gd` bench columns ONLY: `red_/blue_lead_foot_locked`, `red_/blue_rear_foot_locked` are PLACEHOLDERS today
  (BENCH1_BASELINE.md: "Step 2's hop count is from placeholder unlocked feet"). Fill them from the real per-foot lock state.
- `Godot/scripts/FightStagePlayer.gd` (6,166 lines - windows only; grep `_foot_lock`, `_rest_foot_lock`, `_resolve_legs`,
  `foot_lock`, `shuffle`, `step_`) - the locomotion path.
- `Godot/scripts/FightFootwork.gd` (210), `Godot/scripts/FightFootLock.gd` (80, pure - extend only, keep its blind-tested contract),
  `Godot/scripts/FightClipFootPlant.gd` (302) - read first; edit only if the fix lives there.
- `Godot/tests/human2_test.gd` (NEW), `research/BENCH1_BASELINE.md` (append "## After HUMAN2").

## Prior research
- Spec + thresholds: `research/LUDO_ANIMATION_R12_S192.md` "Step 2" (lines ~31-45) and the 12.5-16.5 s benchmark beat;
  `LUDO_ANIMATION_R13_S193.md` "Claude's verdict (round 13)" - correction (b): NO AnimationTree/BlendSpace2D conversion; foot-lock
  phases come from FightStagePlayer's own clip time; the lead-first / rear-first push-pull rule is kept. Correction (a): our switch,
  default OFF.
- `LUDO_ANIMATION_S192.md` "Foot Sliding (Skating) Under External Translation" - the 3 cm/frame procedural shuffle under fixed clip feet.
- `research/topics/footwork.md` (canonical page). The FOOTLOCK queue item: U211 (S144/S146) cut slide 30% but was REFUSED -
  `U211_C223_VERDICT.md`: 32/32 certified pairs regressed because the planner moved root/feet inside certified contact windows.
- Existing machinery to REUSE: FightFootLock (UE 5.8 foot-placement rules), FightLegIK, FightClipFootPlant, FightFootContacts.
- BENCH1 baseline after HUMAN1: `STEP 2 FAIL measured=hop=247,min_width_m=0.461419` (hops from placeholder flags).

## What would a human do?
A boxer never hops with both feet off the canvas to move. Going forward, the lead foot steps and the rear foot pushes then follows;
going back, the rear foot steps first. Each foot is planted (does not slide) while it carries weight; the stance never narrows to a
cross-legged line. A pivot turns on the ball of the lead foot.

## Spec
1. Switch `human_footwork` (room option, default OFF; NOT in DEMO_SWITCHES), same pattern as `human_hit_additive`.
2. Instrument FIRST: real lock flags in the bench CSV (per foot, 1 = planted). Re-grade the baseline with the switch OFF and paste the
   honest STEP 2 number before changing any motion - the 247 hops may be partly the placeholder.
3. With the switch ON: locomotion > 0.2 m/s never has both feet unlocked at once; forward = lead lifts first, back = rear lifts first;
   stride ~48 cm; stance width floor 32 cm (FAIL below 28); a planted foot's world position moves < 1.5 cm while locked; pivot on the
   lead ball.
4. Guardrails: fighter-to-opponent distance tracks the sim's intent within +-6 cm every frame; NEVER move root or feet inside a C223
   certified contact window (the U211 trap); OFF -> bench CSV pose columns equal master's within 1e-6.

## Done (tier: script edited - parse, focused test, related runs)
- Parse gate on every touched .gd (`python Godot/tools/check_scripts.py <files>`).
- `human2_test.gd` (headless, two DIFFERENT boxers - name them; never identical fighters): forward 3 steps -> lead foot unlocks before
  rear in every step; back 3 steps -> rear first; 0 double-unlocked frames at > 0.2 m/s; min stance width >= 0.30 m; locked-foot drift
  < 1.5 cm; distance error <= 6 cm; OFF -> pose identical to master. RED first on master (paste the count). Prove it can fail: one
  mutant (e.g. drop the push-pull order) must turn it red.
- `python Godot/tools/run_tests.py --only fight_stage --jobs 2`, `--only bench1 --jobs 2`, `--only anim_smooth --jobs 2`,
  `--only foot --jobs 2` -> 0 fails.
- C223 production gate with the switch ON: `python Tools/c223_parallel.py production -- <the gate args in BENCH1/C223 docs>
  report=E:/FightCamp/tmp/human2_c223.json` - no certified pair may regress vs master (paste both summaries).
- Re-run the benchmark (BENCH1_BASELINE.md "Reproduce", plus `human_hit_additive human_flinch human_footwork` on); append STEP lines
  under "## After HUMAN2": STEP 2 must PASS; no other STEP may get worse.
- Two stills from the game camera through `still_framing.gd` `save_if_framed` to `previews/human2/`: mid forward step
  (lead foot in the air, rear planted) and the 12.5-16.5 s pivot. Both men head to feet in frame. Open both; describe them.
Commit + push codex/human2. Final message: red count, mutant result, green results, C223 before/after, STEP lines, the two stills.

## The one trap
Locking a foot while the root keeps translating stretches the leg (the IK pops) - the root's step must be phased to the clip's foot
contacts (stride-matched), not the lock added on top of the old shuffle. And no lock inside a certified contact window.

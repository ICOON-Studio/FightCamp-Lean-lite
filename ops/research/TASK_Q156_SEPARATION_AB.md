# TASK_Q156 - did the S62 separation floor move the realism anchors? A/B over 40 bouts (Codex)

Model: gpt-5.6-luna, medium (Codex; not 3D animation design). Owner: codex. Assigned S62, 2026-09-24 - moved from Qwen when the operator gave Qwen the clip-coverage task Q157.

## Why
S62 put a minimum hips-to-hips distance in the ENGINE (`FightRealtime._run_separation`, behind
the `begin()` option `separation_floor`, default ON; OFF is byte-identical to the tree before the
stage). Its own test ran ONE seed per ruleset and printed landed 29 -> 34 (boxing) and 56 -> 68
(MMA) ON vs OFF. One seed is an anecdote. The stage's FALLBACK trigger is written as: "if the
floor moves the realism anchors (landed rates, knockdown 3.9%, J20 leg share) outside their
bands, apply it to the ROOM instead". Nobody has measured that across seeds. You measure it.

## Owned files
`Godot/tools/q156_separation_ab.gd` (new), `research/Q156_DIGEST.md` (new). Nothing else.
Do NOT edit any script. Do NOT edit HANDOFF.md.

## Do
1. A headless `extends SceneTree` tool. Fixture: the two men from
   `Godot/tests/fight_separation_test.gd` (`_boxer()` reach 183 / `_wrestler()` reach 176, copy
   the two dictionaries verbatim - they differ in stats, reach and plan, as the identical-fighters
   rule requires; NAME them in every output line). Rulesets `boxing` and `mma` loaded from
   `res://assets/data/combat_rulesets.json` the way that test's `_ruleset()` does.
2. Seeds 94301, 810039, 93002, 51227, 77003 and 15 more you print (any fixed list), 3 rounds
   each, via `FightRealtime.begin(a, b, {"seed": s, "rounds": 3, "ruleset": r,
   "separation_floor": on})` and `FightRealtime.run_to_completion(state)`, for THREE arms: OFF
   (`separation_floor` false), ON (true, the shipped default), and ON+STRIP (true plus
   `separation_strip_velocity` true - the arm S62 measured as raising volume ~20% on one seed
   and defaulted OFF). Read `state["log"]` events: type `"action"` with `contact` in
   ["clean", "glancing", "absorbed"] is a LANDED strike; its `region` in ["left_leg",
   "right_leg"] is a LEG strike; type `"knockdown"` is a knockdown. Also read
   `state["separation_pushes"]`, `state["separation_push_max_m"]`, `state["clinches"]`, and
   the phase ledger `state["phase_ticks"]` (engage/reset/measure tick counts).
3. Print, per ruleset, the three arms side by side, pooled over the 20 seeds: landed per round
   (mean), landed share of thrown (thrown = all `"action"` events), leg share of landed
   (MMA only is the anchor; print boxing too), knockdowns per 100 landed, clinches per round,
   engage-tick share, pushes per round, push_max. Then the DELTA as a percentage of OFF.
   Population line first, as `fight_separation_test.gd` prints it.
4. Verdict line: `Q156 VERDICT <ruleset> anchors=HELD|MOVED` where MOVED means the MMA landed
   leg share left 8-16% (fight_realtime_test's band, currently regressing at its measured 8%
   baseline), OR landed per round changed by more than 15% of OFF, OR knockdowns per 100 landed
   changed by more than 30% of OFF. Print the numbers beside the verdict, never the verdict alone.
5. Digest: the table verbatim, the verdict, and ONE paragraph on which phase the pushes happen
   in (engage-tick share ON vs OFF says whether the floor is holding men out of exchanges).

## Gate
Tier: new tool file only, no script edited. `python Godot/tools/check_scripts.py
Godot/tools/q156_separation_ab.gd`, then run it once:
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/q156_separation_ab.gd`
(40 three-round bouts; budget ~5 min). No suite, no other test. Branch
`codex/q156-separation-ab`, one
`python Tools/agent_comms.py send --from codex --to claude --topic Q156 --body "<verdict per ruleset with the three numbers>"`.
Trap: `var x := state.get(...)` fails on a Variant - write the type (`var n: int = ...`).
Trap: this checkout is a WORKTREE; branch off `origin/master` first (`git fetch origin &&
git checkout -B codex/q156-separation-ab origin/master`).

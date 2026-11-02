# C177 - sided reactions

Status: final stance handoff implemented under the lead's explicit approval (2026-09-23). Live side selection is verified; stock-clip contact choreography remains a visual limitation.

## Decisions and scope

Existing uncommitted chooser, test and measuring tool retained and extended. All existing readable_s, start_s and end_s are unchanged. No blend constant, inertialization or queue behavior was edited. HANDOFF.md untouched.

FightStagePlayer functions touched: `play_role`, `_graft_retargeted`, `_present`. The graft builds each mirrored reaction once, caches it under FightClipMirror.mirrored_name(), and the normal player selects that animation. FightBeatAdapter: `_present` only. FightClipBinding: react_head/body/leg metadata only. The operator's explicit player permission supersedes the original task's owned-file list.

## Library measurement

f01 boxing rig; production silhouette corrections, 30 Hz retarget, existing windows and sway policy. Axes: +X right, -Z back, +Y up. Values below are displacement from the first pose to the EXISTING readable frame, metres. dir names the dominant axis; signed up_m prevents a downward bend being selected as an upward match.

| Take | Lateral right | Back | Up | Dominant axis |
|---|---:|---:|---:|---|
| HitReaction01 | -0.023794 | 0.324826 | -0.076079 | back |
| HitReaction02 | -0.011709 | 0.333667 | -0.080565 | back |
| HitReaction03 | 0.014163 | -0.102193 | -0.009298 | back (forward signed) |
| HitReaction04 | 0.097775 | -0.022428 | -0.164720 | vertical, downward |
| StaggerSmall01 | -0.011006 | 0.102682 | -0.062691 | back |
| StaggerSmall02 | 0.033494 | -0.000788 | 0.033358 | right |
| StaggerSmall03 | -0.028141 | 0.153298 | -0.149050 | back |
| StaggerMedium01 | 0.000368 | -0.011690 | 0.011728 | up |
| StaggerMedium02 | 0.121549 | -0.024816 | -0.084332 | right |
| StaggerMedium03 | 0.129854 | -0.003375 | -0.075244 | right |
| StaggerMedium04 | -0.001004 | -0.016224 | -0.029473 | vertical, downward |
| StaggerLarge04_LowHit (Chest) | -0.125562 | -0.162496 | -0.662066 | vertical, downward |

No head take is lateral-dominant at its existing readable frame. The largest lateral component over the unchanged head windows belongs to **H2H_HitReaction04.FBX**: **0.200057 m sideways**, **0.099108 m backward**, **0.132501 m downward**, at new lateral_s **0.333333 s**. Lateral:back magnitude ratio **2.018574:1**. Lateral is **77.06% of the net 3D displacement magnitude at that frame**, not a claim about integrated path length. The production player independently gives +0.200057 m versus -0.199450 m mirrored (0.30% magnitude difference).

At unchanged readable_s=0.20, this same take gives 0.097775 m lateral, 0.022428 m FORWARD, and 0.164720 m DOWN: lateral:back magnitude 4.359:1, lateral/net displacement 50.70%. It is a downward bend with a useful sideways component at this frame, not a pure head snap. Neither measurement is below the operator's 25% threshold, so the requested categorical absence statement is not supported by this run. An authored Cascadeur sideways head snap would still improve the visible quality; it is not manufactured by these tags.

Hooks/overhands choose the strongest lateral component when no lateral-dominant take matches, mirrored to the requested receiver displacement. Orthodox lead hits the receiver's right cheek and pushes left; rear reverses it; southpaw reverses both. Straights choose back; uppercuts choose positive up when available; unknown geometry/missing directions preserve the original region pool and round-robin. Direction is displacement, not cheek struck.

## Final stance handoff

The lead approved the expanded seam explicitly, superseding the original task's function window. `FightBeatAdapter.advance_beat` reads the chosen actor's `stance` from the existing fight dictionary and passes it to `_present`; `_present` hands it to the reaction chooser. No engine edit or RNG draw is needed. Optional direct-call `actor_stance` metadata remains supported; missing stance or hand preserves region fallback.

Every function touched in this final step:
- `FightBeatAdapter.advance_beat`, `FightBeatAdapter._present`.
- `fight_reaction_side_test._run`, `fight_reaction_side_test.check_live_stance` (new), `fight_reaction_side_test.capture`.

Four live boxing bouts (seeds 17701..17704) use differentiated orthodox/southpaw fighters: 183/176 cm reach and distinct power, technique, speed, defense, conditioning, fight IQ and grapple stats. The test requires both lead and rear hooks to OCCUR from both throwers, checks their receiver direction independently of the chooser table, and checks missing-hand fallback. A one-tick presentation window avoids hiding those witnesses in a long beat.

Fetch succeeded. Rebase refused the pre-existing shared `AgentComms/last_suite.json` change; HEAD and fetched origin/master were identical, so no history update was necessary. Shared changes were not stashed or committed. HANDOFF.md untouched.

## Verification

- Final parse: 2 touched GDScript files, 0 failures (earlier implementation: 6 files, 0 failures).
- Final live-stance and real-rig chooser/player test: 0 failures; both target playback sides asserted, mirror sign opposite and magnitude within 10%.
- Four temporary chooser mutants caught: invert stance (6 assertions), straight->up (3), uppercut->back (2), bypass direction matching (2). Temporary mutant scripts removed; production source never mutated. Reproduce by replacing `(stance == "southpaw")` with `(stance == "orthodox")`, straight `return "back"` with `return "up"`, uppercut `return "up"` with `return "back"`, and `if not wanted.is_empty():` with `if false:` in separate temporary copies of the chooser.
- clip: SUITE total=10 fails=0.
- react: SUITE total=1 fails=0.
- room: SUITE total=3 fails=0.
- world: SUITE total=6 fails=0.
- No full suite.

Stills recaptured through `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --windowed --script tests/fight_reaction_side_test.gd -- --stills`, then OPENED and inspected. The target is at `lateral_s=0.333333`, the thrower at the hook's contact marker. Camera sides differ to expose the receiver's head; directions below are receiver-local, not screen-left/right.

- `previews/reaction_side/orthodox_lead_hook.png`: orthodox lead arrives from the target's right; the target head moves **LEFT**, measured **-0.199450 m**.
- `previews/reaction_side/orthodox_rear_hook.png`: orthodox rear arrives from the target's left; the target head moves **RIGHT**, measured **+0.200057 m**.

Both captures show the receiver's head and the opposite lateral poses. f09 bare welter throws; f01 boxing welter receives. The stock take also bends downward, and the independently posed stock hooks are not a contact-solved pair: arm/head overlap and an open striking hand remain visible. These stills verify the selected side at the lateral frame, not convincing fist-contact choreography. No contact correction, blend change or retiming of production clips was made.

Reproduce measurements: `godot --headless --path Godot --script tools/c177_reaction_direction.gd`.
Reproduce test: `godot --headless --path Godot --script tests/fight_reaction_side_test.gd`.

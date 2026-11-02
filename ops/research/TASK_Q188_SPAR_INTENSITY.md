# TASK Q188 - QWEN - A SPARRING-INTENSITY MODE IN THE FIGHT ENGINE (S85, the engine half of step 4's gym sparring)
Owner: qwen. Assigned S85, 2026-09-26. Model: qwen3-coder, medium, `--yolo`. Branch `qwen/q188-spar-intensity`.
Worktree: `C:/Users/user/AppData/Local/Temp/FightCamp-Q164` (`git fetch origin && git checkout -B qwen/q188-spar-intensity
origin/master`).

## Why
Training floor step 4 (S86) lets the player book two gym-mates into the ring for a spar, played by OUR fight engine in
the 3D gym. Today the engine only knows how to fight a bout. It needs an agreed-intensity spar: same fighters, same
moves, same rules, but the power a coach allows - and a coach who stops the round before anyone is hurt. Claude builds
the booking, the floor and the consequences in S86; you build the engine half now so S86 can call it.

## What would a human do?
Read `research/G117_GYM_SPARRING_DAYS.md` sections 1, 3, 4 and 7 FIRST. A coach agrees the intensity before the
bell: technical/light is ~30-60% power, nobody is trying to finish; hard is agreed fight pace, still structured. He
watches the first exchanges and stops the round if power climbs or someone is hurt. Most light rounds end on the bell.
Nobody is knocked out in a technical spar; if someone is rocked, the coach steps in.

## The contract (Claude's S86 code will call exactly this)
`FightRealtime.begin(fa, fb, options)` accepts `options["spar"]`: `""` (default, a bout - byte-identical to today) or
one of `"technical"`, `"light"`, `"hard"`. Under a spar:
- strike DAMAGE (head and body condition loss, and whatever feeds knockdowns) is scaled by a per-intensity constant you
  name at the top of the file: `SPAR_POWER := {"technical": 0.35, "light": 0.55, "hard": 0.85}` (G117 section 1 -
  start there; adjust only with a measured reason, and say so).
- pace is NOT scaled by default (technical sparring is high-volume, low-power); if you measure a reason to scale it,
  add `SPAR_PACE` beside it and justify it in the digest.
- the COACH STOP: under `technical` and `light` a round ends early as `stoppage.method == "COACH_STOP"` the moment a
  fighter is knocked down OR his head condition falls under `SPAR_STOP_HEAD := 70.0`; under `hard` only a knockdown
  stops it. A spar NEVER produces `KO`, `TKO`, a submission finish or a decision winner the fight record would read -
  `state["result"]` carries `{"spar": true, "rounds_done": n, "stopped": bool, "landed_a": n, "landed_b": n,
  "head_a": x, "head_b": x}` so S86 can score "who had the better of it".
- submissions in an MMA spar: the attempt still happens; a lock that would finish ends as a TAP (`"tap_a"` / `"tap_b"`
  counted in the result), and the spar continues - that is what a gym roll does.

## The work
1. Implement the option in `Godot/scripts/FightRealtime.gd` (5,935 lines - NEVER open it whole; `rg -n` for `options.get`
   (read at `begin()` :906), `CORNER_STOPPAGE_HEAD_CONDITION` (:333, used :2422) and the strike-damage site, then
   `sed -n 'A,Bp'` windows). A bout (`spar == ""`) must be byte-identical to today: prove it with the same-seed
   DETERMINISM tripwire (the one legitimate same-seed rerun) on 5 seeds per ruleset, before and after your change.
2. A census tool `Godot/tools/q188_spar_census.gd`: 40 spars per intensity per ruleset (boxing, kickboxing, MMA), each a
   LEGAL, DIFFERENT pair (an outside boxer vs a pressure boxer in boxing; an outside kicker vs a pressure puncher in
   kickboxing, both able to kick; a grappler vs a striker in MMA; different stats, frames and plans - NEVER two identical
   fighters, NEVER a man missing techniques his ruleset allows; name the population in the tool's output), 3 rounds
   each. Print per intensity: head condition lost per minute (vs the same pairs in a bout), knockdowns, coach stops,
   taps, rounds that end on the bell.
3. A test `Godot/tests/fight_spar_intensity_test.gd`: bout byte-identity (5 seeds x 3 rulesets); zero KO/TKO/submission
   finishes in any spar; technical head loss per minute <= 45% of the bout's for the same pairs; hard > light > technical;
   a coach stop fires when head condition is forced under 70 in a technical spar and does NOT fire in a hard one.

## Owned files
`Godot/scripts/FightRealtime.gd` (the spar option only), `Godot/tools/q188_spar_census.gd`,
`Godot/tests/fight_spar_intensity_test.gd`, `research/Q188_DIGEST.md`.

## Tier
A script edited. Parse gate on every touched file, the new test, then
`python Godot/tools/run_tests.py --only fight_realtime,fight_scoring,fight_kb,fight_footwork,fight_pace,fight_spar --jobs 2`.
Ceiling: on 2026-09-26 master failed `fight_scoring_test` and six JUDO rows inside `fight_realtime_test`; nothing else in
that subset. Fewer is better. No full suite (it runs nightly).

## Research
All research is open: root `RESEARCH_INDEX.md` (G117 is the source; G108 the kickboxing anchors; Q186_DIGEST the last
change to head damage). Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md.

## Done
Commit, push your branch, write the digest (population named, the census table, byte-identity result), then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q188 --body "<technical/light/hard head loss per min vs bout, stops, byte-identity>"`.

## The trap
Scaling damage in ONE place is not enough if knockdowns are rolled from a DIFFERENT number (shock, a stagger roll, a
per-technique multiplier like Q186's KB head wear). Grep for every path that turns a landed strike into condition loss
or a knockdown, and prove each one is scaled - a "technical" spar that still drops a man with a clean kick is the defect.

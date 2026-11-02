# TASK_Q166 - finish Q165: the ground game, mergeable, and the flag that hides it (Qwen, full branch)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S65, 2026-09-24.

## Where Q165 left it (your own `research/Q165_DIGEST.md` on `origin/qwen/q165-ground-game` 7d8ece9b)
The proximity factor in `FightRealtime._grapple_standing` moved ground time 10.0% -> 18.6% (anchor 15-25%) and
takedown attempts 0.75 -> 1.39 per 15 min (anchor 2.5-3.0). Claude reviewed it in S65 and did NOT merge it, for
three reasons - fix each:
1. **`fight_realtime_test` goes red**: 7 pinned seeds moved. Re-pin them from the test's OWN printed actuals
   (run the test, parse its lines - never copy by hand; run each twice, both runs must agree), with a
   `# Q166 RE-PIN (2026-09-24): ...` note on each, the way `judge_panel_test.gd` does it.
2. **Leg share moved AWAY from its anchor**: 8% -> 6.0% against a real 14-18% (J20). A change that moves a
   metric away from its anchor is held, not shipped (standing rule). Find why more pocket time costs kicks
   (fighters closer = legs not targets?) and make it hold at 8% or better. Print all arms: OLD tree,
   proximity ON, and your repair.
3. **The factor 8.0 is tuned.** Derive the shape from something real or state plainly that it is authored
   and what it is authored against (the 2.5-3.0 attempts anchor), in the code comment and the digest. Takedown
   attempts at 1.39 still UNDERSHOOT; say what would close the rest.

## Part 3 - the flag that hides grappling in the room (report only)
Your own finding: `FightBeatAdapter.gd:295 GRAPPLE_BEATS_DEFAULT := false`. The operator's verdict on take one
was "no ground game at all, no take down" - he watches the ROOM, not the engine. On a seed that grounds in the
live MMA room (screen seeds 92013+ with your census; 92012 does not ground), print for 60 s with the flag off
and on: engine grapple events, what the room SHOWS (pair key / clip per second), and whether any frame shows a
takedown or a man on the mat. Do NOT flip the default - report which it should be and what breaks if it is on.

## Population (print it in every output)
Your R133 pair: grappler (grapple 82) vs striker (34), MMA, different styles and frames - never identical fighters.

## Owned files
`scripts/FightRealtime.gd` (`_grapple_standing` and what Part 2 needs), `tests/fight_realtime_test.gd` (pins
only), `Godot/tools/q165_ground_census.gd`, a new `Godot/tools/q166_grapple_beats_probe.gd`,
`research/Q166_DIGEST.md`. Recordings: MP4 only, under 50 MB (`ffmpeg -c:v libx264 -crf 28`); NEVER
commit an .avi - your Q165 take was 432 MB and GitHub refuses anything over 100 MB.

## Gate (tier: scripts edited)
`python Godot/tools/check_scripts.py <touched .gd>`; then
`python Godot/tools/run_tests.py --only fight_realtime,grapple,fight_grapple,fight_beat_grapple,fight_scoring,judge_panel`.
`fight_scoring` has 3 pre-existing judo reds - a CEILING of 3, fewer is better.
Any windowed Godot run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>`.
Branch `qwen/q166-ground-game-finish` off `origin/qwen/q165-ground-game` (your Q165 commit is the base), in
your worktree `C:\Users\user\AppData\Local\Temp\FightCamp-Q164`, `--headless --import` once first. Commit,
push, `python Tools/agent_comms.py send --from qwen --to claude --topic Q166 --body "..."` per part.
Do NOT edit HANDOFF.md. Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md.
`FightRealtime.gd` is 5,101 lines - never open it whole; grep, then read `sed -n 'A,Bp'` windows.
Trap: a re-pin that makes the test green is not evidence the change is right - the leg-share arm is.

## ROUND 3 (assigned S66, 2026-09-24) - why more ground time finishes too many fights
Round 2 landed ground 20% (anchor 15-25) and TD 1.75/15 min, but **only 2 of 16 fights went the distance**.
J20 D4 (`research/J20_THE_VALIDATION_CORPUS.md:42`): modern UFC standard divisions **51.1% decision /
31.7% KO-TKO / 17.2% sub**; D6: submission ATTEMPTS ~0.5-1.0 per fighter-fight.
1. **Diagnose before tuning** (census on your branch AND the unchanged `origin/master` tree - the control arm):
   for 32+ bouts print, per bout: finish method, round, WHERE it ended (standing / clinch / ground), ground
   seconds, submission attempts and their success, ground strikes landed. Then the ratios: subs finished per
   attempt, GnP finishes per ground minute, standing KO per standing minute. Name which ratio is off its
   anchor - a per-fight total is volume x rate, so find the RATE that is wrong, never the constant nearest it.
2. **Fix the one mechanism** the census names, in `FightRealtime.gd`, with the anchor it serves in the code
   comment. Gate as CEILINGS: decisions >= 35% of 32+ bouts (anchor ~51%), ground 15-25% held, leg share not
   below the old tree's 8.1% (report it either way). If you land nearer 51%, say so and push.
3. Only then re-pin the RNG-shifted seeded tests your round 2 listed (`fight_grapple_seam`, `grapple_adapter`,
   `judge_panel`, and `fight_scoring`'s non-judo pins), each with a `Q166 RE-PIN` comment naming the old seed.
   `grapple_naming_contract` 78.3% < 85%: run it on `origin/master` first - if it is red there too, leave it.
Population: your R133 pair PLUS a second, different pair (e.g. wrestler vs kickboxer, other weights) - two
populations, named in every output. Never identical fighters.
Base: rebase `qwen/q166-ground-game-finish` onto `origin/master` first (Codex C190 is also editing
`FightRealtime.gd`, presentation side only - stay in the grapple/finish code). Same gate, owned files and
send line as above; digest appended to `Q166_DIGEST.md` under `## Round 3`.
Trap: a finish rate that drops because fights stop reaching the ground is not a fix - ground % must hold.

## ROUND 4 (S66, 2026-09-24) - the finish must not punish skill
Round 3 (`8f77ce75`) landed the population numbers (decisions 45% / 42.5%, subs 22.5% / 15%) but NOT merged, because
`GrappleResolve.submission_advance` now scales the finish threshold by `sqrt(70 / attacker_grapple)`: a WORSE grappler
holding a lock at progress 100 taps the man MORE often per tick than a better one. The comment's own arithmetic also
disagrees with the formula (it prints grappler 0.028 vs brawler 0.018; the formula gives 0.026 vs 0.032). A fix that
hits the anchor by inverting skill is a second defect (CLAUDE.md: ask what a rule is for).
1. Run the census with `FINISH_P = 1/35` and NO grapple scaling - is the flat cut alone inside the anchors?
2. If a skill term is needed, make it RELATIVE and in the right direction: attacker's submission offense against the
   DEFENDER's submission defence / escape (a better attacker finishes more, a better defender escapes more). Name the
   stat keys you read and PRINT their values for both populations (`_stat(attacker, "grapple_offense")` - check the key
   exists on these fighters; an absent key silently reads the default).
3. Ground share Pop A 25.4% is OVER its 15-25 ceiling - bring it inside or say why not. Report leg share (old tree 8.1%).
4. The comment states the formula and numbers that the code actually produces.
Same gate, same owned files, re-pins kept only where the final mechanism still moves them. Digest under `## Round 4`.

# TASK Q226 - training strands, speed and technique effects reach the live fight (engine, Qwen CLI on deepseek-v4-pro)
Owner: Qwen CLI (model deepseek-v4-pro, Token Plan). Worktree E:/FightCamp/wt/Q226, branch qwen/q226-fight-inputs (from master).
Operator S137: "everything needs to have a meaning and reward the player for progressing"; S137_WIRING_AUDIT.md section C
rows E3 (training strands), E4 (47 technique effect keys), E5 (speed in decisions). C230 (personality + heat) is the
pattern to copy: one engine switch, game ON / tests OFF, OFF byte-identical, census bands held.

## Do (in this order, each behind its own switch added to FightRealtime.DEMO_SWITCHES)
1. `speed_in_decision` (E5): FightIntent reads the fighter's speed - a faster man closes and circles a little more,
   bounded like C230 (FightIntent.PERSONALITY_BIAS shows the size of a lean). Census: gap/in-range shares move, bands hold.
2. `training_strands` (E3): TrainingStrands (grep `class_name TrainingStrands` / TrainingStrands.gd) -> a small,
   bounded edge on the matching fight input (a man who drilled the jab throws it a touch more and lands a touch more).
3. `technique_effects` (E4): the effect keys in the technique catalog (`grep -n "finish_chance\|cut_chance\|stop_hit\|pushback" Godot/assets/data/*.json`)
   -> one effect processor at the impact step, authored sizes from the data, no new RNG draws when OFF.
FightRealtime.gd is ~7,600 lines - NEVER read it whole: grep, then `sed -n` windows (C230_DIGEST.md names the hooks it
used: begin(), _build_fighter, _run_decision, _run_impact).

## Gates (never loosen one)
- Each switch: a test with a control (switch OFF = byte-identical events; ON moves the named quantity in the right direction).
- Census after all three: `Godot/tools/q212_booked_census.gd -- weeks=40` (game switches) vs `-- weeks=40 no_identity`
  style control arm you add for your switches (each arm its own save folder - see S138's fix in that file): KO+TKO stays
  40-55% (BoxRec ~47), thrown 45-56 per man-round, connect % inside the boxing_output_test band. Report both arms.
- `python Godot/tools/run_tests.py --jobs 2 --only fight_identity,fight_realtime,boxing_output,fight_pace,fight_intent,fight_strike_whole`.

## Owned files
`Godot/scripts/FightRealtime.gd`, `Godot/scripts/FightIntent.gd`, `Godot/scripts/TrainingStrands.gd` (reads only),
new `Godot/scripts/TechniqueEffects.gd`, `Godot/tests/q226_*_test.gd`, `Godot/tools/q212_booked_census.gd` (arm args only),
`research/Q226_DIGEST.md`.

## Prior research
C230_DIGEST.md (all), R147_ATTRIBUTES_AND_GAPS.md, R149, Q68, `python Tools/prior_research.py technique effect strands speed`.

## What would a human do?
A sim designer: small, bounded, data-driven edges, each measured on and off on the same seeds.

## Prefab check
Our own data and modules.

## The one trap
`var x := <call>` fails on a Variant return - type it; a parse error HANGS a headless test - parse gate first.

## Finish
git add by explicit path, commit, git push -u origin qwen/q226-fight-inputs. Never edit HANDOFF.md. Do not stop at written.

## SEND-BACK 1 (Claude, S139, primary source: Q226_DIGEST.md on 45b5e800 - "Census not run")
Not merged: an engine change ships only with its census. Do it now, same worktree and branch:
1. `git pull origin master` (G156, U207 merged since).
2. Watchdog GREEN, then run BOTH arms of the booked census, each in its own process (each has its own save folder):
   `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/q212_booked_census.gd -- weeks=40 as_game`
   and the same with `no_q226` added. Target >= 120 boxing bouts per arm (raise weeks if short). Wait on each process's
   exit, never on a string in its output.
3. Report per arm, side by side: KO+TKO %, decision %, knockdown %, thrown per man-round, connect %. Bands: KO+TKO 40-55%
   (S138: ON 43.3 / OFF 46.7), thrown 45-56 per man-round. The OFF arm must match S138's OFF numbers (it is the control).
4. If the ON arm leaves a band, tune ONLY the Q226 constants (STRAND_EDGE_MAX, SPEED_CLOSE_MAX, the effect magnitudes) -
   never loosen a band - and re-run. Print achieved beside wanted.
5. The heavy tests that timed out: run `python Godot/tools/run_tests.py --jobs 2 --only fight_realtime,boxing_output,fight_strike_whole`
   (the runner has its own longer timeout) and report each. OFF must stay byte-identical.
Update Q226_DIGEST.md with the census table, commit by explicit path, push the same branch. Do not stop at written.

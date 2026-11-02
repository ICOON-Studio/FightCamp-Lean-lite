# TASK C230 - personality and rivalry heat SHOW in the live fight (engine, Codex)
Model: gpt-6-luna, medium (operator 2026-10-01: "use astra model for 3d, luna for other things").
Owner: Codex. Worktree D:/FightCamp/wt/C230, branch codex/c230-identity-in-fight (from master).
Operator 2026-10-01, verbatim: "everything needs to have a meaning and reward the player for progressing".
S137_LOOP_PLAN.md rows E1 + E2; S137_WIRING_AUDIT.md section C.

## Why
- Personality (8 labels, `CareerGoals.personality_of(athlete)`, Godot/scripts/CareerGoals.gd:46; data
  `assets/data/career_goals.json` `personality_shift`) is read by NO fight file: "A Fearless fighter and a Reserved one
  fight identically" (R147_ATTRIBUTES_AND_GAPS.md).
- Rivalry heat is stashed on the athlete at booking (`bout_rivalry_heat`, GameState ~9897) and the LEGACY engine reads it
  (FightSimulation.gd:1126 `rivalry_heat`, :1179 `Rivalries.attack_bonus`, :1210 `stamina_scale`, :1249 `hurt_penalty`).
  Every boxing/kickboxing/MMA bout the player watches runs FightRealtime (7,571 lines - never read whole), which never
  reads it. The grudge-fight mechanic the career sells is dead in the fight.

## Prior research
`python Tools/prior_research.py personality rivalry heat aggression intent`; R147_ATTRIBUTES_AND_GAPS.md s2;
Godot/scripts/Rivalries.gd (its attack/stamina/hurt curves are the AUTHORED effect sizes - reuse them, do not invent new
ones); Godot/scripts/FightIntent.gd (226 lines - the per-tick choice of intent: press/hold/retreat/circle...);
Godot/scripts/FightPlans.gd (374). Find how FightRealtime builds each fighter's dict: `grep -n "func begin\|_fighter_state\|\"stamina\"" Godot/scripts/FightRealtime.gd | head`.

## What would a human do?
A boxing sim designer: personality is a SMALL persistent bias on choices (a Fearless man presses and trades more; a
Reserved/Cautious one holds range and counters; a Showman feints and taunts), never a stat boost. Rivalry heat is a
bout-only edge with a cost - more output and aggression, worse stamina economy, easier to hurt (exactly Rivalries.gd's
legacy curves). Both must be VISIBLE in the census numbers and readable in the room's caption ("presses - FEARLESS").

## Prefab check
Our own modules: Rivalries.gd (curves), CareerGoals.gd (labels). No new data files.

## Owned files
- `Godot/scripts/FightRealtime.gd`: carry `personality` and `rivalry_heat` into each fighter's state at begin(); apply
  Rivalries curves where the legacy sim did (attack on damage/counter/setup roles, stamina scale, hurt threshold). Name
  every edited line range in the digest.
- `Godot/scripts/FightIntent.gd` (and FightPlans.gd only if needed): a personality bias table (8 labels -> small weights
  on intent choice), AUTHORED, each weight labelled with its reason.
- Both behind ONE engine switch `identity_in_fight`, added to `FightRealtime.DEMO_SWITCHES` (game ON, tests OFF).
- The room caption (FightWorldLiveScreen `why` line) may append the personality word on an intent change - ONE line edit.
- NEW `Godot/tests/fight_identity_test.gd`: two DIFFERENT legal boxers (stats, names, frames differ), same seeds,
  personality Fearless vs Reserved -> pressing/hold shares differ in the right direction; heat 0 vs high -> output up,
  stamina lower at the bell; switch OFF = byte-identical events to master (control).
- NEW census `Godot/tools/c230_identity_census.gd` + `research/C230_DIGEST.md`.

## Gate (bands - never loosen one)
Census ON vs OFF, 120 bouts per arm, legal boxing matchups: KO+TKO stays 40-55% (BoxRec ~47), thrown 45-56/man/round,
connect % inside the boxing_output_test band; personality shifts the press/hold share by a visible but bounded amount
(report it); heat raises output and lowers bell stamina. Tests: parse gate, the new test, then
`python Godot/tools/run_tests.py --jobs 2 --only fight_identity,fight_realtime,boxing_output,fight_pace,fight_intent,rival`.
Watchdog before every heavy run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`.

## The one trap
`var x := <call>` fails on a Variant return - type it. A parse error HANGS a headless test: parse gate first. Switch OFF
must stay byte-identical (fight_strike_whole compares events byte for byte).

## Finish
git add by explicit path, commit, git push -u origin codex/c230-identity-in-fight. Do not stop at "written".

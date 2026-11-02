# TASK Q72 - QWEN - JUDO'S GROUND IS HELD OUT OF S1d: THE RULES AND THE SEATS IT NEEDS

Model: qwen3-coder, **medium effort**. Owner: qwen. Launched `--yolo`.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GATE BUT ITS OWN CHECK SCRIPT.**
**Do NOT start Godot.** Claude is running tests in this checkout.

## Owned files

- `research/Q72_JUDO_NEWAZA.md` - **NEW, yours alone.**
- `research/Q72_judo_seats.json` - **NEW, yours alone.**

Nothing else. Do NOT edit `technique_catalog.json`, any script or test,
`HANDOFF.md` or `AgentComms/roadmap.json`. `research/Q72_check.py` is
Claude's - run it, never edit it.

## Why this exists

S1d gives every ground technique the seat it is thrown from. BJJ landed
(`f851924`) and made the BJJ ground fight real. **Judo was measured and HELD
BACK**, because giving judo's newaza seats made judo LESS like judo:

`Godot/tools/measure_ground_seats.gd`, a standing thrower vs a newaza specialist,
40 seeded bouts under judo rules - before / after judo seats:
ground exchanges 55% -> 77%, **ippon wins 31 -> 11**, decisions 9 -> 29, zero
submissions, and **rear chokes applied from underneath** (`judo_hadakajime`
64 times and `judo_okurierijime` 59 times from the BOTTOM seat).

Three reasons, and this task researches all three so judo can land:

1. **No matte.** In `FightSimulation` the ONLY road back to standing is an escape.
   Before S1d the man underneath had nothing eligible, so the engine's fallback
   escape stood the fight up constantly - an accidental matte. With seats he has
   moves, so nobody stands up. IJF referees stop unproductive newaza.
2. **No osaekomi ippon.** A judo pin earns `position_points.control = 1.0` per
   landed control (`combat_rulesets.json`, judo `scoring_profile`), never an ippon.
   `research/G38_THE_GROUND_FIGHT_READ.md:59-60` already records the IJF
   rule: pin 10-19 s = waza-ari, 20 s = ippon.
3. **Seats the effects cannot say.** `derive_technique_phases.py` rule B reads a
   node's effects. Judo's 20 submissions are all authored
   `{submission, submission_setup}` or `{submission, arm_isolation}` - no marker -
   so every one came out "both seats". Hadaka-jime is applied from BEHIND.

## Scope

**Part 1 - the rules, from what is already on disk.** Read ONLY:
`G38_THE_GROUND_FIGHT_READ.md` lines 50-66, and `grep -n -i 'newaza\|matte\|osaekomi\|shime\|kansetsu'`
over `research/COMPETITION_RULESET_RESEARCH.md` and read the hits with 3
lines of context. From `Godot/scripts/FightSimulation.gd` (3,292 lines, never
whole): `sed -n '100,110p'` (`AVG_SECONDS_PER_EXCHANGE = 14.0`) and
`sed -n '405,430p'` (exchanges per round). Then write:
- the IJF newaza rules that matter here, each with its source line on disk; where
  the disk does not say (e.g. how quickly matte is called), say "NOT ON DISK" -
  do not invent a number;
- what those rules are in EXCHANGES at 14 s each (a 20 s osaekomi is ~1.4
  exchanges);
- a proposed judo matte and osaekomi mapping for the exchange model, and which
  ruleset(s) each must NOT apply to (G38:63 is explicit that osaekomi is not an
  MMA or IBJJF rule).

**Part 2 - the seats.** `Q72_judo_seats.json`: one entry for EVERY judo node that
`python Godot/tools/derive_technique_phases.py --discipline judo` would give a
ground seat (rules A and B - NOT the 22 rule-C landings). That report prints
them; there are 33. Shape:
`{"catalogue_commit": "<short hash>", "nodes": [ {"id": ..., "seats": ["ground_top"] | ["ground_bottom"] | ["ground_top", "ground_bottom"], "rule_b_says": [...], "reason": "..."} ]}`.
Decide each by how the technique is applied IN JUDO: a pin (osaekomi-waza) holds
from on top; hadaka-jime, okuri-eri-jime and kata-ha-jime are applied from behind,
which in a two-seat model is the top seat; juji-gatame can be applied from above
or from underneath. `rule_b_says` is what the tool printed. **Where you agree with
rule B, say so; where you do not, the reason must say why.**

## THE TRAP

**Do not decide a seat from the romanised name's substrings** (`jime`, `gatame`).
Hiza-gatame and ude-gatame are both `gatame` and are applied from different
places. Decide from what the technique is, and write low-certainty ones as such
in the reason.

## Done

- Run `python research/Q72_check.py` until it exits 0.
- Shared checkout: stay on `master`. **Never** `git checkout`, `switch`, `branch`,
  `stash`, `reset`, `clean`, `add -A`, `pull` or `push`.
- Commit ONLY your two files, path-limited:
  `git add -- research/Q72_JUDO_NEWAZA.md research/Q72_judo_seats.json`
  then `git commit -m "Q72: ..." -- research/Q72_JUDO_NEWAZA.md research/Q72_judo_seats.json`,
  ending with `Co-Authored-By: Qwen <noreply@qwen.ai>`. **Do not push.**
- One line of mail:
  `python Tools/agent_comms.py send --from qwen --to claude --topic Q72-done --body "<hash> <the Q72_CHECK line>"`

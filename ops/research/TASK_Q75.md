# TASK Q75 - QWEN - 173 SUBMISSION LANDS, 0 FINISHES: WHAT RESISTS A STAND-UP

Model: qwen3-coder, **medium effort**. Owner: qwen. Launched `--yolo`.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GODOT AT ALL.** Claude is running bouts and
tests in this checkout and only one Godot may run. Your gate is a Python script that
MUST exit 0.

## Owned files

- `research/Q75_escape_options.json` - **NEW, yours alone.**
- `research/Q75_WHAT_RESISTS_A_STAND_UP.md` - **NEW, yours alone.**

Nothing else. Do NOT edit any script, test, catalogue, `Q75_check.py`, `HANDOFF.md` or
`AgentComms/roadmap.json`. Claude is editing `Godot/scripts/FightSimulation.gd` RIGHT NOW,
so its line numbers move: find each function with `grep -n 'static func <name>'` and read
that function only. The file is ~3,360 lines - never open it whole.

## Why this exists - measured on master `a62cd0e`

S1e made a submission attack one accumulating threat (`SUBMISSION_SWITCH_CARRY`). BJJ now
finishes 5 of 40. But both MMA matchups finish NONE, and the reason is on the other side of
the exchange: the bottom man keeps standing up. `tools/measure_ground_seats.gd`, 40 seeded
bouts per matchup, catalogue md5 `43e3368e916a09e4ae5c76bb5a17f3c3`:

| matchup | ground exchanges | escapes landed | stand-ups | submission lands | submission finishes |
|---|---:|---:|---:|---:|---:|
| bjj: guard player vs pressure passer | 1420 | 94 | 56 | 512 | 5 |
| mma: grappler vs striker | 803 | 120 | 81 | 74 | 0 |
| mma: muay thai striker vs jiu-jitsu fighter | 983 | 138 | 80 | 173 | 0 |
| judo: thrower vs newaza specialist | 258 | 82 | 50 | 0 | 0 |
| sambo: thrower vs leglocker | 555 | 0 | 0 | 278 | 21 |

The MMA striker has grapple 40 and a BJJ proficiency of 35. The grappler has grapple 80 and
BJJ 76. The striker stands up 81 times.

## Scope

1. **The mechanism, both rolls.** An escape has to LAND first (`_resolve_action` - the land
   chance and the defence factor it subtracts; read `_defender_defense_factor` and the
   `DEFENSE_CLASSES` / `DEFENSE_ANSWERS` consts: does anything answer an incoming `escape`?)
   and THEN `_resolve_escape_attempt` rolls the stand-up. Write down every term in each roll
   and say which belong to the man on top. Also: what clears a submission attempt, and when
   the bottom man with nothing eligible throws `FALLBACK_ESCAPE` (`_fallback_action`).
2. **Anchors on disk.** How long a dominant ground position lasts, or how much of a fight a
   top player controls, in real MMA or BJJ. Look in
   `research/J20_THE_VALIDATION_CORPUS.md` (section C, position and control) and
   `research/G38_THE_GROUND_FIGHT_READ.md`. Quote with `file`, `line` and the exact
   `quote`. If a figure is not on disk, say so; do not invent one.
3. **Options, at least three, each a rule a person could build**, for example: (a) the top
   man's control skill resists the stand-up roll; (b) a landed pin sets a hold the next
   escape must beat, decaying per exchange; (c) a landed escape that fails to stand him up
   keeps `SUBMISSION_SWITCH_CARRY` of the pressure instead of zeroing it. For each, which
   functions it touches and the predicted DIRECTION of submission finishes per matchup
   (`up`, `down` or `same`). Recommend one. Do NOT build it.

**Judo is out of scope for the options:** Claude is building judo's osaekomi (a hold that
scores) in this session. Report judo's row as context only and predict `same` for it.

JSON shape:

    {"fixtures": [{"matchup": "bjj", "ground_exchanges": 1420, "escapes_landed": 94,
                   "stand_ups": 56, "submission_lands": 512, "submission_finishes": 5}, ...],
     "mechanism": {"stand_up_formula": "<the exact clampf(...) expression from the code>",
                   "land_roll_terms": ["..."], "stand_up_roll_terms": ["..."],
                   "top_man_terms": ["..."]},
     "anchors": [{"metric": "...", "population": "...", "file": "research/...", "line": 0, "quote": "..."}],
     "options": [{"id": "a", "rule": "...", "touches": ["_resolve_escape_attempt"],
                  "predict": {"bjj": "up", "mma_grappler_striker": "up", "mma_thai_jiujitsu": "up",
                              "judo": "same", "sambo": "same"}}],
     "recommend": "a"}

`fixtures` matchup keys, in this order: `bjj`, `mma_grappler_striker`, `mma_thai_jiujitsu`,
`judo`, `sambo` - with the numbers from the table above.

## THE TRAP

**The top man is not absent from an escape - he is absent from ONE of its two rolls.** The
land roll subtracts HIS defence factor; the stand-up roll reads only the escaper. Q73 found a
defence bonus that was blind to phase; do not now write that the top man plays no part.
Trace both rolls before you write a sentence about either.

## The gate

    python research/Q75_check.py

It checks the fixture numbers, that the formula you quote is really inside
`_resolve_escape_attempt`, that each anchor quote is on its line, and the option shape. It
fails now because your files do not exist. Fix YOUR FILES, never the checker.

## Done

- Stay on `master`. **Never** `git checkout`, `switch`, `branch`, `stash`, `reset`, `clean`,
  `add -A`, `pull` or `push`.
- `git status -s` first. Commit exactly your two paths, ON the commit line:
  `git commit -m "Q75: ..." -- research/Q75_escape_options.json research/Q75_WHAT_RESISTS_A_STAND_UP.md`
  (after `git add -- <the same two paths>`), ending `Co-Authored-By: Qwen <noreply@qwen.ai>`.
  Then `git show --stat HEAD` must list exactly those two files. **Do not push.**
- Mail: `python Tools/agent_comms.py send --from qwen --to claude --topic Q75-done --body "<hash> top_man_terms=<n> options=<n> recommend=<id> check=exit0"`
- Do NOT edit `HANDOFF.md`.

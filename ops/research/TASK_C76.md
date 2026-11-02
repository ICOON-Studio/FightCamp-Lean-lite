# TASK C76 — CODEX — A BJJ MATCH IS NOT TEN MINUTES FOR EVERYBODY

**Model: Codex, high effort, Fast mode OFF.** Owner: Codex.
Assigned 2026-09-10 by Claude, straight off G41's §5 recommendation 1.

Read this file and nothing else, except **`research/G41_NOT_ROUNDS.md` §1
(the BJJ subsection) and §5**, which is the source you are implementing. Do NOT
read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest.

## The defect, verified before you were assigned

`Godot/assets/data/combat_rulesets.json` gives `bjj` **one** contest length:

    "bjj": { "rounds": 1, "round_seconds": 600, ... }

G41 established, from the IBJJF Rule Book Version 6.1 (June 2024), Art. 1.3,
that **600 seconds is adult BLACK BELT only.** The published adult table is:

| Belt | Seconds |
|---|---|
| white | 300 |
| blue | 360 |
| purple | 420 |
| brown | 480 |
| black | 600 |

Master 1 (age ≥ 30): white/blue 300, purple/brown/black 360. Master 2–7: 300 at
every belt. Juvenile I/II: 300. Age is `(current year − birth year)`, not
birthday. G41 has the citations; do not go re-derive them, and do not extend the
table past what G41 publishes.

**And we already have the key.** This is not a hypothetical attribute:

- `Godot/scripts/GradeLadder.gd:17` —
  `LADDER_BRAZILIAN_JIU_JITSU: Array = ["white", "blue", "purple", "brown", "black"]`,
  which is the IBJJF ladder exactly.
- An athlete carries `athlete["grades"][discipline]["grade"]` — see
  `GameState.gd:5635-5638`.

So every fact the table needs is already on the fighter. **That is why this
slice is worth building and the wrestling half of G41 §5 is not being assigned
with it** — wrestling's 30-second stop lands in the corner-recovery path at
`FightRealtime.gd:753` and `:770`, and another agent is editing that file right
now. **Do not touch `FightRealtime.gd`.**

## What to build

1. **A pure module** that answers contest seconds from discipline, grade and
   age. Statics only, zero preloads. It must:
   - return the G41 table for `brazilian_jiu_jitsu` / `bjj`;
   - return the ruleset's own `round_seconds` unchanged for every OTHER
     discipline, so this is additive and nothing else moves;
   - answer honestly for an unknown grade or a missing age rather than guessing
     — decide what "honestly" is, implement it, and say which you chose and why.
2. **A caller.** This is the part that decides whether the task was worth doing.

## THE ANTI-INERT RULE, and it governs this task

This area has shipped **seven** modules that nothing called — the most recent
was found this week, where an entire authored branch had never once executed
behind a green suite. **A contest-length table that nothing asks is the eighth.**

So: find where a bout's `round_seconds` is actually chosen from the ruleset
before a fight runs, and call the module there. Anchors to start from, and note
that the first is a decoy:

- `GameState.gd:10234` reads `round_seconds` off a **stored fight log** — that
  is a read-back of a finished bout, **not** where the length is decided. Do not
  wire it there.
- `FightRealtime.gd:336-337` takes `rounds` and `round_seconds` from its
  `options` dictionary, so **the caller decides**, not the engine. Read those two
  lines and nothing else in that file.
- `Godot/scripts/Sanctioning.gd` and `GameState.gd` are the two files that read
  `combat_rulesets.json` and build fight terms.

**If, after an honest search, there is no production site that chooses a bout's
length from the ruleset — say so, ship the module and its test anyway, and name
in your mail exactly what would have to exist for it to have a caller.** That is
a real finding and will be read as one. What is NOT acceptable is shipping the
module, saying nothing, and letting it become the eighth.

## Owned files

- your new module in `Godot/scripts/` (you name it)
- its new test in `Godot/tests/`
- `Godot/assets/data/combat_rulesets.json` — **only** the `bjj` entry, and only
  to record that 600 is the black-belt figure. Leave every other ruleset's bytes
  alone.
- the one caller site you find, if you find one
- `research/C76_DIGEST.md` (new)

**Do NOT touch** `FightRealtime.gd`, `FightSimulation.gd`, `GradeLadder.gd`, any
pin file, `HANDOFF.md`, `TASKS.md` or `CURRENT_STATUS.md`. Claude writes your
block. The tree is SHARED and Cursor is editing `FightRealtime.gd` right now:
`git status -s` before staging, explicit paths only, never `git add -A`, never
`git stash`, `reset --hard`, `checkout .` or `clean`.

## Test tier — FOCUSED

Claude runs the full suite once at integration. Yours:

```
python Godot/tools/check_scripts.py <your module> <your test>
python Godot/tools/run_tests.py --only <your test's substring>
python Godot/tools/run_tests.py --only judge_panel
python Godot/tools/run_tests.py --only grade
```

**Never pass `--godot`.** The runner already defaults to this project's engine;
pointing it at the chocolatey binary makes every boot report `engine-error` and
the run is worthless — that cost a wasted pass earlier today. Ceiling `fails=0`
or better on each; if one is lower than you expect, say so and push anyway.

## Land it

Commit, push `master`, trailer `Co-Authored-By: Codex <noreply@openai.com>`,
write the digest, then one line:

```
python Tools/agent_comms.py send --from codex --to claude --topic C76-done --body "<commit> <test> n/m, judge_panel n/m, grade n/m — the caller you found, or the fact that there is none and what would have to exist"
```

## The trap

**A white belt's match is 300 seconds and a black belt's is 600, and the same
two fighters can meet at either.** So the length is a property of the CONTEST,
not of the ruleset and not of one athlete — two fighters of different grades is
a case the IBJJF table does not answer on its own and you must decide, state and
label your answer as AUTHORED, the way this project labels every invented rule.
Do not quietly take the higher belt, or the lower, without saying which and why.

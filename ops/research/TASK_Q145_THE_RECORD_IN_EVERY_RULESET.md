# TASK_Q145 — DOES THE CARRIED TRAINING RECORD HOLD IN EVERY RULESET, NOT JUST MMA?

**Model: `qwen3-coder`, medium effort, `--yolo` (NEVER `auto` — auto leaves you
with no shell tool at all).** Worktree `FightCamp-Q114`, a FRESH branch
`qwen/q145-record-every-ruleset` cut from `origin/master`.

**This is a BLIND measurement.** Do NOT read `tests/carry_progress_contract_test.gd`
and do NOT read the S59 digest. You get the definition below and nothing else;
a measurement written against the implementation only agrees with it.

---

## THE CHANGE YOU ARE MEASURING (S59, shipped 2026-09-23)

`FightRealtime.begin(a, b, options)` takes `carry_progress` (bool). **Since S59
it DEFAULTS TO TRUE** (operator ruling). When true, the built fighter carries the
athlete's `technique_progress`, so `FightMoves.grapple_arsenal(built_fighter,
ruleset_id)` narrows to what the man trained instead of falling back to the
whole tier 1-2 palette. `carry_progress: false` reproduces the pre-S59 tree.

Q142 measured it in **MMA only**, one matchup: palettes 120->119 and 120->104,
named grapple events naming a learned technique 98.7% -> 100%, bout outcomes
unchanged. **Nobody has looked at the other ten rulesets.**

## THE RISK THAT MAKES THIS WORTH A TASK

A narrowing can reach **ZERO**. A man in a judo or wrestling bout whose record
holds none of that ruleset's grapple techniques gets an EMPTY carried palette -
and an empty palette makes `_grapple_technique_for` return `""`, so every grapple
event he makes is unnamed. The fallback that used to hide this is exactly what
S59 removed. Find out whether it happens.

## WHAT I WANT: ONE TABLE, ELEVEN ROWS

For each ruleset id in `Godot/assets/data/combat_rulesets.json`
(`mma, boxing, kickboxing, muay_thai, judo, freestyle_wrestling, greco_roman,
karate, bjj, sambo, taekwondo`), two arms (`carry_progress` false / true), 24
bouts each, seeds `563000 + i`:

| column | meaning |
|---|---|
| palette A / B, each arm | `FightMoves.grapple_arsenal(state[side], ruleset_id).size()` on the BUILT fighter |
| empty? | does either man's carried palette read 0 |
| named / unnamed grapple events | events with `type == "grapple"`, `technique` non-empty vs empty |
| learned % | of the named, how many are in the actor's own `technique_progress` |
| methods | KO / TKO / SUBMISSION / DECISION counts per arm |

A ruleset with no grappling at all (boxing) will read 0 grapple events on both
arms - **print that as a result, do not skip the row.**

## POPULATION — IT HAS COST THIS PROJECT FOUR TIMES

**Never two identical fighters**, and **each man must be legal for the ruleset
he is in** (CLAUDE.md, operator rules 2026-09-12). Per ruleset build two
DIFFERENT men of that ruleset's own disciplines - differ by STYLE and stats
inside the ruleset (e.g. a thrower vs a pinner in judo, an outside kicker vs a
pressure puncher in kickboxing), never by removing a technique the ruleset
legally permits. Build each record from the catalogue exactly as
`tools/q142_training_record.gd`'s `_style_progress` does (read that file - it is
your pattern), using `FightMoves.disciplines_for(ruleset_id)`. **Print each
man's stats and his record's size in your output**, and refuse to run if the two
stat blocks match.

## OWNED FILES

- `Godot/tools/q145_record_every_ruleset.gd` — **new**, yours.
- `research/Q145_DIGEST.md` — **new**, yours: the table, the population,
  and your reading of it.

**No engine file is edited.** If you find a defect, REPORT it - do not fix it.

Worth one grep each before you start (a negative result is a result):
`grep -n "q142\|carry_progress" research/RESEARCH_INDEX.md`.

## TEST TIER — A NEW TOOL ONLY, NO SCRIPT EDITED

Parse gate on your tool, then run it. **Nothing else. No suite, no subset.**

```
python Godot/tools/check_scripts.py Godot/tools/q145_record_every_ruleset.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/q145_record_every_ruleset.gd
```

## THE ONE TRAP SPECIFIC TO THIS TASK

**Pass the ruleset as a DICTIONARY, not a string.** `begin` reads
`options["ruleset"]` as the ruleset record; copy `_ruleset_dict` from the Q142
tool. Hand it a bare id and every bout silently runs under a default, all eleven
rows come out identical, and you will report "no ruleset differs" - which is
the fixture talking, not the engine. **Print `state["ruleset_id"]` for bout 0 of
every row** so a reader can see the eleven rows really ran eleven rulesets.

## WHEN YOU ARE DONE

Commit, push `qwen/q145-record-every-ruleset`, and send one line:

```
python Tools/agent_comms.py send --from qwen --to claude --topic Q145 --body "<one line, NAME THE BRANCH, say whether any palette went EMPTY>"
```

Do NOT edit `HANDOFF.md`.

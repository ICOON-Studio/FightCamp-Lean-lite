# TASK Q68 — QWEN — WHAT IS IN THIS GAME THAT NOTHING CALLS

**Model:** qwen3-coder, medium effort, `--yolo`. Fixed at assignment.

**Test tier:** ANALYSIS. No Godot run required, no test, no full suite. Python
over the repo. Parse gate only if you write a `.gd` (you should not need to).

Read THIS FILE and the files it names. Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest.

---

## WHY THIS EXISTS — THE OPERATOR'S QUESTION, VERBATIM

> *"I thought we made so many research about the rules and you still finding
> incompatibilities"* … *"why these things exist in the game if they are not
> called"*

They are right and the pattern is now undeniable. In ONE session we found:

| authored thing | who reads it |
|---|---|
| 55 effect tags across 184 entries | **nothing** |
| a per-technique `rulesets` field on 24 nodes (`['k1','glory','dutch']` — low kicks are banned in American full contact) | **nothing** |
| 9 disciplines / 354 techniques incl. karate 173 and judo 115 | **no ruleset can reach them** |
| `role: "finish"` on 66 nodes | the engine's `match` has no such arm — they landed and applied NOTHING |
| `kind: "sequence"` | a validator forced 54 of them to `move` |
| `FightSimulation.STAT_KEYS` | deleted in R115 — nothing read it |

**Every one was delivered, validated against itself, and never checked against
the code that would consume it.** Your job is to find the rest of them, in one
pass, so we stop discovering them one at a time.

## THE QUESTION

**Enumerate everything this project authored that nothing reads — and rank it by
what it would cost to wire.**

Three classes, and keep them separate:

1. **DEAD DATA** — a field, key or file that exists in `Godot/assets/data/` or
   `research/*.json` and is never read by any `.gd`.
2. **DEAD CODE** — a `func`, `const` or script in `Godot/scripts/` that nothing
   calls. Be careful: a `static func` called through `load()`ed script, an
   autoload accessed by node path, or a method called from a `.tscn` will look
   dead to a naive grep. **Say which of your findings you are confident in and
   which need a human look** — a wrong "this is dead" is expensive.
3. **UNREACHABLE CONTENT** — content that is read by code but that no gameplay
   path can ever arrive at. The 354 orphan techniques are the known example;
   find the others.

## HOW TO DO IT

Write a Python script. Do not do this by hand and do not sample.

- Collect every distinct key used in the JSON under `Godot/assets/data/` (and
  the four `research/*_nodes.json` trees), at every nesting level.
- Grep `Godot/scripts/`, `Godot/tools/` and `Godot/tests/` for each key as a
  string literal. A key that appears in **zero** `.gd` files is a candidate.
- For code: collect `func` and `const` names per script, then grep for each.
- **Then check your candidates by hand before reporting them.** A key read via a
  variable (`data[key_name]` in a loop) will not grep. Report the count of
  candidates you discarded on inspection — that number is itself useful.

## OWNED FILES

- `Godot/tools/audit_dead_data.py` — NEW, yours alone. Re-runnable.
- `research/Q68_WHAT_NOTHING_CALLS.md` — your findings. NEW.

**You change no existing file.** Report, do not fix.

## THE GATE — A CEILING, NOT A TARGET

- The script must be re-runnable and must print counts, not just lists.
- Every finding carries a `file:line` for where it is authored and the evidence
  that nothing reads it.
- **Lead with the ranked table**: what to wire first, judged on *authored volume
  ÷ estimated wiring cost*. The operator reads that table to decide.
- Where a finding is a judgement call, say so. **"I am not sure" is a real answer
  and is worth more than a confident wrong one** — the whole point of this task
  is that confident-but-unchecked is what created the problem.

## THE TRAP SPECIFIC TO THIS TASK

**Absence of a grep hit is not proof of death.** Everything in the table above
was found by comparing two specific things, never by a keyword sweep. Your
script produces CANDIDATES; your judgement produces FINDINGS, and the write-up
must keep the two apart.

Second: `GameState.gd` is ~13,000 lines and `FightSimulation.gd` and
`FightRealtime.gd` are both large. **Never open any of them whole.** Grep them.

## WHEN YOU ARE DONE

```bash
git add -- Godot/tools/audit_dead_data.py research/Q68_WHAT_NOTHING_CALLS.md
git commit
git push origin master
python Tools/agent_comms.py send --from qwen --to claude --subject Q68-done --body "dead_data=<N> dead_code=<N> unreachable=<N> candidates_discarded=<N> top=<one line>"
```

Check `git status -s` before staging. Stage explicit paths only. Do NOT edit
`HANDOFF.md`.

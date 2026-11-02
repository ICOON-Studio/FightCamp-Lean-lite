# TASK C97 — CODEX — THE COUNTER TAG AND THE COUNTER ROLE DISAGREE ON 32 TECHNIQUES

**Model:** gpt-5.6-luna, **medium effort — NEVER high**. Fixed at assignment.

**Test tier:** ANALYSIS ONLY, over JSON. **No Godot run at all, no test, no parse
gate** — you touch no `.gd`. The gate is your own reasoning, written down.

Read THIS FILE and the files it names. Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest.

---

## THE SITUATION

Our technique catalogue classifies every technique twice over, and the two
classifications disagree.

- **`match.role`** — one of ten (`setup, damage, counter, defense, control,
  takedown, transition, escape, submission, adaptation`). **This is what the
  engine reads** — 77 read sites in `scripts/`. `FightSimulation._apply_landed_effect`
  pays a technique out by role.
- **`match.effects`** — the tags. 140 distinct names. Read 17 times.

On countering, measured over the **live** catalogue (272 techniques):

| | count |
|---|---:|
| carry a counter TAG (`counter_damage`, `stop_hit`, `counter_accuracy`, `counter_ready`, `counter_chain`, `intercept`, `kick_counter`, `counter_timing`, `reaction_punish`) | 37 |
| have `role: "counter"` | 43 |
| **both** | **24** |
| **tagged, role says something else** (damage, adaptation, defense, setup, takedown) | **13** |
| **role says counter, carries no counter tag** | **19** |

Neither set contains the other. **32 techniques are labelled inconsistently, and
only the role affects the fight.**

Worked examples to anchor you:
- **Role only, no tag:** `boxing_rear_uppercut`, `judo_uranage_counter`,
  `karate_uramawashi`, `kickboxing_spinning_back`, `capoeira_negativa_sweep`.
- **Tag only, role says otherwise:** `boxing_shoulder_roll`,
  `judo_grip_break_counter`, `karate_gyakuzuki`, `capoeira_rasteira`,
  `bjj_submission_chain`.

## WHAT YOU HAVE TO DECIDE, PER TECHNIQUE

**For each of the 32, which label is right — the tag or the role?**

Judge it on **what the technique actually is in its sport**, not on which label is
more common. A shoulder roll IS a defensive action that sets up a counter; a rear
uppercut thrown cold is NOT a counter. Say which, and why, in one line each.

Three outcomes are allowed per technique and you must pick one:
- **ROLE IS RIGHT** — the tag is spurious or is describing a secondary property.
- **TAG IS RIGHT** — the role should change. **This is the expensive verdict:
  changing a role changes what the technique does in a fight.** Say so.
- **BOTH ARE RIGHT AND THE VOCABULARY IS THE PROBLEM** — e.g. the technique is
  genuinely a defensive move whose *whole point* is the counter that follows, and
  neither single label captures it. Group these; if there are many, that is a
  finding about the vocabulary rather than about the techniques.

## OWNED FILES

- `research/C97_COUNTER_RECONCILIATION.md` — your verdicts. NEW. **The only
  file you write.**

**You change no data and no code.** This is a recommendation sheet the operator
and Claude act on. A role change is a rebaseline — Claude's call, not yours.

## YOUR SOURCES

- `Godot/assets/data/technique_catalog.json` — the live catalogue. Large; read it
  with a Python script rather than opening it, e.g.:
  ```bash
  python -c "import json;d=json.load(open('Godot/assets/data/technique_catalog.json',encoding='utf-8'));print([ (n['id'],n['branch'],n['match']['role'],list(n['match']['effects'])) for x in d['disciplines'] for n in x['nodes'] ][:5])"
  ```
- `research/TECHNIQUE_TAGS_WIDE.csv` — **use this.** One row per technique
  with discipline, kind, tier, branch, role, phases and tags already flattened.
  It is exactly the view this task needs. Filter it with Python or read it whole
  (108 KB).
- `research/R135_THE_TAGS_AND_THE_ROLE_DISAGREE.md` — where the 32 came
  from. Short, read it whole.

## THE GATE — A CEILING, NOT A TARGET

- **All 32 techniques accounted for.** Not a sample. If you cannot decide one,
  say "UNDECIDED" and say what you would need to know — that is a real answer.
- Each verdict one line, with the sport reason. No essays.
- **Lead the file with a count:** how many ROLE IS RIGHT, how many TAG IS RIGHT,
  how many vocabulary problems. That number is what tells us how big the fix is.

## THE TRAP SPECIFIC TO THIS TASK

**`counter` is not the only overloaded word here, and you will meet the others.**
`control` already means two different things in this catalogue — *ring* control
on `boxing_cutoff_ring` and *grappling* control on `bjj_mount`. If you hit a
technique where the disagreement is really about an overloaded word rather than a
mislabelled move, **say that instead of forcing a verdict.** A finding that the
vocabulary is wrong is worth more than 32 confident guesses.

Second trap: **do not resolve a disagreement by looking at which label the engine
would prefer.** The engine reads the role, so "the role is right because the
engine uses it" is circular and tells us nothing. Judge the technique.

## WHEN YOU ARE DONE

```bash
git add -- research/C97_COUNTER_RECONCILIATION.md
git commit
git push origin master
python Tools/agent_comms.py send --from codex --to claude --subject C97-done --body "total=32 role_right=<N> tag_right=<N> vocabulary=<N> undecided=<N>"
```

Check `git status -s` before staging. Stage explicit paths only. Do NOT edit
`HANDOFF.md`.

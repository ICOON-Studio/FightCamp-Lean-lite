# TASK U60B — CURSOR — JUDO AND BJJ: GRADES AND COMBINATIONS

Model: Composer, **medium effort**. Owner: cursor. **Work on `master`, stay on it.**
Test tier: **DATA ONLY. No Godot, no test suite, no `.gd`.**

## Why there is a second pass

Your U60 role remap landed and the file validates clean — good. But
`U60_judo_bjj_nodes.json` still has **0 nodes with a grade and 0 combination
nodes**, while the other three disciplines finished all three parts:

| | nodes | combos | graded |
|---|---:|---:|---:|
| karate | 168 | 10 | 168 |
| muay thai | 95 | 17 | 95 |
| boxing + kickboxing | 78 | 11 | 78 |
| **judo + BJJ** | **176** | **0** | **0** |

**Judo and BJJ are the worst files to be missing grades in**, because they have
the clearest grading systems in the whole catalogue.

## Owned files — these two only

- `research/U60_judo_bjj_nodes.json`
- `research/U60_JUDO_BJJ_TECHNIQUES.md`

Do **NOT** touch `technique_catalog.json`, any `.gd`, any test, or another
agent's file. **Keep all 176 techniques** — this adds structure, it cuts nothing.

## Read first

`research/TECHNIQUE_CATALOGUE_CONTRACT.md`, sections **10, 11 and 12**.
They are new since your first delivery.

## PART 2 — GRADES (section 11)

Every node needs both:

```json
"grade": "<the art's OWN rank, verbatim>",
"grade_rank": <int, 1 = the first thing taught>
```

- **JUDO** — Kodokan kyu/dan: `"6th kyu"` … `"1st kyu"`, then `"1st dan"` upward.
  The **Gokyo no Waza is already ordered by teaching sequence**, so this is close
  to reading it off. Name the source.
- **BJJ** — `"white belt"`, `"blue belt"`, `"purple belt"`, `"brown belt"`,
  `"black belt"`. Stripes are NOT modelled. Name whose syllabus (IBJJF, Gracie
  Barra, Alliance — they differ).

## PART 3 — COMBINATIONS (sections 10 and 12)

This is the half that makes it a tree rather than a list with numbers on it.

**JUDO has named, documented combination attacks** — **renraku-waza**
(combinations) and **renzoku-waza** (continuous attacks). They are taught and
named; you are not inventing them. Classic examples: osoto-gari into ouchi-gari,
seoi-nage into kouchi-gari.

**BJJ has submission chains** — armbar → triangle → omoplata; kimura → sweep →
back take.

Every combination goes in branch `combinations`, and its `prerequisites` must
name **ALL** its component techniques by id.

**The validator ERRORS on** a combination with fewer than two prerequisites, and
on a combination whose `grade_rank` is lower than any component's — **a chain
cannot be taught before its pieces.**

## Also worth fixing while you are in there

Six effect keys in your file are read by no code and will do nothing:
`balance_break`, `counter_ready`, `opponent_stamina`, `reaction_punish`,
`score_or_damage`, `surprise`. Map them onto read keys where one fits; list any
you deliberately keep at the top of your report.

## The gate — run it before you push

```
python Godot/tools/validate_technique_nodes.py research/U60_judo_bjj_nodes.json
```

Must print `VALIDATION OK`, and the missing-grade warning must be gone.

## When done

Commit your two files only, **push to master, not a branch**, and send:

```
python Tools/agent_comms.py send --from cursor --to claude --subject U60B-done --body "<commit> nodes=<n> combos=<n> graded=<n> validator=OK"
```

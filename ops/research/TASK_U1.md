# TASK U1 — DOES AN OLDER FIGHTER HEAL SLOWER? (Cursor)

**Status: CANCELLED (2026-09-07) — DO NOT START.** John delivered the study
himself, minutes before this reassignment went out:
`research/J12_RECOVERY_AND_THE_YEARS.md` (57 KB, complete, graded).
Redoing it would produce a second, conflicting answer to a question already
answered. **Cursor's live task this cycle is U2 only**
(`research/TASK_U2.md`). The brief below is kept only as the record of
what was asked; nothing here is to be built.

Model: top tier, effort high, Fast off. One session.

## You are not John — you have a shell, so use it

John had no checkout and no token. You have both. That changes two things and
nothing else:

- You **commit and push your own deliverable** rather than handing files over.
- You **send your own mailbox line**: `--from cursor`.

Everything else about the research bar is John's, unchanged, because it
worked (J10 and J11 are the model).

## Deliverable

`research/U1_RECOVERY_AND_THE_YEARS.md`, in the shape of
`research/J10_THE_YEARS.md` — read that file first; it is the standard
you are being held to and it is the only file you need to read besides this
one. **Do not edit `HANDOFF.md`** — Claude writes your block. Do not write
`.gd` files or anything under `Godot/assets/`.

## Why this exists

`BodyReadiness.gd` heals a torn-up body at a rate that reads the activity and
nothing else. A 41-year-old and a 19-year-old recover identically, which is
the difference a player would feel most in a veteran's week — and the game is
about to author a number for it.

J10 could not source yearly stat deltas or a retirement formula and correctly
refused to invent them. **This may be different**: recovery and age is a real
physiology literature, not an inference off fight records. Your answer decides
whether R54's recovery factor is evidence or another authored shape.

## The questions

**Q1 — Does recovery from training load slow with age, and by how much?**
The time course of recovery from a hard session: soreness, force restoration,
readiness to train again, across adult ages. Masters-athlete literature is
fair game — say plainly when a finding is from runners or lifters rather than
fighters and grade it INHERITED, not DIRECT.

**Q2 — Does healing from INJURY slow with age?** Distinct from Q1. The game
models six body regions healing over WEEKS, so the useful shape is "weeks to
return", not "muscle protein synthesis". Soft tissue, bone, and
concussion/RHI return-to-play: do the clinical windows actually lengthen with
age, and in what steps?

**Q3 — Threshold or gradient?** The game used 30 and 33 as bare cutoffs in one
module (R52 removed them). Does the evidence support a threshold at all? If it
is a gradient, is it linear across the adult range or does it bend?

**Q4 — Is it the years or the mileage?** Career length, total bouts,
accumulated damage and rounds fought are all confounded with age. Is there
anything separating chronological age from accumulated load? **If not, say so
plainly** — the game HAS both numbers (`age` and the fight history) and could
key off either, so "they cannot be separated" is an actionable answer.

**Q5 — The medical hold.** J10 established that commission rules outrank
folklore. Do ARP / NSAC / ABC-family rules lengthen a mandatory suspension by
age, or require extra clearance for an older fighter? **A rule is DIRECT
evidence in a way a study is not.**

**Q6 — Does anything RECOVER better with age?** Ask it honestly rather than
assuming decline. If experience, pacing or training economy offsets any of it,
that is worth as much to the design as the decline is.

## The bar — J10's, which worked

- Grade every claim: **DIRECT / INHERITED / UNVERIFIED_SECONDARY / UNKNOWN.**
  A number without a grade is not deliverable. A number without a source is
  UNKNOWN by definition.
- **The could-NOT-source list is first class.** Do not pad it away and never
  fill a gap with a plausible figure.
- **Do not average populations that should not be averaged** (J10 D6): sex,
  sport, injury type and amateur-vs-pro stay separate. J10 found women OLDER
  than men in amateur boxing and YOUNGER in judo and taekwondo; assume nothing
  is symmetric.
- Give a lift-ready section: what `Aging.recovery_scale()` could **honestly**
  encode, each row with its grade attached, plus an explicit "do not encode
  this" list.
- Close with a decisions page (D1, D2, …) and any operator question you want
  answered before Claude authors anything.

## What NOT to do

- **Do not propose a game multiplier as researched.** If the honest answer is
  "the game must author this", say that and label it UNKNOWN. That is a
  complete and useful answer and it is what R54 will act on.
- Do not write `.gd`, data files, or `HANDOFF.md`.
- Do not touch anything R53 or C36 owns: `ProfileRevampPanel.gd`,
  `GameState.gd`, `OfficeHubPanel.gd`, `Aging.gd`, `BodyReadiness.gd`.
  **This task writes exactly one new markdown file.**

## Done

```
git add -- research/U1_RECOVERY_AND_THE_YEARS.md
git commit && git push origin master
python Tools/agent_comms.py send --from cursor --to claude --topic "U1 landed" --body "<one line: the headline finding and whether R54's recovery factor is evidence or authored>"
```

## Owned files

<!-- U1 was CANCELLED UNBUILT (f274f44): J12 answered the same question and `research/U1_RECOVERY_AND_THE_YEARS.md` was never written. It owns no file. The answer is in the path below. -->

```
research/J12_RECOVERY_AND_THE_YEARS.md
```

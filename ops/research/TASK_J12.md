# TASK J12 — DOES AN OLDER FIGHTER HEAL SLOWER? (John)

**Status: COMPLETE (2026-09-07).** Delivered:
`research/J12_RECOVERY_AND_THE_YEARS.md`. John landed it minutes before
a reassignment to Cursor went out; the reassignment (U1) was cancelled
unbuilt. Original assignment: Deep research, graded. **R54's
recovery half is waiting on this** — it is the one number in that task that
might actually be sourceable, which is why it gets its own study instead of
being invented.

Model: top tier, effort high, Fast off.

Deliverables: `research/J12_RECOVERY_AND_THE_YEARS.md` plus
`research/CLAUDE_LAND_NOTE_J12.md`, in the shape J10 used. **Never edit
`HANDOFF.md`** — Claude writes your block. Mailbox line when it lands.

## Why this exists

`BodyReadiness.gd` heals a torn-up body at a rate that reads the activity and
nothing else. A 41-year-old and a 19-year-old recover identically, which is
the difference the player would feel most in a veteran's week — and the game
is about to author a number for it. J10 §2 could not source yearly stat
deltas or a retirement formula and correctly refused to invent them. **This
one may be different**: recovery and age is a real physiology literature, not
a fight-record inference.

Your answer decides whether R54's recovery factor is evidence or another
authored shape.

## The questions

**Q1 — Does recovery from training load slow with age, and by how much?**
Time-course of recovery from a hard session — soreness, force restoration,
readiness to train again — across adult ages. Masters-athlete literature is
fair game; say plainly when a finding is from runners or lifters rather than
fighters, and grade it INHERITED rather than DIRECT.

**Q2 — Does healing from INJURY slow with age?** Distinguish this from Q1.
The game models six body regions healing over weeks, so the useful shape is
"weeks to return", not "muscle protein synthesis". Soft tissue, bone,
concussion/RHI return-to-play — do the clinical return windows actually
lengthen with age, and in what steps?

**Q3 — Where are the thresholds, if there are any?** The game currently uses
30 and 33 as bare cutoffs in one module (R52 is removing them). Does the
evidence support a threshold at all, or is it a gradient? If it is a
gradient, is it linear across the adult range or does it bend somewhere?

**Q4 — Is it the years or the mileage?** Career length, total bouts,
accumulated damage and rounds fought are all confounded with age. Is there
anything separating chronological age from accumulated load? If not, say so —
that matters, because the game HAS both numbers (`age` and the fight history)
and could key off either.

**Q5 — The medical hold.** J10 established that commission holds outrank
folklore. Do ARP / NSAC / ABC-family rules lengthen a mandatory suspension by
age, or require extra clearance for an older fighter? A rule is DIRECT
evidence in a way a study is not.

**Q6 — Does anything RECOVER better with age?** Ask it honestly rather than
assuming decline. If experience, pacing or training economy offsets any of
it, that is worth as much to the design as the decline.

## The bar — J10's, which worked

- Grade every claim: **DIRECT / INHERITED / UNVERIFIED_SECONDARY /
  UNKNOWN.** A number without a grade is not deliverable.
- **The could-NOT-source list is first class.** Do not pad it away and do not
  fill a gap with a plausible figure.
- **Do not average populations that should not be averaged** (J10 D6): sex,
  sport, injury type and amateur-vs-pro stay separate.
- Give Claude a lift-ready section: what `Aging.recovery_scale()` could
  honestly encode, with each row's grade attached, plus an explicit "do not
  encode this" list.
- Close with a decisions page (D1, D2, …) and any operator question you want
  answered before Claude authors anything.

## What NOT to do

- Do not propose a game multiplier as researched. If the honest answer is
  "the game must author this", say that and label it UNKNOWN — that is a
  complete and useful answer, and it is what R54 will act on.
- Do not write `.gd`, data files, or `HANDOFF.md`.
- Do not assume a repo checkout: you have no token and cannot clone. Every
  file path above is a deliverable you write, not a file you must read.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/J12_RECOVERY_AND_THE_YEARS.md
```

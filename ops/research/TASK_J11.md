# TASK J11 — WHAT HAPPENS AFTER THE LAST FIGHT (John)

**Status: COMPLETE (2026-09-07).** Delivered: `research/J11_AFTER_THE_LAST_FIGHT.md`. Deep research, graded.

Model: top tier, effort high, Fast off.

Deliverables: `research/J11_AFTER_THE_LAST_FIGHT.md` plus
`research/CLAUDE_LAND_NOTE_J11.md`, in the shape J10 used. **Never
edit `HANDOFF.md`** — Claude writes your block. Mailbox line when it lands.

## Why this exists

J10 (yours, 2026-09-07) answered when a career peaks and why it ends, and
its §2 correctly refused to invent what it could not source. R51b then
shipped the mechanic: a fighter asks to retire, the player answers, and a
granted retirement moves them off the roster into the world population with
`status: "retired"`.

**And then nothing.** The game has no idea what a retired fighter does next,
and the gym has no idea what it just lost or gained. Two of J10's own
could-not-source entries (#12 the frequency ranking of why careers end, #14
how often a retirement is reversed) sit next to this question but do not
answer it.

## The questions

**Q1 — Do they stay in the sport?** After the last professional fight, what
share of fighters remain in combat sports in ANY role — coach, cornerman,
matchmaker, cutman, commentator, promoter, gym owner, official, ambassador —
and how soon after retiring? If the rate is not sourceable, say so and give
what IS sourceable (case classes, federation coaching-licence pathways,
commission second's-licence requirements).

**Q2 — Does the gym keep them?** Is there any evidence on former fighters
returning to or staying with the gym that trained them, versus leaving the
sport or moving to another camp? This is the one the game most needs: a
retired fighter becoming staff at the player's gym is a mechanic that lives
or dies on whether it is real.

**Q3 — The comeback.** J10 #14 flagged that no population rate exists for
reversed retirements. Push once more, then rule it: is there ANY defensible
figure, in any single sport or commission dataset, for how often a licensed
retirement is reversed and how long the layoff was? If not, say UNKNOWN and
say what a game may honestly do instead.

**Q4 — Does a coach's own fighting record predict anything?** Whether a
former elite fighter makes a better coach is the kind of claim that is
everywhere and sourced nowhere. Find out which it is.

**Q5 — Licensing and age.** What do the ARP / NSAC / ABC-family rules
actually say about licensing an older fighter, a returning fighter, and a
fighter moving from competing to cornering? J10 established that the medical
hold outranks folklore; extend that to the exit.

**Q6 — What does the sport call them?** The vocabulary a real gym uses for a
retired fighter who is still around. The game currently has no word for this
person, and a wrong word is a design decision made by accident.

## The bar — the same as J10's, which worked

- Grade every claim: **DIRECT / INHERITED / UNVERIFIED_SECONDARY /
  UNKNOWN.** A number without a grade is not deliverable.
- **The could-NOT-source list is first class.** J10's §2 was as useful as
  its tables. Do not pad it away and do not fill a gap with a plausible
  number.
- **Do not average populations that should not be averaged** (J10 D6). Sex,
  sport, era and amateur-vs-pro stay separate.
- Give Claude a lift-ready section: what a module could actually encode,
  with each row's grade attached, and an explicit "do not encode this"
  list.
- Close with a decisions page (D1, D2, …) and any operator question you want
  answered before Claude authors anything.

## What NOT to do

- Do not propose game numbers as researched. If the honest answer is "the
  game must author this", say that and label it UNKNOWN.
- Do not write `.gd`, data files, or `HANDOFF.md`.
- Do not assume a repo checkout: you have no token and cannot clone. Every
  file path above is a deliverable you write, not a file you must read.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/J11_AFTER_THE_LAST_FIGHT.md
```

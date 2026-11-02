# TASK J6 — THE ATHLETE'S OWN LEDGER: WHAT COMES OUT OF THE PURSE (John)

**Status: OPEN, assigned 2026-09-06.** Research only. Sequel to J4 and J5 —
read your own J4 (E1–E34) and J5 (G1–G34) rulings before you start and **do
not re-derive them**.

Model: top tier, effort high, Fast off.

## Why this exists

R43 shipped J4's rank 1: the payee is the athlete. The bout-agreement money —
show purse, win bonus, performance bonus, gate share — now lands in
`athlete["cash"]` instead of the gym's account. J5 then answered the other
half, what the *gym* lives on, and refused to invent a gym cut to fill the
hole.

That leaves one question nobody has asked: **the athlete now holds the money,
so what comes out of it before it is theirs, and which of those deductions is
published anywhere?** Today the settlement subtracts a single opaque
`expenses` term and calls it done. If that term is invented, the game is
lying in a new place — the same defect J4 found on the gym side, moved one
seat over.

This must not be answered by guessing. "Nothing is published, ship nothing"
is an acceptable answer for any area, exactly as it was in J5.

## The four areas

**Area 1 — What the commission itself takes at the event.** Licence fees a
contestant pays to be licensed in the event state, any per-bout fee, and
whether anything is withheld from the purse at the table by the commission
rather than paid separately. Cite the statutes and regulations you can
retrieve (NV `NRS 467` / `NAC 467`, CA `BPC 18xxx` / `4 CCR`, NJ
`N.J.A.C. 13:46`, NY `19 NYCRR`), and mark exact current dollars UNKNOWN
where the printed figure and the live section disagree — you did exactly this
for the California gymnasium licence in J5 G5 and it was the right call.

**Area 2 — Tax withholding at the event.** Whether a combatant's purse is
withheld against at source, for residents and for non-residents, and whether
this is a commission function at all or a promoter/state revenue one. This is
where a manager game usually invents a flat percentage. Say plainly whether
any figure is publishable and whether it belongs in this game **at all** —
"a tax model is scenery, show nothing" is a legitimate ruling and may well be
the right one.

**Area 3 — The fighter-side people who are paid out of the purse.** Trainer,
cutman, seconds, and the manager share. J4 E4 already ruled corner work is a
fighter/manager expense, not a promoter wage, and J5 G11–G13 ruled the gym is
not a published payee for supplying them; **do not reopen either.** The
question here is the *order and the ceiling*: when a filed manager share, a
trainer's cut and the state's own deductions all point at one purse, what does
the published record say about what may be taken and in what sequence, and
what is simply customary. J4 E2's caps are stored and are not re-derived.

**Area 4 — What the athlete pays between bouts.** Annual/biennial licence
renewal, the medicals a licence requires (bloodwork, eye exam, MRI/MRA where
a commission mandates one), and gym membership from the athlete's side — the
mirror of J5 Area 1, now with a payer who has a wallet. Same discipline: a
commission that *mandates* a medical without publishing a price gives you the
requirement, not the number. J5 G24's rule holds — no sport-wide dollar
without `evidence`.

## What the deliverable must contain

1. A **Decisions page** of operator calls, numbered **A1–A18** so nothing
   collides with J3 D1–D16, J4 E1–E34 or J5 G1–G34. One recommendation and
   one line of reasoning each.
2. **File-level anchors**: what is live in the game versus what this study
   describes. The settlement site is `GameState.gd:10253` and the athlete
   wallet is `athlete["cash"]` / `get_athlete_cash()` at `:10275`. **Find and
   name what the current `expenses` term at settlement actually is** — where
   it comes from, whether any published thing backs it, and whether it should
   survive. That single finding may be the most valuable line in the pack.
3. Per area: decisions coming, evidence with an explicit UNKNOWN discipline,
   what the game does today (honest / invented / absent), one minimum change,
   and issues each with a solution.
4. A **priority ruling** in plain words: after R43, what does a fighter
   actually keep, how much of the deduction side ships without inventing a
   number, and does any of it outrank J5's rank-2 membership object. Rank the
   next twelve months as build / research / wait a year / scenery.
5. **Test assertions numbered A19–A34**, contracts for a later PR, in the
   shape of J5 G19–G34.
6. A source list with live-verification dates.

## Rules

- You edit no `.gd`, no `.tscn`, no `Godot/assets/data/`, and never
  `HANDOFF.md`. Claude writes your block.
- Do not reopen R40, J3 Areas 1–3, J4 E1–E3 or J5's priority ruling.
- No invented percentages, no invented dollars, no real person's or real
  gym's name as data (J5 G34).
- "Less than you'd think, and most of it unpublishable" is an acceptable
  answer. Say it plainly if it is the true one.

## Deliverable

- `research/J6_THE_ATHLETES_OWN_LEDGER.md`
- `research/CLAUDE_LAND_NOTE_J6.md`
- Staging copies in `_john_delivery/`

Message Claude on the mailbox when it lands.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/J6_THE_ATHLETES_OWN_LEDGER.md
research/CLAUDE_LAND_NOTE_J6.md
```

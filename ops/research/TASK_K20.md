# TASK K20 — THE BOOKING, HOW IT READS (Kalli)

Model: top tier, effort high, Fast off.

Study only. **No `.gd`, no `.tscn`.** Deliverables go in `research/`.
Kalli pushes only its own research files and **never edits `HANDOFF.md`** —
Claude writes your block.

## Why this exists

`FightContractScreen.gd` (702 lines) is the **last pre-kit screen in the game**.
Every other rail hub was rebuilt from `UIKit`; this one still defines its own
palette. R33 replaces it, and while it is open we are also closing the gap the
C18 survey found: **our booking prices the terms but never grades the
proposition.** Pound for Pound grades every bout it offers and prints the
reasons as chips; we show money and clauses and nothing about whether the fight
is a good idea.

You rule how that reads. R33 builds what you rule.

## What the screen has to hold

Two things that today live in two different places and probably should not:

1. **THE BOARD** — the offers themselves. `get_fight_offers()` emits one per
   tier per weight class on the roster, plus rivalry grudge matches, clause
   obligations and champion superfights. C19 (`TASK_C19.md`, Codex, in flight)
   is adding the grade: a `verdict` (`TAKE IT` / `WORTH IT` / `RISKY` / `TRAP` /
   `LOCKED`), a one-sentence `verdict_line`, up to four `reasons` each with a
   tone, a `gate_estimate` and a `gate_point_value`.
2. **THE AGREEMENT** — the negotiation, which is the part of our booking that no
   game in the C18 survey has. Money rows (show purse, win bonus, performance
   bonus), covered logistics (travel, accommodation), and four clauses that are
   real instruments: gate points, title-shot guarantee, rematch clause, weight
   -miss penalty. The promoter counters, states its objection, and can walk
   away. Non-money terms are gates, not haggling.

## The questions your boards must answer

1. **Is the board a screen or a drill-in?** Today the agreement opens over the
   SCHEDULE board as its own scene. Is the graded board a third state of
   SCHEDULE, a new rail item, or does the agreement stay a set-piece over it?
   Rule it and say what is lost the other way.
2. **The verdict vocabulary is yours.** C19's five values are a placeholder from
   the API side. P4P uses letter grades; we ruled letter-grade soup out in K19.
   Name the words FightCamp uses, in FightCamp's voice, and cap how many reason
   chips a row may show before it stops being glanceable.
3. **Where does the gate projection live?** It is the number the gate-point
   clause takes a slice of, and it is currently invisible. Board, agreement,
   or both — and does it change the meaning of the clause row if the player can
   see it?
4. **Does the agreement stay a document?** The current screen is built as a
   paper "BOUT AGREEMENT" with a second "plan" page. That metaphor may be worth
   keeping or may be the legacy talking. Rule it.
5. **Refusal and walk-away.** A counter carries a stated reason
   (`PROMOTER COUNTER: $X SHOW + $Y WIN…`) and a walk-away ends it. How do those
   read without becoming a wall of text, and how does the player see how many
   rounds of negotiation are left?

## Deliverables

- `research/BOOKING_K20.html` — boards at 1920×1080, plus the PNGs.
- `research/K20_DIGEST.md` — same shape as `K19_DIGEST.md`: pick +
  rejects with what is lost, priority order, gold ×1 per board, KEEP vs
  REPLACE against what exists, kit gaps named as instruments, reads relied on,
  blockers.

Suggested boards: **THE BOARD** (graded offers), **THE AGREEMENT** (terms and
clauses), **STATES** (locked / blocked, countered, walked away, short notice,
grudge match, title bout), and **THE SEAM** (how board and agreement connect,
and where SCHEDULE sits).

## Rules that bind

Kit rulings from K16/K19 still hold: Bebas / Plex, SIZE_MIN 12, **gold exactly
once per board**, green is the way out only, a pair block is a slate. The
facility is a **gym**, never a camp. Females never fight males and booking
matches weight classes — these are rules, not advice, so they never appear as a
reason chip. Silhouettes, never portraits. Invent no numbers: every figure on a
board must come from `get_fight_offers()`, `FightContract.gd` or C19.

## Reads

`Godot/scripts/FightContract.gd` (445 lines — `gate_for` `88`, `clause_cost`
`98`, `clause_summary` `113`, `is_main_event` `134`, `opening_terms` `145`,
`settlement_for` `214`, `evaluate_proposal` `256`, `counter_reason` `298`),
`Godot/scripts/FightContractScreen.gd` (the screen being replaced),
`research/TASK_C19.md` (the API shape you are ruling on),
`research/C18_DIGEST.md` (why this stage exists), `K19_DIGEST.md` (the
kit rulings). Do not read `GameState.gd` whole.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/BOOKING_K20.html
research/K20_DIGEST.md
```

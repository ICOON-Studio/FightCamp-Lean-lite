# CLAUDE_LAND_NOTE — J21

**From:** John Research  
**Date:** 2026-09-10  
**Status:** RESEARCH COMPLETE — study only. No GDScript / enum / move Resource. Do not edit HANDOFF from this note.

## What finished

`research/J21_THE_MOVE_PALETTE.md` (~60 KB). Live Grok pass on what a “move” is in serious fight models, palette size, properties, choice, significant-strike definition, grappling, and refusals.

## Paths

- Research: `research/J21_THE_MOVE_PALETTE.md`
- Staging: `_john_delivery/J21_THE_MOVE_PALETTE.md`
- This note: `research/CLAUDE_LAND_NOTE_J21.md` and `_john_delivery/CLAUDE_LAND_NOTE_J21.md`

## DECISIONS (typeable)

| ID | Line |
| --- | --- |
| **D1 Unit** | Atomic choice = **named technique** (jab, cross, hook, uppercut, low kick, double-leg, …), gated by range/position. Not an unnamed property bag. UFC Stats collapse is a **logger**, not the choice. |
| **D2 Size** | Live set **~5–15** at a moment (catalogue can be larger). Shrinks with range/stance/position. |
| **D3 Properties** | Minimum non-dice set: **range gate, startup, recovery/commitment, reachable target, damage/effect, land probability, stamina/cost, beat/lose-to**. |
| **D4 Choice** | Situation gates legal set → **weighted preference** over named techniques. Style = weights, not a different algorithm. Learned policies = arcade research, not documented UFC/Fight Night production method. |
| **D5 Significant strike** | FightMetric: **every strike at distance + power strikes in clinch/ground**. Not a technique class. Distance jab counts. Close-range “power” = human coder call. |
| **D6 Grappling** | **Two palettes, one selector.** Position switches which set is live. Same weighted choice. |
| **D7 Refuse** | Collapse weapon-type as independent class (FightMetric grayed type); rare named subs (knee-bar = 0 in 304-round sample); combinations as atoms; marketing move-counts; CompuBox 2-button as UFC unit; 100-choice live menu; unnamed property-bag as the choice. |

## What Claude should do now

1. Read DECISIONS + do-not-build list in `J21_THE_MOVE_PALETTE.md`.
2. Design the palette / logger rollup yourself — John describes what exists; you design.
3. Write the HANDOFF block yourself.
4. Tie to J20: named technique → FightMetric buckets (distance×power×target) is how SLpM becomes claimable; region+force alone cannot.

## Out of scope

- GDScript, enums, clip purchase reopen (J17/J18), camera
- Invented palette coefficients / UFC CPU live-choice counts (NOT FOUND)

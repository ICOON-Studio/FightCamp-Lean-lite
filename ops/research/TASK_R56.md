# TASK R56 — CLAUDE — THE AMATEUR BOARD: WHERE THE FIRST FIGHT COMES FROM

**Status: COMPLETE (2026-09-07).** The surface half of the amateur cycle.
**Runs LAST.** It consumes all three of the others: U4's D-list (Cursor) rules
what it must be true to, C39's reads (Codex) are what it prints, and G14's
`AmateurMatchmaking.gd` (Grok) is spliced here — this task is where the module
gets its first production caller.

Model: Opus, effort high, Fast off. One session, opened fresh after the other
three have landed.

## Why this exists

C39 gives the game an amateur circuit with real people on it and no way to see
it. G14 gives it a matchmaker's verdict on a pairing and no caller. U4 rules
how a fight is made and nothing renders the answer. R56 is the screen.

The player's fighter can now be an amateur, and the whole texture of that
level — you are not being offered a purse, you are being offered a fight; the
question is not "is it worth it" but "is it even a fight" — has no surface.

## What ships

**1. The amateur board.** `ScheduleHubPanel.gd` (1,724 lines) already has the
graded booking board R33 built on K20's ruling: the OFFERS tab
(`TAB_LABELS:49`), `_offer_rows()` (`:774`), `_build_offers()` (`:795`) and the
`UIKit.booking_offer_row` call at `:826`. The amateur bouts from
`get_amateur_bouts()` belong on that board and must read as a different KIND of
thing, not a cheaper tier of the same thing — no purse column, an entry cost or
an honest UNKNOWN where the purse would be, and the opponent's amateur record
where the rating would be.

**2. The matchmaker's line.** Every amateur row carries G14's
`AmateurMatchmaking.assess()` verdict — the grade and its one-sentence `line`.
An `unsafe` pairing is shown and named as unsafe; it is not silently hidden.
`unknown` fields are printed as unknown. This is the splice: G14 has no other
caller, so **run the full suite after wiring it** and report the module's
first real result.

**3. The record, twice.** The FIGHT RECORD tab of `ProfileRevampPanel.gd`
(`:1209`, and `_fill_rivalries` at `:1259` for the shelf pattern) shows one
record today. It shows two after this: the amateur record and the professional
one, both permanent, per C39's split at the settled-bout write.

**4. The door, with a warning in front of it.** C39 ships `_turn_pro()` and its
two causes. U4's Q6 rules the moment and the wording. This task puts the
irreversible step behind a confirm the player cannot walk into by accident, in
whatever form U4 ruled.

## Rules

- Everything is built from `UIKit.gd` + `UITokens.gd`. No new token and no new
  UIKit factory unless the kit genuinely cannot express it — R50's precedent
  (band by ink weight, because every hue already means something) is on the
  table.
- One figure once per screen. Age in the header. Pair blocks never in the
  header colour.
- A `Label` outside a Container does not autowrap: break lines with `\n`.
- A Control with full-rect anchors must never have `size` assigned when it is
  mounted (R31). Set `expand_mode` and `stretch_mode` on a `TextureRect`
  BEFORE `texture`/`size`.
- `remove_child(node)` before `queue_free()` on any rebuild.
- Read U4's D-list before drawing anything, and cite the D-numbers you obeyed
  in the digest. Where U4 and this file disagree, U4 wins.

## Owned files

- `Godot/scripts/ScheduleHubPanel.gd`
- `Godot/scripts/ProfileRevampPanel.gd`
- `Godot/tests/amateur_board_test.gd` (new)
- `research/R56_DIGEST.md` (new)
- the G14 splice — running `AmateurMatchmaking.gd` for the first time and
  reporting it; fixing the module only if the suite says so.

Not `GameState.gd` (C39's), not `EntityPathway.gd`.

## Gate and tests

```bash
python Godot/tools/check_scripts.py Godot/scripts/ScheduleHubPanel.gd Godot/scripts/ProfileRevampPanel.gd Godot/tests/amateur_board_test.gd
```

Then `amateur_board_test.gd`, `amateur_circuit_test.gd`,
`amateur_matchmaking_test.gd`, then the full suite once in the background
before the commit.

## The one trap

**The amateur board must not become a worse fight-offer board.** If the rows
end up as the same `booking_offer_row` with a zero in the money column, the
stage has shipped nothing — the player will read "free fight" and move on. The
thing being drawn is a level where money is not the axis at all, and U4's Q1
and Q2 rulings are what tell you which axis replaces it.

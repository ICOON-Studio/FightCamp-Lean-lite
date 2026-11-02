# TASK R69 — THE BELT SAYS WHOSE IT IS, AND WHAT IS ON THE LINE (claude)

Model: top tier, effort **high**, Fast off. One session.

## Why this exists

R68 gave every belt a sanctioning promotion. Exactly one surface reads it — the
CHAMPIONS board. Two things are still unsaid, and one of them is a read that
was built and never called:

1. **A champion's own card says only `holds_title: true`.** Two seams
   (`GameState.gd:6018`, `:6567`) publish a bare boolean. A fighter who holds a
   belt cannot say WHICH belt, and now cannot say whose.
2. **`get_bout_title_stakes()` has no caller outside `GameState.gd`.**
   `ChampionshipRead.bout_stakes()` decides whether a bout is a title bout and
   what belt is on it, and nothing draws it. This is C41's problem again — the
   kit nobody calls.

R68 makes both worth fixing at once: a title bout should say *the promotion's*
belt is on the line, not just "TITLE".

## What to build

**Part 1 — the card names the belt.** Beside the existing `holds_title`
boolean (**keep it, additive only, R62's rule**), publish the belt itself: its
`division_label`, its `title_status`, and R68's `organization` block. Reuse
`get_athlete_titles()` and `ChampionshipRead`; do not re-derive a belt from the
championships dictionary by hand.

**Part 2 — the title bout says what is on it.** Draw `get_bout_title_stakes()`
on the surfaces that already announce a bout: the fighter's own profile where
the next bout is shown, and `FightContractScreen.gd`. A bout that is NOT a
title bout must draw nothing at all — `bout_stakes` returns
`is_title_bout: null` for an unstamped bout, and null is "not decided yet",
never "no".

**Part 3 — one standing order, not two.** ~~`PromotionsBoard.sort_by_standing_in_sport()`
(R50) and `WorldPopulation.promotions_by_standing()` (R68) are two different
answers to "which promotion is bigger".~~ **MOVED TO U11, 2026-09-08.** Both
task files claimed this and only one of them owns the file it lives in: the
duplicate ordering is inside `PromotionsBoard.gd`, which is Cursor's under U11.
Two agents editing one file to agree on one order is the collision, not the
fix. R69 does not touch it.

## Owned files

```
Godot/scripts/GameState.gd
Godot/scripts/ChampionshipRead.gd
Godot/scripts/ProfileRevampPanel.gd
Godot/scripts/FightContractScreen.gd
Godot/scripts/WorldPopulation.gd
Godot/tests/championship_read_test.gd
Godot/tests/profile_revamp_test.gd
Godot/tests/fight_contract_screen_test.gd
research/R69_DIGEST.md
```

**Not owned, do not edit:** `Godot/scripts/PromotionsBoard.gd`,
`Godot/scripts/OfficeHubPanel.gd`, `Godot/scripts/ScheduleHubPanel.gd` — Cursor
owns those under U11 and both tasks run at once.

`GameState.gd` is **13,900+ lines — never open it whole.** The seams:
`holds_title` at `:6018` and `:6567`; `get_athlete_title(s)` at `:10484`;
`get_bout_title_stakes` at `:10700`; the championship reads at `:10515-10620`.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/scripts/ChampionshipRead.gd Godot/scripts/ProfileRevampPanel.gd Godot/scripts/FightContractScreen.gd Godot/scripts/WorldPopulation.gd Godot/tests/championship_read_test.gd Godot/tests/profile_revamp_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/championship_read_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/profile_revamp_test.gd
```

Then the full suite once in the background before the commit. Fails=0 or better.

## The one trap

**`is_title_bout: null` is not `false`.** `bout_stakes` returns null for a bout
nobody stamped, and R38's whole discipline is that an undecided thing is not a
negative one. A screen that draws "NOT A TITLE FIGHT" on a null has invented an
answer the read deliberately refused to give.

# TASK C37 — CODEX — THE FORMER READ: WHAT A RETIRED FIGHTER STILL IS

**Status: COMPLETE (2026-09-07, `5fb6165`).** Runs after C36 (FORMER, yours) and
R53 (the retired profile, landed).

Model: top tier, effort high, Fast off. One session.

## Why this exists (verified 2026-09-07, not assumed)

C36 gave FORMER a tab and a row: `name · retired age · retired week`, opening
the profile by `athlete_id`. R53 then made that profile worth opening. Two
things are now true at once:

- **`FormerRoles.gd` (G11, `Godot/scripts/FormerRoles.gd`, 2.3 KB) has no
  caller anywhere.** Grok landed it 2026-09-07 with its own test. It answers
  what a fighter may do after their last fight — `roles_for()`,
  `licence_state()`, `comeback_gate()`, `exit_kind()`, `role_label()` — and
  nothing in the game asks it anything.
- **The FORMER tab reads `get_retirements()` raw** (`OfficeHubPanel.gd:188`,
  `:1169`, `:1195`) and folds the row by hand, while R53 added
  `get_career_epilogue(id)` and `get_aging_read(id)` — both of which now answer
  for a fighter who is off the roster — and neither is read here.

This task is the read model that closes both: **one projection that says what a
retired fighter still is**, and a FORMER row that spends it instead of
assembling one itself.

## Scope

1. **`GameState.get_former_fighters() -> Array`** — one read, newest first, one
   entry per retirement. Each entry folds, per fighter:
   - the retirement record `get_retirements()` already holds (week, age, name,
     record, reason, `athlete_id`);
   - `FormerRoles.roles_for()`, `licence_state()`, `exit_kind()` and
     `role_label()`, fed the facts **the save actually has**;
   - the closing facts from `get_career_epilogue(athlete_id)` — at minimum
     `years_active`, `bouts` and `epitaph`.
   Evaluate it the way your other read models do if any dependency migrates
   lazily: against a disposable `career` copy, restoring the live object before
   anything leaves the method. Return copies, never live references.
2. **`get_former_fighter(athlete_id) -> Dictionary`** — the same entry for one
   id, so the row and any later detail read the same shape.
3. **The FORMER tab spends the read.** `_build_former()` / `_former_row()` stop
   calling `get_retirements()` and stop folding by hand. The row gains, beside
   the facts it already prints, the **role label** and — only when the licence
   state actually knows — the licence word. It keeps opening the profile by
   `athlete_id`; R53 made that landing worth it.

## THE TRAP: "Not known." is the answer, and you must let it be

`FormerRoles._fight_block_reason()` returns **"Not known."** whenever
`licence_denied`, `medical_hold` or `head_trauma_flag` is missing or is not a
real `bool`. That is deliberate — G11's central design is that *a missing gate
is not a clean bill*.

The save carries a medical hold (`body_state.medical_hold_until_week`, and the
retired world record preserves `body_state` only if it was there). It carries
**no `licence_denied` and no `head_trauma_flag` at all.**

So for almost every retired fighter the honest answer is "Not known.", and the
row must print that or print nothing — **never** "CLEARED", never "CAN FIGHT",
never a default of `false` passed in to make the module cheerful. Do not invent
the two missing flags, do not derive them from the retirement reason, and do
not add them to the save in this task. If you pass a flag, pass it because the
save really holds it.

Assert this: a retired fighter with no licence data must NOT read as licensed.

## Owned files

- `Godot/scripts/OfficeHubPanel.gd` — **1,521 lines.** Yours from C36. The
  FORMER region is small and self-contained: `:66` (TABS), `:188` (the tab's
  data load), `:218`, `:1166`-`:1220` (`_build_former`, `_former_row`), `:1346`
  (`_on_former`), `:1441` (the counts), `:1466` (`open_former_for_test`). Read
  those windows with `sed -n 'A,Bp'`, not the file.
- `Godot/scripts/GameState.gd` — **13,3xx lines: NEVER open it whole.** You
  need three windows: `get_retirements` at `:7320`, `get_career_epilogue` at
  `:7398`, and `get_fighter_card` at `:11738` for the disposable-career pattern
  you established in C6. Everything else is off-limits.
- `Godot/tests/office_former_test.gd` (yours), and a GameState-side test for
  the new read — extend `office_hub_api_test.gd` rather than adding a file if
  it fits.

**Do not touch:** `FormerRoles.gd` (Grok's — compose on it, never edit it),
`CareerEpilogue.gd` (Grok's), `ProfileRevampPanel.gd`, `Aging.gd`,
`Retention.gd`, `BodyReadiness.gd` (Claude owns those four on R54 this same
cycle), `HANDOFF.md`.

## Settled

- No new OFFICE destination and no new rail item (K10, K24 5 standing). FORMER
  is the tab; this fills its row.
- **No hiring flow in this task.** Whether the gym can actually employ a former
  fighter as a coach is a system with staff records, salary and a licence
  check, and it is not this. This task says what they *are*; a later stage says
  what you can *do* about it.
- U2 Q5, landed 2026-09-07: **the FORMER list carries retirement facts only** —
  it is never "a lecture on how expensive or slow they were". No age cost, no
  price, no recovery, no wear chrome on this tab.
- M11: RETIRED is `MUTED` on `CHIP`/`TRACK`, never `BAD` and never `GOLD`. The
  row is a record, not an obituary.
- No new UIKit factory and no new token.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/scripts/OfficeHubPanel.gd
```

## Tests

```
--script tests/office_former_test.gd
--script tests/office_hub_api_test.gd
--script tests/office_hub_panel_test.gd
--script tests/former_roles_test.gd
```

Then the full suite ONCE in the background before the commit.

## Done

Commit and push `master`, write `research/C37_DIGEST.md` (short), send
one line with `python Tools/agent_comms.py send`. **Do not edit `HANDOFF.md`** —
Claude writes your block.

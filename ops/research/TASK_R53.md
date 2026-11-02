# TASK R53 — THE YEARS ARE SHOWN: THE AGE, THE ASK, THE LAST WALK (Claude)

**Status: COMPLETE (2026-09-07).** Digest: `research/R53_DIGEST.md`. The screen stage of THE YEARS.
Run AFTER R52 so the read quotes sourced windows.

Model: Opus, effort high, Fast off. One session.

## Why this exists (verified 2026-09-07)

R51b made a fighter age and a career end, and **none of it is on a screen**:

- `get_aging_read()` has no caller outside `Godot/tests/`.
- `get_retirements()` has no caller outside `Godot/tests/`.
- `CareerEpilogue.build()` (G9, `Godot/scripts/CareerEpilogue.gd`) has no
  caller anywhere. A finished career computes and is thrown away.
- The profile prints `AGE %d` twice as flat text
  (`ProfileRevampPanel.gd:584` in the identity chip, `:723` in the growth
  caption) and says nothing about where that age sits.

**One thing is already done and must not be rebuilt.** The retirement ASK
renders itself: the profile's request card reads `request.actions`
generically (`ProfileRevampPanel.gd:1374`, `:1414`, `:1455`), so a `retire`
request already shows GRANT / DECLINE and already answers. What is missing is
the beat AFTER yes, the age reading as something, and the retired fighter's
own profile.

## Owned files

- `Godot/scripts/ProfileRevampPanel.gd` — **2,214 lines: never open it
  whole.** Anchors below; read `sed -n 'A,Bp'` windows.
- `Godot/scripts/GameState.gd` — **12,9xx lines: never open it whole.** Only
  if a read needs a field it does not yet return.
- `Godot/tests/profile_revamp_test.gd`, `Godot/tests/aging_test.gd`.

**Do not touch:** `Godot/scripts/Aging.gd` (R52), `WorldPopulation.gd` (C34),
`CareerEpilogue.gd` (G9's, compose on it, never edit it),
`OfficeHubPanel.gd` (C36 owns it this week).

**Also fix here, left over from R52:** `_apply_birthday` computes
`band_before` with a sex-less `Aging.band_for(age, discipline)` while
`year_step()` now reads sex off the athlete, so a female fighter in a
discipline with its own women's row can take the "enters their peak years"
headline TWICE. Same mismatch in `get_aging_read()`. One argument each.

## Anchors

| file:line | what |
| --- | --- |
| `ProfileRevampPanel.gd:584` | identity chip, `AGE %d · CLASS · DISCIPLINE · …` |
| `ProfileRevampPanel.gd:723` | growth caption, `RATING … AGE %d` |
| `ProfileRevampPanel.gd:1374` | the request card's OPTIONS line |
| `ProfileRevampPanel.gd:1414` | the request card's action buttons |
| `ProfileRevampPanel.gd:1455` | `respond_to_request` call |
| `GameState.gd` | `get_aging_read`, `get_retirements`, `_retire_athlete` |

## The rulings this must obey — they are already made

**K24 (Kalli, `K24_THE_YEAR_TURN.md`):**
- **Decline is NEVER a word.** Never "declining", never "past peak", never
  "washed". `band_for()` returns `"declining"` — that string routes
  behaviour and must never reach a Label. R51b already enforces this in the
  news feed and in `band_line`; hold the same line on screen.
- The birthday is a **selective feed**: the profile HERO age updates
  silently; a ticker line only for a roster champion or the week's focused
  fighter.
- Retirement is **the ask plus room**: the attention strip and the ACTION
  ROW, then on YES a beat with space in the spirit of R45. **A vanish is
  dishonest and a modal breaks THE DAY's grammar.**
- The finished career is read **on the retired fighter's own profile**, not
  nowhere and not a new OFFICE destination.

**M11 (Maria, `M11_THE_LONG_CAREER.md`, boards
`DesignLibrary/screens/long_career/m11_01..06`):**
- **Age reads as INK WEIGHT, never as hue.** Name always `TEXT`; the age
  numeral steps `MUTED` (rising) → `TEXT_2` (peak) → `DIM` (veteran and
  retired). The phase chip is `CHIP` at full ink or `TRACK` recessed, with
  the word always printed.
- **Wear is not M6**: `TRACK` recess plus `LINE_SOFT` and DIM ticks. Never
  BAD / AMBER / GOOD — those stay the medical family's.
- RETIRED is `MUTED`, not BAD and not GOLD. G9's epitaph wears M8's `LINK`
  candour on a record plate, not an obituary.
- **No new token.** `SELECT` does not exist in `UITokens.gd`; use
  `GYM_DEFAULT` / `LINK`.
- **The hero mock reads "peak 2019" — do not build that literally.** The
  epoch is Monday 5 January 2026 and careers only run forward. The figure
  comes from `CareerEpilogue.peak_year`.

## Scope

1. **The age reads as something.** The identity chip and the growth caption
   take M11's ink weight from `get_aging_read().band`, and the phase chip
   prints its word. The read already carries `band_line`, `peak_from`,
   `peak_to`, `weeks_to_birthday`, `next_year` — spend them, do not
   recompute them in the panel.
2. **The beat after YES.** Granting a retirement currently returns `ok` and
   the fighter is simply gone from the roster. Give it K24's room: the
   answer lands, the profile stays up, and the career closes on screen.
3. **The retired fighter's profile.** A retired fighter still exists (they
   are in the world population with `status: "retired"`, `retired_week`,
   `retired_age`). Their profile reads **G9's `CareerEpilogue.build()`** —
   `build(athlete, rows, career_week, record_stats := {})`, composing on
   whatever `FightRecordStats.summarize()` already returned rather than
   recomputing it — on M11's record plate.
4. **`get_retirements()` is NOT yours.** K25 landed 2026-09-07 and ruled the
   gym's record of who it retired belongs under OFFICE; that is **C36
   (Codex), running in parallel in this same checkout**. The interface
   between you: C36 delivers a FORMER row that opens
   `ProfileRevampPanel` by `athlete_id`, and **you make the retired profile
   worth opening**. Do not build a second list, and do not edit
   `OfficeHubPanel.gd`.

## Settled

- No new UIKit factory and no new token (M11 + K10 standing).
- A Control with full-rect anchors must never have `size` assigned when it
  is mounted (R31), and a `TextureRect` needs `expand_mode` before
  `texture`/`size`.
- Scene scripts compile before the autoloads: reach GameState through
  `get_node_or_null("/root/GameState")` plus `has_method`, never the bare
  identifier.
- A `Label` outside a Container does not autowrap; break lines with `\n`.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/ProfileRevampPanel.gd Godot/scripts/GameState.gd
```

## Tests

```
--script tests/profile_revamp_test.gd
--script tests/aging_test.gd
```

Then `career_epilogue_test.gd`, `fighter_requests_test.gd`,
`day_feed_test.gd`. Then the full suite ONCE in the background.

## Done

Commit and push `master`, write `research/R53_DIGEST.md` (short),
convert this block in `HANDOFF.md` to COMPLETE, regenerate `TASKS.md`.
Report ends with the headless command above.

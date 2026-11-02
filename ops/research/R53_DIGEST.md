# R53 DIGEST — THE YEARS ARE SHOWN

Claude · 2026-09-07 · after R52. Owned: `ProfileRevampPanel.gd`,
`GameState.gd`, `profile_revamp_test.gd`, `aging_test.gd`.

## What shipped

**1. The age reads as something.** The hero's biodata row is now `AGE` (DIM
label) + the NUMERAL in M11's ink ladder (`MUTED` rising → `TEXT_2` peak →
`DIM` veteran and retired) + a phase chip, then the rest of the row in
`TEXT_2`. The chip is R50's grammar: full ink on `CHIP` inside the phase,
recessed onto `TRACK` with a `MUTED` word once it is behind them. The
ATTRIBUTES growth caption wears the same ink on its own age, and carries the
next birthday's net stat movement (`Aging.year_step` is deterministic, so it
is a fact, not a guess). A new hero line spends the read's `band_line` plus
the countdown to the next birthday. The name stays `TEXT` — greying it for
age is caricature by type — and no medical hue is borrowed.

K24 is enforced in the test, not just in the comments: `DECLIN`, `PAST PEAK`
and `WASHED` are swept out of every Label on the hero. The band string
`"declining"` routes behaviour; the printed word comes from the read's new
`phase` field (`RISING` / `PEAK` / `VETERAN` / `RETIRED`).

**2. The beat after YES.** `_answer()` reads the ask's KIND before answering
(a granted retirement leaves nothing on the card to ask afterwards), rebuilds
the now-retired profile underneath, and mounts `_last_walk()`: a quiet plate —
name, RETIRED chip, the exit line, final record, years active, bouts, peak
year, and a plain RETURN TO THE DESK. No GO, no GOLD, no BAD, no era banner.

**3. The retired fighter's profile.** For a retired fighter the overview's
third frame is THE FINISHED CAREER instead of STANDING (there is no division
table, pay tug or goal left to draw), and the hero's NOW cluster is replaced
by the closing facts instead of four dials reading zero and a CLEARED badge.
The plate is M11 §4: labelled `pair` fields (years active, bouts, peak year,
debut), one defining-win bout line, and G9's authored epitaph on `TRACK`
behind a `LINK` edge.

## GameState

- `get_aging_read()` and `_apply_birthday()` now pass the athlete's **sex** to
  `Aging.peak_window` / `band_for` (the R52 leftover: the band BEFORE a
  birthday used the sex-less window while the step AFTER it used her own, so a
  woman could enter her peak years twice — women's wrestling is 20-28 against
  the men's 23-29). Covered by a regression check.
- The read answers for a **retired** fighter (falls through to
  `get_world_athlete_by_id`), returns `phase`, `sex`, `grade`, `retired`,
  `retired_week/_age/_reason`, and gives a finished career no retirement
  pressure and no next-birthday preview.
- `get_career_epilogue(id)` **composes** on G9 — `CareerEpilogue.gd` is
  untouched — handing it the rows and the `FightRecordStats` fold the caller
  already has.
- `get_fighter_card()` carries `aging` and `epilogue`, so R23's card-only
  invariant holds: the profile still makes exactly one read per rebuild.
- `get_fight_log()` falls back to the world record when the roster does not
  hold the id. G7 builds from `get_athlete()`, which is the roster, so without
  this every retired fighter read as a career that never happened — epitaph
  "Never stepped through the ropes." on a 2-1 record. The module is untouched.
  The lookup only runs for an id the roster does not hold.

## Not done here, on purpose

`get_retirements()` is C36's (K25: the gym's record of who it retired lives
under OFFICE). No second list was built and `OfficeHubPanel.gd` was not
touched. C36 delivers a FORMER row that opens this panel by `athlete_id`.

No new UIKit factory, no new token, no new rail item.

## Correction, same day

R53 shipped the age numeral in four places on one screen - the hero label, the
leading subject of `band_line` on the hero's years line, the ATTRIBUTES growth
caption, and `AGE n` on the record plate. The standing rule of 2026-09-04-03 is
that **a figure appears ONCE per screen** ("FAME B+ in the hero over OVERALL B+
in a panel: pick one place"), and I had read "figure" as a human figure rather
than as a number. Found while writing `.cursor/rules/30-design.mdc`.

Fixed: the hero keeps the one ladder-inked numeral. `_window_words()` cuts
`band_line`'s leading subject so the years line prints the window only; the
retired exit line states the week and not the age; the growth caption keeps its
progression numbers and drops the age; and the record plate spends that space on
WHY the career ended, the one fact not already on the screen. Four assertions in
`profile_revamp_test.gd` hold the line.

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/profile_revamp_test.gd
```

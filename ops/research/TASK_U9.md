# TASK U9 — CURSOR — THE INJURY ON THE SCREEN

Model: **Cursor Grok 4.6**, effort **high**, Fast off. One session, one
branch. (Cursor's Other Models pool - Claude and GPT - is spent until
2026-10-07; Grok 4.6 sits on the untouched Cursor Models meter and is a
top-tier model, so this task is NOT simplified.)

**RUNS LAST of your four.** U5 and U6 landed on master 2026-09-08; **U8 ships
before this one** — it is in `ProfileRevampPanel.gd`, which this task also
edits (U6 already edited `ScheduleHubPanel.gd`, the other file here). **Blocked
by R59 (Claude)** — the save has no named injury until R59 lands. Start it when R59's digest is in `research/R59_DIGEST.md`; if you
open the file and `body_state` has no `injuries` key, stop and say so rather
than inventing the shape.

## Why this exists

R59 gave the body a name. J13 (DA1) ruled that a region carries a 0-100 number
**and**, when tissue is actually hurt, a named injury that owns the timeline —
a return-to-training week, a later return-to-competition week, a treatment
path and the clearances it needs.

None of that is on a screen. Today the BODY LAB draws six numbers and a hold
banner whose words come from `_hold_reason_words()`
(`ProfileRevampPanel.gd:2020`), and the schedule's amateur board carries the
hold as a bare `held_until_week` integer (`ScheduleHubPanel.gd:845`). A player
sees that a fighter cannot be booked until week 47 and never learns why.

## Owned files

- `Godot/scripts/ProfileRevampPanel.gd` — **2,901 lines, NEVER open it whole.**
  Anchors: the region map const at `:41`, the body read taken at `:244`
  (`_call("get_body_read", [id])` — the established path for this tab, keep
  it), `hold_reason` unpacked at `:216`, `_hold_reason_words:2020`,
  `_refusal_rows:2029`, `_build_body_lab:2073`, `_fill_regions:2115`, the hold
  banner at `:2237-2251`, the TRAINING / COMPETITION pair at `:2253-2259`,
  `_fill_recovery:2293`.
- `Godot/scripts/ScheduleHubPanel.gd` — **2,034 lines, NEVER open it whole.**
  Anchors: the kind filter at `:58` (`MEDICAL` already exists), the amateur
  fighter dictionary at `:838-847`, the booking path noted at `:1083`.
- `Godot/tests/profile_revamp_test.gd`, `Godot/tests/body_region_screen_test.gd`,
  `Godot/tests/schedule_hub_panel_test.gd`.

Read whole (small, and you need their exact shapes): `Godot/scripts/Injury.gd`,
`Godot/scripts/InjuryWords.gd` (Qwen's Q3, LANDED) and
`Godot/scripts/RecoveryWords.gd` (Qwen's Q4, LANDED 2026-09-08).

**RecoveryWords is the second half of the vocabulary and it landed after this
task was written.** It owns where a body STANDS: `phase_word` for
`acute`/`rehab`/`cleared`/`unknown`, `ceiling_word` for
`injury_pre_training`/`injury_pre_competition`, plus `phase_line` and
`region_line`. InjuryWords owns the injury's LABELS. Between them there is no
phrasing left for this panel to invent - if you find yourself writing a third
copy of these words, take them from the module instead. Note `region_line`
takes the region's already-worded name as an argument; the panel passes it in.

## The work

**1. The region says what it is.** In `_fill_regions` (`:2115`), a region
carrying an injury prints the name beside the number. The number stays the
headline — it is the training-load object and it did not change meaning. A
region with no injury prints exactly what it prints today; **no empty label, no
"NONE" row**, nothing added to a clear body.

**2. The two dates, and the honesty rule.** An injury owns
`train_week` and `compete_week`, and they are different dates —
return-to-training is not return-to-competition. Print both, as weeks.

Every number the injury carries also carries a `grade`, and the grade decides
the WORDS, never the layout:

- `DIRECT` — a real published rule. State the week flatly.
- `AUTHORED` — the game's own number. Say it is the gym's estimate.
- `UNKNOWN` — `weeks` is 0 and there is no date. Print `NO DATE SET`.

**The grade words themselves never reach the screen.** `AUTHORED` is not a
word a player reads; "THE GYM ESTIMATES" is. If Q3's `InjuryWords.gd` has
landed, take the labels and this phrasing from it. If it has not, print the
`type_id` in caps and write the three phrasings inline — one small block, so
Q3 can replace it later without touching layout.

**3. The banner says why.** The hold banner at `:2237-2251` keeps its shape and
gains the diagnosis and the region: the hold is one clock and it now has a
name. `_hold_reason_words()` keeps its em-dash for a hold the save cannot name
— old saves and unnamed holds both still exist, and C37's ruling stands: not
known is a correct answer, and the screen never invents a diagnosis. Add the
clearance it waits on (physician, specialist, ophthalmologist) as a chip row,
only when the injury names one.

**4. The board says it too.** On the schedule, a fighter the medical hold
refuses currently shows a week. Give that row the injury's name and its
region — the same words as the profile, so a player reads one vocabulary in two
places. The `MEDICAL` kind filter at `:58` already exists; nothing new is
invented there.

## Refusals

- **No new UIKit factory, no new token.** `UIKit.caps`, `UIKit.display`,
  `UIKit.block`, `UIKit.chip`, `UIKit.pair` cover this. C41 audited the kit and
  found it already oversupplied.
- **No arithmetic in the panel.** Weeks remaining, the max of two ladders, the
  resolve-on-region rule: all of it is `Injury.gd` and R59's read. The panel
  positions and prints.
- **No second GameState call.** The body tab takes `get_body_read` once at
  `:244`. Do not add a second read beside it, and do not reach for
  `get_athlete()` to fill a gap — if the read cannot answer, the screen says so.
- **No medical prose.** No anatomy beyond the type name, no ICD codes, no
  advice, no severity adjectives that read as a prognosis. This is a management
  game, and J13 refused gruesome detail explicitly.
- **No judgement, K24.** Never "fragile", never "injury-prone", never a grade
  on the fighter. A repeat site may be shown as a count; it is never a verdict.
- **No age.** Healing is age-blind and no screen implies otherwise.
- **Do not edit `Injury.gd`, `InjuryWords.gd`, `BodyReadiness.gd` or
  `GameState.gd`.** They are R59's and the module authors'. If the read
  genuinely cannot answer something, say so in your report and stop.

## Gate

Parse gate BEFORE any test — a parse error HANGS a headless test until the
timeout instead of failing it:

```
python Godot/tools/check_scripts.py Godot/scripts/ProfileRevampPanel.gd Godot/scripts/ScheduleHubPanel.gd
```

Then, from `Godot/`:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/profile_revamp_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/body_region_screen_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/schedule_hub_panel_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/smoke_test.gd
```

then the full suite once in the background before the commit. Every file in
`Godot/tests/` must exit 0; `smoke_test.gd` is the real gate.

## The one trap

The BODY LAB is a fixed-position layout: every frame, banner and pair in
`_build_body_lab` is placed by hand (`banner.position = Vector2(12.0, 284.0)`,
the pairs at `y = 342.0`, the refusal rows from `y = 394.0`). Adding a line to
a region row pushes nothing automatically — it overlaps the next element
silently, and a headless test will not see it. Recompute the offsets below
whatever you add, and remember R31: a Control with full-rect anchors must never
have `size` assigned when it is mounted, because with anchors at 0..1 that
writes the OFFSETS and the node ends up twice its parent.

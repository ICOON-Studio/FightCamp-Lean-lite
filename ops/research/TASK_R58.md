# TASK R58 — CLAUDE — THE AGE ON THE BOARD, THE DECISION READ AGAIN

Model: Opus, effort **high**, Fast off. One session.

Two surgical spends in two files. Both reads exist, are tested, and have zero
callers outside `Godot/tests/`.

## Why this exists

**The read backlog is the point of this cycle.** Seven reads were built and
never called; R57 spent `get_body_read`. Six are left and this task takes two.

### 1. `get_aging_read()` — the scouting board prints a bare number

`GameState.get_aging_read(athlete_id)` (`GameState.gd:7577`) is R53's public
projection: the phase band, the peak window, what the last birthday cost and
what the next one will, and the retirement pressure. It falls back to
`get_world_athlete_by_id()`, so it answers for someone who is not on the
roster — which is exactly what the fighter card cannot be asked cheaply for.

The profile does NOT need it: R23's invariant routes the profile through
`get_fighter_card()`, which carries `aging` already (`GameState.gd:12311`,
`ProfileRevampPanel.gd:195`). **Leave that alone.**

`ScoutingHubPanel.gd:379` prints `"AGE %d"` and nothing else. Age is the
single most important number in a signing decision and the board says it the
way a spreadsheet would.

### 2. `get_bout_read()` — the fight modal re-invents its own summary

`GameState.get_bout_read(athlete_id, bout_index)` (`GameState.gd:10487`) is
C30's durable read: the stored decision off one `fight_history` row through
`BoutRead.from_stored()`, plus `title_blocked_by_weight` when the row carries
it. Rows saved before C30 answer honestly absent — they are never
reconstructed.

`ProfileRevampPanel._open_fight_modal()` (`:1542`) opens on a FIGHT RECORD row
and shows purse, hype, streak, title-fight yes/no and an opponent line pulled
from `get_fight_offer()`. **How the fight was actually decided is not in it.**

## Owned files

- `Godot/scripts/ScoutingHubPanel.gd` — the age line at `:379`, its row
  builder, and the sort value at `:759`.
- `Godot/scripts/ProfileRevampPanel.gd` (2,781 lines; never open it whole) —
  `_open_fight_modal:1542`, `_fill_log:1401`, `_build_record:1273`.
- `Godot/tests/scouting_hub_panel_test.gd`, `Godot/tests/profile_revamp_test.gd`.

Nobody else touches these two files this cycle.

## The work

**Scouting.** The age line gains R53's word and window: the phase WORD from
`AGING_PHASE_WORDS` (`GameState.gd:7573` — RISING / PEAK / VETERAN / RETIRED)
and the window, never the band string. Take the read once per visible row in
`rebuild()`, never per redraw. If the read returns `ok: false`, the row keeps
the bare age and says nothing else.

**K24 binds here.** No screen ever prints "declining" or "past peak". Crossing
INTO the peak years may be said; crossing out of them is silence. The board
may not grade a prospect by age.

**The modal.** The FIGHT RECORD row already knows its own index in
`fight_history` — pass it, do not search by week. Add the decision: how it was
scored or finished, the evidence the row stored, and the weight-blocked title
when `title_blocked_by_weight` is present. A row with no stored read prints
**THE RECORD DOES NOT SAY** — never a reconstruction, never a zero.

## Refusals

- No new UIKit factory, no new token, no new rail item.
- No second call to `get_fighter_card()` from the scouting board.
- No projection of when a prospect will peak. The read says where they are.
- The bout modal never recomputes a scorecard. It prints what was stored.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/ScoutingHubPanel.gd Godot/scripts/ProfileRevampPanel.gd
```

Then `--script tests/scouting_hub_panel_test.gd`, `--script tests/profile_revamp_test.gd`,
`--script tests/aging_test.gd`, `--script tests/bout_read_test.gd`, and the full
suite once in the background before the commit.

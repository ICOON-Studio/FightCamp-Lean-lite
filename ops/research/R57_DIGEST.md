# R57 DIGEST — THE BODY GETS ITS SCREEN

Claude · 2026-09-07 · Opus / high / Fast off · `research/TASK_R57.md`

## What shipped

`get_body_read()` (R55, `GameState.gd:7647`) had no caller outside
`Godot/tests/`, and `_fill_regions()` in `ProfileRevampPanel.gd` had been
reading the raw `athlete.body_state.regions` dictionary since R18. Both halves
of this stage were already on master — R55's read and U3's ruling — and only
the wiring was missing. One file changed.

1. **The read is the source.** `_read()` gains `d["body"] =
   get_body_read(id)`: the second deliberate exception to R23's one-read
   invariant after the pound-for-pound board, because `get_fighter_card`
   carries `clearance` — one verdict for the whole fighter — and has never
   carried the six regions. Every lookup keeps its raw `body_state` fallback,
   so an older save or a missing method still draws six cells.
2. **The binding region is the deficit, not the number** (U3 Q2). A head at 72
   against a cage of 90 is 18 under; an arm at 70 against a cage of 80 is 10
   under. The head binds, though the arm is the lower number. R55 does that
   arithmetic in `weakest` and the screen never re-derives it. The binding
   caption takes the refusal tone and carries a `BINDING` word — not a badge,
   because U3 refusal 3 keeps one clearance badge on the screen. A live
   medical hold outranks the mark entirely: the banner is the answer then.
3. **NOW and EVER on one cell** (U3 Q4). Under each gauge, M11's wear grammar:
   a `TRACK` recess with a `LINE_SOFT` edge and up to five `DIM` micro-ticks
   counting `hotspot_bouts`. Never scar-red (refusal 4), never HELD (refusal
   5). Drawn only when `history_known`, so a save whose bouts predate the body
   block reads as silence rather than as "never hurt". Capped at five: the
   recess says it happened, not how much.
4. **What the record cannot say.** A provenance line beside the badge spends
   `history_unknown_bouts` and `history_worst_region`. "Nothing ever happened"
   and "the record does not go back that far" are different sentences, and
   only one of them is a diagnosis. The region hit most often is named as its
   own fact, apart from the region binding today.
5. **`LOWEST · NN` on both glance surfaces** (U3 Q2 ruling D) — the hero beside
   the badge, and the collapsed identity strip the deep tabs use. Labelled
   LOWEST, never "readiness": it is the floor, not the story.

## The one deviation from U3, stated

U3 asks for a `LOWEST · NN` **pair block** on the strip. `UIKit.pair` wants
344px and the strip has none to give, so there the figure joins the condition
line it belongs beside. The label — the half of the ruling that matters — is
kept exactly. The hero, which has the room, carries it as its own element
beside the badge.

## Held

No new token, no new UIKit factory. No anatomy silhouette, no body map, no
per-region badges, no scar-red, no `GO` for cleared, no age on region chrome,
no region column on `squad_row` or the training board. **No healing rate
anywhere** — the per-region recovery clocks are UNKNOWN (J12 D1) and keep
their own future stage.

## Correction to the record

`HANDOFF.md` said `get_corner_rules_read()` was "the one read left" after the
R45-R50 cycle. It was wrong twice: that read is spent at
`ScheduleHubPanel.gd:174`, and **seven** reads had no caller outside
`Godot/tests/` on 2026-09-07 — `get_body_read`, `get_aging_read`,
`get_scorecards_read`, `get_bout_read`, `get_belt_scale_read`,
`get_championships_read`, `get_gym_ledger_week_read`. R57 spends the first.
The remaining six are now named in `HANDOFF.md` so the next count starts from
a true number.

## Files

- `Godot/scripts/ProfileRevampPanel.gd`
- `Godot/tests/body_region_screen_test.gd` (new, 37 checks)
- `HANDOFF.md` — my block and the correction above

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/ProfileRevampPanel.gd Godot/tests/body_region_screen_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/body_region_screen_test.gd
```

Parse 2/2. Focused: `body_region_screen_test` 37/0, `profile_revamp_test`,
`body_read_test`, `region_history_test`, `body_readiness_integration_test`,
`smoke_test` all rc=0.

**No clean full-suite number for this stage, and the reason is on the record
rather than hidden.** Codex's C39 was live and uncommitted in this shared
checkout while R57 ran: `GameState.gd` grew from 177 to 178 inserted lines
mid-run. The suite scored 161 scripts / 3 fails, and re-measuring the three
individually afterwards gave `contract_clauses_test` 5 fails,
`press_conferences_test` 4 and `tournaments_test` clean - a moving target, not
a gate. All the failures refuse with `HAS TURNED PRO - THE AMATEUR CIRCUIT IS
CLOSED` (the R40 gate at `:9905`) reached through C39's new `_turn_pro`, and
**none of the failing tests loads a panel of any kind**, so R57 is not
reachable from them. Codex has the list. The next clean suite belongs to
whoever commits C39.

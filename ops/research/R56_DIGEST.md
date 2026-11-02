# R56 DIGEST — THE AMATEUR BOARD

Claude · 2026-09-07 · Opus / high / Fast off · `research/TASK_R56.md`

The surface half of the amateur cycle, and the last of its four tasks. It
consumes all three of the others: U4's D-list (`ee41d4e`), C39's reads
(`77a15ff`) and G14's module (`c3f24d9`), which gets its first production
caller here.

## What shipped, by D-number

**D2 — an amateur never sees a `FIGHT_TIERS` ghost.** `_offer_rows()` in
`ScheduleHubPanel.gd` now drops every professional offer belonging to a roster
fighter who has not turned pro. `get_fight_offers()` is **not** touched: it
stays the free-agent professional board, clause offers, grudge matches,
superfights and the Grand Prix still append into it, and a roster of
professionals reads exactly as it did before. The screen simply stops pointing
an amateur at it. The suppression list is built from every amateur on the
roster, **with or without a bout this week** — otherwise an amateur with
nowhere to fight would still be shown paid ghosts.

**D3 — the opponents are real people, ranked by G14.** `_amateur_rows()`
collects C39's `get_amateur_bouts()` per amateur fighter and hands the pool to
`AmateurMatchmaking.rank()`. One deliberate omission: a candidate is passed
**without** `held_until_week`, because the world does not tell us whether an
opponent is under suspension. G14 reports it in `unknown` and the row prints
`NOT KNOWN: …` rather than implying the opponent is clear.

**D4 — the verb is ENTER, and the unsafe row is named.** Amateur bouts are
drawn by `_amateur_row()`, not by `booking_offer_row` with a zero in the money
column — that row would read as a free fight and be skipped, which is the trap
the task file named. The bar branches: an amateur selection gets ENTER THE
CARD and no agreement, because there are no terms to negotiate. An `unsafe`
grade prints the word unsoftened; an illegal pairing prints REFUSED with G14's
sentence. `step_down` is worded MORE EXPERIENCED and never "easy".

**D5 — nothing lands without a desk verb**, and the verb goes through
`book_fight()`, which already carries the strike, hold, sanctioning, class and
same-sex gates.

**D8 / D14 — two records, and a door that says what shut it.** The FIGHT
RECORD tab gains one line under the career arc: the amateur record, and once
the one-way door has shut, the week and the cause. The amateur record is never
deleted. A read that cannot answer prints nothing rather than a fabricated
0-0, and a door with no stored cause says the record does not say — a silent
door is refusal 12.

**D12 — the money grammar.** `_amateur_cost_words()` prints NO PURSE in words
and never a `$0` that would read as a fee somebody looked up; `fee_unknown`
prints ENTRY FEE UNKNOWN and never "free"; a prize appears only from an
authored `prize_table`.

## One bug found and fixed outside the screen

`get_organization_fight_offer()` gated `purse` and `win_bonus` on `org_pays`
and **left `reputation_reward` ungated** — so a national amateur federation
handed out the `FIGHT_TIERS` professional local-show reputation figure. U4 D12
says it explicitly ("that table is a professional local-show model; amateur
bouts do not carry it"). One line in `GameState.gd`, in the same dictionary,
now gated the same way as the two lines above it. C39 is complete and Codex
has moved on, so this was taken here rather than left as a contradiction
between a landed ruling and shipped code; the test proves a promotion still
pays its reputation, so the gate is on who pays and not on everyone.

## The one half of a ruling NOT shipped, and why

D4 names two verbs: **ENTER** for an open card or tournament, **CONFIRM** for
an incoming matchmaker call, a gym-to-gym make or a short-notice ask. Only
ENTER ships. No offer C39 emits carries a channel, and every bout on the board
today is a national federation staging a calendar node — the ENTER shape.
Inventing a channel to justify a second button would be exactly the
fabrication this cycle exists to stop. **CONFIRM waits for a `channel` field
on the offer**, which is an engine change and belongs to whoever adds it.

## Held

No new token and no new UIKit factory — the row is built from `block`, `caps`,
`chip` and `button`. `get_fight_offers()` not rewritten. R53's FIGHT RECORD
tab not redesigned; it gained a line. No second medical clock. No healing
rate. No ranking points from an amateur result (C39's, verified untouched).

## Files

- `Godot/scripts/ScheduleHubPanel.gd` — the board, the row, the bar
- `Godot/scripts/ProfileRevampPanel.gd` — the second record line
- `Godot/scripts/GameState.gd` — one line, the D12 reputation gate
- `Godot/tests/amateur_board_test.gd` (new, 33 checks)

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/ScheduleHubPanel.gd Godot/scripts/ProfileRevampPanel.gd Godot/scripts/GameState.gd Godot/tests/amateur_board_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/amateur_board_test.gd
```

Parse 4/4. Focused: `amateur_board_test` 33/0, plus `schedule_hub_panel_test`,
`profile_revamp_test`, `amateur_circuit_test`, `entity_pathways_test`,
`booking_board_api_test`, `booking_eligibility_visibility_test`,
`body_region_screen_test` and `smoke_test` all rc=0.

# TASK U6 — CURSOR — THE CARD THAT CAN BE READ BACK

Model: top tier, effort **high**, Fast off. One session, one branch.

**RUN THIS LAST.** It consumes C40, which lands on master first. Start with
`git fetch origin && git rebase origin/master` and check that
`get_fight_offers()` rows carry a `channel` field. If they do not, C40 has not
landed: ship parts 1 and 2, skip part 3, and say so in your digest.

You own `Godot/scripts/ScheduleHubPanel.gd` and its test. Nobody else touches
that file this cycle.

## Why this exists

Two reads were built, tested and never called outside `Godot/tests/`:

- `get_scorecards_read(results: Array)` (`GameState.gd:13703`) — C25's judge
  read for a WHOLE card at once, through `ScorecardRead.build_many()`.
- `get_belt_scale_read(event_id, bout_index)` (`GameState.gd:10398`) — C29's
  booking stamp beside the settled scale fact, through
  `ChampionshipRead.belt_scale_read()`.

And R56 shipped only half of U4's D4: the ENTER verb for an open amateur card.
**CONFIRM — an incoming matchmaker call, a gym-to-gym match, a short-notice
call — was not shipped because no offer carried a channel.** C40 adds the
channel. This task spends it.

## Owned files

- `Godot/scripts/ScheduleHubPanel.gd` (2,034 lines — **never open it whole**).
  Read these windows only: `rebuild:152`, `_build_cards:692`,
  `_build_book_bar:754`, `_offer_rows:803`, `_amateur_rows:822`,
  `_amateur_verb:909`, `_build_offers:930`, `_amateur_row:989`,
  `_on_enter_amateur:1086`, `_build_offer_bar:1108`, `_build_amateur_bar:1151`,
  `_build_event:1286`, `_build_tape:1367`.
- `Godot/tests/schedule_hub_panel_test.gd`.

Read whole (all small): `Godot/scripts/ScorecardRead.gd` (157),
`Godot/scripts/ChampionshipRead.gd` (219, for `belt_scale_read`).

## The work

**1. The judges, on the card.** `_build_event()` (`:1286`) opens one event out
of `_event`, which comes from `GameState.get_event_card(event_id)`
(`GameState.gd:12958`). That card ALREADY carries a `results` array
(`GameState.gd:12990`) — one result per bout. Feed it straight to
`get_scorecards_read(results)` and put how the judges saw each settled bout on
the event. A bout that did not go to the cards prints its method, not an empty
scorecard. A card with no results at all prints nothing — never a grid of
dashes.

**2. The belt the scale blocked.** For a bout on the open event, spend
`get_belt_scale_read(open_event, bout_index)`. It answers what the booking
stamped and what the scale settled. When those disagree the card must say so
in words — a title fight that stopped being one at the weigh-in is the single
most important thing a card can tell the player, and today it says nothing.
When the read is empty, print nothing.

**3. CONFIRM (only if C40 landed).** `_amateur_verb()` (`:909`) returns the one
verb the row carries. With a `channel` on the offer, D4's second verb becomes
real: **CONFIRM** for an incoming match (matchmaker, gym-to-gym, short notice),
**ENTER** for an open card. Never ACCEPT, and never a purse column on either.
`_build_amateur_bar()` (`:1151`) is where the verb is drawn;
`_on_enter_amateur()` (`:1086`) is the existing commit path — CONFIRM answers
an existing match, so it must not re-run the entry-fee path. An offer with no
channel keeps ENTER exactly as it is today.

## Refusals

- No new UIKit factory, no new token, no new tab.
- No `$0` anywhere on an amateur row — R56's D12 rule: NO PURSE, in words.
- Never reconstruct a scorecard the save did not store.
- Never invent a channel. If C40's field is absent on an offer, the row is an
  open card and takes ENTER.
- Do not touch `GameState.gd`, `ScorecardRead.gd`, `ChampionshipRead.gd` or any
  other panel.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/ScheduleHubPanel.gd
```

Then, from `Godot/`: `tests/schedule_hub_panel_test.gd`,
`tests/scorecard_read_test.gd`, `tests/belt_scale_read_test.gd`,
`tests/amateur_board_test.gd`, `tests/schedule_hub_api_test.gd`, then the full
suite once in the background before the commit.

## The trap

`tests/amateur_board_test.gd` (33 checks) is R56's and it asserts the OFFERS
tab exactly as it stands — the amateur row shape, the ENTER verb and the NO
PURSE wording. Adding CONFIRM must not move any of it. If that test goes red
you have changed the ENTER path, not extended it.

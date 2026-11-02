# TASK C7 — CODEX — the SCHEDULE & EVENTS read API

Model: medium. Fast mode off. Decided at assignment; do not self-escalate.
Self-contained. Read this file, `K10_DIGEST.md`, and the anchors named
below. Do not read `HANDOFF_ARCHIVE.md`; do not read `GameState.gd` whole
(now ~11k lines), use the anchors. START WHENEVER YOU HAVE CREDITS — not
gated on a date, and nothing blocks you: Claude's R23 works on
`ProfileRevampPanel.gd` and the legacy profile, not on your region.

## Why this exists

The replacement programme is at hub four. Kalli's K10 study ruled the
shape: **ONE rail item SCHEDULE**, folding today's separate EVENTS into
it — tabs MY MONTH / THE CARDS, with EVENT as a drill-in off a cards row
rather than a third destination. Three pre-kit screens die when it ships:
`ScheduleBoard.gd` (1346), `EventsBoard.gd` (1089),
`EventDetailScreen.gd` (1074).

You are writing that hub's only read, the way C4 did for GYM, C5 for
TRAINING and C6 for the fighter card. **No screen changes, no save-field
changes, no new game logic** — compose what already exists.

## Deliver

    func get_schedule_month(week: int = 0) -> Dictionary
    func get_cards_board() -> Dictionary
    func get_event_card(event_id: String) -> Dictionary

### `get_schedule_month(week)` — the gym's own dated facts

A month window of day cells (Monday-first), each carrying the real kinds
only — **FIGHT, MEDICAL, RECOVERY, WORLD**. The career clock is
week-granular and there are no invented Training/Travel/Rest chips; that
was a standing ruling on the legacy board and it survives. Alongside
those, the dated things the player is judged on: an ask's deadline, the
weigh-in the day before a bout, a contract running out, a camp settling.
`week = 0` means the current career week. A cell says how many items it
holds, because three obligations landing on one day is the board's hard
case (K10 board 1).

### `get_cards_board()` — the world's schedule

The six columns the legacy table showed — day, date, organization,
discipline, event name, location — one row per world event, plus the
relevance flags the board filters on: **mine** (a roster fighter is on
it), **my division**, **my org**, **bookable**. When a row is not
bookable, say why in the row, in the same voice booking already uses:
weight class mismatch and sex are hard rules
(females never fight males; booking matches weight classes), and a
refusal must name itself rather than silently vanishing.

### `get_event_card(event_id)` — one event opened

The bout list, my fighter's slot if any, the pairing's tale-of-the-tape
numbers, purse and win bonus, and the result once it is fought.

## The four rules that decide whether this is correct

1. **It must not mutate.** `get_event_open_slot_offer()` (2182) can
   GENERATE an offer as a side effect — the same trap C4 hit on the Gym
   hub's empty book and C6 hit on the fighter card's offers. C6 solved it
   by running every getter against a deep-copied Career and restoring the
   live one before returning; that pattern is proven, reuse it. The test
   asserts the save and the world are deep-equal before and after, and
   that the offer count is unchanged.
2. **An unknown or empty `event_id` returns `{}`.** Not a half-filled card.
3. **Two consecutive calls return equal dictionaries** and leave the save
   unchanged.
4. **Numbers agree with their sources.** A day's items agree with
   `get_events_on_day`; an event's broadcast fields agree with
   `get_event_broadcast`.

## Files you own

- `Godot/scripts/GameState.gd` — **append only, at the end of the file.**
  C6's `get_fighter_card` block currently ends it. Add yours after it and
  change nothing above. Rebase on `origin/master` before you push.
- `Godot/tests/schedule_hub_api_test.gd` — new.

Nothing else. No `.tscn`, no screen script, no `project.godot`.

## Anchors

    Godot/scripts/GameState.gd:237    get_simulation_world()      the world's events live here
    Godot/scripts/GameState.gd:1951   get_event_broadcast(event_id)
    Godot/scripts/GameState.gd:2182   get_event_open_slot_offer() ← MUTATING, see rule 1
    Godot/scripts/GameState.gd:2307   get_event_day_offset(event_id)
    Godot/scripts/GameState.gd:2325   get_events_on_day(week, day)
    Godot/scripts/GameState.gd:5119   get_fight_offers()          class-major, roster classes only
    Godot/scripts/GameState.gd:10198  get_gym_hub                 (C4 — the house style)
    Godot/scripts/GameState.gd:10480  get_training_hub            (C5 — deep-copy discipline)
    research/C6_DIGEST.md       the disposable-Career pattern to reuse
    research/K10_DIGEST.md      the board shapes these three reads must serve
    Godot/scripts/DevJump.gd:35       the test harness API

## Test

`Godot/tests/schedule_hub_api_test.gd` builds a real career through
DevJump (set `SceneRouter.navigation_enabled = false` first) and asserts:
a month comes back with Monday-first day cells and only the four real
kinds; a day carrying several obligations reports them all; **the save,
the world and the offer count are deep-equal before and after all three
reads** (the mutation trap); two calls are equal; an unknown event id
returns `{}`; every cards row carries its four relevance flags and an
unbookable row names its reason; a weight-class mismatch is refused by
name; an event card's bouts match the world's own bout list, and a past
event carries its results. Then run `events_board_test.gd`,
`schedule_board_test.gd` and `smoke_test.gd`.

    python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/tests/schedule_hub_api_test.gd
    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/schedule_hub_api_test.gd

Full suite once before the commit (Git Bash, from `Godot/`, `GODOT` = the
console exe): `for f in tests/*.gd; do timeout 600 "$GODOT" --headless
--path . --script "$f" >/dev/null 2>&1 || echo "FAIL rc=$? $f"; done`.
Check `git status -s` first, `git add -- <your files>` only, one commit,
push `master` if you can (else Claude pushes), then convert your
`HANDOFF.md` block to COMPLETE with the hash (max 8 lines) and write
`research/C7_DIGEST.md`.

Note: `HANDOFF.md` has mixed line endings. Append your block without
reformatting anyone else's, and never rewrite another agent's block.

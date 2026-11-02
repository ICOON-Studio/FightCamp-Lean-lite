# TASK C2 — CODEX — the event broadcast read API

Self-contained. Read this file and nothing else. Do not read
`HANDOFF_ARCHIVE.md`; do not read `GameState.gd` whole (~10k lines) —
use the anchors below. START WHENEVER YOU HAVE CREDITS: this task is not
gated on a date and nothing downstream is waiting on the calendar. One
session: when it ships, end it.

## What to build

A read-only `get_event_broadcast(event_id: String) -> Dictionary` on
GameState, built ONLY from what the event and its settlement already
record. Never run a second simulation; if a value is not stored, return
it empty and say so in the digest (that is what C1 did and it was right).

    {"event": {"id", "name", "promotion", "week", "day", "tier"},
     "card": [{"bout_id", "order": 1-based running order,
               "segment": "main"|"co_main"|"main_card"|"prelim",
               "red": {"athlete_id", "name", "record", "gym"},
               "blue": {...same...},
               "is_player": bool (either corner is on the player's roster),
               "weight_class", "title_fight": bool,
               "result": {"winner_id", "method", "round", "time"}
                         or {} while the bout is unresolved}],
     "awards": [{"id", "ids", "opponent"}] as settlement recorded them,
     "ledger": {"purse", "win_bonus", "clauses", "awards_paid", "total"}
               for the PLAYER's bout only; every key 0 when the player
               was not on the card}

Running order is the broadcast order: prelims first, main event last.
`record` is a dictionary, not a string (the shell rule).

## Anchors (grep from these, do not scan)

- `Godot/scripts/GameState.gd:1966` `get_event_open_slot_offer` — how an
  event dictionary and its `bouts` array are reached.
- `:2091` `get_event_day_offset`, `:2109` `get_events_on_day` — the week
  and day fields.
- `:8142` `_award_completed_cards` — where the night's awards are decided
  and stored; read what it wrote, do not recompute.
- `:8223` `get_fight_playback(bout_id)` — C1's sibling API; match its
  shape and its "read what was resolved" discipline.
- `:9681` `_apply_fight_result` — purse, win bonus and clause money.

## Test

`Godot/tests/event_broadcast_test.gd`, a settled card with a player bout:
running order and `order` numbering, main event last, exactly one
`is_player` bout, results present after settlement and `{}` before it,
the ledger total equal to its parts, an unknown event id returning an
empty dictionary.

## Rules

- Parse gate BEFORE any test: `python Godot/tools/check_scripts.py <files>`.
  A parse error hangs a headless test until the timeout instead of failing.
- Then the stage test, then the full suite ONCE before the commit:
  `for f in tests/*.gd; do timeout 600 "$GODOT" --headless --path . --script "$f" >/dev/null 2>&1 || echo "FAIL rc=$? $f"; done`
- Owned files, nothing else: `Godot/scripts/GameState.gd`, new
  `Godot/tests/event_broadcast_test.gd`, `research/C2_DIGEST.md`,
  and your own block in `HANDOFF.md` (max 8 lines; never touch another
  agent's block).
- `var x := <call>` fails when the call returns Variant — write the type.
- Commit with your Co-Authored-By line, push `master`, then END the session.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/C2_DIGEST.md
```

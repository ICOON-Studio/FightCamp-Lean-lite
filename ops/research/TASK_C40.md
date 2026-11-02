# TASK C40 — CODEX — THE CHANNEL A BOUT ARRIVES THROUGH

Model: top tier, effort **high**, Fast off. One session.

Engine only. You own `GameState.gd`'s offer paths and `EntityPathway.gd`. You
do **not** touch any panel — `ScheduleHubPanel.gd` belongs to Cursor's U6, which
runs after you land and is the only consumer of what you ship.

## Why this exists

U4 ruled D4: an amateur bout row carries **CONFIRM** when a match is coming
IN — a matchmaker call, a gym-to-gym match, a short-notice replacement — and
**ENTER** when the fighter is registering for an open card. Never ACCEPT, never
a purse on the row.

R56 shipped ENTER and deliberately did not ship CONFIRM. Its own words:

> **CONFIRM waits for a `channel` field on the offer**, an engine change that
> belongs to whoever adds it. Inventing one for a second button is the
> fabrication this cycle exists to stop.

That engine change is this task. Every bout on the board today is a federation
calendar node — one shape, one verb — and the game has no way to say a bout
arrived any other way.

## Owned files

- `Godot/scripts/GameState.gd` — **12,900+ lines, never open it whole.** Read
  `sed -n 'A,Bp'` windows at these anchors only:
  - `get_fight_offers():5300` — the synthetic professional board, one offer per
    weight class per `FIGHT_TIERS` tier (`:155`), opponent invented from an RNG
    seeded `"fight_offer|<gym>|<tier>|<class>|<week>"`.
  - `accept_signing_offer():5484` — the one place `turned_pro` is written.
  - `get_amateur_bout_offer():5789` and `get_amateur_bouts():5814` — C39's
    amateur path.
  - `get_organization_fight_offer():9735` — a signed fighter's promotion offer.
    R56 fixed a `reputation_reward` leak here; read the gating around it.
  - `get_booking_board():12421` — where a board assembles offers for a screen.
- `Godot/scripts/EntityPathway.gd` (203 lines — read it whole).
- `Godot/scripts/ShortNotice.gd` — read it: a short-notice replacement is
  already a real object in this game and it is already an INCOMING match.
- Tests: extend `Godot/tests/amateur_circuit_test.gd` and
  `Godot/tests/organization_fight_offer_test.gd`.

## The work

**One field, `channel`, on every offer row a screen can see**, plus whatever
the read layer needs to pass it through unchanged.

The vocabulary is U4's and is closed. Do not add to it:

| `channel` | meaning | the verb it implies |
| --- | --- | --- |
| `open_card` | the fighter registers for a card that is open | ENTER |
| `matchmaker` | a matchmaker/promotion offers a specific match | CONFIRM |
| `gym_to_gym` | another gym proposes a specific pairing | CONFIRM |
| `short_notice` | a replacement call for a specific bout | CONFIRM |
| `""` | the offer does not say | ENTER (today's behaviour) |

**Sourced, never invented.** A channel is set only where the code path already
knows the answer:

- A federation calendar node the fighter enters is `open_card`. It already is
  one; naming it costs nothing and asserts nothing new.
- A promotion offering a named opponent to a signed fighter is `matchmaker` —
  the match came to the fighter, which is what CONFIRM means.
- A `ShortNotice` replacement is `short_notice`.
- **`gym_to_gym` has no producer in the game today. Ship the constant and
  produce it nowhere.** A vocabulary entry with no writer is honest; a
  fabricated writer is not.
- Anything you cannot source stays `""`. An empty channel is a correct answer.

**No verbs, no copy, no screen.** You ship the field and the tests. The button
is U6's.

## Refusals

- No new offer kind, no new board, no second medical clock, no purse change.
- Never write `turned_pro` from this task. D13 already settled that door and
  C39 shipped it.
- Do not change `get_fight_offers()`'s RNG seed, its tier table or its shape
  beyond adding the field — the seeded stream must not move, or fight outcomes
  change.
- Do not edit `HANDOFF.md`.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/scripts/EntityPathway.gd
```

Then, from `Godot/`:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/amateur_circuit_test.gd
```

plus `tests/organization_fight_offer_test.gd`, `tests/entity_pathways_test.gd`,
`tests/amateur_board_test.gd`, `tests/short_notice_test.gd`,
`tests/booking_board_api_test.gd`, then the full suite once in the background
before the commit.

## The trap

`tests/amateur_board_test.gd` is R56's screen test and it reads the offers your
paths produce. A field ADDED to a row is invisible to it; a field that replaces
or reorders anything is not. If that test goes red you have changed a row, not
extended it — and the same applies to `booking_board_api_test.gd`, which
asserts the board's contract key by key.

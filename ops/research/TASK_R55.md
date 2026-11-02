# TASK R55 — THE BODY IS SIX PLACES, NOT ONE NUMBER (Claude)

**Status: COMPLETE (2026-09-07).** See `research/R55_DIGEST.md`.

**Was: OPEN (assigned 2026-09-07).** The read half of the per-region stage.
Runs alongside U3 (Cursor rules how it LOOKS) and G13 (Grok counts where the
body was hit). Neither blocks it.

Model: Opus, effort high, Fast off. One session.

## READ THIS FIRST: what this task is NOT

The operator's standing decision of 2026-09-07 (HANDOFF, "Recovery and healing
get a real per-body-part system") gives per-region HEALING its own research
pass and its own implementation stage. **This is not that stage.**

- **Do not touch `BodyReadiness._apply_recovery` (`:372`),
  `forecast_weeks_to_training` (`:341`), or the `recovery` block of
  `assets/data/body_readiness_rules.json`.** Same refusal R54 made, for the
  same two reasons: the rates are UNKNOWN (J12 D1) and the shape is about to
  be replaced.
- **Do not invent an injury taxonomy.** No "torn hamstring", no severity
  grades, no injury kinds. Naming what an injury IS is a research question and
  the pass has not run.
- **Do not build the screen.** U3 is ruling how six regions may read on one
  human being, and it has not landed. R55 ships the READ; the screen that
  spends it is the next stage and inherits U3's law.

What ships is the honest half: **the game already knows which region was hit,
when, and by which bout, and nothing reads it.**

## What is true today (verified 2026-09-07)

- `BodyReadiness` tracks six regions as plain 0..100 values
  (`DEFAULT_REGIONS`, `:10`; `get_regions`, `:57`; `readiness_band`, `:70`;
  `competition_threshold`, `:93`). 433 lines — read it whole once.
- **The hold has no region.** `apply_fight_damage` (`:214`) writes
  `body_state.medical_hold_reason` as `"%s after %s" % [profile_id, method]` —
  the profile and the method, never the part of the body that caused it. The
  hotspots it picked are returned and then dropped on the floor by the hold.
- **The log kept them anyway.** Every settled bout writes `body_damage` into
  the fight-log entry (`GameState.gd:11118`) carrying `before`, `after` and
  `hotspots`. `get_fight_log()` (`:11138`) hands those rows out. **Nothing in
  this codebase reads `hotspots`** — grep it.
- `get_athlete_competition_clearance` (`:3449`) already names the weakest
  region when it refuses a bout. That is the only place the game has ever said
  WHERE, and it says it only to block something.

## What you build

**`GameState.get_body_read(athlete_id) -> Dictionary`** — one read model for
the body, in the shape `get_aging_read` (`:7397`) established: derived, never
written, answering for a roster fighter and honestly empty for an id the save
does not hold.

```
{
  "regions": [                 # ordered by BodyReadiness.region_ids()
    {"id": "head_neck", "value": 62, "band": "...",
     "competition_threshold": 70, "clears": false,
     "hotspot_bouts": 4, "last_hit_week": 41, "damage_taken": 118}, ...
  ],
  "weakest": {...},            # the region row that is furthest under
  "hold": {"held": true, "until_week": 44, "reason": "...",
           "region": "head_neck", "region_known": true},
  "history_known": true,       # false when G13 has not landed / no log
}
```

**The hold finally gets a region.** Derive it — do not write it to the save:
take the most recent fight-log row whose `week` is at or before the week the
hold was set, and read its `body_damage.hotspots`. Where the log cannot say,
`region` is `""` and `region_known` is `false`. **"Not known" is the correct
answer and must survive to the caller** — C37 established that rule for FORMER
and it holds here. Never pass a cheerful default to make the read agreeable.

**The per-region history is G13's seam.** `RegionHistory.summarize()` (Grok,
`Godot/scripts/RegionHistory.gd`) counts hotspot bouts, damage taken and the
last week hit, off the same `get_fight_log()` rows. If it has landed when you
start, consume it and set `history_known` true. If it has not, ship the read
with the history fields absent and `history_known` false, say so in the
digest, and do NOT author a second count here — one number in one place is the
rule G12/R54 already set.

## Settled

- **No healing rate, anywhere.** Not a projection, not "weeks to clear", not a
  per-region forecast. `forecast_weeks_to_training` stays untouched and
  unwrapped.
- **No new hue and no new word.** M6 owns `BAD`/`AMBER`/`GOOD` and the
  `HELD`/`NOT CLEARED`/`CLEARED` badge; M11 forbids wear as anatomy. This read
  returns values, bands and counts — the words and the colours are U3's to
  rule and the next stage's to apply.
- **No fight outcome may change.** This is a read: no RNG stream may shift, no
  damage application changes, no clearance verdict changes.
- **Old saves need no migration.** Every field is derived from what the log and
  the body state already hold.

## Owned files

- `Godot/scripts/GameState.gd` — **13,354 lines, never open it whole.** The
  new read only, placed beside `get_aging_read` at `:7397`. Windows you may
  need: `sed -n '3449,3470p'` (competition clearance), `sed -n '11110,11160p'`
  (the log entry and `get_fight_log`).
- `Godot/scripts/BodyReadiness.gd` — 433 lines, read whole. **Read only.**
  If the read needs a helper this file does not have, add it here as a static
  and leave every existing function alone.
- Tests: `Godot/tests/body_readiness_test.gd` (it must keep passing unchanged —
  that is the proof the clocks did not move) and a new
  `Godot/tests/body_read_test.gd`.

**Do not touch:** `ProfileRevampPanel.gd` (no screen this stage),
`OfficeHubPanel.gd` (Codex owns it on C38), `Mileage.gd`, `RegionHistory.gd`.

## The trap

`get_fight_log()` is newest-first and `_retire_athlete` preserves
`fight_history` on the WORLD record, so a retired fighter's log comes back
through a different branch (`:11138`). Do not assume roster-only: decide
explicitly whether `get_body_read` answers for a retired fighter and test the
branch you chose. R53 got caught by exactly this and needed a follow-up commit.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/scripts/BodyReadiness.gd Godot/tests/body_read_test.gd
```

## Tests

```
--script tests/body_read_test.gd
--script tests/body_readiness_test.gd
--script tests/gym_hub_test.gd
--script tests/profile_revamp_test.gd
```

Then the full suite ONCE in the background before the commit.

## Done

Commit and push `master`, write `research/R55_DIGEST.md` (short),
convert this block in `HANDOFF.md` to COMPLETE, regenerate `TASKS.md`. The
digest must state in one line each: what the read answers that nothing could
answer before, whether G13's history landed in time, and that the healing
clocks were again deliberately left alone.

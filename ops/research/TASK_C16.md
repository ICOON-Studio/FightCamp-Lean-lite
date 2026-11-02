# TASK C16 — THE DAY ATTENTION READ (Codex)

Model: medium, effort medium, Fast off. One pure read, one commit.

## Why

K17 (`K17_DIGEST.md`) dissolved PHONE: there is no relationships screen and
none is coming. The three pillars it verified — coach rapport, loyalty,
fighter rivalries — already have homes, and "who is unhappy and why" gets
**one** home, the attention strip on **THE DAY** (K17 §D, agreeing with
K12 §D). Today `DayFeedPanel.gd` (R17) shows news, offers and a thin alerts
column (open requests, expiring contracts, injuries) and knows nothing
about loyalty or rivalries.

K17 §E names the one gap: an aggregate so the panel makes a single call
instead of looping the roster three times per rebuild. This task delivers
exactly that aggregate. THE DAY build itself is Claude's and is not
started; the Kalli study (K18) runs in parallel and may name more gaps
later — do not pre-build for them.

## Deliver in `Godot/scripts/GameState.gd`

**`get_day_relationship_attention() -> Dictionary`** — append-only, pure,
no new save state, nothing invented. It aggregates three reads that already
exist and returns items sorted most-urgent first:

```
{
  "items": [ { "kind", "athlete_id", "athlete_name", "rival_id",
               "headline", "detail", "tone", "urgency", "route", "route_args" } ],
  "counts": { "loyalty": int, "rivalry": int, "offer": int },
  "worst_tone": "bad" | "warn" | "ok"
}
```

1. **Loyalty** — for every roster athlete (`get_roster()`,
   `GameState.gd:3323`), `get_athlete_loyalty(athlete_id)`
   (`GameState.gd:5833`). Emit an item only when it is actually attention:
   `striking` true (tone `bad`) or the band is the strained/low one that
   read already reports (tone `warn`). Never emit for a content fighter.
   `detail` names the reason the read gives — pay vs market, contract weeks
   remaining, the part that drags the score — never a sentence you compose
   from nothing.
2. **Rivalry heat** — `get_athlete_rivalries(athlete_id)`
   (`GameState.gd:6603`) per roster athlete. Emit HEATED and above (heat
   ≥ 30, the bands in `rivalries.json`: HEATED 30–59, BAD BLOOD 60–84,
   BLOOD FEUD 85–100); tone `warn` for HEATED, `bad` from BAD BLOOD up.
   Carry `rival_id`, the band and the source. COLD and SIMMERING are not
   attention and must not appear.
3. **Open grudge offers** — `get_rivalry_fight_offers()`
   (`GameState.gd:6674`). One item per offer, tone `ok`, `headline` the
   label that read already builds (`GRUDGE MATCH · BAND`), `detail` the
   purse and heat.

`urgency` is an int for the sort only: striking loyalty highest, then
BLOOD FEUD / BAD BLOOD, then strained loyalty, then HEATED, then offers.
Ties break on athlete name so the strip is stable between rebuilds.
`route` / `route_args` point at the surface that already owns the fix —
`fighter_card` with the athlete id for loyalty and rivalry items,
`calendar` for an offer — so the panel never hard-codes navigation.

Empty roster, no rivalries, no offers: `{"items": [], "counts": {...zeros},
"worst_tone": "ok"}`. Never `null`, never a partial dict.

## Rules

- Append-only in `GameState.gd`. No existing read changes shape, no new
  persisted field, no schema bump, no screen touched (`DayFeedPanel.gd` is
  Claude's).
- `get_rival_gyms` is a different thing (world gyms) — K17 §A says so
  explicitly. It is not part of this read.
- Disposable Career in the test, as C13/C15 did.

## Owned files

- Edited: `Godot/scripts/GameState.gd` (append-only)
- New: `Godot/tests/day_attention_test.gd`

## Parse gate

`python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/tests/day_attention_test.gd`

## Test command

`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/day_attention_test.gd`

Then `tests/smoke_test.gd`. Digest `research/C16_DIGEST.md`, short;
message Claude on the mailbox when it lands.

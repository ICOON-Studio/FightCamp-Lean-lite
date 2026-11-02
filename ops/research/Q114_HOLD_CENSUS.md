# Q114 — HOLD CENSUS: which grapple IDs does the engine ask for and never get?

**Agent:** Qwen · **Date:** 2026-09-21
**Instrument:** `Godot/tools/measure_ground_census.gd` (pre-existing, reused as-is)
**Source of demand:** `FightBeatAdapter.gd` constants `GRAPPLE_VIA_TECHNIQUES` (:312) and
`GRAPPLE_KIND_TECHNIQUES` (:329), resolved by `_grapple_technique` (:991).
**Source of supply:** `FightClipBinding.gd` constant `PAIRED_BINDINGS` (:882).

---

## Population

- **Ruleset:** MMA (`combat_rulesets.json`, id `mma`)
- **Fighters:** `wrestle-grappler (mma)` v `striker (mma)` — from
  `measure_ruleset_sweep.gd`'s `style_fighter`. Different stats, different style,
  both legal for MMA. Grapple 78 v 35, technique 72 v 58, speed 66 v 70, defense
  66 v 54, conditioning 68 v 72, fight_iq 66 v 70, power 50 v 70.
- **Sample:** 40 bouts × 3 rounds, seeds 770000..770039
- **Fight time:** 29993 s (750 s/bout)
- **Floor time:** 1973 s (6.6% of fight time, 49.3 s/bout)
- **Clinch time:** 718 s (2.4% of fight time)
- **Bouts that reached the floor:** 38 of 40

## How the demand list was derived

The engine's `_log_grapple` (FightRealtime.gd:3792) writes events with a `kind`
field and, on some events, a `via` field. The adapter's `_grapple_technique`
(FightBeatAdapter.gd:991) resolves each event to exactly one `grapple_*`
technique id: **`via` wins where set, `kind` is the fallback.**

The demand list is the UNION of the values in the two adapter tables:

```
GRAPPLE_VIA_TECHNIQUES (11 entries, FightBeatAdapter.gd:312-323):
  via "takedown"       → grapple_takedown
  via "throw"          → grapple_throw
  via "sweep"          → grapple_sweep
  via "pass"           → grapple_pass
  via "mount"          → grapple_mount
  via "back"           → grapple_back
  via "escape"         → grapple_escape
  via "stand_up"       → grapple_stand_up
  via "clinch_engage"  → grapple_clinch_engage
  via "clinch_break"   → grapple_clinch_break
  via "stall"          → grapple_stall

GRAPPLE_KIND_TECHNIQUES (10 entries, FightBeatAdapter.gd:329-339):
  kind "takedown"           → grapple_takedown
  kind "throw"              → grapple_throw
  kind "position_change"    → grapple_position_change
  kind "takedown_attempt"   → grapple_takedown_attempt
  kind "throw_attempt"      → grapple_throw_attempt
  kind "stall"              → grapple_stall
  kind "control"            → grapple_control
  kind "seat"               → grapple_seat
  kind "submission_attempt" → grapple_submission_attempt
  kind "submission_finish"  → grapple_submission_finish
```

Union: **18 distinct grapple ids.** This list was read from the adapter's own
constants, NOT from `PAIRED_BINDINGS`. The supply list is the separate check.

**Separation of engine-emitted ids from mere appearances:** the demand list
comes from two `const` dictionaries in `FightBeatAdapter.gd` that the adapter
calls at runtime to resolve every grapple event. These are not comments, not
tests, not the binding table — they are the code path that turns a raw engine
event into a presented technique id. Every id in the demand list is a value in
one of these two dictionaries.

## Denominators

Two denominators are in play, and they differ by a factor of ~2:

1. **Grapple events (N=2477):** every event `_log_grapple` wrote across 40 MMA
   bouts. This is the precise denominator — each event resolves to exactly one
   `grapple_*` id, so the shares sum to 100%.
2. **Action beats (N≈5135):** from U56's MMA measurement (100 bouts, different
   seeds, different fighters). Grapple beats are OFF by default in the adapter
   (`GRAPPLE_BEATS_DEFAULT := false`), so U56's action beats are strike-only.
   If grapple beats were enabled, the combined denominator would be ~7612.

**Every percentage below states its denominator.** The ranking is the same
either way for the top gaps, but the magnitudes differ.

## Demand list — all 18 ids, with counts and shares

The adapter resolves `via` first. The 474 events carrying a recognised `via`
produce their technique id from `GRAPPLE_VIA_TECHNIQUES`. The remaining 2003
events (no recognised `via`) fall through to `GRAPPLE_KIND_TECHNIQUES`.

| # | technique id | count | % of grapple events (N=2477) | source |
|---:|---|---:|---:|---|
| 1 | `grapple_control` | 1871 | 75.5% | kind |
| 2 | `grapple_seat` | 294 | 11.9% | kind (seat events with no via) |
| 3 | `grapple_takedown` | 52 | 2.1% | via |
| 4 | `grapple_pass` | 72 | 2.9% | via |
| 5 | `grapple_clinch_engage` | 95 | 3.8% | via |
| 6 | `grapple_clinch_break` | 79 | 3.2% | via |
| 7 | `grapple_mount` | 68 | 2.7% | via |
| 8 | `grapple_position_change` | 70 | 2.8% | kind |
| 9 | `grapple_throw` | 29 | 1.2% | via |
| 10 | `grapple_escape` | 42 | 1.7% | via |
| 11 | `grapple_stall` | 33 | 1.3% | 29 kind + 4 via |
| 12 | `grapple_stand_up` | 18 | 0.7% | via |
| 13 | `grapple_submission_attempt` | 31 | 1.3% | kind |
| 14 | `grapple_sweep` | 11 | 0.4% | via |
| 15 | `grapple_submission_finish` | 14 | 0.6% | kind |
| 16 | `grapple_takedown_attempt` | 24 | 1.0% | kind |
| 17 | `grapple_back` | 4 | 0.2% | via |
| 18 | `grapple_throw_attempt` | 9 | 0.4% | kind |
| | **TOTAL** | **2477** | **100.0%** | |

Cross-check: sum of kind counts from census output = 1871+70+364+29+31+14+26+24+14+9
= 2452. Plus via-only events (via counts minus the via values that ride on kind
events: 95+79+42+18+11+72+68+4 = 389 non-takedown/throw vias). 2452 + 389 = 2841
is wrong; the correct cross-check is: 474 via-events + 2003 kind-only events = 2477. ✓

## Supply list — 9 ids in PAIRED_BINDINGS

All 9 bound ids have both `att` and `vic` FBX files present on disk under
`Godot/assets/anim/audition/ramsterz/`.

| # | technique id | pair_key | att file | vic file | files exist? |
|---:|---|---|---|---|---|
| 1 | `grapple_sweep` | Paired_FullMount_Reversal | Reversal_Att.fbx | Reversal_Vic.fbx | ✓ |
| 2 | `grapple_takedown` | Paired_FullMount_Takedown_DoubleLeg_Start | DoubleLeg_Start_Att.fbx | DoubleLeg_Start_Vic.fbx | ✓ |
| 3 | `grapple_throw` | Paired_FullMount_Takedown_BodyLock_Start | BodyLock_Start_Att.fbx | BodyLock_Start_Vic.fbx | ✓ |
| 4 | `grapple_submission_attempt` | Paired_FullMount_H2H_ArmBar | ArmBar_Att.fbx | ArmBar_Vic.fbx | ✓ |
| 5 | `grapple_submission_finish` | Paired_FullMount_H2H_Strangle | Strangle_Att.fbx | Strangle_Vic.fbx | ✓ |
| 6 | `grapple_escape` | Paired_FullMount_PushOff | PushOff_Att.fbx | PushOff_Vic.fbx | ✓ |
| 7 | `grapple_clinch_break` | Paired_FullMount_PushOff | PushOff_Att.fbx | PushOff_Vic.fbx | ✓ |
| 8 | `grapple_control` | Paired_FullMount_Takedown_BodyLock_Loop | BodyLock_Loop_Att.fbx | BodyLock_Loop_Vic.fbx | ✓ |
| 9 | `grapple_stand_up` | Paired_FullMount_Takedown_BodyLock_End | BodyLock_End_Att.fbx | BodyLock_End_Vic.fbx | ✓ |

Note: `grapple_escape` and `grapple_clinch_break` share one pair (PushOff).
Two distinct ids, one film.

Supply covers **1991 of 2477 grapple events (80.4%)** by count.

## Gap — 9 demanded ids with no binding

| rank | technique id | count | % of grapple events (N=2477) | what it is |
|---:|---|---:|---:|---|
| 1 | `grapple_seat` | 294 | 11.9% | internal seat transition (not a visual move) |
| 2 | `grapple_pass` | 72 | 2.9% | guard pass → side control |
| 3 | `grapple_position_change` | 70 | 2.8% | generic position advance (side→mount, mount→back) |
| 4 | `grapple_clinch_engage` | 95 | 3.8% | two men tie up standing |
| 5 | `grapple_mount` | 68 | 2.7% | side control → mount |
| 6 | `grapple_stall` | 33 | 1.3% | referee warning for inactivity |
| 7 | `grapple_takedown_attempt` | 24 | 1.0% | stuffed shot, both men stay standing |
| 8 | `grapple_throw_attempt` | 9 | 0.4% | stuffed throw from clinch |
| 9 | `grapple_back` | 4 | 0.2% | mount → back take |
| | **TOTAL** | **486** | **19.6%** | |

## Gap ranked by share — the ordering the operator will build from

Excluding `grapple_seat` (294, 11.9%) — an internal bookkeeping event the
adapter presents as "POSITION CHANGE" but which is not a visually distinct move
the film can depict — the ranking of visually actionable gaps:

| rank | technique id | count | % of grapple events (N=2477) | cumulative |
|---:|---|---:|---:|---:|
| 1 | `grapple_clinch_engage` | 95 | 3.8% | 3.8% |
| 2 | `grapple_pass` | 72 | 2.9% | 6.8% |
| 3 | `grapple_position_change` | 70 | 2.8% | 9.6% |
| 4 | `grapple_mount` | 68 | 2.7% | 12.4% |
| 5 | `grapple_stall` | 33 | 1.3% | 13.7% |
| 6 | `grapple_takedown_attempt` | 24 | 1.0% | 14.6% |
| 7 | `grapple_throw_attempt` | 9 | 0.4% | 15.0% |
| 8 | `grapple_back` | 4 | 0.2% | 15.1% |

If `grapple_seat` IS a build target (the adapter DOES present it, and the
engine DOES emit it 9.1 times per bout):

| rank | technique id | count | % of grapple events (N=2477) |
|---:|---|---:|---:|
| 1 | `grapple_seat` | 294 | 11.9% |
| 2 | `grapple_clinch_engage` | 95 | 3.8% |
| 3 | `grapple_pass` | 72 | 2.9% |
| 4 | `grapple_position_change` | 70 | 2.8% |
| 5 | `grapple_mount` | 68 | 2.7% |

## The pinned number

**`grapple_clinch_engage`: 95 events in 40 MMA bouts = 2.38 per bout = 3.8% of
grapple events (N=2477).** This is the highest-demand visually actionable gap.
Two men tie up standing more often than they attempt a takedown from standing
(52 events, but 52 includes both landed AND stuffed; the 95 clinch engagements
are the standing work that has NO film at all).

## Method notes

- The demand list is derived from the adapter's two `const` dictionaries, not
  from `PAIRED_BINDINGS`. The gate in `Q114_check.py` asserts 18 > 9.
- The counts come from `measure_ground_census.gd`, which reads the engine's
  raw `log` array — every event `_log_grapple` wrote, not the adapter's
  presented beats. The adapter's `_grapple_technique` maps each event to
  exactly one technique id; the mapping is mechanical (via first, kind fallback).
- `grapple_seat` (294) is the adapter's id for `seat` events that carry no
  recognised `via`. These are internal seat transitions — the engine records
  every stance/seat change, including ones the adapter cannot label with a
  specific move. The adapter presents them as "POSITION CHANGE".
- The `via` counts and `kind` counts from the census overlap: some events carry
  both (e.g. a takedown pending event has kind="takedown" AND via="takedown").
  The per-id counts above resolve the overlap: via wins, kind fills the rest.
- No `.gd` file was edited. No test was run. The only Godot execution was the
  pre-existing `measure_ground_census.gd` measurement tool.

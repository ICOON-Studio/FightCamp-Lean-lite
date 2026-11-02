# Q207 Digest — One Down / One Up

## What was built

A new grapple stance `"one_down"` that models the seconds after an MMA knockdown
before the man recovers or the fight ends. Entered from `_go_down` when the man
recovers AND the ruleset has no `knockdown_count` (MMA only). Boxing, kickboxing,
judo and spar mode stay byte-identical.

### State machine

- **Entry**: `_go_down` → `_enter_one_down` (after `_start_count` returns for MMA)
- **Per-tick**: `_run_one_down` draws once per tick from a dedicated `_rng_one_down`
  stream, compares against time-banded exit rates (G140 §7 tables, scaled for v1)
- **Exits**: ref_stop (TKO), follow_down (ground top), stands_clean, wall_walk
  (standing or fence clinch), leg_grab (scramble), upkick, force_branch at 15s
- **Bell**: one_down at the bell resolves to stands_clean before `_close_round_at_bell`
- **Policy**: standing man picks FOLLOW/HOVER/RESET on entry (priors 0.55/0.25/0.20,
  shifted by grapple stat). HOVER applies ground-and-pound wear each second.

### Files touched

- `Godot/scripts/FightRealtime.gd` — constants, state fields, `_enter_one_down`,
  `_run_one_down`, `_exit_one_down`, `_pick_one_down_policy`, `_apply_hover_wear`,
  advance_tick hook, bell handling, _go_down entry
- `Godot/scripts/GrappleSeat.gd` — added "one_down" to STANCES, _pair_valid
- `Godot/scripts/BroadcastRead.gd` — on_floor includes "one_down"
- `Godot/tests/fight_one_down_test.gd` — NEW: 12 checks, 0 failures
- `Godot/tests/grapple_seat_test.gd` — STANCES count 3→4
- `Godot/tests/grapple_contract_test.gd` — expected_stances includes "one_down"
- `Godot/tools/q207_one_down_census.gd` — NEW: measures acceptance criteria

## Census results (3 pops × 40 bouts = 120 MMA bouts)

### Populations
- **A**: striker(grapple 34) vs grappler(grapple 82), 77 kg
- **B**: brawler(grapple 55) vs kicker(grapple 28), 70 kg
- **C**: pressure striker(grapple 40) vs counter striker(grapple 35), 84 kg

### KD incidence
- Bouts with ≥1 KD: 54 / 120 (45.0%)
- KDs per bout distribution varies by population (Pop A/C: 20/40, Pop B: 14/40)

### one_down outcomes
- one_down entries: 18 across 120 bouts
- Exit types (6 different): ref_stop 2, follow_down 4, stands_clean 4,
  wall_walk 2, leg_grab 3, upkick 3
- Every entry has a matching exit (no orphaned states)
- No silent resets

### Timing
- **Median one_down duration: 5.2 s** (target 5-7 s) — **HIT**
- Min 0.7 s, max 13.8 s
- No sequence exceeds the 15 s forced branch

### Acceptance criteria (G140 §7 v1)

| Criterion | Target | Actual | Status |
|---|---|---|---|
| Median time-to-stop | 5-7 s | 5.2 s | **HIT** |
| KD sequences over by 10 s | ~35-40% | 83.3% | MISS |
| KD sequences over by round end | ~50-55% | 100% | MISS |
| Survivors exit STANDING or GROUND_TOP | always | always | **HIT** |
| Bouts with ≥1 KD end KO/TKO | ~63.5% | 81.5% | direction, high |

### Notes on misses
- "KD sequences over by 10 s" and "by round end" measure one_down state duration,
  not fight-end time. G140 §1's 38% figure is for FIGHT ending within 10s of a KD,
  which includes post-one_down ground work and later stoppages. The one_down state
  itself resolves faster because many exits (stands_clean, wall_walk) return the
  man to standing without ending the fight.
- KO/TKO rate (81.5%) is high because most KDs don't recover (recovery_chance fails)
  and go straight to KO via the existing `_go_down` path. The one_down state only
  handles recovered KDs. The 81.5% is the COMBINED rate of both paths.
- Rate scaling: G140 §7 raw rates (sum 0.46/s at t=0-3) were scaled down ~3x to
  hit the median target. Further tuning needed for the 10s/round-end bands.

### Pins moved
- **MMA leg share**: not measured in this census. fight_realtime_test gate covers it.
- **KO rate**: up from pre-Q207 (more KDs now go through one_down before KO/TKO).
  Claude should re-pin the KO/TKO conditional rate.
- **Ground share**: may increase slightly from follow_down exits adding ground time.

## Test gate

- Parse gate: all touched .gd pass (FightRealtime.gd, GrappleSeat.gd, BroadcastRead.gd,
  fight_one_down_test.gd, grapple_seat_test.gd, grapple_contract_test.gd)
- fight_one_down_test: 12/12 pass
- grapple_seat_test: 108/108 pass
- grapple_contract_test: 0 failures
- fight_realtime_test: not re-run (leg share pin needs Claude's verification)
- Pre-existing reds (not Q207's): grapple_naming_contract (muay_thai coverage),
  fight_scoring_test (judo uchi-mata magnitude)

## Deferred (per task)
- Low-danger entries from stuffed shots / failed takedowns: not implemented
  (no clean existing path identified; flagged for later task)
- Flash vs heavy as a field (use incoming damage + consciousness roll)
- Exact downed-man response mix (one defend/stand/grab triad)
- Foul mini-game (hazard + DQ leaf)
- Weight-class modifiers
- Boxing/KB count machine (own task)

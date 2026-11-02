# TASK C19 — THE BOOKING READ API (Codex)

Model: top tier, effort medium, Fast off.

Read-only API work on `GameState.gd`. **No screen, no `.tscn`, no UI.**
Per `AGENTS.md` precedence this task file beats the general rule: **write no
`HANDOFF.md` block** — Claude writes it.

## Why this exists

R33 rebuilds the booking screen and adds the one thing our booking has never
done: **tell the player whether a fight is a good idea, not just what it pays.**
The C18 survey found this by playing Pound for Pound, which grades every bout it
offers (`FIGHT HYPE C-`) and prints the reasons as chips — `TWO UNFAMILIAR
NAMES`, `NOBODY HAS HEARD OF EITHER OF THEM`, `+ PICK 'EM FIGHT`. We already
compute every input for that judgement and show none of it.

The screen must not compute this. It reads one call, once per rebuild, exactly
as `ProfileRevampPanel` reads `get_fighter_card()` (C6) and `ScheduleHubPanel`
reads C7. That is the whole job.

## The one function

```gdscript
func get_booking_board(athlete_id: String = "") -> Dictionary:
```

Empty `athlete_id` means the whole roster's board. Returns:

```
{
  "athlete_id": String,          # "" for the roster-wide board
  "career_week": int,
  "offers": Array[Dictionary],   # best verdict first, then richest package
}
```

Each entry passes through everything `get_fight_offers()` already emits —
`id`, `tier_id`, `label`, `opponent_name`, `opponent_rating`,
`opponent_record`, `weight_class`, `purse`, `win_bonus`, `reputation_reward`,
`fame_required` — and adds:

| Key | Type | Meaning |
| --- | --- | --- |
| `verdict` | String | one of `TAKE IT` / `WORTH IT` / `RISKY` / `TRAP` / `LOCKED` |
| `verdict_rank` | int | 0 best … 4 locked; the sort key |
| `verdict_line` | String | one short sentence, the diagnosis |
| `reasons` | Array | max 4, ordered most-decisive first |
| `gate_estimate` | int | `FightContract.gate_for(tier_id, is_event, hype)` |
| `gate_point_value` | int | what ONE gate point is worth in money |
| `weeks_out` | int | weeks between now and the bout |
| `blocked` | bool | true when the offer cannot be taken at all |
| `blocked_reason` | String | named, player-facing, empty when not blocked |

Each `reasons` entry is `{"text": String, "tone": String, "source": String}`
where `tone` is `good` / `warn` / `bad` / `flat` and `source` names the system
the fact came from, so R33 never has to guess and a wrong chip is traceable.

## Where every reason must come from — no new model, no invented numbers

| Reason | Source already in the codebase |
| --- | --- |
| fame gate not met | `get_fight_tier_fame_requirement(tier_id)` vs the athlete's `fame` |
| rating gap | offer `opponent_rating` vs the athlete's rating |
| ranking movement on offer | `get_division_rankings(discipline, weight_class, sex)` — `GameState.gd:9359` |
| rivalry heat | `Rivalries.band_name(heat)` on an existing feud; grudge offers come from `get_rivalry_fight_offers()` — `GameState.gd:6674` |
| short notice | `ShortNotice.in_window(weeks_out)`, `ShortNotice.pick_cause()`, `ShortNotice.premium_purse()` |
| camp length | `weeks_out`, cross-checked against `get_fight_week_card()` — `GameState.gd:11792` |
| clause obligation | `get_clause_offers()` |
| title / superfight stakes | `get_champion_superfight_offers()` — `GameState.gd:9440` |
| money against the tier norm | `FIGHT_TIERS` purse/win_bonus vs the offer |
| main event, five rounds | `FightContract.is_main_event(tier_id)`, `rounds_for_tier(tier_id)` — `FightContract.gd:134` |

**Weight class and sex are NOT reasons.** They are rules, enforced in
generation already (`get_fight_offers()` is class-major per the 2026-09-03 user
rule; females never fight males). Do not surface them as advice. **Assert them**
in the test instead: no offer on the board may cross a weight class or a sex.

## Hazards, both real

1. **`get_fight_offers()` ADVANCES WEEKLY TICK MARKERS.** See the comment at
   `GameState.gd:10619`. `get_booking_board()` is a READ and must be idempotent:
   calling it twice in the same career week returns byte-identical data and
   leaves the save unchanged. If the tick advance cannot be avoided by reusing
   an existing cached offer list, say so in your report rather than working
   around it silently — do not change `get_fight_offers()`'s own behaviour.
2. **`GameState.gd` is ~8k lines.** Never read it whole. The anchors above are
   the only slices you need.

## Owned files

- `Godot/scripts/GameState.gd` — one new function plus its private helpers,
  appended near the other read APIs (`get_fighter_card` `11024`,
  `get_schedule_month` `11169`, `get_scouting_board` `11383`,
  `get_ring_read_contract` `12029`). Change nothing else in the file.
- `Godot/tests/booking_board_api_test.gd` — NEW.

## The test must cover

Determinism across two calls in one week; every verdict value reachable; no
cross-class and no cross-sex offer; a blocked offer names its reason; reasons
never exceed 4; `gate_estimate` agrees with `FightContract.gate_for`; a
short-notice offer carries its cause; a rivalry offer carries its band.

## Parse gate, then the test

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/tests/booking_board_api_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/booking_board_api_test.gd
```

Then `fight_contract_test.gd`, `booking_eligibility_visibility_test.gd`,
`weight_class_matchmaking_test.gd`, `sex_matchmaking_test.gd`, and the full
suite before you push.

## Report

Push your own deliverables this time — the last three C-tasks were committed by
Claude after your session ended. Message Claude with the final shape of the
dictionary if it differs from the table above, and say plainly whether hazard 1
is resolved or open.

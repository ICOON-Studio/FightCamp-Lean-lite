# TASK SPARWIRE1 - sparring blocks on the floor run SparringBlock; the plan glows the gameplan stations (S237)

Seat: Grok Dev (coding seat, own Linux box, Godot 4.7.2, no LFS) - you own the gym floor (your FLOORWIRE1 + DAYPLANWIRE1 are on master).
Branch `grok/sparwire1`, PR to master; Claude reviews and merges by diff. Discipline: BOXING (sparring in the club ring).
Model: Grok Dev. New features ship ON: switch `spar_block` in `GameSwitches.GAME_ON`; plain `--script` tests are the OFF control arm.

## What is on master already (read; do not edit the rules modules)
- `scripts/rules/SparringBlock.gd` (Arena S236, af6060a8): plan_block(block, boxer, pool, opponent, readiness, prefer, seed) ->
  {partner, mods, moments [{minute, trigger, moment}], seed, reason}; resolve_moment(planned, index, call_id, ctx); finish_block(planned,
  results, gameplan, minutes, card_id, clean_reps) -> {readiness_add, gain_mult, card_progress, strain, cut_risk, knockdown_risk, fee,
  member_mood, lines}. STATION_KIND "ring_spar". A block with no SAFE partner plans nothing and says why - never put an unsafe one in.
- `scripts/rules/GameplanReadiness.gd`: plan_for(opponent), block_credit, decay, fight_mods, glow(plan, station_kinds) -> Array.
- `scripts/rules/PartnerPool.gd`: candidates/pick/session_mods (pool rows {id, name, kind, style, stance, weight_class, sex, level, fee...}
  - read the file for the exact keys).
- `scripts/GymHall3D.gd` (~3,450 lines, never read whole - grep): DAYPLANWIRE1 section "S236 DAYPLANWIRE1" (~2080-2290): DAY_PLAN_STATION
  maps "ring_spar" -> "ring_sparring"; `_day_plan_enter(index)`, `_day_plan_tick()`, `_dp_gain/_dp_wear` multiply into `_tick()` gain_k /
  wear_k. Decision cards: `push_card(kind, data)` ~2000, `_card_live(kind)` ~1985, `_card_holds_clock()`.
- GameState (~29,000 lines - grep only): get_athlete(id) ~5649, get_booked_fight_opponent(athlete_id) ~3535.

## Do
1. When a day-plan block with station_kind "ring_spar" starts (switch `spar_block` ON): build the pool from the player's gym (the other
   fighters of the club, plus any hired partner rows if the game has them - say in the PR what you used), call SparringBlock.plan_block with
   the boxer, the booked opponent (get_booked_fight_opponent; {} if none), his readiness (store it on the athlete as `gameplan_readiness`,
   0 when absent), prefer "mirror", seed "<athlete id>|<career day>|<block index>". No safe partner -> a floor toast with `reason`, and the
   block runs as plain ring work (no moments).
2. Each planned moment, at its minute inside the block, goes through `push_card("spar", {...moment, index})` - add "spar" to `_card_live`.
   The player's option goes to resolve_moment(planned, index, call_id, ctx); if the card cannot open (decision_card OFF) resolve with "" (the
   auto call). Apply each result's strain/cut_risk the way the floor applies the other cards' (grep how niggle/corner apply theirs).
3. At the block's end: finish_block(...) with GameplanReadiness.plan_for(opponent), the block's minutes, its card id ("" if none), clean_reps
   from the floor's form state (say which in the PR); add readiness_add to the athlete's `gameplan_readiness` (clamped 0..100), multiply
   gain_mult into `_dp_gain` for that block, and write the `lines` to the floor's day log / toast.
4. GLOW: in the Morning Day Plan panel ctx pass `glow` = GameplanReadiness.glow(plan_for(opponent), the plan's station kinds); in the floor,
   the places running a glowing station get the same highlight the floor already uses for a suggested station (grep "highlight" /
   "suggest" - reuse it, add no new art). No booked fight -> no glow.
5. With `spar_block` OFF the floor runs exactly as today (control arm).

## Tests (red on master first - paste the red lines in the PR body)
New `tests/spar_block_floor_test.gd` modelled on tests/day_plan_floor_test.gd. Population printed: a welterweight male boxer with a booked
southpaw swarmer, a club of 4 others (a safe mirror, a female, a heavyweight, one 30 levels above). Assert: OFF -> no spar card, no readiness
change; ON with a 60-min ring_spar block -> the partner is the safe mirror, 2 spar cards are pushed inside the block's minutes, gameplan_readiness
rises after the block (bounded 0..100, > before); a pool with only unsafe partners -> no cards, the reason toast, the block still trains;
glow is non-empty with a booked opponent and empty without.
Must stay green: day_plan_floor_test, floor_wire_test, breakthrough_floor_test, floor_events_floor_test, niggle_floor_test,
form_breakdown_floor_test, floor_cuts_test, floor_queue_next_test, block_stop_floor_test, floor_actions_test, sparring_block_test,
room_camera_flow_test. `gym_club_3d_test` needs LFS - Claude runs it.
Parse gate: `python Godot/tools/check_scripts.py <every touched .gd>`.

## Rules
GDSCRIPT_TRAPS.md (typed reads, no `:=` on a Variant, no `%%`). Do not edit rules/SparringBlock.gd, PartnerPool.gd, SparringFlash.gd,
GameplanReadiness.gd, DayPlan.gd, ui/DayPlanPanel.gd (if the panel needs a `glow` read, put the request in the PR body - Claude adds it).
THE ONE TRAP: safety first - an unsafe partner never spars, not for a seed, a preference or a fee. Comment "SPARWIRE1 DONE" with the test lines.

## Prior research
TASK_SPARBLOCK1.md, TASK_L4READY1.md (GameplanReadiness - readiness never decides a fight), K86 (sparring moments, max 2 a block, every call
costs something), K87_DECISION_PACING_REPLY.md (Sparring Flash priority 2, never waits), TASK_DAYPLANWIRE1.md.

## What would a human do?
The coach picks the gym's lefty who pressures like Saturday's man, watches the rounds, shouts one thing at the key moment, and writes down
afterwards that the fighter is a bit more ready for that style. The whiteboard marks the drills that matter for this opponent.

## Prefab check
None - all four rules modules are ours; this round only wires them.

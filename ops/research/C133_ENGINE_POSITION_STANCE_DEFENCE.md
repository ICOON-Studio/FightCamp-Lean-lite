# C133 - what the engine has for position, stance, defence, feints and the gaps

## ANSWERS

Q1. RING AND CAGE. In the FightRealtime engine, `place_of` is consumed by
`_run_decision` and copied into impact records; `pressure` and `is_cornered`
have no consumer (rg over the named production files found only their
RingSpace definitions). `half_width` is consumed by RingSpace's wall/clamp/
step/place/pressure functions and FightRealtime movement/body separation.
`arena_profile` does reach FightRealtime: `begin` calls
`Space.shape_for_arena`, and RingSpace maps only `mma_cage` to octagon; other
profiles remain square. Thus the cage is shaped differently in this engine.

Q2. CUTTING OFF AND CIRCLING OUT. `close` starts at `toward`; with `cut_off`
it adds the other fighter's carried velocity times `_cut_off_lead`. `retreat`
is `-toward`. `circle` starts as the fixed perpendicular
`Vector2(-toward.y, toward.x)` and, with `circle_out`, `_circle_direction`
compares open room on both sides. So circle direction is a decision now, but
close/retreat still aim at the other man, not open floor. There is no separate
open-floor chaser: rg found no consumer steering close toward a floor point;
the only open-room steering is circle-out.

Q3. STANCE. BalanceState.gd has no `southpaw` match (rg: no matches); it is a
balance/kuzushi model, not stance. FightSimulation is the separate atomic
engine: it stores athlete `stance`, settles open/closed matchup, and changes
selection/burst weighting; its own comment says no switch-hitting. FightRealtime
also stores `fighter["stance"]` and `stance_matchup`. FightStageDirector is a
label/hand vocabulary: `lead` and `rear` are the mounted hand names and it
explicitly says the room has one clip set. No code switches a fighter's stance;
the real model is FightSimulation's matchup (and the Realtime stored/read
matchup), while StageDirector is presentation labeling.

Q4. DEFENCE. In FightRealtime, attacker contact is first clean/glancing/missed
from attacker-side force and roll. The defender then uses defence stat after
fatigue, his reach band/stance, a selected answering guard and two rolls;
`guard_outcome` maps clean/glancing to absorbed/blocked/slipped. This is a
post-contact outcome, except `_run_evasion` is a separate pre-contact movement
choice. The catalogue does contain selectable guards: `guards_for` builds
guards from defence roles; answering guards exclude footwork. Nine measured
default-rule-set bouts had no blocks because an empty ruleset id has an empty
guard palette and the unnamed fallback only maps clean to absorbed and
glancing to slipped; `blocked` is unreachable there. ImpactModel only prices
the outcomes; it does not decide them.

Q5. FEINTS AND COMMITMENT. A FightRealtime feint is forcibly `CONTACT_MISSED`,
clears defence id/timing, and records `drew_movement` when the defender had
already chosen pre-contact evasion. Thus it does not deliver a blow and can
record an opponent reaction, but it does not create a separate reaction
mechanic. A committed thrower suppresses the defender's answering guard while
the window is live and adds no damage multiplier. The state that carries the
window is `commit_until_tick`, tested through `Commit.is_committed`; it is
also the state used to suppress the thrower's own evasion.

Q6. THE TIME BETWEEN EXCHANGES. `advance_tick` still runs movement every due
movement tick; on a non-decision tick with no impact there is no new action,
but hold movement (8% throttle plus inertia) continues. At 20 Hz, movement is
every tick (0.05 s), impact every 2 ticks (0.10 s), decision every 10 ticks
(0.50 s); the gaps therefore last until the next applicable cadence, not a
fixed exchange sleep. FightRealtime distinguishes the between-exchange
state with `phase` and `phase_until_tick`; `_settle_phase` re-reads it only
when expired and records `phase_ticks`. Plain `intent == hold` is movement,
not measuring/resetting/recovering state.

Q7. WHERE A CHANGE GOES. Ring/cage: FightRealtime._run_movement; tests
`fight_ring_position_test.gd`, `ring_space_test.gd`. Stance: the engine's
stance seam is FightSimulation._stance_matchup (Realtime has its own matchup);
tests `fight_stance_test.gd`, `fight_simulation_test.gd`. Defence:
FightRealtime._run_impact / FightMoves.guard_outcome; tests
`fight_guard_contract_test.gd`, `technique_defence_answers_test.gd`.
Feint: FightRealtime._run_impact; tests `fight_commitment_test.gd`,
`fight_realtime_test.gd`. Between: FightRealtime._run_decision and
`_settle_phase`; tests `fight_between_exchanges_test.gd`, `tick_budget_test.gd`.

## Evidence

- `Godot/scripts/RingSpace.gd:48` "static func shape_for_arena" - arena profile to floor shape.
- `Godot/scripts/RingSpace.gd:49` "return str(SHAPE_BY_ARENA_PROFILE.get(arena_profile, SHAPE_SQUARE))" - MMA is the only octagon mapping.
- `Godot/scripts/RingSpace.gd:92` "shape is described in ONE place" - wall margins feed placement/open-room decisions.
- `Godot/scripts/RingSpace.gd:155` "return place_of(pos, half_width, shape)" - corner predicate is derived, not consumed elsewhere.
- `Godot/scripts/RingSpace.gd:158` "static func pressure" - pressure exists only as a RingSpace function in the searched seams.
- `Godot/scripts/FightRealtime.gd:756` "arena_shape = Space.shape_for_arena" - Realtime reads ruleset shape.
- `Godot/scripts/FightRealtime.gd:1259` "static func place_of(state: Dictionary, side: String)" - Realtime's place adapter.
- `Godot/scripts/FightRealtime.gd:2080` "place_of(state, str(side))" - place affects intent choice.
- `Godot/scripts/FightRealtime.gd:2335` "direction = -toward" - retreat direction.
- `Godot/scripts/FightRealtime.gd:2343` "direction = Vector2(-toward.y, toward.x)" - original circle direction.
- `Godot/scripts/FightRealtime.gd:2345` "direction = _circle_direction(here, toward, half_width, shape)" - open-room circle decision.
- `Godot/scripts/FightRealtime.gd:2385` "var moved: Vector2 = Space.step" - movement is clamped by RingSpace.
- `Godot/scripts/FightFootwork.gd:94` "const THROTTLE_HOLD := 0.08" - hold still moves only at eight percent.
- `Godot/scripts/FightFootwork.gd:141` "static func throttle_for(intent: String)" - intent selects throttle.
- `Godot/scripts/FightIntent.gd:112` "CORNER" - corner changes intent weights.
- `Godot/scripts/FightMoves.gd:92` "STRIKE_ROLES" - only these catalogue roles throw.
- `Godot/scripts/FightMoves.gd:1118` "const GUARD_EVADE_EFFECTS" - defensive catalogue vocabulary.
- `Godot/scripts/FightMoves.gd:1215` "static func answering_guards(live: Array)" - footwork is excluded from answering guards.
- `Godot/scripts/FightMoves.gd:1318` "static func guard_outcome(kind: String, contact: String)" - guard converts contact outcomes.
- `Godot/scripts/ImpactModel.gd:13` "const CONTACTS" - outcomes are impact vocabulary.
- `Godot/scripts/ImpactModel.gd:20` "absorbed" - absorbed is wear pricing, not a choice.
- `Godot/scripts/FightSimulation.gd:501` "OPEN (orthodox vs southpaw)" - atomic engine stance matchup.
- `Godot/scripts/FightSimulation.gd:505` "No switch-hitting" - no stance switch.
- `Godot/scripts/FightStageDirector.gd:167` "southpaw" - director comment labels the matchup; it does not switch it.
- `Godot/scripts/FightStageDirector.gd:170` "the room shows the hand it has" - presentation role.
- `Godot/scripts/FightRealtime.gd:1065` "commit_until_tick" - commitment window state.
- `Godot/scripts/FightRealtime.gd:2740` "Commit.commit_ticks" - throw starts the window.
- `Godot/scripts/FightRealtime.gd:2896` "Commit.is_committed(target, tick)" - committed defender cannot answer.
- `Godot/scripts/FightRealtime.gd:2962` "contact = CONTACT_MISSED" - feints cannot land.
- `Godot/scripts/FightRealtime.gd:2965` "feints_thrown" - feint is recorded as its own count.
- `Godot/scripts/FightRealtime.gd:1333` "_run_decision(state)" - decisions run only on their budget tick.
- `Godot/scripts/FightRealtime.gd:1349` "_run_movement(state)" - movement is separately scheduled.
- `Godot/scripts/FightRealtime.gd:2093` "var next_phase: String = Between.phase_for" - phase state is re-read by decision.
- `Godot/scripts/FightRealtime.gd:2100` "phase_until_tick" - dwell duration is stateful.
- `Godot/scripts/TickBudget.gd:12` "const CADENCE" - cadence creates the gaps.
- `Godot/scripts/TickBudget.gd:24` "static func due_on(tick: int) -> Array" - only due subsystems run.

## Where a change goes

| behaviour | one seam | tests that pin moved numbers |
|---|---|---|
| ring | `FightRealtime.gd:2271 _run_movement` | `fight_ring_position_test.gd`, `ring_space_test.gd` |
| stance | `FightSimulation.gd:3542 _stance_matchup` | `fight_stance_test.gd`, `fight_simulation_test.gd` |
| defence | `FightRealtime.gd:2881 _run_impact` | `fight_guard_contract_test.gd`, `technique_defence_answers_test.gd` |
| feint | `FightRealtime.gd:2960 _run_impact` | `fight_commitment_test.gd`, `fight_realtime_test.gd` |
| between | `FightRealtime.gd:2090 _settle_phase` | `fight_between_exchanges_test.gd`, `tick_budget_test.gd` |

## Open

No proposal is made here. The documented claims are engine-specific: FightRealtime is not FightSimulation. `pressure` and `is_cornered` have definitions but no consumer in the searched named production files; the absence search was `rg -n 'place_of|pressure|is_cornered|half_width'` over the named production files. A broader repository audit was not part of C133.

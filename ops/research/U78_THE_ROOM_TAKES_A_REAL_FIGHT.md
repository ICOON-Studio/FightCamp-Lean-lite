# U78 — The room takes a real fight (census for S4)

Stage S4 makes `FightWorldLiveScreen` accept a booked career bout. This census
records every hardcode, the player booking path (not the dev route), body and
arena coverage, and a proposed entry contract. Options only — no code.

## HARDCODES

| File | Line | Token | What it fixes today | Must become |
| --- | --- | --- | --- | --- |
| FightWorldLiveScreen.gd | 27 | `f01_m_box_welter_rigged.glb` | Fighter A mesh | Body chosen from athlete sex + discipline + weight |
| FightWorldLiveScreen.gd | 28 | `f02_m_box_heavy_rigged.glb` | Fighter B mesh | Same for athlete B |
| FightWorldLiveScreen.gd | 29–30 | `KG_A` / `KG_B` | 66.7 / 120.0 kg mount mass | `competition_weight_kg` per athlete |
| FightWorldLiveScreen.gd | 32 | `"boxing"` | Discipline for arena + ruleset | `contract.discipline` or ruleset id |
| FightWorldLiveScreen.gd | 33 | `94301` | Seed | `contract.simulation_seed` |
| FightWorldLiveScreen.gd | 34 | `ROUNDS` | 3 rounds | `ruleset.rounds` |
| FightWorldLiveScreen.gd | 137–138 | `"male"` | Sex for both mounts | Each athlete's sex |
| FightWorldLiveScreen.gd | 130 | `DISCIPLINE` | Arena spec lookup | `ArenaSurface.for_discipline(bout discipline)` |
| FightWorldLiveScreen.gd | 173–176 | `SEED` / `DISCIPLINE` | `FightBeatAdapter.begin` options | Contract seed + ruleset dictionary |
| FightWorldLiveScreen.gd | 448–484 | `demo_fighter` | Fixed sex, height 175, boxing techniques, identical stats | Full fight-ready athlete dicts from booking |

The dev route `SceneRouter` `"fight_world_live"` (line 121) reaches this screen
with none of the above supplied — it is not the game path.

## WHERE A BOOKED BOUT LIVES

**At booking (`GameState.book_fight`, line 10631):** the offer id is written to
`athlete["booked_fight"]` (line 10781). The offer carries opponent, event,
`ruleset_id`, weight class, venue, scheduled week, and organization. Fight plan
and title/grudge flags ride on the athlete record.

**Due day/week:** `get_booked_fight_due_day(offer_id)` (line 2727) and
`get_booked_fight_due_week` gate when the bout may be entered.

**Fight-week card:** `get_fight_week_card(athlete_id)` (line 14445) projects
opponent, event, venue, `ruleset_id`, stakes, camp, and weight status for the
set-piece UI. Nothing new is stored — it reads the booking.

**Live contract (the payload a fight screen needs):**
`get_world_bout_contract(event_id, bout_index)` (line 805) returns
`ruleset_id`, `discipline`, `weight_class`, `simulation_seed`, `athlete_a`,
`athlete_b` (fight-ready snapshots with natural plan), `event_id`, and
`bout_index`. For a player-booked open slot, athlete B is substituted from
`get_offer_booked_athlete("event|…")` after medical enforcement.

**Player path to a fight screen (not `fight_world_live`):**

1. `DayFeedPanel._enter_fight_week` → `router.push("fight_week", {athlete_id})`
2. OR `ScheduleHubPanel._on_enter_fight_week` → `fight_week` with `{event_id, mode: "live"}`
3. `SetpieceRoot` phases: `fight_week` → `weigh_in` → `fight_night`
4. `FightNightScreen.setup(bout_id, mode)` — live mode expects
   `bout_id = "<event_id>#<bout_index>"` (`live_bout_id`, line 90)
5. `_open_live` loads the contract and calls `FightBeatAdapter.begin` for
   realtime rulesets (`REALTIME_RULESET_IDS`: boxing, mma, kickboxing, muay_thai)

**Handover point for the 3D room:** immediately after
`get_world_bout_contract` resolves in `FightNightScreen._open_live` (line 289),
alongside the existing `FightBeatAdapter.begin` call (line 322). The room must
consume the same contract dict and seed — not re-derive from dev constants.

**Gap in today's set-piece args:** `route_args` carry `athlete_id` or
`event_id` + `mode`, but not `bout_id`. `SetpieceRoot` only calls
`FightNightScreen.setup` when `route_args.has("mode")` (line 242). S4 must
ensure `bout_id` and `mode: "live"` are injected before the `fight_night` phase.

## WHICH BODY

Twelve rigged files; names encode `f##_sex_discipline_weight`.

**Selection rule (proposed):** match sex first (files are `m` or `f` only), then
map career discipline to the nearest file discipline (`boxing` → `box`, `mma` →
`mma`, bare-knuckle promotions → `bare`), then pick the closest weight-class
token in the filename (welter, heavy, fly, middle, light, lhw, straw, bantam,
feather). Apply `FighterPhysique.describe(limit_kg, weight_kg, sex, mesh_height_m)`
for `height_scale` and girth on mount.

**C98 and the two 1.00 m meshes:** f06 (`m_mma_lhw`) and f08 (`f_mma_bantam`)
measure 1.00 m raw mesh height where the other ten are 1.75 m or 1.85 m. This
is a POSITION-unit discrepancy, not a node scale. Any body picker must pass the
file's measured height into `FighterPhysique.height_scale` or those two athletes
render at the wrong stature unless a different file is chosen.

**No fitting body today (examples):**

- Judo, karate, taekwondo, wrestling, BJJ, sambo — no discipline token in any filename
- Female heavyweight — no `f_*_heavy` file
- Male boxing fly/bantam/feather — only welter + heavy for men
- Kickboxing / muay thai — no `kick` or `thai` token; nearest is `box` or `mma`
- Male strawweight — only `f_mma_straw`

## WHICH ARENA

Realtime rulesets (the ones `FightNightScreen` would share with the 3D room):

| Ruleset | arena_profile | Built today? | Evidence |
| --- | --- | --- | --- |
| boxing | boxing_ring | yes | Only profile `FightWorldLiveScreen` actually mounts (hardcoded boxing) |
| kickboxing | boxing_ring | yes* | `ArenaSurface` → `boxing_ring_fl_min` via `ArenaRig`; screen does not swap discipline |
| muay_thai | boxing_ring | yes* | `ArenaSurface` → `muaythai_ring_ifma`; screen never calls it |
| mma | mma_cage | yes* | `ArenaSurface` → `mma_cage_gym_6m` via `ArenaRig`; screen hardcodes boxing |
| judo | judo_tatami | yes† | `MatRig` + `judo_ijf`; screen never loads `MatRig` |
| freestyle_wrestling | wrestling_mat | yes† | `MatRig` + `wrestling_uww` |
| greco_roman | wrestling_mat | yes† | Same mat spec via wrestling discipline |
| karate | karate_tatami | yes† | `MatRig` + `karate_wkf` |
| bjj | grappling_mat | yes† | `MatRig` + `bjj_ibjjf` (profile label ≠ spec id) |
| sambo | sambo_mat | yes† | INHERITED `wrestling_uww` — no `sambo_mat` spec id |
| taekwondo | taekwondo_tatami | yes† | `MatRig` + `taekwondo_wt` |

\* Engine can build; `FightWorldLiveScreen` does not route to it today.
† Requires `MatRig` path; screen only calls `ArenaRig`.

Non-realtime rulesets (judo, wrestling, karate, BJJ, sambo, taekwondo) use
`FightSimulation` on `FightNightScreen` — the 3D room is irrelevant unless S4
also moves those bouts.

## THE ENTRY CONTRACT

**Option A — static factory (matches `demo_fighter` pattern):**

```gdscript
static func begin_from_contract(payload: Dictionary) -> bool
```

**Option B — scene parameter:** router / `SetpieceRoot` passes the same dict in
`route_args["room_contract"]` and `setup()` reads it.

**Proposed `payload` fields (each traced to booking):**

| Field | Source |
| --- | --- |
| `athlete_a` | `get_world_bout_contract(...).athlete_a` |
| `athlete_b` | `get_world_bout_contract(...).athlete_b` |
| `ruleset` | `game_state.get_ruleset(contract.ruleset_id)` — full dict for `FightBeatAdapter.begin` |
| `seed` | `contract.simulation_seed` |
| `rounds` | `ruleset.rounds` |
| `discipline` | `contract.discipline` → `ArenaSurface.for_discipline` |
| `arena_profile` | `ruleset.arena_profile` from `combat_rulesets.json` (display / validation) |
| `body_a` / `body_b` | Chosen `.glb` paths from sex + discipline + weight mapping |
| `mesh_height_a` / `mesh_height_b` | C98 measured height for chosen file |
| `event_id` | `contract.event_id` (readout / debug) |
| `bout_index` | `contract.bout_index` |

The screen would still call `FightBeatAdapter.begin(athlete_a, athlete_b, options)`
with the same options shape `FightNightScreen._realtime_begin_options` builds.
Presentation constants (`BEAT_SECONDS`, `RANGE_M`, `STEP_MPS`) stay as-is.

**Where to invoke:** from `FightNightScreen._open_live` when
`ruleset_uses_realtime(_ruleset_id)` — mount or hand off to
`FightWorldLiveScreen` instead of (or behind) `RingStagePanel` for the beat
stream. Do not add a new `SceneRouter` dev route for career bouts.

## GAPS

- No code path connects a booked bout to `FightWorldLiveScreen` — only dev route `fight_world_live`.
- Set-piece chain does not inject `bout_id` / `mode: live` before `fight_night`.
- All fighter, seed, discipline, sex, stats, and techniques are hardcoded in the room.
- `FightWorldLiveScreen` never calls `MatRig` — mat rulesets cannot render in the room.
- No rigged body for judo, karate, taekwondo, wrestling, BJJ, or sambo disciplines.
- No female heavyweight body; limited male boxing weight coverage.
- f06 and f08 need C98 height_scale correction or different body choice.
- `arena_profile` labels (`grappling_mat`, `sambo_mat`) do not match `mat_specs.json` spec ids — mapping layer needed.
- Non-realtime rulesets stay on `FightSimulation` / `RingStagePanel` — out of scope unless S4 expands.

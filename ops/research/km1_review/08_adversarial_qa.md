# Reviewer #8 — Adversarial QA

## What the evidence says the game is

FightCamp is a Godot 4.7.2 PC management sim: build a gym, sign/train fighters, book fights, watch them resolve in a 3D ring. The active milestone is **"Playable with a Boxer"** (roadmap stage B, 58%). The career walk (`s117_boxer_walk.plan`) is verified end-to-end with `as_game`: new career → Cyprus/Nicosia → roster → training → scouting/staff/contracts → book a boxing bout → camp → weigh-in → fight night → SIM TO RESULT → next week → save. The real-time engine (`FightRealtime.gd`) drives boxing/MMA/kickboxing/Muay Thai; judo/taekwondo/freestyle wrestling stay on the atomic `FightSimulation.gd`. Boxing has **16/36** C223-gated moves certified on the four generated legal male bodies; kickboxing has **0/20**.

Key evidence used: task brief, S117/S119/S121/S122/S75 digests, `GAME_DESIGN.md`, `CURRENT_STATUS.md`, `DECISION_LEDGER.md`, `AgentComms/roadmap.json`, the S117 walk plan, and grep windows into `GameState.gd`, `FightNightScreen.gd`, `RingStagePanel.gd`, `FightSimulation.gd`, `FightBeatAdapter.gd`, `ManagementChrome.gd`, `SceneRouter.gd`, plus focused runs of `career_loop_walk_test.gd` and `judge_panel_test.gd`.

## Missing material

- **No exported `.exe`**: blocked by operator ruling D3 until all 36 boxing clips pass the gate.
- **No operator playtest report** for this build (S75 notes one did not arrive).
- **No audio playback verification**: Dummy audio driver on this PC; audio reviewed from files/code only.
- **No rendered video / watch-loop verdict** for the current build.
- **`AgentComms/nightly/latest.txt` does not exist** on disk; latest suite state is taken from the digests (23 fails at 6d2a4201).
- **No female legal pair** exists for generated bodies (S117 known gap).
- **No novice population** in the world, so the amateur novice matchmaking rule cannot fire (S75).

---

## Strengths to protect

1. **Atomic Career save** (`GameState.gd:3281-3307`): writes to `.tmp`, rotates `.bak`, publishes `.json`, and cleans up. Smoke explicitly asserts no `.tmp`/`.bak` debris after a normal save.
2. **Save incompatibility is surfaced**, not swallowed (`GameState.gd:3358-3360`): hand-edited version mismatches show as `incompatible` cards.
3. **Career walk is gated**: `career_loop_walk_test.gd` passes 0 failures; the board-bout dead-end that locked `advance_week()` is closed.
4. **SIM TO RESULT works** (`FightNightScreen.gd:869-881`) and reaches the same result screen; the walk reached save.
5. **Real-time/atomic ruleset split is machine-checked** (`judge_panel_test.gd` T10): damage-weighted rulesets run `FightRealtime`, the rest run `FightSimulation`.
6. **Seeded replay integrity** is held by `fight_realtime_test.gd` (reported 0 failures in digests).
7. **Generated legal weight pairs** (welter a/b, heavy c/d) are the default, and the old Tripo male arm is no longer reviewed as current.

---

## Findings

### 1. Career saves have no integrity check — a hand-edited JSON loads as valid
- **What**: `_read_save()` parses the JSON and `_is_supported_career()` only checks `save_version`, `world`, `gym`, and `time` dictionaries (`GameState.gd:3519-3529`). There is no checksum/HMAC.
- **Where**: `GameState.gd:3519-3529`; `save_slots_api_test.gd:56-72` demonstrates hand-editing `save_version` is the only validated field.
- **Evidence / repro**: Open `user://saves/career_slot_N.json`, change `gym.cash`, `roster[].record`, or `roster[].stats`, load the slot. The game accepts it.
- **Why it matters**: Players can trivially edit cash, records, attributes, and injuries offline.
- **Severity**: Medium
- **Confidence**: High
- **Fix**: Store a HMAC/SHA-256 of the serialized JSON in `meta.save_hash` on `save_current_career()`; `_read_save()` rejects mismatched or missing hashes as `incompatible`.
- **Effort**: Small
- **Status**: CONFIRMED

### 2. Save schema version is still 1 after months of additive schema changes
- **What**: `SAVE_VERSION := 1` (`GameState.gd:120`) has never been bumped, despite new systems: `BodyReadiness`, `WeeklyObjectives`, `plan_setup`, `simulation_world`, sponsorship, etc.
- **Where**: `GameState.gd:120`, `GameState.gd:3269`, `GameState.gd:3310-3336`.
- **Evidence / repro**: `load_career()` migrates only `AthleteDevelopment`, `BodyReadiness`, and `TaleOfTape`; other new fields are back-filled lazily. An older save missing `objectives`, `event.selected_ruleset_id`, or `simulation_world` may load with empty defaults.
- **Why it matters**: Silent defaulting can cause missing objectives, wrong ruleset selection, or a regenerated world that differs from the original.
- **Severity**: Medium
- **Confidence**: High
- **Fix**: Bump `SAVE_VERSION` and add a versioned migration table in `load_career()` that fills required fields deterministically.
- **Effort**: Medium
- **Status**: CONFIRMED

### 3. Atomic save rotation can corrupt the slot if the process is killed mid-write
- **What**: `_write_save_atomic()` deletes the backup, renames the old save to `.bak`, then renames the temp to final (`GameState.gd:3293-3307`). A kill between `rename(final→bak)` and `rename(tmp→final)` leaves only `.bak`.
- **Where**: `GameState.gd:3281-3307`.
- **Evidence / repro**: Smoke asserts no debris after a clean save; no test simulates a crash mid-rotation.
- **Why it matters**: A crash during autosave can destroy the only good Career file.
- **Severity**: Medium
- **Confidence**: High
- **Fix**: On load, if the main file is missing/corrupt but `.bak` exists and parses, restore from `.bak` and warn. Also `fsync` the temp file before renaming.
- **Effort**: Small
- **Status**: CONFIRMED

### 4. Amateur novice matchmaking has no legal opponents in the world population
- **What**: G96's rule says a novice (0–10 bouts) meets only novices, and the 0–2 debut rule is named but not enforced. The world population has **zero** fighters with ≤2 bouts (`S75_DIGEST.md:36-38`).
- **Where**: `S75_DIGEST.md:36-38`; `AmateurBooking.gd` / `get_booked_fight_opponent` path.
- **Evidence / repro**: `tools/s75_amateur_pool_census.gd` found 0/60 pool opponents with ≤2 bouts across four countries.
- **Why it matters**: The desk shows unsafe rows like "TEN FIGHTS TO NONE"; an amateur boxer career path may offer impossible or mismatched bouts.
- **Severity**: High
- **Confidence**: High
- **Fix**: Seed the world population with a novice tier, or relax the novice-only filter and display a clear "pro debut" warning.
- **Effort**: Medium
- **Status**: CONFIRMED

### 5. No legal same-class female pair exists for generated bodies
- **What**: `career_mesh_weight_class_test` prints that no same-class female pair exists (`S117_DIGEST.md:17`).
- **Where**: `S117_DIGEST.md:17`; generated fighter pipeline.
- **Evidence / repro**: Run a female boxer career and book a bout; the renderer may mismatch weight classes or fall back to male bodies.
- **Why it matters**: A core milestone is "playable with a boxer"; if that boxer is female, visual/legal correctness fails.
- **Severity**: High
- **Confidence**: High
- **Fix**: Generate female welter and heavy legal pairs, or constrain female matchmaking to existing legal classes.
- **Effort**: Large
- **Status**: CONFIRMED

### 6. Feints are invisible in the 3D room
- **What**: The engine emits ~7 feints/min (within G86's 6–14 band), but the live room presents none (`S119_DIGEST.md:49`).
- **Where**: `S119_DIGEST.md:49`; `FightBeatAdapter._present()` / `FightStagePlayer`.
- **Evidence / repro**: Operator video (`s119_showreel.gd`) shows no feint motion; only punches and reactions render.
- **Why it matters**: A player watching the fight sees a different action mix than the engine scored; feints as a tactic are hidden.
- **Severity**: Medium
- **Confidence**: High
- **Fix**: Add a dedicated feint animation/stance-shift clip or a subtle HUD cue when the chosen action is a feint.
- **Effort**: Medium
- **Status**: CONFIRMED

### 7. Booked-bout judges never disagree — 0 split decisions in 54 bouts
- **What**: Q212 census found **0 split decisions in 54** booked boxing bouts; KO+TKO 46.7%, draws 5.8% (`S119_DIGEST.md:45-46`). The `judge_panel_test.gd` fixture can produce non-unanimous cards, but the live population does not.
- **Where**: `S119_DIGEST.md:45-46`; `FightBeatAdapter.state_view()` → `JudgePanel` path.
- **Evidence / repro**: Run `tools/u195_engine_census.gd bouts=...` on booked bouts and inspect judge cards.
- **Why it matters**: Corner/range instructions and fighter style differences should create scorecard variance; unanimous every bout means the judging model is too homogenized in the live loop.
- **Severity**: Medium
- **Confidence**: High
- **Fix**: Verify `judge_sigma` and per-bout bias are applied on the real-time result path, not only in the test fixture.
- **Effort**: Medium
- **Status**: CONFIRMED

### 8. Real-time corner instructions ignore coach rapport (listen_chance is always 1.0)
- **What**: `FightBeatAdapter.apply_corner_instruction()` returns `"listen_chance": 1.0` unconditionally (`FightBeatAdapter.gd:529-531`). `CoachRapport` exists but is not called here.
- **Where**: `FightBeatAdapter.gd:498-540`.
- **Evidence / repro**: Grep `listen_chance` in `FightBeatAdapter.gd`; only the literal 1.0 appears. Atomic path uses `FightSimulation` + `CoachRapport`.
- **Why it matters**: The "coach bond" built on the training floor has no effect during the payoff fight; strategic advice always lands.
- **Severity**: Medium
- **Confidence**: High
- **Fix**: Call `CoachRapport.listen_chance(fighter, coach)` and set `outcome.listen_chance` / `applied` accordingly.
- **Effort**: Small
- **Status**: CONFIRMED

### 9. SIM TO RESULT safety limit can exhaust without finishing, leaving the fight stuck
- **What**: `_on_sim()` loops until `safety <= 0` or `_finished`. If the safety limit is exhausted without a finish, it returns without calling `_finish()` (`FightNightScreen.gd:869-881`).
- **Where**: `FightNightScreen.gd:869-881`, `_tick_safety_limit()` at `:1616-1624`.
- **Evidence / repro**: With very long round/rest configs or a hung real-time tick, `_on_begin()` blocks re-entry because `_finished` is still false.
- **Why it matters**: A rare edge case leaves the player on a fight screen with no way to complete or exit cleanly.
- **Severity**: Low
- **Confidence**: Medium
- **Fix**: If safety reaches 0 and the fight is not over, call `_finish()` with a `method: "NO CONTEST"`/`"TIME"` fallback, or show an error overlay with BACK HOME.
- **Effort**: Small
- **Status**: ASSUMPTION

### 10. Arena speed buttons mutate global `Engine.time_scale` and reset only on finish/leave
- **What**: `_build_arena_speed()` sets `Engine.time_scale = speed_value` (`FightNightScreen.gd:975`). `_on_arena_finished()` and `_on_leave()` reset it, but an abnormal exit (crash, force-quit, alt-tab) may leave it changed.
- **Where**: `FightNightScreen.gd:967-987`, `:995`, `:1486`.
- **Evidence / repro**: Set 4X, kill Godot mid-fight, relaunch; menus may run at 4X.
- **Why it matters**: Global time scale leaking out of the fight affects UI animations and timers.
- **Severity**: Low
- **Confidence**: Medium
- **Fix**: Reset `Engine.time_scale = 1.0` in `_ready()` of `BootRoot`, `CareerRoot`, and `SetpieceRoot`.
- **Effort**: Small
- **Status**: ASSUMPTION

### 11. Arena result swaps winner side but not round cards/scorecard names when player is side "b"
- **What**: `_on_arena_finished()` swaps `winner_side` if `_arena_swap` (`FightNightScreen.gd:1002-1005`), but the rest of `_result` (cards, judge totals, athlete names/ids) is passed through unchanged.
- **Where**: `FightNightScreen.gd:1002-1005`, `_present_player_result()` at `:1431-1468`.
- **Evidence / repro**: If the player's fighter is ever placed on side "b", the result screen may show the opponent's card as the player's.
- **Why it matters**: Misattributes the official result to the wrong fighter.
- **Severity**: Medium
- **Confidence**: Medium
- **Fix**: When `_arena_swap`, also swap `names`, `_ids`, and mirror judge/round card sides before building the payload.
- **Effort**: Small
- **Status**: ASSUMPTION

### 12. Dev/debug routes are registered in the router and reachable from any caller
- **What**: `SceneRouter.ROUTES` includes `"fight_world_preview"` and `"fight_world_live"` with `tier: "dev"` (`SceneRouter.gd:133-138`).
- **Where**: `SceneRouter.gd:133-138`.
- **Evidence / repro**: Any screen that calls `router.push("fight_world_preview")` can open the debug scene in a release build.
- **Why it matters**: Operator-facing debug routes could accidentally ship as player-accessible.
- **Severity**: Low
- **Confidence**: Medium
- **Fix**: Gate dev routes behind `OS.is_debug_build()` or remove them from `ROUTES` in the export pipeline.
- **Effort**: Small
- **Status**: ASSUMPTION

### 13. Career walk is only verified for one country/city/discipline path
- **What**: `s117_boxer_walk.plan` hard-codes Cyprus → Nicosia → boxing. No parameterized walk covers other starter markets or disciplines.
- **Where**: `research/s117_boxer_walk.plan`; `career_loop_walk_test.gd`.
- **Evidence / repro**: The only end-to-end test uses Cyprus/Nicosia. Other markets (Thailand/Bangkok, Iceland/Reykjavík) are exercised in smoke for creation but not the full career loop.
- **Why it matters**: Dead ends, wrong-discipline bookings, or missing UI buttons may exist in other markets.
- **Severity**: Medium
- **Confidence**: High
- **Fix**: Add plan files and test runs for at least one kickboxing/Muay Thai/MMA starter path.
- **Effort**: Medium
- **Status**: CONFIRMED

### 14. Known test failures are still red on master
- **What**: The digests report ~23 suite fails, including `fight_back_bands`, `fight_plan_ai_corner`, `fight_footwork_economy`, and `fighter_reachability` (`S122_DIGEST.md:98-99`; S119 nightly 23 fails).
- **Where**: `AgentComms/nightly/latest.txt` (missing), `S122_DIGEST.md:98-99`.
- **Evidence / repro**: `run_tests.py` on master reports these reds.
- **Why it matters**: Unfixed engine reds are regression landmines for the career loop.
- **Severity**: High
- **Confidence**: High
- **Fix**: Address each red as documented in S122; do not add new features until the suite ceiling is met.
- **Effort**: Large
- **Status**: CONFIRMED

### 15. Clipping gate still fails — head contact remains un-pinned, arm/torso gaps persist
- **What**: Q213 landed with head class 4 / arm 51 / torso worst 6.6 cm; the gate requires head 0 (`S121_DIGEST.md:14-16`).
- **Where**: `S121_DIGEST.md:14-16`; `Godot/tools/q213_clip_gate.gd`.
- **Evidence / repro**: Run `q213_clip_gate` on a boxing seed; head contact is still not at the surface.
- **Why it matters**: Gloves/limbs visibly intersect; the operator's "bodies overlap" complaint is not fully closed.
- **Severity**: High
- **Confidence**: High
- **Fix**: Implement G147 fixes: IK glove pin at head surface, hit-stop, blend times 80–300 ms.
- **Effort**: Large
- **Status**: CONFIRMED

### 16. Legacy `UserSettings` routing flags may not be fully cleared on career switch
- **What**: `_clear_career_routing_flags()` only calls `UserSettings.clear_career_routing_flags()` if the method exists (`GameState.gd:3176-3179`). It does not explicitly zero `pending_event_id` / `pending_schedule_focus_offer`.
- **Where**: `GameState.gd:3176-3179`; `SceneRouter.gd:156-159`.
- **Evidence / repro**: If `UserSettings` is missing the method, stale flags persist across `load_career()`.
- **Why it matters**: A stale `pending_event_id` could route the player to an event that does not exist in the new career.
- **Severity**: Low
- **Confidence**: Medium
- **Fix**: Explicitly wipe the two legacy flag keys in `begin_new_career()` and `load_career()` regardless of method presence.
- **Effort**: Small
- **Status**: ASSUMPTION

### 17. Walk plan button labels are case-sensitive and fragile
- **What**: `s117_boxer_walk.plan` uses both `SAVE` and `Save` as fallback (`s117_boxer_walk.plan:111-112`).
- **Where**: `research/s117_boxer_walk.plan:111-112`.
- **Evidence / repro**: The walk passes now, but a UI copy change breaks it.
- **Why it matters**: The primary end-to-end gate is coupled to label text rather than stable button IDs.
- **Severity**: Low
- **Confidence**: Medium
- **Fix**: Add stable `name`/`id` metadata to walk buttons and update `tools/s64_career_walk.gd` to press by ID.
- **Effort**: Small
- **Status**: PREFERENCE

---

## Tests run

| Test | Result | Notes |
|------|--------|-------|
| `tests/career_loop_walk_test.gd` | **PASS** (0 failures) | End-to-end career walk through booked bout, result, and week advance. |
| `tests/judge_panel_test.gd` | **PASS** (0 failures) | Confirms non-unanimous cards are possible in the fixture; population-level variance is the open issue (Finding 7). |

Both runs emit font/audio import errors under `--headless` (expected on this PC without the `.godot` cache); they do not affect the pass/fail result.

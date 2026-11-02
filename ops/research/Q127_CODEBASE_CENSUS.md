# Q127 — Codebase Census

**Author:** qwen · 2026-09-22
**Scope:** read-only; no `.gd` touched. 740 scripts, 325 tests, 14 832-line GameState.

---

## Three-line summary

**Most important finding:** `GameState.gd`'s `WEIGHT_CLASSES` has **four** entries; every other module that names weight classes has **eight, nine or ten**. The rankings board shows eight tabs; four of them are permanently empty for every fighter the career generator produces. This is silent, structural, and has been shipping.

**First change:** unify weight-class enumeration on `weight_classes.json` (the authoritative data file) and delete every hardcoded list. One source of truth, loaded once.

**Direction is right.** The simulation layer is genuinely strong — 323 tests, a real damage/balance/grapple model calibrated against published MMA statistics, a contact solver (`FightPoseSolver`) that scans every capsule A×B for penetration. The weak half is still the 3D presentation (the operator's own verdict), and the rot this census finds is mostly in the seams between modules, not in the modules themselves.

---

## 1. Wired to nothing

Three modules exist, are tested, and have **zero production callers** (excluding `FightPoseSolver.gd`, which is known-deliberate).

### 1a. `FightClipAudit.gd`

- **class_name** declared at line 1.
- Referenced by `tests/fight_clip_audit_test.gd` (preload + calls).
- **No other script in `Godot/scripts/` or `Godot/scenes/` mentions it** — not in a comment, not in a preload, not in a load path.
- It audits animation clips for locomotion consistency. Useful utility, but nothing in the game calls it at runtime.

### 1b. `FightPairedAnchor.gd`

- **class_name** declared at line 1.
- Referenced by `tools/probe_cmu_grip.gd` (a probe, not production) and `tests/fight_paired_anchor_test.gd`.
- **No production script preloads or loads it.** The test itself says `"SKIP: FightPairedAnchor.gd not present yet; contract test is inert"` when the file is missing — it is structured as a forward contract.
- Provides `to_rig_local` coordinate conversion for paired-mount geometry. `FightWorldLiveScreen` and `PairedStagePlayer` do their own transforms without it.

### 1c. `FightHudRead.gd`

- **class_name** declared at line 1.
- Referenced only in **comments** in production code: `FightHudPanel.gd:1` ("Renders a FightHudRead fold"), `FightRealtime.gd:52/1143/1249/1728` (prose describing what the HUD shows).
- **No production code preloads, loads, or calls any of its functions.** The panel that is supposed to render its output builds its data through a different path (likely inline or via GameState).
- Has a test (`tests/fight_hud_read_test.gd`) that loads it directly and asserts on its output. The test passes; the module is unused.

**What would prove me wrong:** if any `.tscn` scene file references `FightHudRead` via a script property or exported variable. I checked `.gd` files only; scene-tree wiring is the one path grep cannot see.

---

## 2. Gates that cannot fail

The U124 census (`research/U124_DECLARED_ONLY_GATES.md`) already documented the worst of these in detail. I confirm its top finding and add one it did not cover.

### 2a. `fight_body_overlap_test.gd` — worst penetration over a declared subset (U124 #1)

- **File:** `Godot/tests/fight_body_overlap_test.gd:14,32-34,71-72`
- **Global claim:** `"no refused head/hand penetration in %d frames (worst %.4f m)"`
- **What it iterates:** `REFUSED_PAIRS := ["hand>head", "arm>head", "head=head"]`
- **What it cannot see:** Every other class pair the room cares about: `head>arm`, `head>torso`, `torso=torso`, `arm>torso`, etc. — all present in `FightWorldLiveScreen.OVERLAP_ALLOWANCE_M` (`FightWorldLiveScreen.gd:416-428`).
- **Concrete fool:** `arm>head` is not a key `FightBodyCapsules.class_pair_key` can produce (head rank 1, arm rank 2 → always `head>arm`). The middle entry in `REFUSED_PAIRS` matches **zero** part pairs. A bout can show skull-in-shoulder (`head>arm` depth > 0) and the test still prints `ok` with `worst 0.0000 m`.
- **Input that slips through:** Any frame where `head>arm` penetrates but `hand>head`, `arm>head` (never emitted), and `head=head` are clean.

### 2b. `weight_cut_test.gd` — fixture defect, not an assertion defect

- **File:** `Godot/tests/weight_cut_test.gd`
- **What it does:** Books a 76.8 kg Middleweight into a Flyweight bout whose limit is 83.9 kg, then misses weight by 27.2 kg.
- **Why it cannot fail meaningfully:** The weight class whose name and limit disagree is the test's own fixture. The test asserts the miss is detected, and it is — but the fixture is physically impossible (a Middleweight at a Flyweight limit 7 kg above the Middleweight ceiling). The test proves the scale works on a scenario that cannot occur.
- **Confirmed pre-existing:** S41 handover verified it fails identically with `FightClipRetarget.gd` reverted to `6aba786e` — zero references to Retarget, SILHOUETTE or ClipBinding.

### 2c. Hip-only PAIRGAP as regression control (U124 #3)

- **Files:** `Godot/tools/pair_gap_report.gd:2-3,103-104`, `Tools/s41_pairgap_diff.py`
- **What it measures:** Hip-to-hip distance only.
- **Global implication:** S41 handover states "PAIRGAP unchanged" as a pass criterion. Nine byte-identical PAIRGAP rows prove nothing when retarget moves bones below `Hips`. Shoulder rotation +26° with unchanged hip gap → `s41_pairgap_diff` reports `SAME` while hand-to-torso distances move.
- **Documented**, not hidden — but still treated as a gate by downstream stages.

---

## 3. Duplicated constants that have drifted

### 3a. Round duration fallback: 300 s vs 180 s (67% divergence)

| File | Line | Default |
|---|---|---|
| `scripts/FightClock.gd` | 3 | `DEFAULT_ROUND_SECONDS := 300.0` |
| `scripts/FightHudRead.gd` | 13 | `state.get("round_seconds", 300.0)` |
| `scripts/FightSimulation.gd` | 548 | `ruleset.get("round_seconds", 180)` |
| `scripts/FightSimulation.gd` | 3351 | `fight_state.get("round_seconds", 180)` |
| `scripts/FightNightScreen.gd` | 935 | `fight.get("round_seconds", 180.0)` |
| `scripts/FightWorldLiveScreen.gd` | 734 | `ruleset.get("round_seconds", 180.0)` |
| `scripts/GameState.gd` | 10237 | `source.get("round_seconds", 180)` |
| `scripts/FightRealtime.gd` | 891 | `Clock.DEFAULT_ROUND_SECONDS` (→ 300) |

The JSON data (`combat_rulesets.json`) has boxing at 300 and MMA at 180, so the "right" answer depends on the ruleset. But when the ruleset lookup fails or is bypassed, the realtime engine plays **5-minute rounds** while the simulation scores them as **3-minute rounds**. Exchange counts, stamina drain, pacing anchors, and the final decision all assume different durations. The HUD shows 5:00 while the simulation clocks 3:00.

**What would prove me wrong:** if every code path always has a valid ruleset loaded before reaching the fallback. I did not find such a guarantee — the fallback exists precisely because the lookup can fail.

### 3b. Weight class roster: 4 vs 8 vs 9 vs 10

| File | Line | Count | Classes |
|---|---|---|---|
| `scripts/GameState.gd` | 188 | **4** | Featherweight, Lightweight, Welterweight, Middleweight |
| `scripts/WorldPopulation.gd` | 148 | **8** | Flyweight → Heavyweight |
| `scripts/RankingsHubPanel.gd` | 68 | **8** | Flyweight → Heavyweight |
| `scripts/FightContract.gd` | 473 | **9** | Adds "cruiserweight" (225 lbs) |
| `scripts/TaleOfTape.gd` | 48 | **10** | Adds "super bantamweight" (55.3 kg) |

`GameState.gd:3551` generates random opponents using `WEIGHT_CLASSES[rng.randi() % WEIGHT_CLASSES.size()]` — only 4 classes. The rankings board has tabs for 8 classes; 4 of them are permanently empty for career-generated fighters. `TaleOfTape` recognizes "super bantamweight" which no other module knows.

### 3c. Heavyweight limit: 245 lbs vs 120.2 kg (9.1 kg / 20 lb gap)

| Source | Value | In kg |
|---|---|---|
| `FightContract.gd:481` | 245 lbs | 111.1 kg |
| `weight_classes.json` (MMA) | — | 120.2 kg |
| `TaleOfTape.gd` | — | 120.2 kg |

`FightContract.WEIGHT_CLASS_LBS["heavyweight"] = 245` converts to 111.1 kg. The authoritative JSON and TaleOfTape both define it as 120.2 kg (= 265 lbs, the UFC limit). Any code path that converts FightContract lbs to kg and compares against `WeightCut.limit_for()` (which reads the JSON) gets a phantom ~9 kg tolerance error on heavyweight catchweights.

### 3d. Non-drift (confirmed consistent)

- `STRIKE_RANGE = 1.1 m`: `FightRealtime.gd:364`, `probe_preferred_range.gd:63`, `fight_metres_test.gd:19` — all match.
- `AVG_SECONDS_PER_EXCHANGE = 14.0`: `FightSimulation.gd:134`, `BroadcastRead.gd:24` — match.
- Canvas width = 1920: consistent everywhere.

---

## 4. Dead or stale tests

### 4a. The six expected failures — still honest?

The baseline from S23/S41 handover:

| Test | Status | Notes |
|---|---|---|
| `athlete_development_test.gd` | baseline red | standing |
| `fight_pair_live_test.gd` | PARKED | operator ruling 2026-09-15 |
| `fight_scoring_test.gd` | baseline red | standing |
| `fight_stage_presenter_contract_test.gd` | PARKED | same ruling |
| `fight_stage_realism_test.gd` | baseline red | standing |
| `fight_metres_test.gd` | timeout under `--jobs 6` | **passes alone** (~9 min); contention flake, not a defect |

S41 also found `weight_cut_test.gd` as a **new pre-existing red** (fixture defect, see §2b). The list is **mostly honest** but `fight_metres_test` should not be counted as a real failure — it is a resource-contention timeout, not an assertion failure. The honest count is **4 standing reds + 1 fixture defect + 1 flake**.

### 4b. Tests that reference non-existent scripts

No orphaned load paths found among the 52 class_name-bearing scripts. All `preload()` and `load()` paths in test files resolve to files that exist on disk.

### 4c. Inert tests that skip green every run

| Test | Skip reason |
|---|---|
| `fighter_capsules_contract_test.gd` | `FighterCapsules.gd` does not exist in `scripts/`. Exits 0 with SKIP. |
| `ui_kit_book_test.gd` | `renders.json` does not exist (produced by `tools/render_kit.gd` in windowed mode). Exits 0 with SKIP. |
| `fight_paired_anchor_test.gd` | Guards against `FightPairedAnchor.gd` absence; prints SKIP. Forward contract. |

All three are honest — they announce their own inertness — but they are furniture. The suite counts them as passing.

### 4d. The documented baseline is stale

Multiple HANDOFF entries still reference "master's five" including `fight_stage_presenter_contract_test` as a baseline failure. That test **has gone green**. `weight_cut_test` and `fight_metres_test` have taken its place in `last_suite.json`. The documented baseline should be updated to match the actual suite state.

---

## 5. `GameState.gd` — responsibility clusters

14 832 lines, 532 functions. Three largest clusters by line span:

### 5a. UI Read / Board assembly (~3 000 lines, 100+ functions)

**Lines ~11 800 – 14 832.** `get_gym_hub()`, `get_training_hub()`, `get_fighter_card()`, `get_booking_board()`, `get_schedule_month()`, `get_cards_board()`, `get_scouting_board()`, `get_office_desk()`, `get_creation_markets()`, `get_ring_read_contract()`, etc.

Every function here builds a Dictionary for a specific UI panel. They are pure assembly — reading state from the career dict and formatting it. No mutation, no simulation logic, no persistence.

**Could leave first.** These functions have no interdependencies with each other and depend on GameState only for data access. Each one could become a static function in its own `*Read.gd` or `*Board.gd` script (the pattern already established by `BoutRead.gd`, `BroadcastRead.gd`, `ChampionshipRead.gd`, etc.). Estimated extractable: **~2 500 lines**.

### 5b. Booking / fight management / championship (~2 500 lines, ~120 functions)

**Lines ~5 500 – 8 000.** `get_fight_offers()`, `book_fight()`, `accept_promotion_bout()`, `get_championships()`, `get_division_rankings()`, `record_live_fight_result()`, `_apply_fight_result()`, contract negotiation, contender series, amateur bouts, title shots, double-champion windows.

The core business logic of the game. Deeply coupled to the career dict structure and to itself. Cannot be extracted without first extracting the data model.

### 5c. Athlete lifecycle (~2 500 lines, ~100 functions)

**Lines ~6 400 – 8 400.** Ambition, loyalty, retention/poaching, rivalries, aging, retirement, media/press, requests, career goals, epilogue.

Each subsystem is relatively self-contained (rivalries don't talk to media, aging doesn't talk to ambition) but they all read/write the same athlete dict. Could be extracted as independent modules if the athlete dict were formalized as a typed resource.

### What could leave first

The **UI Read cluster (§5a)**. It is already partially extracted (the `*Read.gd` pattern exists), the functions are pure, and they have no mutation side effects. Moving the remaining ~100 board/read functions into dedicated scripts would cut GameState by ~2 500 lines and remove the largest single-file responsibility without touching simulation logic.

---

## What I would change first, ranked

1. **Unify weight classes on `weight_classes.json`.** Delete `GameState.WEIGHT_CLASSES`, `WorldPopulation.WEIGHT_CLASSES`, `RankingsHubPanel.WEIGHT_CLASSES`, `FightContract.WEIGHT_CLASS_LBS`, `TaleOfTape.WEIGHT_KG`. Load once from the JSON. This fixes three findings (§3b, §3c, and the empty rankings tabs) in one change.

2. **Unify round-duration fallback.** One constant, one file. `FightClock.DEFAULT_ROUND_SECONDS` should be the single source, and every `.get("round_seconds", ...)` fallback should reference it or read from the same ruleset loader.

3. **Fix `fight_body_overlap_test.gd`.** Align `REFUSED_PAIRS` with `OVERLAP_ALLOWANCE_M` keys; delete the dead `arm>head` entry. The test currently proves nothing about 90% of the room's overlap surface.

4. **Extract UI Read functions from GameState.** The `*Board.gd` / `*Read.gd` pattern already exists; the remaining ~100 functions in the 11 800–14 832 range are the same shape. Each extraction is independent and testable.

5. **Wire or delete `FightClipAudit`, `FightPairedAnchor`, `FightHudRead`.** Each has tests but no production caller. Either connect them to the pipeline that needs them or remove them before they drift further from the code they were built for.

---

## What I looked at and found clean

- **`FightPoseSolver.gd`** — worst penetration is over every capsule A×B (`pen_max` at line 174-186), not from the declared `contacts` list. The test asserts `pairs == 4` and penetration-with-no-contacts. Mutant-hardened. Not a finding.
- **`fight_stage_realism_test.gd` R7** — overlap violation uses full `overlap["pairs"]` from `Capsules.frame_overlap`, not strike contact lists. Aligned with full scan.
- **`StrikeRange = 1.1 m`** — consistent across engine, probes, and tests.
- **`AVG_SECONDS_PER_EXCHANGE = 14.0`** — consistent across simulation and broadcast read.
- **Canvas width = 1920** — consistent everywhere.
- **`validate_technique_nodes.py`** — historical declared-only vocabulary, fixed. Vocab from `technique_vocabulary.json`, independent of the catalogue under merge.

---

## Files read

`GameState.gd` (windowed: lines 228-230, 248-860, 1404-1930, 2042-2760, 2783-3160, 3164-3445, 3501-3900, 3900-4100, 11 396, 11 800-14 832), `FightContract.gd:473-492`, `FightClock.gd:1-5`, `FightHudRead.gd:1-15`, `FightSimulation.gd:548,3351,3436`, `FightRealtime.gd:891`, `FightNightScreen.gd:935`, `FightWorldLiveScreen.gd:730-734`, `WorldPopulation.gd:148,1711`, `RankingsHubPanel.gd:68`, `TaleOfTape.gd:48`, `weight_classes.json`, `U124_DECLARED_ONLY_GATES.md`, `S41_THE_GIRDLE_IS_IN_THE_GAME.md:125-175`, `S23_THE_WEAK_LINE.md:210-243`, `run_tests.py:1-240`, `project.godot:19-38`. Full class_name census across 52 declarations. Four background subagents for orphan search, tautological gates, drifted constants, and dead tests.

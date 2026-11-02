# Core Gameplay Review — FightCamp KM1

Reviewer #1 (Core Gameplay). Evidence reviewed 2026-09-29.

---

## 1. What the evidence says the game is

FightCamp is a combat-sports gym management simulator whose payoff is a real-time, ruleset-aware fight. The current vertical slice is **"playable with a boxer"**: the player can start a career, sign a boxer, train him through the gym/floor/week planner, book a bout, run fight week, weigh in, watch the fight, and advance to the next week (`S117_DIGEST.md`; `roadmap.json` active milestone S122).

The fight layer is split:

- **Real-time engine** (`FightRealtime.gd` + `FightBeatAdapter.gd`) runs boxing, MMA, kickboxing and muay thai. It is a seeded, deterministic 20 Hz simulation with intent (`FightIntent.gd`), fatigue (`FightStamina`), separation, limb damage, phase bias, and ten-point-must judging.
- **Atomic engine** (`FightSimulation.gd`) still runs judo, taekwondo and freestyle wrestling, by deliberate ruling R85, because those rulesets need ippon/points scoring and single-judge federation paths that the real-time engine does not yet surface.

The 3D room (`FightWorldLiveScreen`, `FightStagePlayer`) presents the fight, but clip coverage is incomplete: **boxing 16/36 moves have C223-gated clips**, kickboxing 0/20, and the active milestone is blocked on boxing 36/36 before an .exe can ship (`DECISION_LEDGER` D3; `roadmap.json` now.next_action).

The career loop has been walked end-to-end (`s117_boxer_walk.plan`, 83 steps, 0 failures), and key realism switches (boxing output, footwork-not-a-blow, usage prior, preferred-range unit correction) are now ON by default.

---

## 2. Missing material

- **No exported .exe** by design (D3), so this review cannot verify the operator's "watch loop" experience; it relies on code, tests, digests and stills.
- **No audio playback**: Godot runs Dummy audio; audio findings are not verified.
- **No fresh nightly suite log** (`AgentComms/nightly/latest.txt` absent in this worktree), so the known 23 reds from 2026-09-28 cannot be confirmed locally beyond the five tests run below.
- **No `HANDOFF.md` slice read** per brief rules; only digests and code were used.
- **No other reviewer files read**, per independence rule.

---

## 3. Strengths to protect

1. **Deterministic seeded real-time core.** R82/R83 established byte-for-byte replay. The `FightRealtime`/`FightBeatAdapter` seam is well-documented and the engine exposes `begin`/`advance_beat`/`is_fight_over`/`result`/`state_view` with no hidden RNG outside the two streams.
2. **Boxing output switch is finally ON and measured.** `boxing_output_test.gd` shows thrown/round 40.3, connect 25.5%, jab share 35.3%, feints ~5.4/min — all inside or close to sourced bands (CompuBox 45-56 thrown/round, G99 connect 27-35%, G86 feints 6-14/min).
3. **Footwork is no longer a blow.** S122 fixed `boxing_step_in_out`, `circle_lead`, etc. so they are logged as movement, never land, never spend evasion; `footwork_not_a_blow_test.gd` 12/12 passes.
4. **Career walk is complete.** S117 reports a full player flow from new career to result screen to next week to save with no dead end.
5. **Good script hygiene.** `python Godot/tools/check_scripts.py` on the ten requested fight scripts passes 10/0.

---

## 4. Findings

### F1 — `fight_realtime_test.gd` is unloadable due to an undeclared `FightMoves` identifier

- **What:** Running the core real-time gate exits with a parse error: `Identifier "FightMoves" not declared in the current scope` at `tests/fight_realtime_test.gd:478` and `:521`.
- **Where:** `Godot/tests/fight_realtime_test.gd:478,521`.
- **Evidence / repro:**
  - `"$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tests/fight_realtime_test.gd` → exit code 1, parse error.
  - `python Godot/tools/run_tests.py --only fight_realtime` → `SUITE total=1 fails=1`.
- **Why it matters:** This is the gate that proves seeded real-time fights replay byte-for-byte and that guards actually occur. It has been unloadable since at least this review; the core engine cannot be regression-tested headlessly.
- **Severity:** Critical.
- **Confidence:** High.
- **Specific fix:** Add a `var FightMoves: GDScript` member and `FightMoves = load("res://scripts/FightMoves.gd")` next to the existing `RT`/`TRAUMA`/`ADVICE` loads at lines 91-93.
- **Effort:** Small.
- **CONFIRMED.**

---

### F2 — `smoke_test.gd` cannot complete because the `.godot/imported` cache is missing

- **What:** The "real gate" fails to load fonts (`InterVariable.ttf`, `BebasNeue-Regular.ttf`, `IBMPlexMono-Regular.ttf`), theme, compressed textures, and menu audio, causing UI scripts (`UIKit.gd`, `ShellChrome.gd`, `MatchSimulatorPanel.gd`, etc.) to fail to parse and the test to hang/timeout.
- **Where:** `Godot/tests/smoke_test.gd`; observed errors reference `res://.godot/imported/InterVariable.ttf-...fontdata`, `title_gym_bg.jpg.ctex`, `unbreakable_noise_menu.mp3`.
- **Evidence / repro:**
  - Smoke test ran for >5 min and was still running; foreground preview shows repeated missing-import errors and script parse failures.
  - `check_scripts.py` passes, so the failure is not a source parse error; it is the Godot import cache.
- **Why it matters:** Without the cache, the end-to-end career smoke gate cannot be run locally. The operator's "watch loop" and the .exe milestone depend on this gate being trustworthy.
- **Severity:** High.
- **Confidence:** High.
- **Specific fix:** Regenerate the `.godot/` import cache by opening the project once in the Godot editor (or running the editor import pass headlessly) on this worktree. Verify `smoke_test.gd` then runs to completion.
- **Effort:** Small.
- **CONFIRMED.**

---

### F3 — Two fight engines are live, and the real-time path is missing combo reactions and technique analytics

- **What:** `FightNightScreen.gd` routes boxing/MMA/kickboxing/muay thai through `FightBeatAdapter` and judo/taekwondo/freestyle wrestling through `FightSimulation`. However, `RingStagePanel.gd:1228-1232` still calls `FightSimulation.react_to_combo(...)` unconditionally. The screen-level comment at `FightNightScreen.gd:1418` states: "Technique analytics are FightSimulation-only. Real-time has no ...".
- **Where:** `Godot/scripts/FightNightScreen.gd:412-414`, `:486-488`, `:533`, `:617-619`, `:1047-1083`, `:1418`; `Godot/scripts/RingStagePanel.gd:1228-1232`.
- **Evidence / repro:** Grep `FightSimulation` in `FightNightScreen.gd` and `RingStagePanel.gd`; the combo-reaction branch does not branch on `_uses_realtime`.
- **Why it matters:** A player watching a real-time boxing bout cannot react to a combo the same way they can in an atomic-ruleset bout, and the post-fight analytics are unavailable. This makes the four real-time rulesets feel thinner than the three atomic ones.
- **Severity:** High.
- **Confidence:** High.
- **Specific fix:** Either (a) expose `react_to_combo` on `FightBeatAdapter` and route `RingStagePanel` through it when `_uses_realtime`, or (b) deliberately remove combo interrupts on the real-time path and document the cut; add real-time technique analytics to `FightBeatAdapter`/`RealtimeRoundStats` and wire `FightNightScreen` to use them.
- **Effort:** Medium.
- **CONFIRMED.**

---

### F4 — Boxing clip coverage is 16/36; the "playable with a boxer" milestone is blocked on animation, not code

- **What:** The active milestone requires all 36 boxing moves to pass the C223 gate before an .exe can ship. Current certified count is 16/36 boxing and 0/20 kickboxing (`S122_DIGEST.md`; `roadmap.json` now.incomplete_blocked).
- **Where:** `research/C223_DIGEST.md`; `research/SHOT_LIST_STRIKING.md`; `AgentComms/roadmap.json` now.
- **Evidence / repro:** S122 digest lists 20 remaining boxing moves: 4 defensive pieces + 7 counters (Q215 in flight) + 7 footwork + feint + drawing + remaining combos. C223 run history shows repeated failures on join discontinuity, speed band, timing band and skin floor for hooks/uppercuts before S120/S121's additive layers.
- **Why it matters:** The player cannot watch a boxing bout that reads as boxing until every catalogue move has its own clip. Borrowed/degraded clips will break the operator's watch-loop verdict.
- **Severity:** Critical.
- **Confidence:** High.
- **Specific fix:** Continue the C223 pipeline per roadmap next_action: collect Q215 counters, fix the latent hip-drop foot-drag on heavy_c, then footwork as one gated clip per move, then feint/drawing/combos. No code shortcut can substitute for passing clips.
- **Effort:** Large.
- **CONFIRMED.**

---

### F5 — Booked bouts produce zero split/majority decisions

- **What:** Q212 measured 54 booked boxing bouts and found **0 split decisions**, 5.8% draws, 46.7% KO+TKO. The judge panel test passes seeded fixtures (kickboxing seed 300 majority_draw, boxing seed 9 majority_draw), but those are deliberately searched seeds, not the population the player actually books.
- **Where:** `research/S119_DIGEST.md` "Q212 merged"; `Godot/tests/judge_panel_test.gd` (passes 0 failures).
- **Evidence / repro:**
  - `judge_panel_test.gd` passes, including T11 non-unanimous verdicts on searched seeds.
  - S119 digest: "booked boxing KO+TKO 46.7%, draws 5.8%, **0 split decisions in 54** — judges never disagree (open)."
- **Why it matters:** In a management game, contested decisions are a major source of drama and replay narrative. If every booked bout is unanimous, the judge panel feels decorative in the main loop.
- **Severity:** Medium.
- **Confidence:** High.
- **Specific fix:** Increase `judge_sigma` or introduce per-judge style bias in the booked population (not just the test fixture) until split/majority decisions occur at a realistic rate (BoxRec/CompuBox data would anchor the target). Re-measure with `tools/u195_engine_census.gd` on the booked population.
- **Effort:** Small.
- **CONFIRMED.**

---

### F6 — Feint rate is still below the sourced band

- **What:** With `boxing_output` ON, `boxing_output_test.gd` reports feints/min = 5.4, against G86's sourced band of 6-14/min.
- **Where:** `Godot/tests/boxing_output_test.gd` output; `research/S70_DIGEST.md`.
- **Evidence / repro:** Run `boxing_output_test.gd`; output includes `feints/min ON 5.4 (G86 6-14)` and the assertion "feint rate in G86 band 4-14/min" only passes because the band's lower bound is 4.
- **Why it matters:** Feints are a core boxing verb for creating openings. Sitting below the real band means the fight reads as too honest and reduces the value of the feint switch.
- **Severity:** Medium.
- **Confidence:** High.
- **Specific fix:** Raise the feint selection weight or reduce the feint decay rate so the population reaches at least the lower half of G86's 6-14/min. Re-run `boxing_output_test.gd` and the S122 jab-share probe.
- **Effort:** Small.
- **CONFIRMED.**

---

### F7 — Real-time corner instructions are shallow: no listen roll, "work the body" absent, and range only applies if the fighter already has one

- **What:** `FightBeatAdapter.apply_corner_instruction` writes a plan modifier to future ticks only, with listen chance hard-coded to 1.0. The comment in `FightBeatAdapter.gd:486-540` notes that range is skipped if the fighter has no `preferred_range`; S122 status and the task brief note "work the body" is absent.
- **Where:** `Godot/scripts/FightBeatAdapter.gd:486-540`; `CURRENT_STATUS.md` U37 note.
- **Evidence / repro:** Read `apply_corner_instruction`; `listen_chance` is always 1.0, emphasis mapping only sets pace/emphasis/range, no body-target modifier.
- **Why it matters:** Corner instructions are a Motorsport Manager-style verb the design promises. A guaranteed listen and missing body target make the corner feel like a cosmetic speed dial rather than a tactical choice.
- **Severity:** Medium.
- **Confidence:** High.
- **Specific fix:** Add a body-target emphasis that influences `target_region` weights in `FightMoves`/`FightRealtime`; add a listen roll scaled by coach cornering quality and fighter composure; gate the change behind the existing switch so OFF stays byte-identical.
- **Effort:** Medium.
- **CONFIRMED.**

---

### F8 — The 3D room drops/relabels most of what the engine computes

- **What:** S9 measured 335,443 action beats: only 29.2% exact, 19.8% substitute, 45.9% degrade, 5.0% generic. S15 relabeled 30,599 movement degrades as "footwork" rather than showing locomotion clips. S10 found 60.1% of beats visibly walking, 39.8% stance motion. The wide frame carries the fight.
- **Where:** `research/S9_PRESENTATION_SPLIT.md`, `S10_MOVEMENT_DEGRADES.md`, `S15_ROUTE.md`; `Godot/scripts/FightStagePlayer.gd`; `Godot/scripts/FightBeatAdapter.gd`.
- **Evidence / repro:** S9/S10/S15 digests; `tools/measure_presentation_split.gd`.
- **Why it matters:** The simulation is sophisticated, but the player mostly sees a wide shot of two men breathing or walking. The payoff moment — a landed combination — is buried in degradation and drop rules.
- **Severity:** Medium.
- **Confidence:** High.
- **Specific fix:** Promote more of the engine's named techniques to exact clips (see F4); once clip coverage rises, tighten the beat drop rule so a landed significant strike is never degraded; add a "finish" camera cut for knockdowns/submissions.
- **Effort:** Medium-Large.
- **CONFIRMED.**

---

### F9 — Grappling rulesets are still on the atomic engine; taekwondo produces plausible-looking but wrong scorecards

- **What:** R85 deliberately left judo, taekwondo and freestyle wrestling on `FightSimulation`. However, the design doc says the target is round-by-round simulation for all rulesets. Taekwondo specifically produces cards like `16-9/13-6/7-11` where "every point [is] a body PUNCH at 1, because head kicks (3) and body kicks (2) are structurally unproducible" (`CURRENT_STATUS.md` R85 note).
- **Where:** `Godot/scripts/FightNightScreen.gd:282-283`; `Godot/scripts/FightSimulation.gd`; `CURRENT_STATUS.md` R85 paragraph.
- **Evidence / repro:** Grep `REALTIME_RULESET_IDS` in `FightNightScreen.gd`; read R85 note in `CURRENT_STATUS.md`.
- **Why it matters:** For v1 the game promises stand-up striking (boxing, kickboxing, muay thai), but if grappling rulesets stay on a different engine forever, the product identity fractures. Taekwondo's wrong-but-plausible cards are worse than empty ones.
- **Severity:** Medium.
- **Confidence:** High.
- **Specific fix:** Either move taekwondo off the real-time path once kicking targets are authored (per S2/S4g leg-share work), or disable taekwondo as a playable ruleset in the demo until its scoring is honest.
- **Effort:** Large.
- **CONFIRMED.**

---

### F10 — Kickboxing has zero certified clips

- **What:** C223 run history shows kickboxing remained 0/20 through run 10 (`C223_DIGEST.md`). The SHOT_LIST_STRIKING kickboxing batch lists 20 moves (roundhouse, teep, switch kick, spinning back, etc.) none of which have passed the gate.
- **Where:** `research/C223_DIGEST.md`; `research/SHOT_LIST_STRIKING.md` batch 5.
- **Evidence / repro:** C223 digest: "Kickboxing EXACT-that-PASSED: 0/20 -> 0/20" repeated across runs.
- **Why it matters:** Kickboxing is part of the stand-up v1 promise. A kickboxing bout today would degrade to boxing punches and generic movement.
- **Severity:** High.
- **Confidence:** High.
- **Specific fix:** After boxing 36/36, run the C223 pipeline against the kickboxing SHOT_LIST with the same generated legal pairs and RamsterZ/Mixamo sources. Audit RamsterZ H2H kicks for usable roundhouse/teep sources first.
- **Effort:** Large.
- **CONFIRMED.**

---

### F11 — Connect percentage and thrown volume are at the edge of sourced bands

- **What:** `boxing_output_test.gd` reports thrown/round 40.3 (want CompuBox 45-56), connect 25.5% (want G99 27-35%). These pass because the test bands are generous, but they sit low.
- **Where:** `Godot/tests/boxing_output_test.gd` output.
- **Evidence / repro:** Run `boxing_output_test.gd`; figures printed under "FIGURES ON".
- **Why it matters:** A boxer who lands 25% and throws 40/round will feel less active and less accurate than real TV boxing. The player will notice the quiet.
- **Severity:** Medium.
- **Confidence:** High.
- **Specific fix:** Tune the throw gate base or output multiplier so the population centers on ~48 thrown/round and ~30% connect. Re-pin the judge scorecards and re-run the full suite.
- **Effort:** Small-Medium.
- **CONFIRMED.**

---

### F12 — The "movement beats are not frozen" finding is a relabel, not a presentation win

- **What:** S15 explicitly states its own result: "A RELABEL, NOT A PRESENTATION WIN ... NO PIXEL MOVED." Footwork beats were previously counted as degrades; now they are counted as stance/footwork. The actual on-screen motion is still the idle/stance loop.
- **Where:** `research/S15_ROUTE.md`; `Godot/scripts/FightStagePlayer.gd`.
- **Evidence / repro:** S15 digest arithmetic: DEGRADE 77,677 -> 47,078, FOOTWORK 0 -> 30,599, all other columns unmoved.
- **Why it matters:** Calling footwork "not degraded" improves metrics but does not give the player a visible step-in, pivot, or angle change. The SHOT_LIST footwork batch remains uncertified (F4).
- **Severity:** Medium.
- **Confidence:** High.
- **Specific fix:** Certify and bind the seven footwork clips (step_in_out, circle_lead, circle_rear, angle_step, pivot_footwork, switch_stance, rhythm_change) and route them through `FightStagePlayer` as locomotion layers rather than stance.
- **Effort:** Large.
- **CONFIRMED.**

---

## 5. Summary table

| Finding | Area | Severity | Confidence | Effort | Status |
|---|---|---|---|---|---|
| F1 `fight_realtime_test` parse error | Test / core | Critical | High | Small | CONFIRMED |
| F2 `smoke_test` import cache | Test infra | High | High | Small | CONFIRMED |
| F3 Two engines, missing real-time combo/analytics | Architecture | High | High | Medium | CONFIRMED |
| F4 Boxing 16/36 clips | Content | Critical | High | Large | CONFIRMED |
| F5 No split decisions in booked bouts | Balance | Medium | High | Small | CONFIRMED |
| F6 Feint rate low | Balance | Medium | High | Small | CONFIRMED |
| F7 Corner instructions shallow | Controls | Medium | High | Medium | CONFIRMED |
| F8 Most beats degraded/relabeled | Presentation | Medium | High | Medium-Large | CONFIRMED |
| F9 Grappling rulesets on atomic engine | Rulesets | Medium | High | Large | CONFIRMED |
| F10 Kickboxing 0/20 clips | Content | High | High | Large | CONFIRMED |
| F11 Connect/thrown volume low | Balance | Medium | High | Small-Medium | CONFIRMED |
| F12 Footwork relabel not real motion | Presentation | Medium | High | Large | CONFIRMED |

---

## 6. Bottom line

The **simulation is ahead of the spectacle**. The real-time fight engine has credible numbers, deterministic replay, fatigue, separation and judging — but the player cannot yet see most of it, and the gating test for that engine is currently unloadable. The milestone is correctly scoped around boxing clip completion; until 36/36 boxing moves pass C223, the core gameplay loop cannot be validated through the operator's own watch loop. The two-engine split and the missing real-time combo/analytics surface are the largest architectural risks to the intended "one coherent fight" identity.

# KM1 — Final Consolidated Game Review

**Date:** 2026-09-29  
**Worktree:** `D:\FightCamp\wt\KM1`  
**Branch:** `kimi/km1-game-review`  
**Reviewers:** 9 specialized reviewers + lead director consolidation.

---

## CLAUDE VERIFICATION (S123, 2026-09-29) - read before acting on any row below
Checked against primary sources. The review is useful and mostly evidenced (real file:line anchors, real test output), but:
- WRONG: "Tripo free-plan fighters cannot ship" (blocker 3, row 2). The twelve were made with tripo_3d THROUGH Higgsfield (paid Plus) and rigged on Ludo - both commercial-OK (asset_manifest.json tripo_fighters, corrected S92). Kimi read a stale row in S75_PHASE0.html; that row is fixed.
- WRONG ARM: row 18 "boxing output 40.3 thrown / 25.5% connect" is the switch-OFF arm of boxing_output_test. The game config (boxing_output + footwork_no_contact ON) reads 47.3 thrown per fought round, 31.5% connect, KO+TKO 45% (S122_DIGEST) - inside CompuBox / BoxRec bands.
- STALE: "the 3D room drops 92.6% of impacts" is CURRENT_STATUS:482, measured before strikes_play_whole went ON (S115, C190).
- NOT A GAME BLOCKER: blocker 5 (smoke_test needs a .godot import cache) is a fresh-worktree artefact; smoke_test passes on master (S123 run).
- FIXED TODAY: blocker 6 / row 4 body overlap - U196 merged (64921f6c), leg=leg 7.02 cm -> 1.3 mm residual head>arm.
- OVERSTATED: row 22 per-frame load() is a resource-cache lookup (deliberate, avoids a preload cycle), not a frame-rate killer; the O(n^2) capsule passes are the real cost.
- CONFIRMED, NEW: keyboard focus disabled (UIKit FOCUS_NONE), green button contrast, placeholder text, result-screen order, post-fight fatigue flat +30, amateur novice pool empty, bald fighters in the ring. Go to queue.backlog unless they are defects on the boxer path (then fix now).
Menu music (blocker 2) is real and already recorded: private builds only, replace before any public build.

### S124 corrections (Claude, 2026-09-29, primary sources read)
- STALE, and S123 wrongly confirmed it: "amateur novice pool empty" (QA #4, row 21) is S75's census. S76 (27b507fb, S76_DIGEST
  "Novices in the world") added G98 bout bands: 21 of 21 debut opponents now have <= 2 bouts; `world_novices_test` guards it.
- HALF RIGHT: contrast (F16, row 10). UIKit's Continue was already INK on GO (M32 7). The weekly Continue in ShellChrome was
  still white on #3fae5a = 2.83:1 - FIXED S124 (INK text and chevron, ~6.5:1).
- FIXED S124: F6 was one of FOUR developer notes in SetpieceChrome's cue line ("WAY OUT RETURNS TO THE SHELL · 480 MS",
  "NEXT SET-PIECE", "CONTINUE IS GO GREEN · THE ONLY PRIMARY EXIT", "THE BELT IS THE ONLY GOLD ON THIS FRAME") - all now
  player copy. F5 trait note ("the label the player sees ...") replaced with player copy.
- NOT TAKEN: F4 "BACK HOME" -> "BACK TO THE DAY" - "BACK HOME" is the deliberate S79 rename (FLOW_PASS4) that three tests pin.
- CONFIRMED, OPEN: bald fighters (F7) - the MPFB pilot has body/eyes/eyebrows meshes and NO hair mesh; hair exists only where a
  skin texture paints it. Fix = MPFB CC0 hair proxies in the build script; on the boxer path, next free agent slot.

## 1. Executive verdict

FightCamp is a combat-sports gym management simulator with a **credible, data-anchored fight engine** and a **complete boxer career loop**, but its **watchable payoff is not yet ready**. The simulation can already calculate a sophisticated fight; the 3D room, audio, and broadcast presentation are still far behind that calculation.

**Strongest feature:** the deterministic, seeded real-time fight engine anchored to published fight statistics (J20, CompuBox, BoxRec) with ruleset-aware palettes, fatigue, damage, and judging.

**Biggest weakness:** animation coverage. Only **16 of 36 boxing moves** have passed the C223 gate, and **kickboxing is 0/20**. The operator has ruled no `.exe` and no preview video until all 36 boxing moves are smooth (DECISION_LEDGER D3), so the active milestone is blocked on content, not code.

**Readiness:** Not ready for production or public Early Access. Continue with targeted changes; do not expand scope to grappling/MMA watchability until stand-up boxing is watchable.

---

## 2. Intended player experience and whether it lands

**Intended experience (from `S75_PHASE0.html` and `GAME_DESIGN.md`):**

1. **"The fight is real"** — every bout simulated from sourced fight stats, watchable in 3D or sim-to-result, same engine, same result.
2. **"You run the gym"** — sign, train, book, run camp, call corner, split purse.
3. **"It tells you why"** — corner reads, result causation, and stats explain outcomes.

**Does it land today?**

- **Simulation:** Yes. The real-time engine passes occurrence-floor tests, seeded replay is deterministic, and pace/accuracy sit near published bands.
- **Career loop:** Mostly. The boxer walk is 83 steps with no dead end, but some screens still carry placeholder/debug text and confusing copy.
- **Watchable fight:** No. The 3D room drops ~92.6% of impacts, feints and defence are invisible, and more than half of boxing techniques have no certified clip.
- **"Why":** Partially. The result-screen plan-outcome lines exist but are buried below cards and opponent stats.

---

## 3. What already works (protect)

1. **Deterministic real-time engine** — seeded replay, isolated RNG streams, ruleset-aware palettes (`FightRealtime.gd`, `FightBeatAdapter.gd`).
2. **Calibrated fight numbers** — pace anchor (7.41 sig landed/min, 47.7% accuracy) sits inside J20 bands.
3. **End-to-end boxer career walk** — new career → sign → train → book → camp → weigh-in → fight night → result → next week → save.
4. **C223 animation gate** — a falsifiable standard with speed/timing/slip/skin/join/non-overlap rows and seam mutants.
5. **MPFB generated male pipeline** — consistent, legally clean bodies with four legal weight-class pairs.
6. **Atomic save rotation** — `.tmp` → `.bak` → `.json` protects against half-writes.
7. **Tooling culture** — 457 tests, contract tests, parse gate, career-walk harness, nightly suite.
8. **UI kit foundation** — `UIKit.gd` / `UITokens.gd` gives every screen shared palette, type, elevation, and tooltip primitives.
9. **Ruleset-aware scoring** — ten-point-must, ippon, points, senshu, split/majority/unanimous decisions.
10. **Forward+ renderer** — real lighting, glow, DoF, fog capability in the gym rooms.

---

## 4. Critical blockers

These must be resolved before any public build or EA release.

1. **Boxing animation gate incomplete (16/36).** The milestone and `.exe` are blocked until every boxing move passes C223 on all four generated legal bodies.
2. **Unlicensed menu music.** `unbreakable_noise_menu.mp3` is a YouTube rip that cannot ship.
3. **Tripo free-plan fighters cannot ship.** The twelve female Tripo bodies are "Public Models · Non-Commercial Use"; they must be regenerated on Tripo Pro or replaced with MPFB.
4. **Ludo clip terms unconfirmed / splash art provenance unknown.** Legal inventory flags these as unresolved.
5. **`smoke_test.gd` cannot run without a regenerated `.godot/` import cache.** The real gate is blocked on cache, not source code.
6. **3D body overlap / clipping gate still fails.** `fight_body_overlap_test.gd` reports `leg=leg` penetration; Q213 head contact is not pinned.
7. **Two fight engines with incomplete real-time parity.** `RingStagePanel.gd` still calls `FightSimulation.react_to_combo` unconditionally; real-time rulesets lack combo reactions and technique analytics.

---

## 5. Prioritised findings table

| Priority | Area | Finding | Evidence | Player impact | Severity | Confidence | Recommended fix | Effort |
|---|---|---|---|---|---|---|---|---|
| 1 | Visual/Animation | Boxing 16/36 certified; milestone blocked | `C223_DIGEST.md`, `S122_DIGEST.md`, `SHOT_LIST_STRIKING.md` | Fight does not read as boxing | Critical | High | Continue C223 pipeline: counters, footwork, feint, drawing, combos | Large |
| 2 | Legal/Audio | Unlicensed menu music + Tripo free-plan bodies | `S75_PHASE0.html` legal inventory | Cannot sell the game | Critical | High | Replace music; regenerate/replace Tripo bodies; confirm Ludo terms | Medium |
| 3 | Technical | `smoke_test.gd` blocked by missing `.godot/` import cache | Core reviewer test run | Cannot run end-to-end gate | High | High | Build import cache headlessly; document first-run step | Small |
| 4 | Technical | `fight_body_overlap_test.gd` red; Q213 clipping gate open | Technical reviewer run; `S121_DIGEST.md` | Visible interpenetration | High | High | Add `leg=leg`/`foot=foot` allowance or fix test; implement G147 fixes | Small–Large |
| 5 | Core Gameplay | Two engines; real-time path missing combo/analytics | `FightNightScreen.gd:1418`, `RingStagePanel.gd:1228-1232` | Real-time rulesets feel thinner | High | High | Expose `react_to_combo` on `FightBeatAdapter` or cut and document; add real-time analytics | Medium |
| 6 | Design/Balance | MMA target mix off J20 D3 (head 46.5% vs 61–65%, body 39.1% vs 19–23%) | `fight_realtime_test.gd` output | MMA reads as body-kickboxing hybrid | High | High | Rebalance technique/target-region weights; re-measure | Medium |
| 7 | Visual/Animation | Defence (block/slip) almost never shown | `CURRENT_STATUS.md` R103; S117 probe | Fight looks like mutual slugfest | High | High | Apply `promote_in_remainder_4` rule; add block/slip clips | Medium |
| 8 | Visual/Animation | Feints invisible in 3D room | `S119_DIGEST.md`; S117 probe | Tactical layer hidden | High | High | Add feint animation/stance clip or HUD cue | Medium |
| 9 | UI/UX | Keyboard navigation disabled almost everywhere | `UIKit.gd` grep `FOCUS_NONE` | Excludes mouse-impaired players | High | High | Restore focus; add shortcuts in `CareerRoot` | Medium |
| 10 | UI/Accessibility | Green Continue button fails WCAG contrast | `UIKit.gd:1591` (2.3:1) | Low-vision players cannot read primary action | High | High | Use `INK` text on green or darken green | Small |
| 11 | Player/Market | Living 3D gym hub not delivered | `D24_HUB_DISPLAY_EVAL.md` | Loses strongest visual hook | High | High | C-light slice: 3 fighters on stations, simple animations | Medium |
| 12 | Visual/Animation | No same-class female generated pair | `S117_DIGEST.md` | Demo implicitly male-only | High | High | Generate female MPFB legal pairs; re-run C223 | Large |
| 13 | Audio | SFX/crowd/voice identity missing; all strikes collapse to punch_head/punch_body | `FightAudio.gd:433-466` | Kickboxing/MMA sound like boxing | High | High | Add kick/knee/elbow/ground/voice cue families | Large |
| 14 | Visual/Animation | Kickboxing 0/20 certified | `C223_DIGEST.md` | Kickboxing bouts degrade to boxing | High | High | Source kick clips; run C223 gate after boxing | Large |
| 15 | UI/UX | Placeholder/debug text visible in Development tab and result screen | `DesignLibrary/screens/profile_revamp/development.png`; `77_result.png` | Looks unfinished | High | High | Replace/remove placeholder copy | Small |
| 16 | Player/Market | Result screen buries THE PLANS / plan-outcome proof | `D50_DIGEST.md` | Player cannot connect choices to outcome | High | High | Move THE PLANS to primary left column | Small |
| 17 | Design/Balance | Post-fight fatigue flat +30 regardless of bout length/damage | `GameState.gd:15195` | Management decisions feel arbitrary | Medium | High | Scale fatigue by duration and damage received | Small |
| 18 | Design/Balance | Boxing output low (40.3 thrown/round, 25.5% connect) vs CompuBox bands | `boxing_output_test.gd` | Boxer feels less active/accurate | Medium | High | Tune output multiplier/contact ladder; re-pin cards | Small–Medium |
| 19 | Design/Balance | Takedown volume low, accuracy high vs J20 D6 | `fight_realtime_test.gd` | Wrestlers underperform | Medium | High | Increase attempt rate or reduce success; add occurrence test | Medium |
| 20 | Core/Adversarial | Booked bouts produce 0 split decisions in 54 samples | `S119_DIGEST.md` Q212 | Judge panel feels decorative | Medium | High | Increase `judge_sigma`/style bias in booked population | Small |
| 21 | Adversarial QA | Amateur novice matchmaking has no valid opponents | `S75_DIGEST.md`; `tools/s75_amateur_pool_census.gd` | Unsafe/impossible amateur bouts | High | High | Seed novice population or relax filter with warning | Medium |
| 22 | Technical | `FightWorldLiveScreen` reloads scripts and runs O(n²) geometry every frame | `FightWorldLiveScreen.gd:3122-3171`, `:3319-3391` | Frame-rate risk on target hardware | High | High | Cache scripts; cache posed capsules; add early-outs | Medium |
| 23 | UI/UX | Weigh-in/fight-week copy contradicts itself | `D25_FRESH_EYES_FIGHT_WEEK.md` | Destroys trust in weight system | Medium | High | Apply Dola's three fixes; add consequence badge | Small |
| 24 | Technical | `GameState.gd` is 17,654 lines / 674 functions | `wc -l`; grep | Maintainability risk | High | High | Split into domain modules behind thin facade | Large |
| 25 | Visual/Animation | Generated fighters bald in ring while portraits show hair | `S117_DIGEST.md` | Identity break | Medium | High | Generate/port hair geometry consistently | Medium |

---

## 6. Top 10 development actions

Ranked by player impact, risk reduction, and effort (not cosmetics).

1. **Finish 36/36 boxing C223 gate.** This is the single milestone blocker. Focus on Q215 counters, footwork as one gated clip per move, feint, drawing, remaining combos.
2. **Unblock shippability.** Replace the YouTube menu music; regenerate/replace Tripo free-plan bodies; confirm or drop Ludo clips; add Godot/OFL/MIT credits notice; schedule a games-lawyer consult.
3. **Fix the 3D contact/overlap defects.** Resolve `fight_body_overlap_test.gd` and implement the Q213/G147 clipping fixes so bodies no longer intersect.
4. **Make defence and feints visible.** Apply the engine's `promote_in_remainder_4` rule and add feint/block/slip clips and audio cues.
5. **Restore keyboard navigation and shortcuts.** Remove blanket `FOCUS_NONE`, wire Tab/Enter/ESC/number keys in `CareerRoot`/`ShellChrome`.
6. **Fix the result-screen information order.** Move THE PLANS to the primary left column so players see why they won or lost.
7. **Build the C-light living gym hub.** Show 2–3 assigned fighters on stations with simple training animations; keep ≥30 fps.
8. **Tune MMA target mix and boxing output.** Re-anchor to J20 D3 and CompuBox bands; re-pin judge cards.
9. **Address the 23 known suite reds.** Start with `fight_body_overlap`, `fight_plan_ai_corner`, `fight_footwork_economy`, `fighter_reachability`.
10. **Split `GameState.gd` into domain modules.** Defer until after the milestone, but start planning the facade now.

---

## 7. Quick wins

These are small effort, high player or process value.

- Replace placeholder/debug text in Development tab and result screen.
- Fix green Continue button contrast (use `INK` text on green).
- Apply Dola's weigh-in copy fixes: "6 DAYS TO FIGHT NIGHT", remove "not on the scale yet", add consequence badge.
- Fix result-screen label: "BACK TO THE DAY ▸" instead of "BACK HOME ▸".
- Fix `ScheduleHubPanel` hint to say "OPEN THE DAY".
- Bump `GameState.BUILD_VERSION` or automate it.
- Cache `FightRealtime.gd` / `RingSpace.gd` loads in `FightWorldLiveScreen` instead of per-frame `load()`.
- Add HMAC/checksum to career saves to block trivial editing.
- Create `default_bus_layout.tres` for audio mixing.
- Remove rejected `gym_theme_ludo_pilot.mp3` from the repo.

---

## 8. Systems needing deeper redesign

These are not quick fixes; they need design time and evidence.

1. **Presentation/broadcast layer.** The 3D room drops 92.6% of impacts. A real broadcast needs camera shot selection (establishing, tight on finish, replay), a body-silhouette damage read, round/score graphics, and crowd/referee presence.
2. **Audio identity.** Current audio is a prototype: no kick/knee/elbow/ground cues, no breath/voice, minimal crowd, no SFX/crowd volume controls. Needs a full cue family and bus layout.
3. **Two-engine unification.** The real-time/atomic split is correct for v1 but creates parity risk. Taekwondo's wrong-but-plausible cards are worse than empty ones.
4. **Female/generated fighter pipeline.** No same-class female pair exists; portraits and 3D do not match. Needs a dedicated art pass.
5. **Hype/emotional stakes.** Rivalries, press conferences, and tournament systems exist but do not yet spend on money, crowd, or walkout.
6. **Career economy tuning.** Starting cash, purses, grade fees, and staff costs are authored without a verified break-even curve.

---

## 9. Missing tests and unanswered questions

1. **Full suite on current branch.** `AgentComms/nightly/latest.txt` is missing; the 2026-09-28 master run had 23 reds. Need a fresh run on `kimi/km1-game-review`.
2. **Clean-machine `.exe` test.** Blocked by D3 until 36/36 boxing.
3. **Audio playback verification.** Dummy audio prevents judging sync, ducking, and mix.
4. **Division/sex-specific fight fixtures.** All occurrence tests use ~83kg male pairings.
5. **52-week economic simulation.** Does the early game break even?
6. **Operator watch-loop verdict.** Has the operator seen a current boxing bout and named the three worst things?
7. **Kickboxing/Muay Thai finish-rate tests.** No pinned occurrence tests against Glory/BoxRec data.
8. **Accessibility test coverage.** No tests for focus order, contrast, color-only communication.
9. **Female career walk.** No end-to-end test for a female boxer.
10. **Crash-mid-save recovery.** Save rotation is not tested under process-kill conditions.

---

## 10. Recommended testing plan

### Internal verification (next 2 weeks)

1. **Animation gate:** Run `tools/c223_production_gate.gd` for every remaining boxing move on all four generated legal bodies; reject any edge-tuned certificate.
2. **Suite:** Run `python Godot/tools/run_tests.py --jobs 2` on current branch; triage all reds.
3. **Career walk:** Re-run `tools/s64_career_walk.gd` with `as_game` after each engine/UI change.
4. **Headless probes:** Run `boxing_output_test.gd`, `fight_pace_anchor_test.gd`, `judge_panel_test.gd`, `fight_realtime_test.gd` after every tuning change.
5. **3D contact:** Run `fight_body_overlap_test.gd` and `q213_clip_gate.gd` until head/arm/torso gaps pass.

### Operator validation (once 36/36 boxing passes)

1. Build `.exe` with `python Tools/build_playable.py`.
2. Operator plays one full boxer career loop and names the three worst things.
3. Fix those three things; re-build; repeat.
4. Only then record preview video and open Steam page.

### Player testing (pre-EA)

1. **First-hour cohort:** 5 management-sim players who follow combat sports. Success = can book and watch a bout without asking for help.
2. **Accessibility check:** keyboard-only playthrough of the boxer walk.
3. **Balance audit:** 20 simulated careers to verify cash flow and ranking/purse progression.
4. **Watch-loop panel:** 5 players watch 3 boxing bouts and rate whether it "reads as boxing." Target ≥4/5.

### Success metrics

- 36/36 boxing C223 pass rate.
- Suite ≤0 unexpected failures.
- Career walk 0 dead ends.
- Operator watch-loop verdict: no breaking "worst thing."
- First-hour players complete one bout unaided.

---

## 11. Release-readiness scorecard (1–10)

| Area | Score | Rationale |
|---|---|---|
| Core gameplay | 6 | Engine is solid; watchable payoff is not. |
| Controls and feel | 4 | Mouse-only; keyboard focus disabled; no shortcuts. |
| Balance | 6 | Pace/accuracy anchored; MMA target mix and boxing output off. |
| Progression | 6 | Career loop works; economy untuned; flat fatigue. |
| Technical stability | 5 | Save rotation good; 23 suite reds; body overlap fails. |
| Performance | 4 | Per-frame script loads and O(n²) geometry passes risk frame rate. |
| UI/UX | 5 | Kit foundation strong; placeholder text, contrast, and focus gaps. |
| Accessibility | 3 | No settings, poor contrast, keyboard navigation disabled. |
| Visual quality | 5 | Direction A chosen but not fully applied; 3D fight behind. |
| Audio | 3 | Prototype; unlicensed menu music; missing cue families. |
| Content depth | 4 | Boxing 16/36; kickboxing 0/20; no female legal pair. |
| Replayability | 5 | Seeded engine supports it; presentation and variety limit it. |
| Originality | 7 | Calibrated engine + gym management is a real gap. |
| Market appeal | 6 | Market vacuum exists but closing; depends on demo timing. |

**Average:** ~4.9/10.

---

## 12. Final recommendation

**Continue with targeted changes.** Do not return to prototype, but do not rush to EA. The project has a strong identity and a working simulation; the work now is to make the spectacle match the simulation.

**Why not "Rework major systems"?** The real-time engine, C223 gate, career loop, and UI kit are the right foundations. Rebuilding them would waste the calibrated simulation.

**Why not "Continue as designed"?** The current trajectory under-invests in presentation, accessibility, and legal shippability. Continuing exactly as-is risks a demo that underwhelms and a release that cannot ship.

---

## Next sprint action plan

**Goal:** Close the "Playable with a Boxer" milestone.

| Order | Task | Owner | Acceptance criteria |
|---|---|---|---|
| 1 | Regenerate `.godot/` import cache and verify `smoke_test.gd` | Technical | `smoke_test.gd` exits 0 on this branch |
| 2 | Replace unlicensed menu music | Audio / Claude | `unbreakable_noise_menu.mp3` removed; new track wired and manifest-approved |
| 3 | Collect Q215 counters and merge what passes C223 | Claude / Qwen | `c223_sequence_gate.gd` 4/4 on counters; stills reviewed |
| 4 | Fix latent hip-drop foot-drag; certify footwork moves | Claude | Each footwork move passes bound 4/4 with per-foot rule |
| 5 | Certify feint + drawing + remaining combos | Claude | 36/36 boxing reached |
| 6 | Fix `fight_body_overlap_test.gd` and Q213 clipping | Technical | Overlap test passes; head contact pinned |
| 7 | Apply defence promotion rule; add feint/block/slip clips | Presentation | Block+slip visible ≥10%; feints visible |
| 8 | Fix placeholder text and contrast; restore keyboard focus | UI/UX | No debug text on demo path; WCAG AA on Continue; Tab navigates |
| 9 | Move THE PLANS on result screen | UI/UX | Plan-outcome lines in primary left column |
| 10 | Run full suite; triage remaining reds | Technical | Suite green or all reds explained/owned |

**Stop rule:** If 36/36 boxing is not reached by the demo deadline, ship a boxing-only demo with kickboxing/MMA/grappling hidden. Do not lower the C223 gate.

# Reviewer #9 — Creative Director

## Evidence summary: what the game is and what it wants to be

FightCamp is a **combat-sports gym management simulator** for PC (Steam, Windows 10/11, keyboard+mouse). Its intended identity is built around three pillars from the product sheet (`research/S75_PHASE0.html:91-96`):

1. **"The fight is real"** — bouts are simulated from sourced fight statistics (J20's >7,000 UFC bouts, CompuBox, BoxRec) and the same engine drives both the 3D watch and the sim-to-result path.
2. **"You run the gym"** — the player is coach/manager: sign, train, book, run camp, call corner, split purse.
3. **"It tells you why"** — wins and losses are explained on screen through corner reads, result causation lines, and supporting stats.

The release target is **the whole game**, not a demo (`AgentComms/roadmap.json:1801-1805`, DECISION_LEDGER D2). v1 Early Access is priced at **$19.99** and scoped to **stand-up sports: boxing, kickboxing, Muay Thai**; MMA + grappling is the first major update (`S75_PHASE0.html:104`; DECISION_LEDGER D19-D20). The active development stage is **B: "The fight is WATCHABLE"**, with the milestone **"PLAYABLE WITH A BOXER"** (`roadmap.json:99-112`).

The current build, per the evidence pack, has:
- A **calibrated real-time fight engine** with seeded replay, ruleset-driven palettes, damage/stamina/judging, and grappling support ( boxing/MMA/kickboxing/muay thai on `FightBeatAdapter`; judo/wrestling/taekwondo on `FightSimulation` by R85 ruling).
- A **functional career loop** walked end-to-end with a boxer (`S117_DIGEST.md:6-10`; `roadmap.json:13`).
- A **3D fight room** using generated MPFB fighters (`DECISION_LEDGER D5`), with C223-gated boxing clips at **16/36** certified (`S122_DIGEST.md`; `roadmap.json:9`).
- Deep **management systems**: gym market share, membership, crowding, staff/retiree coaches, contracts, training floor, physio, rooms, decor, rivalries, press conferences, tournaments.
- Strong **tooling discipline**: 457 tests, nightly suite, career-walk harness, C223 production gate, contract tests, parse gates.

The central creative tension is that the **simulation is far ahead of its presentation**. The roadmap's own assessment says: *"The simulation can calculate a sophisticated fight better than it can show one"* (`roadmap.json:52`). Stage B is 58% complete; stage C ("It looks like television, not a debug view") is at 8%.

## Missing material

- I did **not** run the windowed career-walk harness (heavy, limited to two runs; `TASK_KM1_GAME_REVIEW.md:41-43`). Findings about the walk rely on digest reports and screenshots, not fresh observation.
- I did **not** run headless tests or probes. All code claims come from digest/test reports.
- **Audio** cannot be verified on this PC (Dummy driver); audio findings are from files and wiring only.
- I did **not** view all preview stills/folders individually; visual judgments rely on selected stills referenced in digests and Maria's art packs.
- I did **not** read other reviewer files, per the independence rule.

## Strengths to protect

1. **Sourced simulation credibility.** The engine is anchored to real fight data (J20, CompuBox, BoxRec, Schortgen distance, Piorkowski timing) and has deterministic replay. This is the game's primary differentiator against competitors (`G62_COMPETITOR_SURVEY.md:201-212`).
2. **Per-move animation authenticity.** The C223 gate (`SHOT_LIST_STRIKING.md`) and the refusal to relabel/warp clips past identity is the right long-term decision. It protects "the fight is real" at the pixel level.
3. **Management depth without feature bloat (so far).** Gym market, crowding, equipment tags, coach effects, retiree coaches, and the training floor all tie back to the core loop.
4. **Generated MPFB fighter pipeline.** CC0, one seed → body + face + portrait, consistent and legally clean (`DECISION_LEDGER D5`; `S75_PHASE0.html:134`).
5. **Test and tooling culture.** Contract tests, mutant checks, the C223 gate, and the career walk create a safety net that most indie sims lack.
6. **The "why" infrastructure.** Result-screen causation, corner reads, body map, and plan-outcome lines are already in place and should be extended, not rebuilt.

## Findings: coherence, contradictions, gaps

### 1. The game has two competing identities — management sim and 3D broadcast — and the second is far behind

- **What:** The product promises both a deep management sim and a watchable 3D fight, but presentation stage C is at 8% while simulation stage A is at 65% (`roadmap.json:24-50`).
- **Where:** `AgentComms/roadmap.json:24-50` (assessment bars), `S75_PHASE0.html:91-96` (pillars), `S8b_DIGEST.md` / `roadmap.json:521-523` (operator: "the head was no visible... motion was terrible").
- **Evidence/repro:** Roadmap assessment labels "Believable indie fight broadcast" at 25% and "AAA presentation bar" at 12%. The operator's own verdict on a recorded bout was that heads were not visible and motion was terrible.
- **Why it matters:** If the watchable fight underdelivers, the second and third pillars collapse. Players who sim-to-result lose the payoff; players who watch lose trust in the simulation they see.
- **Severity:** High
- **Confidence:** High
- **Specific fix:** Make the operator's **watch loop** (`S64_DIGEST.md`; `DECISION_LEDGER D24`) the gate for stage B completion, not just the 36/36 clip count. Do not advance to stage C work until a watched boxing bout is accepted as "reads as boxing."
- **Effort:** Medium (process + one iteration pass)
- **Type:** CONFIRMED

### 2. Visual identity is undecided — four directions coexist

- **What:** Maria's M34 pitch presents four art directions (A Brass & leather, B Fight poster, C Arena night, D Six A.M.) and explicitly says "The operator picks" (`research/CLAUDE_LAND_NOTE_M34.md:18-20`).
- **Where:** `CLAUDE_LAND_NOTE_M34.md:18-20`, `M32_MENU_ART_DIRECTION.md` (tokens), `M33_ICONS_AND_TYPE.md` (font/icon restyle).
- **Evidence/repro:** M34 still lists "Open questions" asking the operator to choose a direction. M32/M33 tokens are not yet integrated into a single direction.
- **Why it matters:** A coherent identity cannot ship with four competing looks. UI tokens, gym art, and fight-night presentation all depend on this decision.
- **Severity:** High
- **Confidence:** High
- **Specific fix:** Operator must pick one M34 direction. Until then, stop producing new UI art and require every new screen/mock to reference the chosen direction's token table.
- **Effort:** Small (decision) / Medium (implementation)
- **Type:** CONFIRMED

### 3. v1 scope says stand-up, but grappling/MMA work keeps pulling resources

- **What:** The product sheet and DECISION_LEDGER freeze MMA + grappling behind the first update (`S75_PHASE0.html:104`; `DECISION_LEDGER D19-D20`), yet the backlog still queues grappling holds (C222), ground seats (Q209), and the suit route for grappling (`roadmap.json:1708-1793` backlog).
- **Where:** `DECISION_LEDGER.md:74-93` (D19/D20), `AgentComms/roadmap.json:1708-1793` (backlog), `S1f` summary in `roadmap.json:221-226`.
- **Evidence/repro:** Backlog items C221/C222 are explicitly "WAITS BEHIND C223" but still active enough to consume Codex/Cursor cycles. Stage A still lists grappling acceptance criteria (`roadmap.json:68-76`).
- **Why it matters:** Every hour on grappling is an hour not spent making boxing watchable. It also risks shipping a v1 that feels like an incomplete MMA game rather than a complete stand-up sim.
- **Severity:** Medium
- **Confidence:** High
- **Specific fix:** Convert C221/C222/Q209/U194 to **post-EA backlog** until stage B is done and the watch-loop verdict is clean. Reassign those agents to boxing clips, footwork, or broadcast stage C tasks.
- **Effort:** Small
- **Type:** CONFIRMED

### 4. The "hype" layer is designed but not wired into the active milestone

- **What:** G89 and G102 establish that fights feel big through gym-vs-gym heat, tournament finals, ticket/gate numbers, weigh-in face-offs, and a 7-beat offer-to-bell sequence. The roadmap has a Fight Hype stage (S73) marked `status: "now"` (`roadmap.json:753-759`), but the current `now` block (S122) is entirely about boxing clips and footwork.
- **Where:** `G89_FIGHT_HYPE.md:151-254` (proposed build order), `G102_FIGHT_HYPE_SEQUENCES.md:77-90` (7 beats), `roadmap.json:753-759` (S73).
- **Evidence/repro:** S73 is listed as "now" but has no delivery record in S117-S122 digests. Fight-week in the current walk is button-advance weeks + weigh-in + TOTT, not the sourced 7-beat sequence.
- **Why it matters:** Without stakes and ceremony, the management loop becomes a spreadsheet. The operator explicitly asked for this (`roadmap.json:753`: "the hype to the fight feel as real as possible").
- **Severity:** Medium
- **Confidence:** High
- **Specific fix:** After C223 footwork lands, assign one cycle to G89's top 3: (1) gym-vs-gym heat object extending `Rivalries.gd`, (2) tournament-round hype carry, (3) displayed ticket/gate number from hype. Do not build the full 7-beat sequence until stage B is done.
- **Effort:** Medium
- **Type:** CONFIRMED

### 5. "It tells you why" is partially built but not yet felt before the fight

- **What:** The third pillar is served by post-fight reads, corner reads, and result causation (`S100_DIGEST.md`, `S101_DIGEST.md`), but the **road to the fight** (camp choices, weight cut, injury risk) is where players in comparable games feel the stakes (`G102_FIGHT_HYPE_SEQUENCES.md:63-75`).
- **Where:** `G102_FIGHT_HYPE_SEQUENCES.md:63-75` (what players praise: Punch Club's scarcity, Undisputed's weight trade-off), `S97_DIGEST.md` / `S101_DIGEST.md` (corner/result reads exist).
- **Evidence/repro:** G102 says players remember "miss weight → fight doesn't count / fame and purse cut" and "spar can injure." The current build has these systems but the evidence pack does not show them surfaced as narrative tension before the bout.
- **Why it matters:** The third pillar must work *before* the result, or the player has no emotional investment in the explanation.
- **Severity:** Medium
- **Confidence:** Medium
- **Specific fix:** In the fight-week/weight-cut/camp screens, add consequence previews: "cut too fast → medical hold risk," "skip rest → gas tank down." Reuse existing `BodyReadiness.forecast_region_weeks` (`S68_DIGEST.md`) for visible forecasts.
- **Effort:** Medium
- **Type:** ASSUMPTION (based on G102 player evidence, not direct build observation)

### 6. Audio identity is essentially absent

- **What:** Stage C lists sound (impacts, crowd, corner, commentary bed) as a done-when criterion, but the test PC runs Dummy audio and the only menu music is a YouTube rip that cannot ship (`S75_PHASE0.html:145`).
- **Where:** `AgentComms/roadmap.json:123-127` (stage C done_when), `S75_PHASE0.html:145` (menu music legal row), `DECISION_LEDGER.md:58` (tools: say.ps1 never used).
- **Evidence/repro:** Legal inventory marks `unbreakable_noise_menu.mp3` as "Cannot ship." No shipped SFX/crowd/corner audio is referenced in the evidence pack.
- **Why it matters:** Sound is half of "fight is real" and "broadcast." Silent impacts and crowd kill immersion.
- **Severity:** Medium
- **Confidence:** High
- **Specific fix:** Replace menu music immediately with a licensed/commissioned track. Start a placeholder SFX pass (impact thud, bell, corner voice cues, crowd bed) as soon as stage B is watchable.
- **Effort:** Medium
- **Type:** CONFIRMED

### 7. Several content-identity risks are unresolved

- **What:** The legal inventory still flags unresolved terms for Ludo clips, unknown provenance for splash/portrait/world-map art, and the need for a games-lawyer consult before public release.
- **Where:** `S75_PHASE0.html:118-150` (legal inventory), `DECISION_LEDGER.md:51-65` (tools verdicts).
- **Evidence/repro:** Ludo retarget clips are listed "Licence: Ludo terms - not recorded" / "State: Unknown." Splash fighter, gym background, world map, generated portraits are "tool and terms not recorded."
- **Why it matters:** A commercial release cannot ship with unlicensed assets. This is a hard blocker for stage E.
- **Severity:** High
- **Confidence:** High
- **Specific fix:** Before any public build: confirm Ludo terms or drop the clips; trace and replace unprovenanced art; schedule the games-lawyer consult.
- **Effort:** Medium
- **Type:** CONFIRMED

### 8. The animation method is correct but the schedule risk threatens identity

- **What:** The operator asked whether fixing animations "each move individually" is the right method. The answer was: per-move clips yes, per-move hand-tuning no; variants from certified bases; counters as sequences (`S121_DIGEST.md:3-6`).
- **Where:** `S121_DIGEST.md:3-6`, `SHOT_LIST_STRIKING.md`, `C223_DIGEST.md` (gate measurements).
- **Evidence/repro:** 16/36 boxing moves are certified. The remaining 20 include 4 defensive pieces, 7 counters, 7 footwork moves, feint, drawing, and combos. Kickboxing is 0/20.
- **Why it matters:** The per-move gate is the right identity, but if it cannot hit 36/36 before demo pressure mounts, the team may be tempted to relax the gate or skip kickboxing entirely — either of which breaks the product promise.
- **Severity:** Medium
- **Confidence:** High
- **Specific fix:** Keep the gate. Accept that kickboxing may not be in the first watchable build; ship boxing-only watchability first, then extend. Footwork should remain one gated clip per move, not a procedural stepping system (`S121_DIGEST.md:6`).
- **Effort:** Medium
- **Type:** CONFIRMED

### 9. Demo pressure could misrepresent the product

- **What:** The operator set a playable demo by 2026-10-04 and told Claude "this [will] be remember[ed] after 100 sessions" (`CLAUDE.md:36-39`). D2 and the release definition say the demo is milestone M5, not the product.
- **Where:** `CLAUDE.md:36-46`, `AgentComms/roadmap.json:1801-1805`.
- **Evidence/repro:** The product sheet is "NOT yet signed off" (`roadmap.json:1802`). The demo deadline is real but the release identity is larger.
- **Why it matters:** A demo built under time pressure can freeze an incomplete identity in players' minds (see Boxing Club Manager failure mode in `G62_COMPETITOR_SURVEY.md:216-227`).
- **Severity:** Medium
- **Confidence:** Medium
- **Specific fix:** Frame the demo explicitly as "Playable with a Boxer — one ruleset, one watchable bout." Do not show kickboxing/MMA/grappling in the demo unless they pass the same watch-loop gate.
- **Effort:** Small
- **Type:** ASSUMPTION (schedule/risk judgment)

### 10. The "gym vs gym" rivalry remains fighter-pair only

- **What:** The operator asked for rival gyms and high-stake tournaments to feel real. `Rivalries.gd` tracks fighter-pair heat; there is no gym-level rivalry object (`G89_FIGHT_HYPE.md:14-25`, `136-148`).
- **Where:** `G89_FIGHT_HYPE.md:136-148`, `roadmap.json:753-759` (S73).
- **Evidence/repro:** G89: "There is no gym object." Real coverage treats the gym as the faction, the fighter as its champion.
- **Why it matters:** Without gym-level heat, "rival gyms" is just a presser line. It underdelivers the operator's specific ask.
- **Severity:** Medium
- **Confidence:** High
- **Specific fix:** Add a gym-pair heat record (0-100) fed by poaching, inter-gym bouts, and tournament team scores. Wire it into purse multipliers and crowd mix.
- **Effort:** Medium
- **Type:** CONFIRMED

### 11. Feature backlog has items that do not serve the three pillars

- **What:** Backlog includes SWEAT (wet skin), LIGHT (baked gym lighting), STAFFKIT (clothed staff), SUITPILOT, and OWN PROMOTION (`roadmap.json:1765-1793`). DECISION_LEDGER also lists "Planned on operator's ask, never built" items (`DECISION_LEDGER.md:30-38`).
- **Where:** `AgentComms/roadmap.json:1765-1793`, `DECISION_LEDGER.md:30-38`.
- **Evidence/repro:** These are not in the v1 product sheet or stage A-E done-when criteria.
- **Why it matters:** Each is a good idea, but together they risk expanding scope before the core identity is proven. The operator already rejected the "quota" approach to agent assignment (`CLAUDE.md:16-25`).
- **Severity:** Low
- **Confidence:** Medium
- **Specific fix:** Run every new task through the three-pillar filter. If it does not make the fight more real, the gym more runnable, or the "why" more visible, backlog it until post-EA.
- **Effort:** Small
- **Type:** PREFERENCE

### 12. Store/market positioning is clear but must stay honest

- **What:** The competitor survey shows FightCamp's gap is promoter-side commerce, rival organizations, and Workshop support; its edge is the calibrated engine (`G62_COMPETITOR_SURVEY.md:18-22`, `201-212`).
- **Where:** `G62_COMPETITOR_SURVEY.md:18-22`, `201-212`.
- **Evidence/repro:** Four of five competitors are unreleased promises; BCM shipped with broken 3D and mixed reviews. FightCamp's brief does not claim promoter mode or rival orgs for v1.
- **Why it matters:** Marketing copy must not promise what v1 lacks. The identity is "gym-first stand-up sim," not "promoter tycoon."
- **Severity:** Low
- **Confidence:** High
- **Specific fix:** Keep Steam/store copy aligned with v1 scope. Avoid "MMA" as a headline until the first update.
- **Effort:** Small
- **Type:** CONFIRMED

## Summary

FightCamp has a strong, well-defined identity on paper and a simulation layer that already differentiates it. The creative risk is not that the game does not know what it is; it is that **presentation, scope discipline, and emotional stakes are not yet pulling their weight against the simulation**. The three priorities for protecting identity are:

1. **Choose the visual direction and finish stage B before expanding.** Lock M34, hit 36/36 boxing clips, and pass the operator watch loop.
2. **Make the watchable fight credible.** One venue, one crowd, one camera pass, and sound placeholders matter more than new rulesets right now.
3. **Wire emotional stakes into management.** Gym heat, ticket numbers, and pre-fight consequence previews turn the spreadsheet into a career.

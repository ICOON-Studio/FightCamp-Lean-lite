# Reviewer #7 — Player & Market

## Evidence summary: what the game is

FightCamp is a PC combat-sports gym management simulator for Steam, built in Godot 4.7.2. The player runs a gym, signs fictional fighters, trains them, books bouts, cuts weight, and watches fights resolve in a 3D arena. The product sheet (`S75_PHASE0.html:99-109`) targets management-sim players who follow combat sports — Football Manager / Motorsport Manager / Punch Club fans — at Early Access **$19.99** (1.0 $24.99), with a **10,000 wishlist** target. v1 scope is stand-up sports only: boxing, kickboxing, Muay Thai; MMA + grappling is the first major update (`S75_PHASE0.html:104`; `DECISION_LEDGER.md` D19-D20).

The project has a calibrated real-time fight engine seeded on published fight statistics (J20, CompuBox), a career loop that walks end-to-end with a boxer (`S117_DIGEST.md:6-9`), and a brass/leather visual direction. As of S122 the active milestone is **"Playable with a Boxer"**: 16 of 36 boxing moves have passed the C223 animation gate on generated legal bodies (`roadmap.json` now.id S122; `S122_DIGEST.md`). No `.exe` is allowed until all 36 boxing moves pass (D3).

## Missing material

- No exported `.exe` exists yet, so first-time player onboarding, install experience, and frame-rate on a clean machine are **unverified**.
- No Steam page, store copy, or live wishlist counter exists; market data is from competitor store pages and research files only.
- Audio is reviewed from files/code only — playback-dependent findings are marked **Not verified**.
- The career walk (`tools/s64_career_walk.gd`) was not re-run for this review; the last reported walk is S117 (83 steps, 0 failures) and S121/S122 reported focused subsets only.

## Strengths to protect

1. **Calibrated fight engine as the core USP.** The real-time simulation is anchored to published data (CompuBox connect rates, BoxRec KO rates, J20 strike distributions) and supports seeded replay. This is the feature no competitor documents at this grain (`G62_COMPETITOR_SURVEY.md:14`, `GAME_DESIGN.md:341-358`).
2. **Career loop is complete end-to-end for a boxer.** S117 walked new career → sign → train → book amateur bout → camp → weigh-in → fight night → result → next week → save with no dead end (`S117_DIGEST.md:6-9`).
3. **Distinct visual direction.** Brass, leather, aged wood, and warm gym lighting give a premium, serious identity that separates the game from spreadsheet sims (`D24_HUB_DISPLAY_EVAL.md:10-11`).
4. **"Why did it happen" feedback layer.** The plan-outcome lines and corner-read mechanics are designed to tie choices to fight results (`D48_DIGEST.md`, `D49_DIGEST.md`).
5. **Market vacuum for a credible MMA/gym management game.** Punch Club leads boxing-management by volume, but no high-n, high-score MMA gym sim exists on Steam (`G103_MENU_BENCHMARK_TEARDOWN.md:79-90`).

## Findings

### 1. The game is entering a real market vacuum, but only if it ships before the unreleased competitors

**What:** There is no high-review-count, high-score MMA or combat-sports gym management game on Steam in 2026. Punch Club (~16k reviews, ~80%) is the volume leader but is a life-sim boxing tycoon, not a gym sim. The closest shipped "run a gym" peer, Boxing Club Manager, is Mixed (~87 reviews, ~57%) and widely cited as abandoned (`G103_MENU_BENCHMARK_TEARDOWN.md:79-90`; `G62_COMPETITOR_SURVEY.md:215-226`). Four of five named competitors (MMA Sim King, PROMOTER, THE FIGHT BUSINESS, plus Pound for Pound in demo) are unreleased promises (`G62_COMPETITOR_SURVEY.md:26-35`).

**Where:** `G103_MENU_BENCHMARK_TEARDOWN.md:79-90`, `G62_COMPETITOR_SURVEY.md:26-35` and feature matrix.

**Evidence:** Steam-review volume/score table in G103; BCM post-launch branch stopped June 2023 and peak CCU was 27.

**Why it matters:** FightCamp's window is now, before Pound for Pound (EA Mar 2026), Cage Empire (Sep 2026), Elite MMA Manager (Q4 2026), and PROMOTER (2027 EA) land. Delays past H1 2027 likely compress pricing and discoverability.

**Severity:** High  
**Confidence:** High  
**Fix:** Treat the 10,000-wishlist target as a hard gate; launch Steam page as soon as legal assets are clean (Tripo Pro regeneration, music replacement). Use the calibrated engine and "living gym" angle as the store-page lead.  
**Effort:** Medium  
**Type:** CONFIRMED

---

### 2. The target audience is well chosen but the game must prove the numbers are trustworthy

**What:** The product sheet names management-sim players who follow combat sports and specifically cites Football Manager, Motorsport Manager, Punch Club, and World Championship Boxing Manager (`S75_PHASE0.html:101`). This audience reads menus, wants numbers to be true, and plays long sessions.

**Where:** `S75_PHASE0.html:101`; `G62_COMPETITOR_SURVEY.md:16`.

**Evidence:** The target player line is an operator estimate, but the comparable titles are real and the engine's calibration work (J20, CompuBox) is documented across S26, S27, S119, S122.

**Why it matters:** Boxing Club Manager was punished because its fight engine outcomes did not match its 3D presentation — players called the sim a "coin flip" (`G62_COMPETITOR_SURVEY.md:221`). FightCamp's audience will do the same if the 3D room or result screen ever contradicts the engine's logged numbers.

**Severity:** High  
**Confidence:** High  
**Fix:** Keep the result-screen plan-outcome lines (`D48_DIGEST.md`, `D49_DIGEST.md`) and expand them to show denominators ("19 of 31 landed to head") rather than opaque grades. Add a "verify" log or export so streamers can check the engine against the broadcast.  
**Effort:** Small  
**Type:** CONFIRMED

---

### 3. FightCamp is a gym-first sim while the strongest competitors sell promotion-side commerce

**What:** The competitor survey identifies a parity gap: MMA Sim King, PROMOTER, THE FIGHT BUSINESS, and Believr all feature broadcaster/PPV/ticket/gate economics, rival promotions that poach, and sandbox/database modes. FightCamp's loop is gym → booking → fight; it does not simulate card construction for profit, broadcast deals, or rival-org bidding wars (`G62_COMPETITOR_SURVEY.md:200-208`).

**Where:** `G62_COMPETITOR_SURVEY.md:200-208`, feature matrix rows "Finances, sponsorship, broadcast" and "Rival promotions".

**Evidence:** Feature matrix shows FC as "U as first-class PPV/broadcast" and "Rival organisations competing for dates/talent/broadcast U" (`G62_COMPETITOR_SURVEY.md:64`, `143`).

**Why it matters:** At $19.99, players will compare depth per dollar. If competitors ship with promoter tycoon layers and FightCamp does not, the price point reads as high for a gym-only loop.

**Severity:** Medium  
**Confidence:** High  
**Fix:** Make the gym-market and hype systems visible revenue drivers (gate/PPV numbers from `G89_FIGHT_HYPE.md` proposal 3) rather than hidden formulas; postpone full promotion mode to the first update but surface the financial consequences of hype.  
**Effort:** Medium  
**Type:** CONFIRMED

---

### 4. The "living gym" hub is the clearest visual differentiator and it is not yet delivered

**What:** Dola's fresh-eyes review of the HOME hub found that the static background "looks nearly empty" regardless of roster size, with fighters only visible as small bottom cards. Option C — using the 3D engine to show assigned fighters in the gym — is identified as the unique selling point versus Cage Legacy's still-based hub (`D24_HUB_DISPLAY_EVAL.md:16-19`, 43-55).

**Where:** `D24_HUB_DISPLAY_EVAL.md`; `G103_MENU_BENCHMARK_TEARDOWN.md:104` ("living gym floor as the main menu" is the open lane).

**Evidence:** D24 option evaluation table; G103 section 5 row 1 ("Living place-as-hub" ADOPT).

**Why it matters:** The first 10 seconds of a Steam demo decide wishlists. If the hub reads as "pretty wallpaper," the game loses its strongest visual hook and converges with lower-budget competitors.

**Severity:** High  
**Confidence:** High  
**Fix:** Implement D24's "C-light" slice: HOME hub only, 3D overlay, max 3 fighters on assigned stations, 2-3 simple training animations, keeping the existing UI. Gate: ≥30 fps on the operator's PC and player response "it feels alive."  
**Effort:** Medium  
**Type:** CONFIRMED

---

### 5. Generated fighter portraits currently fail the "human" test for half the cards

**What:** Dola reviewed an 8-card grid of generated fighter portraits and judged 5 as "mannequin," 2 as "fighter," and 1 as "real person." Top failure signals were flat eyes, poreless skin, and identical underlying skull structure across cards (`D40_FRESH_EYES_THE_GENERATED_CARDS.md:6-34`).

**Where:** `D40_FRESH_EYES_THE_GENERATED_CARDS.md`; `S93_DIGEST.md` / `S94_DIGEST.md` generator pipeline.

**Evidence:** Dola's one-second judgement table and Claude's read confirming the generator's base looks like "one skull with a new tint."

**Why it matters:** Fighter identity is the emotional hook in any manager sim. If the default portraits read as plastic, the player never forms attachment, and attachment drives long sessions and roster retention.

**Severity:** High  
**Confidence:** High  
**Fix:** Widen bone-shape ranges on face keys (jaw, brow/forehead, cheekbone, nose bridge), add skin detail/roughness map and eye catchlights, then re-test with Dola. Hair caps and beards follow (`D40_DIGEST.md:39-43`).  
**Effort:** Medium  
**Type:** CONFIRMED

---

### 6. The weigh-in and fight-week screens use confusing jargon that will alienate first-time players

**What:** Dola flagged "DAY -6 TO BELL" as reading like a bug, "CAMP WEEKS / 0" as unclear, and "not on the scale yet" as contradictory when the fighter's weight is already displayed. The Weigh-In screen also lacks a clear consequence line for missing weight (`D25_FRESH_EYES_FIGHT_WEEK.md:30-32`, 49-52).

**Where:** `D25_FRESH_EYES_FIGHT_WEEK.md`; screens `25_fight_week.png`, `26_fight_camp.png`, weigh-in render.

**Evidence:** Dola's three concrete fixes: replace "DAY -6 TO BELL" with "6 DAYS TO FIGHT NIGHT," remove the dead camp-plan section, and make the over-limit status the dominant line.

**Why it matters:** Weight cutting is one of the genre's most memorable mechanics (Undisputed reviews cite it repeatedly). Confusing the player at this screen wastes a key retention moment.

**Severity:** Medium  
**Confidence:** High  
**Fix:** Apply D25's three fixes verbatim; add a one-line consequence badge ("OVER LIMIT — must cut 3.7 kg or bout is off").  
**Effort:** Small  
**Type:** CONFIRMED

---

### 7. The result screen buries the proof that player choices mattered

**What:** Dola's 5-second scan of the result screen found the visual order is Result → Cards → Opponent stats, while "THE PLANS" (the player's choices and their outcomes) lands last. For "did my choices matter?" the order should be Result → Cards → Plans (`D50_DIGEST.md:13-25`).

**Where:** `D50_DIGEST.md`; `S102_DIGEST.md` / `Godot/scripts/ResultScreen.gd` (plan-outcome lines).

**Evidence:** Dola's eye-gaze ranking table and recommendation to move THE PLANS into the left column below THE CARDS.

**Why it matters:** If the plan-outcome lines are hidden, the player sees a win/loss and assumes dice. The entire strategic layer collapses into decoration.

**Severity:** High  
**Confidence:** High  
**Fix:** Move THE PLANS block to the primary left column below THE CARDS; fold the redundant CAUSE paragraph into a one-line summary; use D49's ship wording ("ROUND 3 READ (THE TELL) · 4 COUNTERS (R2: 1) · 14 LANDED (R2: 9)").  
**Effort:** Small  
**Type:** CONFIRMED

---

### 8. Hype systems exist but do not yet spend on money, crowd, or walkout

**What:** G89 found that Rivalries.gd (fighter-pair heat) and PressConferences.gd (fight-week questions) already model conflict, but there is no gym-vs-gym rivalry object, no ticket/PPV number driven by hype, no crowd composition, and no 3D fight-week content. The research ranks "tickets/gate/PPV number that read HYPE" as the missing receipt (`G89_FIGHT_HYPE.md:24`, 151-153, 177-183).

**Where:** `G89_FIGHT_HYPE.md:12-25`, `151-253`; `G102_FIGHT_HYPE_SEQUENCES.md:77-93` (proposed 7-beat sequence).

**Evidence:** G89's proposed build order and G102's real fight-week sequence (offer → camp → weigh-in → TOTT → bell).

**Why it matters:** Hype that does not change the take or the room feels like flavor. Players praised UFC 5's social-feed payouts but called them shallow because they did not change the building or walkout (`G89_FIGHT_HYPE.md:146-149`).

**Severity:** Medium  
**Confidence:** High  
**Fix:** Ship G89's top slice first: gym heat object + tournament-round hype carry + a displayed gate/PPV number derived from hype + title + hometown. Wire it into settlement and crowd volume.  
**Effort:** Medium  
**Type:** CONFIRMED

---

### 9. The corner minute is promising but the UI link between body and treatment cards is weak

**What:** Dola reviewed the S97 corner UI and found the body-silhouette markers and the three treatment cards do not visually link: "1 CLOSE / 2 DEAD-LEG / 3 NO-AIR" exists but the eye does not connect numbers to cards instantly (`D45_THE_PIT_STOP_CORNER_FRESH_EYES.md:35-36`). The Motorsport Manager pit-stop model is cited as the reference.

**Where:** `D45_THE_PIT_STOP_CORNER_FRESH_EYES.md`; `Godot/scripts/CornerMinuteScreen.gd` / `FightHudPanel.gd`.

**Evidence:** Dola's numbered-badge recommendation and the comparison to MM pit stops.

**Why it matters:** The corner minute is a unique management verb. If the player cannot read it in 5 seconds, it becomes busywork — exactly the trap D44 warned against (`D44_THE_CORNER_MINUTE_PLAYER_VIEW.md:25`).

**Severity:** Medium  
**Confidence:** High  
**Fix:** Draw matching numbered badges on the body silhouette that correspond to the three treatment cards; flash the card + time bar when a choice exceeds budget.  
**Effort:** Small  
**Type:** CONFIRMED

---

### 10. Legal and asset risks threaten the $19.99 price point

**What:** S75's legal inventory identifies multiple items that cannot ship in a paid game: the twelve Tripo fighters were generated on the free "Public Models · Non-Commercial Use" plan and must be regenerated on Tripo Pro before release; the menu music is a YouTube rip with no licence; Ludo retarget clip terms are unrecorded; the Godot copyright notice is missing from credits (`S75_PHASE0.html:134-145`, 188). Budget burn is ~€294-343/month, requiring ~480-560 copies/year just to cover tools, against a S73 floor of 3k-6.5k lifetime copies (`S75_PHASE0.html:191`).

**Where:** `S75_PHASE0.html` legal inventory and budget sections; `DECISION_LEDGER.md` D12, D22-D26.

**Evidence:** Tripo free-plan chip = "Cannot ship"; menu music chip = "Cannot ship"; Godot notice chip = "Notice missing."

**Why it matters:** These are hard blockers for a $19.99 Steam release. The price is only viable if the build is legally shippable; otherwise the project cannot sell at any price.

**Severity:** Critical  
**Confidence:** High  
**Fix:** Before fixing public build: regenerate fighters on Tripo Pro; replace menu music with licensed/commissioned track; confirm or drop Ludo clips; add Godot/OFL/MIT credits screen; schedule one games-lawyer consult.  
**Effort:** Medium  
**Type:** CONFIRMED

---

### 11. The 3D fight room still looks worse than the stills, which reverses the intended value proposition

**What:** The operator's own verdict on the 3D room was "the head was not visible on either fighter and artifacts around them, motion was terrible" (`S8b` in `roadmap.json:522-523`). The current milestone (S122) is gated on 36/36 boxing clips passing the C223 gate, precisely because the operator ruled no `.exe` until the boxing animations are smooth (`DECISION_LEDGER.md` D3; `roadmap.json` now S122).

**Where:** `roadmap.json:522-523`, `989-1019`; `DECISION_LEDGER.md` D3; `S122_DIGEST.md`.

**Evidence:** S8b recording findings; S122 boxing 16/36 with 20 left; operator ruling "no exe until boxing clips completed and smooth."

**Why it matters:** The 3D fight is the payoff for the management loop. If it is "painful to watch," players will skip it and the game's core differentiator disappears. This is the same failure mode that sank Boxing Club Manager's 3D pitch.

**Severity:** Critical  
**Confidence:** High  
**Fix:** Finish the 36 boxing moves through the C223 gate (bound, mid-band, no edge-tuning) before any market push; only then resume `.exe` builds and video trailers. Do not broaden to kickboxing until boxing is stable.  
**Effort:** Large  
**Type:** CONFIRMED

---

### 12. The training-floor labels collide with props, breaking readability

**What:** Dola's D61/D63 reviews found fighter name tags overlapping the ring top rope, heavy-bag chains, and stationary bike/rower icons. The labels read as "editor debug text" rather than in-world UI (`D61_DIGEST.md:20-26`, `D63_DIGEST.md:17-36`).

**Where:** `D61_DIGEST.md`; `D63_DIGEST.md`; `Godot/scripts/TrainingFloor3D.gd` / fighter tag placement.

**Evidence:** Dola's overlap tables for WESLEY HALE, COLE KOWALSKI, DARIO LARKIN.

**Why it matters:** Training-floor readability is part of the daily loop. Overlapping labels train the player to ignore the 3D view and read only the bottom cards, undoing the living-gym investment.

**Severity:** Medium  
**Confidence:** High  
**Fix:** Anchor each tag above the fighter's head with a small backing plate; run collision checks against nearby prop geometry; move DARIO LARKIN's tag off the bike icon and WESLEY HALE's off the ring rope.  
**Effort:** Small  
**Type:** CONFIRMED

---

### 13. Staff room lacks the status summary a manager needs

**What:** Dola found the staff room shows identical neutral cards for every coach; load state requires reading every card. "HIRE A COACH" reads as decoration because it has no button shape or hover cue (`D57_DIGEST.md:17-35`).

**Where:** `D57_DIGEST.md`; `Godot/scripts/StaffRoom3D.gd`.

**Evidence:** Dola's four-question table and recommendation for colour-coded badges (green = open slots, yellow = at capacity, red = overloaded, white = idle) plus a top summary line.

**Why it matters:** Staff management is a core management-sim verb. If the room cannot be scanned in one second, it fails the Football Manager / Motorsport Manager density standard the target audience expects.

**Severity:** Medium  
**Confidence:** High  
**Fix:** Add colour-coded status badges to coach cards and a top summary line ("2 unassigned fighters — hire or reassign"); make "HIRE A COACH" a button with hover state.  
**Effort:** Small  
**Type:** CONFIRMED

---

### 14. The product scope is correctly frozen, but the demo must not be confused with release

**What:** The product sheet and DECISION_LEDGER correctly freeze MMA/grappling as the first major update and keep v1 to stand-up sports (`S75_PHASE0.html:104`; `DECISION_LEDGER.md` D19-D20). However, the operator has also asked for a demo build, and the active milestone is "Playable with a Boxer," not the full product (`roadmap.json` now S122).

**Where:** `S75_PHASE0.html:104`; `DECISION_LEDGER.md` D19-D20; `roadmap.json` now.

**Evidence:** Operator quote in D2: "release is not the demo, its the whole fucking game."

**Why it matters:** A strong demo can build wishlists, but if the team ships MMA before the stand-up loop is trusted, the game risks the Boxing Club Manager failure: breadth without depth.

**Severity:** Medium  
**Confidence:** High  
**Fix:** Keep the demo boxing-only; market the EA as "boxing/kickboxing/Muay Thai gym sim" with MMA as the first update, matching the product sheet exactly. Do not promise MMA in EA store copy.  
**Effort:** Small  
**Type:** CONFIRMED

---

## Summary table

| # | Finding | Severity | Confidence | Fix effort | Type |
|---|---|---|---|---|---|
| 1 | Market vacuum exists but closing in 2026-27 | High | High | Medium | CONFIRMED |
| 2 | Target audience wants trustworthy numbers | High | High | Small | CONFIRMED |
| 3 | Competitors sell promotion commerce; FC is gym-only | Medium | High | Medium | CONFIRMED |
| 4 | Living 3D gym hub is the key differentiator, not yet delivered | High | High | Medium | CONFIRMED |
| 5 | Generated portraits read as mannequins for 5/8 cards | High | High | Medium | CONFIRMED |
| 6 | Weigh-in / fight-week jargon confuses first-timers | Medium | High | Small | CONFIRMED |
| 7 | Result screen buries plan-outcome proof | High | High | Small | CONFIRMED |
| 8 | Hype systems do not yet spend on money/crowd | Medium | High | Medium | CONFIRMED |
| 9 | Corner-minute body↔card link is weak | Medium | High | Small | CONFIRMED |
| 10 | Legal/asset blockers threaten shippability | Critical | High | Medium | CONFIRMED |
| 11 | 3D fight motion is still below ship bar | Critical | High | Large | CONFIRMED |
| 12 | Training-floor labels overlap props | Medium | High | Small | CONFIRMED |
| 13 | Staff room lacks scan-able status | Medium | High | Small | CONFIRMED |
| 14 | Demo must not be mistaken for full release scope | Medium | High | Small | CONFIRMED |

## Top 5 player-market actions

1. **Unblock shippability first** — Tripo Pro regeneration, music replacement, credits notice, lawyer consult (Finding 10).
2. **Finish the 3D fight animation gate** — 36/36 boxing moves through C223 before `.exe`/trailer (Finding 11).
3. **Make the hub alive** — C-light 3D gym slice with 3 fighters on stations (Finding 4).
4. **Fix the result-screen proof** — move THE PLANS to primary real estate (Finding 7).
5. **Launch Steam page with the engine/hub angle** — start collecting the 10k wishlists (Finding 1).

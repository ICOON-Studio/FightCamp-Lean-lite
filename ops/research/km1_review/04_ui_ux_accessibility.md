# Reviewer #4 — UI/UX & Accessibility

## 1. What the evidence says the game is

FightCamp is a Godot 4 PC combat-sports gym management sim. The player runs a gym from a persistent office/hub, trains fighters, books fights, and watches bouts resolve in a 3D ring. The current milestone is **"Playable with a Boxer"** (stage B, 58%): one boxer must be trainable, bookable, and watchable through a complete career loop, with all 36 boxing moves passing the C223 animation gate before any .exe is built (D3).

The UI is built from a single kit (`UIKit.gd` + `UITokens.gd`) driving ~31 player-facing `SceneRouter` routes, hosted inside `CareerRoot` with a left rail and a top `ShellChrome` bar. The flow passes (Kalli, S80–S89) have locked route names and many hub labels, but the actual chrome is still a mix of `ShellChrome` and legacy `ManagementChrome`, and the fight-night/post-fight screens are still being dressed.

## 2. Strengths to protect

- **Unified kit foundation.** `UIKit.gd`/`UITokens.gd` gives every screen a shared palette, type system, elevation model, and tooltip helper (`UIKit.tip`). This is the right architecture; expanding it beats rewriting per screen.
- **Strong visual identity.** Dola reports (D24–D26) confirm the warm brass/leather direction reads as premium and distinctive versus genre competitors. The rail, date plate, and resource pills are instantly scannable.
- **Clear primary action language.** The "green = Continue / GO" rule is enforced in code and comments (`UIKit.gd:1591`; `ShellChrome.gd:463`), preventing the button-salad common in sim UIs.
- **Router navigation is testable and layered.** `SceneRouter` supports `go`/`push`/`pop`/`replace`, and tests verify route resolution and stack depth (`Godot/tests/scene_router_test.gd`).
- **Tooltips are wired.** `UIKit.tip` plus the `TipLayer` autoload gives every control a cheap way to expose a term or explanation.
- **Fight feedback is improving.** THE PLANS card on the result screen (`FightResultPanel.gd`) and the between-rounds corner panel (`CornerPanel.gd`) show the team already understands that player choices must be visible.

## 3. Findings

### Menus & Navigation

#### F1 — Keyboard navigation is disabled almost everywhere
- **What:** The dominant pattern in `UIKit.gd` is `hit.focus_mode = Control.FOCUS_NONE` for every clickable row, tile, card, and grid cell (e.g. `UIKit.gd:2744`, `:2910`, `:3144`, `:4831`; `SkillsMovesPanel.gd:314`; `ProfileRevampPanel.gd:1909`; `OfficeHubPanel.gd:1329`). `ShellChrome.gd:464` sets the top Continue button to `FOCUS_ALL`, but nothing else in the rail or content accepts focus.
- **Where:** `Godot/scripts/UIKit.gd`, `SkillsMovesPanel.gd`, `ProfileRevampPanel.gd`, `OfficeHubPanel.gd`, `ShellChrome.gd`.
- **Evidence/repro:** Grep `focus_mode = Control.FOCUS_NONE` across `.gd`; run any screen and press Tab — focus never leaves the Continue button.
- **Why it matters:** Mouse-only UI excludes players who cannot use a mouse precisely (motor impairments, laptop trackpad users, couch play) and slows power users. The brief says keyboard+mouse is the target.
- **Severity:** High.
- **Confidence:** High.
- **Fix:** Remove the blanket `FOCUS_NONE` from interactive kit elements; set `focus_mode = FOCUS_ALL` and wire `focus_next`/`focus_previous`/`focus_neighbor_*` for rail → content → primary action. Add `ui_accept`/`ui_cancel` handlers in `CareerRoot` or `ShellChrome`.
- **Effort:** Medium.
- **Type:** CONFIRMED.

#### F2 — No keyboard shortcuts for common actions
- **What:** No `_input`/`_unhandled_input`/`_gui_input` handler in `CareerRoot`, `ShellChrome`, `ManagementChrome`, or the hub panels maps ESC to back/pop, Enter to the primary gold action, or number keys to rail items. The only keyboard mention is the debug-style "WAY OUT ESC · POP" label on fight screens (`s117_walk_game/77_result.png`, `75_bout_live.png`).
- **Where:** `Godot/scripts/CareerRoot.gd`, `ShellChrome.gd`, `ManagementChrome.gd`, `FightNightScreen.gd` (assumed from absence).
- **Evidence/repro:** Grep for `InputEventKey`, `ui_accept`, `ui_cancel`, `shortcut` in the listed files — no matches.
- **Why it matters:** Without shortcuts the player must mouse to every action; this is especially painful in the fight-night speed controls (1X/2X/4X/SIM TO RESULT) and corner choices.
- **Severity:** High.
- **Confidence:** High.
- **Fix:** Add a top-level input handler in `CareerRoot`/`SetpieceRoot`: ESC → `router.back_or(<safe fallback>)`, Space/Enter → trigger the current screen's gold button, 1–9 → rail items when no modal is open.
- **Effort:** Small.
- **Type:** CONFIRMED.

#### F3 — Dual navigation system is not fully collapsed
- **What:** `ManagementChrome.gd:54` still defines `DIRECT_SCENES["day_feed"]: "res://scenes/DayFeedScreen.tscn"`, and `DayFeedScreen.gd:5` still documents the old ManagementChrome/DIRECT_SCENES path. `ShellChrome` delegates navigation to `ManagementChrome.navigate_to`, which can still remount the standalone `DayFeedScreen.tscn`. Flow Pass 4 decided to kill this remount, but the wiring and scene file remain.
- **Where:** `Godot/scripts/ManagementChrome.gd:54`, `DayFeedScreen.gd:5`, `ShellChrome.gd:288`.
- **Evidence/repro:** Read `ManagementChrome.DIRECT_SCENES`; `DayFeedScreen` _ready builds a shell if run standalone.
- **Why it matters:** Two ways to open THE DAY risk state desync, double chrome, and divergent test surfaces. It also blocks the "one hosted THE DAY" rule.
- **Severity:** Medium.
- **Confidence:** High.
- **Fix:** Remove `day_feed` from `DIRECT_SCENES`; delete or quarantine `DayFeedScreen.tscn` from player builds; update `DayFeedScreen.gd` comment. Keep only the hosted `day_feed` route.
- **Effort:** Small.
- **Type:** CONFIRMED.

#### F4 — Result-screen leave label does not match the route name
- **What:** `FightResultPanel.continue_label_for` returns `"BACK HOME ▸"` for an empty card, but the route it opens is `day_feed` whose rail label is "THE DAY". Flow Pass 4 wanted `"BACK TO THE DAY ▸"`.
- **Where:** `Godot/scripts/FightResultPanel.gd:1148`.
- **Evidence/repro:** Read the function; compare to `SceneRouter.ROUTES["day_feed"].label` = "HOME" and `ShellChrome` rail label "THE DAY".
- **Why it matters:** Inconsistent home/day/home naming confused Dola in earlier passes (D25/D26); the final label should match the surface the rail already names.
- **Severity:** Low.
- **Confidence:** High.
- **Fix:** Change `"BACK HOME ▸"` to `"BACK TO THE DAY ▸"`.
- **Effort:** Small.
- **Type:** PREFERENCE (matches Flow Pass 4 decision).

### Readability & Information Design

#### F5 — Placeholder/debug text is visible in a shipping panel
- **What:** The Development tab's TRAIT PLATE reads: *"The label the player sees; the goals, the asks and the bond does."* The trailing "does." is an unfinished sentence and reads as internal annotation.
- **Where:** `DesignLibrary/screens/profile_revamp/development.png`; `Godot/scripts/DevelopmentPanel.gd` (the trait plate section around line 434 prints `_wrap(str(lines[i]), ...)` with raw lines).
- **Evidence/repro:** Open `DesignLibrary/screens/profile_revamp/development.png` — the text is clearly visible on the right-hand TRAIT PLATE.
- **Why it matters:** It signals an unfinished game and breaks immersion in a tab the player visits repeatedly.
- **Severity:** High.
- **Confidence:** High.
- **Fix:** Replace the raw lines with final player-facing copy or hide the block until copy is authored.
- **Effort:** Small.
- **Type:** CONFIRMED.

#### F6 — Post-fight screen shows developer legend text
- **What:** The bottom-right of the result screen reads *"CONTINUE IS GO GREEN · THE ONLY PRIMARY EXIT"*. This is a design-rule annotation, not player copy.
- **Where:** `previews/s117_walk_game/77_result.png`; bottom-right corner.
- **Evidence/repro:** View the preview; the line is present in the shipped-looking screenshot.
- **Why it matters:** Developer-facing legends must not appear in player-facing builds; this is the kind of "debug UI" the operator explicitly rejected in R111.
- **Severity:** High.
- **Confidence:** High.
- **Fix:** Remove the legend label from `FightResultPanel` or replace it with a contextual hint (e.g., "Next bout in 6 days").
- **Effort:** Small.
- **Type:** CONFIRMED.

#### F7 — Result screen buries THE PLANS below reference stats
- **What:** Dola's 5-second scan (D50) shows the eye lands on result → scorecards → opponent stats, while THE PLANS (the player's choices and their effect) sits at the bottom. This misorders the screen's purpose: it should answer "did my choices matter?" first.
- **Where:** `Godot/scripts/FightResultPanel.gd`; `DesignLibrary/screens/post_fight/m5_07_composed.png`.
- **Evidence/repro:** D50 section 1; preview shows THE PLANS below THE CARDS and THE READ on the right.
- **Why it matters:** If the player cannot connect plan to outcome, the camp/planning loop feels like dice.
- **Severity:** Medium.
- **Confidence:** High (Dola direct).
- **Fix:** Move THE PLANS into the left column directly below THE CARDS, full width; keep SETTLEMENT and THE READ as secondary right-column reference. Expand each plan line to two lines (rating + intent + outcome).
- **Effort:** Medium.
- **Type:** PREFERENCE (Dola player-view).

#### F8 — Fake precision and vestigial labels on the result screen
- **What:** D50 notes "Output/min: 7.1 vs 7.3" implies precision the simulation does not meaningfully support; "TIME AT BAND" is leftover RANGE jargon; the CAUSE paragraph repeats the cards; the "READ" column header is ambiguous.
- **Where:** `Godot/scripts/FightResultPanel.gd`; D50 section 4.
- **Evidence/repro:** D50 table; `DesignLibrary/screens/post_fight/m5_07_composed.png`.
- **Why it matters:** Extra precision and duplicate labels make the screen harder to scan and erode trust.
- **Severity:** Low.
- **Confidence:** High (Dola direct).
- **Fix:** Round fight stats to whole numbers; rename "TIME AT BAND" to "WHERE FOUGHT"; fold CAUSE into a one-line summary; relabel "READ" to "SCORE" or "MARKS".
- **Effort:** Small.
- **Type:** PREFERENCE.

#### F9 — Schedule hub hint still uses outdated "HOME" wording
- **What:** `ScheduleHubPanel.gd:576` shows `"CLICK A DAY FOR ITS OBLIGATIONS · OPEN HOME FOR WHAT IS DATED"`. Flow Pass 4 decided the route is `day_feed` / THE DAY, and "HOME" is not a route label.
- **Where:** `Godot/scripts/ScheduleHubPanel.gd:576`.
- **Evidence/repro:** Read the line; compare to `FLOW_PASS4_CUTOVER.md` which wanted "OPEN THE DAY FOR WHAT IS DATED".
- **Why it matters:** Minor, but it perpetuates the home/today/day naming confusion the flow passes were meant to end.
- **Severity:** Low.
- **Confidence:** High.
- **Fix:** Change to `"CLICK A DAY FOR ITS OBLIGATIONS · OPEN THE DAY FOR WHAT IS DATED"`.
- **Effort:** Small.
- **Type:** PREFERENCE.

### HUD & Fight Feedback

#### F10 — Fight HUD lacks readable health/damage state
- **What:** The live fight screen (`75_bout_live.png`, `s97/stung_and_chips.png`) shows round/clock, speed controls, and small status chips, but no continuous health/condition read or clear visual link between a fighter's body and damage. Dola (D44) requested body-language first, then subtle on-silhouette chips.
- **Where:** `Godot/scripts/FightHudPanel.gd`; `previews/s117_walk_game/75_bout_live.png`; `previews/s97/stung_and_chips.png`.
- **Evidence/repro:** Previews show only `R1 2:34`, `CORNER · NO INSTRUCTION`, and tiny `LEG · EYE · CUT · AIR` chips. No stamina/trauma bars or body map on the main view.
- **Why it matters:** The corner choices (D45) depend on reading damage quickly; if the player cannot see who is hurt, the pit-stop mini-game becomes guesswork.
- **Severity:** High.
- **Confidence:** High.
- **Fix:** Add a small body silhouette with region pips (pale orange = hurt, deep red = critical) as Dola described; keep it unobtrusive but persistent.
- **Effort:** Medium.
- **Type:** PREFERENCE (D44 direct).

#### F11 — Corner minute links issue numbers to cards weakly
- **What:** Dola (D45) could read the three issues (CLOSE, DEAD-LEG, NO-AIR) and the three treatment cards, but the visual link was not instant. The silhouette has red dots but no numbered badges matching the cards.
- **Where:** `Godot/scripts/CornerPanel.gd`; `previews/s97/corner_card.png`.
- **Evidence/repro:** D45 section 6; preview shows numbered list beside silhouette but no matching badges on the body.
- **Why it matters:** In a 45-second time-pressured choice, mismatch costs wrong treatment and lost rounds.
- **Severity:** Medium.
- **Confidence:** High (Dola direct).
- **Fix:** Add numbered badges to the body silhouette that match the order of the treatment cards; flash the card and time bar when a choice is over budget.
- **Effort:** Small.
- **Type:** PREFERENCE.

#### F12 — Fight-night speed controls are mouse-only and unlabeled for state
- **What:** `FightNightScreen` exposes 1X/2X/4X/SIM TO RESULT as clickable chips (`FightHudPanel` does not own them; the screen does). No keyboard shortcut or active-state highlight is visible in the preview.
- **Where:** `Godot/scripts/FightNightScreen.gd` (assumed); `previews/s117_walk_game/75_bout_live.png`.
- **Evidence/repro:** Preview shows four chips top-right; no pressed/highlight state is visible.
- **Why it matters:** Speed toggles are high-frequency during a fight; making them keyboard-addressable and visually stateful reduces friction.
- **Severity:** Low.
- **Confidence:** Medium.
- **Fix:** Bind number keys 1/2/3/4 to speed; add a pressed style to the active speed chip.
- **Effort:** Small.
- **Type:** ASSUMPTION.

### Onboarding & Objectives

#### F13 — New player has no guided first loop
- **What:** The career walk (`s117_boxer_walk.plan`) is a linear script for QA, not an in-game tutorial. There is no evidence of a first-run guide, contextual callouts, or a glossary gate before the player reaches THE DAY.
- **Where:** `research/s117_boxer_walk.plan`; `Godot/scripts/BootRoot.gd`/`CreationFlowPanel.gd` (no tutorial routes found).
- **Evidence/repro:** `SceneRouter.ROUTES` has no "tutorial" or "first_run" tier; plan file is a QA automation script.
- **Why it matters:** FightCamp has dense systems (training, camp, booking, weight cut, corner). Without onboarding, the first hour will overwhelm players used to lighter sports sims.
- **Severity:** High.
- **Confidence:** Medium (absence of evidence).
- **Fix:** Add a short first-day overlay or modal sequence on THE DAY that points to: set program → book offer → start camp → fight week. Gate it behind a "first career" flag.
- **Effort:** Medium.
- **Type:** ASSUMPTION.

#### F14 — Day-feed briefing and ask cards need clearer action framing
- **What:** Dola (D26) found that only the OFFICE badge read as "needs you"; STAFF, THE RING, and GYM FLOOR labels were phrased as observations ("3 without a coach", "Nobody in the ring this week", "Nobody on a plan yet") rather than actionable tasks.
- **Where:** `Godot/scripts/DayFeedScreen.gd` / `DayFeedPanel.gd`; D26.
- **Evidence/repro:** D26 table; `DesignLibrary/screens/day/day.png` shows "MUST ANSWER · 2" asks but the left rail badges are passive counts.
- **Why it matters:** If a label does not say what to do, players ignore it until it blocks Continue.
- **Severity:** Medium.
- **Confidence:** High (Dola direct).
- **Fix:** Adopt Dola's rewrite: "3 need coaches assigned", "0 scheduled to train", "0 assigned to plans"; only badge when action is required.
- **Effort:** Small.
- **Type:** PREFERENCE.

#### F15 — Weight-cut screen contradicts itself
- **What:** D25 noted the weigh-in shows a fighter's weight (76.3 kg) while also saying "not on the scale yet", and "DAY -6 TO BELL" reads like a bug. "CAMP WEEKS: 0" plus a dead camp-plan section on Fight Week looks broken.
- **Where:** `Godot/scripts/WeighInPanel.gd` / `FightWeekPanel.gd`; D25.
- **Evidence/repro:** D25 sections 2–3.
- **Why it matters:** Weight management is a core system; contradictory copy destroys trust in a number-heavy screen.
- **Severity:** High.
- **Confidence:** High (Dola direct).
- **Fix:** Remove "not on the scale yet" when a weight is displayed; change "DAY -6 TO BELL" to "6 DAYS TO FIGHT NIGHT"; replace the empty camp-plan section with "Fight this week — camp phase complete".
- **Effort:** Small.
- **Type:** CONFIRMED (Dola direct).

### Accessibility

#### F16 — Green Continue button fails WCAG contrast
- **What:** `ShellChrome.gd:480` uses white text (`Color.WHITE`) on `GO #22c55e`. The code comment at `UIKit.gd:1591` admits this is 2.3:1. WCAG AA requires 4.5:1 for normal text.
- **Where:** `Godot/scripts/ShellChrome.gd:466–485`; `UIKit.gd:1591`.
- **Evidence/repro:** Read the code; calculate relative luminance of `#22c55e` (~0.32) vs white (1.0) → ~3.1:1, or with the darkened pressed state even lower; the comment itself cites 2.3:1.
- **Why it matters:** Low-vision players and many displays cannot read the most important button in the game.
- **Severity:** High.
- **Confidence:** High.
- **Fix:** Either darken the green to ~`#166534` with white text, or keep `#22c55e` and use `INK` (`#1b1207`) text as the comment suggests. Prefer the latter — it matches the existing GO/INK pairing.
- **Effort:** Small.
- **Type:** CONFIRMED.

#### F17 — No accessibility settings
- **What:** `UserSettings.gd` saves video mode, vsync, music volume, and mute. There are no toggles for high-contrast, color-blind modes, UI scale, font size, subtitle/closed-caption, or input remapping.
- **Where:** `Godot/scripts/UserSettings.gd`; `ManagementChrome.gd` settings overlay.
- **Evidence/repro:** Read `UserSettings.gd` exported vars and save/load methods; grep `colorblind`, `high_contrast`, `ui_scale`, `subtitle` — no matches.
- **Why it matters:** Without these options the game is unusable for a significant slice of players. The brief says controller is not promised, but keyboard+mouse accessibility is.
- **Severity:** High.
- **Confidence:** High.
- **Fix:** Add a settings category with at least: UI scale slider (80–150%), high-contrast palette toggle, and font-size bump. For the short term, respect OS display scale.
- **Effort:** Medium.
- **Type:** CONFIRMED.

#### F18 — Status is communicated by color alone in several places
- **What:** The day-feed right badges, goal-card LIVE chips, and corner status chips use red/amber/green but do not consistently pair the color with an icon or text state. `GOOD`/`AMBER`/`BAD` semantic colors are the only cue in many kit components.
- **Where:** `Godot/scripts/UIKit.gd` chip builders; `FightHudPanel.gd`; `CornerPanel.gd`.
- **Evidence/repro:** `DayFeedScreen` red badges are numeric only; `DevelopmentPanel` goal cards show a blue "LIVE" chip but no "complete/expired" text.
- **Why it matters:** Color-blind players cannot distinguish red/amber/green reliably.
- **Severity:** Medium.
- **Confidence:** Medium.
- **Fix:** Add shape or text companions: a check/cross icon, "NEW" / "OVERDUE" labels, or filled vs outline chips.
- **Effort:** Small.
- **Type:** ASSUMPTION.

### Visual/UI Consistency

#### F19 — Some preview screens still use the old blue theme
- **What:** `DesignLibrary/screens/day_feed.png`, `skills_moves.png`, `development.png`, and the `profile_revamp` folder show a cool blue palette, while the current approved direction is M34 Direction A (warm brass/leather, D4, D24).
- **Where:** `DesignLibrary/screens/*.png`; `DesignLibrary/screens/profile_revamp/*.png`.
- **Evidence/repro:** Visual comparison between these screens and Dola's warm-gym descriptions in D24–D26.
- **Why it matters:** Outdated design references in the library can mislead new artists/agents and may leak into builds if screens are rebuilt from old screenshots.
- **Severity:** Low.
- **Confidence:** High.
- **Fix:** Audit `DesignLibrary/screens` and mark/archive blue-theme images as "pre-D4 reference"; replace with current brass/leather captures once the theme is fully applied.
- **Effort:** Small.
- **Type:** CONFIRMED.

#### F20 — Lobby sign overlaps honours wall and cards are misaligned
- **What:** D55 found the "TRIALS & MEMBERSHIP" sign hangs over the honours wall, wires cut across frames, and the right-side cards are vertically offset.
- **Where:** `Godot/scripts/LobbyPanel.gd` / `OfficeRoomPanel.gd`; D55; `previews/s96/room_tier*.png`.
- **Evidence/repro:** D55 sections 2–4.
- **Why it matters:** The lobby/front desk is the first 3D room many players will see; overlapping signage reads as broken.
- **Severity:** Medium.
- **Confidence:** High (Dola direct).
- **Fix:** Move the sign above the front desk; align right-side card tops; add small activity props (mug, notebook, shifted flyer) per D55.
- **Effort:** Small.
- **Type:** PREFERENCE.

## 4. Missing material / cannot verify

- **No live play trace of the current brass/leather build.** The available in-game screenshots (`s117_walk_game`) use an older theme or fight-night debug state; I cannot confirm whether the M34 Direction A chrome is fully applied to THE DAY, profile, or schedule screens in the current build.
- **No exported .exe (operator ruling D3).** All findings about navigation, contrast, and keyboard support are from code and preview stills; runtime behavior in a packaged build is unverified.
- **Audio is Dummy driver only.** Cannot review sound cues, mix, or accessibility subtitles.
- **No accessibility test suite.** No tests cover focus order, contrast, color-only communication, or keyboard shortcuts.
- **Corner UI and fight-night HUD are partially out of scope.** `TASK_CORNER_UI` (Codex) and Maria's VFX look are in flight, so some HUD findings are framed as assumptions/preferences pending final art pass.

## 5. Priority actions for this area

1. **Fix the green Continue contrast** (F16) — one token change, immediate accessibility win.
2. **Remove placeholder/debug text** (F5, F6) — zero-engineering copy fixes that stop the game looking unfinished.
3. **Restore keyboard focus and shortcuts** (F1, F2) — medium effort, required for the stated keyboard+mouse target.
4. **Add a first-run onboarding overlay** (F13) — biggest onboarding improvement before the demo.
5. **Fix weigh-in contradictions** (F15) — direct player-trust issue.
6. **Reorder the result screen to front-load THE PLANS** (F7) — makes the core loop feel meaningful.
7. **Add body-silhouette damage feedback to the fight HUD** (F10) — needed for corner choices to land.
8. **Add accessibility settings** (F17) — UI scale and high contrast at minimum.
9. **Collapse the remaining dual navigation wiring** (F3) — prevents state desync.
10. **Audit DesignLibrary screens for outdated blue-theme references** (F19) — keeps the kit library honest.

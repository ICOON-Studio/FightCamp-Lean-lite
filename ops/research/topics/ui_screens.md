# UI, menus, screens, flow, words, tutorial, profile

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **Menu architecture:** five top-level areas on the left rail - HOME, FIGHTERS, FIGHTS, GYM, MONEY - `J54_MENU_ARCHITECTURE_SURVEY.md`
  (S79 reorganisation); menu art direction and style guide - `M32_MENU_ART_DIRECTION.md`, `M32_MANIFEST.md`; icons and type -
  `M33_ICONS_AND_TYPE.md`; the pitch look (M34 direction A, S80) - `M34_PITCH_PRESENTATION.md`.
- **Words:** one word per job - `K78_S79_WORDS.md`; handbook lines in one house voice - `K77_HANDBOOK_WORDS.md`; 18 real terms
  a first-month player meets were missing - `J53_HANDBOOK_REAL_TERMS.md`; skill band words - `G101_SKILL_BAND_WORDS.md`,
  `D23_SKILL_BAND_WORDS.md`; how management games explain themselves - `J52_TOOLTIPS_AND_TUTORIAL.md`.
- **The hub display** (decided S81: 3D training floor + rooms) - `S81_HUB_DISPLAY_SYNTHESIS.md`, one number per hotspot -
  `G109_HUB_LIVE_COUNTS.md`.
- **Result screen** leads result -> THE PLANS -> scores - `D50_DIGEST.md`; the player-view reviews of every screen are the D-series.
- **Flavour text is specific, never generic** (S206, operator board Q-S205-2 "take the 4 ideas", from his Game Notes Sheet8):
  a news line, story card, scout note or result line names a concrete, sim-true event - "He took a knee to the temple in round 2
  and kept walking" is allowed, "He's tough" is banned; no two fighters in one gym read alike. Review any new text against it -
  `GAME_NOTES_SHEET8_REVIEW_S206.md`.
- **Menus are the product:** the S74 playtest walk found a dead end every test passed; walk the loop in the exported build every
  stage - `S74_READINESS_AUDIT.md` (G11), `S74_PLAYTEST_FIXES.md`.

## Engine
`UIKit.gd`, `SceneRouter`, the hub panels (`*Panel.gd`), `tools/s64_career_walk.gd`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (119, newest first, generated)

- `S101_GTA6_VFX_BREAKDOWN_NOTES.md` (2026-09-27) - S101 - WHAT GTA 6's TRAILER BREAKDOWN MEANS FOR FIGHTCAMP (2026-09-27)
- `D61_DIGEST.md` (2026-09-27) - D61 DIGEST - DOLA - FRESH EYES: THE TRAINING FLOOR AS THE HUB (S113)
- `D50_DIGEST.md` (2026-09-27) - D50 - Dola: fresh eyes on the whole result screen (S102 render)
- `D48_DIGEST.md` (2026-09-27) - D48 DIGEST - post-match screens that prove the plan mattered
- `U177_HUB_DISPLAY_EVAL.md` (2026-09-26) - U177 — Option B (2.5D hub rooms) in Godot: pipeline cost and floor sync
- `S81_HUB_DISPLAY_SYNTHESIS.md` (2026-09-26) - S81 HUB DISPLAY - SYNTHESIS AND RECOMMENDATION
- `Q179_HUB_DISPLAY_EVAL.md` (2026-09-26) - Q179 — Hub Display Evaluation (Qwen lens: training-clip census)
- `M35_ART_PROVENANCE_AND_REPLACEMENTS.md` (2026-09-26) - M35 - WHERE EVERY PICTURE CAME FROM, AND WHAT REPLACES THE ONES WE CANNOT SHIP
- `G111_HUB_GROWS_WITH_ROOMS.md` (2026-09-26) - G111_HUB_GROWS_WITH_ROOMS (Grok, collected by Claude S83, 2026-09-26)
- `G109_HUB_LIVE_COUNTS.md` (2026-09-26) - G109_HUB_LIVE_COUNTS (Grok, collected S82 2026-09-26 from grok.com chat "G109HUBLIVECOUNTS")
- `D25_FRESH_EYES_FIGHT_WEEK.md` (2026-09-26) - D25_FRESH_EYES_FIGHT_WEEK
- `D23_SKILL_BAND_WORDS.md` (2026-09-26) - MEMO — D23: Skill Band Words & Fighter Level Terminology
- `C208_HUB_DISPLAY_EVAL.md` (2026-09-26) - C208 — Live gym rooms, bounded by truthful activity
- `U170_DIGEST.md` (2026-09-25) - U170 digest — the market on screen
- `S81_FIGHT_BUSINESS_SURVEY.md` (2026-09-25) - S81 - COMPETITOR SURVEY: THE FIGHT BUSINESS: BOXING MANAGER (Steam app 5249680)
- `S74_READINESS_AUDIT.md` (2026-09-25) - S74 readiness audit - FightCamp against J49's gate table (Claude, 2026-09-25)
- `M34_PITCH_PRESENTATION.md` (2026-09-25) - M34 — The pitch look: main menu, hub and fight-night hype
- `M33_ICONS_AND_TYPE.md` (2026-09-25) - M33: Icons and type for FightCamp menus (S78 → S79)
- `M32_MENU_ART_DIRECTION.md` (2026-09-25) - M32: The menu look. How Blizzard, EA and Sega make menus feel finished
- `M32_MANIFEST.md` (2026-09-25) - M32_MANIFEST: menu look / style guide (Maria, 2026-09-25)
- `K78_S79_WORDS.md` (2026-09-25) - K78 - S79 WORDS: TUTORIAL, CAMP GATE, HOME, RAIL, FIGHT HUD
- `K77_HANDBOOK_WORDS.md` (2026-09-25) - K77 - THE WORDS: HANDBOOK LINES AND COACH LINES IN ONE HOUSE VOICE
- `J54_MENU_ARCHITECTURE_SURVEY.md` (2026-09-25) - J54: HOW SPORTS-MANAGEMENT AND FIGHT GAMES ORGANISE THEIR MENUS
- `J53_HANDBOOK_REAL_TERMS.md` (2026-09-25) - J53: Gym Handbook real-world terms, checked against the rulebooks
- `J52_TOOLTIPS_AND_TUTORIAL.md` (2026-09-25) - J52: HOW MANAGEMENT GAMES EXPLAIN THEMSELVES
- `J49_MECHANICS_MEET_PRESENTATION.md` (2026-09-25) - J49 - HOW THE INDUSTRY JOINS MECHANICS, ANIMATION AND UI
- `G106_HUB_DISPLAY_EVAL.md` (2026-09-25) - G106_HUB_DISPLAY_EVAL
- `G104_OPERATOR_REFERENCE_MENUS.md` (2026-09-25) - G104 — Operator reference menus (research only)
- `G103_MENU_BENCHMARK_TEARDOWN.md` (2026-09-25) - G103 — Tear down the menus the operator named
- `G101_SKILL_BAND_WORDS.md` (2026-09-25) - G101 — What coaches and scouts say for a fighter's level
- `D24_HUB_DISPLAY_EVAL.md` (2026-09-25) - D24_HUB_DISPLAY_EVAL
- `U168_DIGEST.md` (2026-09-24) - U168 digest — profile and result leftovers (Cursor, 2026-09-24)
- `U167_DIGEST.md` (2026-09-24) - U167 digest — the schedule tells the truth (Cursor, 2026-09-24)
- `M29_LEAVE_AND_CONTINUE.md` (2026-09-24) - M29 — LEAVE AND CONTINUE
- `FLOW_PASS3_HUB_AND_HUD_WORDS.md` (2026-09-24) - FLOW_PASS3_HUB_AND_HUD_WORDS — PASS 3
- `U128_DIGEST.md` (2026-09-22) - U128 digest — region panel in UIKit
- `U127_DIGEST.md` (2026-09-22) - U127 digest — stat row + ProfileRevamp literals
- `U126_SCREEN_CENSUS.md` (2026-09-22) - U126 screen census (generated)
- `U126_DIGEST.md` (2026-09-22) - U126 digest (Cursor)
- `M30_GYM_FLOOR_LAYOUT.md` (2026-09-22) - M30 — THE GYM FLOOR, COMPOSED
- `M28_VFX_AND_PRESENTATION.md` (2026-09-22) - M28_VFX_AND_PRESENTATION.md — PASS 1
- `M28_HOLLYWOOD_ANIMAL_REFERENCE.md` (2026-09-22) - M28_HOLLYWOOD_ANIMAL_REFERENCE.md — PASS 2 (on top of PASS 1)
- `M28_GYM_FLOOR_BOARDS.md` (2026-09-22) - M28_GYM_FLOOR_BOARDS.md — PASS 3
- `M22_VISUAL_LANGUAGE.md` (2026-09-22) - M22 - THE VISUAL LANGUAGE, AS NAMED TOKENS
- `K75_PHASE_FIRST_SKILL_TREE_WORDS.md` (2026-09-22) - K75_PHASE_FIRST_SKILL_TREE_WORDS.md
- `G66_POST_FIGHT_SURFACE.md` (2026-09-22) - G66 — THE POST-FIGHT SURFACE, AT G64 DENSITY
- `G63_MENU_RULES.md` (2026-09-22) - G63 — COMPETITOR MENUS, TORN DOWN INTO BUILDABLE RULES
- `FLOW_PASS4_CUTOVER.md` (2026-09-22) - FLOW_PASS4_CUTOVER — PASS 4
- `FLOW_PASS2_ROUTE_WORDS.md` (2026-09-22) - FLOW_PASS2_ROUTE_WORDS — PASS 2
- `FLOW_PASS1_SCREEN_MAP.md` (2026-09-22) - FLOW_PASS1_SCREEN_MAP — PASS 1
- `C162_DIGEST.md` (2026-09-22) - C162 — CORNER UI
- `C145_THE_NAVIGATION_GRAPH.md` (2026-09-21) - C145 — The navigation graph
- `K42_ROKOKO_BLENDER_RETARGET.md` (2026-09-14) - K42 — KALLI — ROKOKO STUDIO LIVE FOR BLENDER: CAN WE RETARGET WITH IT, HEADLESS, ON BLENDER 5.2?
- `U78_THE_ROOM_TAKES_A_REAL_FIGHT.md` (2026-09-13) - U78 — The room takes a real fight (census for S4)
- `J28_HOW_FIGHT_MOVES_FLOW.md` (2026-09-13) - J28 — How Fight Moves Flow
- `Q53_TYPE_SCALE.md` (2026-09-12) - Q53 — The Numbers Behind the Type
- `U57_GRAPPLE_PROMOTION.md` (2026-09-11) - U57 — What the Ground Fight Is Worth on Screen
- `C90_COLOUR_ESCAPES.md` (2026-09-11) - C90 — Colour escapes census
- `C89_SURFACE_CENSUS.md` (2026-09-11) - C89 surface census
- `U36_DIGEST.md` (2026-09-10) - U36 DIGEST — FightNightScreen switches engines
- `U31_DIGEST.md` (2026-09-10) - U31 DIGEST — THE SEAT CHIP
- `Q25_GROUND_READ_AUDIT.md` (2026-09-10) - Q25 — THE GROUND FIGHT READ, AUDITED AGAINST WHAT WE ACTUALLY BUILT
- `M13_THE_FIGHT_SCREEN.md` (2026-09-10) - M13 — THE FIGHT SCREEN THAT MUST NOT PICK A PUNCH
- `C69_DIGEST.md` (2026-09-10) - C69 — THE GRADE ON THE SCREEN
- `U24_DIGEST.md` (2026-09-09) - U24 digest — the scorecard screen
- `U9_DIGEST.md` (2026-09-08) - U9 DIGEST — THE INJURY ON THE SCREEN
- `U10_DIGEST.md` (2026-09-08) - U10 DIGEST — THE BODY GETS ITS OWN COLUMN
- `C44_DIGEST.md` (2026-09-08) - C44 digest — one voice for the seven attributes
- `C41_UIKIT_DEAD_FACTORY_AUDIT.md` (2026-09-08) - C41 — UIKit dead-factory audit
- `U6_DIGEST.md` (2026-09-07) - U6 DIGEST — THE CARD THAT CAN BE READ BACK
- `R57_DIGEST.md` (2026-09-07) - R57 DIGEST — THE BODY GETS ITS SCREEN
- `R50_DIGEST.md` (2026-09-07) - R50 DIGEST — THE PROMOTION: C24's organization read gets a screen
- `R46_DIGEST.md` (2026-09-07) - R46 — THE DESK, THE MONEY (digest)
- `R45_DIGEST.md` (2026-09-07) - R45 — THE POST-FIGHT SCREEN (digest)
- `M10_THE_BOOKS_THE_SCREEN.md` (2026-09-07) - M10 — THE BOOKS, THE SCREEN
- `K25_AFTER_THE_LAST_FIGHT.md` (2026-09-07) - K25 — AFTER THE LAST FIGHT, AND THE HONEST NUMBER (Kalli)
- `K24_THE_YEAR_TURN.md` (2026-09-07) - 1. Birthday
- `C35_DIGEST.md` (2026-09-07) - C35 DIGEST — THE CORNER GETS A SCREEN
- `R37_DIGEST.md` (2026-09-06) - R37 THE RANGE RAIL — digest
- `R34_DIGEST.md` (2026-09-06) - R34 — THE FIGHT CAMP (Claude, 2026-09-06)
- `R33_DIGEST.md` (2026-09-06) - R33 — THE BOOKING (digest)
- `M4_POST_FIGHT_READ.md` (2026-09-06) - M4 — THE POST-FIGHT READ, THE VISUAL LANGUAGE
- `M3_RANGE_RAIL_PASS2.md` (2026-09-06) - M3 — THE RANGE RAIL, PASS TWO
- `M2_CAGE_DESK_MANIFEST.md` (2026-09-06) - M2 — Cage Desk asset replace manifest
- `M1_RANGE_VISUAL.md` (2026-09-06) - M1 — THE RANGE, THE VISUAL LANGUAGE
- `K21_DIGEST.md` (2026-09-06) - K21 DIGEST — THE FIGHT CAMP, HOW IT READS (Kalli)
- `K20_DIGEST.md` (2026-09-06) - K20 DIGEST — THE BOOKING, HOW IT READS (Kalli)
- `K18_DIGEST.md` (2026-09-06) - K18 DIGEST — THE DAY (Kalli)
- `J1_ORGANIZATION_RULES_AND_JUDGES.md` (2026-09-06) - J1 — Organization Rules and Judges
- `AAA_PROFILE_ART_BRIEF.md` (2026-09-06) - AAA Profile Art Brief — Cage Desk
- `R30_DIGEST.md` (2026-09-05) - R30 DIGEST — THE RANKINGS HUB (Claude)
- `R29_DIGEST.md` (2026-09-05) - R29 DIGEST — THE BOOT
- `R25_DIGEST.md` (2026-09-05) - R25 DIGEST — THE SCOUTING HUB (Claude)
- `R24_DIGEST.md` (2026-09-05) - R24 DIGEST — THE SCHEDULE HUB (Claude)
- `R23_DIGEST.md` (2026-09-05) - R23 Digest — THE FIGHTER CARD (Claude, 2026-09-05)
- `R22_DIGEST.md` (2026-09-05) - R22 DIGEST — the TRAINING hub (Claude)
- `R21_DIGEST.md` (2026-09-05) - R21 DIGEST — the GYM hub, the first replacement panel
- `K9_DIGEST.md` (2026-09-05) - K9 DIGEST — TRAINING hub study (Kalli)
- `K8_DIGEST.md` (2026-09-05) - K8 DIGEST — GYM hub study (Kalli)
- `K17_DIGEST.md` (2026-09-05) - K17 DIGEST — THE PHONE / RELATIONSHIPS (Kalli)
- `K13_DIGEST.md` (2026-09-05) - K13 DIGEST — CAREER CREATION study (Kalli)
- `K12_DIGEST.md` (2026-09-05) - K12 DIGEST — OFFICE + STAFF hub study (Kalli)
- `K11_DIGEST.md` (2026-09-05) - K11 DIGEST — SCOUTING hub study (Kalli)
- `K10_DIGEST.md` (2026-09-05) - K10 DIGEST — SCHEDULE & EVENTS hub study (Kalli)
- `C9_DIGEST.md` (2026-09-05) - C9 — Office + Staff read API
- `C8_DIGEST.md` (2026-09-05) - C8 Digest — SCOUTING read API + shortlist
- `C7_DIGEST.md` (2026-09-05) - C7 Digest — SCHEDULE & EVENTS read API
- `C6_DIGEST.md` (2026-09-05) - C6 Digest — FIGHTER CARD read API
- `C5_DIGEST.md` (2026-09-05) - C5 Digest — TRAINING hub read API
- `C4_DIGEST.md` (2026-09-05) - C4 — Gym hub read API
- `C15_DIGEST.md` (2026-09-05) - C15 — Ring Read API
- `C14_DIGEST.md` (2026-09-05) - C14 DIGEST — THE CREATION READ API
- `C13_DIGEST.md` (2026-09-05) - C13 — Rankings read API
- `C11_DIGEST.md` (2026-09-05) - C11 — Set-piece read API
- `PROFILE_STATS_BY_TAB.md` (2026-09-04) - Fighter Profile — stats by tab & subtab
- `PROFILE_IA_THREE_VERSIONS.md` (2026-09-04) - FightCamp Profile — three AAA information architectures
- `PROFILE_DESIGN_BRIEF.md` (2026-09-04) - Fighter Profile Design Brief (data-bound)
- `G7_DIGEST.md` (2026-09-04) - G7 — fight log read API
- `C2_DIGEST.md` (2026-09-04) - C2 Digest — event broadcast read API

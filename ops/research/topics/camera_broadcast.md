# Fight camera, broadcast layer, HUD, hype, walkout, arena, crowd

**Canonical page.** Read this before assigning or building anything on this topic. New findings UPDATE the sections
below (with the study that settled them); they do not become an orphan file. Last hand update: S114, 2026-09-27.

## Settled
- **Every fight is watched in the 3D arena; the flat 2D fight picture is deleted and a test fails if it returns** (operator
  S74 ruling, roadmap). The owned Marpa MMA arena is fitted and lit - `C205_DIGEST.md`, `C206_DIGEST.md`; the UFC cage is 30 ft
  (9.14 m), not the 6 m gym cage - `U155_DIGEST.md`; the gym ring for spars - `U182_DIGEST.md`; venue shot lists - `G74_THE_VENUES.md`.
- **The camera:** broadcast cuts between a standing camera and a pre-placed ground camera - `Q55_THE_GROUND_CAMERA.md`; most
  punches are not drawn, the camera shows closed moments - `G43_THE_FIGHT_CAMERA.md`; camera craft (no published framing
  numbers) - `J51_FIGHT_CAMERA_CRAFT.md`; the third camera for the clinch - `G83_CLINCH_DISTANCE_AND_THIRD_CAMERA.md`; hit cam +
  slow-mo - `Q149_DIGEST.md`; the 3D frame and knockdown frame - `M14_THE_3D_FRAME.md`, `M15_THE_KNOCKDOWN_FRAME.md`.
- **The broadcast layer spec** - `G97_BROADCAST_LAYER.md`; what the broadcast refuses - `U48_WHAT_THE_BROADCAST_REFUSES.md`;
  the fight-night HUD at FM density - `G64_FIGHT_NIGHT_HUD.md`; the fight screen must not pick a punch - `M13_THE_FIGHT_SCREEN.md`.
- **Hype and the walkout:** what makes a fight feel big - `G89_FIGHT_HYPE.md`, `G102_FIGHT_HYPE_SEQUENCES.md`; small-hall club
  shows (600-1,250 around the ring) - `G105_CLUB_SHOW_WALKOUT.md`; the live walkout in the owned arena (5-s shot) - `C207_DIGEST.md`;
  gate fill floor 0.60 sourced (UFC 116 61.7%, UFC 222 60.2%) - `G94_GATE_AND_ATTENDANCE.md`.
- **The crowd:** MultiMesh, one draw for thousands, motion in the vertex shader - `G107_CROWD_SOURCES.md`; the walkout crowd
  stays OFF until the hall is filled (operator: crowd-and-drill downloads outstanding).
- The engine runs headless; the result is the same whatever watches - `S74_READINESS_AUDIT.md`.

## Open
- Crowd assets (operator download) and the walkout crowd; the pair camera `camera_keep_pair` defaults OFF.

## Engine
`FightWorldLiveScreen.gd`, `MarpaArena.gd`, `VenueRig.gd`, `FightNightIntro.gd`, `FightHudPanel.gd`, `BroadcastRead.gd`.

<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->

## Studies on this topic (60, newest first, generated)

- `U182_DIGEST.md` (2026-09-26) - U182 digest — spar in the gym ring
- `G107_CROWD_SOURCES.md` (2026-09-26) - G107_CROWD_SOURCES
- `G105_CLUB_SHOW_WALKOUT.md` (2026-09-26) - G105_CLUB_SHOW_WALKOUT
- `C208_HUB_DISPLAY_EVAL.md` (2026-09-26) - C208 — Live gym rooms, bounded by truthful activity
- `S81_FIGHT_BUSINESS_SURVEY.md` (2026-09-25) - S81 - COMPETITOR SURVEY: THE FIGHT BUSINESS: BOXING MANAGER (Steam app 5249680)
- `S74_READINESS_AUDIT.md` (2026-09-25) - S74 readiness audit - FightCamp against J49's gate table (Claude, 2026-09-25)
- `M34_PITCH_PRESENTATION.md` (2026-09-25) - M34 — The pitch look: main menu, hub and fight-night hype
- `K78_S79_WORDS.md` (2026-09-25) - K78 - S79 WORDS: TUTORIAL, CAMP GATE, HOME, RAIL, FIGHT HUD
- `J51_FIGHT_CAMERA_CRAFT.md` (2026-09-25) - J51: Fight camera craft. How broadcast crews shoot a fight, and what FightCamp's watched-fight camera should d
- `J49_MECHANICS_MEET_PRESENTATION.md` (2026-09-25) - J49 - HOW THE INDUSTRY JOINS MECHANICS, ANIMATION AND UI
- `G97_BROADCAST_LAYER.md` (2026-09-25) - G97 - How a fight broadcast tells the story (Grok, Expert, collected S75 2026-09-25)
- `G97_BRIEF.md` (2026-09-25) - 
- `G94_GATE_AND_ATTENDANCE.md` (2026-09-25) - G94 - gate and attendance vs hype (Grok Expert, verbatim)
- `G94_BRIEF.md` (2026-09-25) - G94 - WHAT A CARD'S GATE AND ATTENDANCE ACTUALLY DO WITH HYPE (Grok research brief)
- `G102_FIGHT_HYPE_SEQUENCES.md` (2026-09-25) - G102 — How fight games and broadcasts build hype before the bell
- `C207_DIGEST.md` (2026-09-25) - C207 — Live walkout in the owned arena
- `C206_DIGEST.md` (2026-09-25) - C206 — Marpa arena fit and hall exposure
- `C205_DIGEST.md` (2026-09-25) - C205 - Marpa MMA Arena
- `U155_DIGEST.md` (2026-09-24) - U155 digest — arena scale and bounds
- `U14x_DIGEST.md` (2026-09-24) - ARENA_ART — Paper Hall pass 2
- `OPERATOR_WATCH_TAKE1_VERDICT.md` (2026-09-24) - The operator's verdict on watch-loop take one (2026-09-24, verbatim)
- `G89_FIGHT_HYPE.md` (2026-09-24) - G89 - FIGHT HYPE
- `G89_BRIEF.md` (2026-09-24) - G89 - FIGHT HYPE: what makes a fight feel big, and what can be measured (Research, no code) - FightCamp, 2026-
- `G88_THE_CROWDED_FLOOR.md` (2026-09-24) - G88 - THE CROWDED FLOOR
- `G88_BRIEF.md` (2026-09-24) - G88 - THE CROWDED FLOOR: how many members does a combat gym's floor carry at once? (Research, no code) - Fight
- `G83_CLINCH_DISTANCE_AND_THIRD_CAMERA.md` (2026-09-24) - G83 - the clinch floor per seat, and the third camera (Grok) - FULL, collected S62 2026-09-24
- `FLOW_PASS3_HUB_AND_HUD_WORDS.md` (2026-09-24) - FLOW_PASS3_HUB_AND_HUD_WORDS — PASS 3
- `U144_DIGEST.md` (2026-09-23) - U144 — Iron Parish pass 3 (ARENA_ART)
- `Q149_DIGEST.md` (2026-09-23) - Q149 Digest - Hit Cam + Slow-Mo
- `Q143_CONTROL_RESOLUTION.md` (2026-09-23) - Q143 — CONTROL RESOLUTION CENSUS
- `G74_THE_VENUES.md` (2026-09-23) - G74 - THE VENUES (Grok, Expert mode) - RAW CAPTURE OF THE CHAT ANSWER
- `C176_DIGEST.md` (2026-09-23) - C176 digest
- `U133_DIGEST.md` (2026-09-22) - U133 — Arena art pass 5 (cursor)
- `U132_DIGEST.md` (2026-09-22) - U132 — Arena art pass 4 (cursor)
- `Q136_DIGEST.md` (2026-09-22) - Q136 DIGEST — SOUND PASS 3
- `Q135_DIGEST.md` (2026-09-22) - Q135 DIGEST — SOUND PASS 2
- `G64_FIGHT_NIGHT_HUD.md` (2026-09-22) - G64 — THE FIGHT-NIGHT HUD AT FM MATCH-DAY DENSITY
- `U112_VIDEO_MOTION.md` (2026-09-21) - U112 — paired 3D joint streams from broadcast footage
- `U109_FOOTAGE_BETWEEN_RATES.md` (2026-09-21) - U109 - what fighters do between punches, measured
- `Q108_FOOTAGE_BATCH3.md` (2026-09-14) - Q108 - footage batch 3 folded into the two-man table
- `K57_WATCH_LIST_3.md` (2026-09-14) - K57 — Watch list 3: punches landing in super slow motion (the hit and the reaction)
- `TELEVISED_MMA_GAP_ASSESSMENT.md` (2026-09-12) - Televised MMA — blunt gap assessment
- `U48_WHAT_THE_BROADCAST_REFUSES.md` (2026-09-11) - U48 / U49 — What the Broadcast Refuses
- `Q55_THE_GROUND_CAMERA.md` (2026-09-11) - Q55 — THE GROUND CAMERA
- `U33_DIGEST.md` (2026-09-10) - U33 Digest — PostFightRead learns the grapple
- `U32_DIGEST.md` (2026-09-10) - U32 Digest — BroadcastRead learns the grapple
- `U25_DIGEST.md` (2026-09-10) - U25 digest — the live fight read
- `M16_READ_AT_DISTANCE.md` (2026-09-10) - M16 — READ AT DISTANCE (punch TYPE legibility at M14 HOME)
- `M15_THE_KNOCKDOWN_FRAME.md` (2026-09-10) - M15 — THE KNOCKDOWN FRAME
- `M14_THE_3D_FRAME.md` (2026-09-10) - M14 — THE 3D FRAME (REAL CAMERA IN A REAL RING)
- `G45_SEVEN_PERCENT_OF_A_FIGHT.md` (2026-09-10) - G45 — SEVEN PERCENT OF A FIGHT
- `G43_THE_FIGHT_CAMERA.md` (2026-09-10) - G43 — THE CAMERA, WHEN MOST PUNCHES ARE NOT DRAWN
- `G38_THE_GROUND_FIGHT_READ.md` (2026-09-10) - G38 — THE GROUND FIGHT READ
- `U21_DIGEST.md` (2026-09-09) - U21 Digest — BroadcastRead stops assuming fourteen seconds
- `U19_DIGEST.md` (2026-09-09) - U19 Digest — the broadcast read
- `R85R_UNDISPUTED_HUD.md` (2026-09-09) - R85R — UNDISPUTED, THE LIVE HUD (first-hand, 2026-09-09)
- `RING_NIGHT_SPRITE_SHOT_LIST.md` (2026-09-08) - Ring Night fighter sprites — shot list
- `C17_FIGHT_SCENE.md` (2026-09-06) - C17 — Live Fight Scene: architecture deep-dive
- `R20_DIGEST.md` (2026-09-05) - R20 DIGEST — the spine: router, career root, fight night
- `C2_DIGEST.md` (2026-09-04) - C2 Digest — event broadcast read API

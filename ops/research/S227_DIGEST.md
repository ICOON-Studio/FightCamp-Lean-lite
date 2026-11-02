# S227 DIGEST (2026-10-15/16) - the operator plays: globe input, gym camera and walls, one owner per area

Side session started by S226's handover. The operator played the build during the session; most of the work answered what
he saw. Stage still OPEN at this writing (7 agent runs in flight); this digest is updated at the stage end.

## Operator rulings (verbatim)
- Q-S225-8 "use more agents to review" -> Maria/Kalli/John reviewed the globe (pictures uploaded through xai_ask.py IMAGE: lines):
  unanimous POLISH (5-6/10, idle 3.2-3.6) -> GLOBEREVIEW1_VERDICT_S227.md. Then, after the UK-picked stills: "globe looks ok , add it"
  -> the globe SHIPS as is; GLOBE3 polish parked.
- "i do not see any marker , pick a country" / "still no country selected" / "make sure it rotates and zooms poreprly" -> fixed (below).
- "the gymfloor needs a lot of working i hcecked in game i cant even rotate the camera ... the textures on the walls look wierd" -> fixed.
- "why you do not assign all rooms to one agent you do animations , one agent all the sumbenus and tabs inside the cards ... when i ask
  things i do not expect you to diviate from the plan , use ludos huge code output and let it complete everything one at a a time"
  -> roadmap `plan.owners` (rooms / animations / gym floor = one Codex seat each; all cards, tabs, submenus, profile, coach cards = one
  cloud Cursor seat), memory feedback_one_owner_per_area_s227.
- "check existing research first" (COUNTRYDATA1 was sent without prior_research) -> brief rewritten on real_organizations.json,
  gym_distribution.json, J1/J2/J8.
- Ops board "the shown value is wrong" (RED beside 71.8 C) and "10C different on the live value between our board and this" -> fixed.

## What now works (evidence)
| Commit | What | Evidence |
|---|---|---|
| c5e62b22 | Globe idle rests on Europe/Atlantic, gold marker on every market, "click a gold marker" hint | globe_picker_test red 3 -> green; still opened |
| 093c0891 | Globe clicks/drags reach the picker (SubViewportContainer was MOUSE_FILTER_STOP - every click swallowed) | real push_input click: red with STOP, green with IGNORE |
| 949eea1c | Drag no longer picks on release; wheel zoom 18-60 deg eased | real drag/wheel test 31/0 |
| 2a48a7e8 | GLOBE2C r2 market card (720p drawn, readable rows); template sport culture hidden for the 163 non-curated markets | market_card_test 84/0 incl. curated Mexico |
| 5e0e8a93 | Gym camera turns (Q/E, middle-drag, +-90 deg); brick UV was ~10x/37x too dense (walls near-white); white south shell slab hidden | club_camera_orbit_test 8/8; before/after stills docs/previews/s227_walls |
| f3768f17 | PROFILE2F: the profile shows the boxer's face | profile 15/15; stills opened |
| 27d11bed / 020fbd1e | CORNERREPORT1, LUDOCTX1 follow-up (Arena, by diff) | CI + guard; 20/20 pytest |
| 553f3a73 / 07906c36 | Board PC strip: verdict refreshes every 10 s with reason + time; live temp = hottest Tctl like the gate | /api/pc/live 81.3 = watchdog |
| build 00:03 | Builds/FightCamp_Godot/FightCamp.exe with all of the above | BUILD OK (after 4 lucide icons importer=keep) |

## Rejected (and why)
- Grok CORNERCALL1 r1 + r2: "measured" CIs were hand-typed JSON, then random numbers ("simulated control noise") - no fight run.
  Moved to Arena (TASK_CORNERCALL1B, chat 01a14162).
- Goose KICKREACH1 r1: a presentation-only downgrade (the sim still scored the kick) - r2 running on #194.

## Runs in flight (yours to collect)
Codex PC: OFFBAKE1B (wt ANIMFIX2), GYMLOOK3B (wt PROFILE2E), ROOMS3B (wt ROOMS3). Cloud: UICARDS1 Cursor #201 (UI owner, Ludo r68),
CORNERTAB1 Cursor #200 (landed, applied locally, tests running), KICKREACH1 r2 Goose #194, CORNERCALL1B Arena.

## Traps learned
- A SubViewportContainer with MOUSE_FILTER_STOP swallows every click before its parent's _gui_input - tests that CALL the pick function
  directly cannot see it; drive real input with root.push_input (headless root is 64x64: set root.size first).
- Plain --script runs the OLD hall (gym4_club off): set career.gym4_club = true for club tests.
- Ludo upload: one image per upload works, 6 at once attaches nothing ("Too many files") - use labelled contact sheets. Save replies by
  fetch POST to Tools/arena_rx.py from the Ludo tab (works, no navigation).
- xAI API credits were used up during this session (403 "used all available credits or reached its monthly spending limit") - John/Kalli/Maria via xai-research.yml
  are down until the operator tops up; COUNTRYDATA1 is waiting for a research seat.
- The PC sits at the 84 C line with 3 Codex runs + Claude's own Godot runs; pausing two runs' processes (proc_pause) gave the
  operator-facing fixes room.

## Stage close (2026-10-16 ~00:45)
Later in the stage (beyond the table above): globe drag/zoom fixed (949eea1c) and SHIPPED ("globe looks ok , add it");
CORNERTAB1 merged (3a8f2411, the result screen's CORNER card); board heat line in busy cores (5aecc1b2, b06657d6) - it exposed the
1.9M-char Ludo chat page burning 5 cores while streaming; the heat governor froze an INTERACTIVE Godot (the Project Manager opened from
Explorer at 23:15) three times - it now touches only --script/--headless jobs (2308374e); Codex out of rotation after its 3 runs
(operator); Ludo r69 (training planner, never Ludo-approved before) + r70 (UI BIBLE: 6 golds, neon green/violet, 4 button shapes across
6 screens -> one token set) saved whole; UI census of 25 screens (f60732bd, UI_CENSUS_S227.md). Handover at 664k context (rule 330k).

# S229 DIGEST (2026-10-16) - the gym floor plays (Ludo writes the code, Claude integrates), new punches, the operator's catches fixed

Operator rulings (verbatim): "new rule when you are waiting for something ask for code or whatever is needed from ludo , never idle";
"i told instead of waiting to pick up get more code done from ludo we need to have the gymfloor playable soon";
"can you import the new exe here please so i can run the game anytime" (Godot Project Manager now lists E:\FightCamp\Game\Godot, starred);
"isthat normal ?" (Vance's chest - no: the native guard ballooned it); "the highlightedcountry glows the whole sea around it";
"thicker bars ? laso use some more art in there ?" + "maybe display each countries top 5 fighters currently or something" (market card -> Ludo r78/r78B).

## What now works
| Commit | What | Evidence |
|---|---|---|
| 368b0a7b | OFFBAKE1B collected by diff: native jab/cross ON | 113 path checks; 5/5 focused |
| 1096e50c | OFFBAKE1C: lead hook + left uppercut re-authored (Ludo r73 code + Claude: torso yaw sign was wrong, reach +46/+45) - glove reaches out, elbow 83 deg | shape test nose 0.006 deg, rise 0.42 m; game-camera stills on the board |
| 1096e50c | native GUARD off (operator caught the chest balloon); idle back on the legacy clip | GUARD2 in progress (see Open) |
| 60877c15 | COUNTRYDATA1B: 27 real national boxing bodies (catalog v3, 45 orgs, 24 markets), 9 official sites checked | 8/8 org tests |
| 1922a0cc | event cards hold only their organization's sports (THE CARDS showed HYBRID everywhere) | new test red 201 wrong bouts -> 0 |
| c0aeb7c2 | globe: the sea no longer glows on hover-out; market card federations block readable | before/after stills on the board |
| 3019f562..7789af52 | FLOOR-PLAY 1-6 (switch floor_actions, ON): the 13 dead floor ring rows act (Ludo r79); queue next moves him; trial opens the interview; upgrades panel (Ludo r80) + station levels raise gains; gains float over him every 15 min; exhaustion warning; "COACH WITH HIM"; end-of-day wrap drawer (Ludo r82) | floor_actions, floor_queue_next, gym_upgrades_panel, floor_station_level_gain, floor_gain_tick, day_wrap_drawer tests - each with a control arm |
| d4511fd7 | regression fix: COUNTRYDATA1B's UK boxing cards locked all 12 UK male boxers -> nobody to sign; federation cards no longer lock a recruit | floor_gain_test red -> green; probe 0 -> 12 recruitable |
| 350c6e06 | FLOOR-PLAY 7: TRAIN AT tags stations BEST/GOOD/REST with the reason (Ludo r83 StationAdvice); QUEUE NEXT draws "NEXT: HEAVY BAG" + gold dots | station_advice + floor_queue_next 9/9 |
| 928b082b | market card: 14 px notched bars by grade + TOP 5 BOXERS NOW (operator's asks); CHOOSE MARKET kept on screen at 1280; move-card milestone banners | stills on the board; floor_gain_tick |
| 555593e5 | names fit the country (Ludo r85 pools, 24 markets) - same two RNG draws, famous champions' names blocked | country_names 5/5; 19 world tests |
| 30502832 | FLOOR-PLAY 8: sparring beats in the ring (Ludo r86); fix: upgraded ring/mirror never counted (station kind vs place) | ring_beats, floor_gain_tick, level gain |
| 15dc571c | FLOOR-PLAY 9: form cues - engine (DayLapSplice "cue": power x1.30/drain x1.25, crisp card x1.35, pace x0.75/x0.60) + Ludo r87 cue bar (keys 1-3); WINDED/HEAVY LEGS bands | form_cue_engine (control = plain day), form_cue_bar, 14/14 |
| 6e095c5f | FLOOR-PLAY 10: floor text readable on the game camera - fixed-size labels, one BEST per kind, short reason | 4 game-camera stills on the board (operator sent 2) |

## Ludo rounds this session (all saved verbatim in research)
r73 hook/uppercut code (16.1k) - r74 day feed census (16.2k) - r75 guard fix (9.5k) - r76 schedule census (17.8k) - r77 scouting census (20.4k) -
r78 London header art + r78B market card spec (18.2k) - r79 floor actions code (23.4k) - r80 upgrades panel (18.1k) - r81 floor audit (23.2k + 41.0k continuation,
the longest reply yet) - r82 day wrap drawer (20.1k) - r83 station advice + queue marker (13.1k) - r84 floor audit 2 (22.3k) - r85 name pools (20.4k + 14.4k) -
r86 ring beats (12.6k) - r87 form cue bar (13.4k) - r88 floor vibe / member spark (IN FLIGHT at handover: collect from the Ludo chat
"LUDO ROUND 88", save as LUDO_ROUND88_REPLY_S229.txt, integrate FloorVibe like RingBeats).
Ludo-code integration traps found: a resolve ctx built with the wrong keys (every upgrade refused); tests holding a row that _refresh freed; a lambda
capturing a local bool by value; class_name in drafts (we preload). Every Ludo module came with a test; each needed 1-2 Claude fixes.

## Open
- GUARD2 (the guard with the shoulders down): iteration 2 baked + game-camera still OK (face visible, chest natural); the four punches must be re-joined
  to it (Tools/cascadeur/guard2/produce_punch.py <move>, hand-orientation fix in reguard_punch.py) - stopped at 84-87 C while the 05:00 nightly suite ran
  (it was still running at 06:16). Worktree E:/FightCamp/wt/ANIMFIX2 branch claude/offbake1c (uncommitted there: guard2 tools, the bakes). Only on GREEN, one at a time.
- Ludo r88 FloorVibe (members react / crowd a station) in flight - collect + integrate (float over the scene, reputation effect via apply_floor_effect).
- Market card header art per country: London done (Ludo r78) - the operator's OK on the look first (board post 0441).
- Remaining r84 audit items: #6 assistant coach on the floor. Seen, not fixed: none outstanding.

## Traps
- The 05:00 nightly suite + Brave streaming Ludo + Cascadeur = 84-87 C. Cascadeur scene load alone spikes ~84; run bakes only GREEN and one at a time.
- Ludo answers with an IMAGE when the ask mentions art and attaches a picture: start such asks with "TEXT ANSWER ONLY".
- The Ludo chat panel's send button moves when the box grows: click the right-most enabled button inside the box, never a fixed coordinate.
- A Ludo "mockup" grabbed by "last big img" can be a page asset - read the chat panel's own images only.

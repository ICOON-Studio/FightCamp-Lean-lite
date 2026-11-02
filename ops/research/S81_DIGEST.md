# S81 DIGEST - hub display decided, three competitors surveyed (two played), beats 1-2 in direction A, the road recorded
Claude, 2026-09-25/26 (the operator slept from ~00:40; "you can check it freely and also do the full suite run around
4am"). Look: `research/s81_look/`. Narration was spoken aloud on request (Windows OneCore voice "Mark", local only)
until the operator went to sleep.

## Shipped (all on master, all pushed)
- **Hub display DECIDED** - `S81_HUB_DISPLAY_SYNTHESIS.md`: **two layers.** HOME stays a picture that tells the truth
  (tier/occupancy variants, live pin counts, every room the player builds becomes a pin); the GYM FLOOR becomes our own
  3D engine with the player's fighters on the stations they are programmed on. B (2.5D sprites) rejected. All five
  collected memos land on that split: D24 (Dola), G106 (Grok), C208 (Codex, measured 3 fighters 5.8 ms/frame), Q179
  (Qwen, measured **0 training clips vs 18 stations**), U177 (Cursor, **0** TileMap/Sprite2D code in the repo).
- **Competitors surveyed** (operator asked for each): `S81_CAGE_LEGACY_SURVEY.md` (demo installed and PLAYED 10 weeks,
  2 fights, driven over its Electron DevTools port - text-log fight with identical sprites, 30-second rounds, inverted
  70/30 purse split, broken rankings), `S81_FIGHT_BUSINESS_SURVEY.md` (a boxing promoter sim that CLAIMS 3D fights and
  shows none; dark-and-gold look close to ours), `S81_PUNCH_CLUB_2_SURVEY.md` (82% of 4,589; played to the city map by
  screen + mouse, stopped at 93 C: its hub is one pixel room where the objects ARE the actions).
- **Operator ideas recorded** (HANDOFF S81 block): a lasting SCOUTING FILE per opponent with his weak points; a MEDIA
  HIRE who promotes fighters and builds hype; ROOM EXPANSION as separate rooms with one effect each; their facilities
  and backroom staff pages praised as readable.
- **Fight-night beats 1-2 to M34 direction A**: fight week = the announcement (split portraits on the brass diagonal,
  surnames in brass, the week + the tape on leather plates, gold step); weigh-in = the faceoff with a weight plate under
  each man and the official line. Shared pieces in `FightHypeKit.gd`. The grey FIGURE box is gone from the weigh-in too.
- **The road booking -> bell recorded at 1X** (owed since S79): `s81_look/road_booking_to_bell.mp4`, 2 m 34 s, plan
  `research/s81/road.plan` (the S76 plan no longer ran: THE DAY is gone, and the camp must be SET before Continue).
- **HOME bugs found by the recording, fixed**: NEXT FIGHT printed the title FLAG ("NEXT FIGHT · FALSE") and an empty
  org ("· in 4 weeks"); fighter cards said 0-0 where the profile and the tape said 0-1-0 (HOME counted only this gym's
  log). `scene_router_test` did not know S80's three area hubs (fails 1 -> 0).
- **Collected**: C207 (walkout shot, merged but **OFF** - empty grey hall, barefoot boxer), Q178 (footwork bands, OFF by
  default), C208, Q179, U177, D24, G106, G105 (small-hall walkout direction: "fill the first six rows").
- **D25 (Dola, fresh eyes on the two new screens) acted on**: the fight-week countdown read "DAY -6 TO BELL" (now "6 DAYS"), and the weigh-in showed a number beside "not on the scale yet" (now "walking weight today"). D23 (skill band words) turned out to be answered in S78 and never saved - collected.
- **Late collections (overnight)**: C209 (text-to-motion cannot make a targeted drill; skipping candidate), Q180/Q181/Q182 (footwork: per fighter, MMA in band but the MMA flip cut leg share 8% -> 4.9%; default held OFF everywhere; boxing/KB tuned into band, inert), G107 (crowd route: VAT MultiMesh), G108 (sourced finish-rate table: KB 7% vs Glory 33% and MMA legs 8% vs UFC 16% are engine defects). C210 never ran: Codex login rejected (401) at 01:41 - operator re-login.
- **Tools**: `grokbots.py send --attach` (browser bots can SEE images now).

## Tests (subsets; the full suite is the 04:00 run)
parse gate on every touched script 0 fails; setpiece 3/0, career_loop_walk, day_feed, scene_router, menu_clarity,
smoke, shell, gym_hub 2/0, market_on_screen, coach 3/0, fight_night, tale, fight_room_walkout, venue_art, fight_audio,
fight_footwork 3/0, fight_realtime - all green.
**Full suite, 2026-09-26 04:00 at 2fc74ea7: SUITE total=416 fails=13** (`AgentComms/nightly/latest.txt`; first run of the
nightly task). **None from S81**: header_real_date, sponsorship, weight_cut and fight_pace_anchor fail identically with
FightRealtime.gd, GameState.gd and DayFeedPanel.gd reverted to the S80 handover (dadf725c) - a control run in the main
checkout, restored after. Known reds: athlete_development, fight_pair_live (parked), fight_scoring, fight_stage_realism,
fight_body_overlap (S80), fight_metres (slow, not hung). Not touched by S81: asset_manifest (a warning line counted as a
failure), capsule_coverage_contract (a blind contract test whose CapsuleCoverage.gd was never merged),
fighter_reachability_contract (f01 'neck 0.15 has no usable approach'). The 7 non-parked, non-S80 reds are a triage
list for S82 - each is a stale test or a real defect, and nobody has decided which.

## Known, not fixed
- Camp setup, schedule, the tale of the tape and the fighter profile are still the old style (the road shows them).
- The camp page says "No camp running - a camp opens once a bout is booked" with the bout booked right above it.
- Continue's "1 must answer first" overlaps its label; the "Needs you" count badge touches the heading.
- D25's other point: with no camp possible, the fight-week 'Camp weeks 0' + empty plan area looks broken - say it in one line instead.
- The walkout needs a crowd, light and walkout kit before it is switched on (G105, G107).
- Kalli, John and Maria unreachable until ~2026-10-01 (Grok Bot weekly limit): K80, J56, M36, J55, M35 blocked.

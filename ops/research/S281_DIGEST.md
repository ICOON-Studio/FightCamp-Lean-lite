# S281 DIGEST (2026-10-21) - GYMBUILD economy wired, watcher rebuilt GitHub-direct

## Shipped on master
- MEMBERCAPCHIP1 (Cursor #321) db132ea6 - member counter "n / cap" left of cash, tooltip, full-band pulse, week alert.
- SPARPIT1 (Cursor #317) 83200517 - draw a taped sparring pit, buy the tape ring, ring_sparring IQ x pit. Tape NOT visible yet (see open).
- ROOMWORK2 (Arena #326) 8d7b4348 - office PC purse split (40% to promoter without it), treatment table (35% faster heal / $450
  hospital), shelving (same-day fix / 3 days + $220). Plus a seen defect fixed: on the empty shell a BUILD-bought piece was only a place,
  never an equipment item, so bought kit never wore, broke or cost upkeep (GameState._bought_station_equipment). 31524154: the table
  rule reaches FIGHT injuries too.
- INCOMEOFFERS1 (Arena #327) 07054396 - weekly early-income offers pure module.
- STARTECON2 (Qwen #324) 73e2a6d5 - office loans (micro / municipal / promoter advance) + gym-wide staff pay tier live in the save;
  Claude threaded the tier into the REAL wage bill (GameMoney.pay_tier_of at all 5 payroll call sites - Qwen's left them on market).
- Ludo S281 economy numbers (LUDO_S281_ECONOMY_NUMBERS.md) - operator Q-S277-3 "Yes, build the verdict." -> ECONBAL1 (Arena) running.
- BAGMOUNT2 round 1 ae86f617 - landed BY MISTAKE (staged diff swept into the stills-tool commit; tests green both arms): shop sells
  Wall-arm bag 550 / Free-standing bag 950, wall-only placement, mount saved on the bought piece. Drawing not right yet (open).
- ASGAMERED6 part: gym_menu_test asserts the one top bar 987446a2. The rest closed on audit (ASGAMERED6_AUDIT_S281.md, 8 suspects).
- Tools: agent_events.py 7ee0e443 (GitHub-direct watcher for the Monitor tool; CLAUDE.md s8 updated); gym_build_stills.gd (BUILD a
  shell gym the player's way + game-camera stills); cloud agent workflows 50 -> 100 min (19c992b0); Eyes video CLI installed (operator ask).

## Operator calls this session (verbatim)
- claude-eyes link -> "install it" (done, no whisper - our clips have no speech).
- "try ziva baby ?" -> tried: it took a task but could not write working GDScript (Lua syntax), no stills. Ziva Smart is out of weekly
  credit (resets ~2026-10-27).
- Q-S277-3 "Yes, build the verdict."
- "the watcher missed them - this happens too often, read a tutorial how to setup watchers" -> agent_events.py + Monitor (memory
  feedback_watcher_github_direct_s281).

## Open (in flight / next)
- Cursor #325 BAGMOUNT2 round 3: frame bag GOOD on the still; wall arm drawn beside the bag along the wall (must stick out above it);
  pit tape hidden under the pit mat (y 0.008 under 0.014). Stills: docs/previews/s281_gym_build_r2/02_floor_view.jpg.
- Cursor #323 HITFEEL2 round 3: hit stop does not freeze the anims (5 fails) and breaks punch_retime (a jab stub; master 0 fails).
- Goose #320 WEARSLIP1 round 2 (round 1 only added a debug print).
- Arena ECONBAL1 (arena/5195cbdb-fightcamp-lite): undercard rate, yield formulas, pay tier effects as rules; then Claude wires them
  (weekly morale drift + coaching gain mult + quits) into the career and the offers into the office.
- ASGAMERED6 audit: verdict the 8 suspects one by one on the as_game career (rows 1, 2, 4, 5 player-visible if real).
- UI still missing for loans / pay tier / income offers (a Cursor task after BAGMOUNT2).
- Old open-issue branches never collected (#281, #284, #300, #302, #303, #311) - triage.

## HANDOFF
Working commit: d353f0ec. Next action: collect whatever agent_events reports (Cursor #325/#323, Goose #320, Arena ECONBAL1), then wire
ECONBAL1 into the career, then the ASGAMERED6 audit rows 1/2/4/5.

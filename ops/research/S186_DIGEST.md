# S186 DIGEST - 2026-10-09 - HUD2 built behind `hud2` from the operator's own marks (Markup Board), TIPS3 merged, walk defects fixed

Operator working method this session: he reviewed every HUD2 still on the **Markup Board** (`Tools/markup`, KEEP/CHANGE/MOVE marks,
saved to `Feedback/2026-10-09-NN`) on his Samsung monitor; I applied each board, re-shot the game's own camera and reopened it.
Board server: `python Tools/markup/serve.py --no-browser` (port 8765); open it with
`brave.exe --app=http://127.0.0.1:8765/?q=<img1.png>,<img2.png> --window-position=0,0 --window-size=1920,1080`
(images from `previews/ui_s185/`; **N / P / arrow keys** switch pictures, marks stay per picture until Ctrl+S saves).
**Operator ruling: no Microsoft Edge pop-ups - the board opens in Brave** (Edge is a Windows component; not uninstalled).

## What now works (all behind `hud2`, OFF - `career.hud2` or user arg `hud2`; `GameState.is_hud2_on`)
Spec of record: `research/HUD2_OPERATOR_PICK_S186.md` (his picks) + the boards in `Feedback/2026-10-09-01..12`.
- **Corner clusters, no top bar** (`ShellChrome.apply_hud2`): gear, info, BACK top-left; club + date card top-centre; cash left of
  MAIL (bell) left of **CONTINUE top-right**; icon dock = a left column (hover shows the word); hall full-screen
  (`GymHallPanel`), `CareerRoot` lifts the bar above the hall. END DAY hidden - CONTINUE ends a running visit
  (`CareerRoot.on_continue`), otherwise the ordinary Continue (camp gate, week review, shell rebuilt).
- **Speed controls** (`ClubSpeedControls`, `GymClub3D.set_speed`): Pause / Play / Fast (1x/3x), Space toggles; **Fast drops to Play**
  on a goal pause, ring, station pick or a visitor at the desk (`drop_fast`).
- **Fight-week rail** (`FightWeekRail`): right-edge tab (days to the bell) opens a compact top-centre strip: today / weigh-in /
  fight night / result with real dates; opens itself once a day in fight week (`hud2_rail_day` stamp), folds after 7 s.
- **Hand of fighter cards** (`FighterHand`): bottom edge, small face + short name + stamina/strain bars, tucked and rising on
  hover, max 7 + "+N"; click opens the **profile upward**: body = Kalli's K3 anatomy figure (`assets/ui/body_detailed_front.png`,
  callouts inpainted out) with six readiness markers (`BodyDiagram`), and a **LIVE training block**: the six trainable stats with
  today's gain, the stats the current station trains highlighted with their per-hour rate, the move card's progress, following
  the day. Hall HUD insets: day goals top-left under the gear, morning card below CONTINUE/MAIL.
- Tests: `fighter_hand_test` 31/0, `hud2_pieces_test` (speed, buttons, rail rows/auto-open, dock words, Fast drop), fight-week +
  weigh-in in `setpiece_panels_test`; hall/club/shell/nav/timeline/floor_pick/result all green with the switch off.
- Walks: `research/s186_hud2_walk.plan`, `_screens.plan` (8 career screens), `_rail_walk`, `_hover_rail.plan` (hover, rail, live
  profile) and the 60-step bout walk `s184_club_bout_walk.plan` **pass with `as_game hud2` (0 failures)**. Walk tool gained
  `hover [Node]` / `hover node:Name` and `untilnode Name|STEP|MAX`. Stills: `docs/previews/ui_s185/HUD2_BUILD_*.png`.

## Also merged / fixed
- **TIPS3** (Arena PR #70) merged a9b04458: 9 panels, parse gate 9/9; 5 in-game spot checks NOT done.
- **Fight-week strip** names its cells from the real fight day (card `bell_day`), not fixed MON..SAT.
- **Two records**: the result tile is labelled **AM** for the gym's amateur book; fight week / weigh-in / live scoreboard stay on the
  world record (7-4-1). The mismatch is a design call, see open questions.
- Bugs I made and fixed in-session: stale date plate after Continue; Continue skipping the week review; the Markup Board queue.
- RULE BREAK to note: one heavy walk started while the watchdog said RED (memory 94%) - my command chain did not stop on it.

## Open questions (his call, none gate the next build step)
- Which record book should a first AMATEUR bout show (world 7-4-1 vs gym amateur 0-0-0)?
- The profile body is Kalli's K3 photo figure; the flat K2 muscle map (`body_muscle_map_front.png`) is the alternative; a real 3D
  model view would be a bigger job.
- The live "+14.7" is the engine's raw accumulated daily gain, not scaled to the 0-100 stat - judge whether it reads right.
- Marks 1/2 of board 10 and the card hover are untested with a REAL mouse (only the hover signal was fired).

## Nightly (changed since the last check)
`AgentComms/nightly/latest.txt` 10-09 @f219ad5f: 599 tests, **7 red** (was 571/5). New reds, none from this session's code:
`home_pin_counts_test` (the Office pin's Open button has no tooltip_text), `stat_vocabulary_test` (UIKit.gd:4856 stat-list literal not
the canonical STAT_KEYS - REC1/offer_opponent_words), `q226_strands_test` (technique specialist share 29.5% vs 29.9%).
Known reds still: fight_pair_live, fight_stage_realism (parked on purpose), fight_world_live, fighter_reachability_contract (KM3).

## Agents
Arena TIPS3 collected and merged. Cloud Cursor HUD2 V1/V2 (issue #67) collected (mock-ups only; the issue is still open on GitHub).
No other seat was launched this session: the work was the operator's interactive board review, one UI file set at a time.
`QWEN_API_KEY` is still dead (operator only).

## Next (roadmap `now`)
Read any new `Feedback/` boards first, apply, re-shoot (`as_game hud2`, plan `s186_hud2_hover_rail.plan`), reopen in Brave. Then ask
for his OK to turn `hud2` ON for new careers; then FLOOR-PLAY's equipment dock (the left dock carries it), the three new nightly
reds (NIGHTLY1E), GYM5-LOOK (never started).

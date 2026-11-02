# S179 DIGEST - the club's three pure pieces merged (copied out of Arena), the 2:00 day live, the 3D club handed to Codex + Cursor

Session 2026-10-08 evening, Opus 5.5. Stage: GYM4 (build the new club, operator OK'd on paper S178). Context budget (250k) set the
split: Claude collected and merged, delegated the 3D build, and hands over before the build lands.

## What now works (evidence)
1. **GYM4A/B/C merged - e5456c61.** Arena finished all three in ~20 min but could not push (403: its GitHub connection reaches only
   Guru-Meditation/vittorio-coffee since the ICOON-Studio move; this answers board Q-S178-1 = "Not yet"). The nine files (all new)
   were copied exactly out of Arena's diff view (method + `Tools/arena_rx.py` in AGENT_TOOLS.md "Arena"). On the PC, Godot 4.7.2
   headless: GYM CLUB LAYOUT PASS checks=69, THING ACTIONS PASS checks=50, WALK INS PASS checks=138; parse gate 6/0. Mutants run on
   the PC, all red: gym_club edge cut + zoom far/close swap; ThingActions occupied check dropped + HH:MM unpadded; WalkIns day not
   mixed into the seed, no day-end clamp, no sort. Files match each brief's Owned files (3 per task, nothing else).
   - `GymClubLayout.gd` + `gym_club.json`: hall + places, rooms (locker, physio, reception, office), street, walk-in waypoints,
     aisle graph, `zoom_camera(far|mid|close)`; same API as GymHallLayout.
   - `ThingActions.gd` + `thing_actions.json`: per kind (fighter, coach, station, office_window, walk_in) <= 6 rows, greyed with the
     brief's reason ("Occupied until 14:00"), never hidden; `coach_rows` ordering.
   - `WalkIns.gd` + `walk_ins.json`: pool x day curve x fame/ads, seeded per day; `inside_at`; interviews at the reception desk.
2. **The 2:00 day is live - de301c48.** `day_lap_stations.json` real_s_per_min 0.3 -> 0.2 (operator S178 "2:00 day (Kalli)").
   Tests read it from data: lap family 4/0, gym_hall family 6/0.
3. **Delegated (running at handover, IDLE priority, hidden):**
   - Codex GYM4E - `TASK_GYM4E_CLUB_3D.md`: GymClub3D.gd extends GymHall3D, builds the club from gym_club.json, zoom far/mid/close
     with the roof hidden below far and near walls dither-fading on the camera->fighter segment, walkers from WalkIns, `thing_at` +
     `thing_clicked`, new switch `gym4_club` (OFF), headless test with 8 acceptance rows + 4 mutants. wt E:/FightCamp/wt/GYM4E.
     NOTE: the first launch ran inline (no IDLE) and was stopped by PID after ~2 min; its partial GymHall3D.gd hook edit stays in
     the worktree for the relaunch (pid 77012).
   - Cursor GYM4F - `TASK_GYM4F_ACTION_RING.md`: ClubActionRing.gd, up to 6 icons on a circle, disabled rows greyed with the reason
     via UIKit.tip, keys 1-6, Esc/right-click back one level, call_coach -> coach_rows level 2; Radial Menu Control (#3469, MIT)
     tried first. wt E:/FightCamp/wt/GYM4F.

## Not done / blocked
- **J65 (John, free models) NOT collected**: `gbot thread "John Research"` -> `listAgents failed: 417 Expectation Failed` every try
  (gateway; `--files` has no local store). The Grok Bot app was not opened (it would show on the operator's screen). Next session:
  retry; if still down, pick one semi-realistic model family and generate the missing props with the generate skill (fal.ai).
- **Arena seat**: usable for new pure tasks only via the diff-view copy until the operator reconnects GitHub (board Q-S179-1,
  blocked_on_operator ARENA-GITHUB). No new Arena task this session (context budget; every GYM4 piece left is scene work).
- The nightly is unchanged since the S177 check (1bd09b94, 571/5) - nothing new red.

## Next (roadmap now, a decision)
Collect GYM4E + GYM4F (gates, mutants, neighbours, merge the diff) -> wire thing_clicked -> ClubActionRing and DayGoals on the HUD
-> J65 or generated props -> one still per zoom from the game camera (as_game, gym4_club on), opened, sent -> operator OK -> video ->
switches on + exe walk.

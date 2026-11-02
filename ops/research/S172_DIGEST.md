# S172 digest - the core loop redesigned by the operator: ONE 3D gym, the day lap (Claude, 2026-10-06)

## 1. Shipped
- **TRAIN2 merged** ab4c251e (Arena PR #53, diff applied): drag-to-plan palette; training_palette_test 29/0; training/program/week neighbours
  20/0; as_game walk with REAL mouse drags (new walker step `drag <focus>|<day>`), still `docs/previews/s172_train2/37`. Then SUPERSEDED by D38
  (operator: "it is terrible as it is now in the game it will need to change completely") - code stays until GYM3D1 replaces the page.
- **STORY5b fixed** 098da161: the story's career-start baseline was taken on an EMPTY gym, so a signed amateur's own record read as story results
  (the first bout never came; the result line stayed empty, and the first-fight card could fire on signing day). Marks are now per fighter in
  story.baseline.by_athlete. story_join_record_test 8/0 (6 red on the old tree); story_campaign_game_test 25/0; neighbours green. Seen on the game
  camera: `docs/previews/s172_story5b/56_result.png`.
- **Demo design review** `DEMO_DESIGN_REVIEW_S172.md` (part 1 vs the paper design: the camp pays nothing visible, the corner is optional and silent,
  "why" restates the score, records shown three ways, MMA leftovers in the boxing camp; part 2 vs NAV1: chrome built, substance missing).
- **MMA Manager 2 watched live** (operator played, Claude watched): `MMAM2_WATCH_S172.md` - training shown at the station, moves unlocked by
  training, one weapon vocabulary across scouting/training/stats, a 3-beat finish, readability over realism.
- **D38 + DAYLAP1_DESIGN.md**: the operator's design, verbatim, in five messages.

## 2. The design (D38)
One big 3D gym is the main screen. The day is a LAP: the clock runs; click a station; the fighter walks there, prepares (switch cost) and
trains; each station gives its own benefit and drains STAMINA; managing stamina inside the day is the loop. No fast-forward while he trains.
The coach buffs the station he stands at; the coach's pool must last the week. Rest = the pit stop (refuel, fresh legs/arms, patch up, the talk,
the tape). Moves are cards on the ring, limited by discipline and the coach's knowledge; time on a card passes a usable threshold, then unlocks
follow-up moves and combos.
Cancelled/superseded by it: TRAIN2 as the week screen, GYM-CLICK1's painted HOME, the timeline bar's fast mode during training. The other rooms (office,
locker, mat, staff, physio, film room) STAY as expansions of the gym scene - Operator S172 (verbatim): "keep other scenes as expansion of the gym scene". TRAIN1 folded into DAYLAP1; STORY4's Wall re-homed into the gym.

## 3. NOT done (said plainly)
- Arena STORY5C (chat 01a10ec3) and DAYLAP1A (new chat) still running - collect next session.
- No game-camera still of anything D38 yet. The walk-the-review fixes (part 1) are not started.
- Arena PR #43 (KM3) still open, needs a measured C223 pass.

## 4. Traps recorded
- When the operator names a reference game he means ONE mechanism (memory feedback_reference_game_is_one_mechanism): "we are not making a copy of
  motor sport".
- MMA Manager 2's web build sits in a Pley iframe behind a 403 for direct access; not worked around (access control). Nothing downloaded.
- Computer-use screenshots mask un-granted apps; the operator's "Samsung" monitor is C24F390, "SHARP LCD" is the other.
- A story baseline taken before the roster exists counts every signed fighter's past record.

## 5. Next session (cloud)
roadmap `now.detail`: collect STORY5C + DAYLAP1A; GYM3D1 layout on paper; GYM3D1 build + DayLap on the floor behind a switch; review fixes.

# S547 digest (2026-11-24, from 05:37, Fable) - the signing card merged, CONTINUE made plain, three workers launched

Code commits: 1f12a0087 (KNOWBUILD1 merged by diff), 84d135cab (CONTINUE, the two wait lines, a long hover),
6f0b24e78 (Self-belief), ece92b4e8 (Finance's club show row). Briefs: 05eab2aa7 (STAFFCARDS1), BODYREACT2.
Build: Builds/FightCamp.exe exported 05:56 (docs/WHAT_TO_TRY.txt O to S).

## The owner's words this session
- Board answer Q-327 "Which screen has the 'week preview' button you asked about?": "Top bar CONTINUE". His note had
  been "wtf is the week preview button doing and showing ?". The button read "CONTINUE / to Mon 12 Jan, week review".
  -> `Needs.go_state`: the second line is "days run to <date>"; `TopCards.go`: the hover says "The days run until
  something needs you." and "Stops <date>: the week's results." (the reason for the stop lives on the hover only).
- Open, asked again in the first message: Q-328 (shrink the plan screen), Q-329 (cut the coach trial week).
  New: Q-330 "Corner ring calls (Cut the ring off, Stay off the ropes) add 0 wins in two probes. Cut them?".

## Collected
- KNOWBUILD1 (Opus tab of S545, branch build/knowbuild1, 44 files, +2,065): applied to main with `git apply --3way`
  (no merge state, so a worker's pathspec commit in the same checkout keeps working). Four overlaps with S546's word
  changes: RosterActs, Fighters, Trial took the build's side; run_tests.sh got both new tests. Two "club stipend" lines
  in the new text -> gym. Its four stills checked against the method lines (a scene, cards, no pop-up, the profile's top
  card says what changed, bounds 0) and re-made on main: docs/playtest/s547, on /review. The stray grey bar on the
  worker's own still was the guide clipboard's clip over the pop-up: already fixed by S546's layer change (checked with
  the guide on). Tests green on main: knowbuild1_walk, know_reads, golden_path, roster_cards, save_load, test_jump,
  playtest_s375, two_boxers_two_years, plain_words, file_limits, palette_guard, no_pronoun, first_week,
  tooltip_standard (one hover of the build was over the 14-word line limit: cut).
- BODYCROSS3 (Fable tab of S546, c39580b37 on main): its sheet and touch pictures opened - the elbow is bent on every
  picture from the touch (129 deg as the side camera sees it), the hit boxer is folded 12 to 18 deg on pictures 10 to
  12. For his eye on /review. NOT in the 3D fight: the v2 player never draws the fold take -> BODYREACT2.
- CORNERCMD2 (Opus tab of S545, c3d0f866e): FAIL again on bars 5, 6, 8, the stop rule applies. The core is stronger:
  reading the moment +14.6 (3 rounds) and +22.2 (6 rounds) wins in 100 over PLAN ONLY (138,600 bouts). My reading of
  the three failures, from its tables and the code lines: bar 6 (the ring calls) is a real fail - held, Cut the ring off
  loses in every cell; as moment answers both add 0 -> Q-330, my pick is to cut both from the corner. Bar 8 (a command
  held all bout beats PLAN ONLY by over 10) is the BASELINE's hole: `BoutRules.auto_corner(stats)` picks "long" or
  "body" from our boxer's stats alone, never reads the opponent, never rests a boxer at 0 wind - so the corner's +15 to
  +22 is measured against a coach's call that is blind. Bar 5 (the boxers disagree on 4+ commands) is the probe's
  population: three boxers from the same week-4 training grade alike (15 of 24 grades OK).
  NEXT: CORNERBASE1 - the same probe against a coach's call that reads the opponent's game and rests a tired boxer;
  that number is the honest worth of the live corner, and the auto call is also what a player who sims gets.
- Arena CARDROUND9: the chat hit its daily usage limit. Its branch is pushed (lite mirror
  ICOON-Studio/FightCamp-Lean-lite, arena/f591a0d9-fightcamp-lean-lite at e0e15a796; fetched here as
  refs/remotes/lite/arena-r9). Checked in a scratch folder: 61 of 61 tests green, engine 484 lines, play gate 4 of 6
  (boxing 77.5 v jiu-jitsu 22.5, bar 40-60; 21.0 decisions a bout, bar 22.5-45). Not merged: the gate fails.
- The 05:00 full tests (commit 7d9057efe): 499 pass, 4 reds, all old - move_tip_test (the partner's answer to the
  jab), matchmaking_bots_test (known), block_meet_test (old player's ruler), face_frame_test (one opponent's picture,
  mh_boxer_13, cut 1 px at the chin in the offer page's slot). The day before: 29 reds. None new, none with "club".

## Fixed on the way
- Two lines told him to wait for offers (S546 rule): Home's corner "No fight booked. Offers come in on Fights." and
  the Free chip -> "Ask for a bout on Fights."
- Two confidences on one profile: the MIND attribute is now "Self-belief" (`AttrBoard.NAME`); Confidence is the bar.
- Finance's club show row ended in "..." in the office window: `ClubShow.read` gives a `row` (the named hall only;
  each button's hover has its hall); "Your club would leave ..." -> "Your gym ...".

## Launched (console tabs of this session, `claude_cm.ps1`)
- PLANREAD2 (Opus, tab c1, 05:50, 3-4 h): the card's plan term over-reads the bout; fix the read to the bout.
- STAFFCARDS1 (Opus, tab c2, 05:52, 3-4 h, worktree E:\FightCamp\wt\STAFFCARDS1, branch build/staffcards1): the Staff
  window as cards from docs/mockups/s546/staff_cards.png. Decided: the dock's Staff icon opens the cards; the sortable
  sheet stays under the office's Fighters and staff sheets.
- BODYREACT2 (Fable, tab c3, 06:02, 2-3 h, main checkout): the v2 player picks a body reaction by when the fold
  arrives, not by head travel; red ruler first, a control arm on head reactions, films for his eye.
  (TASK_BODYREACT1.md is an old S370 Ziva brief of the same subject on the old player: left as it is.)

## Tool notes
- `git apply --3way <patch of main...branch>` merges a worker branch by diff without a MERGE_HEAD.
- A `cd` inside a Bash call moves the session folder (it happened three times): `(cd ops && ...)` only.
- The start page's FULL TESTS line is the day before's until about 05:50: the 05:00 run starts at 05:15 and takes 30
  minutes; touch no game file while `sh tools/run_tests.sh` of nightly_tests.ps1 is alive.
- Arena's branch lives on FightCamp-Lean-lite (not FightCamp-lite): `gh api repos/ICOON-Studio/FightCamp-Lean-lite/branches/<b>`.

# S188 DIGEST - 2026-10-09 - club training reaches the stats; Codex launcher fixed; SPLIT1 + GATES1 merged

## What now works (evidence)
| Commit | What |
|---|---|
| 7f54af93 | `Tools/codex_task.cmd`: Codex CLI 0.162.0's Windows sandbox setup re-ACLs every runtime under `%LOCALAPPDATA%\OpenAI\Codex\runtimes`; the operator's open Codex DESKTOP app locks `node_repl.exe` there (os error 32) -> `helper_unknown_error: setup refresh had errors`, NO shell command runs. S187's SPLIT1+GATES1 died in 20 s with zero edits. Fix: the CLI gets an empty `LOCALAPPDATA=E:\FightCamp\codex_localappdata`. Probe: git status ran; both relaunched and delivered. |
| b8ec186c | FLOORGAIN1: `GameState.file_visit` applies the lived day through `TrainingPreview.lived_gain` = raw x `LIVED_GAIN_SCALE` 0.0066 x the program's coach factor x headroom (DayLap keys renamed hand_speed->speed, defence->defense, ring_iq->fight_iq; cap potential+10). Census: seven 600-minute days per station vs a full program week (0.60): achieved 0.43-0.75, median-calibrated. `floor_gain_test` RED on the shipped tree (5 FAIL), GREEN on the fix (control: a skipped morning moves nothing; heavy-bag week +0.71 power). |
| b8ec186c | Operator Q-S186-1 "Amateur 0-0-0 (the career just started)": a non-pro recruit in the game's start opens the gym's amateur book at 0-0-0; `UIKit.shown_record/record_text` read it -> "0-0-0 AM"; world fighters keep their own record. f5bdb95f: the FighterHand profile header used the raw record (7-4-1 on the game camera s188_floorgain/41) - now `UIKit.record_text`. |
| b8ec186c | Operator Q-S186-3 "Show it as a bar / arrow, no number": training block "PADS · Technique ↑ · Speed ↑", stat row "56 ↑" + the cyan bar; club hover "TREADMILL CONDITIONING ↑". Seen on the game camera s188_floorgain/41. |
| b8ec186c | DEFECT FIXED: NIGHTLY1E's `UIKit.offer_opponent_words` named the GameState autoload -> every test that preloads UIKit compiled GameState before the autoloads ("Identifier not found: CompetitionData"; week_review_test HUNG, shown_record/one_record printed SCRIPT ERRORs). Now `AthleteStatModel.STAT_ORDER`. |
| e3cbe9de | GATES1 merged (Codex): `check_workflow.py branch` = parse gate + auto-picked tests (cap 25) + test guard + LOOSENED? alarm + one-screen verdict. |
| 7ad54cd5 | SPLIT1 merged (Codex): money/billing -> `scripts/state/GameMoney.gd` behind unchanged delegates (GameState -119 net); `game_money_split_test` pins 5 weeks of cash; the new gate said MERGEABLE (10 tests). |

## Found, not fixed (queued)
- **FLOORGAIN2**: on the game camera (s188_floorgain/56) the week review still reads "Nobody trained". The walk's save: 15 camp visits
  filed, each only `{"pads": 4}` minutes - CONTINUE A WEEK / the forced camp mornings end the visit almost at once, so technique moved
  +0.009 in a week (floor_gains raw 19.6). The review is now honest; the auto-filed day is the defect. Decide: a skipped/auto day runs
  the coach's default day (the week's cards on their stations, ~DayLap full day) instead of 4 minutes, OR the skip warns (S187 B16).
  Start: `GymHall3D._end_visit` (~670) and who calls it at line ~632; GymHallPanel `_on_visit_ended`.
- PLAYUI1 (Cursor c916decb) NOT merged: ghost text fixed, but still 50 still clips 5 texts and the Continue / Set his training buttons
  are still cut -> send-back PLAYUI1B running.
- GATES1 follow-up: a branch with no registered worktree is extracted to a temp dir on C: and Godot-imported there - move it to E:.

## Agents
Codex SPLIT2 (training -> GameTraining.gd) RUNNING, wt E:/FightCamp/wt/SPLIT2. Cursor PLAYUI1B RUNNING (wt PLAYUI1). Arena FLOORGAIN1B
(blind contract test of lived_gain, chat 01a12206) and SPAR1A (SparRead pure fold for the spar panel, chat 01a1220d) RUNNING.
Maria M44 mock DONE in her chat (rules note in the gbot thread), copying to the PC was in progress at handover.

## HANDOFF
Next: collect the four runs above, then FLOORGAIN2, then SPAR1 screen (M44 + SparRead).

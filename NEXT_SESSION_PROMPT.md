# S476 handover (written 2026-11-14 at the end of S475; S474's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S476`.
Miro P0: S475 redrew it (start + end). Partial updates work: send only the changed card slots + new ones + data-deleted lines
(the frame's own resize is refused by Miro - leave the frame rect out; the frame just stays taller).

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k; start the wrap-up at ~310-330k (a full Miro redraw costs ~25k: send partials).
- Godot jobs through `python ops/Tools/godot_slot.py run --who s476 -- <cmd>`.
- Arena: `python ops/Tools/lite_mirror.py --lean push` first; repo ICOON-Studio/FightCamp-Lean-lite, branch main; a short prompt
  naming ops/research/TASK_<ID>.md works. New chat per task. S475: Arena showed a Terms dialog (signed out) - the owner cleared it.
- Goose: 3 a day; S474+S475 filed 4 on 2026-11-14 (FWPAY1 closed unused).
- Never `cd` into a worktree (use `git -C`); it moves the session's working directory.

## HIS WORDS THIS SESSION
- Q-S294-229 board answer (comment, not a yes) - verbatim + Claude's answers in ops/research/AMATEURWEEK1_OPERATOR_NOTES_S475.md:
  4.1 trips "useless logistics and pain in the ass" -> a MANDATORY sparring partner, picked on a screen: left your boxer, middle the
  partners, right the opponent's card (what is known). Season ladder "at least 9/10", reputation over fixed win counts. Asked how
  tell truth shows, how look-again works, how mood works (answered), wanted to see section 9 (crop sent:
  docs/mockups/s474/fight_night_frame_v1.png). The other 6 rules (pro offer 9 wins, savings, rest gaps, tick over, weigh-in,
  cottage) were NOT answered: the trips/cottage/savings ones are moot; ask the rest again only if v9 still needs them.
- "arena rdy" (he accepted Arena's terms).

## IN FLIGHT (yours - collect, do not relaunch)
- Qwen KNEEFIX1 LANDED (branch qwen/kneefix1, commit a59e1c80) - NOT MERGED. guard_knee passes (rear -0.0067 / +0.0020 v the
  calibrated source) BUT it lowered MIN_GUARD_FRAMES 15 -> 8 (boxer 1 settles only 8 frames at yaw -45) = a weakened test, and its
  4 stills (docs/kneefix1 on the branch) cannot show the knee: the two boxers stand inside each other's guard (gloves through heads,
  a GAP defect in the guard still itself) and the camera is far. Next: keep the SOURCE calibration (sound), refuse the frames cut
  (find why b1 settles 8 frames at -45), render close rear-leg stills both settings at a real range, then his look.
- Arena FWTRIPS1 (chat https://arena.ai/agent/01a1dbad-e080-797e-ae46-6f33e93a32c3): trips were CUT - close its lite PR unmerged.
- Seat queue: SQ144 Kalli fight week map v9 (sparring partner screen replaces trips); SQ145 John LADDER1 research; SQ141/142
  step value critics (Dola, Maria); SQ143 Kalli plan flowchart v3; SQ139/140 fight week screen critics (v1 - redraw after v9);
  SQ131/132 coach fit v8, weight r4; SQ135/136/138 club week v7 critics.

## FIRST
1. Collect KNEEFIX1 (above). 2. Seat answers: v9 -> two fresh critics (`design_loop.py critic AMATEURWEEK1_V9 ... --seat dola|john`)
-> 6/6 + depth 7 -> his board WITH the redrawn screen mockup (sparring partner columns; names only in headers - v1 had "her" and
"She pays"). LADDER1 research -> Kalli map -> critics to 9/10. Plan flowchart v3 -> his board. 3. Arena: a pure module from v9 when
it lands (partner-to-opponent match score). 4. The fight week switch still waits for v9 + his look at the screen.

## NOTES
- Built and on main, unwired until the switch: WeighGap, BoutSheet, FightWeek, FightWeekEvents, FilmTruth, FightWeekPick,
  RegionShows. FightWeekPick names a trip-free week; check it against v9 before wiring.
- LIVERRIBS1 left: the forecast (BoutRead) does not read the Aim - the Aim is picked live, so decide whether a plan-level aim
  exists to mirror; and play it in the exe.

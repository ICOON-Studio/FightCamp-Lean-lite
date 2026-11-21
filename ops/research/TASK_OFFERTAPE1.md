# TASK OFFERTAPE1 - the bout offer stops looking like the tale of the tape; the tape shows form (owner review notes C448, C449)

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
Owner S535 on the review board (stills in E:\FightCamp\review\2026-11-21_1502_painted_bodies_everywhere_2d_your_keep_p\):
- C448 on 12_bout_real.png (the bout OFFER): "this looks too much like the tale of tape, maybe change it ?"
- C449 on 18_tape_real.png (the TALE OF THE TAPE before the fight): "ok. maybe add streak/latest results?"

## Part 1 (build): form on the tale of the tape (C449)
- A "Last 5" row (newest first, W / L / D, a stoppage marked, e.g. "W W L W(KO) W") and the streak in words ("3 wins in a row")
  for both corners. Our boxer: `c.results` (BoutFinish.gd:155, newest first; HotStreak.gd reads the same). Opponents keep only
  w / l today (no per-bout list): add a small `form` list to a world boxer, written where its w / l change (Matchmaking.apply_result
  for pros, BoutFinish for our bouts, and the amateur world's own results if it plays any - find them; BoutRead._after only
  previews). Never invent past results: where nothing is known yet, show the record only and the row says "not on tape" (TapeRows
  MISSING / WHY rule). Old saves load (SaveGame defaults).
- One list, every screen: put it in `scripts/rules/TapeRows.gd` (all tape screens read it: TapeVersus, FightPrep, VersusPanel,
  fight3d TapeCard). Names only in headers (owner S448).
- Red-first test: `tests/tape_form_test.gd` (our boxer's last 5 from results; an opponent's form after a pro bout; an unknown form
  shows the record only).

## Part 2 (mockup first, then his OK): the bout offer as a DECISION, not a tape (C448)
The offer (scripts/ui: find the screen that draws 12_bout_real.png - "Accept the bout" / "Pass: loyalty -3") repeats the tape's
layout (two painted boxers, the stat table). Its job is the decision: the deal (date, weeks to prepare, money to the club, answer-by),
what a win and a loss do (ladder), the coach's read and the risk, the opponent's threat and form - and only the 2-3 stats that
decide it. Draw it as a 1920x1080 HTML mockup (tools/render_mockup.py) in the game's look (Palette.gd colours, the painted bodies
can stay but the centre is a contract / letter, not a stat table), plus the tape for comparison. Put both on the map
(`python ops/Tools/opsboard/map_board.py gallery ...`) and the review board; do NOT build part 2 until the owner OKs the mockup.

## Prior research
`python ops/Tools/prior_research.py bout offer tape versus screen` first; memory feedback_names_only_in_headers_s448,
feedback_only_actionable_info_s398, feedback_screen_logic_of_the_moment_s439, feedback_tooltips_explain_s532, ONELOOK1 notes.

## What would a human do?
A promoter's offer is a phone call or a letter: who, when, how much, what it does for you. The tale of the tape is the poster on
fight night. Two different moments, two different screens.

## Prefab check
None: TapeRows, the painted bodies, render_mockup.py exist.

## Contract
OWNS: scripts/rules/TapeRows.gd, tests/tape_form_test.gd, ops/previews/s535_offer_mockup/offer.html, docs/OFFERTAPE1_RESULT.md
RED_TEST: tests/tape_form_test.gd
REGRESSION: tests/golden_path_test.gd
VISUAL: yes (part 1: a tape still with the form row; part 2: the mockup)

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who offertape1 -- <command>`; screens rendered on the hidden desktop
(tools/layout_snapshot.gd, clean_view rules). Never stage LineGrade.gd, LiveRound.gd, StepWire.gd; other consoles own
scripts/fight3d/v2 and MHRig.gd. No file over 500 lines. Stage explicit paths, commit to main with the Co-Authored-By line, push,
reply on the board (`python ops/Tools/review_reply.py` if it exists, else say so), report in two lines, stop.

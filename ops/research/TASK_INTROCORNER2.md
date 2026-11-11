# TASK INTROCORNER2 - QWEN (qwen3-coder) - the fight intro from the corners, second round: it must compile, last, show each name call, and never play the two boxers alike

Status: OPEN (S435, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: the operator, S434: "add some celebrating animations or shadow boxing during the introduction and do not make each
fighters animations identical"; the ring entry is out, the intro starts in the corners. INTROCORNER1 (branch
qwen/introcorner1, commit 792eb414) was NOT collected (S435, Claude read it in the real game):
1. THE GAME DID NOT COMPILE. scripts/fight3d/FightIntro.gd line 81-82 called `IntroEntry.new()` then `_entry._init(stage,
   crew)`; IntroEntry._init takes (s, c). Main.gd failed to load. The seat's tests passed because none loads the game.
2. tools/intro_still.gd did not parse (Data.SAMIRA, Data.PRIYA do not exist; CornerCrew.build needs 2 arguments). No still
   was ever made.
3. With line 81 fixed, the real game's intro (tools/intro_shots.gd, a still every 0.5 s) read: warm-up 0 to 2 s
   (rk_shadowboxing_b v ow_bounce_idle: different, good), then BOTH boxers on `ow_walk` for 1.5 s, then BOTH on `af_idle`
   until the bell at 6 s. No name-call clip ever played on either boxer. Main's intro runs past 9 s before the warm-up
   even starts: the new one is about a third as long and its one new idea (the name call) never shows.
4. In the stills the TALE OF THE TAPE card covers both boxers from the walk to the bell (only the boots show), the two
   walk in the same pose with both arms held out in front, and in the warm-up the blue boxer leans back over the ropes.
Read first: ops/research/TASK_INTROCORNER1.md (the full spec still holds: styles by personality, joins, feet planted, the
`_announce(i)` hook), docs/mockups/s435/introcorner1/ (three stills of the faults; you cannot see them: use the numbers).

## Contract
OWNS: scripts/fight3d/FightIntro.gd, scripts/fight3d/IntroEntry.gd, scripts/fight3d/IntroStyle.gd, tests/intro_style_test.gd, tests/intro_real_test.gd, tools/intro_shots.gd
RED_TEST: tests/intro_real_test.gd -> INTRO_REAL failures=0
REGRESSION: intro_style_test, ring_ropes_entry_test, corner_warm_test, fight_polish_test, file_limits_test, fight_flow_test, hud_shown_test, corner_lens_test, theatre_test, no_pronoun_test
VISUAL: yes - Claude renders tools/intro_shots.gd and reads the stills; the operator closes it.
NOT YOURS: FightStage.gd, FightView.gd, FightCast.gd, CornerWarm.gd, the tale-of-the-tape card's own script (read it; if
the card must move or shrink to stop covering the boxers, say so in the PR body and Claude does it).

## The job
0. Start from your own commit: `git cherry-pick 792eb414` on this branch (or redo it), delete tools/intro_still.gd, and
   fix FightIntro.gd line 81 (`IntroEntry.new(stage, crew)`, no second `_init` call).
1. THE INTRO LASTS. In the real game (not a test double) from the first frame to the bell: the corner warm-up is at
   least 6 s of game time, each name call holds at least 2.5 s, the walk to the middle follows. Use game time
   (`view.t` or the intro's own clock), never wall time.
2. EACH NAME CALL SHOWS. When the red name is called the RED boxer plays the name-call clip of their style (a Win take
   for the showman; the glove raise for the worker; a quick raise for the nervous one) and the camera the intro
   already uses for that corner is on them; the same for blue. The other boxer keeps their own warm-up.
3. NEVER ALIKE. At no sampled moment of the whole intro do the two boxers play the same clip, the walk to the middle
   included (two different walks or the same walk started at different phases counts as the same clip: use different
   clips; if only one walk exists, one boxer walks and the other is already at their mark, then swap by the bout seed).
   No boxer walks with both arms held out: after the gloves' guard is on, the walk keeps the guard (check the two
   hand bones are within 0.35 m of the head bone during the walk).
4. THE CORNER POSE STANDS. During the warm-up the hips stay over the feet: the head bone is within 0.25 m (flat) of the
   midpoint of the two foot bones on every sampled frame, for both boxers (the blue boxer's lean over the ropes fails this
   today).
5. tests/intro_real_test.gd (headless, extends SceneTree): it LOADS `res://scenes/Main.tscn` (so a compile error anywhere
   in the game fails it), then builds the intro on a FightStage the way FightCast.intro does, with two fighters of
   different personality, and steps the intro's timeline with a fixed dt to its end, sampling every 0.25 s of game time:
   a. Main.tscn loads and the script of every file you own loads (load() is not null). Red on 792eb414.
   b. the timeline from the first frame to the bell is at least 14 s of game time; the warm-up at least 6 s. Red on 792eb414.
   c. each name call: that boxer's clip is one of their style's name-call clips for at least 2.5 s. Red on 792eb414.
   d. no sample has both boxers on the same clip (print the worst run of equal samples: 0). Red on 792eb414.
   e. the walk keeps the guard; the warm-up keeps the head over the feet (the two distances in job 3 and 4; print the
      worst of each).
   f. three pairs of personalities (showman v worker, worker v nervous, a fighter v a copy of themself) x 20 bout seeds.
   Every bar prints the number it read. A row that cannot be measured is a FAILURE, never a skip. If the 3D stage
   cannot be built headless, say so in the PR body and run the same checks from tools/intro_shots.gd instead (it runs
   with a picture) and print the same lines there.
6. tools/intro_shots.gd is on main (Claude's still tool: the real game, a still every STEP seconds, an INTRO_SHOT line
   with each boxer's clip). Extend its line with the game time, the camera name and the cue name if you can read them;
   do not change how it starts the game.

## Prior research
ops/research/TASK_INTROCORNER1.md; scripts/fight3d/CornerWarm.gd (the warm-up takes and the join it uses); memory rule
S420: a seat test must run the game path (a test that never loads the game let a branch through that did not compile).

## What would a human do?
Watch a televised bout's introductions: each boxer loosens up in their own way in the corner, the announcer calls one
name and that boxer answers the crowd while the other keeps moving, then the other. It takes most of a minute, and the
two never mirror each other.

## Prefab check
The clips exist (Win takes, fidgets, bounce, the owned shadow-boxing takes, the glove raise the warm-up has). Nothing new
is made or bought.

Rules: no script over 500 lines (FightIntro.gd under 470); no he / she in any script text; parse every file you touch
before testing; new features ship ON; never loosen or delete an existing test to pass; commit on your branch and PUSH.
RESULT lines for the PR body: `RESULT: tests/intro_real_test.gd -> INTRO_REAL failures=0` and one per regression test.

# TASK ANIMFIX1 - CLAUDE SUBAGENT (Fable 5.2) - the fight animations: boxing and grappling, seen on the board

Status: OPEN (S425, Claude main). Discipline: boxing and no-gi BJJ (both are in the game). Animation item (operator S401).

## The operator's words (2026-11-10, verbatim)
"can you assign a subagent to fix the boxing/grappling animation issues and using fable 5.2 , i want to start seeing
animations on the board and grappling fights that make sens and make understand what is the action happening and how to
react as a player". Earlier the same day: "when do you think i will be able to see a second animation on the board ?"
He is the playtester (40 years of games, boxing and BJJ background, no development background). He judges with his eyes.

## What done looks like
1. FILMS ON HIS REVIEW BOARD, each looked at by you first and rated honestly:
   `python ops/Tools/review_add.py --stage S425 --rating "<score /10, Claude subagent>" --title "<what it shows>" <file>="caption"`.
   A film he can watch in under a minute, 1280x720, of the game's own screen. No film = nothing done.
2. BOXING: the legs no longer tremble in round 2, on film, with tests/head_aim_test.gd, leg_tremble_test, beat_clips_test,
   move_tip_test and block_meet_test green on the branch.
3. GRAPPLING: a live BJJ match in the game where a viewer can say at every moment (a) who is on top and in which position,
   (b) what is being tried, (c) whether it is working, (d) what the player can do now. Where the picture and the words
   disagree, the picture is fixed (or the words), and the film shows it.

## Track A - boxing: the trembling legs (start here, it is nearly there)
- Worktree `E:\FightCamp\wt\LEAN_LEGTREMBLE4`, branch `qwen/legtremble4` (Qwen finished, commit 0edc96fe, not pushed).
  It is yours now: work there. History: ops/research/TASK_LEGTREMBLE4.md, docs/LEGTREMBLE1_RESULT.md on the branch.
- State: leg_tremble_test, beat_clips_test and move_tip_test pass; tests/head_aim_test.gd has ONE failure, a VOID on
  `B_A_dn lead_hook` (hips gap 0.972 against gap_m 0.916, GAP_TOL 0.05; main has 0, twice).
- Qwen's stated cause is UNPROVEN and partly wrong, do not build on it: it says FightClips.hold_root_xz never fires for
  retargeted clips because the path has no colon. FightClips.load_into prefixes every track path with the skeleton path
  BEFORE calling hold_root_xz ("<prefix>:<bone>"), so the check does see "Hips"; and main plays the same guard clip and
  is green. The difference between main and the branch is the baked clips (149 rewritten by LEGTREMBLE3, 122 hips-locked
  by LEGTREMBLE4). Audit it yourself: same setup, main's clips against the branch's, the hips of both boxers frame by
  frame around `_reset`, until you can name the clip and the key that moves the gap 5.6 cm. This is round 5: no more
  guesses, a measurement that names the cause, then the fix, then the test green three runs in a row.
- A film of one short round on this branch is being made now: `E:\FightCamp\tmp\s425_lt4\round.avi` (log beside it).
  Watch it first (the `eyes` skill, or extract frames with ffmpeg and open them with the Read tool): do the legs tremble?
- When green and looked at: commit on the branch, push the branch once (`git push origin qwen/legtremble4`), post the
  film. Do NOT merge to main: Claude main collects by diff.
- NOT YOURS: the knockdown sway (KDFIX4) is running on Cursor in `E:\FightCamp\wt\LEAN_KDFIX4`. Do not edit
  scripts/fight3d/FighterLife.gd, GuardWeave.gd, KnockdownLayers.gd, TiredSag.gd, tests/knockdown_still_test.gd or
  tools/knockdown_probe.gd.

## Track B - grappling: a match the player can read
- New worktree from main: `git worktree add E:/FightCamp/wt/LEAN_GRAPPLEFIX1 -b claude/grapplefix1 main` (run from
  E:\FightCamp\Lean), then seed it: `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\seed_godot_cache.ps1
  -Worktree E:\FightCamp\wt\LEAN_GRAPPLEFIX1`. Work there.
- Start by SEEING what he sees. `tools/open_night_play.gd` walks the career's real buttons to a live BJJ bout
  (usage in its header; `auto=1`), `tools/theatre_film.gd` films a chain, `tools/belt_match_film.gd` a match. Film a live
  bout as the player gets it, then go through it second by second and write a table: time, what the rules say is
  happening (position, who is on top, the move, the player's options on screen), what the picture shows, can a viewer
  tell (yes/no), what is wrong (bodies through each other, a floating limb, the wrong person on top, a label ahead of or
  behind the motion, an option that does not match the picture, nothing telling the player what his choice did).
- Read before fixing: ops/research/topics/ground.md and paired_holds.md, ops/research/CRITIC_PACK.md (the BJJ sections),
  ops/research/BJJ_FILM_JUDGED_S390.md, BJJ_CONTACT_JUDGED_S391.md, BJJ_CRITICS_R6_S398.md, GRAPPLEFIX1_TABLE.md (what
  earlier rounds found and fixed; do not redo them). Code: scripts/grapple/ (GrapplePlayer, GrapplePose, GrappleContact,
  GrappleLimbs, GrappleTheatre, TheatreUI, MatHud, TieUpPanel) and scripts/rules/Bjj*.gd. Probes that already measure:
  tools/who_on_top_probe.gd, tools/grapple_mesh_probe.gd, tools/bjj_tremble_probe.gd, tools/bjj_realism_probe.gd.
- Fix in this order, one at a time, each with a ruler that is red before the fix and green after, then the film again:
  1. anything that shows the wrong thing (wrong person on top, a position that is not the one named);
  2. bodies that break the picture (limbs through torsos, floating, trembling);
  3. the action is not readable: the move's name, its start and its result must land with the motion; a viewer must
     see who is attacking;
  4. the player cannot tell what to do: his options must be tied to what the picture shows now, in plain words (what
     the call does, never jargon), and the result of his call must be visible on the bodies and said once.
- After each fix that changes what he sees: the film (under a minute), looked at, on the review board. Commit on
  `claude/grapplefix1`, push the branch once per finished fix. No PR, no merge to main.

## Rules of this PC and this repo (hard)
- Read first: E:\FightCamp\Lean\CLAUDE.md (PC rules, tests, git) and ops/research/GDSCRIPT_TRAPS.md.
- Nothing opens on his monitors. Godot headless: `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe --headless
  --audio-driver Dummy` (never the _console.exe). A picture needs a window: only on the never-shown desktop,
  `python tools/hidden_desktop.py run --timeout=<s> <godot.exe> --path <worktree> --windowed ...`. Images and films are
  opened with the Read tool / the eyes skill / ffmpeg frames, never with an app.
- EVERY Godot job goes through the queue: `python ops/Tools/godot_slot.py run --who claude-anim -- <the Godot command>`
  (run from E:\FightCamp\Lean; a hook blocks a bare Godot start). One windowed render at a time. Before a film or a test
  batch: `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; RED = wait, do not start.
- Never kill Godot by image name (other agents run it): by PID only, and only your own.
- Tests: only the ones your change touches, never the full suite (`sh tools/run_tests.sh` is the full one). One test:
  the headless exe with `--script res://tests/<name>.gd`. The exit code alone is not a pass: read the output; rc 124 is a
  hang, suspect a parse error. A new ruler must be red on the unfixed tree first.
- A visual fix is done only on the game's own camera, in a still or film YOU opened: check gap, noses, wrists, feet.
  A test closes nothing visual on its own. Never tune a number to pass a bar; never call a red test "pre-existing"
  without running it on main.
- No script over 500 lines (tests/file_limits). Game words on screen, never jargon. Git: explicit `git add -- <files>`,
  never stash / reset --hard / checkout . / clean / add -A, never `git gc`. Commit messages end with
  `Co-Authored-By: Claude Fable 5.2 <noreply@anthropic.com>`.
- Do not edit anything under E:\FightCamp\Lean itself except by reading: your code changes live in your two worktrees.
  (review_add.py and godot_slot.py are run from E:\FightCamp\Lean; that is fine.)

## Report (your last message, plain words)
Per track: what was wrong (the measured cause), what you changed (files), the tests and their pass lines, each film's
path and your rating, the branch and its last commit, and what is still wrong, most visible first. No claims without a
file behind them.

# S310 digest (2026-10-30) - updates 11-13 in Lean, board Play buttons, real-fight study

## His words this session
- Q-S294-17 (update 10): "Yes, it works". Q-S294-18 (update 11): "for now is ok as i said needs more features/mechanics for
  the player during the fight but these need to be wired also with the other aspects (training,etc)". Q-S294-20 (corner
  plan): "Yes, build it". Q-S294-19 / Q-S294-21 (updates 12 / 13): open.
- Play notes: "playing it seems satisfying", "body shots still have no reaction", "need a mechanic to prevent the player to
  pick always the green options", "where is stamina, body damage, nothing is shown anywhere", "does nt feel like a human
  body, too flat back", "the player needs a lot more to select during the corner time", "add the tale of the tape",
  "why don't you map all 165 clips we purchased?", "do all this on next session".
- C141 (coach from the side) "doesnt look like a natural human"; C142 "looks better from this angle".

## What shipped (Lean)
- 83e852d update 11: coach's pick only with film study, from her usual game (Exchanges.favourite); buttons show "when";
  shout bar 10 s. Measured film 3: none 0.56 / follow pick 0.66 / read clue 0.72. c7dda85: last bare her/she named.
- e341d68 + Game dcfed6df/3e730fc4: board main page "Play the game" (latest build + Test buttons). The board is an S4U task
  in session 0 - buttons run Interactive scheduled tasks (Tools/register_play_tasks.ps1); TestJump.gd jumps.
- 42419f7 / f39b33f update 12: Exchanges.COMMIT (always-green 0.55 = silence 0.54, read 0.68); body damage costing energy
  all fight; FightHud energy / BODY HITS / HURT; ring lands the counted body shots; HitSnap.fold; cloth normal maps.
- 0ab9976 tale of the tape; 8b96fa5 crouching coach trunk up (CornerIK.upright 55 deg).
- eca97b4 update 13: corner minute four jobs (CornerJobs recover / set-up with gold NOW / talk). Plan 0.73, + set-up 0.78
  (stoppage wins 3.3 -> 4.8%), + truth 0.77.
- 7b324d2: the whole Punch Pro library in use (BeatClips.pick; react() always took the first clip).

## Evidence
29/29 Lean tests at 7b324d2 (corner_jobs_test 20, beat_clips_test, tale_of_tape_test, test_jump_test new); stills on the
review page (fight display, body fold, back before/after, tale of the tape, coach neck, corner card, reaction sheet).

## Side session
real-boxing-footage (local_e568234c) -> Game 3ebbca97 `research/S310_REAL_FIGHT_GAPS.md`: three women's world finals vs
our round 1. Ranked: 1 range that breathes (FightStage._compose pins the jab gap), 2 head-shot lock 0.2-0.3 s, 3 feet moving
>= 35 %, 4 clinch + referee, 5 guard by range, 6 2-5 punch bursts.

## Decided (Claude, as developer)
- Clinch: no two-person boxing clinch is sold (Fab, MoCap Online, Reallusion searched) and free commercial data has none;
  build it on CornerIK reach + look + af_push (his call open: build free vs paid capture). No new mocap purchase needed now.
- Lean parse gate: `--check-only --script` on every touched .gd before a windowed run (a parse error hung corner_film 450 s).

## HANDOFF
Next session: his board answers (Q-S294-19, Q-S294-21, clinch choice), then S310_REAL_FIGHT_GAPS fixes 1-3, then the clinch.
Lean NEXT_SESSION_PROMPT.md has the details. Bouts.gd is 493 lines - split before adding to it.

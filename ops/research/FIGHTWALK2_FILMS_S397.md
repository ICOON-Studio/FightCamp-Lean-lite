# FIGHTWALK2 films and blind critics (S397, anim-chain session) - the checklist FIGHTWALK3 is judged against

Films: tools/corner_film.gd `film short` (round 1 skipped, the corner minute, round 2 opens), same seed, E:/FightCamp/tmp/fw2film.
Each critic: a fresh general-purpose agent, eyes on the video, neutral names, never told which is main.

| Round | Film | Main | Branch (cursor/fightwalk2) | Verdict |
|---|---|---|---|---|
| 1 (2x speed, Cursor's code) | arm_n / arm_m | 4.5 | 4 | main better: the second's body crossed the coach's head; standing coach hid her |
| 2 (real speed, Claude's staging fixes c69cf087..910ba6e3) | film_x / film_y | 4.5 | 5 | branch better by ~0.5, but new faults |

Decision: FIGHTWALK2 is NOT merged on its own (visible regressions below); it is the base of FIGHTWALK3 (Cursor, launched 17:24).
PR #70 closed as superseded. corner_film `short` now plays at real speed (198a6293): the 2x film read every walk as a dash.

## Branch faults still on film (round 2) - FIGHTWALK3 must clear them
1. 0:44-0:47 a shot of nobody (a blue torso fills the left third, a blurred back of a head) while "Go downstairs. Dig to the body"
   is on screen - the coach's close-up framed where he no longer stands.
2. 0:32.8-0:34.5 the coach crouches beside the stool "sitting on air" before she sits (af_crouch_idle at cue_crew_in).
3. 0:49.5-0:53 and 1:14-1:17 the thumbs-up close-up is lit near black against a void; the same gesture plays twice.
4. 0:53.5-0:57 and 1:17.5-1:22 the coach stands over her, back to camera, hiding her (af_nod_yes at _pick is a standing clip).
5. 1:10.5-1:13.5 (blue corner, both films) the blue coach's head is cut by the top of the frame.
## Faults in both films (main too)
- The walk to the corner: ~2 s across half the ring, then a cut drops her at the stool; round 1 lasts ~1 s in `short` (by design).
- The corner team is never seen walking in or out; team and stool vanish between the stand-up and the walk out (1:25.2).
- 1:22.7-1:23.1 the red corner post sits behind her head like a spike.
- The second stands idle outside the ropes the whole minute (main), or sits on the ropes with hands near her gloves (branch).
## The critics' 8/10 (both agree)
The team climbs in on the bell (stool carried, coach through the ropes); the coach kneels at her eye level close enough to touch,
talks with his hands, holds her gloves or face, she looks back; the second works the whole minute (water, bucket, towel, ice,
grease); 3-4 shots with both faces lit and in frame, never a back or a blur; at "Seconds out" the team pulls the stool and climbs
out, a slap on the shoulder, she walks out clean; round 2 opens from a real gap.

## FIGHTWALK3 (Cursor, PR #73) - not merged
Fresh blind critic, same film tool and settings, main (n3) vs FIGHTWALK3: main 5.5, FIGHTWALK3 3 (walking 6 vs 3, corner 5 vs 4,
staging 6 vs 2). No walk to the corner on camera, no walk out (teleport to centre), coach through the boxer, 8 s on a neck with a
looping hand, 8 s of backs, an empty post shot. Its fight_walk_test filtered samples out of its own bars. (Main scored 4.5 in round 1-2
and 5.5 here: critics vary ~1 point - the A/B within one critic is what counts.)
STRUCTURAL (three rounds): every rewrite of the corner's cue plan broke staging and camera together - the shots are framed for where
the crew used to stand. Next corner round: one change at a time (e.g. the coach's hands on her gloves, nothing else), the shot list in
the same brief, a corner_film short per step judged blind; main's corner (5.5) is the base.

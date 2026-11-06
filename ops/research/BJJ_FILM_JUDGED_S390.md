# BJJ belt match, judged and fixed (S390, 2026-11-06)

All judges are blind Claude sub-agents reading eyes contact sheets, not people. The players are simulated personas, not playtest data.
Each film is a different stretch of a match, so scores show direction, not a measurement. The operator's eye outranks them.

| Film | What changed | Reviewer | Animation | Technique | Sam fun/clarity | Priya | Tom |
| --- | --- | --- | --- | --- | --- | --- | --- |
| S389 after | clash panels | 3 | 4 | 3 | 6/5 | 3/3 | 4/5 |
| S390 film 1, seed 28 | S389 body placement | 3.5 | 3 | 2 | 5/6 | 3/4 | 4/6 |
| S390 film 2, seed 22 | right winner, curated moves, gas | 3 | 4 | 3 | 4/5 | 2/4 | 3/3 |
| film 3, seed 22 | finish switched on, mat | 3 | 3.5 | 3 | 4/6 | 2/4 | 3/5 |
| film 4 | finish built from the landing | 4 | 3.5 | 3 | 4/6 | 3/4 | 3/5 |
| film 5 | pull-in, leg over, free arm posted | 4 | 4 | 3 | 4/6 | 3/4 | 3/4 |
| film 6 | close lens (banner and panel bugs) | 3.5 | 3.5 | 3 | 4/5 | 3/4 | 3/3 |
| film 7 | hips scoot in, panels off, banner low | 3.5 | 4 | 3 | 4/6 | 2/4 | 3/5 |
| film 8, seed 22 | two skin tones, slower taps | 3 | 3 | 2 | 4/5 | 2/3 | 3/4 |
| film 9, seed 13 | same, a kimura with a coach call | 3.5 | 3 | 2 | (one row for both matches) | | |
| film 10, seed 22 | status line in corner colour | 3 | 3 | 2 | 5/6 | 3/4 | 3/5 |

**Not at 7/10.** Fun and technique did not move. Films 8 and 9 scored lower after the two skin tones made the bodies easier to read: judges then read the winner and loser
the wrong way round. That reading is wrong: the frame shows red Ana on her back applying it, and tools/who_on_top_probe.gd finds the rules and the drawn hips agree on 275 of 283 and 129 of 137 settled frames.
It was still a real clarity failure: nothing tied the name to the body. With the status line in the corner colour (film 10) the judge named who was who at about 95% and read the armbar the right way round.

## Causes found (each measured or read in code)
- The winner was the higher body. In an omoplata, triangle or guard armbar the attacker lies underneath, so the win went to the victim, or the submission was refused.
  45 of 82 submission positions have the attacker under. Fixed: GrappleFinish.attacker reads whose limbs are on the target, per family.
- The finish never played. "finish" sat in GrapplePlayer.DEFAULT_OFF from S379, so S389's tap and the armbar extension never ran in any film. Fixed.
- The tap used the raw landing, not the frame on screen; a move is laid on swapped or mirrored, so the winner would have tapped. Fixed: shown_frame, loser passed in.
- GrappleMap's "tap" moves (22) go to "staredown": played mid-match the pair let go and stood 1.2 m apart. That was the apart bar's repeat failure.
  Fixed: refused in a match. Apart bar: 2.0-2.6 s on 7 of 8 seeds, widest 1.41 m -> 0.0 s, widest 0.05 m on the two seeds rechecked (22, 11).
- go_position never moved the bodies: a position is one frame and a blend snaps a sequence's first frame to the pose on screen. Page and match moved on, bodies stayed. Fixed: two frames.
- Gas: MISS_GAS 0.06 emptied both women by 3:00. Now MOVE 0.015, MISS 0.025. Not yet checked against real rolls.

## Curation
tools/grapple_quality.gd writes assets/data/grapple_curated.json: 402 of 1,485 moves refused in a match (wip 236, inverted 73, pop 69, bad landing 42, inside 38, tap 22, apart 4; a move can carry several).
The thresholds are judgement calls and have not been checked move by move. The browser still shows every move.

## More causes found after film 2
- GrappleMap's recorded "extend arm" popped the pair 90 degrees and lost the arm; the finish now grows from the landing (GrappleFinish.squeeze).
- A straight arm is 0.56 m: with her hips away the wrist overshot to her face, so her hands sat on her own face. Her hips now slide in under the shoulder.
- The trapped arm was re-chosen after the slide and could flip; now chosen once.
- Timing clamped a keyframe gap at 1.2 s, so big moves whipped round; now 2.2 s. Not re-judged on its own.
- Two identical skin tones (11 and 10 both #4f3122) read as one mass and hid who was who. Opponent is now mh_boxer_17.
- Only the arm family has a built lock. Every other family gets the squeeze and the tap on the landing as GrappleMap gives it.

## Still open
Film 10's judge: her hands still read on her own face, the tap meets nothing (about 60% it is a tap), no knee pinch or hip lift. A win from 0-3 on a 28% roll reads as dice.
The kimura grip (GrappleFinish._take_grip) came after film 9 and has not been filmed.
Limbs through bodies (the sep layer is off since S379 for trembling), fast spins (17.4 s, 39.7 s in film 2), a real lock for families other than the arm,
floor dips of a few frames (seed 11: 0.159 m, 4 frames at 119.6 s), the status line naming the wrong woman on top, no coach call on short matches.

## Boxing, same night
One judge per film, different footage each time: direction only.
| Film | What changed | Fight | Animation | Camera |
| --- | --- | --- | --- | --- |
| main | baseline | 5 | 4 | 5 |
| box 1 | FIGHT9R16 merged by hand | 5 | 5 | 6.5 |
| box 2 | replay after he lands | 5.5 | 5 | 6 |
| box 3 | replay runs to the frozen moment | 5.5 | 5.5 | 6 |
| box 4 | rest-pose pop fixed | 5.5 | 5 | 6 |
| box 5 | walk-off, shorter lead | 5 | 5 | 4 |
| box 6 | stays inside the ropes | 5 | 5 | 5.5 |
| box 7 | walk planned after landing | 5 | 5 | 5 |
| box 8 | standing boxer kept clear of the body | 5.5 | 5 | 5.5 |

Fixed and confirmed by a judge: the replay return (tools/replay_exit_probe.gd: head 1.61 m on the first live frame, the rest pose under the replay), and the body inside the ropes.
Open: the corner walk (the old clip, stiff for 4 s), the replay shows the punch and the fall on separate angles, no hurt state after the count, the skate after the count (not the lunge: that is about 2 m/s; cause unknown), the knockdown has no head snap or stagger, stand-offs out of range, punches short at 0:40.

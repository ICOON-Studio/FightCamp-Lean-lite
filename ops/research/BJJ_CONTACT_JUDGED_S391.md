# BJJ contact, measured and judged (S391, 2026-11-06)

Branch claude/bjjcontact, not merged. All judges are blind Claude sub-agents reading eyes contact sheets, not people. The players are simulated personas, not playtest data.
Each film is seed 22. The operator's eye outranks all of this: mid-session he looked at a judged sheet and said "blue doesn t even look like a human". He was right and the bars were green-going at the time (see below).

## Not done
The limb bar set before the work (no limb past 6 cm for over 0.5 s) is still red on all three seeds. Nothing here is at 7/10. Not to be shown to him as finished.

## Why the sep layer never helped
tools/bjj_tremble_probe.gd with `withsep withcarry`: JOINTS overlap peak 0.214 -> 0.054 m, DRAWN overlap p95 0.176 -> 0.196 m, jerk p95 272 -> 456 m/s^3.
It clears the data's thin figure, and the drawn bones sit 9-28 cm off those joints (our lengths, track's shift); with sep on, 18-35 cm. It trembled and fixed nothing on screen. Left off.

## What was built
- scripts/grapple/GrappleLimbs.gd: on the drawn bones, each limb swings as one rigid piece about its shoulder or hip, capped at 0.45 rad, its shape kept. Eased, outside the loop. `nolimbs` is the control arm. The head turns on the neck.
- Holds: where the data says a hand or foot touches the other woman, the spot (segment, how far along, which side) is found again on her drawn bones. This is what puts both hands on the wrist.
- Placement (GrappleDrawn.track): eased on the way to the screen, steps proportional, a stale shift leaks away. On its own this took pooled jerk 272 -> 146 and flips 0.70 -> 0.20 before holds went in: most of main's measured tremble was track's corners, not the recording.
- Finish: second leg clamps the chest; the tap is on the mat (S390's thigh tap landed, measured, palm on skin, and nobody could see it behind her head); the lens is chosen for a clear line to the hand (FinishLens.gd); the winner drives her hips into each tap; the banner says the corner.

## The trap: contact bars alone reward throwing limbs away
The first solver moved the hand or foot and re-solved the bend. Limbs past 6 cm fell to 5% of frames, and on 25-77% of frames a limb sat over 35 cm from the recording: knees folded behind the hips, a foot by the shoulder. Judges said "legs hang in the air". The human bar (bjj_drawn_bars HUMAN) was added after his comment and is why the limb numbers below are worse than the first cut. They are the honest ones. Read LIMBS and HUMAN together, always.

## Bars (full match, tools/bjj_drawn_bars.gd)
| Bar | Seed 22 before | after | Seed 13 before | after | Seed 11 before | after |
| --- | --- | --- | --- | --- | --- | --- |
| Limb frames past 6 cm | 1451/1885 (77%) | 313 (17%) | 876/1351 (65%) | 271 (20%) | 5093/6881 (74%) | 1530 (22%) |
| Longest run past 6 cm (bar 0.5 s) | 11.7 s | 1.5 s FAIL | 7.1 s | 2.8 s FAIL | 22.5 s | 6.2 s FAIL |
| Depth p95 / mean | 0.180 / 0.106 | 0.125 / 0.035 | 0.155 / 0.077 | 0.146 / 0.032 | 0.183 / 0.105 | 0.134 / 0.034 |
| Held hands off her skin (bar 15%) | 57% | 20% FAIL | 50%* | 22% FAIL | 76%* | 24% FAIL |
| Limb frames over 35 cm off the recording (bar 0) | 0 | 3 FAIL | 0 | 27 FAIL | 0 | 171 FAIL |
| Floor (bar 0.04 m) | 0.021 pass | 0.060, 2 frames FAIL | 0.022 pass | 0.049, 3 frames FAIL | 0.161, 3 frames | 0.103, 22 frames FAIL |
| Torsos (bar 0.10 m) | 0.041 | 0.018 | 0.038 | 0.051 | 0.071 | 0.100 |

\* limbs on, holds off; seed 22 is limbs off. The floor on seeds 22 and 13 is a small regression from a pass.
Also new: seed 11 has a 0.75 m one-frame knee step at 143.2 s (main's seed 22 worst is 0.24 m; seed 11 not read on main).

## Trembling (tools/bjj_tremble_probe.gd, mode=match)
| | main | branch |
| --- | --- | --- |
| Pooled jerk p95 | 272 | 261 |
| Flips a joint a second | 0.70 | 0.40 |
| Hold phase jerk p95 / flips | 117 / 0.09 | 275 / 0.45 WORSE |
| Pop move / hold / miss / finish | 0.266 / 0.010 / 0.193 / 0.261 | 0.313 / 0.164 / 0.368 / 0.186 |
| Torso overlap p95 (ANA, KIM) | 0.149 / 0.150 | 0.050 / 0.103 |
| Bars failed | 7 | 8 |

Better pooled, worse while held still. Both judges who looked saw no trembling on the tight sheets, but that is sheets, not motion. Not a clean "no new trembling".

## Judges
| Film | What changed | Reviewer | Animation | Technique | Sam | Priya | Tom |
| --- | --- | --- | --- | --- | --- | --- | --- |
| S390 film 10 (baseline) | | 3 | 3 | 2 | 5/6 | 3/4 | 3/5 |
| f3 | first solver, holds, chosen lens | 3 | 4 | 2 | 4/4 | 5/3 | 3/5 |
| f4 | rigid swing, mat tap | 3 | 4 | 3 | 4/4 | 3/3 | 3/4 |
| f5 | second leg, corner in the banner, eased framing | 3 | 4 | 4 | 5/5 | 4/5 | 3/6 |

One judge each, same film stretch, so direction only. Fun did not move. Reviewer did not move.
f3 and f4: three of six judges took red Ana's armbar for Nadia's. Checked in BeltMatch and the frames: Ana is red, on her back, applying it. A misread, and a real clarity failure: the banner named no corner. On f5 nobody misread.

## Still open, from f5
Top of the list from all three: the finish has no sequence: hips never lift under the elbow, the arm never extends, Nadia stays upright, nobody reacts or releases, frozen from 1:00.1. (Hips do rise in the data; judges cannot see it.)
Snaps at 0:07.6, 0:17.6-18.0, 0:40.2: reviewer and black belt both. Easing the framing did not clear them, so they are in the bodies or moves; not diagnosed.
Contact: heads merging 0:27-0:35, forearm into face 0:46-0:50, shin into crotch 0:21-0:23, Ana's legs hanging in side control 0:31-0:38 (the recording's pose, not the solver: unverified).
Thick bodies on a thin recording: at a 0.45 rad cap some overlap cannot be cleared by limbs. Going further needs a pose-level answer (thinner fit, or per-position edits), not more solver.
GrappleFinish.gd is 573 lines (over the 500 rule before this work too). GrappleBrowser.gd 587.
Kimura (_take_grip): filmed at last (seed 13, E:/FightCamp/tmp/s391/f7, Ana wins 0:35; not judged). It does not read: the lens sits at Nadia's feet, her hips fill the frame and the lock is hidden behind Ana. The tap shows. FinishLens weighs the tap over the grip; for a grip family it should weigh the lock.
Tap: after f5 it was moved clear of her own legs (film f6, looked at, not judged): the hand rises and lands on open mat.

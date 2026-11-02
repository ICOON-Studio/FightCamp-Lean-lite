# TASK PAIRLIVE1 (S219) - the authored jab pair plays wrong in the live room (fight_pair_live red for real reasons)

Model: Codex sol (gpt-6.1-sol, NEVER astra). Own seeded worktree E:/FightCamp/wt/PAIRLIVE1, branch codex/pairlive1 from master.
Queue: after FLYFOOT1 / TECHSTAGE1 FIX5 / KM3B on the Codex seat. Never master.

## Primary source (Claude S219)
`fight_pair_live_test` was red since 2026-10-02 only because no boxer threw a head jab (NOJAB1, merged 2026-10-13). With jabs back
(seed 810039) it reads TOTAL=39 fails=5: pairs qualify 3, played 1, out_of_range 2; the landed jab at 14.10 s does not play the pair
(entered at 44.3); ONE CLOCK 1 frame off; "no foot lock, contact push or aim on a body inside its pair" 50 frames; the lead glove
off the authored spot from 4 frames before contact to 12 after (e.g. frame 40 room 0.632 vs authored 0.535 m). These are real
pair-playback defects the missing jab hid. Re-run it first and paste the red lines.

## What would a human do?
Take the one landed jab, step it frame by frame, and log which system writes each body's bones on each frame (the player, the foot
lock, the contact push, the aim) - the test already names the systems that must be OFF inside a pair.

## Do
1. Make "out_of_range" honest: log the gap at entry for both refusals vs the pair's authored gap range; if the room's spacing is the
   cause, ease to the window as the S4a notes describe (not by widening the authored range).
2. Foot lock / push / aim inside a pair: find the path that re-enables them (S4a turned them off for pair frames) - FLYFOOT1 and
   ANIMSOURCE1 also touch the foot lock; rebase on whatever of theirs is merged.
3. ONE CLOCK off by one frame: find the frame where the two playheads diverge.
4. Glove placement within 1 cm of the authored scene from contact-4 to contact+12.
6. PUNCH OUTPUT IN THE LIVE FIGHT (operator S221, verbatim: "yellow boxer [...] doesnt throw a single punch"). Claude counted the
   played strike clips in the FLYFOOT1 recordings (seed 94301, Adebayo red vs Perez blue, 60 s, as_game): red 19 strikes, blue 8
   (blue idle 78% of frames, red 66%); first 20 s: red 10, blue 2. IDENTICAL on master (master_94301.csv) - not caused by FLYFOOT1.
   CompuBox band (topics/pace_calibration.md, G99): 45-56 thrown per fighter per 3-min round = 15-19 per minute. The sim-level
   boxing_output_test passes, so compare the SIM's thrown count per fighter with the strikes the LIVE room plays for the same
   seed: find where blue's strikes are lost (never chosen, refused out of range, dropped by the pair/queue, or played as idle).
   Gate: as_game live census, 2 seeds x differentiated pairs, each fighter 13-21 strikes per minute of fight time; red first on
   master (paste the numbers). Never test identical fighters; name the population in the output.
7. `python Godot/tools/run_tests.py --jobs 2 --only pair,realism,foot_lock,jab_share,fight_moves` + fight_pair_live green.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on <the defect>; paste that number in your report.
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.

## Prior research
S4a commit 6a62ccd4 (the pair system), FightMoveScript.gd, NOJAB1 (jab_share_test), FLYFOOT1 brief (root vs feet).

## Prefab check
None - our own pair system.

## The one trap
The pair is authored for meshes f01/f09: check which bodies the room loads now (MetaHuman cast?) - a pair for the wrong meshes must
be refused and counted, never played on the wrong skeleton.

# S548 digest (2026-11-24, Fable)

## The owner's answers and orders this session (verbatim)
- Q-328 "make it more impactful" (the written plan) -> PLANIMPACT1 launched, relaunched after the PC restart.
- Q-329 "Cut it, show chemistry" (coach trial week) -> DESIGN_COACHMAP1.md; Kalli 5 / 5 / 6.
- Q-330 "Cut both" (corner ring calls) -> marked cut on DESIGN_CORNERCMD1.md.
- "can ludo or dola do the job?" / "fix both yourself, dont wait for arena" / "do 9b yourself too, dont wait for arena"
  -> card round 9 fixed and merged, round 9b slice 1 built by Claude on main.
- "Weaker version, measured" (Keep your base) -> on against a pull, off against a sweep.
- "why is memory so full , nothing is running" / "Yes, close them" -> 11 finished worker processes closed.
- "can you pause everythingfor 5monitues" / "i need freed memory" / "find why archeage is lagging so much and fix it" /
  "Close Viber only" -> cause found (kernel pool 15.3 GB after 12.3 days up); Viber closed; he restarted the PC.

## Collected
- PLANREAD2: the card's plan read follows the ring (style plan +10.6 over its bout -> +0.6); the whole-file plan still +3.6.
- CORNERBASE1: live corner +9.8 / +10.7 over a coach who reads the file; FILE coach for sims +2.6 / +6.2 (not built);
  a coach's rating buys 0 in a simmed bout.
- BODYREACT2: a landed body hook bends the hit boxer on the blow, 60 of 60; debts: the close hook is crowded, one take,
  17 of 120 men's exchanges 1 degree over. choreographer_test patched green.

## Built here
- Card round 9 on main: guard pull lands the puller on his back; the bot sits when it has no entry. Gate 6 of 6.
- Card round 9b slice 1 on main (paper first: CARDREAL_AUDIT section 9). 73 tests, gate 6 of 6, boxing 43 / jiu-jitsu 57.
  Finding: Keep your base as the critic wrote it = boxing 99.5%; all of it came from the SWEEP half.
- The trial evening's question pictures use the prospect's own body. block_meet_test out of the nightly list.
- Briefs: PLANIMPACT1, COACHMAP1 (map written by Claude), BODYCROSS4, CARDROUND9B addendum. Critic pack updated.

## Not done
No export. MATCHBOTS2 not finished (died with the restart). BODYCROSS4 not launched. Card 9b slices 2-3. Dola's coach
review not sent. The FILE coach for simmed bouts.

## Lessons
- A critic's rule is measured on 400 bot bouts before it goes on; a breakage may sit in one half of a rule.
- A legal move the bot never lays proves nothing about the move: count uses per move.
- While his game is open: one worker, one Godot. Finished worker tabs hold about 0.35 GB each until closed.
- `lite_mirror.py` needs `--lean`. The idle guard refuses a turn end with workers running: keep light work for waits.

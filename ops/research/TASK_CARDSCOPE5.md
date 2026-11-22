# TASK CARDSCOPE5 - card game round 5: make each art's own mechanic matter (P6) and the hold readable (P5) (S538)

Model: claude-fable-5-2 (headless on the API credit, ops/Tools/sdk_run.py). Node greybox only (no Godot).

## Why
Round 4 (ops/research/DESIGN_CARDGAME_SCOPE.md [R4], commit e43791485, proto/cardscope4/): FAIL 5 of 7 core bars. The wind pool
beat the owner's limb points on every clause (decided - limbs stay out). Style table 15/15 inside 41-59, bout 3.3 min.
Failing:
- P6 own mechanic: switching it off changes the pilot's turn in boxing 33.5%, karate 18.0, judo 42.9, wrestling 19.0, BJJ 5.2,
  sambo 0.0 (bar > 50 each); the blind judge names the style 52.8% (bar 90). The six arts play alike - the owner asked for six
  martial arts BECAUSE they would give depth and replay.
- P5 the hold: the pilot's answer equals the printed rule in 48.9% of held turns (bar 100): the right play waits for the last tick.
Section 8 / line ~1067 of the scope page names the next steps: (a) a mechanic that changes the line per art, (b) the hold's
printed rule reworded and the pin made worth its room.

## Do
1. Copy proto/cardscope4 to proto/cardscope5 (keep 4 as the record). Bars unchanged (P1-P6, P10, D1 as in section 4d) -
   written before the run, not loosened.
2. P6: redesign each art's own mechanic so it changes WHAT you play, not a number - one per art, boxing-/sport-true (e.g. boxing
   combinations that chain cheaper only in punch range; karate's in-and-out that scores only from kick range and forces a
   range change; judo's grip that must be won before any throw; wrestling's chain that turns a stuffed shot into the next;
   BJJ's position ladder where a submission is only legal from the right rung; sambo's throw-to-lock in one turn). FREE HAND
   (owner S534): cut, add or interconnect. Re-run P4 after (the table must stay inside 40-60).
3. P5: make the printed rule the true best answer (reword it, or change the hold so waiting is not better), and give a pin a
   reason to be taken.
4. Re-run the full core set; update the scope page as round 5 (form, table, what changed and why, what was cut) and the turn
   mockup if a card face changed.
5. PASS: write ops/research/CARDSCOPE5_CRITIC_BRIEF.md (fresh critic: opens with OWNER_CARDGAME_INTERVIEW_S537.md + the scope page,
   never an earlier score; DEPTH / PLAY / GENERAL /10; reads the greybox code; the list to reach 10 and a drawn 10/10 page) and
   queue Kalli: `python ops/Tools/seat_queue.py add --seat kalli --brief research/CARDSCOPE5_CRITIC_BRIEF.md`. Do not score your
   own work; the code-checked second critic is Claude's to launch.

## Prior research
ops/research/DESIGN_CARDGAME_SCOPE.md (3S, 4d, 6d, 8), OWNER_CARDGAME_INTERVIEW_S537.md, CARDREF2_MARTIAL_ARTS.md sections 1, 6.

## What would a human do?
Give each art the one thing its fighters actually do differently, so a judo player plays judo.

## Prefab check
None.

## Contract
OWNS: proto/cardscope5/ (new), ops/research/DESIGN_CARDGAME_SCOPE.md, ops/research/CARDSCOPE5_CRITIC_BRIEF.md
RED_TEST: proto/cardscope5/engine.test.mjs (node --test)
REGRESSION: none (standalone)
VISUAL: no

## Rules
No script over 500 lines. node only, long probe output to a file. Commit only your paths (`git add -- <new>` then
`git commit -m ... -- <paths>`), end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, push, report in two lines, stop.

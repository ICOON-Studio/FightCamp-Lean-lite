# TURNPRO17 - turning pro v17: the owner's design (when + how), one clean map and a quick greybox probe (S542)

Kind: design + probe. Model: claude-opus-5-5 (Code Mode tab). Commit only your paths (`git commit -m "..." -- <files>`), do not
push. Godot only through `python ops/Tools/godot_slot.py run --who TURNPRO17 -- <cmd>` (headless, Dummy audio), ONE run at a
time; long runs write to a file and you wait on the done line (a killed waiter leaves Godot running: check by PID). Before each
run: `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; RED = wait; the owner's game
(ArcheAge) in the top list with memory AMBER = wait. Two other workers share the Godot queue (BODYCROSS1, COACHDEEP6).
Estimate: 2-3 hours. This is a QUICK probe: size it to finish in under 40 minutes on one slot (time one cell first).

## Why
Sixteen design rounds failed the 8 bar (TURNPROBE16 FAIL 11/16). The owner was interviewed (S541, 15 answers, all yes):
`ops/research/TURNPRO_INTERVIEW_S541.md` is the spec. In S542 he was walked through the rules with numbers and answered
Q-S294-320 "Yes, build it": `ops/research/TURNPRO17_RULES_S542.md` is what he approved. v17 is NOT a patch of v16: the moment
is about WHEN he turns pro and HOW his first six fights are picked; the promoter is background. Layers only get removed.

## Do
1. `ops/research/DESIGN_TURNPRO1_V17.md`: one clean document from the two pages above, nothing carried from v1-v16 unless
   the interview keeps it. It holds:
   - WHEN: the offer line as built (`scripts/state/Roster.gd` pro_ready: 7 wins + top 3, or 9 wins); the pop-up Turn pro
     now / Not yet; patience as 3 marks; "Not yet" twice (about 4 weeks each, hunger -15), the third time a rival gym comes:
     turn pro now or lose the boxer for good. Replaces today's rule in Roster.decline_pro / pro_ready (+2 wins a decline,
     terms x 0.9, after two only at rank 1).
   - HOW: pro fights 1-6 each offer two bouts, SAFE (75-90% to win, today's purse, name +1) and RISKY (40-55%, double purse,
     name +3), both chances printed honestly; after fight 6 the normal booking (`scripts/state/ProLadder.gd`) takes over. Say
     how the two bouts are made from what the game already has (ProLadder's tune-up 0.70-0.93 and step-up 0.5 reads).
   - TWO BARS, 0-100: CONFIDENCE (start 50; safe win +4, risky win +12, points loss -10, knockout loss -30; moves the win
     chance by at most 5 points either way) and HUNGER (start 70; safe win -8, risky fight +10 win or lose, each "Not yet"
     -15, four weeks without a fight -5; at 0 the boxer asks to leave: two warnings, then gone).
   - Every number tagged ESTIMATE with its real-world reason (how pro debuts are matched, why prospects stall or walk).
     These are the owner-approved starting numbers: the probe may tune a number, with the before/after written in the map,
     but may not add a rule, a bar on the boxer, or a choice.
   - CUT, by file: the second promoter house, the five asks and counter-offers (`scripts/rules/ProCall.gd` asks, the wire
     that makes two houses), favours, home nights, favour title shots. A table: what is deleted, what shrinks, what stays
     (the gym's purse share and the name from wins stay as built; no new money rules).
   - A table of every menu it appears on and what each is wired to (owner S425): the pro offer pop-up; the boxer card
     (patience, confidence, hunger); the booking screen of fights 1-6 (safe and risky side by side); one result-page line.
     Plain game words; names only in headers; no he/she in game text.
   - Boxing only, men and women alike; the BJJ fighter keeps its own road.
2. Bars, written in the map BEFORE any run, never loosened (the owner: bots only check nothing is broken; depth and fun are
   his play + two critics at 8):
   - (1) No habit - ALWAYS SAFE, ALWAYS RISKY, ALWAYS WAIT (both "Not yet"s, then safe), TURN NOW + ALTERNATE - is the best
     arm in more than 6 of the 10 boxer types.
   - (2) The READER (picks by the printed chances and the two bars, no hidden numbers) beats every habit by more than 2
     standard errors in at least 5 of the 10 types.
   - (3) Both bouts are alive: the reader takes SAFE in at least a quarter and RISKY in at least a quarter of all fights 1-6.
   - (4) Waiting is a real question: the reader's best line says "Not yet" at least once for at least 2 types and never
     for at least 2 types.
   - (5) Mistakes are felt: ALWAYS SAFE or ALWAYS WAIT loses the boxer (hunger 0 or the rival gym) in at least 2 types; the
     reader loses the boxer in at most 1 of 10; a knockout loss in pro fights 1-3 leaves a measurable mark on fights 4-6.
   - (6) Nothing runs away: confidence's shift of the win chance never passes 5 points; both bars stay inside 0-100.
   Write ONE score before the run, with its reason (the boxer's standing after fight 6: still at the gym, record, name,
   confidence), and print its parts apart so no part hides behind another.
3. Probe `tools/turnprobe17.gd` (+ `tools/turnprobe17_rules.gd`, a summary script if needed), a GREYBOX: the rules above as a
   small pure module, the game's own numbers read from the game's modules where they exist (never copied by hand). TEN BOXER
   TYPES that differ in stats (the key is `stats`), techniques, frame and plan - never two identical fighters; men and women,
   each against their own sex and weight class; the population named in the output. Result `docs/TURNPROBE17_RESULT.md`.
4. PASS -> `ops/research/CRITIC_TURNPRO1_V17_BRIEF.md`: opens with `ops/research/CRITIC_PACK.md` and
   `ops/research/CRITIC_ACCESS.md`; gives the game and the v17 rules, never an earlier score or our own opinion; asks DEPTH
   and PLAY out of 10 (the bar is 8 on both), which options are missing or useless and what each changes, the list of changes
   to reach 10 (most important first), and the critic's own 10/10 drawn as a 1920x1080 HTML page. Queue it for kalli and dola:
   `python ops/Tools/seat_queue.py add --seat <seat> --brief research/CRITIC_TURNPRO1_V17_BRIEF.md`. Write in the result that
   a code-checked critic is still owed (the coordinator launches it).
   FAIL -> which bar, what one change would fix it, stop. No second design round in this task.
Nothing under scripts/ changes in this task: the build comes after the critics.

## Feedback loops
- Confidence -> win chance -> wins -> confidence. Cap: the shift is at most 5 points and the bar stops at 0 and 100. Trial
  check: the win chance printed for fight 6 is within 5 points of the same bout at confidence 50.
- Knockout loss -> confidence -30 -> lower chance -> another loss. Cap: the same 5 points; print the longest losing run.
- Hunger -> leaves. One-way sink, fed back only by the player's own picks (risky fights raise it). Print hunger after each
  of fights 1-6 per arm.
- Name -> ? In fights 1-6 the name must NOT change the two offers' chances (after 6 the normal booking reads it). Say so in
  the map; if the code path differs, cap it or say why not.
- Purse -> cash: no rule in this mechanic reads cash back. Say so.
- ONE-REP TRIAL FIRST: one career per boxer type per arm, printed in full, before the sized run. STOP and fix the map if a
  bar leaves 0-100, if every type converges on the same best arm, or if any arm never loses a fight.

## Prior research
`ops/research/TURNPRO_INTERVIEW_S541.md` (the spec), `ops/research/TURNPRO17_RULES_S542.md` (approved numbers),
`docs/TURNPROBE16_RESULT.md` (why 16 failed: the honest card solved the decision), `ops/research/DEPTH_AUDIT_S534.md` (five
maps passed at 7+ and failed when measured). Run `python ops/Tools/prior_research.py pro debut matchmaking prospect` and name
the real-world study behind the safe / risky numbers.

## What would a human do?
A manager with a new pro picks the first six opponents himself: mostly men he should beat, one or two real tests to find
out what he has. Too soft for too long and the prospect goes flat or signs elsewhere; too hard too early and one bad night
sets him back a year. The boxer wants money and a name now; the gym wants him ready.

## Prefab check
None (a rules probe on our own modules).

## Contract
OWNS: ops/research/DESIGN_TURNPRO1_V17.md, tools/turnprobe17.gd, tools/turnprobe17_rules.gd, tools/turnprobe17_sum.py, docs/TURNPROBE17_RESULT.md, ops/research/CRITIC_TURNPRO1_V17_BRIEF.md
RED_TEST: tools/turnprobe17.gd
REGRESSION: none
VISUAL: none

Do not ask questions: decide, and write what you decided in the result.

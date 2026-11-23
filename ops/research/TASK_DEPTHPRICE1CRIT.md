# DEPTHPRICE1CRIT - a code-checked critic of the two priced choices (fight-week load; sponsorship or a day job) (S543)

Kind: research. Model: claude-opus-5-5 (Code Mode tab). Commit with a pathspec (`git commit -m "..." -- <your file>`), do
not push; touch only your file. RESEARCH ONLY - no game code changes, do not run Godot. Estimate: 40 minutes.

## Your job
Read `ops/research/CRITIC_DEPTHPRICE1_BRIEF.md` - the full critic brief (the critic pack, then the page
`ops/research/DESIGN_DEPTHPRICE1.md`). Do exactly what it asks, for EACH of the two choices (the two SCORE lines, missing
and useless options, "To reach 10/10", your 10/10 page of each as one HTML code block), plus what a chat critic cannot do:
1. CHECK EVERY CODE CLAIM on the page against today's tree (`scripts/rules/FightWeek.gd`, `scripts/rules/DayJob.gd`,
   `scripts/ui/modals/FightWeek.gd`, `scripts/ui/OfficeDesk.gd`, `scripts/ui/MoneyPanels.gd`, `scripts/state/GymSpend.gd`,
   and whatever they call): TRUE (file + function + line) / FALSE (what the code does) / NOT FOUND.
2. CHECK THE TWO PROBES: `tools/depthprice1a_probe.gd` + `tools/depthprice1a_report.gd` (row 21) and
   `tools/depthprice1b_probe.gd` (row 15), against `docs/DEPTHPRICE1A_RESULT.md` and `docs/DEPTHPRICE1B_RESULT.md`. Does
   each probe play what the page says? Could its bars (3 wins in 100 or real money; no option best in more than 6 of 10
   cells) pass by construction or by noise (row 15's gap is 2.9 wins in 100 against about 2 of noise)? Are the cells
   really different, or one cell ten times?
3. For each choice say plainly which of these is right, with the evidence: BUILD the price as measured; CHANGE it (name
   the change, tied to a state the player can see or to another mechanic that exists in the code - give file and
   function); or CUT the choice (the game picks for the player) and what would be lost.
4. Score what is measured, not what is promised. The bar: 8 DEPTH and 8 PLAY (owner S534).

## Deliverable
ONE new file `ops/research/DESIGN_DEPTHPRICE1_CRITIC_OPUS.md`, ending with the list of code files you opened.

## Feedback loops
None: a read-only review; nothing in the game or a probe changes.

## Prior research
`ops/research/DEPTH_AUDIT_S534.md` (rows 15 and 21), `ops/research/DEPTH_SCOPE_S534.md`, the two results above,
`ops/research/FIGHTWEEK_SCREEN_V1_CRITIC_JOHN_JOHN.md` (an earlier look at the fight week screen).

## What would a human do?
Open every cited line before believing it; ask whether a real amateur coach would ever weigh these options, and whether
a player would notice the difference in a season.

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_DEPTHPRICE1_CRITIC_OPUS.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: none

Do not ask questions: decide, and write what you decided in your file.

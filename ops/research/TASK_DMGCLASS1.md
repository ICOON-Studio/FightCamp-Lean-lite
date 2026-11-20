# TASK DMGCLASS1 - write the stoppages-by-weight-and-sex design map v1 FROM THE CODE

Kind: research (design map)
Status: OPEN (S532, Claude main). Discipline: boxing. Model: Arena (cloud). Work on FightCamp-Lean-lite main, your own
arena/ branch, a PR into main there; never merge. RESEARCH ONLY - no game code changes. Do not run Godot.

## Why
Today a stoppage is decided the same way for a flyweight woman and a heavyweight man. Real boxing is not like that. Dola's
research (`ops/research/RESEARCH_STOPS_BY_CLASS_SEX_BRIEF_DOLA.md`, SQ257, with sources and where the data is thin):
- men's pro: heavier classes stop more; heavyweight about 1.4x lightweight;
- women's pro: about 0.45-0.5x the men's rate in the same class;
- amateur: about 1/6 to 1/5 of the pro rate (England Boxing / BJSM, 3x3-min rounds, headguards in some codes);
- 4-6 round early pro bouts: about 0.85x the base pro rate.
Owner scope (CLAUDE.md, S428 and the fixture rules): women never fight men; booking matches weight class; one ruleset per
sex, never mixed.

## Your job
Write `ops/research/DESIGN_DMGCLASS1_V1.md`: how weight class, sex and amateur/pro change how often fights are stopped and
how hurt a boxer gets, in THIS game. Inputs: the research file above; `ops/research/topics/knockdowns_stoppage.md` and
`ops/research/topics/body_damage.md`; the game pack `ops/research/CRITIC_PACK.md`.
RULES (owner S530 METHOD: "each next version is written from the code"):
1. Section 1 "what the game decides today" is written ONLY from code you opened. Find EVERY place a stoppage, a knockdown,
   the hurt state or a stopped loss is decided or shown, e.g. `scripts/rules/Matchmaking.gd` `stop_chance` (the offer's
   stoppage risk), `scripts/state/RingDuel.gd` (hurt), `scripts/rules/BoutRules.gd`, the bout finish and result code,
   injuries after a stoppage (`Injuries`), the pro ladder offer rows (`ProLadder.gd`, `ProFights.gd`). Every line tagged
   CODE names file + function (+ line) and is TRUE today. Anything not in the code is ESTIMATE (a proposal) or CUT.
2. Measure before proposing: say how the code would let us read today's stoppage rate per class and sex (which probe or
   test already prints it - search tools/ and tests/ - or the smallest new probe to write), so the multipliers are checked
   against a measured baseline, never stacked blind.
3. The proposal: ONE place in the code where the class/sex/amateur factor is applied (name it), the table of factors
   (each ESTIMATE, sourced to the research), and every menu that must SHOW it (offer card stoppage risk, the coach's read,
   the result's "what decided it", the medical rest after a stopped loss) - a table: menu | CODE TODAY | TO BUILD.
4. Depth target 7+: what the PLAYER decides differently because of it (booking a heavier class, a heavy hitter in the
   other corner, a women's division where decisions dominate, the towel, the medical rest) and which number each choice
   changes. No dominant pick.
5. Plain words; names only in headers; numbers that are not in code say ESTIMATE.

## Deliverable
ONE new file `ops/research/DESIGN_DMGCLASS1_V1.md` and in the PR body: the list of code files you opened. A PR that adds
only that file.

## Contract
OWNS: ops/research/DESIGN_DMGCLASS1_V1.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
RESEARCH_STOPS_BY_CLASS_SEX_BRIEF_DOLA.md (SQ257); research/topics/knockdowns_stoppage.md; research/topics/body_damage.md;
guard damage v4 (owner Q-275: "Yes, build it after turning pro").
## What would a human do?
A boxing analyst pulls the finish rates per division from BoxRec, then asks the game designer where the one dial is that
makes a heavyweight night feel dangerous and a women's flyweight night a points battle.
## Prefab check
None (a design map).

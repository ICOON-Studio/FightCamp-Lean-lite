# TASK DMGCLASS1REV2 - rewrite the stoppages-by-weight-and-sex map v2 FROM THE CODE

Kind: research (design map)
Status: OPEN (S532, Claude main). Discipline: boxing. Model: Arena (cloud). Work on FightCamp-Lean-lite main, your own
arena/ branch, a PR into main there; never merge. RESEARCH ONLY - no game code changes. Do not run Godot.

## Why a v2 (Claude's review of v1, S532)
`ops/research/DESIGN_DMGCLASS1_V1.md` read the right files but put the dial in the wrong place. Fix these, in order:
1. WRONG DIAL. `Matchmaking.stop_chance` only feeds the stoppage number SHOWN on pro offer rows (ProLadder.offer_axes,
   ProFights._row). It decides nothing. A factor there would make the screen lie: the shown risk would change, the fights
   would not. Find where a bout is ACTUALLY stopped and a boxer actually knocked down / hurt: `scripts/rules/Knockdowns.gd`
   (e.g. `puncher_chance`), `scripts/state/BoutNight.gd` (e.g. `count_sides`), `scripts/state/RingDuel.gd` `settle`
   (hurt), `scripts/rules/PerkFight.gd` / `CounterCut.gd` (stoppage kinds), `scripts/state/BoutFinish.gd` /
   `AfterFight.gd` (how "stopped" is recorded). Tests that pin these: `tests/stop_mult_test.gd` and any test grepping
   `stopped`. The factor goes where the stoppage is decided; the shown number then reads the SAME factor.
2. NOT A CHOICE. A boxer's weight class is her body (ProLadder.division_for maps sex + limit); the player does not
   "select a limit". Find what the player really decides that a class/sex factor would change (which offers to accept,
   the opponent's power, the towel - FightPrep towel_row careful/normal/brave, pulling out hurt, rest between bouts, the
   plan's defence lines) and check in the code whether a class change (moving up or down) exists at all; if not, say so.
3. MEASURE FIRST. v1 named no measured baseline. Write the probe SPEC (do not run it): a headless tool under tools/
   that plays N bouts per (sex x class x amateur/pro) through the SAME function the game uses (name it) and prints the
   stoppage share per cell, so the factors are fitted to a measured base, never multiplied on top blind. Say which
   existing probe in tools/ is closest to copy.
4. NO NONSENSE MULTIPLIERS. Medical rest and injury days follow the damage taken in the bout, not the class factor
   (v1 had a women's amateur stoppage loss resting 0.5 weeks). Keep the factor to how OFTEN fights are stopped and how
   HARD punches land; rest stays what the damage ledger says.
5. Plain words, no pronouns for the player's boxer in body text ("your boxer", "the opponent"); names only in headers.
6. Keep from v1: the research table (Dola SQ257, with its sources and thin-data notes), the menu table (menu | CODE TODAY
   | TO BUILD) - corrected so each row's CODE TODAY is true.
Depth target 7+ (owner S425): at least three real player choices whose numbers the factor changes, no dominant pick.

## Deliverable
ONE new file `ops/research/DESIGN_DMGCLASS1_V2.md`; in the PR body the list of code files you opened. A PR adding only it.

## Contract
OWNS: ops/research/DESIGN_DMGCLASS1_V2.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
DESIGN_DMGCLASS1_V1.md (this review); RESEARCH_STOPS_BY_CLASS_SEX_BRIEF_DOLA.md (SQ257); research/topics/knockdowns_stoppage.md.
## What would a human do?
A fight-sim programmer finds the one roll that ends a fight, measures it per division, then tunes it to BoxRec's rates.
## Prefab check
None (a design map).

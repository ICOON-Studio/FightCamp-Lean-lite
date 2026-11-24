# PLANIMPACT1 - the result page checked against its own table and the code (S549, Claude; read-only)

For the session that collects `docs/PLANIMPACT1_RESULT.md`. Nothing was run again: this is arithmetic on the page's
table and three greps. The raw runs (`E:/FightCamp/tmp/planimpact1/`) were not re-summed.

## The page's own numbers hold
| Claim on the page | From its table | Holds |
|---|---|---|
| With lever 2 the plan adds 6.5 to 7.4 over no plan (live corner) | reader:C L2 81.6 - reader:none 75.1 = 6.5; 84.6 - 77.2 = 7.4 | yes |
| Today the same plan adds 1.4 to 2.0 | 77.1 - 75.1 = 2.0; 78.6 - 77.2 = 1.4 | yes |
| The live corner stays worth 15 to 20 over the file coach | 81.6 - 66.8 = 14.8; 84.6 - 64.8 = 19.8 | yes |
| Best plan - coach's plan, both with lever 2: +4.5 / +6.0 | 81.6 - 77.2 = 4.4; 84.6 - 78.6 = 6.0 | yes |

## The code lines it names hold
- `scripts/rules/PlanBoard.gd` `validate` (l.27, "Check for duplicate places" l.56): one line a place today.
- `tools/cornercmd2_rules.gd`: a command's grade comes from her mastery (GRADE2 l.75); the plan is only the base call
  edge (l.311). The plan plays no part in how well a command is carried out.
- `tools/planimpact1_rules.gd` `raise` (l.83): lever 2 is one grade up, MULT equal to GRADE2.

## What the page's wording hides (the reading to take to the owner)
1. **Lever 2 mostly pays for HAVING a plan, not for a good one.** The no-plan arm cannot get the bonus. A careless plan
   with lever 2 is 79.3 / 83.7: that is +4.2 / +6.5 over no plan. The best plan is 81.6 / 84.6. So choosing well is
   worth **2.3 at 3 rounds and 0.9 at 6 rounds** - smaller than today's 2.0 / 1.4 at 6 rounds. The page says this in
   one clause ("a careless plan also gets the bonus"); it is the main result, not a footnote.
2. **Lever 2 is a corner buff.** The corner's worth over the file coach goes from +10.0 / +12.4 to +14.8 / +19.8. That
   keeps "depth stays in the corner", but it makes the live corner even more the whole game.
3. So the page's "Decision: lever 2 goes to a second probe with one narrower rule" should be held to a bar the first
   probe did not set: **best plan - careless plan, both with the lever, 6 or more in most boxers**. Without it
   PLANIMPACT2 can pass by handing every plan the bonus.
4. Kalli's change (a) on the coach map (the corner coach's tactics = how well the boxer hears the call) is the same
   lever with a different owner (the coach instead of the plan). Read both before the coaches page: one rule should
   not be sold twice.

## Not checked
The paired +-2 SE figures, the per-boxer rows, the control's "5400 of 5400 identical" (taken from the page), and
whether the narrowed mapping (80.7% of commands raised in the trial) was the only change between trial and full run.

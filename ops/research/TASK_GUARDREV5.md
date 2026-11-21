# TASK GUARDREV5 - write the guard damage map v5 FROM THE CODE, carrying John's 10/10 ideas the owner liked

Kind: research
Status: OPEN (S533): Goose #432 failed (1h48, no file); now the DEBUTPICK1 Fable session. Discipline: boxing. Model: Fable session in this checkout.
arena/ branch, a PR into main there; never merge. RESEARCH ONLY - no game code changes. Do not run Godot.

## Why
Guard damage v4 is BUILT (S524-S525: the guard bar, wear, the leak through the guard, clinch / Hands up, habits, the corner
line). John's critic (`ops/research/GUARDDMG1_V1_CRITIC_JOHN_S533.md`, scored the v1 map 6/5/6) drew a 10/10 fight-night page
and the owner said (S533): "john has some nice ideas in his render". Most of that page is not in the game yet.

## Your job
Write `ops/research/DESIGN_GUARDDMG1_V5.md`:
1. Section 1 "what the game does today" ONLY from code you opened (scripts/rules/GuardWear.gd, GuardNotes.gd, Exchanges.gd,
   CornerCard.gd, CornerJobs.gd, scripts/fight3d/BarGuard.gd, HudBars.gd and whatever they call). Every CODE line names file +
   function (+ line) and is TRUE today; anything else is ESTIMATE or CUT.
2. Go through John's "To reach 10/10" list (11 points) and his 10/10 page one by one: for each, already built (CODE ref) /
   take it (how, which numbers the fight already uses it changes) / refuse (one line why). His page items: the guard bar
   cracked with a BROKEN tag and the guard by round; the coach note that says WHY the guard broke ("the opponent has gone to
   the arms since round 4: 112 on the guard"); landed counts Head / Body / On the guard (and how many got through); corner calls
   that each show their PRICE (Clinch and reset: stops the leak for 6 s, guard +4, warning risk 1 in 8; Move, don't cover;
   Hands up; Fire back; Body first); the referee's look gauge; "Next big shot on the guard: hurt 1 in 6"; a Why? link.
   Also on his rendered page (the owner sent the picture, S533): under the guard bar one line saying what the state means
   ("Half of every blocked punch gets through · 1 in 3 lands clean and scores"); a timed event strip under the counts
   ("1:15 big right hand on the guard · 1:14 guard under 20 · 1:13 next big shot on the guard can hurt"); under the corner
   calls what the tape says about the opponent ("From the tape: heavy hands · goes to the arms when ahead"); "One call. It
   lasts until the bell."; bars coloured only when at risk. Say for each whether today's fight night shows it.
3. Keep the owner's rulings: the 3D fight never decides, it shows the settled round; names only in headers; only actionable
   information on screen; every number read from the rule; amateur vs pro differences stay.
4. The table of every menu the mechanic appears on and what each is wired to, with CODE TODAY vs TO BUILD.
5. Depth target 7+ on DEPTH and GENERAL DESIGN: covering must be right against a light hitter and wrong against heavy hands;
   no dominant corner call; each call changes a number the round already uses (name it).

## Deliverable
ONE new file `ops/research/DESIGN_GUARDDMG1_V5.md`; in the PR body the list of code files you opened.

## Contract
OWNS: ops/research/DESIGN_GUARDDMG1_V5.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
GUARDV4 (roadmap): DESIGN_GUARDDMG1_V3.md + its critics (John, Dola); GUARDDMG1_V1_CRITIC_JOHN_S533.md.
## What would a human do?
A cornerman watches the arms go and tells his boxer exactly what it costs to keep covering.
## Prefab check
None (a design map).

# S369 playtest - two boxers + a BJJ athlete, played as a planning game (Claude, in the exe)

Operator on run 1: "that was no playtest, you didnt get a second fighter, you didnt use any of the game features to make a
plan, the scouting should be more impactful for the players understanding, how to plan for the fight". Run 2 below plays
the planning game. Build: branch claude/bjjmatch1 exe (a978816). Career Mon 5 Jan -> Sat 14 Mar 2026. Stills:
ops/previews/S369_playtest/ (01-14, local only).

## What I did (run 2)
- Recruited through Fighters > Scouting: three prospects as text rows with scouted ranges; invited Tess Reilly (23,
  middleweight pressure fighter, 6-4) to a trial; signed her ("Sharpen the signature").
- Lucy: offer vs Priya Nair (6-1, counter-puncher). Read the file, accepted, camp (technique + film), built the Playbook game
  plan against her, watched both tapes in the tape room (answered the Game film, SPOTTED the Weakness tell). A short-notice
  twist then swapped Priya for Erin Doyle (8-2, volume puncher).
- Tess: offer vs Amy Croft (5-5, pressure fighter), camp (conditioning + film), her own plan; fought LIVE, every round,
  calls on the read, two corners -> split decision win 29-28 29-28 28-29.

## The scouting -> plan -> fight chain, link by link
| Link | What the game does | Verdict |
|---|---|---|
| Offer | File shows record/look + her GAME ("waits to counter"); best weapon, habit, weakness locked "?" | Too thin to decide on; no way to learn more before saying yes |
| Film in camp | Unlocks best weapon, then habit, weakness (Priya: right hand over the jab / takes a round / slow to start) | Works, but the file lives on the fighter page > Camp tab only |
| Tape room | 3D film of her past bout; THE FLOW builds as you watch; THE TELL; SPOT game; "Your answer" (double jab) | The best scouting screen - genuinely teaches how she fights |
| Tape -> plan | Answer "Not in the plan yet: pick one. 6 of 6 arrows" - clicking does nothing, no "replace", no why | BROKEN LINK: what I learned cannot enter the plan |
| Plan board | Rates each line vs her GAME archetype only (+7 vs Priya; same plan -8 vs "boxes at range") | Ignores everything the film unlocked; no round dimension ("slow to start" has no answer) |
| Swap twist | "The tape study starts again" - yet Erin's file was 3/3 full on day one | Scouting cost nothing; the twist had no planning bite |
| Fight | Plan line plays when the exchange reaches its range card ("Plan: Step back", "Plan: Double jab") | Plays, but invisible: two jabs look like any jabs; one caption at exchange start |
| Result | "WHAT DECIDED IT" + THE PLAN, LIT UP: "Long range - Double jab 7/10", "Tie up 2/4" | The payoff exists, hidden behind a button |

**So the player never SEES the plan working in the ring, and what the tape teaches never reaches the plan.**
Operator: "it doesnt show double jab in the fight" - correct: it was thrown 10 times (7 won) and nothing on screen said so.

## Findings, worst first
1. The tape's answer cannot be added to a full plan (6/6 arrows): dead click, no replace, no message. (09)
2. The plan board rates only the archetype, never the unlocked weapon/habit/weakness; no round-by-round line, so "slow to
   start" / "fades after round 2" (her weakness) have nothing to plan with. (10, 11)
3. The plan is invisible in the fight: no "PLAN: DOUBLE JAB - won" beat, no counter on screen; only the result's hidden
   flow map shows 7/10. (14)
4. Double jab beats every pressure/counter type at long range (+8 / +10): one dominant answer -> same plan for everyone.
5. Corner collapses into "1 THE MINUTE / 3 PICK THE PLAN / Your call ..." - steps vanish, numbering skips 2, the
   recovery/talk picks are not summarised (operator: "i dont understand this"). (12)
6. The fight ring HUD (energy / condition / guard arcs) has no numbers - in round 3 I could not tell Tess was the more
   tired (26 vs 30 at the bell) and pushed her into losing the round. (13; operator: "also add numbers here")
7. Shout attribution names the wrong call ("not because of 'Let your hands go'" after I shouted "Breathe").
8. Templates show: both wins 29-28 29-28 28-29; "fades after round 2" for two opponents; the coach's "get inside and go to
   the body" corner line word for word in both fights; a twist repeated word for word.
9. Swap twist: "the tape study starts again" but the new file is full at once.
10. Clinch camera: a head hidden / the lens behind Tess (CAMCLINCH1 is on it). Review panel blanks its lower half after
    a twist pick until re-scrolled. The W/L strip does not say which end is newest.
11. BJJ: Ana is a text row on Roster / missing from Training, Offers and the 4-week strip; her gold IS in the review as a
    sticky (run 1 said it was missing - wrong, I had not scrolled); her body gains are not in the review.

## What worked (keep and build on)
- The tape room (film, flow, tell, SPOT) - the scouting the operator wants is already half built here.
- Live calls on the read: "It worked: 'Hands up, move your head' won Tess those 30 seconds"; the read meter + TAKE IT NOW.
- Corner "FIXED: last round's fix never came up", then the unfixed habit punished in round 3 - a real choice with a cost.
- Round summary per 30 s with my shouts marked; WHAT DECIDED IT; THE PLAN, LIT UP.
- Two boxers' face cards side by side on Training / Offers (today's UI).

## Proposal: make scouting the planning (for the operator's OK)
1. **Tape -> plan in one click**: the tape's answer replaces the line it answers (shows "replaces One-two"), plan full or not.
2. **The plan board reads the file**: every unlocked fact becomes a rated line ("her best weapon: right hand over the jab ->
   your one-two at long range walks into it -6"), and a ROUND row (R1 / R2 / R3) so "slow to start" and "fades after round
   2" can be planned (start fast / save it for round 3).
3. **See the plan in the ring**: when a plan line fires, a corner caption + a tick ("PLAN: DOUBLE JAB - landed, 4/5"), and
   the corner shows "your plan so far: double jab 4/5, step back 1/2" before you pick the next round's plan.
4. **Scouting costs something**: the file opens one fact per film session; a short-notice swap really resets it.
5. **Numbers on the ring HUD** and a readable corner summary - building now (operator asked).

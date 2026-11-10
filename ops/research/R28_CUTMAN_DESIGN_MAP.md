# R28 Cutman - design map (S423)

One of the seven mechanics the operator chose (S402: "R28 Cutman: a closing eye, stop it or go on"). Per his rule (Q-173:
"what the player decides exactly and where does that happening? which screens?"), this is the map before any build.
Picture: docs/mockups/s423/cutman_10_coach.png (v2, the coach critic's 10/10). v1's picture: cutman_corner.png.

## What is true today (read in code, S423)
- Eyes, nose and cuts are tracked on the body map (BodyMap.gd: bands fine > 55, hurt, critical <= 35, doctor <= 15), but the
  map only feeds the picture: no result reads it. A closed eye changes nothing.
- The 3D corner has a cutman row (enswell an eye, close a cut, nothing), on PRO nights only (CornerOverlay, S396).
- The eye numbers are wrong for play (tools/eye_band_probe.gd, 300 bouts): a critical eye for the loser in 2% of 3-round
  bouts but 86% of 6-round bouts. Too rare where the game starts, everywhere later.
- The cutman on staff: $150 a pro night, halves post-bout layoffs.

## The decision the player makes (v2, after two critics; v1 is in git)
Two critics (a corner coach and a management-sim veteran, both from CRITIC_PACK) scored v1: depth of decision 4 and 5. Their
faults, both agreeing: the cutman always won the "who works the eye" row; "Send out" always beat "Pull out" (a chance against
a certain loss); v1's lift took the eye from 28 to 38, above the closing line, so stop-or-go stopped making sense. v2 is the
coach critic's 10/10 drawing (docs/mockups/s423/cutman_10_coach.png), which fixes all three:
1. THE CUTMAN HAS ONE JOB IN THE MINUTE, picked from the problems the boxer brings back:
   - **The eye: ice and enswell.** The swelling stops growing: next round's eye loss is halved (28 stays closing, about 34).
   - **The cut: adrenaline and pressure** (pro; an amateur corner needs an accredited cutman, England Boxing 2.4.1). The
     bleeding stops; a punch landed on it reopens it (1 in 3 a round).
   - **The coach takes the second job**: half strength and it uses the corner's one change. Never the cut.
   So with two problems the minute is a trade, not a lookup. Without a cutman on staff only the coach row exists.
2. STOP OR GO (eye closing at the bell; below a divider; never pre-selected; Ready waits for it), each with its WIN CHANCE
   for the rest of the bout from the cards so far and the edge with one eye (the game's own numbers, "not a promise"):
   - **Pull the boxer out**: win 0%, loss on the record, the tournament is over; the eye is safe, back training in 1 week,
     and a boxer who wanted to go on trusts the corner less only if it was pride talking (see 3).
   - **Send the boxer out**: e.g. 31%; doctor stops it 1 in 6 (driven by sight: under 25 the doctor stops it); +25% punches
     land on the blind side; a lasting cut 1 in 5 (out 3-4 weeks, "Marks easily"), worse with every punch landed there.
   - **Send out and work off the blind side**: e.g. 28%; blind-side hits +10% instead of +25%, the boxer's own output -10%,
     uses the one change.
   The stakes stand at the top (e.g. "Regional quarter-final"): pulling out of a club show and of a title bout differ.
3. THE BOXER HAS A SAY: one line in the boxer's words ("I'm fine, coach. One more round."), with trust: Heart and morale
   decide whether it is pride or truth, shown as a number on hover.
4. AIM (in the round, already a standing order): when the OPPONENT's eye is closing, Aim offers "The cut eye"; the other
   corner faces the same card.

## Where it happens (screens)
- **Corner minute** (3D CornerOverlay and the words corner): a new EYE card on the boxer's side: the eye's band and number,
  what it lost this round, then the three workers, then the stop-or-go row under a divider. Picture: cutman_corner.png.
- **Live fight** (FIGHTDISPLAY2 side panel): the worst-place tag "EYE x" and the closing-eye band on the holo, for both
  boxers; the opponent's eye shows only what the corner can see.
- **Staff (Club > People)**: the cutman card says "Accredited: works amateur and pro corners" and the price.
- **After the bout**: The Why gets one line ("The left eye closed in round 2; sent out; 9 punches landed on the blind side")
  and the injury report shows the cut and its layoff.

## What it changes, and by how much
| What | Number | Anchor |
|---|---|---|
| Who may treat a cut in an amateur corner | only an accredited person; so no cutman = no cut work, only ice on swelling | England Boxing 2025 Annex 2.4.1 (J55) |
| Agents | amateur: ice, enswell, non-petroleum jelly; pro adds adrenaline 1/1000 (closes a cut for a round) | World Boxing 3.1.6/3.1.8, NSAC (J55) |
| Eye problems per bout, amateur 3 rounds (loser) | hurt 15%, closing 5%, doctor band 1% | Nevada pro: eye 14% and cuts 51% of 17.1 injuries per 100 boxer-matches (J55 3b); amateurs wear headguards, so fewer. Invented, direction anchored |
| Same, pro 4 to 6 rounds | hurt 30%, closing 12%, doctor band 4% | same anchor, no headguard |
| Cutman on the eye | next round's eye loss halved (no lift over a line) | direction: ice and pressure work in 60 s (J55 3b); size invented |
| Cutman on a cut (pro) | bleeding stops; reopens 1 in 3 a round when hit there | adrenaline 1/1000 fastest haemostat (J55 3b, PROXY) |
| Coach takes a job | half strength, costs the one change, never the cut | Nevada 467.635(2): one person in, the cut work or the coach |
| Closed eye in the round | punches to that side land +25% (+10% when working off it, own output -10%) | invented; anchor not found (J55 6) |
| Doctor check at the bell | sight under 25: stopped; closing above 25: 1 in 6 | invented; BBBofC lets the doctor visit the corner (3.8) |
| Lasting cut if sent out closing | 1 in 5, up with each punch landed there: layoff 3 to 4 weeks, "Marks easily" (next bouts start the eye 8 lower) | InjuryRoll "cut" layoff 14 to 21 days today |
| Win chance shown | rest of the bout from the cards and the one-eyed edge | the game's own numbers |
| Cutman price | $150 a pro night (kept), $50 an amateur show (new) | money: the operator decides |

## What the player sees after
The eye's band is on the corner card and the live panel before each choice; after the bout The Why names the eye, the
choice and what it cost; the next week's report has the layoff, and the fighter's file "Marks easily" if the cut lasts.

## Build order (after his OK)
1. Pure module EyeRules.gd + tests (Qwen/Goose): the eye bands from the bout's own exchanges (tuned to the table on 300
   bouts), the blind-side edge, the doctor check, the lasting-cut roll, the cutman and coach lifts.
2. Wire it into the bout (LiveRound / RingDuel read the blind side; the bell runs the doctor check) with a control arm.
3. The EYE card in the corner minute (Cursor), from cutman_corner.png.
4. Critics judged the map (S423): docs/mockups/s423/cutman_critic_coach.md (realism 7, clarity 7, depth 4, excitement 6),
   cutman_critic_simvet.md (look 6, clarity 7, depth 5, excitement 7); both 10/10 drawings beside them. v2 takes the coach's.

## Questions for the operator
- The design as drawn: build it?
- Money: the cutman for amateur shows at $50 a night?

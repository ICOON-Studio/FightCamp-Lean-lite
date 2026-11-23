# The push switch and knowledge - the owner's interview (S543, 2026-11-23)

Asked after the push switch failed two probes (PUSHPROBE2; DEPTHPRICE1A row 27: the best play is one rule, "push while wind
is above 45") and knowledge v9 scored 7/8/7 and 8/7/7. He chose "Yes, interview me". Claude's diagnosis and the nine
questions are in the session; his answers are below. Where this page and an older map differ, THIS page wins.

## Round 1 - his answer, verbatim
"p1,p2 i think these things needs to be selectable for the player : Offense & Attack Commands (
* "Take it downstairs" / "Go to the body": Hit the opponent's torso or body rather than head-hunting.
* "Change levels": Mix punches between the head and body to force the opponent to adjust their guard.
* "Let your hands go" / "Get off": Throw combinations freely and stop hesitating.
* "Be first": Throw the opening punches to set the pace and disrupt the opponent's rhythm.
* "Sit down on your shots": Plant your feet and transfer body weight into punches for more power) , Defense & Form (Hands
up": Keep gloves high to protect the head and jaw.
* "Reset": Return to a balanced stance, proper guard, and clean posture after an exchange.
* "Get out of there": Move your head or feet immediately after throwing punches instead of lingering in range.) , Ring
Positioning & Strategy ("Cut the ring off": Angle your movement to trap the opponent rather than chasing them in a straight
line.
* "Stay away from the ropes": Avoid getting pinned against the ropes where escape routes are limited) . the engine should
understand and  respond and display these decisions on the fight . P3 yes P4 yes P5 depth can be judged and compared , i
will play to judge the fun  . Do you agree ?  K1-3 yes k4 yes to a no to b"

## What that settles

### The fight control (was "the push switch")
- P1, P2 REPLACED BY HIS OWN DESIGN: not one switch. The player SELECTS corner commands, in three groups:
  - OFFENCE: Go to the body; Change levels; Let your hands go; Be first; Sit down on your shots.
  - DEFENCE AND FORM: Hands up; Reset; Get out of there.
  - RING: Cut the ring off; Stay away from the ropes.
  "the engine should understand and respond and display these decisions on the fight."
- P3 YES: openings the player can see, pushing inside one pays; some opponents bait, and the opponent's file warns.
  (Waits for TELLPLAY1: `TELLPLAY_SCOPE_S543.md`.)
- P4 YES: worked live while the round plays; in a round not watched, the coach in the corner works it by tactics rating.
- P5: "depth can be judged and compared , i will play to judge the fun". Claude agrees: DEPTH is measured (probes) and
  compared (critics against reference games, 8 or more); FUN is his play. A mechanic stays only with both.

### Knowledge (signing a prospect on uncertain reads)
- K1 YES: a wrong signing costs the place on a small roster for a season and the story (the one who got away signs for the
  rival club and comes back against your boxer), not dollars.
- K2 YES: stop the paper rounds. Build step 1 of v9 (the signing card with the ranges, the two dates, the three calls) so
  he plays it; critics score the played build; a tenth map round only if his play says it is flat.
- K3 YES: a prospect is a moment, three to five signings a year, shown like the pro offer.
- K4: (a) YES - each trial evening the player picks tomorrow's question (body, skills, the pad test, the hard spar);
  (b) NO - no fourth call "sign short".

## What the game already has for his commands (code read S543)
`scripts/rules/Exchanges.gd` CALLS: seven corner calls, each with the attributes it needs, a wind cost, and a best / ok /
wrong grade against what the opponent is doing (`MODES`: pressing, at range, waiting to counter, loading up, tiring, hurt,
your boxer tired, your boxer hurt). `scripts/rules/StepEffect.gd` TABLE: ten learned steps.

| His command | In the game today |
|---|---|
| Go to the body | call `body` ("Downstairs! Go to the body!") |
| Let your hands go | call `let_go` |
| Hands up | call `hands` ("Hands up! Move your head!") |
| Cut the ring off | a learned step (`cut_off`), not a call |
| Stay away from the ropes | learned steps that clear the ropes (`pivot_out`, `roll_out`), not a call |
| Get out of there | close to call `long` ("Jab and move") and the steps `step_out`, `pivot_out` |
| Change levels; Be first; Sit down on your shots; Reset | NOT in the game |
| (not on his list, in the game) | calls `lead` (Draw the lead), `tie` (Tie up), `finish` (Go for the finish), `long` (Jab and move) |

## Round 2 - asked S543, answers below when given

Asked (each with Claude's recommended answer): C1 the list = his ten commands plus the four calls the game has (fourteen,
three groups), replacing Push / Steady / Save; C2 one command active from each group; C3 every command is best / ok /
wrong against what the opponent is doing right now, a wrong one costs; C4 a command works as well as the boxer has trained
it; C5 the two bars stay (wind and head), every command shows what it burns; C6 a command can be changed at any time, takes
effect from the next exchange, and the boxer hears it by coachability and trust in the corner; C7 shown first as the
shout, the bars and a line in the round, the 3D look of each command in the 3D phase; C8 probe on the real bout, critics
for depth, the build, his play.

His answer, verbatim:
"c1 do you think its too much ? c2 1 option for attack or defence and 1 option for positioning c3 yes c4 yes c5 yes c6
yes(maybe use switch or range sliders) c7 yes c8 yes"

What that settles:
- C2 CHANGED BY HIM: TWO slots, not three - ONE command for attack or defence, and ONE for positioning.
- C3, C4, C5, C7, C8 YES.
- C6 YES, with his idea for the control: "maybe use switch or range sliders".
- C1 OPEN: he asked whether fourteen is too much. Claude's answer (S543): yes, for a 40-second watched round. Proposal put
  to him in round 3.

## Round 3 - asked S543, answers below when given

Claude's answer to his C1 ("do you think its too much ?"): yes - a watched round is 40 seconds; fourteen buttons cannot be
read in that time. Asked, each with the recommended answer: D1 the list trimmed to his ten (a FIGHT slot of eight, a RING
slot of two); D2 the controls; D3 what the boxer does with nothing selected; D4 the moment button.

His answer, verbatim: "d1-4 yes"

## THE SPEC (complete: rounds 1-3) - the corner commands
1. WHAT IT IS: the player works the corner live. Not one push switch: the player SELECTS commands, and "the engine should
   understand and respond and display these decisions on the fight" (his words).
2. TWO SLOTS (his C2): ONE command for attack or defence, ONE for positioning.
   - FIGHT slot, one of eight or none: Go to the body; Change levels; Let your hands go; Be first; Sit down on your shots
     (attack) - Hands up; Reset; Get out of there (defence and form).
   - RING slot, one of two or neither: Cut the ring off; Stay away from the ropes.
3. THE OLDER CALLS (D1): "Jab and move" becomes "Get out of there"; "Tie up" and "Breathe, pick your shots" (the eighth existing call) become part of "Reset"; "Go for the finish"
   becomes the moment button (9); "Draw the lead" leaves the live set and stays a line of the pre-fight plan.
   They replace Push / Steady / Save.
4. RIGHT OR WRONG BY THE MOMENT (C3): every command is best, ok or wrong against what the opponent is doing right now
   (pressing, at range, waiting to counter, loading up, tiring, hurt). A wrong command costs.
5. ONLY AS GOOD AS THE BOXER (C4): a command works as well as the boxer has trained it; an untrained one shows Poor and
   does little. Only trained commands are lit.
6. THE TWO BARS STAY (C5, his 12 Nov idea): wind and head beside the fighter; every command shows what it burns.
7. CHANGING A COMMAND (C6): free at any time while the round plays; it takes effect from the next exchange; the boxer
   hears it or not by coachability and trust in the corner. The control (his idea, D2): the RING slot is a three-stop
   slider (Stay away from the ropes | Centre | Cut the ring off); the FIGHT slot is a row of eight buttons in two colours,
   one lit, click the lit one to turn it off.
8. NOTHING SELECTED (D3): the boxer fights to the plan written before the bout, as today. A command overrides the plan
   only while it is on.
9. MOMENTS (P3, D4): when the opponent is hurt a pulsing "Go for the finish" button appears and goes when the moment
   passes. Openings the player can see; some opponents bait, and the opponent's file warns - the baits wait for
   TELLPLAY1 (`TELLPLAY_SCOPE_S543.md`).
10. LIVE (P4): worked while the round plays, no pause; in a round not watched the coach in the corner works it by
    tactics rating (the corner pick of coaches v7).
11. SHOWN (C7), in two steps: now the shout as a bubble at the corner, the bars moving, a line in the round ("Hands up:
    slipped the right hand") and right / wrong calls counted on the result page; the 3D boxers visibly doing each command
    in the 3D phase after the mechanics (his order).
12. ROUTE AND JUDGING (C8, P5): a probe on the real bout first (no single command best everywhere; reading the moment
    beats any fixed command), then critics for DEPTH (measured and compared, 8 or more), then the build; FUN is his play.
    A mechanic stays only with both.
Build task ids: CORNERCMD1 (map + probe), then critics, then the build. Knowledge: KNOWBUILD1 (step 1 of v9, the signing
card) after the turning pro v17 build.

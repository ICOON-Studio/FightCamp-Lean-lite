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

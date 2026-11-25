# Ring Switches, S558 - every agent played it (owner S557: "have it playtested by all agents and also you")

## NOT GREEN
- Arena played the page as it was BEFORE this session's changes (its own clone), and its turn paused once after two
  hours (a long turn; one message restarted it).
- Kalli, John and Maria played 1 to 2 beats each: the owner, S558: "grokbots are out of quota". Their drivers resume with
  the same command (`node ops/Tools/play_by_message.mjs <seat> E:/FightCamp/tmp/allplay1/<seat>`).
- Cline played two bouts and a half (lost both, 27-30 and 28-29 to the Jabber) and wrote no report: its free model hit
  "free-models-per-day". 10 OpenRouter credits lift that limit (his money), or it resets tomorrow.
- The clinch is NOT fixed on the page. It is measured (below) and waits for his word or one more check, because it
  changes how every bout feels.
- Nobody but Claude saw a picture: every seat played in words. Pace, sound, the order strip and the pictures are unjudged.
- The jab still lands too often on the balance tool (76 to 79%), the one bar of nine that fails, as before.
- I stopped part of the S557 measurement run by mistake (it was alive, not dead as the handover feared); the ground
  version gave_30 was never replayed. Its probe ran: no gain, like the others.

## Who played, and the scores (fun, depth, clarity, variety, out of 10)
| Seat | Bouts | Record | Fun | Depth | Clarity | Variety | Its first ask |
|---|---|---|---|---|---|---|---|
| Claude | 3 | 2 wins, 1 loss | 8 | 8 | 6 | 6 | show where each hand is in each moment |
| Ziva | 6 | 2 wins, 4 losses | 7 | 8 | 7 | 7 | the clinch must not eat a punch you paid for |
| Antigravity | 3 | 3 wins | 7 | 7 | 6 | 6 | the clinch is a free stamina engine: make it worth nothing |
| Dola | 3 | 1 win, 2 losses | 8 | 7 | 7 | 8 | say when a clinch and a push off work |
| Arena | 6 | 6 wins | 7 | 7 | 7 | 7 | show his next cover before it fires (he closes the line you just scored on) |
| Ziva, first playtest (S556) | 9 | | 6 | 7 | 6 | 6 | |
Reports, logs and each seat's drawn 10/10 screen: `ops/research/allplay1/<seat>/`. The drawings are on the map
(Antigravity's is the one to look at). Mean of the five: fun 7.4, depth 7.4, clarity 6.6, variety 6.8 - under the
bar of 8 for depth and for play. Three claims of each report were checked against its logs: Ziva 3 of 3 exact, Arena's
six results and its worst beat exact (it says it never threw the push off: the log has one),
Antigravity 2 of 3 exact (it counted 5 clinches, the log has 6), Dola's results right and her clinch count wrong (she
said 17, the log has 11).

## What every player said (and what the logs say)
1. THE CLINCH. Ziva: four beats and ten stamina erased by his clinch ("the only thing that can make a chosen beat not
   exist"). Antigravity: won 3-0 on one loop - step in, feint, cross, then clinch the next beat - 14 clinches in 51
   beats, none answered by the Slugger. Dola clinched 11 times in 54 beats. The balance bots clinch 1.4 times a bout;
   Antigravity and Dola clinched 4 to 5 times a bout (Claude 1.7, Ziva 0.8, who had it done to it 6 times).
2. BACKING OFF IS DEAD AND LONG IS A CORRIDOR. The five players backed off 8 times in 366 beats; the balance bots
   back off in a third of theirs. Every round's first beat is "walk in". Ziva: "the safe range and the dull range are
   the same range".
3. THE GUARD BAR means nothing to a player: on every line, in no line of the help, and it moved on 3 beats in 100.
4. EVERY ROUND WAS 10-9, so two rounds up made round 3 dead on the cards (Claude, Antigravity, Arena). FIXED, below.
5. A MAN ON THE FLOOR KEPT PUNCHING, and getting up gave him more health than the man who dropped him (Claude, Ziva).
   The first is FIXED; the second is his call (it is also the drama of a comeback).
6. HIDDEN RULES learned by losing: a hand that punches guards high the rest of the beat; a step in beats a back off;
   what the feint covers. Now in the page's how-to and the words tool's help.
7. THE MEN BREAK THEIR CARDS AND WASTE BEATS: the Jabber walks in, the Slugger backs off, the Body Snatcher jabs and
   runs; all three open the same way; a feint with no punch behind it; an identical beat twice running.
8. WHAT IS GOOD, in every report: no plan stays right (each worked about three beats, then he answered it); the stamina
   bar is the real clock; his last three beats and the hand counts made "which line is open" a read (Ziva: "the best
   thing that has happened to this game").

## What changed on the page (measured: 8 of 9 bars on both sets, as before; 36 rule tests, the page played to the bell)
- A round won by 5 points or more is scored 10-8 (a knockdown is 3 points).
- A man whose health is at 0 throws nothing more that beat (two punches of the same speed in one moment still both land).
- Words: "ties you up"; "he backs off, you step in and cut him off"; "a hand that punches is held HIGH in the other
  moments"; the judges' line. The words tool's help says the five rules players had to lose to learn.

## Measured and NOT on the page
- Ziva's four rule ideas from S557 (a block costs guard, a free chase): all 8 of 9, none moves the jab. Not taken.
- The look-ahead learning the ground rule: no version gives the player fewer free rounds against the Jabber (he backs
  off 31 to 41% of beats whatever the look-ahead thinks; it is his style). Not taken.
- THE CLINCH, on a new probe (`probe_clinch.mjs`: Antigravity's loop played by rote, 60 bouts a man): wins against the
  Jabber / Slugger / Body Snatcher.
  | Version | Loop wins | |
  |---|---|---|
  | The page | 43% / 53% / 43% | the same script without the clinch wins 3% |
  | The clinch gives +1 stamina, not +2 | 22% / 43% / 40% | |
  | The man tied up gets half his stamina back | 17% / 35% / 28% | |
  | The man tied up gets all of it back | 18% / 23% / 22% | |
  | +1 and half back | 27% / 23% / 23% | |
  | +1 and all back | 5% / 15% / 13% | |
  On the balance tool (its own look-ahead table, 84 bouts): "all of it back" holds only 7 of 9 bars - the push off
  falls to 3% of beats (it is the answer to a clinch, and nobody needs it when the clinch pays less). The two
  other versions (+1 and half back, +1 and all back) fail the same bar, 7 of 9 each; the feint cleanup reads 7 of 9
  on one set (the mirror at 61%): `E:/FightCamp/tmp/s558_balance/batch/`.
  So: not on the page tonight. The push off has to be given a second job, or the mildest version taken.

## Tools new this session
- `ops/Tools/play_by_message.mjs`: a seat with no shell plays beat by beat (Grok bots, Antigravity, Dola; `via=test`).
- `proto/twohands/tools/probe_clinch.mjs`; tweak files in `ops/research/s558_balance/`.

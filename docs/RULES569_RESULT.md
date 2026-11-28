# RULES569 - his three rule ideas on the boxing page (Puncher's chance)

Task: ops/research/TASK_RULES569.md. Started S569 (Fable 5.2 worker), stopped for low memory at the end of S570, resumed
and finished S571. Every number below is from a committed file in ops/research/s558_balance/results/rules569_*.txt.
All runs: balance.mjs, jobs=1, one job at a time; each version measured on its OWN look-ahead table (a version run on
today's table is called a "screen" and only used to pick which version to build).

## Control
Today's order.html, the same day (S569 COUNTERS2, counters2_today_mirror_s1/s2.txt, n=84 jobs=1): **8 and 8 of 9 bars**
(red: punch lands - Jab 68%, Overhand 73%). n=12 seed 1 (rules569_today_n12_s1.txt): 6 of 9. Opponents
(counters2_today_opps_s1.txt): wins 75 / 65 / 68% v Jabber / Slugger / Body Snatcher. Feint loop (from the brief): 35 / 53 / 37%.
A beat takes 2.2 clicks (4 guard switches + up to 3 moves). Since then order.html only changed its drawing (LAYERS0, ?layers=1).

## The rules as measured
- **R1 - Guard is one action** (rules569_r1.json): the four guard switches are gone; a hand not punching is back in its
  stance guard by rule (lead glove in front of the chin: stops jab and cross; rear glove by the cheek: stops hook and
  overhand; body and uppercut line open). "Guard up" is one card (both hands, 1 stamina, covers every line until his next
  action). The two hands never punch in the same moment.
- **Idea 2 - the power switch** (rules569_p2.json): the LAST punch of a beat can be thrown at full power (you sit down on
  the punch that ends the combination): +2 stamina, +1 health, one step slower. Blocked or short, the thrower is OPEN in
  his next moment (his guard covers nothing). Feint stays its own card (MMCTOY1 did not keep it as a mode).
- **Idea 3 - the bars affect each other, B3b** (rules569_b3b.json), read once at the start of a beat so no link feeds
  another twice: (1) HEALTH CAPS THE STAMINA BAR - each third of health lost takes 1 off the stamina bar (never under 4);
  (2) TIRED ARMS - starting a beat on 3 stamina or less, punches of 2+ do 1 less (never below base - 1);
  (3) SOFT GUARD - every blocked punch wears the guard (1, a big punch 2); on 2 guard or less a blocked big punch lets 1
  through; (4) ON THE ROPES - every punch he blocks takes 1 more guard.
- **Idea 5 - the exchange that gets dearer** (rules569_r5*.json): +1 stamina the 2nd attacking beat in a row, +2 the 3rd;
  R5 resets on a back off / no-punch beat / clinch, R5c a clinch keeps the count, R5d only a beat with no punch resets.
- Idea 4 (combined moves) was not reached: R4 needs R3 to hold its bars.

## The table
| version | trial n=12 s1 | mirror n=84 s1 / s2 | red bars (n=84) | opp wins J / S / BS | feint loop | clicks a beat | its own numbers |
|---|---|---|---|---|---|---|---|
| today (control) | 6 of 9 | 8 / 8 | punch lands (Jab 68%, Overhand 73%) | 75 / 65 / 68% | 35 / 53 / 37% | 2.2 | - |
| **R1** guard one action | **5 of 9 - FAILS** | not run | dead: Jab 0%, Lead hook 3%, both uppercuts 2%; stoppages 0%; no-punch beats 31% | - | - | **1.8** | Guard up chosen 30% / 32% of beats (bar 10-35: passes) |
| R1, ten screen variants | best 5 of 9 | - | - | - | - | - | rules569_r1_screens_n12.txt |
| **idea 2 alone** (P2) | 7 of 9 | **8 / 8** | Overhand lands 79-80%, Jab 68% | 75 / 79 / 61% | 40 / 52 / 38% | 2.1 | full power in 9.5% / 9.7% of attacking beats (bar 5-25: passes); lands 55% / 61%; punished (blocked, short or beaten to it) 41% / 36% (bar 30-60: passes); hit while left open after it 2% / 6% of uses |
| **idea 3 alone** (B3b) | 7 of 9 | **8 / 8** | Jab 65%, Overhand 70%; Body jab 67%, Body hook 65% | 87 / 73 / 71% | 25 / 50 / 37% | 2.1 | links seen, % of beats (s1): health caps stamina 19%, tired arms 4%, soft guard leak 0%, ropes 2.5%; any link 24% |
| idea 3, health cap link alone (B3_l1) | 6 of 9 | 8 / 8 | Jab 66%, Overhand 77% | - | - | 2.1 | the cap shows in 19% of beats |
| idea 3, first four links (B3) | 5 of 9 - fails | not run | stoppages 25%, draws 0%, mirror 25% | - | - | - | tired arms changed 0 hits, guard never low |
| idea 2, first screen (+1/+2 health, +1 stamina) | 4 of 9 (screen) | - | stoppages 67% | - | - | - | settled to the version above after three screens |
| R1+2+3 together (screen) | 5 of 9 (screen) | - | - | - | - | - | rules569_r3_screen_n12_s1.txt |
| R5 / R5c / R5d | 5 / - / 5 of 9 | not run | stoppages 0% | - | 42/42/27, 25/37/23, 32/37/20% | - | the loop is not capped v the Slugger in any version |

Death spiral check: stamina at the last bell, a man - today 2.2 (n=12), idea 2 2.1, idea 3 1.8 (n=84): no spiral.
Stoppages at n=84: today 19 / 21%, idea 2 25 / 20%, idea 3 21 / 14%; knockdowns 2.1-2.4 a bout everywhere (bar 0.5-2.5).

## Verdict
- **R1 broke the sequence.** The guard as one card cuts clicks (1.8 v 2.2) and Guard up is a real choice (30%), but with
  the stance guard by rule the lead glove always covers jab and cross: the jab dies (0% of beats), body punches land
  66-79%, a third of beats have no punch, nobody is stopped. Ten variants screened, none above 5 of 9. So R2, R3 and R4
  (the combined moves) were not run, as the brief says.
- **Ideas 2 and 3 each hold alone** on today's page at the same bar count as the control (8 / 8 of 9). The power switch
  meets all its own bars. Of the four bar links only "health caps the stamina bar" shows often enough (19% of beats; bar 10%);
  tired arms 4%, ropes 2.5%, the soft-guard leak never fired - those three are decoration as measured.
- **Idea 5 does not cap the feint-then-overhand loop** in any version (best v the Slugger 37%, bar 30), and it costs
  stoppages (0% at n=12).
- rules.html (make_rules569.py, built from rules569_r3.json = all three ideas, the version that failed) stays a toy to
  feel the cards: Guard up card, FULL tag on a punch card, the link words on the gauges. Its tooltip numbers are R3's
  (tired at 2), not B3b's. page_play_test rules.html 4 passed, order.html 4 passed, rules_test 37 passed (S571).
  Stills: docs/rules569/rules_guard_plan2.png, rules_full_after.png, rules_gauge_plan2.png (opened).
- Not measured (next step if he wants it): ideas 2 + 3 together on today's page with their own table.

## For the owner (three lines)
1. One guard card made the jab useless and the fights flat, so it did not go in; the four guard buttons stay.
2. The power switch works: you pick full power on about 1 punch in 10, it lands about 6 times in 10, and you pay for it
   about 4 times in 10 - fights stay as balanced as today.
3. Of the bars affecting each other, only "lost health shrinks your stamina" really matters in a fight; the dearer
   exchange did not stop the feint-and-overhand trick.

RULES569 DONE

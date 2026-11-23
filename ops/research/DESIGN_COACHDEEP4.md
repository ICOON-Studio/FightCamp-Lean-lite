# DESIGN_COACHDEEP4 - deep coaches v4: ranked bouts pay a stipend, a departure takes her wins, class nights follow the members (S541)

Task: ops/research/TASK_COACHDEEP4.md. Base: DESIGN_COACHDEEP3.md (every v3 rule stands unless this page changes it) and the
owner's 24 answers (ops/research/COACHDEEP_GRILL_S539.md, binding). The stipend stays $250 a week; owner Q-311 "Bouts pay by
rank" stands. Probe: tools/coachdeep4.gd + tools/coachdeep4_rules.gd. Result: docs/COACHDEEP4_RESULT.md. Nothing under
scripts/ changes until the probe and two critics pass it.

Prior research (prior_research.py "coach class nights departure rank pay"): the COACHDEEP1-3 maps and results, Dola's and
Kalli's COACHDEEP1 critiques, GymBills.gd, BoutRules.gd. The work follows COACHDEEP3's verdict (docs/COACHDEEP3_RESULT.md s5):
the method holds (7 of 10 bars, b and c passing together for the first time); three numbers/rules are wrong, fixed here in
its order, nothing else touched.

Why v4: in COACHDEEP3 the small club with a cheap or weak hire (small L, F, K) ran every evening as a class night, let its two
ranked boxers walk (2.0 a career) and scored best, because (1) a ranked amateur's year (13 bouts at ~$740) still did not pay
her $13,000 of stipend, (2) a losing boxer who leaves stops taking losses, so the club's record went UP when she walked, and
(3) class nights paid on a fixed [1, 1, 1, 0.5] whatever the members, so the class was right in 6 of 109 trade weeks.

## 1. Rank bands that pay a stipend (COACHDEEP3 s5 item 1)

| Her place at the bout | v3 | v4 club's cut | Tickets ($18.75 a seat) | Real-world reason |
|---|---|---|---|---|
| Unranked (under 4 wins) | $450 | **$450** (BoutRules.TICKET_CUT, unchanged) | ~24 | A novice sells to her family and the club; the normal game starts with a walk-in novice (Q-246), whose money must not change. |
| Ranked 4th or lower | $700 | **$1,000** | ~53 | A name on the regional table sells like a small-hall card regular (55-60 tickets a boxer, CLAUDE_LAND_NOTE_J46.md). $1,000 = her stipend at one bout every 4 weeks: a ranked amateur pays for herself, the owner's sentence. |
| Ranked 2nd-3rd | $950 | **$1,200** | ~64 | A contender is the name a club show is built round; a fifth more than the small-hall line. |
| Number 1 | $1,200 | **$1,500** | ~80 | The region's best amateur sells above the small-hall line (club-show crowds 200-500, DESIGN_HOSTSHOW1_CRITIC_JOHN.md:543): she earns the club money over her stipend. |

Seat price: GBP 15 (middle of GBP 12-20) x 1.25 (Update 27) = $18.75. The ranked bands are ESTIMATE, set so a ranked amateur
covers her stipend and the top of the table earns; the probe checks it in money (bars f2, j).

Why a full stipend and not more: "a ranked amateur roughly pays her stipend, an unranked novice does not" (v3 map s1) is the
goal. At $1,000 she breaks even on cash; she is kept for her wins, reputation and members - the coaching question - not as
a profit line. Number 1 earning ($19,500 v $13,000) is the reward for building a champion.

## 2. The departure price counts the wins she takes with her (item 2)

Her next year (year_value) and so her departure price gain a record line: her next 13 bouts at her last win chance p
(the mean of her last 3), expected wins less losses = 13 x (2p - 1), in the score's win-less-loss line (0.5 a line). A boxer
who stays carries that line in her next year at the end of the 104 weeks; a boxer who leaves takes it with her. So the
kid who wins medals (p 0.6-0.8: +2.6 to +7.8 record a year = 5-16 lines) is costly to lose, which v3 missed.

Decided, and why: the brief's line is "expected wins minus losses of her next 13", taken literally. Two readings were
weighed and dropped: (a) charging a leaver her remaining in-horizon bouts too - at p under 0.5 that books a CREDIT for
losses she will not take, the very gain we remove elsewhere, and it double-counts the bouts already missing from the
record; (b) counting only her expected wins, never her losses - not a game item (the game keeps the record whole). A boxer
who loses more than she wins IS a drag on a club's record in the real sport; what v3 got wrong is that her WINS were free to
lose. The probe prints the price's parts: cash, reputation, record (wl), Leaving's reputation.

## 3. Class nights follow the members (item 3)

v3's fixed CLASS_RETURN [1, 1, 1, 0.5] becomes: one FULL class night per 12 members on the books (StaffRoles 1:10-12),
then ONE half night (the same people spread over one more evening), then nothing new. Demand = full nights + 1.

| Members | Full nights | + half | Paying share of n nights |
|---|---|---|---|
| 30 (small start) | 2 | 3rd at 0.5 | 1, 2, 2.5, 2.5 ... |
| 48 | 4 | 5th at 0.5 | 1-4, 4.5 |
| 70 (big start) | 5 | 6th at 0.5 | 1-5, 5.5 |

ESTIMATE, real-world reason: a club's members come on fixed nights and a timetable grows with the members; at 70 the 4th and
5th class are full (v3 paid them 0.5 and 0), so a second coach's evening is a real trade in a big club, and in a small one
the third night is only half - his evenings go to the boxers.

Target before the rerun (item 3): in a 10-rep diagnostic (mode=full reps=10 hreps=10 at the swept size), neither side right
in more than two thirds of the trade weeks. It is reported before the verdict; the full run decides, bars unchanged.

## 4. Everything else
Unchanged from v3: M3 the coached combination, M4 area weights by style, chemistry swept again (bar g: 1.0 / 0.6 / 0.4 /
0.25, 10 reps, the largest with CHEM best in at most 5 of 10 cells), the TEST CLUB, arms and controls, the score in lines.

## 5. Menus (after the critics; nothing built before)
| Menu | Shows | Wired to |
|---|---|---|
| Ask card / offer letter / bout page / poster | the club's cut by her band ($450 / $1,000 / $1,200 / $1,500) | BoutRules.ticket_cut(rank) (new) |
| Rank row under the name | the next band and what it pays ("top 3 sells $1,200 a bout") | RankLine.before + ticket_cut |
| Leaving warning (boxer card, week review) | what walks out with her: her band's year, her expected wins next year | Leaving + year value |
| Money page / week review | each bout's cut with its band | BoutFinish club_cut |
| Week plan | class nights: "3 full nights at 36 members, a 4th half full" | ClubDeal.class_cash x class_share(n, members) |
| Boxer card (Playbook) / Coach card | as v3 | OwnCombos, spec_mult |

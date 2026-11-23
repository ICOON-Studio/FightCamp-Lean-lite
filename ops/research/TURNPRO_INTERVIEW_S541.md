# Turning pro - the owner's interview (S541, 2026-11-23)

Asked after 16 design rounds failed the 8 bar (TURNPROBE16 FAIL 11/16; v15 critics 6/6/6, Kalli 6/6/6, Dola 9/9/8).
Owner: "why it keeps failing interviewme". Claude's diagnosis given first:
1. Each round patched the last critic's list instead of asking what the moment is for: layers grew (two houses, favour,
   home nights, counter-calls, title shots), never smaller.
2. The choices barely change the outcome (a few hundred dollars, a couple of wins).
3. The honest card solves the decision: following the card is already perfect play, so the "reader" depth bar can never pass.
4. The player's dilemma was never settled with the owner.

Fifteen questions in three rounds; the owner answered "yes to all five" each round (Claude's recommendation taken).

## The settled design (supersedes DESIGN_TURNPRO1 v1-v16 as the target)
1. THE MOMENT IS ABOUT WHEN AND HOW: when he turns pro, then how his first fights are picked. The promoter is background:
   one simple offer.
2. WHO WANTS WHAT: the boxer pushes (money, fame now); the gym wants him ready, its cut and its name; the player sits between.
   Hold him too long and he may leave; rush him and a KO costs his value.
3. MISTAKES ARE FELT AS STORY, not dollars: a rushed boxer KO'd in his third pro fight loses confidence; one held too long
   loses hunger or walks out.
4. NUMBERS STAY HONEST, THE CHOICE IS A TRADE: e.g. 70% to win, low purse, slow name v 45% to win, big purse, fast name.
5. JUDGED BY PLAY: bots only check nothing is broken (no dominant habit); depth and fun = the owner's play + two critics at 8+.
6. WHEN: the offer arrives when ready (as built: ~7 wins + top 3, or 9 wins). "Not yet" costs patience (shown on his card);
   waiting gives a few more amateur bouts.
7. HOW: the first 6 pro fights each offer TWO bouts - safe (high win chance, low purse, slow name) and risky (lower win chance,
   bigger purse, faster name), both on the card honestly; after 6 the normal booking takes over.
8. CONSEQUENCES: two bars on the boxer. Confidence moves his win chance a little; a KO loss drops it hard, easy wins raise it
   slowly. Hunger falls with too many easy fights or a long wait; at zero he wants to leave.
9. THE GYM: its purse share and the name from his wins, as built. No new money rules.
10. CUT: favours, home nights, counter-calls, favour title shots; the two houses shrink to one simple offer.
11. SHOWN ON: the pro offer pop-up (Turn pro now / Not yet, patience); the boxer card (patience, confidence, hunger); the
    booking screen of fights 1-6 (safe and risky side by side); one result-page line (what the fight did to confidence
    and hunger).
12. "NOT YET" TWICE, about 4 weeks each, a visible patience cost; the third time a rival gym comes for him instead.
13. HE CAN BE LOST: refuse the rival-gym moment and he leaves for good, after two warnings.
14. BOXING ONLY for now, men and women alike; the BJJ fighter keeps its own road.
15. ORDER: a quick greybox probe (10 boxer types; always safe / always risky / always wait each best in no more than 6 of 10;
    one-rep loop trial first) -> two fresh critics at 8+ -> build -> the owner's play closes it.

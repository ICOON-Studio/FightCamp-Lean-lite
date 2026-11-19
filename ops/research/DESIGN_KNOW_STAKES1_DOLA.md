# KNOW_STAKES1 - make knowing a boxer matter: pick ONE lever and design it (S459 design loop)

You are the designer of a boxing gym management game (FightCamp). Plain words; names only in headers ("your boxer",
"the prospect"). Every new number is an ESTIMATE. End with "To reach 10/10" for your own design.

## The game's knowledge system today (from the code)
Prospects walk in. You see each attribute as a RANGE (lo..hi) around a shown centre; the true value is inside the range.
Reads narrow the ranges: Look closer ($120), a Trial, a Test day, hard sparring at the club or outside, bouts. A first look
now misreads the whole kid (one shared error plus each attribute's own), so the shown rating is off by ~1.7 points on
average (was 0.8). Hyped prospects show 3-8 points high.

## What the measurement says (four bots sign prospects for 4 years, 60 worlds x 3 seed sets)
- ORACLE (signs the truly best) beats BLIND (signs the shown best) on top-10 finishes by only +4.4 / +9.2 / +7.9%.
- Signing by POTENTIAL (what a kid will become) LOSES to BLIND (to -13%): potential is not the missing truth.
- The pool: true ratings spread 20 points best-to-median; potential 14.
So knowing the truth barely changes a career: the pick has no stakes. More accurate reads cannot fix that.

## Your job
Pick ONE of these levers (or a better one, with reasons), and design it in full:
1. A wider walk-in spread (some walk-ins are much better or much worse than they look).
2. Hidden flaws that decide bouts: a glass chin, cuts easily, freezes under pressure - invisible until a read or a bout.
3. The cost of a wrong signing: stipend weeks paid for nothing, a release cost, the boxer's ambition leaving with them.
For the lever: what the player decides; what each read reveals about it and what it costs; what happens over a season if
you sign blind vs read first; every menu it shows on (prospect card, Look closer, Trial, Test day, roster, week review)
and what each is wired to; ONE headless probe with a pass line (BLIND vs ORACLE on the same worlds, paired, 150+ worlds:
ORACLE ahead by 8%+ on every set, and READ-FIRST - a bot that pays for one read before signing - ahead of BLIND by 4%+).
The bar: two fresh critics score DEPTH 7+ and GENERAL DESIGN 7+.

# TASK J-KDRATES1 - JOHN - knockdowns and stoppages in WOMEN'S AMATEUR boxing (real numbers, with sources)

Model: John (Grok bot, research). Discipline: boxing (demo). Research only: no code.

## Why
Our boxing manager game (PC, deep management sim) simulates women's amateur bouts (3 x 2 min or 3 x 3 min, AIBA/IBA/World
Boxing and England Boxing rules, headguard rules as they apply) and the first 4-round women's pro debut. We are adding
knockdowns and stoppages to the simulation. The game must hit REAL rates, so we need the numbers before we tune anything.
We already know men's MMA knockdown rates (UFC ~35% of bouts have a knockdown) and boxing pro KO share (~47% BoxRec);
we have NOTHING for women or for amateurs. Do not repeat the men's/MMA figures.

## The questions (answer every one; longest complete answer you can; a source for every number - name, year, link)
1. Women's amateur boxing (elite and youth; Olympics 2012-2024, World Championships, European, national championships such
   as England Boxing / USA Boxing): what share of bouts end by RSC / RSC-H / KO / ABD / DSQ vs on points? Per tournament
   where you can find it (Olympic results sheets list the decision type).
2. Standing 8 counts / knockdowns per bout in women's amateur boxing: how many bouts have at least one count, and how many
   counts per bout? If only men's amateur data exists, give it and say so, plus any women/men ratio from any source.
3. How the rules change it: headguard (removed for elite men 2013, kept for women until when?), the three-count rule
   (three counts in a round / four in a bout = RSC), the 2-min vs 3-min rounds, the referee's early stoppage culture.
4. Women's PRO boxing: share of bouts won by KO/TKO (BoxRec or any census), for 4-round debut bouts if anything exists, and
   overall. Compare to men's pro.
5. Weight class: is the stoppage rate higher at middleweight+ than at flyweight in women's amateurs?
6. What a manager sim should target per 100 women's amateur bouts: bouts with a count, bouts stopped, decisions. Give a
   band (low-high), never one number, and say how sure you are.

## Prior research
Old repo topics/knockdowns_stoppage.md: men's UFC KD incidence 35.1% of 8,337 bouts; boxing ~47% KO/TKO (BoxRec modern);
doctor stoppage ~1% of bouts. Nothing for women or amateurs.

## What would a human do?
Pull the official results PDFs (Olympic/World Championship results books list WP/RSC/KO per bout) and count.

## Prefab check
Datasets: BoxRec, the IBA/World Boxing results books, Olympedia, any Kaggle amateur boxing set - name each you used.

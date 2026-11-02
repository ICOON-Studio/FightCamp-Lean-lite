# J_UPSETS1_JOHN - John answer (seat queue SQ18)

Brief: research/TASK_J_UPSETS1.md
Sent: 2026-10-29 18:40 | collected: 2026-10-29 19:10 by Tools/seat_queue.py (the 30-min reconcile)
Attachments on the bot's box (not downloaded): J_UPSETS1.md
Verify the sources before using it.

---

Starting J-UPSETS1 now. First I'm looking for boxing betting-odds studies and Olympic upset data.

J-UPSETS1 is underway. When it's done I'll post the five tables and the favourite-win recommendation here, with the .md attached.

**J-UPSETS1 is done.** The one hard boxing number is that pro favourites win about 86% of decided fights. There are no published boxing win rates by odds band, so the recommendation leans on UFC odds bands instead. The data also had no higher-seed win rate for amateurs, no figures for how often a winner drops a round, and no developer-published targets.

**Q1. Pro boxing favourites** ([boxoddsstats](http://boxoddsstats.com/), 4,536 fights, snapshot 2022-02-05, licence unknown)

| Number | Value | Type |
|---|---|---|
| Favourite record | 3,783 wins, 608 losses, 124 draws | MEASURED |
| Favourite share of all fights | 83.4% | DERIVED |
| Favourite share of decided fights | 86.2% | DERIVED |
| "Upsets" (underdog won at odds at least twice the favourite's) | 7.87% | MEASURED |

The site's underdog-win count (611) doesn't match its favourite-loss count (608), and the site doesn't explain why. Its odds-band filters didn't show any per-band numbers.

**UFC odds bands, the stand-in** ([vigged](https://vigged.com/learn/ufc-betting-angles), 7,187 fights, 2010–2026, closing odds, MEASURED)

| Favourite's odds | Fights | Favourite won |
|---|---|---|
| −100 to −150 | 1,595 | 53.5% |
| −150 to −200 | 1,691 | 59.8% |
| −200 to −300 | 1,868 | 68.7% |
| −300 to −500 | 1,281 | 79.5% |
| −500 or shorter | 631 | 88.7% |
| All favourites | 7,066 | 66.9% |

In UFC split and majority decisions only, the favourite won 53.0%. No band covers odds of −1000 or shorter.

**Q2. Amateur and Olympic**
- **No-edge baseline:** the red corner wins 50.51% of 6,589 Olympic and World Championship bouts ([Peperkoorn 2024](https://www.nature.com/articles/s41598-024-81373-3)). Corners are assigned roughly at random, so this is what a fight with no favourite looks like.
- **Paris 2024 seeding** was drawn at random, not by ranking ([media guide](https://boxing.athlete365.org/wp-content/uploads/2024/07/Olympic-Games-Paris-2024-Boxing-Media-Guide.pdf)). World Boxing seeds by its own ranking ([rules](https://worldboxing.org/wp-content/uploads/2024/09/World-Boxing-Competition-Rules-Feb-2024-v3.99-ClEAN.pdf)).
- **Higher-seed win rate:** none published.

**Q3. Rounds** ([ABC judges report](https://www.abcboxing.com/world-title-judges-report/), pro world titles, 23,965 rounds on 2,796 judges' cards)

| Number | Value | Type |
|---|---|---|
| Rounds where a judge differed from the majority | 11.60% | MEASURED |
| Rounds scored even | 2.54% | MEASURED |
| Judges' cards that picked the bout winner | 88.24% | MEASURED |

How often the bout winner loses at least one round, and how often the underdog wins round 1, are not published.

**Q4. Rating gap versus win chance**
- **Judo**, about 380,000 matches: Elo fits well at small gaps but overestimates favourites at big gaps ([Ishii 2025](https://www.jstage.jst.go.jp/article/budo/58/1/58_2504/_article/-char/en), abstract only).
- **MMA:** an Elo-only model picked 60% of 755 winners ([Combat Edge](https://combat-edge.com/predictions/accuracy/), seen as a snippet only).
- **Boxing:** no Elo or ranking fit exists.

**Q5. Sports sims:** I found no favourite-win targets published by any developer.

**Recommendation (ESTIMATE):** in a 3-round amateur bout, aim for the favourite to win about 60% at a slight edge, 75% at a clear edge and 88% at a big one, and never above about 95%.
- Winning two of three rounds gives P(bout) = p²(3−2p), where p is the chance of winning one round. Hitting those three targets needs p ≈ 0.57, 0.67 and 0.78 (DERIVED).
- If each fighter's random roll has a normal spread σ, the strength edges should be about 0.24σ, 0.64σ and 1.11σ (DERIVED). With σ ≈ 8, that means edges of about 2, 5 and 9 points.
- Your harness gives 100% at a +5 edge, so the roll's spread is currently far too small.

My suggestion is to re-run the 400-bout harness and tune σ until the results land at 60/75/88, within 3 points either way. My notes to Claude are still on hold until your computer is back online.

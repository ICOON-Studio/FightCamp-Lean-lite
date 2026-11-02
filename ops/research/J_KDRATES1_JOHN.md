# J_KDRATES1_JOHN - John answer (seat queue SQ13)

Brief: research/TASK_J_KDRATES1.md
Sent: 2026-10-29 02:40 | collected: 2026-10-29 03:10 by Tools/seat_queue.py (the 30-min reconcile)
Attachments on the bot's box (not downloaded): J_KDRATES1.md
Verify the sources before using it.

---

Starting J-KDRATES1 now. First I'm pulling the official Olympic and World Championship results books to count how each women's bout ended.

J-KDRATES1 research is running, and I'll post the full answer here with the .md attached when it's done.

**J-KDRATES1 is done.** Women's amateur bouts are rarely stopped. My count of about 1,700 women's bouts gives 1.4% across the 2012–2024 Olympics and 4–11% at the IBA/AIBA World Championships. There is no public data anywhere on standing-8 counts or knockdowns for women amateurs, so every count figure below is a GUESS.

My counts come from [Olympedia](https://www.olympedia.org) and Wikipedia brackets, not the official results-book PDFs, so they still need checking against those.

**1. Share of bouts stopped (RSC, KO, ABD or DSQ; walkovers left out)**

| Tournament | Bouts | Stopped | Share |
|---|---|---|---|
| Olympics 2012 | 33 | 0 | 0% |
| Olympics 2016 | 33 | 2 RSC | 6.1% |
| Olympics 2020 | 97 | 1 RSC | 1.0% |
| Olympics 2024 | 115 | 1 ABD (Khelif v Carini) | 0.9% |
| **All four Olympics** | **278** | **4** | **1.4%** |
| AIBA Worlds 2018 | 239 | 12 RSC, 2 DSQ | 5.9% |
| AIBA Worlds 2019 | 203 | 9 | 4.4% |
| IBA Worlds 2022 | 287 | 24 | 8.4% |
| [IBA Worlds 2023](https://en.wikipedia.org/wiki/2023_IBA_Women%27s_World_Boxing_Championships) | 307 | 35 | 11.4% |
| IBA Women's Worlds 2025 | 208 | 45 | 21.6% (outlier) |
| World Boxing Championships 2025 | 191 | 1 | 0.5% (probably too low) |

The World Boxing 2025 figure is likely an undercount. Its Wikipedia pages list almost every result as a judges' score, so stoppages may be hidden there.

**2. Counts and knockdowns per bout**
- **Women:** I found no source for this.
- **Men, the closest data:**
  - Olympic men's knockouts fell from 6.3% to 3.8% of bouts when headguards became mandatory in 1984, while all early endings rose from 17.3% to 21.8% ([BJSM 2013](https://bjsm.bmj.com/content/47/7/452)).
  - Loosemore 2017 found head-blow stoppages fell from 28.9 to 10 per 10,000 rounds without headguards ([Clin J Sport Med](https://doi.org/10.1097/JSM.0000000000000322)).
- **Women/men ratios:** only rough ones exist.
  - The pro stoppage rate per minute fought is about 0.83 for women versus men.
  - Concussion rates are almost identical ([Combat Sports Law](https://combatsportslaw.com/2025/04/10/study-male-and-female-boxers-suffer-almost-identical-concussion-rates/)).

**3. Rules**
- **Headguard:** [World Boxing's competition rules](https://worldboxing.org/wp-content/uploads/2025/09/World-Boxing-Competition-Rules-Nov-2024-Approved-4.pdf) (Nov 2024) require it for elite women and ban it for elite men. Women wore headguards at every Olympics from 2012 to 2024.
- **IBA headguards:** IBA dropped women's headguards about a year before its 2025 Worlds, then allowed them back for that event. A 12-month trial is still being discussed ([IBA coaches' forum](https://www.iba.sport/news/open-forum-held-for-coaches-on-headguards-at-iba-womens-world-boxing-championships)).
- **Count limit:** a bout is stopped after 3 counts in a round or 4 in a bout, under World Boxing and the [England Boxing 2025 rulebook](https://www.englandboxing.org/wp-content/uploads/2025/04/2025-Rule-Book-Final.pdf). Also see the [USA Boxing rulebook](https://assets.contentstack.io/v3/assets/blteb7d012fc7ebef7f/blt38c82f8d00897a1f/67b8d0360c0965f2c1e1d577/USA_Boxing_Rule_Book_Rev._1.1.2025.pdf).
- **Round length:** 3×3 min for elite and under-19s, and 3×2 min for under-17s and England Boxing development bouts.
- **Unconfirmed:** the Olympic women's round format for 2012–2016.

**4. Women's pro**
- An [AAN 2025 abstract](https://www.aan.com/msa/Public/Events/AbstractDetails/58398) based on BoxRec (2014–2024) finds 29% of women's bouts end by KO/TKO (5% KO, 24% TKO) across 14,555 bouts, against 47% for men. Per minute fought, the two are nearly equal.
- I found no data on 4-round debut bouts.

**5. Weight class**
There's no real difference, based on my counts from the 2018–2025 IBA/AIBA Worlds:
- **Up to 54 kg:** 10.6% stopped (51 of 479).
- **57–70 kg:** 9.5% stopped (54 of 569).
- **Middleweight and up:** 11.2% stopped (22 of 196).
- **Olympics:** no middleweight stoppages in about 52 bouts.

**6. What the sim should target per 100 women's amateur bouts**

| Metric | Elite (Olympics, World Boxing) | IBA-style, national or club | How sure |
|---|---|---|---|
| Stopped | 1–6 | 5–12 (rare events up to ~20) | Medium |
| Points decisions | 94–99 | 88–95 | Medium |
| Bouts with at least one count | 5–15 (GUESS) | 10–25 (GUESS) | Low |
| Counts per bout | 0.07–0.25 (GUESS) | 0.15–0.4 (GUESS) | Low |
| Pro 4-round debut, KO/TKO | 25–45 (GUESS, built around the 29% figure) | — | Low to medium |

The count bands assume 2–4 bouts with a count for every bout that's stopped. That ratio is my assumption, not data.

**Datasets**
- **Used:** Olympedia and Wikipedia brackets.
- **Not used:** BoxRec needs a login. Kaggle's [Boxing at the Summer Olympics](https://www.kaggle.com/datasets/mathurinache/boxing-at-the-summer-olympics) and [Boxing Matches](https://www.kaggle.com/datasets/mexwell/boxing-matches) weren't checked for bout-level detail.
- **Cross-check:** amateur-boxing.strefa.pl came back empty.

**Gaps**
- No women's count or knockdown data. The official per-bout results PDFs might list counts.
- World Boxing 2025 needs checking against its results book.
- European Championships, England Boxing and USA Boxing nationals weren't counted, because I found no public bout-level results.
- No youth women's tournaments were counted.
- No census of 4-round debuts exists; it would need a BoxRec query.
- There's no same-event men's comparison.

The full report with every source is attached. My counts and scrape scripts are in the same folder on my computer, `/workspace/jkdrates1/`.

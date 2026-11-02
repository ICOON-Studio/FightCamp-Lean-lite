# G146 — Professional boxing draw rate

Delivered by Grok (Expert), S119 2026-09-28, chat https://grok.com/c/4c2ea1ab-3086-4a96-8b07-15ebaad53d19 . Saved verbatim by Claude; Claude's note at the end.

Window note: no official BoxRec outcome-split table exists. Figures below are the published anchors only. Game context: 60 sim bouts, 8×3 min, three judges, 10-point must → 11.7% draws of all bouts (~¼ of decisions). UFC sourced draw rate 0.7% (2021–25, n=2,577).

## Table

| Metric | Value | n | Window | Source | Tag |
|---|---|---|---|---|---|
| Draw rate, all professional bouts | ~2–3% | not given | unspecified “industry data” | https://sportssurge.alibaba.com/boxing/what-does-a-draw-mean-in-boxing (30 Oct 2025) | PROXY |
| Draw rate, all professional bouts | ~1 in 40 (2.5%); higher in 12-rd title fights | not given | unspecified | https://topdocumentaryfilms.com/boxing-betting/ (updated Sep 2026) | PROXY |
| Draw rate by scheduled length (4/6 vs 8 vs 10/12) | — | — | — | none found | UNSOURCED |
| Share of DECISIONS that are draws | — | — | — | none found | UNSOURCED |
| Split: unanimous / majority / split draws | — | — | — | none found (majority draw called “one of the rarest” qualitatively: https://boxingreviewer.com/how-is-boxing-scored 20 Feb 2022) | UNSOURCED |
| Technical-draw share of all draws | — | — | — | none found (rule exists: accidental foul after min. rounds + even/split cards) | UNSOURCED |
| 10-10 rounds on scorecards | ~1% of judged rounds (10-9 ~93%, 10-8 ~5%) | not given | CSAC briefing, undated | Andy Foster / CSAC via https://fightersonly.com/article/ext/39162/ | PROXY |
| 10-9 / 9-10 only | 93.1% of rounds; 6.8% excluded as non-binary | 7,864 rounds / 1,003 bouts with BoxRec cards | HD-video sample, years not stated | Jabbr / DeepStrike judging paper https://cdn.prod.website-files.com/68d6be744d7efccc2207f571/699f0f4c7359f338bf538829_Interpretable%20Prediction%20and%20Large-Scale%20Analysis%20of%20Judging%20in%20Professional%20Boxing.pdf | SOURCED (composition, not isolated 10-10) |
| KO+TKO share | ♂ 47% KO/TKO; ♀ 29% KO/TKO | 237,238 bouts | 2014–2024 | Karimi & Bickart, *Neurology* 8 Apr 2025, BoxRec collaboration https://www.neurology.org/doi/10.1212/WNL.0000000000212434 | SOURCED (not a draw rate) |
| Decision share among bouts that are not draw/NC | 46.5% decision / 35.1% TKO / 18.1% KO / 0.2% DQ | 1,690 US bouts (draws+NC excluded) | Jul–Dec 2017, USA | Ringside ARP / *Neurology* abstract https://www.neurology.org/doi/10.1212/01.wnl.0000580936.14660.4e | SOURCED (cannot recover draw %) |

## BoxRec datasets named
- boxrec.com — ABC-recognized record-keeper. Proprietary; no open bulk licence.
- Research extracts (not redistributable): Karimi & Bickart 2025 n=237,238; US 2017 H2 n=1,690; DeepStrike n=1,003 bouts with full cards.

## Reading (Grok)
No sourced professional-boxing draw % exists for 2015+ at any grain. The only all-bout figures are unsourced proxies at ~2–2.5% - several times UFC's 0.7% and far below the engine's 11.7% of all bouts. North American practice suppresses 10-10 rounds (~1%, even rounds "discouraged"). Treat 2–3% of all bouts as the only external ceiling.

## Claude's note (S119)
- The engine's boxing draws are NOT 10-10 rounds: boxing's profile scores 10-10 only on an exact float tie. They are 4-4 round splits over 8 rounds.
- The census pairs are deliberately even matchups; real cards mix mismatches. So the engine number to compare with 2-3% is the draw rate under the GAME'S OWN matchmaking (booked offers), not the census pairs. Measure that before touching the judges. Anchor is PROXY - a ceiling, never a pin.

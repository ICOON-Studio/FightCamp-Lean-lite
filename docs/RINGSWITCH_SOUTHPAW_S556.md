# Ring Switches: the southpaw, measured (S556, 2026-11-25)

The owner on stances (S555): "dont we need stances ? switching lead hands , does that fit or it make things brake and
complicated ?", then "yes prepare this for next session". Stance is a trait of a fighter; the first one is a southpaw
opponent. Nothing was built: five rule versions (two prepared in S555, three written from John's answer) of the open stance (an orthodox man against a southpaw) were run on
`proto/twohands/tools/balance.mjs`, each with its own look-ahead table, 84 bouts of two equal men who both play well.

## NOT GREEN (read this first)
- **No version is good enough to build.** Five were measured; the best pass 6 of the 9 bars (the page: 8).
- **None matches real boxing.** John's sourced answer came back the same session
  (`ops/research/RINGSWITCH_SOUTHPAW_BRIEF_JOHN.md`, section "John's numbers" below). In every version the cross is
  thrown LESS or the same; in real open-stance bouts the rear straight is thrown 25 to 40% more.
- John's sources were not re-opened by me: his own tags (SOURCED / COACH / CHECK) are carried as he gave them. His one
  counted study is an undergraduate dissertation on 24 bouts.
- Both men in these runs are in the open stance (the mirror bout). A southpaw OPPONENT with his own style and skill was
  not measured: that needs the cover rule keyed by the pair of stances, which is the build.
- The nine bars are mine, as in S555.

## The two versions
- **Version 1** (`ops/research/s555_balance/southpaw_v1.json`): the rear straights (cross and body cross) come down the
  middle, past the lead hand. The REAR hand stops them: held high the cross, held low the body cross.
- **Version 2** (`southpaw_v2.json`): version 1, and the lead hands are in each other's way: a lead hand held LOW stops
  the jab too.

## What came out
| What | The page today (both orthodox) | Open stance, version 1 | Open stance, version 2 | The bar |
|---|---|---|---|---|
| Beats at Inside / Mid / Long | 32 / 35 / 33% | 31 / 34 / 36% | 26 / 32 / 42% | each 15 to 55% |
| Most used switches | back off 34%, step in 32%, body cross 28% | back off 34%, step in 30%, body cross 23%, body hook 23% | body cross 35%, back off 31%, step in 26% | none over 40% |
| Least used | overhand 5%, rear uppercut 4% | rear uppercut 3-4%, lead uppercut 4% | **rear uppercut 3%, lead held high 3%** | each 3% or more |
| The jab: thrown a bout / lands / blocked | 3.9 / 72% / 28% | 3.6 / 57% / 42% | 2.7 / **30% / 70%** | lands 30 to 65% |
| The cross: thrown a bout / lands | 2.7 / 46% | 1.5 / 51% | 1.3 / 56% | |
| The body cross: thrown / lands / falls short | 4.7 / 45% / 33% | 3.9 / 39% / **41%** | 6.0 / 34% / **51%** | short at most 40% |
| The body hook: thrown a bout | 1.4 | **4.0** | 2.6 | |
| Held hands (share of beats) | lead low 27%, rear high 20%, rear low 21%, lead high 12% | **rear low 33%**, rear high 22%, lead low 23%, lead high 6% | lead low 36%, rear low 32%, rear high 13%, lead high 3% | |
| Bouts stopped / drawn / knockdowns a bout | 20% / 12% / 2.3 | **7%** / 15% / 1.7 | **6% / 24%** / 1.2 | 10 to 40% / at most 20% / 0.5 to 2.5 |
| Two punches in a beat | 16% | **13%** | **11%** | 15 to 45% |
| Clinches a bout | 1.4 | 1.3 | 1.1 | at most 2 |
| An order to choose / most often first | 68% / feet 47% | 67% / feet 49% | 59% / feet 50% | 40%+ / at most 60% |
| The same man against himself | 49% | 49% | 47% | 40 to 60% |
| BARS | **8 of 9** | 6 of 9 | 5 of 9 | |

## What it means
1. **The open stance does ask something else** (so it is not just the same game with other numbers). In version 1 the
   guarding hand becomes the REAR hand (held low in one beat in three, against the body cross); the lead hand has only
   the jab and the body hook to stop, so it goes punching: the body hook is thrown three times as often. The jab stops
   being nearly free (blocked 42% instead of 28%), which fixes the one bar the page fails today.
2. **But the fight goes soft.** The cross, the punch that hurts, is thrown half as often, so stoppages fall from one bout
   in five to one in fourteen and two-punch beats thin out. One hand (the rear) now has to cover the cross, the body
   cross, the hooks and the uppercuts: the men keep it home instead of throwing it.
3. **Version 2 is worse**: with the lead hand also stopping the jab, the jab lands 3 times in 10, Long becomes the place
   where little happens (42% of beats), the body cross is thrown most and falls short half the time, one bout in four is
   a draw.
4. **It is the wrong way round against what trainers say**: in the open stance the rear straight is taught as THE punch
   (its line is clear) and the jab as the hard one to land. Version 1 gets the jab right and the rear straight wrong.
   This is the point John's numbers should settle before a third version is written.

## John's numbers (SQ333, the same session)
- **The rear straight**: thrown 66.6 and 75 times a bout in the two open-stance groups against 53.3 and 54.3 in
  same-stance bouts (p = .013), landing 40 to 47% either way (Goodman 2013, 24 world-title-level bouts, 6 a group: his
  one counted study, tagged CHECK). Coaches: it comes down the middle, the REAR hand has to stop it and "has to move"
  between the straight and the overhand: one position no longer covers both.
- **The jab**: three orthodox boxers landed 11.9%, 11% and 9.8% of their jabs against southpaws (CompuBox notes on
  single boxers) against 22.4%, 17% and a division average of 22%: about half. Coaches: the lead hands meet; the jab is
  slapped down with the lead hand.
- **Results**: among the top 340 professionals both stances win 88% and 87% of their bouts, and everybody wins less
  against a southpaw (85% against 89%); across 10,445 active professionals a southpaw has the better record 52.4% of
  the time.
- **His one rule**: swap which held hand stops the straight: the cross is stopped only by the rear hand held high, the
  lead hand held high keeps the jab. That is version 3 below.

## Three more versions, built on his answer (on the page as it is now: the body jab, health 18)
| What | The page now (both orthodox) | 3. John's one rule (only the head cross moves to the rear hand high) | 4. Version 3, and the cross is fast | 5. Version 1, and the cross is fast |
|---|---|---|---|---|
| BARS | 8 of 9 | 5 of 9 | 6 of 9 | 5 of 9 |
| The cross: thrown a bout / lands | 3.8 / 43% | **2.3** / 63% | 3.6 / 63% | 3.5 / 65% |
| The jab: lands | 73% | 78% | 76% | 80% (thrown in 5% of beats: nearly dead) |
| Lead hand held high (share of beats) | 9% | **2%** | **2%** | **2%** |
| Dead or nearly | none | body hook 3% | lead hook 2%, overhand 3%, body hook 3% | overhand 3%, jab 5% |
| Bouts stopped / draws | 16% / 7.5% | 10% / 0% | 11% / 5% | 8% / 10% |
| Two punches in a beat | 17% | 12% | 11% | 14% |

## Why they all fail the same way
The rear hand held high already stops the lead hook and the overhand. Give it the cross as well and one hold stops
three big punches: the cross is thrown less (the opposite of real boxing) and the lead hand held high is left with the
jab alone, a 1-health punch, so nobody holds it (2% of beats). Making the cross fast brings its count back to today's,
not above it, and kills the lead hook. A one-line swap cannot make a southpaw in this game: the open stance needs its
own cover table, where each of the four holds is still worth making.

## Recommendation (mine, for his call)
Do not build the southpaw from any of these. The question is now a design one and it is with Kalli (SQ334,
`ops/research/RINGSWITCH_SOUTHPAW2_BRIEF.md`): one cover table for the open stance in which every hold stops a big
punch, none stops three, the rear straight is harder to stop than today and the jab easier. Her table is measured the
day it lands (10 minutes). Build only if it passes at least 8 bars, throws the rear straight more and lands the jab
less. The price of the build is then mostly pictures: every picture of the red man mirrored (about 60 runs of 11
frames, about 25 minutes of rendering, plus the clinch picture, which the mirrored man breaks today).

## How to run it again
```
N=84 sh proto/twohands/tools/balance_batch.sh <out_dir> ops/research/s555_balance/southpaw_v1.json ops/research/s555_balance/southpaw_v2.json
```
The three later versions: `ops/research/s556_balance/southpaw_v3_john.json`, `southpaw_v3_john_fast.json`,
`southpaw_v3_v1_fast.json`. About 10 minutes for two versions on 7 threads (the batch looks ahead with 300 passes a state; the page's own table uses 500). The page is not touched.

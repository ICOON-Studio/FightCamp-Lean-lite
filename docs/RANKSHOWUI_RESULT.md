# RANKSHOWUI

The rank a fight earned now shows in the Why panel under the result, and on the fighter's own card.

## What changed

- `WhyCard.build` takes the rank words as an optional last argument. When the words are not empty, a fourth row is added: head `RANKING` (caps, 150 wide) and a body label named `WhyRank`, same font and colour as the plan rows. Empty words add no node.
- `FightNight` passes the words the bout booked (`rank_words`) into that call. Nothing else on the fight night screen changed.
- `AfterFight.rank_words(c, f, before)` is the line `RankLine.after` already writes. `book` stores it on the result beside the tiles, and the rank tile reads the same call. `rows` is the division table the card asks for; `_rows` still calls it.
- `RankRow.build` returns one line named `RankRow`, the words of `RankLine.before` on those rows. A pro returns nothing, and so does a no-gi athlete (off the amateur table, and with no division the table would not build). `FighterCard` places the line under the name and chips. The gold `#N IN THE REGION` chip is unchanged. The line does not wrap and clips, so it stays one line and does not widen the card.

## Test last line

```
RANK_SHOW_UI failures=0
```

28 asserts, all ok.

## Text the cases printed

Copied from the test output:

```
CASE why: Now number 3, up from 5; she passed Dana Mills.
CASE unranked: Unranked: 3 wins from entering.
CASE ranked: Number 3.
CASE pro: none
CASE result: Enters the rankings at number 6.
```

The Why case is the words handed to the panel. The unranked case is an amateur with 1 win. The ranked case is number 3, and the gold chip still read `#3 IN THE REGION`. A pro printed no row. The result case is one real amateur bout: Lucy entered at number 6, and `WhyRank` matched the rank tile's first line.

## Rank row minimum width

```
RANK_ROW min_width unranked=1.00
RANK_ROW min_width ranked=1.00
```

Clip is on and autowrap is off, so the line's minimum width is 1 px. The card's width still comes from the name, the record and the face. The rank line fills that width and clips if a longer line ever shows up.

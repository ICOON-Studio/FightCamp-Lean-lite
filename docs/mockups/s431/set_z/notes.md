# Set Z notes (S431): squad.png and overview.png

Both pages are 1920x1080, rendered five times, opened and checked whole (no blank bottom rows, nothing clipped).
`gen.py` writes both HTML files; `overview.html` is made from a copy of `s430/overview_a.html` by text replacement, so
everything not listed below is byte for byte what he said "looks nice" about.

## Palette (sampled from ref/gym_screen.png with PIL, not guessed)
| Hex | Where it is on the gym screen | Where I use it |
|---|---|---|
| wood bar, average `#191411` (rows `#0f0d0a` to `#1d1713`, light edge line `#412a20` at y 73) | top bar | top bar: the game's own `assets/ui/wood/bar.png`, 76 px tall |
| plank `#402820` / `#483020`, top highlight `#795139`, outline near black | Mail, Menu, NEEDS YOU, More below | the top bar buttons: the game's own `plank.png`, nine-slice 9 px |
| `#6c9de6` (dominant `#6898e0`) | brush club name | club name, Permanent Marker 32 px |
| `#ede1cd` | date | date |
| `#b7a488` | "Week 2", "running -$680 a week" | the same two lines |
| `#e7bd55` | money | money |
| `#efe2ce` | words on planks | words on planks |
| `#252b43` | pin fill | every action pin; dashed pin = offered, not booked |
| `#fffbf3` | pin ring, label and strip words | pin ring, face ring, label and strip words |
| `#e1473a` | the one red pin (needs you) | the one red pin on the squad (Lucy's offer), the key |
| `#1b253f` | navy pill label under a pin | action labels, the weight class label under each face |
| `#222a44` (`#252d45` to `#1c2640`) | news strip | next-step strip on both pages, the hover card |
| `#1a1f31`, bar `#275696`, words `#8eb8f3` | the strip's blue tag | tags "SHOW IN 19 DAYS", "TIREDNESS"; `#8eb8f3` also for a name that is a link |
The bar colours, gold button, wall and type below the bar are overview_a's own, unchanged.

## What I took from the gym screen
- The top bar, measured against the picture at 2x: same height (76), same plank pieces, same positions and inks, same
  date, money and need. Inner pages add the "Gym" plank (the way back), placed where today's inner pages have it.
- The round white-ringed pin with its navy label under it: on the squad it is the mark for every action, and a face in
  the same ring with a navy class label is the mark for a person. One red pin, as on the gym screen.
- The blue-tag strip, with the gym screen's own words ("SHOW IN 19 DAYS"), now carrying the page's next step.
- Wood below the top bar: read off the gym screen, none except shell buttons (its "More below" plank). My pages need no
  such button, so there is no wood below the bar. The floorboards under the figure are overview_a's and stay.

## Overview: the only changes to overview_a
1. Top bar = the gym screen's. 2. "Engine" is "Cardio". 3. On the scale: weight against the limit and the tiredness
meter (bar with the fresh line at 50 and the heavy zones, the number, "Fresh, 0 rest days", the game's own wording).
4. Six tabs. 5. The real 3D figure, cut out of ref/overview_today.png (`lucy_figure.png`, enlarged 1.8x), leader lines
re-aimed at the real head, glove, shoulder, chest, thigh and boot. 6. The next step sits in the blue-tag strip; the
four action buttons keep their shape and carry their icon in a pin.
Data moved to the gym screen's Monday (12 Jan, week 2) so the three pictures tell one story: record 3-1, weight 60.9
against 60.0, the next step is the offer the top bar names, the guide's line is about that offer.

## Squad: what is drawn
Four rows (three boxers, one no-gi), each: face, class, record, rank or belt; overall; three meter tiles (tiredness,
weight, mood: big number, bar with a tick, two words); the goal ring; the next four weeks as a track with the date
pinned; one action pin. One hover drawn open (tiredness, the game's own tooltip words plus what each rest day leaves:
72, 63, 55, 47 from the game's 0.87 a day). Every caption is three words or fewer; nothing under 20 px below the bar.

## Unsure / weak
- The top bar's small lines (Week 2, running, the need) are 15 to 16 px because the real bar's are; I copied, not fixed.
- I changed NEXT STEP from the nationals to the bout offer so it agrees with the top bar. If he wants the nationals
  line back it is one string.
- The figure is a 1.8x enlargement of a small render: soft at the edges. The build would draw the live model.
- Tess and Ana have no face in the game's cast table; I used two unused studio faces (mh_boxer_15, mh_boxer_16).
- Squad numbers that are mine, not the game's: overall for Samira, Tess and Ana, the moods, Tess's tiredness 72,
  Ana's weight, the goals of Samira, Tess and Ana, the open's date. The club show dates, limits, records, weights of
  the three boxers and the rank rule (ranked at 4 wins) are the game's.
- "Compare" as a tab and the track of the next four weeks do not exist in the game yet.
- The squad has gold once (the next step) and the same thing again as Lucy's red pin: said twice on purpose, like the
  gym screen says it three times, but he may find it one too many.
- No staff member is named on either page. Where staff appear later they are "Coach", never a surname.
- The two "No bout" rows leave the track column nearly empty.

# DESIGN_TRAINGAME2_CRITIC_JOHN_JOHN - John answer (seat queue SQ172)

Brief: research/DESIGN_TRAINGAME2_CRITIC_JOHN.md
Sent: 2026-11-15 12:10 | collected: 2026-11-15 12:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'm checking TRAINGAME2's numbers against the game's rules in the pack first, then I'll score it. The owner's computer is still offline, so `CRITIC_ACCESS.md`, the page and the probe aren't open to me.

**Logic check.** I recomputed the map's numbers from the rules in the critic pack: 4.1, 4.2, 4.4, S448 and S451.

These hold up:
- **The fire shares match FireLevel** (S451): 0 under 30, 1 in 2 at Usable, 3 in 4 at Sharp, always at Signature.
- **The intensity ratios are consistent.** Hard Defence +0.17 is 1.3 × about 0.13, and Light Speed +0.06 is 0.6 × about 0.10, both matching the Normal row (+0.10 to +0.13).
- **The weight figure is plausible.** −0.04 to −0.09 kg a morning on a 500 kcal cut plus training burn fits: about 7,700 kcal is a kilo, so the cut alone is about −0.065 kg a day.
- **The tiredness line is internally consistent.** The rule's line from 40 ends with a Sunday rest of −8 (48 to 40), as the map says.
- **The rule check is right.** At +7.5 a night, the check hook at 28.2 needs one more pad night, and fight week has pad nights (TAPER is light, not padless).

Nine things don't hold:

1. **The design finding mixes units with minutes.** The pack (S448) says a pad night is 240 drill units for 75 real minutes. 8.7 mastery a night is about 0.036 a unit, which is the map's "0.03 a minute", but per real minute it's about 0.11. So five real minutes is about 0.6, not 0.15. The 1.8 gap needs about 16 real minutes, which is roughly the difference between a 50/50 and a 70/30 split of a 75-minute night (15 minutes). So "a night, not minutes" is only half true: **the split the game already offers can close the gap**, provided the Friday night was shared. The map doesn't say whether Friday's +7.5 was a full night or a share. That one fact decides whether the story can happen.
2. **The mastery rate isn't shown to match the pack.** At 2.1 an hour of pads, a 75-minute night is +2.6, not +6 to +10. The code's 240 units must be what scales it (2.1 per 60 units is 8.4). The pack has two rates for the same night. The map should say which the code uses, so critics and the Handbook don't quote 2.1.
3. **"Stamina" was changed to "Cardio" everywhere.** The pack's agreed list and `Attrs.gd` (S448) name the attribute Stamina, merged from Conditioning and Cardio. I can't see the S431 ruling, but if it stands, the attribute, the profile and the Handbook must rename too. Otherwise one concept has two words.
4. **The mornings raise the old summary stats.** Power, Technique and "Ring IQ" are summary values read from the 14 abilities (S448). Renaming the sparring line from Fight IQ to Ring IQ goes backwards: Fight IQ is the real ability. Mornings should name what they raise: Strength or Explosiveness for strength work, Accuracy or Timing for the bag.
5. **The probe body is a named woman at a 70.0 kg limit.** Women's classes are 57/60/65/75 and 70 is a men's limit. Either the body or the limit is wrong, and every weight number depends on it.
6. **Names appear outside a header** ("Lucy's record", "Dola's story"). The probe can say "the test fighter". If either name is on the page body, that breaks S448.
7. **The tiredness line is labelled "first bell 48"** inside peak week. The bout is the week after, so the first-bell value needs the taper week too: three rest days and no sparring would bring it well under 40.
8. **The map never prices the cost side.** Peak week is "hardest, sparring twice" (4.1), but the map shows one sparring night and gives no tiredness or injury change for adding a pad night. An extra pad night or a hard morning is only a choice if its tiredness cost shows: overreached from 80 means gains × 0.6 and injury risk × 3, and a load spike (1.5+) gives 2–4×.
9. **Three claims are left as drawn and unchecked:** win shares at +1.5% a usable move, the injury risk line, and the comparison with the coach's week. The pack's only measured value is sharp over usable at +2.8 wins in 100.

I score TRAINGAME2 at depth 5, general design 5 and play 6, so it doesn't meet the owner's bar yet. It's an honest numbers pass on a built mechanic, and its key finding is useful. But that finding is mis-scaled (units read as minutes), the cost side of the week is missing, and it brings in two word conflicts and a wrong weight limit.

I judged it from the pack and the map only. `CRITIC_ACCESS.md`, `training_k.html`/`.png` and the probe are on the owner's computer, which is offline.

## Scores

**Depth 5.** The real decision in this week is which move gets a pad night, and the map rightly makes that the lever. What holds it at 5:
- **Mornings barely differ.** Every Normal morning gives +0.10 to +0.13, so the choice of session is only which stat, never how much, and the page doesn't show what each stat does in a bout.
- **The costs aren't priced.** The page doesn't show tiredness, overreach, load spike or injury against an extra pad night, so the obvious pick (drill the nearest-to-Usable move) has no visible downside.
- **The split lever is dismissed**, though it may be exactly what closes the 1.8 gap.
- **It ignores interactions:** the check hook as a weapon opens Counter sense (Defence 65 + check hook weapon), and a tell found in the opponent's file names a drill.

**General design 5.**
- **What's good:** it fixes numbers against the code, names the probe, separates verified from unverified, and drops a promise the rules can't keep.
- **What holds it at 5:**
  - minutes and units are mixed;
  - the pack gives two mastery rates (2.1 an hour, about 8 a night) for the same night;
  - Stamina and Cardio, and Fight IQ and Ring IQ, are each one concept under two words;
  - the mornings raise summary stats, not the abilities in `Attrs.gd`;
  - a 70 kg limit sits on a women's body;
  - names appear outside the header;
  - the tiredness line is unredrawn and labelled for the wrong day;
  - it isn't a design map yet: no table of options and what each changes.

**Play 6.** "Will the check hook be Usable before the bell?" is good anticipation: a number climbs across three nights, and the week review shows it. What holds it at 6 is that the answer is fixed by the rules once the cards are placed, with no visible risk to weigh.

## What each option changes, and verdict
| Option | What it changes | Verdict |
|---|---|---|
| Morning session (8 kinds + rest) | +0.10 to +0.13 to one stat, weight, tiredness | Keep, but name the ability it raises and what that does in a bout |
| Light / Normal / Hard | ×0.6 / ×1 / ×1.3 gain; tiredness | Keep, and show the tiredness price beside it |
| Evening: Pads | about +6 to +10 mastery to the cards | Keep; this is the core |
| Evening: Sparring | Shares 180 units over moves at 30+; +0.12 Fight IQ | Keep, and say it can't help a move under 30 |
| Evening: Rest | −8 tiredness | Keep |
| Evening: Film | Nothing shown on this page | **Useless here** unless the page shows a tell opened |
| Split 50/50, 70/30, 30/70 | About 15 real minutes (48 units) moved between cards | **Keep and promote:** it may be the cheapest way to close a small gap |
| Diet Hold / Cut | About −0.065 kg a day from the cut | Keep |
| The coach's one change, "Do it" | Unknown on this page | Show its mastery or weight effect on the button |

**Missing options**
- **"Make it Usable by fight night".** Pins the move: the coach moves splits or adds a night and shows the cost.
- **Extra pad night instead of rest.** Saturday or Sunday evening Pads, with +7 mastery against tiredness and the spike risk shown.
- **A taper-week view,** showing what fight week's pad night and rest days do before the first bell.

## To reach 10/10
1. **Fix the scale.** State in one place what the code does: 240 units a night, mastery per unit (about 0.036 at mastery 12–28 with pads coach 58), and 75 real minutes. Redo the five-minute finding in real minutes (about 0.6). State whether Friday's +7.5 was a full night or a share, then rule which lever (split or night) closes the 1.8 gap.
2. **Make the split the readable lever.** Each card on a night shows "+X mastery" for its share. Changing the split re-forecasts the move's tier by fight night ("Usable Fri" or "Usable Mon 23").
3. **Price every choice in tiredness and risk.**
   - Each evening card shows its tiredness change.
   - The week line shows the overreach mark at 80 and the spike ratio.
   - A Hard morning or extra pad night that crosses either mark turns the cell's colour (colour means risk only).
4. **Use one word per concept, from `Attrs.gd`.** Either Stamina everywhere, or the owner's Cardio renamed in the code, the profile and the Handbook too. Use Fight IQ, not Ring IQ. Mornings name the ability they raise.
5. **Fix the probe body.** Either a women's 65 or 75 limit, or a men's body at 70, and redraw weight from it. Use "the test fighter" in place of names.
6. **Redraw the tiredness line from the real carried-in value,** through peak week and the taper week, ending at the real first-bell number.
7. **Show what readiness buys.**
   - Usable means fires 1 in 2; Sharp fires 3 in 4.
   - The win value comes from a probe measured like S427 (400 bouts a cell), not the drawn +1.5%.
   - Show the Counter sense perk if the check hook as a weapon completes it.
8. **Write it as a design map:** options, what each changes, the dominant-pick test, and a bot probe. Does "always pad the nearest-to-Usable move" beat the coach's week by more than the tiredness it costs? The design passes if it doesn't always win.
9. **Run the probe, then redraw the page.** The game can do all of this with existing rules; only the readiness forecast and the "make it Usable" pin are new UI.

## The 10/10 page (1920×1080, Look B; Fighters, the fighter page, Week tab)

**Shell (0–64):** dark top bar. CONTINUE is the only pulsing button.

**Header (64–190):** portrait and name once, with class, record and "Peak week · bout in 9 days". A tiredness meter shows marks at 80 (overreached) and the spike ratio.

**Left whiteboard (40–1300):** seven columns.
- **Mornings:** magnets with the ability raised and its value ("Strength +0.12"), plus a Light | Normal | Hard pill.
- **Evenings:** Pads cards with the split bar and "+X mastery" for each card's share, a Sparring card, and a Rest card showing "−8 tiredness".
- **Fight date:** circled in marker.
- **Tiredness line:** under the columns, running through to the first bell. Cells crossing 80 are red.

**Right panel (1340–1880):**
- **WHAT THIS WEEK BUYS:** each move's ring toward Usable and Sharp, with the day it gets there ("Check hook: Usable Mon 23 · fires 1 in 2").
- **A pin:** "Make it Usable by fight night", which re-forecasts.
- **THE COST:** tiredness at the first bell, injury risk word, weight on the day against the limit.
- **COACH'S ONE CHANGE:** its effect written on the button ("Fri 70/30: Usable Fri, tiredness +2").

**Bottom (960–1060):** Back to the coach's week, and the diet pill. Secondary detail is in hover text.

**Stress state (the default drawing):** the check hook at 28.2, 1.8 short, with the split fix and the extra-night fix both shown and their costs side by side.

## Sources
No new outside sources this pass. Every figure is DERIVED from the critic pack and the map. The roughly 7,700 kcal per kilo of body weight is the common rule of thumb, from memory and a CHECK.

# K_CALIB1 answer - Kalli (design review), the Sunday test calibration

Collected S373 (2026-11-03) from the gbot thread 'Kalli'. Built: women's bleep club anchor 60 -> 8.0
(SkillAwards.BLEEP_WOMEN_AT), punches shown to 0.1 as the average of 3 tries, force in 25 N steps, a norm word
(BEGINNER / CLUB / ELITE for that sex) beside every records-wall number (TestDay.norm, AwardCard._wall).
Still open: a MEASURED club-women bleep figure (Kalli's 8.0 is an ESTIMATE) - John.

I ran the numbers for a club boxer training hard: 12 weeks at about 1 stat point a week, so +12 from the 60 anchor. One assumption changes every answer below: what you round each test to on the wall. I assumed bleep to 0.1 of a level, punches to whole punches and force to 10 N. That rounding is NOT COMPUTED against the build.

**Q1. The pace is uneven: bleep is right, punches are too slow and force is too fast.**
- **Women's bleep** moves 0.053 a point, so +0.64 levels in the camp. That's about 6 chalk lines, roughly one every two weeks. That's right.
- **Men's bleep** moves 0.06 a point above 60, so +0.72 levels and about 7 chalk lines. That's right too.
- **Punches in 10 s** (women 0.18 a point above 60) gain only 2.2, so 2 chalk lines in 12 weeks. That's too few. The men's curve is the same at +2.4.
- **Force** (women 8.8 N a point) gains about 105 N, so about 10 chalk lines, nearly every week. That's too many.

My fixes:
- Show punches to one decimal as an average of 3 tries, for example 48.3. That gives about 6 chalk lines without touching the anchors.
- Show force rounded to 25 N. That gives about 4 chalk lines.
- Leave the anchors alone. Both fixes change only the display, so John's numbers stay as they are.

**Q2. Yes, the women's gap is too small. Add a club anchor.**
The men's curve has the shape that feels right: a big jump from beginner to club, then a hard climb to elite. The women's straight line reads 7.7 at 60, which puts a club woman only 1.3 levels short of a national team. On the wall that reads as "elite is a few months away".

I'd change it to 40 → 6.6, 60 → 8.0, 85 → 9.0, keeping the clamp at 4-12.
- The 8.0 is my ESTIMATE. I got it by copying the men's shape: their club anchor covers 70% of the untrained-to-elite gap, and 70% of 6.6 to 9.0 gives 8.3. I rounded down for safety.
- John should look for a measured club-women figure (NOT COMPUTED).
- With this anchor, the women's bleep slope above 60 drops to 0.04 a point, so Q1 becomes about 5 chalk lines. That's still fine.

**Q3. Two things would read wrong side by side.**
- **The same bleep number means different things.** An elite woman and an untrained man both read 9.0. A coach knows the two scales differ, but a player sees "Ana = a beginner man". Put a norm word under every number (BEGINNER, CLUB, ELITE for her sex), and have the wall compare each fighter only with their own past bests.
- **Danny's force cell sits blank next to Ana's 770 N.** Until J_TESTS4 lands, show "NOT TESTED" on his card, not 0 or a dash.

On the punches curves, the men's kink at 60 (+10 up to club level, then only +5 to elite) matches the women's (+9, then +4.5), so nothing to change there.

# S293 digest (2026-10-23) - Ludo's pace + money verdict built; the fighter's path holds its money and moves faster

## Operator words (verbatim)
- "am very dissapointed with this project , do not even know what to pick, you make the decision" -> board Q-S289-2 answered for him:
  "Yes, build the verdict" (research/LUDO_PROGRESSION_MONEY_S292.md, Claude's verdict section).

## What now works (evidence)
ef09c67c, golden_path_test -- as_game 10/10 with two bounds that go RED on the shipped files:
- PACE: TrainingPreview PROGRAM_RATE 0.6 -> 1.0, headroom clamp((pot - stat)/25, 0.10, 1.25), LIVED_GAIN_SCALE 0.0066 -> 0.011.
  G6 best week gain: shipped +0.29 (red) -> +0.39 (bound 0.35). Honest gap: Ludo's 1.0+/week is a FOCUSED rookie week; this path's
  fighter is mid-range (headroom 0.6 under /25) and the floor week spreads over stations.
- GOALS (FighterGoal): Debut conditioning +3.5 from start; Make the Weight holds conditioning and builds toward 62 by <= 1.5; Southpaw
  technique +2.5; Gatekeeper conditioning +4 / fight IQ +2.5. Mastery / sparring / familiarity clauses wait for counters.
- REVIEW BAR: WeekReviewPanel STAT_BAND 5 -> 1 - the bar fills to the next whole point; a crossed point is the gold arrow beat.
- MONEY (game arm): first coach sessional $450 (GameState.FIRST_COACH_SESSIONAL), dues $16 -> $22 (membership.json), quick start opens
  with 30 members (seed_opening_members), evening classes +$350/week with a coach (weekly_class_income, in the report + review 'In'),
  amateur bout -> club ticket cut $450. G8 weekly net: shipped -$1,456 (red) -> -$36 (bound -$200); fight-night cash $15,420 -> $22,702.
- Contracts re-pinned with the arithmetic in comments: training_preview, lived_gain, game_money_split, fighter_goal, membership
  Q19-Q22, week_review band. Plain arm 16/16 touched tests. Game arm reds that predate this: week_review (gap 7) and drill_mastery
  (empty-gym setup) -> Cursor #345.
- Exe rebuilt clean (1,200 frames, 0 errors); WHAT_TO_TRY template (Tools/playable/WHAT_TO_TRY.txt) was the S77 one on every build -
  rewritten for the fighter's path.

## Next
1. Collect Cursor #345 GOLDREDS1 by diff (gap 7 + profile_drawer/skip_day_drawer/drill_mastery setup).
2. The operator plays Builds/FightCamp_Godot; his notes drive the next fixes.
3. Parked from Ludo's round (new mechanics, his call): crisis forks (camp investment, fundraiser night, pro-licence wall), rep -> walk-in
   surge, patch sponsorship, fighter-run classes, ABA points/badges, move-mastery goal clauses.

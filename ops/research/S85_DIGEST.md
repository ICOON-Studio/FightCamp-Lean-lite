# S85 DIGEST - the pull (training floor, step 3)
Claude, 2026-09-26. Roadmap `now` from S84: drill mastery, breakthrough days, the coach bond, one floor event, % of a
point everywhere. Commits 5bff374f, 183db4ae, 2571958e (+ merges of Q186, Q187).

## Shipped
- **`DrillMastery.gd` (pure, zero preloads), G115's numbers.** Pips at 6/16/36/72/140 mid-level focused hours; bonus
  +1.5/1.2/1.0/0.8/0.5% on skill stations (+5.0%), +1.0/0.8/0.6/0.5/0.4% on strength/cardio (+3.3%). **Conversion (mine):
  one planned station-day = one focused hour** (4-6 rounds plus the drilling between = three of G115's 20-minute
  blocks) - pip I in 6 days, pip V in 140 (~8 months at 4 days/week, G115's "automatic under pressure 6-12 months").
  Novice x1.8 / elite x0.65 by overall rating, applied to the HOURS BANKED that day, so a fighter's pips never go back.
  Stored as `athlete["drill_mastery"][catalog_id].hours` (per KIND of station, so a new bag keeps his work); pips derived.
- **Breakthrough days (G115 §4, supersedes the design's doubling):** 6% of quality sessions at pip 0-II, 2% from III, 0 at
  fatigue > 50 or pip V; coach bond x0.5..x1.5 (neutral = exactly G115's band); a proc cuts 25-40% of the current pip's
  REMAINING hours, never a free pip. Rolled per session, seeded by fighter + station + day.
- **Pip V** opens the lowest-tier sequence of the fighter's own discipline in the station's family (striking on bags/
  ring, grappling on mats) whose prerequisites he owns - learned in `technique_progress` (source `drill_mastery`), news line.
- **ONE gain rule:** `GameState._mastered_gain` = TrainingPreview.preview_gain x pip multiplier, called by the planner
  preview AND the day tick; hours go in after the gain is taken, so preview == applied with a pip in play.
- **Coach bond (5c):** each ring day steps the fighter <-> head-coach rapport +1 toward his set-point
  (`CoachRapport.apply_pad_day`); the floor's coach tag reads "BOND 62 · tight" (D30: gym words).
- **Floor event (5f, G116):** `FloorEvents.gd` - the bag chain slips (~1 per 2 months per hanging bag, 4-day cooldown,
  one open at a time). CLOSE: $40 swivel, +10 condition, the bag sits out that day (its fighter rests). TAPE: -3 wear, or
  a 30% drop at -35. Unanswered at day end = taped. Card with two buttons on the floor; amber ring round the bag.
  G116's other five wait for sparring (step 4) or a reputation flag (visiting pro, viral clip = season beats).
- **Floor:** five pips (gold earned) over each tag and "DRILL III · 11% to IV"; a breakthrough turns the tag gold with a
  ring at his feet; station name cut from tags (D30). **HOME's day card** leads with "BREAKTHROUGH on the heavy bag" /
  "DRILL II on ..." in gold; **HOME, planner and the Monday note** speak in % of a point (`TrainingPreview.share_label`,
  `change_phrase`). Renders: `docs/previews/s85/` (floor_step3, day_card, monday_report, planner, profile).

## Tests (subsets; the full suite is the nightly)
- `drill_mastery_test` 0 failures: pure rules; 56 REAL days (bag 4 days/week) - pips move only past G115's thresholds
  (pip I at step 15, 9.72 h - a breakthrough the same day; pip II at step 29), hours survive save/load; preview == applied
  at pip III (worst diff < 1e-6, +3.7%); **breakthrough rate over 600 different fighters: 5.8% at pip 0 and 2.0% at pip
  III**, not on a schedule; ring days move the bond, never past set-point; pip V opens a boxing sequence; bag-chain rate 17
  events / 600 days / two bags (G116 ~20), never in cooldown; close/tape/unanswered all land; HOME day card line.
  **Four mutants caught** (preview skips the pip, breakthrough doubled, closed bag still trains, pad day builds nothing).
- **Q187 (Qwen) blind contract test:** 84 checks, 0 failed on master, its 3 mutants caught - two hands agree.
- Subset (drill_mastery, training_*, day_feed, home_pin, coach_*, smoke, career_loop, menu_clarity, scene_router, gym_hub,
  combo_training, technique_training, athlete_development, booked_training): 24 tests, 1 red = athlete_development's two
  pre-existing rows. Last nightly: 2026-09-26 at 9847dd13, SUITE total=416 fails=13 (AgentComms/nightly/latest.txt).

## Collected
- **Q186 (Qwen)** merged: KB head damage per minute by technique class + a KB corner stoppage that needs a knockdown;
  KB finish 6.7% -> 28.9% (Glory band 20-40%), boxing 35.6% and MMA 40.0% unchanged. Re-run on master:
  fight_realtime's only reds = the six pre-existing judo rows; fight_scoring red as before.
- **G116 (Grok)** gym floor events; **G117 (Grok)** how gyms spar (intensity, volume, matching, per-round risk, rivalry
  trigger) for step 4; **D30 (Dola)** pips read untold, breakthrough reads as good news, cut the station name from tags,
  gym words for the bond - acted on.

## Not done (carried to S86)
- Pips on the fighter PROFILE (drawn on the floor and HOME only).
- D30's label stacking (three tags still crowd one bag on the cramped tier-1 floor) and a short breakthrough burst.

## Assigned
Q188 (Qwen) spar-intensity mode in the fight engine (G117); G118 (Grok) how a gym grows, for tiers 3-4; D31 (Dola) did
% of a point fix HOME and the planner. U180 (Cursor) still running from S84.

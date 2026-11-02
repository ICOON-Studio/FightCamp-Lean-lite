# S100 DIGEST - THE PLAN SETUP MOVES THE FIGHT, THE KNOWLEDGE SLOTS BECOME CORNER READS (2026-09-27)

## Shipped
- **Q202 merged** (`740518ee`, Qwen): when exactly one fighter is pinned to the wall, the separation push goes 80/20 to
  the free man, in MMA with footwork on. The longest run below the separation floor went from 25 ticks to 9 (the cap
  is 9). Boxing, KB and MMA with footwork off are byte-identical. It is gated by ruleset because the ungated version
  moved judo's pinned ippon seeds. That is a smell: a physics rule should not know the ruleset. Revisit it when the
  judo pins are re-set.
- **The plan setup moves the fight** (`ca7f1a29`). The begin option is
  `plan_setup {side: {sliders, overall, reads}}`, and each slider drives an existing lever:
  - pace: the volume share, 0.88 to 1.12
  - target: the head weight goes down while the body and leg weights go up, 0.6 to 1.4
  - range: the preferred standoff, 0.92 to 1.08
  - grappling: the shoot rate, 0.4 to 1.6 (no effect in boxing, KB or MT)
  - risk: contact against defence, ±0.02 each

  The overall fit from `FightPlanSetup.overall` becomes a ±0.05 edge on both thresholds, with 85 as neutral. Booked
  and event bouts pass the player's saved setup, and the 3D room gets it on its own sides (swap-aware), so the bout
  you watch is the bout that settles.
  - **The first cut was wrong, and the census caught it.** At volume 0.25, range 0.12 and risk +0.03/-0.04, a
    striker on the far-off plan (inside, pressure, body, shoot, defend first) out-landed and out-won the coach's ideal
    plan. Pace bought volume for free, and "defend first" gained more than it paid. The levers are now flavour at a
    matched cost, and the fit carries the value.
  - **Two corrections to the measurement.** A mirror of a near-zero ideal still scores about 70, which measures
    nothing, so POOR now pins every slider to the far end away from the ideal. And the metric is the landed
    DIFFERENTIAL per minute rather than raw landed/min, because a patient plan throws less and can still be the better
    plan.
- **The knowledge slots become corner reads** (`4838a40f`). These are chief-lane pit-stop cards of 20 s each:
  - "his tell" comes from slot 1 (the style spar) and gives +0.03 contact;
  - "his exit" comes from slot 2 (film) and gives +0.03 defence.

  A read lasts for the next round only. Survive plus both reads does not fit the 45 s minute, so on a bad night a
  read costs the survive instruction. A fumbled read lands nothing. The AI corner picks reads when they fit.

## Measured (`fight_plan_setup_engine_test`, 4/4)
Population: MMA, 3 x 5 min. Striker: reach 188, power 68, grapple 38, conditioning 58. Grappler: reach 178, power 54,
grapple 72, conditioning 68. Both have the whole MMA palette. The catalogue is the shipped one. 40 seeds per arm.
- **OFF:** with no option, and with a neutral setup (all sliders 0, overall 85), the log hashes are equal to the
  PRE-S100 engine on 12 hashes (4 seeds x boxing/KB/MMA). This was checked by running the HEAD~ `FightRealtime.gd` in
  the main checkout.
- **The striker plans:** GREAT scores 98 overall and POOR scores 69. The landed diff/min difference is
  +0.50 [0.27, 0.72]; win share is 0.500 vs 0.350.
- **The grappler plans:** GREAT scores 95 overall and POOR scores 77. The landed diff/min difference is
  +1.53 [1.13, 1.92]; win share is 0.750 vs 0.200. POOR here includes "keep it standing", which is what guts a
  grappler.
- **Corner reads:** with both reads against none (neutral sliders, AI corners), the landed diff/min difference is
  +0.24 [0.15, 0.32].

## Suite
The 2026-09-27 nightly at `40bec39e` was 439 total with 24 fails. Subsets run this session:
- fight_plan, fight_night, sharp_edge, fight_realtime, camp and separation: 13 tests, 1 fail.
- corner, pit, limb, fight_night, plan and world_live: 16 tests, 1 fail.

Both fails were already red on the nightly. **The fight_realtime red is 7 judo pins**: seeds 94003, 94009 and 94014 were
pinned to end by ippon and now end by shido disqualification (hansoku-make); 94004 and 94006 went the other way. The
cause is U190's judo change. Plan setup cannot reach judo, since fights without a setup are byte-identical. These are
stale values for S101. The world_live red is C215's.

## Agents
- **Q203 (Qwen)** is running in `Temp/FightCamp-Q164` on branch `qwen/q203-realism-reds`.
- **U191 (Cursor)** was found dead with 80 lines uncommitted. That work is saved as `d9ccbe66` on
  `cursor/u191-footwork-side-effects`, and Cursor is relaunched from it with an instruction to commit as it goes.
- **C215 (Codex)** is still queued behind the two-agent cap.

## Not done
- **Stale values**, which wait on U191 and Q203: judge_panel T4/T8R/T11, result_screen_why, the fight_strike_whole
  hashes, and now the fight_realtime judo pins.
- **The opponent has no plan setup**, so the player's plan is measured against a neutral man. S101 gives AI corners a
  setup whose quality comes from the coach.

# S99 DIGEST - THE RED LEG UNSTAGED, THE REDS SORTED, THE FIGHT PLAN AS A SETUP (2026-09-27)

## Shipped
- **Unstaged red leg** (`1e88a1ea`): `tools/s99_leg_seed_scan.gd` builds the production room per seed and runs a copy of
  its engine to the end. With the room's own demo fighters in MMA, 4 of 12 seeds take a leg to HURT, all in round 3,
  none to CRITICAL. `tools/s99_render_red_leg.gd` renders seed 99008 with nothing written into the fight: it only
  fast-forwards and sends the corner empty. Fighter A's right leg was stung at 756.258 s, the tick the scan predicted.
  `docs/previews/s99/red_leg_unstaged.mp4` was sent to the operator.
- **fight_night_realtime green**: the lab pairing is now roster[1] vs roster[0] (rests=2). U189 had made the old pair a
  round-1 TKO, so no corner window ever opened. The corner check is unchanged.
- **C214 merged** (`f784e744`): an ordinary landed leg kick is a 0.60 s upright hitch (StaggerSmall01); the heavy
  collapse only plays at CRITICAL/DOCTOR. Root XZ excursion 0.0000 m.
- **Q200 merged** (`c13be469`): advance_week now matches advance_day on floor events and the open spar night; presenter
  and fidelity tests get a synthetic clipless beat. The GameState change was reviewed. Subsets 10/0.
- **smoke_test green**: the music-continuity check accepts S94's playlist hand-on (it only accepted a looping MP3).
- **U190 merged** (`5149a535`): judo attempts went from 0.50 to 9.26 per 4-min match [7.89, 10.63]; scores are 6.6% of
  attempts. The change is judo-only; boxing, KB and MMA are byte-identical on 10 seeds.
- **Fight plan setup** (`6baa0532`, the S99 build): `FightPlanSetup.gd` (pure) has five sliders (range / pace / target /
  grappling / risk) that set three coach reads (offence fit / defence fit / engine). The coupling means every slider
  moves two or more reads. The hidden per-opponent optimum is a corner's logic on reach, power, chin, tank and
  grappling, plus a per-opponent jitter. The opinion bands are Motorsport Manager's (0.03/0.10/0.20/0.30). The
  knowledge band is 1.0 wide, 0.75 once slot 1 opens (a camp week with the Mirror partner) and 0.3 once slot 2 opens
  (film). Code: `GameState.get_plan_setup_view` / `set_plan_setup`; `FightPlanSetupPanel.gd` opens from the camp panel
  with a FIGHT PLAN SETUP button, in setup and in camp. `fight_plan_setup_test` 27/0; with the knowledge rule broken on
  purpose it goes 2 red.
- **Q199 sorted into stale values and real defects** (Claude's ruling):
  - STALE VALUES, to update after Q202 + U191 merge (both move the engine): judge_panel T4/T8R/T11 (use
    `tools/s21_repin_judge_cards.py`), result_screen_why (seed 92043 ends before round 3; pick a seed that reaches it),
    fight_strike_whole baseline hashes.
  - DEFECTS, tasked: U191 (Cursor, running) covers the five footwork side effects: clash 3.01 s, feint bites 0, low-kick
    contact 0, grapple films suspended, walkout Y 2.5 cm. Q203 (Qwen, queued) covers jab share 20.4%, R16 cut-off and
    the landing order. C215 (Codex, queued) makes footwork visible again so fight_world_live can pass. Q202 (Qwen,
    running) covers the separation gap.

## Suite
Nightly 2026-09-27 at `40bec39e`: 439 total, 24 fails. This session turned five of them green: smoke,
fight_night_realtime, daily_progression, fight_stage_presenter_contract, fight_stage_technique_fidelity (the last three
through Q200). Subsets that were run: camp/UI 24/0, the Q200 set 10/0, judo/grapple 14/3 (the same 3 as the nightly).

## Not done
- The setup does not move the fight yet. S100 wires the sliders into the engine's intent and turns the knowledge slots
  into corner reads.
- The stale values above are not updated yet (they wait on Q202 and U191).

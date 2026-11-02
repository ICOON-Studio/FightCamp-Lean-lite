# S97 DIGEST - LIVE LIMB DAMAGE + THE CORNER AS A PIT STOP (2026-09-27)

Operator (verbatim): *"in between the rounds i want the corner to be presented (visually indicators,text wtc) with the
problems and be able to understand them and be able to address them against the limited time"* and the dilemma *"do
not blow the nose in danger of the eye swalling or risk blowing it for some benefit ?"*. Built from G132, G133, D44 and
the Motorsport Manager study (S96).

## Shipped (all behind `limb_damage`, default OFF)
- **`CornerPitStop.gd`** (new, pure, no preloads): bands fine / hurt / critical / doctor (limbs 70/40/15; face pips
  1 / 2-3 / 4); `problems()` - worst first, max 3, words BLEED / CLOSE / SWELLING / NO-AIR / DEAD-LEG / RIBS / WOBBLED /
  STOP, zero in a clean fight; `cards()` - enswell 15 s (cutman), close the cut 25 s (cutman), ice a leg 15 s / ribs
  12 s (second), **blow the nose 3 s (second, TWO-SIDED: wind back vs 35% orbital emphysema when an eye or the nose is
  already swollen, 3% otherwise - the eye gains 2 pips and can shut)**, water-sit-survive 10 s (chief); MM's critical
  path (lanes in parallel, `USABLE_S` 45 per G133); paces careful x1.25 / normal / rushed x0.7 with mistake 3/8/20%
  scaled by cutman skill; `apply()` refuses an over-budget plan WHOLE; a rushed enswell can shove the swelling up;
  `payoff()` eased / held / worsened; `auto_plan()` for the AI corner (never blows a nose with the orbit swollen).
- **Engine** (`FightRealtime.gd`): the switch seats its own stream (`SEED_CORNER`) so OFF draws nothing new; a HURT
  leg slows the feet (x0.92 / 0.80 / 0.70 by the worse leg); legs keep what they take (leg wear x4 under the switch,
  AUTHORED to G132's proxies) and recover at most a third of a normal minute (UFC 6: legs do not recover); a bleeding or
  swollen nose keeps 40% of the minute's wind OWED until the nose-blow pays it; the doctor stops a shut eye; each bell
  records a pit stop per corner, the AI corner decides at once, the player's waits (`pending_pit_stop`,
  `apply_player_corner` - refused outside the rest, when over budget, or twice).
- **Live room** (`FightWorldLiveScreen.gd` + new `CornerPitStopPanel.gd`): with the switch on, the between-rounds card
  is the pit stop - body figure with pulsing hotspots and severity words, job cards (Benefit | Risk | seconds | lane,
  the nose-blow in amber), the chief's instruction row, CAREFUL / NORMAL / RUSHED with the slip %, a 45 s bar that
  REFUSES a job that does not fit, SEND HIM OUT. It applies to the **LIVE fight** (the old `CornerPanel` deep-copies
  the state and applies its instruction to the copy - so its instruction never reached the bout; left as is for the
  switch-off path, noted for a later fix). Live cues: chips (L-LEG / R-LEG / BODY / EYE / CUT / AIR in D44's colours)
  under the round clock, sampled per pumped tick so they change when the blow lands ON SCREEN; the leg reaction plays
  when a leg crosses into HURT (stung) and the torso leans off a hurt leg / folds over hurt ribs (spine, after every foot
  pass, never compounding); the payoff line at the next bell ("LEFT EYE: EASED · AIRWAY: WORSENED").
- **`CornerPanel` (the switch-OFF card, the default game) applied its instruction to a deep copy - no corner
  instruction ever reached a live bout.** Fixed (`_live_state`); `corner_panel_test` only read the returned outcome, so
  it now also checks the fight - and the old card fails that check (control run).
- Payoff compares ALL problems, not the three the card shows (a fourth read as "worsened" in the first render); a
  cleared airway stays clear until the next bell (`air_cleared`); ranking on a tie: head, eyes, legs, air, cut, body.
- The stung moment is the leg kick's own `react_leg` (H2H_StaggerLarge04_LowHit, 2.7 s, nearly to the floor) - playing
  it again on the band change dropped the man to his hands, so the room does not. **That clip is too big for every
  landed leg kick too** - a lighter leg-hit reaction is motion-lane work.
- Render: `tools/s97_render_corner.gd` (production room, kickboxing, seed 97102 - 97101 is a round-1 KO and never
  reaches a break). STAGED at 0:20: left leg 62, left eye swelling 2, right brow cut 1, nose cut 1. Out:
  `docs/previews/s97/` stung_and_chips, corner_card, corner_picked, corner_sent, payoff_next_round (+ stung.mp4,
  corner_walkthrough.mp4, sent to the operator). In that run the nose-blow's 35% landed: AIRWAY EASED but air in the
  orbit undid the enswell (LEFT EYE HELD) - the operator's dilemma, played out.
- Try it: `FightCamp.exe -- limb_damage` (or the room option / bout engine option `limb_damage`).

## Measured
- `tools/s97_limb_census.gd`, kickboxing 3x3, **population: Thai kicker (`kickboxing_thai_kicker`, 183 cm) vs counter
  striker (`kickboxing_counter_striker`, 176 cm), both with the full KB tier 1-2 palette (45 nodes)**, seeds 970000+,
  100 bouts: OFF and ON outcome mix IDENTICAL (decision 63 / KO 21 / TKO 16, CI95 +-8-10; kicker wins 48%); the corner
  saw a problem in 9% of 348 minutes (seal 23, enswell 4, nose-blow 2, survive 2; 2 mistakes) - zero cards in clean
  fights, as designed. (Identical because no leg reaches HURT and face marks move no outcome - see the finding.)
- **FINDING: no leg ever reached HURT.** ~2.3 leg strikes land per fighter per bout (torso 22.4, head 27.1, legs 4.6
  landed per bout) - ~8% of landed, against U178B's MMA fix; **the kickboxing ruleset never received U178B's selection
  keys.** Worst leg at the final bell 95/90 ON. So live limb damage cannot fire on its own until U189 lands.
- Face marks: 20 kickboxing fighter-fights gave 5 marks at 1 pip and none at 2, so the cutman acts from the first pip.
- Tests: `corner_pit_stop_test` (new) 0 failures, **five mutants all caught** (panel applies to a copy, bar never
  refuses, legs fully recover, air never owed, AI corner waits). Subsets: corner_ 8/8, fight_realtime 1/1,
  judge_panel 1/1, fight_night_realtime 1/1, fight_kb_corner 1/1. **fight_world_live_test RED on master too** (four
  footwork-readout lines; control with master's room file fails identically; nightly 9847dd13 had it green) - not S97;
  flagged as its own task.

## Agents
- U188 (Cursor) NOT merged, second miss: slide p95 1.18 vs bar 0.573; its kneel probe flags 922 of 922 knee samples at
  canvas_world_y 1.28 m - every knee on every frame, which points at the instrument. -> Q198 (Qwen, queued behind Q197):
  audit both feet instruments before any sixth fix.
- U189 (Cursor, launched): kickboxing leg share - U178B's selection for the KB ruleset, PROXY band 14-20%.
- G134 (Grok, sent, chat eaf86efc): kickboxing leg-kick share and the limp curve, to re-pin U189's band.
- Q197 (Qwen) still running at S97 end (research, throw landings).

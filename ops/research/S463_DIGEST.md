# S463 digest (2026-11-14) - steps learned and read, Knowledge proved, design loop round

## Built (pushed to main)
- LEARNPICK1 (his Q-S294-221 "Yes, greybox it"): `scripts/rules/StudyWeek.gd` + the WHAT TO LEARN NEXT card on her page
  (FighterPage tab 1, shown on Overview) + the `study` act (BoutActs) + DrillWeek runs the study slot on the week's pad nights.
  The coach's three cards are LearnSlots.cards (SLOTS1); a punch pick = her pad move (f["learning"]); a step/defence pick = the
  study slot (f["learning_slots"], 1 slot until a pads assistant is wired). Gain = LearnSlots.DEFAULT_GAIN 6 x speed x pads/3,
  capped at MoveMastery.cap. At 30 the slot frees + news. Tests: study_week_test (pure + DrillWeek path, step_back 0 -> 32 in
  5 weeks), study_pick_walk_test (real scenes: sign -> click Study tie up -> 35 days -> usable, slot free, news). Still:
  tools/study_still.gd (on the review board, sent to him).
- STEPMASTERY1 gate ON: `FireLevel.mastery_of` reads `StepMastery.fire_mastery` for step/defence arrows (no bars = 100 = before).
  A new boxer's step_back/pivot/tie_up start at 0 (StepMastery.start_values), so they never fire until studied. plan_bout:
  drilled steps keep +1.94 plan edge, undrilled +1.20 (new check). fight_why / phase_wire fixtures put their plan's steps at 85
  (they grade the plan, not the drilling). MoveBook shows step tiers and "Not learned (n of 30): never comes off".
- Tests green: study_week, study_pick_walk, learn_slots, golden_path, pad_week, fire_level, plan_bout, plan_chain, fight_why,
  phase_wire, bout_marks, clinch_rest, clinch_why, corner_swap_cards, fight_flow, line_swap, perk_fight, move_book, game_plan.

## Probes collected (each rerun by Claude on the same seeds before reading)
- KNOWBOTS2 (PR 265): page honest (rerun identical, READER-BLIND -3) but VOID by construction (read the centred shape; results
  from an independent rating; BAD beat BLIND).
- KNOWBOTS3 (qwen/knowbots3 b0b58da0): PASS, rerun identical. Truth = AttrGen.attrs_of (corr with rating 0.80). ORACLE-BLIND +14
  (instrument), BAD 40 < BLIND 87 (control), READER-BLIND +6 top-10s per 60 worlds after paying (bar 5), 43% of the ORACLE gap,
  sensitivity +8. Knowledge step 2 done; step 3 (wiring) waits two critics 6+/6+ on v2 (SQ93 Dola, SQ94 Maria).
- NODEREAD1 (PR 266): rerun same verdict - punches read (6), the 10 steps/defences change no bout (0 differing bouts). The seat's
  page had two numbers a cell the committed probe never writes: the committed page is the rerun's own. Its bouts set
  fire_level={} (always fire), so it could not see the new gate; TREEVALUE1 runs with the game's shares.

## Delegated
- Qwen: NODEREAD1 (landed), KNOWBOTS3 (landed), TREEVALUE1 (running from 03:53, ETA ~05:15: node value under the game's fire
  shares, 60 generated fighters, 4 styles; control = probe_off arm must show no step value).
- Seat queue: SQ93-94 Knowledge v2 critics; SQ95-96 fight week v8 (Dola, John); SQ97-98 club week v5 (Dola, John); SQ99-100
  coach fit v5 (Kalli, Maria; Dola's v5 cut at section 12 again, flagged in the brief); SQ101-102 push/tank v2 (Dola, Maria);
  SQ103-104 weight round 2 (Kalli, John; never scored); SQ105 Kalli writes TURNPRO1 v1 from the code facts + John's numbers.

## Design loop
- HOSTSHOW1 v4 DESIGNED: John 7/7, Dola 8/8 -> his board Q-S294-222 (build after the fight week?).
- R58 (a fighter leaves) DESIGNED earlier this session -> Q-S294-220.
- LIVERRIBS1 v2: Maria 7/6; John's score pending (SQ91).

## Lessons
- A probe that sets fire_level={} cannot see mastery: every planned line fires. Probes about mastery leave the key out.
- A seat's result page can differ from what its committed probe writes even when the numbers are honest: keep the rerun's page.
- Dola's long chat answers get cut near the end (COACHFIT v4 and v5 both at the wiring table): ask for the table first next time.

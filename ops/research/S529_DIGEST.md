# S529 digest (2026-11-19, Opus)

## Decisions
- Coach fit phase 1 (COACHSCOPE1): ops/research/COACHFIT_SHEET.md written from CoachFit.gd. Fit reaches 28..82 in play
  (10/90 only through the time penalty, now cut). Two channels only, joined to WeekPlan: gain (multiplied through
  capped(), never below today's product - a live x1.89 weak-spot 1-to-1 in a Hard camp stays x1.89 at fit 50) and
  tiredness (load x tired_mult, held 0.92..1.08). The corner stays uptake x trust (owner Q-S294-86 "no new meter"); the
  coach-time budget is ClubDeal's (S519); Steady's free +2 -> 0; mode is not a player control (the right mode is decided
  by the card). The earlier probes already say a TOP fit is felt by no one (+0.95 stat / 26 weeks, Sharp 1.5 weeks
  sooner, +0.08 wins in 100) -> phase 2 asks ONE question: is there a gain slope inside the cap worth +4..+8 wins? NONE ->
  fit becomes a hover reason, not a number.
- Guard "under half" (the Tie up clinch) reads the guard AFTER this exchange's wear and recovery: the clinch answers the
  blows just taken (GuardState header). Found by Arena's blind test.
- Text at Largest: buttons in the corner bar keep 20 px (corner_bar_test rule), so "Say nothing" got room (140 px) instead
  of a smaller font; the plan chart's bell box 450 px + fit-to-slot (min 16 px, then "..." + hover); the roster's coach
  line clips like its neighbours. TextScale.fit_on_resize is the reusable helper.

- Turning pro: v3 critics Goose 7/7, Arena 5/4 -> v4 from the code (Goose TURNREV4, collected). Seen defect fixed: the
  "own ticket price" ask paid at the fixed $50 (ProCall.money, ProOfferWire.night) - now the deal's price. Open: ProCall
  .ambition_kind looks for "pro", which no Recruit.ambition says (v4 s6 proposes the preference line).
- Knowledge stakes: Dola's hidden flaws already exist (Durability, the 20 habits) -> code check -> v2 (SQ239).
- Animation (the owner's Fable session, stopped ~520k): built headless in scripts/fight3d/v2, film 7 + blind round owed.

## Evidence
- tests/coach_fit_sheet_test.gd: red first (11 of 49 - exactly the three decisions), then green; coach_fit_test green.
- tests/guard_contract_test.gd (Arena, blind): 3 red on the shipped code, all test timing; fixed; mutant
  CLINCH_THRESHOLD 0.6 -> 2 checks red; guard_state_test green.
- Text-size audit (layout_snapshot text=3 with --log): TEXTFIT 2 -> 0 (E:/FightCamp/tmp/s529_text3b); the 60-screen
  contact sheets found the roster overlap the TEXTFIT line cannot see.
- Critics: TURNPRO1 v3 Arena 5/4 (DESIGN_TURNPRO1_V3_CRITIC_ARENA.md).
- Tests green: pro_call, pro_offer_wire (both red first), pro_debut, pro_contract, pro_lean, pro_week_lines,
  loyal_pro_share, coach_fit_sheet, coach_fit, guard_contract, guard_state, corner_bar, plan_chart, text_scale, file_limits,
  film_night, halo, roster_cards, roster_summary, roster_row, roster_rows_page, test_club.

## Delegated
Goose COACHFITPROBE2 (#401) + TURNCRITIC3G (#403); Arena GUARDBLIND1 (landed, collected), TURNCRITIC3A (landed,
collected), STEPBLIND1 (running); Qwen TREEVALUE5 (running); Dola SQ236-238 (queued by the reconcile).
Housekeeping: the obsolete STEPTUNE2 probe stopped on the owner's yes (it held a Godot slot the animation session waited
for); six collected briefs marked DONE (start's CONTRACT DEFECT line gone).

# S146 DIGEST - 2026-10-02 (night): the week tells the truth, PLAYTEST pass 2, U211 refused

Operator at start: "you take all the work until missing agents are back, you still have dola, maria". Codex MH2 kept
running on its own; Q213B ended incomplete on heat (RED 85 C); Cursor/Qwen/Grok out. Claude built, Dola and Maria
researched/art-directed.

## 1. What now works (each with its evidence)
- **Week review tells the truth (U213 item 5, P36/P37/P40/P44)** - 659b260e, cb10c6c8, 0d2449dd. PAID OUT = the monthly
  bill + fight-camp cash (wages/upkeep accrue weekly, bill once a month - the old board subtracted both); NET == the bank's
  real change; amber line 'WAGES + UPKEEP THIS WEEK $X · ON THE MONTHLY BILL ($Y SO FAR) · DUE 1 FEB'; each fighter's real
  gains before -> after ('DEFENSE 54.0 → 54.1'), also in the Monday report (no more '+13%' every week); layout fixed
  (plates no longer stretched, rows grow, world results one line + tooltip, identical hooks '(3 OFFERS)', breakthrough %).
  Evidence: week_review_test (paid camp: NET -24 == bank 25000 -> 24976; old sum read +876); stills
  docs/previews/u205/week_review_w1.png + _w4_billed.png; seen in the exe walk (still s146_p2/061).
- **PLAYTEST pass 2** (research/PLAYTEST_S146_PASS2.md): cold AI walk in the exe, empty gym, same choices as
  pass 1. The loop now closes: sign (1 click from HOME) -> coach -> train -> booked week 1 -> camp -> weigh-in -> live
  3D bout -> result -> next offers, all in 5 in-game weeks (pass 1 never reached T5). PLAY scores 1 -> 2 in all four.
- **12 pass-2 issues fixed with gates**, then re-checked live in a rebuilt exe (pass 2b, E:/FightCamp/playtest/s146_p2b):
  CRITICAL broke-at-first-fight -> 0-0-0 novice asks the $250 stipend (J5: fighter wages are invented polarity;
  first_months_cash_test ON $9,264 after 8 weeks vs OFF -$1,748), stipend market for loyalty (no 'STRAINED' on day one);
  amateur record shown after the first bout (UIKit.shown_record); booked fighter's offers not 'waiting'; hiring a coach
  coaches your fighters (auto-assign); 'Open offers' opens OFFERS (verified live); fight week reads the camp it ran, no
  'he'; amateur bouts '3 x 3:00'; overdrawn cash red '-$666' + tooltip; honest pin/status words; a boxing gym's Scouting
  SCREEN lists boxers first (verified the board AND the panel). Game switches all default empty_gym_start() - headless
  tests are the control arm, each new check has an OFF arm that reads the defect.
- **U211 FOOTLOCK refused**: C223 production gate (same scope as the certificates) - 32/32 certified move x welter rig pairs
  regress vs master (lead hook contact slip 0.005 -> 13.9 cm). research/U211_C223_VERDICT.md. Not merged.
- Bots: D68 (Dola, one-more-turn) collected; D69 (Dola, fresh eyes on the first hour) collected + 8 of 10 applied;
  M39 part 3 (Maria, venue ladder) collected (parts 1-2 still in her chat); M40 (Maria, the week review LOOK) collected -
  a full build spec; D70 WITHDRAWN (operator: "check existing research first" - G74/J8 already hold it).
- Tools: grokbots New-chat picker fixed (visible role=option), `send --out` writes the whole reply.

## 2. Gates run
week_review_test, first_fight_for_every_fighter_test (+ mutant: booked skip off -> FAIL got 3), home_pin_counts_test,
first_job_card_test (D coach ON/OFF, E scouting board + panel ON/OFF), first_months_cash_test, shown_record_test,
fight_week_words_test, day_feed_screen_test; run_tests --only sets (--jobs 2): 22/0, 20/0, 17/0, 6/0, 8/0, 7/0, 12/0,
49/51 (the 2 = fight_back_bands_contract + fighter_reachability_contract, red in the 10-02 nightly on master).
One run started while the watchdog read RED (19:33, 85 C) - should have waited; noted.

## 3. Open, ranked (PLAYTEST_S146_PASS2.md has the full list)
- GLOVES (operator asked 20:00 "is the new gloves finished on the fighters" - NO): C241 run 4 never launched; the approved
  CC-BY Sketchfab glove sits in E:/FightCamp/incoming/. Claude takes it (no Codex seat).
- M40 week-review LOOK - Maria's spec, Claude builds it.
- P2-13 economy still bleeds ~$1,400/wk from one coach (solvent ~4 months): authored balance pass (J5/J8: label invented).
- P2-16/17 live bout: blotchy clothes, barefoot, one still with a knee at hip height (no knee in the palette - check on video).
- Q213B (last 3 clipping moves) ended incomplete on heat - checkpoint ceb04637.

## 4. Next (decision)
Claude: (1) C241 run 4 - fit the approved CC-BY glove to both corners, stills from the live room, credits file;
(2) build M40's week-review look; (3) P2-13 economy balance; then the operator's cold session on the exe.
Collect MH2 (Codex) when it lands.

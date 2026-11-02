# TASK STORYPARITY1B (S221) - wire the sandbox predatory offers + the debt event into the week, the inbox and a modal

Model: cloud Cursor (label `cursor`). Branch `cursor/issue-<n>` from master (STORYPARITY1A merged cdfbc81e). Open a PR, never merge.
No Git LFS on the cloud box: the test must not load models. Do not delete or shorten any existing test.
Approved: operator board Q-S212-16 on research/LUDO_ROUND53_VERDICT_S219.md section C (read section C whole - the numbers
and the 5 corrections). INSOLVENCY ENDS THE CAREER is part of the approved verdict.

## Why
Sandbox starts (no story) must still carry the pressures the story teaches: a predatory promoter dangling quick money, and a hard
decision when the gym's cash stays below zero. The rules already exist as two pure modules (STORYPARITY1A):
`Godot/scripts/PredatoryOffers.gd` (140 lines) and `Godot/scripts/DebtEvent.gd` (84 lines), pinned by
`Godot/tests/sandbox_parity_rules_test.gd`. This task makes them HAPPEN in a sandbox career. Do not change the two modules' numbers.

## Owned files
- NEW `Godot/scripts/SandboxParity.gd` - ALL the glue logic lives here (pure, static, `extends RefCounted`): it takes the career
  state slice + rolls and returns the new slice + events. GameState only calls it. Target < 400 lines.
- `Godot/scripts/GameState.gd` (20,257 lines - NEVER read whole). Windows you may read with `sed -n`:
  `7986,8030p` (advance_week start: the blocking-fight early return at ~8021 is the pattern for a blocking decision),
  `8390,8430p` (end of advance_week: the hook goes just BEFORE `if not save_current_career():` at ~8401),
  `4313,4330p` (how a switch is read: `station_wear_on()`), `18243,18265p` (`is_story_campaign_on()`),
  `12198,12310p` (short-notice offers: `_short_notice_candidate`, `get_short_notice_offers`, `accept_short_notice`).
  Add at most ~120 lines to GameState, all in ONE new block marked `# --- STORYPARITY1B (switch sandbox_parity, ON in the game - GAME_ON)`.
- `Godot/scripts/GameSwitches.gd` - add `"sandbox_parity"` with a one-line description (same style as `"station_wear"`, line 41).
- `Godot/scripts/StoryInboxPanel.gd` (159) - the offer card (see UI).
- NEW `Godot/scripts/DebtDecisionModal.gd` - the blocking debt modal (see UI).
- NEW test `Godot/tests/sandbox_parity_wiring_test.gd`.

## Do
1. Switch `sandbox_parity` in `GameSwitches.GAME_ON` (operator S221: new features ship ON), read with `GameSwitches.on("sandbox_parity")`; plain `--script` tests stay the OFF control arm. Everything below runs only when the switch is ON AND
   `is_story_campaign_on()` is false (correction 5: the story keeps its scripted Marcus Vance trap untouched). OFF = today's game,
   byte-identical: the save gets no new key, advance_week returns the same dict.
2. State in `career["sandbox_parity"]`: {cooldown_weeks, pending_offer{terms, weeks_left, legal_reviewed}, active_contract{terms,
   bouts_left}, neg_weeks_in_a_row, immunity_weeks, debt{kind, principal, remaining, missed_in_a_row, weeks_since_choice,
   neg_weeks_in_receivership, austerity_weeks_left}, pending_debt_decision{deficit}}. Normalise missing keys (old saves).
3. Weekly tick (called from advance_week just before the save; rolls from the GameState's existing RNG, passed in as floats):
   a. Offers: decrement cooldown / pending weeks_left (expiry -> outcome "expire" -> cooldown 6). If no pending/active, roll
      `PredatoryOffers.offer_fires(state, roll)`; on fire build `tier1_terms(5 rolls)` and push ONE inbox card.
      win_streak / won_last come from the gym's top fighter's record (the fighter the offer is for; report which accessor you used).
   b. Debt: if cash < 0 increment neg_weeks_in_a_row, else reset to 0. Decrement immunity. If `DebtEvent.should_fire(...)` and
      no pending decision -> set pending_debt_decision{deficit = -cash}.
   c. Active loan: charge `loan_payment(principal, remaining)`; if cash would go below the payment's coverage rule you choose
      (report it), count a miss and apply `missed_payment_step` (notice = prestige -50; repossess = remove the most valuable
      equipment instance; foreclosure = treat as insolvent). Austerity: upkeep x0.5 while austerity_weeks_left > 0 (apply the
      other austerity multipliers only where a clean hook already exists; list the ones you skipped).
   d. After a choice: `after_choice_state(...)`; "receivership" -> no signing/buying (return the reason from the buy/sign APIs) +
      one forced auction of half the equipment at 30% value; "insolvent" -> `career["ended"] = {"reason": "insolvency", week}` and
      the next screen is the career-over screen if one exists (else a modal with the reason and a button to the main menu).
4. advance_week BLOCKS while pending_debt_decision is set: return
   `{"ok": false, "reason": "DECIDE HOW TO COVER THE DEBT BEFORE ADVANCING THE WEEK", "debt_decision": {...}}` (same pattern as the
   booked-fight block). API: `get_debt_decision() -> Dictionary` (the three options with their numbers from DebtEvent) and
   `choose_debt_option(kind: String) -> Dictionary` for kind in loan | emergency_fight | austerity. Every choice sets immunity 3.
   Emergency fight: pay `paid_now` at once and offer the bout through the EXISTING short-notice path (5-9 days out, opponent gaps
   from the rolls, stamina penalty + injury chance stored on the booking); say how you mapped it.
5. Offer API: `get_predatory_offer() -> Dictionary` (terms + `visible_tells(terms, legal_reviewed)`), `seek_legal_review()` (-$350,
   reveals the clause), `accept_predatory_offer()` (advance paid now; active_contract with 3 bouts; the promoter cut applies to
   those bouts' purses), `decline_predatory_offer()` (outcome "decline"). Bout results feed `PredatoryOffers.outcome(...)`;
   a finished contract sets cooldown 16.
6. Cash moves go through the gym ledger the way other cash moves do (GymLedgerRead / cash_log), with plain labels:
   "PROMOTER ADVANCE", "LEGAL REVIEW", "LOAN", "LOAN PAYMENT", "EMERGENCY FIGHT (SIGNING)", "FORCED AUCTION".

## UI (switch ON, sandbox only)
- Inbox card (StoryInboxPanel or the inbox the sandbox uses - report which): title "A PROMOTER WANTS YOUR FIGHTER", the advance,
  "3 BOUTS - PROMOTER KEEPS 45%", the tells as chips (SPLIT / STAT GAP +N / UNSANCTIONED), the clause chip only after review,
  buttons ACCEPT / SEEK LEGAL REVIEW ($350) / DECLINE, "EXPIRES IN N WEEKS".
- DebtDecisionModal: centred, blocks the week. Header "THE GYM IS IN DEBT: -$N", three option cards (LOAN: principal, weekly payment,
  16 weeks; EMERGENCY FIGHT: purse, paid now, opponent +power/+technique, injury risk 35%; AUSTERITY: upkeep -50% for 8 weeks and the
  penalties). One click picks; no close X (it is a decision). Max 900x560 at 1920x1080.
- No developer text on any player screen.

## Test - `Godot/tests/sandbox_parity_wiring_test.gd` (extends SceneTree, prints `SANDBOX_PARITY_WIRING_TEST PASS (<n> checks)`)
Drive `SandboxParity.gd` directly with hand-built state (no GameState node needed for most checks); one check may instance GameState
headless if it needs no LFS. Checks:
1. Switch OFF (or story ON): the tick returns the state unchanged and no events.
2. Week 8, cash 14200, roll 0.03 -> one offer event; roll 0.05 -> none. With a pending offer, no second offer.
3. Offer expires after 3 ticks -> cooldown 6; next 6 ticks never offer even with roll 0.0.
4. Cash -450 one tick -> no decision; second negative tick -> pending_debt_decision{deficit}; cash back >= 0 resets the counter.
5. Loan chosen on a 1650 deficit -> principal 7500, first payment 918.75, immunity 3 (no new decision for 3 ticks even if negative).
6. Austerity -> upkeep multiplier 0.5 for 8 ticks then 1.0.
7. After a choice, still negative at weeks_since_choice 4 -> "receivership" flag set; 6 more negative ticks -> ended insolvency.
8. Missed payments 1/2/3 -> notice (prestige -50) / repossess (the most valuable item gone) / foreclosure.
9. Accept -> advance in cash, 3 bouts; a win pays purse*(0.55); third bout done -> cooldown 16.
10. Mutants (inside the test, each must turn an assertion red): (a) story ON not checked; (b) immunity ignored; (c) cooldown not
    decremented.

## Gate
`python Godot/tools/check_scripts.py <every touched .gd>`; then
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/sandbox_parity_wiring_test.gd` and
`--script tests/sandbox_parity_rules_test.gd` (must stay PASS). Paste both PASS lines in the PR. Claude runs
`run_tests.py --jobs 2 --only advance_week,week,ledger,short_notice,story,inbox,game_switches` on the PC.

## VISUAL GATE
UI screens (inbox card + modal): Claude renders both on the PC at 1920x1080 and opens them; the operator closes it. Not a body,
animation or fight-camera change.

## Prior research
LUDO_ROUND53_VERDICT_S219.md section C (the rules + corrections), LUDO_ROUND52_VERDICT_S217.md (sandbox parity, the three starts),
topics/money_business.md, TASK_STORYPARITY1A.md, PromoterTrap.gd + promoter_trap.json (the story's trap - read only, untouched),
short_notice.json (premium x1.35).

## What would a human do?
Keep the rules where they are (pure modules), write one small glue module that turns "a week passed" into events, and let the big
GameState file only call it - the same way StationIntegrity is wired.

## Prefab check
None - our own rules and screens; the modal reuses the project's existing modal/card styling.

## The one trap
GameState.gd is 20k lines and every session edits it: put logic in SandboxParity.gd, keep the GameState block small and in one place,
and never let switch OFF change a byte of the save or of advance_week's return.

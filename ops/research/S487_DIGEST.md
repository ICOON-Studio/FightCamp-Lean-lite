# S487 digest (2026-11-15)

## Shipped (main, pushed; export built 14:20)
- R58 APPROACHWIRE1 (576a681a): Eastside ABC's approach is live and on screen.
  - scripts/state/ApproachWire.gd: Monday opens an approach (Approach.due: loyalty under 35, worth taking, 12 weeks clear);
    group "keep" only for a boxer on a day job, the holder = the most loyal team-mate on the stipend (none for a bout/debut
    offer, which also closes Approach.answers offering MOVE without a stipend ask). Talk once (Loyalty.can_tell_straight).
    Answers: MATCH (stipend held to day+84), HALF ($125 + $125, both x0.925 training, holder -4), MOVE (holder to a day job,
    -12, a -3 grievance every 28 days unless Loyal), PROMISE (GymSpend.book_show + a Promises show_top row; offers and the
    idle tick wait for the night; kept +10 / broken = leaves), LET GO (leaves next Monday). Unanswered = leaves.
  - Hooks: GymSpend (Monday call, show night, set_stipend lock "held to ...", gain x train_mult), Career.promises,
    LoyaltyWire (wants_sponsor + idle tick wait for a promised show), Bouts (no offers / no offer_passed while promised),
    Needs (red need "Eastside ABC wants X", APPROACHED flag).
  - scripts/ui/ApproachCard.gd: the card on top of the Overview (name only in the header; five columns with cost, loyalty
    in 12 weeks with its band, team-mate, training; grey answers say why on screen); Overview "Let go" with
    Leaving.let_go_price's confirm. Still: ops/previews/s487/approach_overview.png (checked, on the review board).
  - tests/approach_wire_test.gd walks every answer in the day loop: PASS. 23 touched tests green.
- LOYAL3 (Arena probe) merged; Approach tuned from it: MOVE won 59% (ceiling 60) -> HOLDER_MOVE -8 -> -12, HALF +4/+9 ->
  +6/+10: MOVE 54% max, HALF 16% (was 10%), every answer still best somewhere.
- Nightly list (tools/run_tests.sh): approach, leaving, promises, loyalty_hooks, approach_wire added - they never ran at 05:00.
- no_pronoun: five she/her strings from S483-486 made neutral.
- rib_damage: "at or under 55" judged on the 8-window mean like its neighbours (61.1%; the nightly's 58.0 was one window).

## Not merged / found
- CLASH8 (Qwen): no layer after ArmClash undoes the clash. GloveClear clears a capsule along the forearm; the glove is
  drawn along Gloves._follow's axis (knuckle slerped 0.85 to the forearm) and the meter reads that. With the drawn axis the
  overlap reads 0.069 and still does not clear. Its RESULT lines ("0 frames") were false - its own note says reverted.
  Qwen's "rank skip" cause is wrong for f19 (the rank-0 hand is the one that moved). -> TASK_CLASH9 (queued after STYLE4).
- fight_why (good plan GOOD 276-279 of 540, bar 360): bisected to 3fd32033 S466 CARDFIX1 (375 -> 279). A counter answer
  (feint) in the good plan changes nothing. -> TASK_WHYGRADE1 (fires per situation before/after; queued for Qwen).
- plan_bots, block_meet: known reds, unchanged.

## Seats
- Qwen: STYLE4 running (wt LEAN_STYLE4); then CLASH9, WHYGRADE1 (dispatch queue).
- Arena: APPROACH2 blind contract test (chat 01a1df16-850a-751c-9fb9-5f050bd336aa), five mutants for Claude to run.
- Seat queue: SQ176 Kalli TRAINGAME2 v2 (sent); SQ177 Dola + SQ178 John critics on ladder v3.
- Goose: today's three runs already used; none sent.

## Decisions (Claude, as developer)
- A holder exists only for a stipend ask; LET GO waits for Monday (the map), not instant.
- PROMISE: until HOMEBOUT1, "boxed" on the night = fit on the night (the home bout itself is not simulated yet).
- A Godot job inside a heredoc trips rule_guard: write such scripts with the file tool.

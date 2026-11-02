# S67 DIGEST - the manager contract: the gym earns from a fight (2026-09-24)

## Shipped
- **Membership unfrozen** (`b6a3d064`). Operator ruling 2026-09-24 ("Unfreeze now", S66), reversing 2026-09-07's FLAT:
  `membership.json` `weekly_drift_fraction` 0 -> 0.25, `flat_count_rule` rewritten with the ruling verbatim.
  `membership_test` Q18a/b: a gym at its natural count holds still; one more floor item raises the target by
  `members_per_floor_item` and next week's members and dues rise. 38 checks, 0 failures.
- **The manager contract** (`e37f6b9a`), research Grok G71 (`G71_THE_MANAGER_CONTRACT.md`, collected verbatim).
  - `scripts/ManagerContract.gd` (new, preload-only): the filed paper (`share_percent`, `jurisdiction`, `signed_week`,
    `term_weeks`, `expires_week`, `manager_licensed`) and the fighter's answer. **No default percentage (J4 E2).** His
    ceiling = 100 x [(wage - market) x weeks between bouts + (loyalty - 50)/50 x market x weeks] / the purse he expects;
    INF with no purse on record (G71 s2: prospects sign higher). Answers accepted / countered (his floor) / refused /
    illegal - the statute answers first: caps (E22, NY floor), statutory max terms NV 4y / CA,NJ 5y / NY 3y (G71 s1,
    now in `manager_share_caps.json` with citations), the 10% manager line (E24; CA is OVER 10%).
    `wage_to_sign` inverts the ceiling so a refusal names the wage he would sign at.
  - `GameState`: `propose_manager_contract` (one counter then done; a no stands for the week), `raise_athlete_wage` (a
    separate employment act, G71 s5 - it clears the week's no, new terms = new conversation), `get_manager_contract_view`,
    expiry inside `_manager_contract_for`, and all three gym credits (purse, champion bonus, award) through ONE
    `_book_manager_share` onto `career["manager_share_log"]`.
  - `GymLedgerRead`: `manager_shares` (this week / total / count) and a labelled inflow line, left out of the weekly
    projection because a bout is not a weekly flow.
  - Profile CONTRACT tab: MANAGER CONTRACT frame under THE ASK - share stepper starting at 0, jurisdiction and term
    cyclers, PROPOSE, the answer, PAY $X/WK when he names a wage; filed: share, term, EARNED, LICENSED MANAGER.
  - `tests/manager_contract_test.gd`: E19/E20/E22/E23/E24 + derivation, statute, one-counter, expiry, wage lever;
    **9/9 mutants caught** (loyalty sign, manager line, expiry off-by-one, cap skipped, share not logged, expired
    paper collects, second counter accepted, wage inversion sign, raise accepts a cut).
  - Focused tiers green: purse_payee, gym_ledger_read (16), office_hub_panel (119), profile_revamp, membership (38).
  - **Walk** (`tools/s64_career_walk.gd`, gym hub -> @NL -> CONTRACT): 12% refused at market pay, loyalty 48 ("HE WILL
    MANAGE HIMSELF"), PAY $1,081/WK, 12% signed (licensed manager, weeks 1-157), fought -> result **TO NASIR LARKIN $880 /
    TO THE GYM $120 · MANAGER SHARE 12.0%** (was $0). Sheet: `docs/previews/s67_walk/s67_manager_before_after.png`.
- **Found on the walk and fixed:** every day-one starter is inherited at market pay with loyalty < 50, so nobody could
  ever sign - the wage lever and the named wage are the fix; and a raise had to clear the week's no.

## Collected
- Merged: Q164 (`6cc84e11`, boxing 10-8 without a knockdown), Q166 r4 + Q168 (`52803e16`, submission baseline),
  U161 (`16eff1d6`, c168 green), U162 (`0c28615e`, retarget census - no 4x defect), C191 (`db54b2e4`, default-OFF
  `contact_stop`: >3 cm overlap 1370 -> 524/3600 frames, longest 3.30 -> 0.517 s), U163 r1-r2 + U160 r4 (one
  conflict in `FightWorldLiveScreen._process` resolved as the union). U163 r3 `0514673b` landed after the suite started.
- Grok studies saved: G72 TRAPS (design, slice order), G73 THE MECHANISM AUDIT (top five missing: feint->reaction,
  ring-cutting, body work->guard, pivot off the line, underhook->cage), G74 THE GYM MARKET (city demand pool, share by
  attractiveness, crowding; slice 1 = share x D + crowd sink). Sent G75 STRIKE SPEEDS (real peak speeds/durations).
- Assigned Q169 (Qwen): G72 slice 1, the isolated arm from mount, behind `trap_arm`, measured against Q168.

## Suite
`SUITE total=384 fails=13`, read off the run: the nine documented reds (c168 is GREEN now, U161) + `fight_strike_speed_test`
(U163's `_root.global_position` read out of the tree - 659 engine errors; fixed after the run with the file's own
`_world_of`, 31 checks, 0 errors; fight_world 4/0, fight_stage 10/1 ceiling) + three where Q164 met Q166 on master:
`fight_pace_anchor` (D1 8.31/min > 8.0), `result_screen_why` (fixture now two rounds), `judge_panel` (two re-pins
collided; T11 from Q164's boxing gate). Control arm: reverting only FightRealtime.gd + GrappleResolve.gd to e37f6b9a turns
pace_anchor and result_screen_why green -> Qwen Q169 PART 0. Effective after the fix: 384/12.

## Not done / carried
- TAKE FOUR not recorded: U163's kicks were only resolved in r3 (0.97x on the kicking foot), which landed mid-suite,
  and U164 (are the bought clips faster than humans?) is running. S68 records take four once U163 r3 is merged.
- A parallel S66 session was committing to master in this checkout throughout (U163 r3, U164). Its roadmap edits and
  mine were kept apart.

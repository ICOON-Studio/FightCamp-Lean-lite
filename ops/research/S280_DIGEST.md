# S280 digest - member cap live, rent removed, promoter bail-out in the debt decision, Ludo's member-counter spec + code (2026-10-21)

## What now works
1. **Lockers set the member cap on the drawn gym** (8326b457). `GameState.member_cap_live()` counts locker banks / shower stalls in
   `club_rooms_built` -> `RoomWorkRules.member_cap` -> `Membership.settle_week` override `member_cap` (members in stay; the cap stops
   sign-ups only). Switch `room_work` in GAME_ON; old careers / switch off = no cap. BUILD window locker line: "12 member places -
   nobody joins without lockers". `tests/room_work_wire_test.gd` ROOM_WORK_WIRE failures=0 (control grows to 36, capped 12).
2. **Rent removed** (c82c2897, operator Q-S277-2 "remove rent from the game"): no rent rule in room_types.json, no
   `monthly_rent`/`built_floor_m2`, GameMoney bill = wages + upkeep. `rent_test` replaced by `no_rent_test` (shell bill == old bill).
3. **Promoter bail-out = 4th option in the existing debt decision** (Arena #322 rules 9ad46a79 + Claude wiring 4474c310): 5,000+ in
   the red -> DebtDecisionModal draws PROMOTER BAIL-OUT; +8,000; promoter takes 50% of the gym's manager_share of the next 3 purses;
   2 wins in 60 days = recovered ("failed" has no consequence yet). `tests/bailout_wire_test.gd` BAILOUT_WIRE failures=0.
4. **Collected**: Qwen ROOMWORK1 (#316) + HITFEEL1 (#318) pure modules (136e87d1).
5. **Ludo member-counter UI** (operator: "where the member cap shows in the UI/screen ?", "ask ludo also and check how this is shown on
   mgt2 and 2pm", "ask for the whole implementation code"): spec ludo_rx/LUDO_S280_MEMBERCAP_UI_raw.txt (19,521 chars), code
   _CODE_raw.txt (20,430 chars). `MemberCapRead.gd` pure read adapted + test (8987de3d; shower price $1,100 not Ludo's $1,600).
   Top-bar chip -> Cursor #321 MEMBERCAPCHIP1.

## Decided and why (Claude as developer)
- Grok #319 BAGMOUNT1 refused round 1: no test, edits outside OWNS, hard-coded prices -> round 2 comment + relabel.
- Qwen's `member_cap` returns 0 on negative showers (its test asserts it) - kept; the game never passes a negative count.
- Dola "network error" on Local environment: NOT the firewall (2 Allow rules for Cici.exe, outbound open). Her log: dola.com task-mode
  manifest answers HTTP 502 (net_error=0) - server side. Firewall left unchanged (security settings are the operator's).
- ESBC Revival mod installed into Undisputed on his ask (study reference game); originals GameAssembly.dll + data.unity3d in
  E:\FightCamp\Undisputed_backup_S280; bundles/banks restore via Steam verify. E: now 13.7 GB free.

## In flight (yours to collect)
- Ziva HITFEEL2 (127.0.0.1:7012 chat "Claude (S280) - NEW TASK HITFEEL2", ziva/playtest).
- Cursor #317 SPARPIT1, Cursor #321 MEMBERCAPCHIP1, Goose #315 ASGAMERED6 + #320 WEARSLIP1, Grok #319 BAGMOUNT1 round 2.

## Next
ROOMWORK1 wire 2 (office PC purse split, physio table injury days, shelving breakdowns), loans as OFFICE actions + pay tiers
(STARTECON1 rest), collect the runs above, re-task Arena, Dola personalities when he says she is done, re-task Cursor NIGHTLY12.

## HANDOFF
Working commit: see `git log -1` after the ship commit. Evidence: the RESULT lines above, all run on the PC this session.

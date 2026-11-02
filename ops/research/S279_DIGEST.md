# S279 digest - locked rooms open, the start's money rules in, floor work spread over 6 seats (2026-10-21)

## What now works
1. **Locked BUILD rooms open when the career earns them** (2162a015). Qwen's RoomUnlockRules (#313) + `GameState.room_unlock_facts()`
   (roster, members, pro wins, longest bout rounds, station breakdowns, reputation, career earnings) -> `BuildMode.room_types_live()`
   and `pick_room`; the BUILD window row says what opens it with have/need ("2 fighters signed (1 / 2)"). New counters:
   career.longest_bout_rounds (bout settle), career.station_breakdowns (a station breaks). `tests/room_unlock_wire_test.gd` green both
   arms (red before: no live read existed).
2. **StartEconomyRules** (Qwen #314): loans (micro/municipal/promoter advance), promoter bail-out, staff pay tiers, early income
   channels - pure module, START_ECONOMY_RULES failures=0. NOT wired yet (see Decided).
3. **As_game arms collected**: Goose round 2a (6 tests, a35bbc8b), Cursor #309 (8 of 9, e5eff34a), Cursor #310 (4f4e7f73).

## Decided and why (Claude as developer)
- Reputation "Tier 2" (Ludo S277 Ring Pit unlock) = gym reputation 0-100 in bands of 20 (tier 2 = 40+): no tier ladder exists.
- Cursor #309 gym_club_3d_test change refused (adds a freed-instance SCRIPT ERROR; master's passes). Cursor #303 NIGHTLY12 refused:
  both targets still red with its diff (contact_push_carry ON 3 < OFF 2; walkout beat list reads 0 - the early return reads _beats
  before the engine made any).
- Cursor #310 dropped "the worn man slips fewer punches" in the game arm; kept instead: it reads 225 -> 232 as_game = a real defect
  -> WEARSLIP1 (Goose #320). bout_wear_wire_test is red as_game until that lands - honest red, not a broken test.
- STARTECON1 wiring: the game already has a LIVE debt system (SandboxParity.gd: debt decision, DebtEvent loans, emergency fight,
  predatory offer, receivership; `sandbox_parity` in GAME_ON). DECISION for S280: the promoter bail-out becomes the option offered at
  cash <= -5,000 inside that existing debt decision (not a second system); micro/municipal/promoter-advance loans become OFFICE
  actions; pay tiers on the staff screen; early income channels as Day Plan / office offers.
- build_single_piece_test is red as_game on master too (the empty shell has no drawn training floor) - in Goose's ASGAMERED6.

## Operator calls this session (verbatim)
- Q-S277-1 rooms that work: "Approve all" -> ROOMWORK1 (Qwen #316) + BAGMOUNT1 (Grok #319).
- Hit feel: "do it assign others for these modules and you keep the work on the gym" -> HITFEEL1 (Qwen #318 numbers), HITFEEL2
  (Ziva: wire + same-seed A/B, thrower stays pure mocap; C188 contact-gate trap in the brief). Impulse was OFF since S274
  clips_only_base (active_ragdoll + hit_physics in CLIPS_ONLY_OFF); Attributes.hitstop_frames existed but nothing read it.
- "keep the progress on the floor going" -> BAGMOUNT1 + SPARPIT1 (Cursor #317) briefed.
- Fighter personalities (Proto Boxing style): "dola is building the whole thing i will let you know" - Kalli ask SQ11 cancelled.
  Dola runs in her desktop app ("Proto Boxing Animation" chat); Claude advised: Local computer mode, folder E:\FightCamp\Game
  read-only, output to research/dola_out/. Her reply not read yet (still generating; reading needs the Cici app relaunched
  with the CDP port, which would cut a running answer).
- Rent: asked again on the board as Q-S277-2 (remove vs keep as built).

## In flight
Goose #315 ASGAMERED6, #320 WEARSLIP1; Qwen #316 ROOMWORK1, #318 HITFEEL1; Cursor #317 SPARPIT1 (then #303 NIGHTLY12 round 2);
Grok #319 BAGMOUNT1; Ziva HITFEEL2 (queued after #318; Ziva editor DOWN - start it first), ZIVATREMBLE1; Kalli SQ10 hit-feel numbers.

## Next (S280)
Collect the runs above; Dola's personality build (read her chat once she is done); wire STARTECON1 per the decision; wire ROOMWORK1
(lockers gate members, office PC purse, physio, shelving) when #316 lands; Ziva up + HITFEEL2.

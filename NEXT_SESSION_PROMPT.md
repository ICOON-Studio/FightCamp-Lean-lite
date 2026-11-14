# S467 handover (written 2026-11-14 at the end of S466; S465's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S467`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; wrap-up from ~395k (S466 wrapped at ~330k: a deep bisect is costly).
  At most TWO helper sessions / subagents at once.
- Never idle while a test or agent runs: run_in_background and do the next item.
- Godot jobs (tests, films, export) go through `python ops/Tools/godot_slot.py run --who s467 -- <cmd>` (rule_guard blocks others).

## HIS RULINGS IN FORCE (quote them)
- S459: "need to finish intergrading mechanics before we spend more time in designing the menus" -> integrate first.
- S461 greybox: each mechanic lands on the screen it belongs to as a line, a number, a hover or a few buttons.
- S459: design loop on the free seats until every mechanic scores 6+ depth and 6+ general (ops/Tools/design_loop.py).
- Q-219: liver vs ribs "yes"; Q-220: R58 a fighter leaves "Yes, build after the fight week".

## WHAT S466 DID
- Card table fixed (3fd32033, c5a29c4b): her own trouble (she_tired/she_hurt) no longer moves her to a fixed card; a lost exchange
  moves her (where_next); a counter-puncher waits OUTSIDE. PlanChain matched. CARDFIX2 (Qwen + Claude rerun identical, c18e6e82):
  best answers never firing 13 -> 0, every card reached, step bars now change results, wins 61-67 of 120 (51-56 in 100).
- LANDREACH1 step 2 (9f8f9c51): bisected to d258cab0 (POWER1 step 2 review round 1: the carry started from the glove as drawn on
  the hit frame, 13-19 cm short on the rear hand). ReachLimit.carry_base: rear cross/hook start from the face point when the drawn
  glove is > 2 cm off. block_meet 9 -> 5, hit_frame 11 -> 10, hit_carry 34-38 -> 32. docs/LANDREACH1_RESULT.md has the table.
  ON THE GAME CAMERA the rear cross now arrives but lands HIGH (forehead / top of head): docs/mockups/s466/landreach/00_cross f18/f19,
  on the review board.
- READ-PROOF on Fight prep (ProReadWire.proof_words, proread_wire_test 5). Liver on the right of every body (BodyMap; was swapped
  for a southpaw defender). LIVERRIBS1 v2 passes (John 7/6/7 SQ91 + Maria 7/6/7). TURNPRO1 v2 Maria 7/6/6 (SQ114); Dola SQ113 pending.
- plan_bots_test 2 red - was red on the nightly before S466 (not this session's change). Build exported 11:25.

## FIRST
1. His board: Q-224 (club show map), Q-225 (push/tank map); review comments on the S466 cross still and the S465 tiles/clash.
2. NIGHTLYTRIAGE1 (Qwen, qwen/nightlytriage1, launched 11:47, ~12:30): collect, rerun tools/nightly_triage.py on main, then fix
   or write a known-cause note for each red test.
3. LIVERRIBS2 (Goose, issue #271, pure scripts/rules/LiverRibs.gd + tests/liver_ribs_test.gd): collect by diff + parse + test,
   then WIRE it per DESIGN_LIVERRIBS1_V2_REVISE_KALLI_KALLI.md section 6 (menu table) and 7 task 4: Exchanges (hand-to-side,
   drain, ribs penalty), Knockdowns (body 8-count), InjuryRoll (bruised/cracked split), the crack card in the corner minute.
4. LANDREACH1 step 3: the rear cross lands high - compare the face target point (_target / clip_contact's shown face) with the
   drawn face on 00_cross f18/f19 (hit_frame_film seed 4242); lead hooks 5-9 cm (block_meet's 5 left).
5. Seat answers SQ96/98/104 (John), SQ109/111/113 (Dola) -> ops/research/DESIGN_LOOP_S459.md.
6. Export after any player-visible change.

## NOTES
- Miro P0: S466 recreated six cards whose ids Miro would not confirm (now_9, now_10, done_session_3). If the old widgets sit under
  the new ones on the board, remove them by hand in Miro (ids 3458764690416594183-186, 3458764690411923554-555).
- The CARDFIX2 probe prints "wins within 40-60: NO" because it compares a count out of 120 with a per-100 band: in band.

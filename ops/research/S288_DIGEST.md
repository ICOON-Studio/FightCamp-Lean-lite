# S288 DIGEST (2026-10-23) - members use the gym like a real one; GitHub Actions minutes cut; MGT2 room scale measured

## Operator asks this session (verbatim)
- "keep working on the gymfloor until it makes sense, you have customers entering without checking in , then an npc is boxing on locker , the guy on the treadmill is walking the oposite side , ask for reviews if you need to and advice"
- "you did't even placed all the rooms on your playtest ... do you know how to playtest as a game dev ?"
- "why mgt2 rooms feel bigger and the objects better inside the rooms ?"
- "can you fix this so we do not waste so many actions on github" (with a screenshot: nightly ~900 min a night since 19 Oct, CI 60-100 runs a day)

## What now works (evidence)
1. PLAYTEST = FULL BUILD (memory feedback_playtest_full_build_s288). `tools/s288_member_visit_probe.gd` builds every room
   (gym-step preset arena_heart: office, reception, physio, equipment store, locker room) and 19 pieces, presses Play, and follows each
   member. Read RED on the shipped tree: treadmill and bike riders faced away from the console (dot -1.00); a member threw combos alone
   at the mitt locker; the way in went straight from the street door to the floor.
2. MEMBER VISIT (4253cb95, 38d60b30): street door -> reception desk (2 s, facing the counter) -> locker room when built (3 s) ->
   floor -> station (`ShellFloorMembers.entrance_path`, MemberWalker stops). Pads = the coach's station, so no member works it alone.
   On a treadmill or bike he faces the piece's front turned by its yaw. A member only takes a piece he can be seen working: bike and
   agility ladder (no clip yet) stay EMPTY instead of an idle body on them.
   A day at Play is ~14 s and each day rebuilds the floor. A visit (~35 s) used to snap the member onto his station mid-walk; it now
   lives in `ShellFloorMembers._visits` and resumes after a rebuild.
   `tests/shell_member_visit_test.gd`: RED on the shipped scripts 6/7, GREEN 12/12 (-- as_game); it stands down in the switches-off arm.
   Stills on the career screen's own hall (floor_view): docs/previews/s288_member_visit 01 check-in, 02 locker room, 03 all at work at
   67 s across 4 rebuilds (treadmill rider faces the console, crop checked). On the board (8787/review) and sent. OPEN until his OK.
3. `gym_build_input_test` was red in the as_game arm on master (8 checks): its training floor overlapped the S287 reception area and
   was refused, and every later check failed blind. The floor is now drawn clear of the area and the build is asserted. 26/26, both arms.
4. ACTIONS MINUTES (d36c43f0). Measured 19-22 Oct: 10,045 billed min. Nightly 3,763 (37%: ~565 a night + four hand re-runs on
   19 Oct = 1,503), cloud-agent 1,955, CI 1,909, cloud-tests 1,392, goose ~575 (its 75 skipped label runs cost 0).
   Per test (22 Oct night): 1,048 tests = 1,013 test-min; 68 tests >= 300 s = 710 min (70%); 4 hangs burn 20 min each every night.
   - nightly-suite.yml: Mon-Sat FAST tier (`run_tests.py --tier fast`, --timeout 600) on 8 shards; Sunday ALL on 16; a scheduled
     fast night on a commit the last good night already tested is skipped. The merged SUITE line carries `tier=`.
   - `Godot/tools/test_durations.json` (per-test runner seconds) + `Tools/test_durations.py <run id>` refresh (merges).
   - Sparse checkout in ci / cloud-tests / nightly shards (no docs/previews media, research/_captures, Tools/cascadeur: 2.7 of 4.2 GB).
     Proven: CI checkout 91 s -> 29 s, cloud-tests 106 s -> 37 s; cloud-tests s288-sparse (as_game) PASS 2/2 with LFS.
   - rule_guard: a hand-dispatched nightly needs FIGHTCAMP_ALLOW_NIGHTLY=1.
   Expected nightly: ~17,000 -> ~7,000 min a month. Still open: each CI / cloud-tests / agent run pays ~2 min of Godot import even
   with the cache (~540 runs in 4 days).
5. MGT2 SCALE (research/MGT2_SCALE_S288.md, UnityPy on his install, numbers only): MGT2 rooms are NOT bigger in person heights (3x3
   minimum = 2.3 x 2.3; ours 2.5 deep). The reasons are: walls 1.16 person heights high (ours 2.0), furniture ~1.3-1.4x true scale
   against its people (desk 1.07-1.21 person heights wide), a 1-tile grid, and every object a workplace. Asked Ludo (chat "Gym
   Management Screen", still uploaded; ask = research/LUDO_MGT2_ROOMS_S288_ASK.md) for the verdict - answer to collect.
6. Collected Qwen BOUTREPEAT1 #341 (ededc0f3): the bout and the career route (camppay_measure) replay byte-identically per seed, in
   one process and across two. The A/B flips are not engine noise.

7. AUTO FILL LOCKERS: the preset's locker room was built EMPTY. The data names its copies `lockers_1`/`lockers_2`, the catalogue names
   the piece `lockers`, so nothing matched, and member capacity was 0 ("40 / 0" on the top bar of every preset still). Fixed in
   `BuildMode._catalog_item_for_furniture` (numbered copies map to their piece). shell_member_visit_test: red on the shipped
   BuildMode (lockers [], cap 0), green (2 locker banks, cap 24). Preset/BUILD tests 5/5 in both arms.
8. MGT2 VERDICT on the board: Q-S277-9 (attach research/MGT2_ROOMS_VERDICT_S288.md; Ludo's answer verbatim in
   research/LUDO_MGT2_ROOMS_S288.md, 20,025 chars, one message). Room walls 3.6 -> 1.8 m, room hero furniture x1.3/x1.15, one floor per
   room, 3-5 pieces flush on the walls. Nothing is built until he answers.

## Found, not fixed
- No receptionist behind the counter.
- 4 fight tests hang every night (fighter_gloves_both_corners, fight_stage_realism, fight_strike_whole, fight_grapple_seam);
  they now run only on Sundays (slow tier).

## Next (decision)
Read his comments on the S288 stills first. Then collect Ludo's MGT2 answer into a verdict for his OK; bike + ladder clips;
receptionist; exe on the full-build route; check the first fast-tier night.

## HANDOFF
commits ededc0f3 d36c43f0 4253cb95 38d60b30 pushed. In flight: Ludo MGT2 rooms answer (chat "Gym Management Screen").

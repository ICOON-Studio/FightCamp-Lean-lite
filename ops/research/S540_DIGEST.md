# S540 digest (2026-11-23, 11:20-14:25, Opus)

## Owner answers acted on
- Q-306 "Yes, make it bite" + Q-307 "Yes, build it": combo counter BUILT (COMBOCOUNTER1 cf5dfe536): spam -6.7 wins in 100 v the
  counter-puncher, a varied plan read 20/100; feed line, result tab, Playbook chip.
- Q-308 "Yes, keep it": club show v6 FAIL 5/9 (HOSTPROBE3) -> v7 running (HOSTPROBE4).
- Q-309 "Yes, start": Dola's style sheet (A) rendered (docs/mockups/s540_restyle/); B cut off, C/D missing -> one page per ask.
- Q-310 "Keep, build the full set": PICS2D2 (full boxing picture set as a second view) - resumed after a low-memory stop.
- Q-311 "Bouts pay by rank": coaches v3 FAIL 7/10 (COACHDEEP3 139fa7f8c; small club + weak hire still lets ranked boxers go) ->
  v4 list in docs/COACHDEEP3_RESULT.md s5.
- C477/C478 (his stills): the lean chip said "after two uses" (rule bites from the fourth) - fixed cc8c3789d; MODE listed twice -
  fixed c9159faf2.
- Card game: "use the console with fable ... everything what a AAA studio does to prepare", "it doesn have to be strickly cards",
  "why i think we did that already and i also made propositions" -> CARDPREPROD1 (Fable): no new genre study, his proposals placed.
- He sent GrappleMap (public domain) + two reference-only sites -> GRAPPLEMAP1 on Arena.

## Merged / measured
- STEPPAY5 merged by diff (f31338cfa): ten steps pass all three legs.
- TURNPROBE15 PASS 17/17 (5,498 careers); critics: Opus code-checked 6/6/6, Kalli 6/6/6, Dola 9/9/8 -> v16 map 0ffde41dd, probe
  batch running (E:/FightCamp/tmp/turnpro16, tab c15).
- Knowledge v8 (KNOWSTAKES8 809cae63a): Kalli 6/6/7; Dola pending.
- Card r6 (Arena PR, FightCamp-Lean#445): FAIL 5 core bars; fresh Arena code check: DO NOT MERGE AS IS (ui.js imports `actions`
  from engine.mjs - the page does not load). Merged as the base (9815bfe8f + e417141f) -> CARDFIX6B on Arena.
- NIGHTREDS1: plan_templates <- STEPPAY3, matchmaking_bots <- DMGCLASS2 (design results; decided, in P4PEVID1).
- Regression found by Claude: p4p_visit_test 0 of 60 evidence after today's merges (not the counter) -> P4PEVID1.
- BoutRead cache key now includes own_combos (821ddfa63, COACHDEEP3 found it); bout_read_test PASS.

## Lessons
- `git diff --name-only` lists only the NEW path of a rename: a pathspec commit left 15 staged deletions (fixed e417141f).
  Use `--no-renames` when collecting paths for a pathspec commit.
- The owner's game (ArcheAge) + six tabs took RAM to 98%: two workers stopped mid-run waiting for a restart nobody could type.
- Not exported: PICS2D2 had uncommitted view edits in the tree (export takes the tree).

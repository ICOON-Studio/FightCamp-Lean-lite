# S371 digest - Argon and Ziva loop the fight and the mat to 9/10; men's boxing; the records wall; no she/her (2026-11-03)

Main 399d6fe -> 2a1c4a0 (PR #21) -> e4fbedc (loops) -> 551ef21 (PR #22) -> 98ee280 (no pronoun) -> 89e968f (MALE1 +
records wall) -> e21dc45 (referee to Argon) -> wrap-up. Operator, in order: "gemini4 review the fight with the fixes and
rate it again", "and then tell gemini to reach to 9/10", "let argon do all the fixes until its 9/10", "who can do the same
for the bjj ?", "fix bjj until its 9/10", "ziva needs access to https://eel.is/GrappleMap/index.html
https://grappleflows.com/main", "also gemini might need that".

## Collected
- PR #21 FLOWBOUT1 (Arena): PlanRecord.gd + BoutNight "plan_rec"; plan_record_test in run_tests.sh (24 checks green),
  save_load / fight_flow / golden_path green. (Record tab + Playbook win rates still to wire.)
- PR #22 KNEETRACK1 (Antigravity/Argon): KneeTrack before FootPlant; knee_probe 57 -> 6 failing clips (af_drink, sit,
  three special uppercuts). Argon 2 -> 2 on a turntable film (not a fight).
- PR #23 NOREF1 (Qwen) CLOSED: push_off_probe crashed at line 84, Qwen's API cut the run ("inappropriate content"), Argon
  2 -> 2 (frozen clinches). The referee moved into Argon's FIGHT9 loop; Qwen's try kept in ops/research/noref1_qwen/.
- NOPRONOUN1 (a Claude helper agent in a worktree): ~160 strings in 55 scripts + 47 in 4 data files; tests/no_pronoun_test.gd
  guards literals + data (allowlist: actor slots, {her} name placeholders, saved wrestling ids). Suite 121/0 there.
- Goal ideas: Grok, Dola, Ludo (answered S370 in the WRONG Ask Ludo chat "Multi-Hub Space Strategy"; read only, nothing
  sent), Gemini 4 -> GOALIDEAS_SUMMARY_S371.md. John J_MEN1, J_TESTS2; Kalli K_MEN1 (inline; attachments stay on the box).

## Argon judges (ops/Tools/gemini_judge.py, argon, 24 fps)
- Fight on main (tools/judge_film.gd secs=90, ops/previews/S371/fight_main.mp4): 2/10. Costs: slow weightless punches
  -2.5, referee -1.5, clinch/rope clipping -1.5, foot slide -1, repeated moves + staring -1, camera crossing the line -0.5.
- BJJ belt match (claude/bjjmatch1 + tools/belt_match_film.gd, bjj_main.mp4): 2/10. Costs: limbs through bodies -3,
  called techniques that do not match the pose -2, weightless slow takedowns -1.5, dead freezes on calls -1, foot slide -0.5.

## The judged loops (operator: "until its 9/10")
- seat_dispatch + brief_contract: `BASE:` = the branch a round starts from; `LOOP: <STEM> <target>` = after DONE,
  loop_next writes TASK_<STEM>R<n+1>.md (BASE = this round's branch if Argon's after >= before and checks green, else the
  old base; '## Last verdict' replaced with the after verdict) and queues it on the same seat; stops at the target or 12
  rounds. Merging stays with a session (S249).
- FIGHT9 (Antigravity on gemini-4-argon-high): R1 launched 02:08 (agy/fight9r1, LEAN_FIGHT9R1). OWNS scripts/fight3d/,
  MoveWords, clip timing json, tools/fight9_probe.gd (one cumulative probe, a bar per fix). Not his: Ziva's body-shot
  reactions. FILM = judge_film.gd secs=90 (same film every round).
- BJJ9 (Ziva, she runs it herself with bash: fix, film, gemini_judge, BJJ9_ROUNDS.md) queued in her chat "after task"
  BODYREACT1; branch ziva/bjj9 from claude/bjjmatch1 (fcf6293 added tools/belt_match_film.gd). WEIGHIN3D1 after it.
- ops/research/BJJ_REFERENCES_S371.md: GrappleMap (public domain; data already in GrappleMapDB; no timing) + the operator's
  Grapple Flows "Match Breakdown: Mount Sweep To Foot Over Foot Pass" (6 nodes, read in his Chrome - the site needs his login).

## Built
- MALE1: Data.DIVISIONS men's mfw 57.5 / mlw 60 / mww 70 / mmw 75 (England Boxing senior men's classes, J_MEN1), each
  with "sex"; 16 men (K_MEN1; Callum Stokes, Kofi Boateng, Mateusz Kowalczyk, Nathan Bell renamed off the cast; weaknesses
  on OppFile keys); Danny Osei (mlw) + Josh Harper (mww) in PROSPECTS; Data.sex_of / divisions_for; fighter_state "sex";
  SaveGame tops up the men (with RivalPast) and male prospects; FightPoster MEN'S/WOMEN'S. tests/male_boxer_test.gd 27/0.
- GOALTESTS1 phase 2, the records wall: scripts/rules/TestDay.gd - Sunday tests bleep / punches in 10 s / rear-hand force
  (J_TESTS2 women's anchors: 40 beginner, 60 club, 85 elite; CALIBRATION for Kalli), bests with the beaten value; Sim
  week report "bests"; WeekReview "NEW BEST ..."; AwardCard RECORDS WALL (strike-through via RichTextLabel [s]).
  tests/test_day_test.gd 12/0. Still: ops/previews/S371/award_training_tab.png (tools/award_still.gd).
- SkillAwards.bleep_known(sex): men show no bleep level until John's J_TESTS3 (sent: men's bleep norms, force, speed).

## Open / next
- Male MetaHuman boxers (4-6, Unreal on a GREEN PC with Chrome closed - asked the operator); until then a man fights in a
  woman's body. Then guide_tour with a man + Ana.
- John J_TESTS3 (men's norms) -> TestDay/SkillAwards men's anchors. Women's 61.2 / 66 kg limits are not in any current
  rulebook (J_MEN1: use 60 / 65) - change with Lucy's weight cut checked.
- GOALTESTS1 phase 2 next items: the test-day moment (3D pad round + PASSED stamp), the grade upgrades its move cards,
  Day 1 vs today. FLOWBOUT1 wiring (Record tab, Playbook plan-line win rates). The plan in the ring.
- Collect FIGHT9 rounds / BJJ9 rounds when they reach 9/10 (or stall); Ziva BODYREACT1 (14 of 42 landed body shots show
  nothing; her probe found the punch is replaced before contact).

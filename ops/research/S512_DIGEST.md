# S512 digest (2026-11-17, Opus, main line beside the animation sessions)

## What now works (in the .exe, exported 22:0x)
- ASK FOR A BOUT (ASKFIGHT1, owner "Yes, build it"; map v4, round-4 critics Dola 7/7 + Goose 7/7): Fights > Ask for a
  bout (and Fighters > Find a bout) opens a panel: the next two club shows side by side with what each date leaves time
  for (scripts/rules/AskDates.gd, Goose ASKDATES1), one card per answer (sheet name / step up / names you pick) with an
  Ask per date, missing answers with reasons, Wait. Booked through Bouts.accept (scripts/state/AskFlow.gd); a picked
  name: the host keeps the gate (BoutFinish, result page). EVERY amateur bout now teaches (FightLearn, ASKPROBE2's
  model: every fight ability +growth, a step up x1.25), result page WHAT IT TAUGHT. tests/ask_wire_test.gd (18 checks)
  + ask_dates_test in run_tests.sh. Left: Home DO NEXT line, the stoppage-risk word (no chance figure exists).
- ASKPROBE4 (Qwen, PR 358 collected by diff): 60 fighters, 15,479 real bouts - the show date is a real choice
  (neither date best for more than 22/60; far show plan mastery +3.8, wins +0.7, injury 1.3). Its grep: the week-before
  pad night, the late night's x2.5 injury / cut stop and FightWeek.banked are NOT wired (INTEGRATE1).
- ONE LOOK (Q-251 "do it and i will judge"): Training tab, drill cards, scorecard on the one palette; loose colours
  73 -> 29 (left on purpose: fight3d, WeekCards' per-ability tile colours). Fight analysis game words carry no subject.
- LEAN CI (owner "Yes, switch it", then "i do not want checks on things that were not change"): tools/ci_pick.py -
  only changed tests (+ the brief's own RED_TEST on a PR) and a parse check of changed scripts; notes/art-only changes
  skip Godot; full suite = the PC's 05:00 run or a dispatch with full=true. Each main push has its own group (never
  cancelled); a dispatch on an agent branch checks that branch against main. First real run: 7 min (was ~22).
  Actions November: 28,391 of 50,000 at 22:30 (pace had pointed to ~49,500). There is NO nightly suite on GitHub.

## Animation (FIGHTPLAYER2) - run by its own Fable sessions
- Part 3 (S510) baseline: raw clips 4.5/4.5 = placement only 4.5/4.5 = full stack 4.5/4.5 (six blind critics); the
  pipeline pins clip travel (FightClips.hold_root_xz) and cut the jab bake. -> the scope as written.
- Scope critics: Dola 8/9 ("BUILD IT"), Goose 7/8 -> passed. anim-rebuild (local_dd54a93a) did the clip census and
  briefed the choreographer (Goose issue 356, landed). anim-rebuild-2 (local_9ee8e7a4, Fable) collects it and builds on.
- start_session ignores `model: claude-fable-5-2` from an Opus parent: check get_session, set_session_model, and stop +
  re-send the first turn if it already began on Opus (memory feedback_fable_for_animations_s512).

## Agents
- Grok bots (Kalli, John, Maria) OUT OF QUOTA (owner): their queue parked; reassigned - Kalli's ladder v6 and coach
  spec r6 revisions to Dola (SQ211, SQ212), John's guard-damage critic to Goose (issue 355: 6/6/7; Dola 6/7/7 ->
  another round). Goose = critics and pure modules (issues 353-357 this session). Dola free, still working.
- Critic files collected: FIGHTPLAYER2_CRITIC_S512_{DOLA,GOOSE}, ASKFIGHT_CRITIC_S511_{DOLA,GOOSE},
  DESIGN_GUARDDMG1_V1_CRITIC_GOOSE.

## Smaller
- Two briefs pointed at the retired tape_room_test -> film_night_test. LIVEROUNDSPLIT1 found done (439 lines).
- tests/grapple_fix_test.gd failing 18 = the S399 GRAPPLEFIX1 TARGET test (red on purpose, BJJ parked).
- Settings "Show the fight log" waits for the live log panel (it only sets that panel's default).

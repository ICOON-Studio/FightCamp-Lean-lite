# S458 handover (written 2026-11-13 at the end of S457; S456's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S458`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; wrap-up from ~395k. At most TWO helper sessions / subagents at once.
- Never idle while a test or agent runs: run_in_background and do the next item.

## HIS RULINGS THIS SESSION (quote, act)
- Q-S294-217 on the board: "Separate Training scene, fighters on top".
- Mid-session: "move the training out of the office and wire it on the gym floor training area ? what do you think ?" -> Claude
  agreed (training was never in the office code; the gym floor's bag-area pin, GymHub PIN_AT "training", says "Fighters" today and
  becomes "Training", opening the scene; the office keeps mail, money, staff and the Fighters app). The profile's Training tab stays his
  S354 overview: read-only week, what it buys, fight night, one Open in Training button. Nothing is planned in two places.

## DONE IN S457
- SPECIALTY1 (Qwen PR 257) collected by diff + parse + test, then WIRED: PadWeek.run_week's Sunday hands 60+ moves to Specialty.apply
  (hold by pad/bag/sparring units, fade 1.5 to floors 50/70, frozen in taper and while injured); under 60 keeps decay_week; DrillWeek
  returns held/faded for the Monday rows (display waits for C20 + screens, map task 14). 11 tests green incl. golden_path and
  two_boxers_two_years. WHAT_TO_TRY has the S457 note; exported.
- STYLENAME1 briefed (ops/research/TASK_STYLENAME1.md), run on Qwen, collected: scripts/rules/StyleName.gd (named style, Monday check,
  effects as numbers, plan_cap, two_held). NOT WIRED yet.
- Training H + I (docs/mockups/s457/training_h/): H = its own scene, four fighters on top, what the week buys, one number a tile,
  day tanks, week Nights switch, Hold/Cut ticked; profile_training_tab_h = the summary. Critics H: Claude 6/5, Dola 7/8.
  I = amateur no-camp nights (2+1 / 3+1 / 4+1), the coach's pad nights across four fighters with the shared-night cost (R55),
  the drag strip from the rules (win +0 no new tier, injury 1.1 -> 1.4, pull out or fight hurt), tank at the first bell, a
  take-the-advice button. Critics I: Dola 6/8 (ops/research/TRAINGAME_CRITIC_S457_I_DOLA.md); Claude I: see
  TRAINGAME_CRITIC_S457_I_CLAUDE.md (it was still running at the handover; read it first).
- POWER1C's stale "queued" row in dispatch_queue.json superseded (it would have launched Qwen onto the uppercut beside POWER1D).
- POWER1D: in-house helper given the contract (OVER_HEAD at the glove's lowest point; BACK in the spine's frame; hit_carry excludes an
  uppercut's post-contact return; each read must still go red on a mutant), then the S456 patch + the regression list, punch_speed 3x.
  Its result: the "## S457 result" section of ops/research/TASK_POWER1D.md (uncommitted files in the tree if it had not finished:
  check `git status` for tests/uppercut_tail_test.gd, the hit_carry test, scripts/fight3d HitImpact/BeatClips).

## NEXT (Claude)
0. Qwen is free: brief its next pure module first (the dispatch queue rows still "queued" are stale: SLOTS1 done, the rest have branches - clean them).
1. TRAINING J from the two I reviews. Both say density: cut numbers to a third (one per tile, the rest on hover); the Nights switch
   lights the evenings it changes; the coach's-nights row names which fighter pays (the strip portrait, not "the other boxer");
   a coach-vs-yours total on THIS WEEK BUYS; redraw film, rest, rest night, mobility, strength, intervals, roadwork in the Playbook's
   dithered ink (the Claude H critic: they read as a second style; rest and rest night look alike; neck shows a guard). Keep every
   number traced to the rules (the H critic caught three that were not). Two fresh critics at 7+ -> the board with H, I, J.
2. POWER1D: read the helper's S457 section; land it if the regression list is green, then film seed 4242 + 3 seeds to the review board.
3. Wire StyleName: Monday check into the week, the effects into Duels (range_open), Combos (combo_energy), the plan edge (mid_edge,
   counter_edge), pressure answers, Knockdowns; plan_cap where the plan's line cap lives.
4. Coaches map v4 from Kalli SQ69 + John SQ70, then fresh critics.
5. Kalli SQ71 / John SQ72 (fight week v6) when `start` prints them.

## TRAPS (S457)
- The idle guard reads Qwen as idle from the process list: a finished Qwen run (its log shows RESULT lines) means collect it now.
- where_we_are.py can hit "Invalid argument" writing roadmap.json while another writer has it: re-run that one command.
- Dola reads the JPG small: numbers in the drag strip come back garbled; quote its claims against the picture before acting.

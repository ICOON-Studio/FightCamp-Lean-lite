# S532 digest (2026-11-20 evening -> 2026-11-21 ~02:30, Opus, main session)

The owner played the build and reported defects one by one; each was fixed the same session. A side Fable session
(GUIDETIPS1, his "Yes, build it" on Q-S294-282) builds the tooltip and guide standard in the same folder.

## Fixed from his playtest (all committed, in the 00:39 .exe)
- Names out of text (S448; his ruling "To-do rows keep names"): guide lines, coach card lines, FirstWeek strip.
- Tooltips that explain (People coach tiles: pay, classes, real cost, to sign; mastery bar colours, flag, dashed box).
- Amateur bouts have no camp (S428/S481): coach's camp row, Fight prep, guide all say fight week.
- "game crashed when i pressed set the camp": NOT reproduced (his log was rotated out by test runs). Found: amateur bouts
  still offered "Set the camp". Fixed at the buttons (FightPrep.next_step, CoachCheck) + BoutActs "startcamp" acts only
  from the camp pop-up. A central redirect of the "camp" act was tried and REVERTED: ~14 tests, TestJump and golden_path
  set a camp on an amateur bout through the act on purpose (Bouts.start_camp turns it into a camp bout).
  Fighters.gd `_camps` (tab 2) is unreachable since S396 (Routes.canon). Memory project-s532-camp-crash-amateur.
- Round portrait mask (circle, no square); fighter pictures in their own stance (orthodox = left foot leads, `_s` = southpaw);
  the towel moved to a "Fight night" card.
- Names and she/her out of the coach's read, the walk-in need and the ask news (Arena's P4P code check):
  no_pronoun_test green again (it was red in the nightly).

## Footwork (STEPSCOPE1, METHOD: findings drive the queue)
- Gate review: per-step legs from PlanFight.ANSWERS x Exchanges.STYLE_MODES (ops/Tools/treevalue_regate.py), 2/10 pass.
- cut_off sizing 1 (commit 0b4f75a7f): StepEffect.opp_steps_less now read (lv.ring_cut -> RingDuel.step_bias). TREEVALUE10:
  NO effect (Out-boxer -0.75 vs -0.7). The step fires ~once a bout, so its +1 ropes never reaches the owner's three a round,
  and it costs a little against every style. docs/TREEVALUE9_RESULT.md "S532 TREEVALUE10".
- Next, by measurement not guess: lever attribution. StepEffect.probe_off (measurement only) + probe `off=`; four runs
  (off=wrong, drain, tank, opp_ropes) IN FLIGHT at ship time (scratchpad tv11_*.log; the task prints each arm's cells).

## Design loop (METHOD S531: maps by Arena from the code, critics with a CODE CHECK)
| Map | Dola | Arena | State |
|---|---|---|---|
| Three P4P mechanics v1 (S531 built) | 8/8/9 (SQ258) | 6/7/8, code check: 12 rows the built code does less | v2 written |
| Three P4P mechanics v2 (Arena from code) | SQ262 queued | 8/7/7 | waits on Dola; then board |
| Turning pro v8 | SQ261 queued | chat running (01a1fb21) | |
| Stoppages by weight class and sex v1 | - | - | wrong dial (stop_chance is display only) |
| Stoppages by weight class and sex v2 | SQ263 queued | owed: Arena daily limit, resets 14:25 | real roll = Knockdowns.round_counts / puncher_chance, one ClassDamage dial |
Also owed after 14:25: the GUIDETIPS1 Arena critic (TASK_GUIDETIPSCRITIC1A.md).

## Seats
- Grok bots: Cursor login is back but gbot_wake hangs (no answer in 2 min); `gbot list` = 404 not routed. Left: Dola and
  Arena cover the chat/critic work.
- Arena daily limit reached ~02:10 (resets 14:25).

# S357 DIGEST (2026-11-02) - update 60: the short-notice swap, the camp test button; Miro top 5 verdict; SMOOTH3 r4 not merged

Lean commits: 58d270b (swap card), 9c43ed0 (whiteboard hover + jump=camp), 2d0df0f (update 60 notes + shortcut),
3636b5d (swap fixes found by the stills), 1151fa4 (injuries_test seed). Build exported, suite 102/102, pushed (main).
Game: this digest, MIRO_TOP5_S357.md, KALLI_WHITEBOARD_S357_BRIEF.md (SQ25), launch_targets.json (camp button), roadmap.

## Operator this session
- Board answers quoted at start: Q-S294-82 "Yes, build it", Q-S294-83 "Yes, build it" - both already built in S356 (update 59).
- C214/C215 (same mark twice) on the v1 belt road still: "why this is on the belt road??" (the body holo) - v3 (Q-S294-80) has
  no holo; whatever is built follows v3.
- "miro sub fixed check the board" - checked: two new Miro AI frames (Idea backlog ~50 stickies, Early Access top 5).
- Ziva v3.3.3 restart cut its turn ("Disconnected" screenshot) - told it to continue.

## Built (update 60)
1. SHORT-NOTICE SWAP (WeekTwist CHOICES, the 10th card, last of the Miro draft). Rare: its own dice, RARE_SHARE 0.12 of the
   weeks it can come up (57 of 400 in the test); only an amateur bout (not champ, not pro) 14+ days out with a tougher
   opponent in the division (Bouts.can_swap / tougher_opp = the lowest rating above the current one). Take the fight
   (coach's default): Bouts.short_notice - new opponent same night, b.short_notice, film depth reset, tape study restarts on
   camp.tape_start (the camp keeps its own start/week count); a win = 2 x WIN_REPUTATION (BoutNight). Withdraw:
   Bouts.withdraw_bout - bout + camp end, next offers after AFTER_DECLINE, WeekPhase re-synced.
2. Whiteboard: a twist-changed day's hover names the card it replaced.
3. TestJump jump=camp + ops board "Test: a camp on the whiteboard (update 59)" (task "FightCamp Play test camp", Test camp.lnk):
   runs to the week review, then deals the week AHEAD's choice card (the swap when allowed), lands on Training.

## Evidence
- week_twist_test (rarity, 14-day rule, swap, tape restart + week count kept, +10 on a win, withdraw), test_jump_test (camp
  lands; Monday runs the dealt card: Maria Ortega -> Priya Nair), golden_path_test, week_coach_test PASS; suite 102/102.
- Hidden-desktop stills Lean docs/playtest/s357 (tools/s357_stills.gd), on 8787/review: the camp played through - Monday
  swap Maria -> Priya, fight day 33 a win, reputation +10, peak camp.
- The stills caught 2 defects the tests had not: the jump dealt mid-week (the review replaced the card unseen, the swap
  never ran) and the swap reset camp.start ("camp week 1 of 3"). Both fixed, both now in tests.
- Export 2 stopped on injuries_test "cleared when the days are up": random quick_start seed (a fresh injury ~1 run in 8) -
  pinned seed 325, 3/3 green. Other quick_start tests may carry the same flake.

## SMOOTH3 round 4 (Ziva, wt/ZIVA_LEAN ziva/smooth3-r4 @ 36f80cc) - NOT merged
Ziva's own runs: plain 360/min (143 at a change) -> fix 340/min (133); noreach 259 (90). Bounds 250 / 110: red. The
OUTPUT-pose fade is right but only 20/min of PunchReach's ~94: the rest is elsewhere in PunchReach (reach in/out ramps,
lean). Its result file: control arms ADDED but never measured; inside_guard 8 of 571 frames called PASS (bound <= 4);
hit_gap line identical to main's round-3 line. Sent back: measure plain/noreachin/noreachout/nolean/nofade/noreach on
36f80cc, inside_guard on main too, a fresh hit_gap line, logs per arm. project.godot (editor rewrite) must not be committed.

## Decided (Claude, D49)
- Miro "Early Access top 5" verdict (MIRO_TOP5_S357.md, Q-S294-86): build 3 week-review reveal -> 2 she pushes back
  (morale = trust, no new meter) -> 5 fight poster per bout (an art seat); skip 4 (the S310 corner already has more).
- Default answer on the swap = take the fight (a replacement bout is the boxing norm; withdraw ends a paid camp).

## Next (S358)
1. Collect Ziva SMOOTH3 r4 (the arms measured) - measure on one commit; merge by diff only within bounds.
2. Q-S294-86 answer -> the week-review reveal first.
3. Q-S294-78/80 answer -> the belt road + its pull (NEXT_SESSION_PROMPT item 5).
4. Kalli SQ25 whiteboard review (research/KALLI_WHITEBOARD_S357.md) - act on it.
5. Q-S294-87 (outside testers).

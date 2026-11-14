# S469 handover (written 2026-11-14 at the end of S468; S467's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S469`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; wrap-up from ~395k (S468 wrapped at ~375k).
  At most TWO helper sessions / subagents at once.
- Never idle while a test or agent runs: run_in_background and do the next item.
- Godot jobs (tests, films, export) go through `python ops/Tools/godot_slot.py run --who s469 -- <cmd>` (rule_guard blocks others).
- A job on the hidden desktop prints NOTHING unless `tools/hidden_desktop.py run --log=<file>` is given (S468 lost a run).
- Never `cd` into an agent worktree in the main shell; read it by absolute path.

## HIS RULINGS IN FORCE (quote them)
- S459: "need to finish intergrading mechanics before we spend more time in designing the menus" -> integrate first.
- S461 greybox: each mechanic lands on the screen it belongs to as a line, a number, a hover or a few buttons.
- S459: design loop on the free seats until every mechanic scores 6+ depth and 6+ general (ops/Tools/design_loop.py).
- Q-219 liver vs ribs "yes"; Q-220 R58, Q-224 hosted show, Q-225 push/tank: "Yes, build after the fight week".
- C391 on the cross still: "Fine but i wait to see it in the match". C394 on the rear uppercut film: "still clipping" (x4).

## WHAT S468 DID (docs/CLASH2_RESULT.md is the whole story)
- tests/result_tabs_test.gd no longer hangs (a script error before quit(): its seed-44 story died with the S466 card fix).
  The sample bout is now found by FixLab's rule; the no-fix page and the fix button are both checked. failures=0.
  tools/fixlab_scan.gd: on all 20 sample bouts the plan wins 9 of 40 and the best plan change 11 (under MIN_GAIN) - a
  plan change barely matters on that fixture. Not raised with him yet: measure it on real bouts first (design loop).
- C394 glove clipping: new ruler tools/clash_meter.gd (bodies as drawn; the film prints CLASH lines). Seed-4242 film,
  frames from the hit on with a glove or forearm more than 2 cm inside the other's: rear uppercut 14 -> 3 (one frame
  0.065 m), lead uppercut 14 -> 1 (0.024 m). Changes: true glove and forearm shapes, right of way (live punch > hand going
  home > guard), the pass runs after ElbowClear (scripts/fight3d/ArmClash.gd), a crowded hand draws in, an arm opens
  outward off a live punch. `-- ballclash` = the S465 rule. Strips: docs/mockups/s468/*_before_after.png (on his board).
- Lead glove height (LANDREACH3): NOT changed. tools/landreach4_probe.gd: block_meet's CTRL_LANDED reads a half-eased
  glove (reach weight 0.14 on the hit frame) and the hit point re-latches onto it; the arm solve itself is on its aim.
- Club week v6 queued for Kalli (SQ115). GUARDKNEE2 (Qwen) was still running at the handover.

## FIRST
1. Lead glove, three steps (docs/CLASH2_RESULT.md, last section): (a) ReachLimit.carry_base returns the face whenever
   the reach was not at full weight on the hit frame (pass the weight; PunchReach is at 498/500 lines - change the call in
   place); (b) block_meet CTRL_LANDED lets the ease finish before it seeks to the contact, as the game does; (c) run
   tools/hit_gap_probe.gd on the hidden desktop WITH --log for the played numbers by punch, then FILM seed 4242
   (`hit_frame_film.gd -- <out> jabs=2 crosses=2 seed=4242`) - his C391: he waits to see it in the match.
2. Clipping leftovers: the one frame after the rear uppercut's hit (0.065 m: her guard forearm on the glove at her chin);
   a boxer's OWN two gloves overlap each other (no rule yet); the rear uppercut lands 0.114 m off her chin at 8 % speed.
   Read his comment on the S468 strip first (review board).
3. GUARDKNEE2 and LIVERPROBE1 (Qwen): collect; set LiverFold.shot_points / fold_scale from LIVERPROBE1's table
   (bar: body knockdowns 10-20 % of all counts).
4. LIVERRIBS1 step 4: the opponent's corner retiring a cracked boxer (LiverRibs.corner_retires at each bell) and YOUR
   boxer's crack card in the corner minute (Pull out / Defend the side / Fight through, behind a divider, never
   pre-selected, prices live - design s4.1). Then side elbow fixes (s4.2), switching sides (s4.3), BoutRead/Scout (s6).
5. Seat answers: SQ109/111/113 (Dola), SQ115 (Kalli, club week v6), SQ116 (Kalli, weight r3) -> ops/research/DESIGN_LOOP_S459.md.
   SQ104 came in at the wrap-up: John scored weight r2 7/5/6 (misses general design by one). SQ116's base map is
   WEIGHT_MAP_S439 (the later clarity round); John and Kalli scored WEIGHT_MAP_S434 - check Kalli's r3 answers John's list.
6. Export after any player-visible change.

## NOTES
- Regression after the clearance change (headless): block_meet 4 (the four CTRL_LANDED rows = the lead glove item), hit_frame 10,
  hit_carry 38 (`-- ballclash`, the old rule, the same day: 38). The full suite runs at 05:00.
- 16 worktrees are HELD by `start` (dirty, nothing unpushed) - old seat runs; retire_worktree handles them once clean.
- hit_frame_film prints `modifier order`, `CLASH` and (per red frame) `clashdbg`: what each boxer's clearance saw before
  and after it moved an arm. Use those before changing GloveClear again.

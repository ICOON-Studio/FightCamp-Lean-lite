# S468 handover (written 2026-11-14 at the end of S467; S466's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S468`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; wrap-up from ~395k (S467 wrapped at ~340k).
  At most TWO helper sessions / subagents at once.
- Never idle while a test or agent runs: run_in_background and do the next item.
- Godot jobs (tests, films, export) go through `python ops/Tools/godot_slot.py run --who s468 -- <cmd>` (rule_guard blocks others).
- Never `cd` into an agent worktree in the main shell (S467: it moved the session's folder); read it by absolute path.

## HIS RULINGS IN FORCE (quote them)
- S459: "need to finish intergrading mechanics before we spend more time in designing the menus" -> integrate first.
- S461 greybox: each mechanic lands on the screen it belongs to as a line, a number, a hover or a few buttons.
- S459: design loop on the free seats until every mechanic scores 6+ depth and 6+ general (ops/Tools/design_loop.py).
- Q-219 liver vs ribs "yes"; Q-220 R58, Q-224 hosted show, Q-225 push/tank: "Yes, build after the fight week".
- C391 on the cross still: "Fine but i wait to see it in the match".

## WHAT S467 DID (ops/research/S467_DIGEST.md)
- LIVERRIBS2 (Goose #271) collected (two added files only). Liver vs ribs WIRED: InjuryRoll (left ribs only; bruised/cracked,
  InjuryRoll.name_of), LiveRound side tally f.bout.sides + RingDuel/LiveRoundAfter.body_units (liver x1.3, ribs x0.55),
  hurt left ribs land x0.85, PaceAim.opp_hurt liver on the right for every stance, aim words, LiverFold.gd (body knockdown,
  round line, result-page counts tile + hover). tools/liverfold_probe.gd: 6.0 pts/shot -> 7 folds of 27 counts in 100 bouts.
- Nightly: no_pronoun, result_defects, aim_wire green. block_meet -> LANDREACH3 (Qwen running). guard_knee -> GUARDKNEE2
  (queued). plan_bots + move_tip: known causes in docs/NIGHTLY_TRIAGE_S466.md (S467 table).
- Fight week v8 passes 6/6 (John 7/6/6 + Dola 8/8). Ten stale Qwen PRs closed (all their files on main).

## FIRST
0. tests/result_tabs_test.gd HUNG twice in S467 (no CPU after a few minutes, stopped by hand); not in the nightly durations.
   Run it once on main through godot_slot with a timeout and read its last lines: a hang there is a defect (S467's only
   change near it: ResultPage counts tile, folds joined as PackedStringArray).
1. LANDREACH3 came back NOT FIXED (docs/LANDREACH3_RESULT.md, collected): the lead punches' carry starts from the drawn
   glove 5-11 cm off in height (ReachLimit.carry_base keeps `shown` for the lead hand); a y-snap traded block_meet rows and
   added 2 THROUGH in hit_frame. The fix: split the contact point (on the face) from the carry start (as drawn) - PunchReach
   is at 498/500 lines, so first move _note_shown's carry part into ReachLimit (or a new small file), then give the contact
   frame its own target. Claude does it (VISUAL: film seed 4242 on the game camera before merge; he waits to see it).
2. GUARDKNEE2 (Qwen, launched 12:58, qwen/guardknee2) and LIVERPROBE1 (queued behind it): collect; set LiverFold.shot_points
   and fold_scale from LIVERPROBE1's table (bar: body knockdowns 10-20 % of all counts).
3. LIVERRIBS1 step 4: the crack in the bout is BUILT (S467 late: LiverFold._crack, f.bout.cracked, x0.6, injury link);
   left: the opponent's corner retiring a cracked boxer (LiverRibs.corner_retires at each bell), and YOUR boxer's crack card in the
   corner minute (Pull out / Defend the side / Fight through, behind a divider, never pre-selected, prices live - design
   s4.1). Then side elbow fixes (s4.2), the opponent switching sides (s4.3), BoutRead/Scout lines (s6).
4. Seat answers SQ98/104 (John), SQ109/111/113 (Dola) -> ops/research/DESIGN_LOOP_S459.md.
5. Export after any player-visible change.

## NOTES
- 16 worktrees are HELD by `start` (dirty, nothing unpushed) - old seat runs; retire_worktree handles them once clean.
- LiverFold's dice are salted with the bout (opponent name + tally): BoutNight's own seed is the same for every bout on a
  day, so probes on one day rolled the same fold dice (0 or 7 folds whatever the chance).

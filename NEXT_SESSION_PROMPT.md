# S461 handover (written 2026-11-13 at the end of S460; S459's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S461`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; wrap-up from ~395k. At most TWO helper sessions / subagents at once.
- Never idle while a test or agent runs: run_in_background and do the next item.

## HIS RULINGS IN FORCE (quote them)
- S459: "need to finish intergrading mechanics before we spend more time in designing the menus" -> INTEGRATE1 first; no menu design.
- S459: "use all free agents on loop until all mechanics have been designed . critics need to rate them at least 6 at depth and 6 at
  general design etc" -> design loop (ops/Tools/design_loop.py; tracker ops/research/DESIGN_LOOP_S459.md).
- S460 Q-S294-219: "Yes: liver = stamina drain + a knockdown chance when hurt, ribs = the injury place (cracked rib, weeks out).
  Design map + critics first" -> ops/research/LIVERRIBS_MAP_S460.md v1, critics SQ77 (Dola) + SQ78 (John).
- S459 "do not remove the holos yet" -> side holos stay.

## FIRST: collect
1. GRADE1 (Qwen, branch qwen/grade1, brief ops/research/TASK_GRADE1.md, launched 21:42). Read docs/GRADE1_RESULT.md (ARM lines,
   GOOD_VS_POOR). Apply the DIFF by hand: its LiveRound / BoutRead lines sit next to S460's PlanPhase lines (LiveRound ~263 pick,
   BoutRead ~241 pick) - keep both; LiveRound cap 470. Then line_grade, bout_read, fight_why (red on main: 384/540), phase_wire,
   style_wire, golden_path. If no centred table cleared the bar, LineGrade stays unwired and the numbers go to INTEGRATION_S459 row 2.
2. Seat answers SQ73-SQ78 (Kalli fight week v7, Dola coach fit v4, John hosted show, Maria fighter leaves, Dola + John LIVERRIBS1).
   Each -> design_loop.py next round. Then queue: PUSHTANK_MAP_V2_S442 critic, READREVEAL1 map, CAMPLOC1, LEDGER1, weight, turning pro.
3. PRs 259 / 260 (COACHMARKET1 / PROREAD1) were collected in S458 (main is ahead); `gh pr close` was blocked by the permission check
   in S460 - close them (or ask him to).

## NEXT (Claude) - INTEGRATE1 (ops/research/INTEGRATION_S459.md)
- DONE: #1 StyleName (S459), #3 PlanPhase (98916635, phase_wire_test), #7 TraitLine (20bd3e74, trait_wire_test).
- #4 Towel next: Towel.gd is pure (risk / reasons / comes / answer / words). Build TowelWire.gd (new, small) that builds Towel's state
  from (f, m) - sides power/chin/heart, damage, counts, p_lose - and applies an answer; BoutNight.corner_jobs takes a `towel=` key
  (add it to the "fix", "talk", "adapt" match: zero new lines - BoutNight is 487/500); pull = retired (loss, PULL_DAYS, morale,
  loyalty), box_safe = pace save + hands; the card on the corner minute (CornerOverlay 452 lines); the line (careful / normal / brave)
  on fight prep; one test that plays a pull.
- Then #5 ProRead, #6 Loyalty, #8 TrainRead, #10 Knowledge, #11 ClubDeal, #12 CoachMarket. #9 TellWorth waits on LEVERS1's exchange
  table (its unit is power points - not game words).
- Not wired yet inside done items: PlanPhase late-state extra LINES (pace only has a screen); TraitLine.crossed -> week news; the three
  "new" TraitLine hooks (Stubborn, Listens, skipped mornings) are designed but not built.
- Reds on main: fight_why_test (384/540, decide with GRADE1); result_defects_test point 2 (not traced).
- POWER1E rear uppercut tail (QUICK_BACK_S 0.10 + uppercut_tail; punch_range windowed baseline 67 failures).

## DONE IN S460
- His C385/C386 (a2e21f70): LANDED = the holo's own tally (FightSeam.landed_ex reads BodyLive.round_hits); holo_live_test row proves it
  with an empty beat list. The lit call card's stamina cell + number in dark ink (HudRegroup.Cell.lit). C387: S459's Club panel.
- LIVERRIBS1 map v1 + critics queued. GRADE1 brief + Qwen launch. PlanPhase + TraitLine wired.

## TRAPS (S459, kept)
- LiveRound.gd has a TIGHT 470-line cap (file_limits): fold changes into existing lines.
- A seat-test or film run with `sharedholo` fails fight3d_play (the tool checks the side holos) - mockup only.
- Control runs: copy the touched files aside, `git show HEAD:<f> > <f>`, run, copy back (never a bare stash).
- S460: `gh pr close` is refused by the auto-mode permission check. Seat dispatch: `python ops/Tools/seat_dispatch.py --task <ID> --seat qwen`
  (dry run) then `--act`; OWNS must be bare paths (notes in parentheses on the next line).

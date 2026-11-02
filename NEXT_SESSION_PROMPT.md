# S356 - next session (written S355, 2026-11-02, after update 58)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S355 shipped update 58: the perks fight (PerkFight.gd, measured on vs off in tests/perk_fight_test.gd), CLINCH2 collected
(Ziva: clinch_check 1/6 -> 6/6; Ziva Pro not needed), CORE3 step 2 (WeekActual.gd planned vs actual at the week review +
WeekTwist.gd one twist card a week; fight week never takes a session), CORE3 step 3 (ComboOdds.gd: the combo lab's hit rates
by opponent game - Exchanges.settle's own dice). Digest: Game/Godot/research/S355_DIGEST.md.
OPERATOR RULES: no his/her in game text; agents do animations, Claude mechanics + UI; every probe at `--fixed-fps 30`;
S355 "you can change the rule": headless tests may run beside ONE windowed render on a GREEN watchdog.

1. SMOOTH3 audit, then round 4 to Ziva: run tools/smooth_probe.gd on ONE commit (>= c24500d - the twist cards change the
   path to fight night, so every arm must share a commit): plain + `-- noguard`, `noreach`, `nosnap`, `noglove`, `nojoin`,
   `nofeet`, `nosettle`, `noheads` (hidden desktop, --fixed-fps 30, --timeout=700 each, one at a time). S355 plain on 9092e67:
   OURS 351/min (143 at a clip change), pro_idle 110 on top. Write the top layer into TASK_SMOOTH3 ROUND 4, copy the brief
   to E:/FightCamp/wt/ZIVA_LEAN/docs/ziva/SMOOTH3_r4.md, branch the worktree from Lean main, send Ziva the chat line.
2. CORE3 step 4: the fight plan's Test it - 20 sims vs the scouted opponent shown as a range (e.g. 11-15 of 20), 3 tests a
   camp, film study narrows the range; show where the plan breaks. Then the peak-camp bonus (all three goal lines met = +1
   every stat for that fight, a gold line in the review).
3. Playtest a 4-week camp in the .exe yourself (computer-use) and get reviews (Kalli on design, Ziva in the editor);
   ask the operator about outside human testers.
4. Miro production map: move PERKFX, CORE3-2, CORE3-3 to DONE (not moved in S355).
5. Cleanup: TrainingBoard.gd is no longer shown (fold its body picture into the perk road or delete); wrestling reaction
   ids still say "her" (display map).

# S355 DIGEST (2026-11-02) - update 58: the perks fight, planned vs actual + a twist card a week, the combo lab's hit rates

Lean commits: 9654051 (perks), 9092e67 (CLINCH2 collected), c24500d (CORE3 step 2), ddcc68a (CORE3 step 3). Game: this
digest, roadmap, live runs, Q-S294-81 closed, TASK_SMOOTH3 round-4 audit.

## Operator input this session (verbatim)
- Chat: "you can change the rule" (on my holding a test back while a windowed render ran) - Lean CLAUDE.md now lets a
  headless test or two run beside a render on a GREEN watchdog; never two windowed renders at once.
- Board: none new. Q-S294-81 (RPG recruit) closed with his S354 chat answer "Yes, build it" (shipped as update 57).

## What now works (Lean, update 58)
1. THE PERKS FIGHT (PerkFight.gd, pure; hooks in Knockdowns / BoutNight / LiveRound). Measured on the same nights with the
   perk on vs off (tests/perk_fight_test.gd, 160 nights per arm, Lucy):
   - Iron chin (chin 50 vs Dana 72): her counts 279 -> 185, stoppages 60 -> 34, 132 staggers.
   - Stiff jab vs Maria (presser): rounds won 205 -> 224. Ring general vs Erin: 117 -> 128.
   - Counter sense vs Maria: rounds 205 -> 214, landed 9766 -> 9978, counted bouts 6 -> 9 (tuned: damage 8 + no margin
     moved only 1 count; now damage 15 + margin 12).
   - Second wind: round-3 energy at the bell 70.7 -> 80.7. Body snatcher: Maria's last-bell energy 3.7 -> 1.9.
   - Finisher (power 80 vs Maria): stoppages 11 -> 18. Fast hands (drilled double jab): rounds 262 -> 271 (x1.1 gave +3:
     too small; now x1.25).
   Round lines name the perks at work; Counter sense gets its own fight line and 3D caption. Perk cards say exactly what
   each does. Red on main (13 fails) before the hooks.
2. CLINCH2 COLLECTED (Ziva, 5 rounds): tools/clinch_check.gd re-run on today's main 1/6 -> 6/6 (3 holds; heads 0.17-0.21 m,
   axis turn 34 deg, digs 6/6 reach the ribs). Stills opened (c02 tie, before/c08). Ziva Pro: NO - the S354 rule ("6/6 on
   Ziva Smart = Basic is enough") is met.
3. CORE3 STEP 2 - PLANNED VS ACTUAL + THE TWIST CARD (WeekActual.gd, WeekTwist.gd, pure). Monday keeps the week's
   projection; days run other than planned are logged (injured / plan changed); the week review shows planned vs actual
   per trained stat, weight and fatigue peak, the reason, and the coach's ONE change (overreached -> ease a morning; over
   the limit -> the cut diet first, ~0.45 kg a week, then a hard run; a stat short -> its session; else keep the week).
   One twist card a week (sore wrist, rain, weights room shut, partner ill, head cold, visiting pro, quiet week), seeded,
   never twice running, shown on the Training tab and projected there.
4. CORE3 STEP 3 - THE COMBO LAB'S HIT RATES (ComboOdds.gd, pure). PLAYBOOK > Combos shows IN THE RING for a book
   combination: how often it lands whole in each opponent game vs the next opponent (main game in gold) or an even one -
   Exchanges.settle's own dice (20,000 rolls per edge match within 0.005). E.g. the one-two vs Maria: 45 % against her
   pressing (no help), 59 % against boxing at range.
Tests: suite 96/96 after step 2; combo_odds, combo_builder, golden path green after step 3.

## Decided (Claude, the developer)
- Fight week never draws a twist that takes a session: a head cold on day 28 (bout day 33) left the golden path's camp
  61.25 kg for 61.2 - luck at the scale with no week left to answer it, not a choice.
- No weekly twist news line: it flooded Mail (49 unread in the golden path); the Training tab and the review carry it.
- The coach names the diet before a session for weight: one hard run over a light morning is ~0.05 kg; a cut ~0.45 kg.
- A combination "lands whole" = she wins the exchange it is thrown in; the lab shows the combination's own part (the
  corner's calls and her habits move a real exchange on top).

## Agents
- Ziva: CLINCH2 collected; seat free. SMOOTH3 round 4 goes to Ziva once the ablation names the layer (below).
- SMOOTH3 audit (CLAUDE.md "audit before more fix rounds" after Goose's 3 red rounds): plain smooth_probe on main 9092e67
  `OURS 351/min (648, 143 at a clip change)`; by clip pro_idle 110, pro_left_hook 77, pro_body_shot 60, pro_left_jab_b 48,
  pro_left_hook_v2 37, clinch_vic 36, clinch_att 32. The per-layer arms were VOID (they ran across the step-2 commit, whose
  twist cards change the path to fight night) - rerun all arms on ONE commit >= c24500d.

## Not done (next session)
- SMOOTH3: the ablation on one commit (plain + noguard noreach nosnap noglove nojoin nofeet nosettle noheads), then the
  round-4 brief to Ziva on the top layer.
- CORE3 step 4: fight plan Test it (a range like 11-15 of 20, 3 a camp, film study narrows it).
- Playtest a 4-week camp in the .exe (computer-use) + Kalli / Ziva reviews; ask the operator about outside testers.
- The peak-camp bonus (all three goal lines met = +1 every stat for that fight) is still open from the S354 design.
- Cleanup: TrainingBoard.gd is no longer shown; wrestling reaction ids still say "her" (display map).
- Miro production map not moved this session (context); move PERKFX / CORE3-2 / CORE3-3 to DONE next session.

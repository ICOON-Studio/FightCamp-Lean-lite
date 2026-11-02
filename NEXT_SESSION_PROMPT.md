# S365 - next session (written S364, 2026-11-02, after update 66)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean (branch `main`).
S363 (Lean 6f1758c): Kalli's SQ26 belt-road review collected (Game/Godot/research/K_BELTROAD1_KALLI.md). Her first change is
built: the stripe is a choice (scripts/rules/StripeCall.gd: give now / hold back / give early). Morale is read at the opens
(NoGi.win_chance) and moved by her results. Ana's week is in the week review (WeekReview._grappler, Grapplers.week_report).
Digest: Game/Godot/research/S363_DIGEST.md. Stills are on /review S363.
OPERATOR RULES: no his/her in game text; agents do animations, Claude does mechanics + UI; probes at `--fixed-fps 30`; tests
may run beside ONE windowed render on GREEN; check Miro (https://miro.com/app/board/uXjVETf7la4=/) at start.
NEVER rewrite a .gd through PowerShell Get-Content/WriteAllText: use the Edit tool or Python utf-8. roadmap.json is indent 1.

S364 (Lean 2767c1c..9fbc103, update 66): Kalli parts 2-3 - what the classes drill (NoGi.drilling_for: coach / open / fav)
and each open decided on one syllabus group (NoGi.lean_edge +-0.25, signature +0.05, NoGi.chance_word). Kalli's "weakest
group" plan was measured as a trap and replaced by "for the next open" (Game/Godot/research/S364_DIGEST.md).

In order:
1. Kalli part 4: Ana's no-gi side as gym business - BJJ members on their own dues, a medal brings 1-2 members, a blue belt
   teaches the beginners' class. Real UK BJJ club dues first (John via seat_queue) - no numbers from memory.
2. If any test log shows "bout has no opponent" (Home.events / FightPoster warning), find the writer (S364 could not).
3. His /review comments on updates 64-66; Q-S294-89 (SMOOTH3 film) when he answers.
4. The Miro production map cards (S361-S364 skipped it).

# S368 - next session (written S367, 2026-11-02)

S367 (ops/research/S367_DIGEST.md): playtest + critic review 6.5/10 (ops/research/S367_CRITIC_REVIEW.md); Gemini judges
video - `python ops/Tools/gemini_judge.py <clip.mp4> --model argon --fps 24 --kind fight|clip --intent "..."` (his key is
in HKCU\Environment; prepaid credit, so it can never overspend; every run lands on the board's Gemini meter). Argon on a
live round: 2/10 - clinches merge, the referee's break passes through a boxer, phantom hits, ~60-70% speed. ORDER = roadmap
`now.next_action`: (1) remove the empty E:\FightCamp\Game folder; (2) test + merge s365-bjj-side; (3) REFBREAK via ONE
animation seat in its own worktree, the same fight film before/after judged by Argon (Antigravity has no Argon - Gemini
3.8 Flash High there is free); (4) CLINCHMERGE, FIGHTSPEED, PHANTOMHIT, CAMORBIT the same way.

--- S367 notes (written S366) ---
# S367 - next session (written S366, 2026-11-02)

Start: open the session in E:\FightCamp\Lean (ONE repo since S366: the workflow is in `ops/`; the old repo is deleted), then
`git pull && python ops/Tools/agent_comms.py start`. Old paths below ("Game/Godot/research/X") are now `ops/research/X`.
S366 (ops/research/S366_DIGEST.md): the E: SSD stalled (96% full + a 9.5 GB git repack); the workflow moved into ops/;
E:\FightCamp\Game deleted on his word; the watchdog gates E: (RED < 5% free / writes > 250 ms); /animations has orbit
previews of all 153 clips. S367 order = roadmap `now.next_action`: (1) remove the empty E:\FightCamp\Game folder (a hook
stub only); (2) branch s365-bjj-side is UNTESTED - parse, bjj_side/stripe_call/no_gi/drill_pick/golden_path tests, merge
into main, export; (3) fight clips at captured speed played whole + the pro_win pose; (4) his comments on /animations.
His own actions pending: E: pagefile (32 GB, Windows setting). Undisputed stays (he plays the ESBC Revival mod).

--- S365 notes (written S364) ---
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

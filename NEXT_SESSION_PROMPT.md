# S371 - next session (written S370, 2026-11-03)

Start in E:\FightCamp\Lean: `git pull && python ops/Tools/agent_comms.py start`. Digest: ops/research/S370_DIGEST.md.
Research: ops/research/S370_MENUS_RESEARCH.md (Miro menu rules, praised games per loop, our gaps). Operator focus S370:
the player experience IN THE MENUS - training and planning first (memory feedback-menus-are-the-game-s370); animation
work goes to seats. ORDER = roadmap `next_action`:
(1) collect the seats: Arena FLOWBOUT1 PR (branch arena/ca105630-fightcamp-lean: plan_record_test into run_tests.sh,
then wire the Record tab + Playbook plan-line win rates), agy KNEETRACK1 (tools/knee_probe.gd -- layer=1, windowed film),
Qwen NOREF1 (tools/push_off_probe.gd + film), Ziva BODYREACT1 (her chat on 7012; then send TASK_WEIGHIN3D1);
(2) Q-S294-92 training goals as tests (canvas https://claude.ai/artifact/HLaiSxhMXEPERsM3naACY7) + John's J_TESTS1
numbers (gbot thread John) -> build GOALTESTS1; (3) the plan in the ring + the corner's plan so far + the plan board reads
the file with a ROUND row (S369 proposal 2-3); (4) re-render the guide (python tools/hidden_desktop.py run ... --script
res://tools/guide_tour.gd -- <dir>; python tools/guide_gif.py <dir> <log> ops/previews/S370_guide) and resend;
(5) one belt match before claude/bjjmatch1 merges (S369).
TRAPS: a headless pose probe must `await process_frame` after loading clips or every seek reads the rest pose; the tape
room is a layer over the game (not a modal) - take it off by node; in 3D the fight's buttons live in the fight view's
overlay (root.find_child), and the intro runs ~20 s before the first bell.

--- S370 notes (written S369) ---
# S370 - next session (written S369, 2026-11-03)

Start in E:\FightCamp\Lean: `git pull && python ops/Tools/agent_comms.py start`. Digest: ops/research/S369_DIGEST.md.
Playtest + proposal: ops/research/S369_PLAYTEST_TWO_FIGHTERS.md. ORDER = roadmap `next_action`:
(1) the operator picks the first fight change (the S369 box asked: remove the referee - both boxers push each other off
slowly / tired legs red on the holo + weaker tired shots); build it, then the other, body-shot hit reactions, and the
flow (THE PLAN, LIT UP) saved per bout on the fighter page; (2) scouting -> plan (tape answer replaces its plan line, the
plan board reads the file + a ROUND row, the plan visible in the ring and the corner); (3) readable corner summary, rename
"exchanges won"; (4) collect PR #20 CAMCLINCH1 windowed (cam_view_probe needs a window; the dispatcher's BEFORE film was
6 s of walk-in), retire agy/refbreak1 (superseded by "remove ref"), merge claude/bjjmatch1 (belt match, Ana's strength/
cardio, HUD numbers; 118/118) after the operator plays `FightCamp.exe -- jump=grapple match=1`.
LESSONS: a career playtest plays the planning game (memory feedback-career-playtest-uses-every-feature-s369); the exe's
window loses focus whenever a chat message arrives - re-focus (Alt keypress + SetForegroundWindow, handle in a variable)
before each computer-use batch; open_application starts a SECOND exe. Antigravity = Gemini 4 Argon High (seat_dispatch).
Miro production map (wrap-up 3b) was NOT moved in S369.

--- S369 notes (written S367) ---
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

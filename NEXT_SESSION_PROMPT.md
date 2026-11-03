# S372 - next session (written S371, 2026-11-03)

Start in E:\FightCamp\Lean: `git pull && python ops/Tools/agent_comms.py start`. Digest: ops/research/S371_DIGEST.md.
TWO JUDGED LOOPS ARE RUNNING (operator: "let argon do all the fixes until its 9/10", "fix bjj until its 9/10"):
- FIGHT9 on Antigravity/Argon via seat_dispatch: each round's brief is ops/research/TASK_FIGHT9R<n>.md, written by
  loop_next with Argon's newest verdict; read seat_dispatch.log "LOOP FIGHT9" lines and live_runs.json. Main = 2/10.
  A round that stalls (same score twice, or a crash) -> read its verdict + output and sharpen the next brief by hand.
  At 9/10 (or 12 rounds): collect the last KEPT branch by diff + the probes + a film you watch yourself, then merge.
- BJJ9 on Ziva (her chat on 127.0.0.1:7012, queued after BODYREACT1): she logs rounds in ops/research/BJJ9_ROUNDS.md,
  branch ziva/bjj9 from claude/bjjmatch1. Belt match = 2/10. Collect BODYREACT1 first (body_react_probe + film).
ORDER: (1) the loops (above) + collect BODYREACT1; (2) male MetaHuman boxers - the operator was asked (build in Unreal
with Chrome closed on a GREEN PC, ops/Tools/metahuman, cfg sex "M"); then Faces picks bodies by sex and guide_tour signs
Danny/Josh + follows Ana (memory feedback-playthrough-two-fighters-s370); (3) John J_TESTS3 (men's bleep/force/speed,
gbot thread John) -> SkillAwards.BLEEP_SEXES + TestDay men's anchors; (4) GOALTESTS1 phase 2 next: the test-day moment
(3D pad round + PASSED stamp), the passed grade upgrades its move cards, Day 1 vs today (GOALIDEAS_SUMMARY_S371.md);
(5) FLOWBOUT1 wiring: Record tab + Playbook plan-line win rates (PlanRecord.rates/verdict); (6) women's limits 61.2/66 ->
60/65 (J_MEN1: not in any current rulebook) with Lucy's cut checked.
MIRO (S371): production map P0-P9 updated; the seats' ideas frame https://miro.com/app/board/uXjVEV03QWA=/?moveToWidget=3458764689220929557 has a YOUR NOTES lane - read his notes there at start. The DONE columns are full: archiving old DONE cards = deleting them, ask him first. Stale cards left in place: P1 NOW three Goose cards, P2 NOW 'Agent run in flight', P3 NOW Cursor pictures + NEXT 'Waits on your answer'.
TRAPS: export.sh runs the suite at JOBS=4 - beside agents run `JOBS=2 sh tools/export.sh`; a stopped background shell
leaves xargs + Godot test children running (kill them by command line). Argon reads only its worktree (file tools
only): anything it must read goes on main (ops/research is fine - Godot ignores ops/). The judge_film.gd movie records
at 1920x1080 whatever --resolution says.

--- S371 notes (written S370) ---

SEATS AT HANDOVER: KNEETRACK1 DONE -> PR #22 (checks 5/5 PASS; Argon 2->2/10 but it judged a turntable as a broadcast and
said the standing clips keep the knees over the toes) - collect with knee_probe -- layer=1 + your own look at the orbit film;
NOREF1 launched on Qwen by the scheduled 01:39 cycle (BEFORE Argon 2/10).

FIRST: Q-S294-92 board comment (Claude overwrote it at 01:12, restored): "ask for other ideas use dola,ludo,ziva,gemini4,
grok" -> ops/research/ASK_GOALIDEAS_S370.md sent to Grok (gbot Kalli thread), Dola (cici.py read --out), Gemini 4
(answer in ops/research/GOALIDEAS_GEMINI4_S370.md). LUDO: the message went into the WRONG chat ("Multi-Hub Space
Strategy", another project) - resend in a FightCamp chat (All Chats -> the FightCamp one, check the title first). ZIVA:
send it after BODYREACT1. Collect all five, merge the ideas into GOALTESTS1 phase 2, show the operator a short summary.

Start in E:\FightCamp\Lean: `git pull && python ops/Tools/agent_comms.py start`. Digest: ops/research/S370_DIGEST.md.
Research: ops/research/S370_MENUS_RESEARCH.md (Miro menu rules, praised games per loop, our gaps). Operator focus S370:
the player experience IN THE MENUS - training and planning first (memory feedback-menus-are-the-game-s370); animation
work goes to seats. NEW S370 RULE (memory feedback-playthrough-two-fighters-s370): every playthrough runs TWO fighters -
a MALE boxer and the female BJJ athlete (Ana). The game is women-only today, so FIRST build men's boxing: TASK_MALE1
(John J_MEN1 classes, Kalli K_MEN1 opponents - gbot threads; f["sex"], men's divisions, a pronoun helper and the
she/her pass, male MetaHumans via ops/Tools/metahuman in Unreal on a GREEN PC; the male holo = the male half of the S353 ecorche pack, already owned). ORDER = roadmap
`next_action`: (0) MALE1; (1) collect the seats: Arena FLOWBOUT1 PR (branch arena/ca105630-fightcamp-lean: plan_record_test into run_tests.sh,
then wire the Record tab + Playbook plan-line win rates), agy KNEETRACK1 (tools/knee_probe.gd -- layer=1, windowed film),
Qwen NOREF1 (tools/push_off_probe.gd + film), Ziva BODYREACT1 (her chat on 7012; then send TASK_WEIGHIN3D1);
(2) GOALTESTS1 phase 2 (operator "Yes, build it"; phase 1 = the skills award road + bleep engine, 1e89b6a; canvas
https://claude.ai/artifact/HLaiSxhMXEPERsM3naACY7): the test-day moment, the records wall, Power/Speed tests on John's
J_TESTS2 women's values (gbot thread John), Kalli reviews the bleep calibration (SkillAwards.BLEEP_*_AT); (3) the plan in the ring + the corner's plan so far + the plan board reads
the file with a ROUND row (S369 proposal 2-3); (4) re-render the guide (python tools/hidden_desktop.py run ... --script
res://tools/guide_tour.gd -- <dir>; python tools/guide_gif.py <dir> <log> ops/previews/S370_guide) and resend;
(5) one belt match before claude/bjjmatch1 merges (S369).
DISPATCHER: the scheduled agy launch died once with WinError 2 (S370 patch logs the agy path it uses - read
seat_dispatch.log's "SEAT <id>: agy = ..." line); if a scheduled launch fails again, rerun with `seat_dispatch.py run <ID>`
from the session shell. TRAPS: a headless pose probe must `await process_frame` after loading clips or every seek reads the rest pose; the tape
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

# S380 - next session (written S379, 2026-11-04)

START in E:\FightCamp\Lean: `git pull && python ops/Tools/agent_comms.py start`. Digest: ops/research/S379_DIGEST.md.

OPERATOR RULES FROM S379 (memory has them): open every clip with eyes before sending/collecting (yours and other seats');
pressing contact (leg under an armpit) is normal, only pass-through is a defect; picture cards over text menus; BJJ is
Argon's (not Ziva's); cameras never zoom while turning, TV broadcast angles, <= 10 deg/s; film clips start with each boxer
in his corner, walk to centre, fight.

DO IN ORDER:
1. Fix seat_dispatch agy launch from the scheduled reconcile: agy.exe "exists False" for 10 min then crash (FIGHT9R8,
   BJJ9R11) while session-shell launches work. Find agy at call time (shutil.which / the shim) and requeue on
   FileNotFoundError instead of failing.
2. TV camera: the workflow tv-broadcast-camera (branch claude/tvcam) was running at hand-over - read its verdict, open
   E:/FightCamp/tmp/s379/tvcam/knockdown_tv.mp4 with eyes, then fight9base. Then films start in the corners (judge_film /
   knockdown_film skip the ring walk-in). Then release FIGHT9R10 (dispatch_queue status held -> queued).
3. Merge main's pose fix (d5173e6e) into claude/bjj9base, relaunch BJJ as BJJ9R12 on agy (copy TASK_BJJ9R11 -> R12).
4. Camp protocol: Hard barely changes the stat and load_setting is never read by the sim - make the protocol matter
   (fatigue + gain); men's station pictures; regenerate the theatre's fifty_fifty.png card.
5. Queue LOCOWALK4 on cursor (BASE claude/locowalk3 pushed); export update 75 (camp cards, callouts, theatre).

IN FLIGHT: tv-broadcast-camera workflow (this session's background; result lands in claude/tvcam). FIGHT9R10 HELD.
NOT DONE: corner-start films; BJJ9R12; update 75; men's camp pictures.

--- S379 notes (written S378) ---

# S379 - next session (written S378, 2026-11-03)

START in E:\FightCamp\Lean: `git pull && python ops/Tools/agent_comms.py start`. Digest: ops/research/S378_DIGEST.md.

LEGS STAY THE PRIORITY (operator S377: "the walking on the clip is so bad", "slide across", "knees trembling"). What changed:
- LOCOWALK1 never ran a shell: Cursor auto-updated at its launch and started running the repo's PreToolUse hook without
  CLAUDE_PROJECT_DIR (rc 2 on every call). Fixed fa59bedc and proven with a one-line Cursor run. It faked the walk with a
  sine-wave generator (no compile) - PR #31 closed. Lesson: "shell hook broken" in a seat's output = our infrastructure;
  reproduce with `ops/Tools/cursor_task.cmd <prompt> <wt> <out>` before relaunching.
- LOCOWALK2 QUEUED on cursor (launches when a PC slot frees; Ziva + agy hold both): Ludo's CAPTURED presets, not
  text-to-motion - `ludo model animate-preset --preset-id walk_backward|backpedal|walk_forward|walk_relaxed|strafe_* --in-place
  --crop-loop` on our boxer (clip_gltf export), import via clip_gltf, tools/locowalk_bake.gd keeps the walk's hips + legs and
  mc_Box1_M3_Idle's guard upper body. 10-credit cap (536 on the account). Collect against the drawn-bone bars in its brief
  and your own eyes burst; if the presets fail, the footwork mocap pack goes to the operator (his money).
- Then: walk_back_guard -> KnockdownCount.WALK_CLIP; brief FIGHT9 to put the fight's footwork on the step clips + StepRoot.

IN FLIGHT (yours): LOCOWALK2 (queued, cursor); FIGHT9R7 (agy Argon High since 17:45, BASE claude/fight9base, its before
film 4/10); BJJ9 round 10 (Ziva, chat "BJJ9 Round 10" on 7012, new scripts/grapple/GrappleFinish.gd, nothing pushed). Collect
FIGHT9 / BJJ9 only at a real 9/10 (check the verdict file's Score line).

BUILT S378 (main, IN the update 74 exe): PLANCOMBO1 - PLAYBOOK > Game plan's GO-TO COMBINATION row (f["plan_combo"]): the named
own combination decides 40 % of the combination exchanges (not 33 %) while thrown whole (OwnCombos.whole_at = the ring's
rule), picked 1.21x in the ring. Test jump `jump=gameplan` + board button "Test: the plan's go-to combination (update 74)".
NOT DONE: roster boxer tiles without face photos; the operator has not played updates 73-74; E:\FightCamp\wt\MERGE_F9BASE
still left for the operator to delete.

--- S378 notes (written S377) ---

# S378 - next session (written S377, 2026-11-03)

START in E:\FightCamp\Lean: `git pull && python ops/Tools/agent_comms.py start`. Digest: ops/research/S377_DIGEST.md.

THE OPERATOR'S LEGS COMPLAINTS ARE THE PRIORITY (S377, watching the knockdown film): "the walking on the clip is so bad",
"their legs dont really move they slide across", "the knees seem to be trembling", "why you fail to fix simple clip
animations?", "do you use your eyes skill when judging clips?". What is true now:
- NOT the rig. Sliding = clips played in place + code moving the body: StepRoot (scripts/fight3d/StepRoot.gd) now moves a body
  by the clip's planted foot (the knockdown corner walk uses it).
- The library has NO good walk: af_walk limps, the loc_* step loops squat (hips 0.17 m low, knees in) - the clips themselves
  (filmed with `-- nofeet noknee`). LOCOWALK1 is RUNNING on cursor (Ludo CLI 0.2.2, cap 6 credits; operator: "Try Ludo
  first") making walk_back_guard / walk_guard / walk_relaxed + step_in/out/left/right_guard. If its clips fail the bars,
  ask the operator about buying a boxing footwork mocap pack (his money) - board question with the failing numbers attached.
- Knee tremble = FootPlant's procedural steps (drawn bones: foot mid-step 43 % of fight frames, each step pumps the knee 35 deg;
  `nofeet` jerk 1.6-3.2 vs 11-15 deg/frame^2). Two tunings tried and reverted. Real fix: the step clips + StepRoot in Footwork,
  FootPlant as ground contact only (FIGHT9's files - brief it with the numbers, or build it when the clips exist).
- PROBE TRAP: get_bone_global_pose outside the modifier pass = the CLIP's pose. Measure DRAWN bones (skeleton_updated cache,
  tools/knockdown_film.gd _watch). knockdown_film's walk-slide line is RED until LOCOWALK1 lands - every other line PASS.
- JUDGE LEGS WITH EYES + NUMBERS before sending anything: `eyes index <mp4>`, `eyes burst <id> <t> --count 16 --span 3` on every
  moving leg, plus the drawn slide / knee-jerk lines. A still sheet never shows a slide.

IN FLIGHT (yours): LOCOWALK1 (cursor, wt LEAN_LOCOWALK1); BJJ9 round 10 (Ziva, chat "BJJ9 Round 10" on 7012, armbar finish,
ziva/bjj9 @ cf5891cf - click Continue if it stopped at its 32k reply cap); FIGHT9R7 QUEUED on agy from claude/fight9base
(= R5 + main 3264b79e; Argon 3/10 last). Argon's prompt was fixed this session (men, no referee by design) - main with the
knockdown count judged 4/10. Collect FIGHT9 / BJJ9 only at a real 9/10 (check the verdict file's Score line).

BUILT S377 (main, not in an exe yet): KNOCKCOUNT1 (neutral corner, the clock holds, count 1-8 / 10, rise at the sim's up_at,
BOX! / STOPPED / KO ends the bout at once, overhead count shot), STEPROOT1, the drawn-bone probe, CI artifacts 2 days.
LEFT FOR THE OPERATOR: delete E:\FightCamp\wt\MERGE_F9BASE (temp merge checkout; the safety check refused Claude's rm).
NOT DONE: Kalli's named-combo share (needs a plan option for own combinations); Roster boxer tiles without face photos;
update 73 still unplayed by the operator.

--- S377 notes (written S376) ---

# S377 - next session (written S376, 2026-11-03)

START in E:\FightCamp\Lean: `git pull && python ops/Tools/agent_comms.py start`. Digest: ops/research/S376_DIGEST.md.

ARGON IS FIXING ALL THE CLIPS (operator S376: "let argon fix all the clips", "tell argon i expect to raise the quality to
9/10 results"). FIGHT9 loop: R6 on agy Gemini 4 Argon High (the operator bought 2,500 Antigravity credits; he has Google AI
Pro - NEVER suggest a bigger plan) from claude/fight9base (= cursor/fight9r5 + main). No round cap (LOOP_MAX 99), stops at a
real 9/10. Judged film: Danny's men's bout with a knockdown at 70 s (judge_film fightjump=men_fight knockdown=70).
Brief (TASK_FIGHT9R6.md, inherited by every round): knees tremble, knees bend sideways + feet turn on the canvas, bare toes
through the boot soles, foot jumps 18 > 4 between clips; keep floor_clear_probe + knockdown_film green.

CHECK EVERY SCORE AGAINST ITS VERDICT FILE before believing it (ops/previews/dispatch/FIGHT9R<n>/after.gemini_argon.md,
the **Score** line). S376: the parser read Argon's "nowhere near a 9/10" as 9/10 and stopped the loop at a real 3.5 - fixed
(read_verdict = the Score line); `python ops/Tools/seat_dispatch.py reloop <task>` re-reads stored verdicts, no spend.
Collect FIGHT9 only at a real 9/10 with fight9_probe, knockdown_film, floor_clear_probe green; merge main into it first
(agy has file tools only - merge main into a BASE yourself before an agy round).

BJJ9 (Ziva) holds the belt match on ziva/bjj9 = cf5891cf, now with Claude's BJJMENU1 (each call a card: chance, points,
gas, risk, what a miss costs). Not on main until BJJ9 is collected. Ziva's MCP was ECONNREFUSED all S376 - restart Ziva or
move the BJJ9 loop to agy.

BUILT S376 (all on main, exe exported, update 73 in Builds/WHAT_TO_TRY.txt; the operator has NOT played it yet):
- legs: FootPlant STEP_REACH/CAP_REACH - knees locked straight 14-22 % -> 0-1 % (men and women, tools/men_fight_film.gd)
- pace: recover/react speed-ups 2.5x -> 1.5x, OTHER_SPEED 1.1, SWING_S 0.2 (operator: "punch speed very fast")
- KNOCKDOWN1: fall on the shot + slow-motion replay (KnockdownReplay + PoseRecorder); FloorClear keeps a downed boxer ON
  the canvas (operator: "hands are below canvas wtf")
- BJJCOACH1: coach's steps under Ana's mat; leg locks play leg locks
- S375 playtest fixes: Ana card, Scouting face cards keep ranges, Drill it on own combos, written personalities
- KALLINUMS1 (Qwen PR #27) collected
OPEN for the operator to judge: update 73 in the exe (Danny's legs + a knockdown + Ana's card/steps).
NOT DONE: Kalli's "plan line names the combination" share 0.40 (PlanBoard lines carry no combo id); the Roster's boxer tiles
have no face photo while Ana's card does.

--- S376 notes (written S375) ---

# S374 - next session (written S373, 2026-11-03)

CLINCHES (operator, end of the late S372 run): "clinch happen only when a fighter is desperate to break opponents combo
but get risk of getting hit, that should be pretty rare and i dont care about the real stats" - ClinchBeats rewritten: a
clinch answers a landed combination (3+ in 0.9 s, 2+ landing), GRAB_P 0.12 (x2.5 hurt), one an exchange at most, 55% eat
an entry shot first; ~0.16 a round (was 2.5-4.8). clinch_beats_test 11/0. TASK_FIGHT9R3 told.

PR #24 (agy/fight9r1, FIGHT9 round 1): main merged in (S374, the operator asked). One conflict, BeatFire.gd: main's
BODYREACT1 waits + round 1's refused punch shows nothing, no big-shot slow-mo, de-duplicated defence; a boxer still
folded over a body shot does not defend (BeatFire._folded) and body reactions keep main's pace (BeatClips.body_react).
fight9_probe 13/15 (unchanged: ring-entry head 1.495, clinch break 2), beat_clips/fight_flow/golden_path/clinch_rest/
ring_lens PASS; body_react_probe curl OK but HELD 0.20 s < 0.35 - Argon's faster combos (COMBO_LAND_S 0.28) land the
follow-up inside the fold. TASK_FIGHT9R3.md now says so (rounds inherit it); a FIGHT9 branch is collected only with
body_react_probe PASS. The kept branch to collect is agy/fight9r2 (PR #25) or later, not #24 - merge main into it too.

GEMINI (8ae47866): every paid call goes through gemini_meter.check (budget 14 Google-counted, cap 400k tokens a call) and a
loop round reuses an already-judged commit's film as its before. When the operator raises the cap at ai.studio/spend:
`python ops/Tools/gemini_meter.py budget <cap - 1>` then rejudge.

DONE BEFORE S374 STARTED (operator "Yes, fix it", 169e5fc4): Danny's first offer used to miss weight; Bouts.makeable_day now dates
an offer for a boxer over his class where Sim.weigh_forecast reaches the limit (up to 4 weeks later). Suite 128/0.

Start in E:\FightCamp\Lean: `git pull && python ops/Tools/agent_comms.py start`. Digest: ops/research/S373_DIGEST.md.
GEMINI CAP RAISED (operator "Yes, set EUR 50"; Claude set it at ai.studio/spend; brake budget 48 Google-counted). FIGHT9R3
relaunched 08:12 - its before film (agy/fight9r2 today) judged 2/10, agy working; BJJ9 round 8's film judged by Claude
with Ziva's recipe: 3 -> 4/10 (ops/previews/BJJ9/bjj_r8.gemini_argon.md; KEEP) - tell Ziva to read it and go on. COLLECT: Qwen
PASSEDSTAMP1 = PR #26 (checks 5/5; add passed_stamp_test to run_tests.sh at the merge).
LOOPS: FIGHT9R2 (PR #25, agy/fight9r2) probe 15/18 after Claude's a6fadb9b - the operator's C218 moving legs fixed, no
referee; 3 FAIL = clinch breaks pass through. R3 queued on BASE agy/fight9r2 (the push-off). seat_dispatch now holds the
loop on an unjudged film and --check-only parses the brief's scripts (agy broke its own probe). BJJ9: Ziva round 7
(f1e25860). Before collecting FIGHT9, merge main into the kept branch (BodyBurn tank lines + BODYREACT1 are on main).
QUEUED: Qwen PASSEDSTAMP1 (the PASSED stamp in the week review - add passed_stamp_test to run_tests.sh at the merge).
SENT: John J_WEIGHT1 (real amateur cut rates; club-women bleep), Kalli K_GRADED1 (graded-move gas saving %) - gbot threads.
BUILT S373: offer weigh-in forecast (Sim.weigh_forecast), men's force + norm words + calmer steps, women's 2025 classes,
graded combo cards (SkillAwards.ECONOMY), FLOWBOUT1 on screen, tired legs red, exchanges-won label. Not done: guide_tour.

--- S373 notes (written S372) ---

# S373 - next session (written S372, 2026-11-03)

Start in E:\FightCamp\Lean: `git pull && python ops/Tools/agent_comms.py start`. Digest: ops/research/S372_DIGEST.md.
LOOPS: FIGHT9 round 2 (agy/fight9r2, LEAN_FIGHT9R2) builds on round 1 compile-fixed (agy/fight9r1 7a9313b7, PR #24). Its
BEFORE film = round 1's first real Argon score; round 1 probe 13/15 (ring-entry head 1.496 m, clinch break 2 through=3).
The operator's C218 ("when legs move its akward") is round 2's top item. seat_dispatch now boots Main.tscn after a seat
delivers (compile_errors), gives agy one repair pass, and never films a branch that does not compile - check
seat_dispatch.log for COMPILE lines. BJJ9: Ziva round 4 (BJJ9_ROUNDS.md). Before collecting FIGHT9, merge main into the
kept branch (BODYREACT1 changed BeatClips/BeatFire on main).
SENT: John J_TESTS4 (men:women rear-hand force on one device -> TestDay.POWER_MEN_AT, empty today = no men's force test);
Kalli K_CALIB1 (the Sunday test curves). Collect both (gbot thread --to John / --to Kalli).
ORDER: roadmap now.next_action. MEN: five male MetaHumans are in (Faces.MEN_CM; jump=men_fight); the male body-map holo
is in (holo_m). Men are bare-chested (operator: "male boxers donot wear tops"). Danny missed weight on his first offer (diet-only cut too slow for 1.6 kg in 17 days).
TRAP: Argon (agy) cannot run Godot - it wrote PackedStringArray.any() and broke indentation; the gate catches it now.

--- S372 notes (written S371) ---

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
MIRO (S371): production map P0-P9 updated; the seats' ideas frame https://miro.com/app/board/uXjVEV03QWA=/?moveToWidget=3458764689220929557 has a YOUR NOTES lane - read his notes there at start. Old DONE cards MOVED (operator 'Yes, archive them'; nothing deleted) into the 'DONE archive (S371)' frame https://miro.com/app/board/uXjVEV03QWA=/?moveToWidget=3458764689221523342 (text in ops/research/MIRO_DONE_ARCHIVE_S371.md); each DONE column keeps 5. Stale cards left in place: P1 NOW three Goose cards, P2 NOW 'Agent run in flight', P3 NOW Cursor pictures + NEXT 'Waits on your answer'.
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

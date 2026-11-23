# S544 handover (written 2026-11-23 ~22:40, end of S543 - Fable)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Digest: ops/research/S543_DIGEST.md.

## METHOD lines - quote all of them in your first message
- ORDER (owner S542: "restyling isnot important i want to finish with all pending mechanics then focus on the 3d and
  menus"): pending mechanics first, THEN 3D and menus. No look / restyle question to him until then. Ask before launching a
  new animation item (PICSFIX1 below is his own "Yes, fix them now").
- TELLS FIRST (S543 TURNPROBE18, checked in code): a plan line the player writes against an opponent's tell adds about 1
  point over the coach's plan, because a tell does not change how the opponent fights. No new design round whose central
  idea is "the player answers the tell" (turning pro's matchup rule, scouting the opponent's file, the push switch's
  openings) until TELLPLAY1 is measured: `ops/research/TELLPLAY_SCOPE_S543.md`.
- CARD GAME, REAL FIGHT FIRST (owner S543: "very quickly drafted without any attention to how a a real fight is done"):
  no round 9 feature, screen or balance work until the real sequences are researched and every card is audited against
  them: `ops/research/CARDREAL_SCOPE_S543.md`. Each new or changed move names the real sequence it follows.
- MECHANICS NEED 8 (owner S534): 8+ DEPTH and 8+ PLAY from two fresh critics, after the probe; under 8 -> his cut-or-keep.
- DEPTH IS MEASURED, FUN IS HIS PLAY (owner S543: "depth can be judged and compared , i will play to judge the fun").
- FREE HAND (owner S534): remove / add / interconnect to reach 8, then report.
- A DESIGN PAGE GOES TO A CODE-CHECKED CRITIC FIRST (S543: the depth-prices page had five wrong code claims and both its
  probes had passed by construction; the code-checked critic found it in six minutes).
- RUN THE FULL SIZE BEFORE A VERDICT. FEEDBACK LOOPS in every design/probe brief (claude_cm.ps1 refuses without).
- AGENTS ONLY IN THE CONSOLE (owner S541): `mcp__terminal__run_in_terminal` with `powershell -NoProfile -ExecutionPolicy
  Bypass -File ops\Tools\claude_cm.ps1 --model <model> --permission-mode auto "<brief>"`. At most 3 at once.
- A DESIGN THAT KEEPS FAILING: interview the owner on the dilemma (grilling skill) before another round.
- HIS GAME FIRST (S537): ArcheAge running -> no new jobs on AMBER/RED memory. At handover the watchdog was RED (memory
  93%, ArcheAge open): nothing could be launched and no build was exported.
- FIGHT ANIMATION: v2 only, no new correction layer. Board questions 20 words max. Commit by pathspec.

## FIRST: collect the three workers (console tabs c4, c5, c6 of the S543 desktop session; read results from the files)
1. TELLPLAY1 (tab c4) -> `docs/TELLPLAY1_RESULT.md`. Brief `ops/research/TASK_TELLPLAY1.md`, seven bars. PASS -> two critics,
   one code-checked FIRST; FAIL -> the one change. It unblocks turning pro's matchup rule and the commands' baits.
2. TURNPROBUILD17 (tab c5) -> branch `build/turnpro17`, worktree `E:\FightCamp\wt\TURNPROBUILD17`,
   `docs/TURNPROBUILD17_RESULT.md` there. The owner: "Yes, build v17 now". Merge by DIFF onto main (read the deleted and
   rewritten tests list first), run the tests it names, open its four stills, export, WHAT_TO_TRY, he plays.
   Step 1 is on main: `scripts/rules/ProStart.gd` + `tests/pro_start_test.gd`.
3. COACHDEEP8 (tab c6) -> `docs/COACHDEEP8_RESULT.md`. v7 failed 4 of 7 each by one cell; v8 = its three named changes.
   PASS -> the worker queues Kalli and Dola; launch a code-checked critic. Then build step 1 of his order (cut the
   class-or-pads rule in `scripts/rules/CoachRoles.gd`). Carry the finding: `BoutRead.chance` ignores the corner coach.

## SECOND: launch what is briefed and waiting for a slot (watchdog not RED)
- PICSFIX1 (`ops/research/TASK_PICSFIX1.md`): the owner's "Yes, fix them now" on the two fight-picture defects. FIRST free slot.
- CORNERCMD1 (`ops/research/TASK_CORNERCMD1.md`): the corner commands, map + probe. The spec is
  `ops/research/PUSH_KNOW_INTERVIEW_S543.md` (THE SPEC, 12 points). He was asked to confirm the spec before the probe
  launches and had not answered at handover: ask once, then launch.
- EXPORT: `sh tools/export.sh` was NOT run in S543 (watchdog RED). On main and not yet in a build: the fight-week load
  cut, the fight-week tank fix, the rank test fix. `docs/WHAT_TO_TRY.txt` has the S543 section ready.

## THIRD: seat answers and the card game
- SQ316 Kalli, SQ317 Dola on `CRITIC_DEPTHPRICE1_BRIEF.md`: sent before the code check; the page was wrong (see its
  correction note). Read them for ideas on the sponsorship budget only.
- SQ318 John, `CARDREAL1_JOHN_BRIEF.md` (the real sequences, boxer against jiu-jitsu fighter): check his sources, then
  phase 2 of `CARDREAL_SCOPE_S543.md` (the card-by-card audit, a console worker). `CARD_R8_OWNER_PLAY_S543.md` holds his
  words and the seven screen fixes that come AFTER the real-fight work.

## Then, in his order (mechanics first)
- KNOWBUILD1: build step 1 of knowledge v9 (the signing card: ranges, two dates, three calls; each trial evening the
  player picks tomorrow's question; no "sign short") - his K1-K4 answers in the interview file. After the v17 build.
- DEPTH1: sponsorship as ONE budget split across the boxers (the code-checked critic's proposal,
  `DESIGN_DEPTHPRICE1_CRITIC_OPUS.md` section 3); the loan's timing. The fight-week load is CUT (Q-324).
- PROGBUILD1 (a better pads coach: rides on coaches v8). Then 3D and menus.
- Nightly reds left for the main session: `palette_guard_test` (FightPictures.gd, 11 raw colours: in PICSFIX1),
  `move_tip_test` (animation, held), `plan_templates_test` + `matchmaking_bots_test` (NIGHTREDS1, queued for grok).

## Waiting on the owner
- His confirmation of the 12-point corner commands spec.
- About a dozen finished worker processes hold ~3.5 GB (he closes the tabs; never Stop-Process without his yes; never
  the three running tabs c4, c5, c6).

## Model for S544
Opus 5.5, medium effort, Fast off: three collections, one merge by diff and two launches; Opus workers for the probes.

# S543 handover (written 2026-11-23 ~21:20, end of S542 - Fable)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Digest: ops/research/S542_DIGEST.md.

## METHOD lines - quote all of them in your first message
- ORDER (owner S542: "restyling isnot important i want to finish with all pending mechanics then focus on the 3d and
  menus"): pending mechanics first (turning pro, coaches, knowledge, depth, push switch, progression), THEN 3D and menus.
  No look / restyle / mockup-pick question to him until then. Ask before launching a new animation item.
- MECHANICS NEED 8 (owner S534): 8+ DEPTH and 8+ PLAY from two fresh critics, after the probe; under 8 -> his cut-or-keep.
- FREE HAND (owner S534): remove / add / interconnect to reach 8, then report.
- JUDGED BY PLAY (his turning pro and coach interviews): bots only check nothing is broken; depth and fun = his play + two
  critics at 8.
- RUN THE FULL SIZE BEFORE A VERDICT (S542: a 300-career check read a 2,000-career pass as a fail).
- AGENTS ONLY IN THE CONSOLE (owner S541): every worker = `mcp__terminal__run_in_terminal` with `powershell -NoProfile
  -ExecutionPolicy Bypass -File ops\Tools\claude_cm.ps1 --model <model> --permission-mode auto "<brief>"`.
- FEEDBACK LOOPS (owner S541): every design/probe brief has `## Feedback loops`; claude_cm.ps1 refuses without it.
- A DESIGN THAT KEEPS FAILING: interview the owner on the dilemma (grilling skill) before another round.
- HIS GAME FIRST (S537): ArcheAge running -> no new jobs on AMBER/RED memory.
- CARD GAME: free seats write the code (Arena), Claude coordinates and PLAYS EACH ROUND BY HAND FIRST (`preview_start
  name=cardgame`, port 8799); his play opens each next round.
- FIGHT ANIMATION: v2 only, no new correction layer. Board questions 20 words max. Commit by pathspec.

## FIRST: collect COACHDEEP7 (running at handover)
Opus worker, console tab c4 of the S542 desktop session (not in your terminal panel: read its last message from the newest
`*.jsonl` in `~/.claude/projects/E--FightCamp-Lean/`, or `docs/COACHDEEP7_RESULT.md` once committed). Brief
`ops/research/TASK_COACHDEEP7.md`; spec `ops/research/COACH_INTERVIEW_S542.md` (17 owner answers). PASS -> the worker queues
Kalli and Dola; launch a code-checked critic too. FAIL -> the one change it names; if it needs the owner, ask him.
After two 8s: build step 1 of his order (cut the class-or-pads rule in `scripts/rules/CoachRoles.gd`), export, he plays.

## SECOND: turning pro v18 (one round)
v17: his Q-320 "Yes, build it"; probe PASS 6/6 at risky purse x1.75 (`docs/TURNPROBE17_RESULT.md`, S542 addendum on top);
critics Kalli 5/6/6 (`CRITIC_TURNPRO1_V17_BRIEF_KALLI.md`), Dola 8/9/9 (`..._DOLA.md`). Both lists point the same way:
1. Let the MATCHUP decide, not the price: each of the two cards shows the opponent's style and one tell; a plan line
   against the tell moves the chance (inside what plan grading allows).
2. The NAME pays after fight 6: it sets where the normal booking starts (ProLadder).
3. Keep his two bars, but wire them to who the boxer is: the signing card's ambition scales hunger; the existing
   confidence trait scales the knockout hit. Show confidence's math on the card ("Confidence: +3% -> 83%").
4. "Not yet" gets a reason: print what four more weeks gives (TrainingPreview.plan_gain into DebutRead.card); hold the
   offer through a nationals run.
5. Hunger felt in the ring at the ends (a flat boxer, a hungry one), inside the shared 5-point cap.
6. Kalli's code items 5-9 (the game's words TUNE-UP / STEP UP; the decline path; the hunger clock; no step-up name fits).
Write TASK_TURNPRO18 (map + full-size probe, Feedback loops, the same six bars + "the reader's edge is 8% or more"), launch
in a console tab, then the same two critics + a code-checked one. Tell the owner the two bars stay his.

## Waiting on the owner
- Card round 8 play at http://127.0.0.1:8799/ (start as the boxer) -> round 9 on Arena from
  `ops/research/CARD_R8_CLAUDE_PLAY_S542.md` + cards as data and pictures.
- Knowledge v9 (Kalli 7/8/7, Dola 8/7/7): offer the interview again before a v10.
- Four finished S541 worker processes still open (~1.4 GB): he closes the tabs, or allows Stop-Process.

## Then, in his order (mechanics first)
DEPTH1, PUSHTANK1 (greybox probe), PROGBUILD1. 3D and menus after: wire the body cross into the fight, ONELOOK1, restyle.

## Model for S543
Opus 5.5, medium effort, Fast off: collecting two design rounds and writing one brief; Opus workers for the probes.

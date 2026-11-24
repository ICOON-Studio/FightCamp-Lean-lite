# S545 handover (written 2026-11-24 about 02:00, end of S544 - Fable)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Digest: ops/research/S544_DIGEST.md.

## METHOD lines - quote all of them in your first message
- A DECISION SCREEN IS A SCENE, AND A CLICK SHOWS WHAT CHANGED (owner S544: "looks like spreadheet you need to use art
  you are an experienced AAA game designer"; "i click turn pro now , i expect to see what changed , bring up the players
  profile show me what is new"). A decision screen = a picture of the moment + the choices as cards with a painting and
  at most four plain facts; never rows of key/value as the main content. After a decision button, the player lands where
  the change lives, sees before -> after with NEW marked, and one pulsing next action. Pattern to reuse:
  `scripts/ui/ProScene.gd`, `modals/ProOffer.gd`, `modals/ProNews.gd`, `WhatsNew.gd`, `ProBars.mark`.
- NOTHING CUT BY THE SCREEN (owner S544: "why half the screen isout of bounds"). Before a screen change is merged or
  exported: `tools/jump_snapshot.gd` on the hidden desktop with `--log` (BOUNDS lines; headless sizes are wrong), and
  open the real picture. A worker's stills are checked for both of these lines before the merge.
- ORDER (owner S542): pending mechanics first, THEN 3D and menus. His own play notes on a screen are fixed at once.
- NO DESIGN ROUND ON A PLAN LINE THE PLAYER ADDS until PLANWORTH1 is measured (TELLPLAY1 FAIL: under 1 point in the
  ring; `ops/research/TELLPLAY_SCOPE_S543.md`). Judge on real bouts (`BoutNight.play_out`), never on the read alone.
- A WORKER'S NUMBERS CAN BE RIGHT AND ITS WHY WRONG: open the code lines a "why" stands on before it becomes a question
  to the owner.
- CARD GAME, REAL FIGHT FIRST: each new or changed move names the audit row it follows (`ops/research/CARDREAL_AUDIT.md`).
- MECHANICS NEED 8 (owner S534), probe first, then a code-checked critic, then the chat critics. DEPTH is measured, FUN
  is his play. FREE HAND to remove / add / interconnect, then report.
- A DESIGN THAT KEEPS FAILING gets a stop rule in its brief (COACHDEEP9) or an interview with him.
- AGENTS ONLY IN THE CONSOLE: `mcp__terminal__run_in_terminal` with `powershell -NoProfile -ExecutionPolicy Bypass -File
  ops\Tools\claude_cm.ps1 --model claude-opus-5-5 --permission-mode auto "<brief>"`. At most 3 at once.
- HIS GAME FIRST: ArcheAge running + memory AMBER = two Godot slots; my renders and tests queue behind the probes.
- FIGHT ANIMATION: v2 only, no new correction layer. Board questions 20 words max. Commit by pathspec.

## FIRST: collect what is running (read the result files; the tabs belong to the S544 desktop session)
1. CORNERCMD1 (tab c3; owner "yes start the probe", Q-325) -> `docs/CORNERCMD1_RESULT.md`. Step 0 measures today's eight
   calls on real bouts; then nine bars. PASS -> the worker queues Kalli and Dola; launch a code-checked critic FIRST.
   FAIL -> which bar and the one change, to him (it is his design).
2. PLANWORTH1 (tab c4) -> `docs/PLANWORTH1_RESULT.md`: question 1 (does one written line switch the coach's plan off?)
   then six findings bars. Take the numbers to the owner in plain words: (a) designing the plan pays, (b) it pays but the
   tape adds nothing, (c) it barely beats the coach's. Only then a design question.
3. Arena CARDROUND9 (chat 01a20a6d-3a1b-79dc-a475-e858f591a0d9, branch arena/f591a0d9-fightcamp-lean-lite): its PR
   relays from the lite mirror. Read the CI log yourself, `ci_arena.py guard`, apply the diff. Then PLAY BOTH ARTS BY HAND
   and write down each move that does not look like a fight, before the owner is asked.
4. Seat answers (ARRIVED at the end of S544, filed UNREAD): Kalli scored the paper model real 6, depth 5, play 6
   (the knockdown is missing, and the punches a fan expects). Read both critics, take their changes into a round 9b for
   Arena BEFORE the owner is asked to play. SQ320 Dola, SQ321 Kalli (`CRITIC_CARDREAL_BRIEF.md`: the paper model; their 10/10 first screens are
   the input for card round 10, the screen); SQ319 John (`CARDREAL2_JOHN_BRIEF.md`: judo, wrestling, sambo, karate -
   check sources, then the same audit for those arts).

## SECOND: launch
- COACHDEEP9 (`ops/research/TASK_COACHDEEP9.md`): first free worker slot. Its STOP RULE is the coordinator's to apply:
  a forced moment that fails bar 3 again is cut as a player decision; no v10.

## THIRD: his play
- The S544 build (second export) is in `Builds/`. `docs/WHAT_TO_TRY.txt` leads with six points (A-F). Board buttons:
  Pro: the call / safe or risky / rival gym calls / hunger gone. His play notes are fixed the same session.
- Shown to him as pictures: `docs/playtest/s544_turnpro/` (the call, the rival call, a pro from today, not yet, the
  profile, Mail in the office); on 8787/review: v17's first screens and the fight pictures' contact sheets.

## Then, in his order (mechanics first)
- KNOWBUILD1: step 1 of knowledge v9 (the signing card) - as a SCENE (the METHOD line), with what changed after signing.
- DEPTH1: sponsorship as one budget split across the boxers; the loan's timing.
- PROGBUILD1 (rides on coaches). Then 3D and menus; the map holds "3D fight: staged exchanges (E33)" for that phase.
- Apply the scene + what-changed pattern to the other decision pop-ups as they are touched (bout offer, weigh-in miss,
  the club show booking, the hire): not a restyle sweep, one screen when its mechanic is worked on.
- Known gaps: a blocked body punch is caught at chest height in the pictures (no elbow-down block clip); the nightly
  reds `plan_templates_test` and `matchmaking_bots_test` (NIGHTREDS1, no seat took it).

## Waiting on the owner
- His play of the S544 build. Nothing else.
- Finished worker tabs from S543 and S544 hold memory (he closes tabs; never Stop-Process without his yes).

## Model for S545
Opus 5.5, medium effort, Fast off: collections, one launch, and his play notes; Fable for a design conversation if
PLANWORTH1 says the plan barely beats the coach's.

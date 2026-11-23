# S542 handover (written 2026-11-23 ~18:30, end of S541 - Opus)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Digest: ops/research/S541_DIGEST.md.

## METHOD lines - quote all of them in your first message
- MECHANICS NEED 8 (owner S534): 8+ DEPTH and 8+ PLAY from two fresh critics, after the probe; under 8 -> his cut-or-keep.
- FREE HAND (owner S534): remove / add / interconnect to reach 8, then report.
- AGENTS ONLY IN THE CONSOLE (owner S541 "Yes, block them"): settings deny Agent + start_session. Every worker =
  `mcp__terminal__run_in_terminal` with `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\claude_cm.ps1 --model
  <model> --permission-mode auto "<brief>"`. Fable is available (fresh reset): design/animation; Opus probes/builds.
- FEEDBACK LOOPS (owner S541 "Yes, add it"): every design/probe brief has `## Feedback loops` (what it feeds, feeds back?,
  cap, one-rep trial first); claude_cm.ps1 refuses the launch without it.
- A DESIGN THAT KEEPS FAILING: interview the owner on the dilemma (grilling skill) before another round.
- HIS GAME FIRST (S537): ArcheAge running -> no new jobs on AMBER/RED memory.
- CARD GAME: plan SIGNED (S541). Free seats write the code (Arena), Claude coordinates; his play opens each next round.
- FIGHT ANIMATION: v2 only, no new correction layer. Board questions 20 words max. Commit by pathspec, collect paths with
  `git diff --name-only --no-renames`.

## FIRST: turning pro v17 design WITH the owner (his words: "we continue with the design on the next session")
The spec is `ops/research/TURNPRO_INTERVIEW_S541.md` (15 answers, all yes). He stopped the v17 brief to do the design with
him: walk him through the rules with numbers (patience, the two "not yet"s, the rival-gym moment, safe v risky offers for
fights 1-6, confidence and hunger bars, what is cut from today's code), get his yes, THEN write TASK_TURNPRO17 (design +
greybox probe, Feedback loops section, bars: no habit best in more than 6 of 10 boxer types, the reader beats every habit in
5+ of 10) and launch it in a console tab. Read Roster.gd check_pro, ProCall.gd, ProLean.gd before talking numbers.

## Running at handover - collect when they land
1. CARDROUND8 (Arena, arena/1f620be9-fightcamp-lean-lite; chat https://arena.ai/agent/01a208f1-411d-7eb9-a134-f8231f620be9):
   the guide. On the PR: node --test, gate=play, serve proto/cardgame (`python -m http.server 8799` in that folder), play the
   first bout by hand with the guide on, merge by diff (`--no-renames`), close the PR, then give him http://127.0.0.1:8799/.
2. HOSTLIGHT1 (Opus, console tab): club show light night (two halls as a read + two reserves). Verify club_show_test +
   golden_path yourself, render the Club > Money row, open it.
3. COACHDEEP5 (Opus, console tab): catchment cap on the class<->members loop; PASS -> critics queued by the worker; FAIL ->
   if it cannot reach 8, his cut-or-keep.
4. Knowledge v9 critics LANDED: Kalli 7/8/7, Dola 8/7/7 - one axis under 8 each. Offer him the interview (9 rounds) before v10 (both lists) -
5. Dola restyle pages C/D LANDED (RESTYLE1C/1D_DOLA_BRIEF_DOLA.md, committed): extract the HTML, render with tools/render_mockup.py, open, put A-D on the map for his pick.

## Next, in order
6. Card round 9: cards as data + pictures (GrappleMap BJJ, boxing pairs from PICS2D2), after his r8 play.
7. A body-cross take for the 2D pictures (fight_pictures_test red on 4 pictures).
8. Export once something he can see lands.

## Model for S542
Opus 5.5, medium effort, Fast off: a design conversation with him and collecting four runs; Fable on design tabs if needed.

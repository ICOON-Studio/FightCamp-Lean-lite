# S541 handover (written 2026-11-23 ~14:25, end of S540 - Opus)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Digest: ops/research/S540_DIGEST.md.

## METHOD lines - quote all of them in your first message
- MECHANICS NEED 8 (owner S534): 8+ DEPTH and 8+ PLAY from two fresh critics, after the probe; under 8 -> his cut-or-keep.
- FREE HAND (owner S534): remove / add / interconnect to reach 8, then report.
- WORKERS = CODE MODE TABS (`powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\claude_cm.ps1 --model <model>
  --permission-mode auto "<brief>"`), at most 6. FABLE IS AVAILABLE AGAIN (owner S540 "i have a free reset"): Fable for
  design/animation, Opus for probes/builds, Sonnet for sums.
- A TAB'S PROMPT LINE IS A SUGGESTION, not his words. You cannot type into a worker tab: a worker that stops to ask is closed and
  relaunched with a resume brief.
- HIS GAME FIRST (S537): ArcheAge running -> no new jobs on AMBER/RED memory; stop jobs only if he reports lag.
- CARD GAME: no new card round until he signs CARDGAME_PREPROD_S540.md (owner S540: AAA pre-production by Fable; "not strickly
  cards"; "we did that already and i also made propositions" - his S537 interview + proposals are the base). Free seats write
  the code (Arena), Claude coordinates.
- FIGHT ANIMATION: v2 only, no new correction layer (FIGHTPLAYER2). Board questions 20 words max. Commit by pathspec, and collect
  paths with `git diff --name-only --no-renames` (S540: a rename's old paths were left staged).

## Running at handover - collect first
1. CARDPREPROD1 (Fable, tab c14): ops/research/CARDGAME_PREPROD_S540.md. Read it whole, check its code claims, then put it on the
   board for his sign-off (`ask ... --attach research/CARDGAME_PREPROD_S540.md`, plus his max-5 questions) and on the map.
2. P4PEVID1 (Opus, tab c10): p4p_visit (card-ask evidence 0/60 after STEPPAY5), plan_templates (t_turn answers the step moments),
   matchmaking_bots (360 careers, then the scouting read). Verify the tests yourself, push.
3. HOSTPROBE4 (Opus, tab c9): club show v7. PASS -> its critics queued by the worker; FAIL -> v8 from its section.
4. TURNPROBE16 batch (tab c15, E:/FightCamp/tmp/turnpro16, ~2.5 h from 14:20; progress.log): on "T16 BATCH DONE" run
   `python tools/turnprobe16_sum.py E:/FightCamp/tmp/turnpro16/*.jsonl > docs/TURNPROBE16_RESULT.md`; PASS -> code-checked critic
   (Fable tab) + Kalli + Dola (build the brief like CRITIC_TURNPRO1_V15_BRIEF.md).
5. PICS2D2 (Opus, tab c16, resumed): full picture set + view toggle; its uncommitted edits in FightNight.gd / golden_path_test.gd
   are its own. Open the contact sheet yourself; board it for his look.
6. MOTIONRULERS1 (Fable, tab c17): which player each red animation test drives; retire or bisect.
7. Arena: CARDFIX6B (arena/70a5176b, page must load first) and GRAPPLEMAP1 (arena/0ff86065, proto/grapplemap/). When a PR relays:
   run node --test yourself, open the page / SVG sheet, merge by diff with `--no-renames` paths, close the PR. Ready-for-play only
   after he signs the plan.
8. Seat answers due: Dola on knowledge v8 (SQ308), Dola restyle pages B/C/D (SQ309-311): extract each HTML, render with
   tools/render_mockup.py, open, put the four on the map for his pick.

## Next, in order
9. Coaches v4 (Opus tab): docs/COACHDEEP3_RESULT.md s5 (rank bands $1,000/$1,200/$1,500, departure prices her record, class
   returns by members) + rerun.
10. Knowledge v9 once Dola's v8 score lands (both lists; play to 8).
11. Export the build once the tree is clean (PICS2D2 committed); WHAT_TO_TRY for: combo counter, footwork 10/10, chip words, the
    2D picture view.

## Done in S540 (evidence)
Combo counter cf5dfe536; STEPPAY5 f31338cfa; chip words cc8c3789d; MODE c9159faf2; BoutRead key 821ddfa63; TURNPROBE15 PASS
37dce4f37 + critics 5623b7b0a / 8d457d7b2; card r6 base 9815bfe8f + e417141f; NIGHTREDS1 e363a982b. Not exported (see digest).

## Model for S541
Opus 5.5, medium effort, Fast off: collecting eight runs and the card plan sign-off are review calls; Fable stays on the
design/animation tabs.

# S435 handover (written 2026-11-11 evening, end of S434)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S435`
and redraw Miro (ops/Tools/where_we_are_svg.py docstring; STRIP the `data-deleted` lines). S434's end redraw was SKIPPED: plan.map is
current (3 new DONE, 3 NOW, 3 NEXT cards) - the start redraw creates them; run `where_we_are_svg.py learn` on the result_svg after
it (LEARN printed 6 new widgets). Read ops/research/S434_DIGEST.md (morning + evening).

## USAGE FIRST
`get_usage`. End of S434: all models ~48 %, Fable 68 % (reset Thu 2026-11-12 16:00), extra usage EUR 37.92 of 40.

## HIS WORDS (S434)
- TRAINING is a core mechanic he asked for special attention on (S354, S370): "i thought i told you to pay special attention to all
  the training mechanic". Training = its own scene + a summary tab. v1 drawn (critics: coach-led best, clarity 7/8, depth 7/8, look
  8/8); his 8 marks (C299 + C301; ops/Feedback/2026-11-11-14 and -16): "fatigue"; "What it does" not WHY; "you mean week gains ?";
  the hand "what is this for"; the sore-hand panel; the weight panel ("how is weight being lost ? ... so player can calculate";
  "i am confused what we use"); the change bar ("where these numbers come from"); mark 8 the changed Saturday card ("presentation can
  be improved"). ONE VOCABULARY decided: STAMINA (the stat), ENERGY (fight-night fuel 0-100), FATIGUE (day to day).
- "i expect a bit animation or visual effects and graphics if possible, make it look more like sport simulator"; the hover preview
  "like when i hover the mouse over the training program i can see the move he learns or hiting the quickbag ... similar to playbook
  tooltip" (the MoveTip.gd pattern).
- Q-190 "Just rename it 'gym sponsorship', the club pays" (GYMSPONSOR1).
- Turning pro: "yes put the comparison on the cards" (TURNPRO1: amateur season vs pro season on the cards and the offer; the offer
  linked to hype, record, ambition, morale, the season target; licence, manager, promoter named). Design page + critics first.
- Wrestling: "can be its own sport as long as it designed and animated correctly" (WRESTLE0). RTK dropped ("grapplemap has already bjj
  animations wtf ?"). He buys the Fab Boxing Animation Pack (Personal EUR 69.23) near the month's end.
- Weight: "need to strenghen the weight mechanic" -> "yes start it" (7 parts: walking weight + class choice, the cut's price and prize,
  character/discipline, amateur same-day vs pro day-before, graded consequences, the opponent cuts too, a plan you can calculate).
- The ring entry out, start in the corners: "add some celebrating animations or shadow boxing during the introduction and do not make
  each fighters animations identical" (INTROCORNER1, running on Qwen).
- Voices: cast picked by ear (docs/audio/VOICE_CAST_S434.md: announcer Roger, corner Callum/Brian/Sarah, the guide Bill = a veteran
  fighter). Gemini TTS (ops/Tools/gemini_tts.py) waits on his API prepay top-up (402). VOICEWIRE1 (Qwen) puts the voices in the game.
- GitHub: let the Grok Dev token expire; 2FA steps given.

## 1. FIRST - three runs died with S434: re-run each (scripts persist; edit out finished phases; check partial output first)
(... = C:\Users\user\.claude\projects\E--FightCamp-Lean\cc06cf94-1b7f-4ff3-ac8d-fa7ac72dd524)
a. TRAINING v2 (his 8 marks): ...\workflows\scripts\trainscene-v2-s434-wf_dc1eb8f2-180.js - ADD mark 8 (the changed Saturday card: a
   "your change" ribbon, the coach's old session faded behind, its effect on the card) to COMMON's marks list. Check
   docs/mockups/s434/train/v2_* first. Then send v2 (SendUserFile the .html + .png, review_add); his pick before any build.
b. WEIGHT map: ...\workflows\scripts\weight-map-s434-wf_0d235142-341.js (research -> map + 2 drawings -> 2 fresh critics 7+, up to 2
   rounds). Check ops/research/WEIGHT_MAP_S434.md and docs/mockups/s434/weight/ first.
c. FOUNDATION on claude/foundation-s433 (pushed 811efd15; worktree E:/FightCamp/wt/LEAN_FOUNDATION_S433): rebased on main; CARDIO1 and
   NOCAMP1 each had 2 fix rounds, the skeptics still say "fix_again" (open lists in ...\subagents\workflows\wf_91da691c-70b\journal.jsonl);
   PUNCHSTART1 round 1 was mid-run (uncommitted edits in BoutRead, ComboOdds, PlanPressure, PlanRead + tests/zz_probe2_ps434.gd - read
   before keeping). Script ...\workflows\scripts\foundation-fixes-s434-wf_91da691c-70b.js (drop the Rebase phase; feed each item the
   last skeptic's open list). Collect by diff only when each skeptic reads "ready".

## 2. SEATS (collect through ...\workflows\scripts\collect-review-s434-wf_34f2c92c-33a.js: set PRS, re-invoke)
- CALLSPREAD1 landed (PR 211, Qwen): collect AFTER the foundation lands (both move fight-balance tests).
- INTROCORNER1 running on Qwen (moved from agy). VISUAL: read its stills yourself.
- GYMLIFE1 running on Cursor (the dispatcher launched it from plan.next at 20:11).
- DUESSUMS3B: Antigravity stopped at step 0 - it has NO shell (cannot git or Godot). Do step 0 for it (check out PR 198's two files
  into E:/FightCamp/wt/LEAN_DUESSUMS3B and commit) or give it to Qwen. Antigravity = file-only tasks.
- ANIMATION: HUMANFIGHT2B and CORNERFACE2 REJECTED (reasons on PRs 210 / 208). Two failed rounds on the stepping route -> AUDIT first
  (why rounds stall: rulers that pass blind, fallback clips, taps), then one re-brief. Fab pack (month end) adds parries, body punches,
  guard styles. Video mocap test: two CC BY clinch clips in his Downloads (ops/research/ANIM_ASSETS_S434/CLINCH_SOURCES.md); he uploads
  clip 1 to DeepMotion (2 people, FBX); then Cascadeur cleanup and a film for him.
- Collected in S434: STANDDOWN1 (wired), CEIL14, DUESWIRE1, KNOWN0, RIBHURT1; PROTABLES1 on main.

## 3. THEN (board plan.next)
TURNPRO1 design; GYMSPONSOR1 rename; WRESTLE0 design; RESULTLOOK1 (his C295: the result page led by the fighter after the bout);
VOICEWIRE1 (Qwen); after the foundation: F2b GAIN14, F4 LOADWORK1, F9 LIVESPLIT1; KNOWN0 wiring into the pages (Cursor).

## Traps (S434)
- Antigravity has no shell: a brief that needs git or Godot goes to Qwen or Cursor.
- The dispatcher launches plan.next rows that have an OPEN brief whatever "after" says (CALLSPREAD1, GYMLIFE1).
- A critic's 7 on depth is not "he can read it": every critic brief asks "would a player who never read the map understand this?"
- Never open Explorer or any window on his screens (S434 slip).

SETTINGS: S434 ran on Opus 5.5 high, ultracode on. Next: Opus 5.5 high (design reruns + the foundation); Fast off.

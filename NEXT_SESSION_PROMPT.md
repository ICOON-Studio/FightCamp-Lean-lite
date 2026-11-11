# S436 handover (written 2026-11-11 late evening, end of S435)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S436`
and redraw Miro. Read ops/research/S435_DIGEST.md and ops/research/ANIM_AUDIT_S435.md (sections A and G).
TWO SESSIONS WROTE THIS FILE: S434 stayed open beside S435 and kept committing (training v2 sent, its own handover edits).
If S434 is still open at your start, its workflows may still run: check before touching their work (section 1).
MIRO: the 24 old surplus cards in "P0 Where we are" were deleted on his yes (S435) and the frame shrank back
(translate(6000,-2287), height 2210); where_we_are_miro.json is trimmed. A normal redraw works again; a new delete still needs his yes.

## USAGE FIRST
`get_usage`. S435 at 21:05: all models 53 %, Fable 69 % (reset Thu 2026-11-12 16:00), extra usage EUR 37.92 of 40.

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

## HIS WORDS (S435)
- None in chat after the start line. Board: Q-190 "Just rename it 'gym sponsorship', the club pays" - done in the four build maps.

## 1. THE S434 WORKFLOWS (they did NOT die: S434 was still open)
Folder: C:\Users\user\.claude\projects\E--FightCamp-Lean\cc06cf94-1b7f-4ff3-ac8d-fa7ac72dd524\subagents\workflows
FIRST look at the file times under each wf_ folder there and at the session's own .jsonl. Still moving = leave them, they
are S434's. Stopped = read the journal.jsonl's last entries and re-run only what did not finish (scripts in the session
folder's workflows\scripts; a Workflow run needs his word in this session, and check usage first).
a. TRAINING v2 (wf_dc1eb8f2-180): FINISHED and SENT by S434 (docs/mockups/s434/train/v2_scene.*, v2_summary.*; his 8 marks
   applied, mark 8 = the Saturday card reads "Changed"). Critics on the first v2: clarity 6 and 6 ("Normal 82% of a usual
   week's work" unclear), depth 7, look 7; the final redraw is NOT scored. RISK: denser than v1 - read his answer first;
   if he wants it lighter, move numbers into hovers. Then two fresh critics on clarity before his pick.
b. WEIGHT (wf_0d235142-341): map round 2 running at 21:24 (docs/mockups/s434/weight/: CODE.md, REAL.md, r1 drawings, a
   critic's 10). No ops/research/WEIGHT_MAP_S434.md yet.
c. FOUNDATION (wf_91da691c-70b, worktree E:/FightCamp/wt/LEAN_FOUNDATION_S433): PUNCHSTART1 fix round 2 running at 21:24;
   CARDIO1 and NOCAMP1 skeptics said "fix_again". Collect by diff only when each skeptic reads "ready".

## 2. SEATS
- GYMLIFE2 (Cursor) launched 21:11 (estimate 22:05): the shadow strip's pop, walks round the kit, nobody under a hub
  button. VISUAL: read the stills (docs/mockups/s435/gymlife2/).
- INTROCORNER2 (Qwen) queued behind INTROCORNER1's runner (still "running" its regression at 21:32). The first round did
  not compile and cut the intro to 6 s (S435 digest). Collect ONLY after tools/intro_shots.gd on the branch shows the name
  calls: `python ops/Tools/godot_slot.py run --who S436 -- python tools/hidden_desktop.py run --timeout=240 --log=<log>
  <godot.exe> --path <worktree> --windowed --resolution 1920x1080 --audio-driver Dummy --script res://tools/intro_shots.gd
  -- <out> secs=9 step=0.5`. If the runner opens a PR for qwen/introcorner1, close it with the digest's reasons.
- DUESSUMS3C (Qwen) queued after it (the DUESSUMS3B brief under a new id).
- PR 211 CALLSPREAD1: NOT collectable as is - its spread makes a wrong call cost less (exchanges_test "wrong calls lose
  clearly more", golden_path "corner call: calm"). After the foundation: collect with a fix that keeps that bar.
- Collected in S435: GYMLIFE1 (PR 212 closed). Fab pack at the month's end; the clinch mocap test waits on his DeepMotion upload.

## 3. ANIMATION (every session): D0 is Claude's own work, before any seat brief
Done: BEAT_TALLY (scripts/fight3d/BeatTally.gd; tools/human_fight_film.gd prints it); the lead uppercut's contact; SKIP /
VOID fail in head_aim and block_meet; clip_contact.gd keeps other tools' keys.
Measured: one real bout = 48 punches; 20 of the 22 that wanted a special take (miss / big / tired / step) fell back to a
plain one. head_aim reads 3 of 12 rows, block_meet 1 of 21 (the hips gap, 0.73-0.79, sits under the test's 0.80 floor
since the stepping route). Both are red on main and in the daily list now: the next nightly will show them.
NEXT, in order: (1) head_aim and block_meet hold their gap (a band around the stage's own standing gap) and read every
row; (2) restore short_m (tools/punch_reach.gd write=1) and take the re-measured contact file
(ops/research/CLIP_CONTACT_REMEASURED_S435.json) with tools/hit_gap_probe.gd before / after; (3) human_feet on the default
route; (4) a layer-order test; (5) tests/fight_bout_test.gd, the frozen real-bout ruler - `seed=` does NOT change the
bout, so it needs a second settled round (the `women` bout, or a seed that reaches the round script); (6) the corner-face
scene and ruler. THEN the seat tasks of the audit's section G: CONTACT1, POPS1, REACH1, KNEE1.

## 4. THEN (board plan.next)
TURNPRO1 design (the offer screen exists, scripts/ui/modals/ProOffer.gd; the comparison leans on fans, loyalty and the
season target, none built: a design page + critics first, critics cost money: ask), WRESTLE0, RESULTLOOK1, VOICEWIRE1 (no
brief yet), RANKSHOWUI (the result page already shows the rank tile; the Why card and the fighter page are left), KNOWN0
wiring (needs state first: no fighter carries a knowledge dict), after the foundation: F2b GAIN14, F4 LOADWORK1, F9
LIVESPLIT1. Ziva is down: start it when no Godot job runs.

## Traps (S434 + S435)
- A handover's "died" can be wrong: check file times before re-running anything.
- The 3D fight has no stage headless. Every Godot start goes through `python ops/Tools/godot_slot.py run --who <s> -- ...`;
  windowed ones through tools/hidden_desktop.py with `--log=<file>` (without it nothing the game prints is kept) and the
  exe's FULL path.
- The clock moves slower than it feels: all of S435 ran 21:00 to 21:40.
- idle_guard calls a seat idle while its runner still tests and pushes; the dispatcher refuses the launch: queue the task
  (`seat_dispatch.py queue --task <ID> --seat <seat>`). A re-run of a task needs a new id.
- A seat's green tests do not mean the game compiles: load Main.tscn (or run the real-game still tool) before a collect.
- Antigravity has no shell. The dispatcher launches plan.next rows with an OPEN brief whatever "after" says.
- A critic's 7 on depth is not "he can read it". Never open Explorer or any window on his screens.

SETTINGS: S435 ran on Fable 5.2. Next: Opus 5.5 high (ruler code in the fight scripts, collects); Fast off.

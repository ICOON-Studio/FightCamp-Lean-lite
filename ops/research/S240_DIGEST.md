# S240 digest (2026-10-17) - the office takes over: goal talk, desk PC, iso camera briefed; machine-speed hand-offs

## Operator rulings this session (verbatim)
- Board Q-S237-2: "Yes, build both" - note "no donot invent new cards, this should bedone in the office". BUILT (below).
- "burn all of this !!" (SuperGrok weekly 2% used) -> Grok Dev NIGHTLY7 (7 reds), SuperGrok Expert PROGSIGNS1.
- "ask ludo,paul for this : how about instead of the find fight button add for now the office with a desk a pc on it click the pc
  and have options dashboard finaince,leaderboards , Tournaments (book a fight here)" + "also ask if it would be better to swtich to
  2.5d isometric for the whole gym and keep 3d only for fight" -> Ludo r106/r107/r108, Paul P15/P16.
- Board Q-S239-1: "3D World + Orthographic Isometric Projection ... STRONGLY RECOMMEND ... Add all the rooms we have rdy so their
  opjects )desk PC in Office) can be accessed with unzooming gym floor a bit and and clicking it. we switch on other objects on rooms
  (rooms should still render as designed only objects can't be interacted yet) 1 at a time when mechanics enforce it" + "yes of
  course we enable whaever is necessary for this loop and make interactable". Ludo r108: "YES, AGREE FULLY".
- "yes build staright away" = when Ludo + Paul agree on a detail inside an approved feature, build and report (board only for new
  mechanics/scope/money/taste) - memory feedback_build_agreed_details_s240.
- "donot open new tabs everytime for the same website" - memory feedback_one_tab_per_site_s240.
- Scion video ("what can you learn from this ?") -> "do the rest that you suggested ... also what about qwen" + "is there anything on
  our workflow built so that is based on human speed" -> the tooling below.

## What now works (evidence on master 0017e2bd+)
- OFFICE GOAL TALK (d6e72a2b): a settled goal waits in the office; desk/chair/entering opens InterviewPanel.build_goal_talk (result,
  trust/morale now, walk-out warning < 30, next goal from two or one damage-control goal; LATER keeps him waiting). FighterGoal.goal_for /
  walk_out_warning / next_choices + damage_control. tests goal_talk_office 0 fails (3 boxers + OFF), goal_settle_floor, fighter_goal(_floor).
- MILESTONE BUBBLES (d6e72a2b, switch progression_signs): "★ MILESTONE: 80 TECHNIQUE" when a gain tick crosses a multiple of 10.
  rules/ProgressionSigns.gd (a782f85c, SuperGrok, 33/33) also holds the floor ring / idle posture / snap numbers - NOT wired yet.
- DESK PC model (6e5ec216): Ludo image -> image-to-3D, assets/models/club/office/pc_crt.glb, on the desk (gym_club.json furniture "pc",
  attachment surface, rests_on desk, y 0.88). rooms_office_physio_test passes. NOT yet seen on a game-camera still.
- PLAYLOOP4 (dbf2fcaf, Grok Dev PR #231): playable_loop_test 9/9 - CareerRoot._gym3d_key has the staff ids; + ShellChrome.refresh_top
  freed-bar SCRIPT ERROR fixed. The nightly's new red is fixed.
- FINDFIGHT1 collected (7a955e34, Cursor): FindFightPanel/Button/CountdownPill, 24/24 - to be EMBEDDED in the PC (PCHUB1), floor button dropped.
- TOOLING (Scion lessons): Tools/auto_collect.py (fast lane: new rules+test files, CI + guard + RESULT line proven in the CI log, one
  command); Tools/agent_watch.py (background in a session, exits when a run lands - PLAYLOOP4 sat landed ~45 min unseen);
  board_reconcile adds the fast-lane verdict; Tools/ludo_save_reply.js (Ask Ludo reply -> research/ludo_rx/ via the arena_rx
  receiver, verified on r108). CLAUDE.md s7 FAST LANE, s8 MACHINE-SPEED HAND-OFFS + code only to branch-pushing seats.

## Ludo / Paul
- r106 (PC hub, YES with a one-click guardrail), r107 (no 2D sprites; orthographic iso 35.264/45, 3 zooms), r108 (agrees with the
  ruling: zooms 36/16/7 m, desk click box 2.2x1.2x1.4, OFFICE PC tag 160x34, silent inactive props, inactive rooms x0.85/4200 K,
  goal talk via "GOAL REVIEW PENDING" banner over the office, CRT PC prompt). Raw: ludo_rx/LUDO_R106/107/108_raw.txt (+ R108_page).
- Paul P15: demo PC = BOUT CONTRACTS + FINANCES only; P16: agrees iso camera, would sequence after slice 4 stills (operator chose now).
- Verdict doc: LUDO_R106_R107_VERDICT_S240.md.

## In flight at handover
- LANDED, COLLECT FIRST: Grok Dev NIGHTLY7 PRs #234 (promotions_board), #235 (default_build_shows_no_real_name), #238
  (station_move_picker); Arena GOALNEXT1 PR #237 (rules already on master by Claude - run its goal_next_test against master as a BLIND
  check, keep the test if green, do not take its FighterGoal diff).
- RUNNING: ISOCAM1 (Cursor #232: iso camera + live objects + OFFICE PC tag), PCHUB1 (Cursor #233: PC screen 2 tabs), FINLEDGER1
  (Qwen #236: FinanceLedger - first fast-lane candidate), FIGHTBOARD1 (Arena chat 9abee363, "orchestrating" since 12:25 - likely
  stalled), NIGHTLY7 rest (Grok Dev).

## Traps
- PowerShell 5.1 `Get-Content -Raw` reads ANSI: rewriting a UTF-8 .gd with it garbles every non-ASCII char (↑ ★ —). Edit with the
  Edit tool or Python (encoding utf-8); Tools-free repair: scratchpad fix_mojibake.py approach (cp1252 bytes -> utf-8).
- Commit messages with quotes: never PowerShell here-string args to git; use `git commit -F -` from Bash or a file.
- gym_club.json furniture "on" is the LOADER'S int index key (stacks on that prop's AABB top) - use "rests_on" for meaning only.
- grok.com page text drops code indentation - code goes only to branch-pushing seats.

## HANDOFF
- Working commit: 0017e2bd (+ this digest). Pushed.
- Next action: roadmap now.next_action.
- Awaiting operator: nothing (Q-S239-1 answered; stills of the office PC + iso camera will need his OK when they exist).

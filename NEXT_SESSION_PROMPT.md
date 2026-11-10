# S421 handover (written 2026-11-10, S421 main session)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S422` and redraw the map (recipe: ops/Tools/where_we_are_svg.py docstring).
Older handovers: S420's is in git (92404f23), S396 to S417 in ops/research/HANDOVERS_S349_S417.md.

## FIRST: the PC crash (11:12) and what died with it
- Blue screen, bugcheck D1 (DRIVER_IRQL_NOT_LESS_OR_EQUAL) in amdkmdag.sys (AMD Radeon RX 6800 XT driver 32.0.21045.16010,
  16 Oct), amdfendr and dxgkrnl on the stack: read from C:/Windows/Minidump/111026-14546-01.dmp by parsing its driver list
  (no debugger installed; the parser is easy to redo: TRIAGE_DUMP at 0x2000, driver entries 0x90 apart). It came about a
  minute after heat_governor.ps1 SUSPENDED a windowed Godot render (cut_pages_still on the hidden desktop) mid-frame. Fixed:
  the governor never suspends --windowed / --write-movie jobs now (restarted via its task). If it happens again with no
  suspended render: an AMD driver update is his call (memory: PC freezes = AMD GPU driver, S287).
- FIGHTSLIDE2 (Qwen) had FINISHED and committed a08047c6; the crash killed the runner before the push. Claude pushed
  qwen/fightslide2 by hand: NO PR, collect by diff. Its finding: the captured rk_ clips (rk_jab, rk_cross) carry the body by
  their own hip travel while the feet do not step. Its ruler changed (a planted foot = local stillness, not world speed):
  prove it red on main before trusting the table.
- LOOKSLATE6 (World on slate) collected after the crash (files checked whole, tests green, Rankings rendered).
- LEGTREMBLE2: Antigravity's account stopped ("AI credits balance is too low"); PR 160 closed (did not compile). The job is
  LEGTREMBLE3 on Cursor and KDFIX2 on Qwen were LAUNCHED at 11:20 (after the crash): collect them when they land.
- John's dues research is queued (SQ31, ops/research/J_DUES_CHOICE_S421_BRIEF.md): premium dues always earn most
  ($45 x 0.85 > $35 > $25 x 1.15), so the dues choice is fake; his answer -> a proposal on the board.
- The board's animations page now says the game has all 169 clips and lists only the verified one (his S379 rule).

## FIRST: his answers on the board
- Q-S294-170 NEW: the fight display, one drawing (docs/mockups/s421/fight_display.png, notes on hints 1, 5, 9) and Ludo's paint
  (fight_display_painted_ludo.png). On yes: the two briefs of ops/research/FIGHT_DISPLAY_DECISION_S419.md section 6 (the panels to
  Cursor; the motion module, events in, effects out). Section 7 is the data check: hint 9 forecasts energy + fit only, the place
  arrows are cut; hint 5's habit is the opponent's `mode` (rec["habit"] is OUR boxer's habit: never wire the chip to it).
- Q-169 Training A or B (board said A, chat said B), Q-165 At a glance, Q-167 Club People, Q-166 Training B painted: still open.

## Collected S421 (on main, exported, HE HAS NOT PLAYED IT; WHAT_TO_TRY has an S421 section)
- LOOKSLATE7 (Cursor, PR 158): roster cards, pad cards, Overview buttons on slate. Fixed at collect: the weight chip clipped
  "0.9 kg over" -> "+0.9 kg" (tooltip keeps the words). 6 px more inside the Overview frame ran the page past 1920: 22 stays.
- R11C (goose/issue-149): fight_why_counts_test joins tools/run_tests.sh (roster_slate_test too).
- PR 105 MENUPLAYBOOK1 CLOSED unmerged: 259 commits behind, conflicts in GamePlan.gd and Playbook.gd, the old warm look. The Playbook
  goes through the "Playbook + fight night: concepts" row. Branch kept.
- Seen defects fixed: (1) the stylised portraits (assets/ui/style_b/portraits) were on a near-black backdrop, so dark faces vanished
  on slate (Luke Reid): tools/portrait_backdrop.py keyed all 23 onto the S387 studio slate; (2) Club People's bare roster-places icon
  -> a tile "2 / 3 roster places" on the role cards' dark bed; (3) the bout offer is VersusPanel.build, not TapeVersus (that is fight
  night): OFFER_FOOT 72 keeps the corner notes off the boots.

## Running / queued (superseded by the crash section above)
- (was) AGY LEGTREMBLE2. Collect: the test must load the SHIPPED .res, red on
  main's clips; then re-render the board films (clip_orbit) and LOOK.
- CURSOR LOOKSLATE6 (World on slate, 10:34). QWEN FIGHTSLIDE2 (causes switched off one by one, 10:41).
- QWEN KDFIX2 queued (round 2 of KDFIX1, PR 159 closed): round 1's test read get_bone_global_pose from the test (the pose BEFORE
  the modifiers) with the stage frozen and seeked, so it could only pass; floor and case were the same code; its GuardWeave change
  is a no-op (down clips were never in free_clips). Round 2 needs a standing control that reads the weave >= 3x the floor.

## Seen, not fixed
- The hologram groups six hit places into three ("do we only have 2 hit points"): a design question, not asked yet.
- The animation page shows 1 of 169 clips by its own rule; he read it as "only 1 animation".
- The knockdown count waits on the replay with no time limit; no case for the opponent's knockdown.
- Held worktrees LEAN_FIGHTERMODEL4G / GYM3D2 / MONEYOD2: superseded, look then retire.
- Club People's lower strip (No-gi, hire cards, members tiles) is still the old brown, not slate.

## Traps (new this session)
- Ludo `image edit` over a layout with bare figures painted photo-real bare torsos: dress every figure in a layout before a paint
  and ask for an "illustrated" body map.
- A still tool's new career has a random seed: the offer's win chance differs between renders; the game's saved seed does not.
- render_mockup.py, hidden_desktop.py: run any Godot still through `godot_slot.py run --who claude -- python tools/hidden_desktop.py ...`
  (rule_guard blocks a bare one).

SETTINGS: this session ran on Opus 5.5 | Cursor Grok 4.7 High.

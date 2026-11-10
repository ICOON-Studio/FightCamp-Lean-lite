# S421 handover (written 2026-11-10, S421 main session)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S422` and redraw the map (recipe: ops/Tools/where_we_are_svg.py docstring).
Older handovers: S420's is in git (92404f23), S396 to S417 in ops/research/HANDOVERS_S349_S417.md.

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

## Running / queued
- AGY LEGTREMBLE2 (the animation item, base agy/legtremble1, launched 10:29). Collect: the test must load the SHIPPED .res, red on
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

# S491 digest (2026-11-15)

## His words this session
- After playing S490 (handover): chip "remove that from his face"; tooltips "i have seen better from you . try harder";
  "text out of bound" ("Draw the lea"); "wtf is eye"; "bars seem to not work"; coach "terrible neck blending"; fighters'
  shoulders, walk, "you can see through them".
- Mid-session: "whenyou change to large fonts everything breaks inthe scene going out of bound"; "we need to have a
  cohesive interface /hud/ui/ux"; "DID YOU FIND THE RAM LEAK ?"

## Done (commits 00398b99, 304ac90e, d1020f21, 785ec515; pushed)
- IntentChip: a lane under each name plate (y 208), never on a body. intent_chip_test rewritten (off the face, does not
  follow the head, opponent's ends at the right edge).
- SidePanel.tag_text: plain hurt words ("Eye hurt", "Nose badly hurt", "Eye: doctor"), blank when fine. Name/plan,
  energy word/number spacing; habit card two lines.
- BodyPanels.Tank.set_range: solid fill to the low guess, paler range past it.
- Call hover: Tips house card (When / Against the opponent / Energy / Skill) + TipMeter odds bar; engine tooltips use the
  card's colours (UI theme). Tips text is built at its final size so the card is measured right (was cut at the edge).
- Text size: Settings no longer sets content_scale_factor; scripts/ui/TextScale.gd scales fonts on node_added and settles
  a one-line text back toward Medium when its box did not grow (re-checked on redraw). Headless runs stay Medium.
  TextScale.fit(control, width, px, min) for boxes that must fit; TextScale.overflow(root) = the audit.
- Audit: tools/layout_snapshot.gd and tools/fight3d_play.gd print TEXTFIT lines, `text=<0-3>`. 60 screens: Medium 3,
  Largest 64 -> 3 (playbook step buttons 80 px). fight3d_play also films a pinned call card (p06t_call_hover).
- Bug: Roster.turn_pro / RosterActs crashed with no pro offer left (found by the snapshot run) - guarded.
- Tests (all green): text_scale (new), intent_chip, side_panel, corner_bar (now in run_tests.sh), round_board, tips,
  tip_notes, truth_pass, holo_live, golden_path, file_limits, roster/pro tests. Export built.

## RAM (his question)
14 finished FightCamp sessions of 2026-11-15 with Remote Control active each kept claude.exe (~750 MB) + an idle
powershell.exe: ~12 GB. Watchdog RED at wrap-up (RAM 98%, commit 0.9 GB free; his game 8.4 GB). Asked him to archive them.

## Not done / next
- BODYLOOK1 (Ziva, TASK_BODYLOOK1.md): defects 6-7. Ziva not started (no budget; next session starts it first).
- ONELOOK1: palette Q-251, remaining fight hovers on the house card, playbook buttons, GuideBubble OFF FRAME line.
- Qwen not relaunched: watchdog RED. Collects (WHYGRADE1, ROPESCONTRACT1 #317, SQ181/182) carried to S492.

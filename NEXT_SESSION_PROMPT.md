# S492 handover (written 2026-11-15 at the end of S491)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S492`.

## FIRST - ANIMATION ITEM: START ZIVA ON BODYLOOK1 (start prints "ZIVA DOWN, HAS WORK" with the launch line)
His S490 play, defects 6-7, not started yet: coach "terrible neck blending"; fighters "shoulders look weird and their walking
too"; "sometimes you can see through them". Brief: ops/research/TASK_BODYLOOK1.md (measure on the game camera, name the
layer per symptom: mesh / cull / alpha / weights / walk clip, then fix). Claude opens every still; he closes it.

## WHAT S491 DID (his words first)
- Defects 1-5 fixed, on the review board + sent (docs/playtest/s491): chip off the face (IntentChip lane under each plate),
  "wtf is eye" -> SidePanel.tag_text says "Eye hurt" / "Nose badly hurt" / blank when fresh, opponent energy bar fill +
  paler range (BodyPanels.Tank), "Draw the lea" fits, call hovers on the house card (Tips) with TipMeter odds bar.
- "whenyou change to large fonts everything breaks inthe scene going out of bound": Settings no longer zooms the window
  (content_scale_factor stays 1.0); scripts/ui/TextScale.gd scales each label/button font on node_added, then settles a
  one-line text back toward its Medium size when its box did not grow (re-checked on redraw). Headless tests stay Medium.
  TextScale.fit(control, width, px, min) for a box that must fit; TextScale.overflow(root) = the audit.
- "we need to have a cohesive interface /hud/ui/ux" -> ONELOOK1 (claude row). Audit tools: `tools/layout_snapshot.gd -- <dir>
  [text=3]` and `tools/fight3d_play.gd -- <dir> [text=3]` print TEXTFIT lines. S491 result: Medium 3 / 60 screens,
  Largest 64 -> 3 (the three are the playbook's 80 px step buttons: "Pivot off the ropes", "Double jab", "Step back").
- Bug: TURN PRO with no offer left crashed (Roster.turn_pro, RosterActs) - guarded.

## THEN (roadmap now.next_action has the order)
1. Quote board answers Q-248..251 and his review comments on the S491 stills; act.
2. ONELOOK1 left: Q-251 palette sweep once he says yes (his "cohesive interface" leans yes - still ask for the colours);
   remaining fight hovers (stamina tank, effects panel, pace/aim, habit card) onto the house card; playbook step buttons;
   layout_snapshot prints OFF FRAME for the FirstWeekStrip GuideBubble buttons (y 1854) - check on a real still.
3. Collect: Qwen WHYGRADE1 (branch qwen/whygrade1; fix = the good plan's counter lines must reach counter|outside),
   Arena ROPESCONTRACT1 PR #317 (run + 5 mutants, merge on 5/5), SQ181 Dola + SQ182 John COACHSPEC1 critics (7+ both).
4. CLASH10 audit by Claude (three seat rounds red; GloveClear push vs Gloves._follow; branch qwen/clash9 instrumentation).
5. FIGHTWEEK3 leftovers (Train it off / Ask a kilo, favours, win band; Main.gd 470/470 -> CardActs.gd router).
6. Arena: one pure module (`python ops/Tools/lite_mirror.py --lean push` first).
7. Miro P0 still owes the S490+S491 redraw (svg marks 12 surplus card slots to delete: ask him once).

## USAGE RULES (kept)
- get_usage first; wrap up from ~310k, hand over by 420k. Godot through `python ops/Tools/godot_slot.py run --who s492 --`
  (bash `timeout` inside godot_slot resolves to Windows TIMEOUT - do not use it there). Write a repo-root
  .tmp_s492_tests.sh runner with the Write tool (rule_guard blocks a heredoc holding the Godot command) and delete it after.
- The fight films read the player's user://settings.cfg (his is Large): pass `text=1` for a Medium film.
- New tests go into tools/run_tests.sh's list (S491 added text_scale, intent_chip, side_panel, corner_bar).

## RAM (S491)
- Finished sessions keep running while Remote Control is on (his "Keep it on"): ~750 MB each. At wrap-up, if the
  watchdog shows RAM high, list finished sessions (list_sessions) and offer to archive them - his yes each time.

## Known reds (NIGHTLY1): fight_why (WHYGRADE1), plan_bots, block_meet B_A pro_left_hook control row.

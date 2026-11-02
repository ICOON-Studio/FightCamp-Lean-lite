---
name: project-session-s208
description: "S208 - SWITCHALL1 (GameSwitches registry, all ON), MetaHuman fight identity + room-view + shout-icon fixes, stress rules wired, Ludo r43, CI minutes cut; digest S208_DIGEST.md"
metadata:
  node_type: memory
  type: project
  originSessionId: ac357a18-37d8-4eab-95bb-c88576242df5
  modified: 2026-10-12T01:56:01.810Z
---

S208 shipped: SWITCHALL1 merged (Godot/scripts/GameSwitches.gd = the one shipped-switch table; bench1 is a scripted benchmark, kept OFF;
LudoShoutBar lazy build). Defects fixed with red-first tests: room view (HALL_FRONT_Z 12 vs hall_d 18), MetaHuman fight identity (trunks/fists),
shout icon link-2 missing. Merged RECEPTIONDESK1, TECHSEED1B, STRESS1A, STRESS1B_A. CI minutes PR #129 (import 10 min -> 38 s). Ludo r43
collected, verdict Q-S207-2. ANIMSOURCE1A motion rejected on sheets -> 1B running. In flight: Codex ANIMSOURCE1B/MH4/UAL1, Arena STRESS1B_B, John J_CLOTHES2.

Lessons: Ludo can sign the session out mid-answer (pane and Chrome both); the Google sign-in popup needs the operator's own click; a JS
`button.send-message` click sometimes does not send - real click, then check the input box emptied. A Codex brief without "## Owned files"
fails check_workflow. Codex inventories mislabel instruments as features - read every flipped switch's code before shipping it ON.
Related: [[project-session-S207]], [[feedback_ludo_huge_questions]].

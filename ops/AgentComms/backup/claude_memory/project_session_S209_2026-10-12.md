---
name: project-session-s209
description: "S209 2026-10-12 collection day - 1B native MH punches, MH4 cast, UAL1, stress merged; 6 runs out; traps (--only comma list, JSON indent 1, untracked import files block asset diffs)"
metadata:
  node_type: memory
  type: project
  originSessionId: 0d158427-7172-4fc0-9cbe-c8afca280afd
  modified: 2026-10-12T06:36:09.648Z
---

S209 merged ANIMSOURCE1B (native MetaHuman guard/jab/cross/hook, sheets opened), MH4 (26 fit MetaHumans incl. women), UAL1 (Quaternius gym motion), STRESS1B_B (Arena PR #130); fixed FightStagePlayer `apply_human on Nil` (SWITCHALL1 default-ON flags). Launched ANIMSOURCE1C + MHNATIVE1 (Codex sol), PROFILE2E (Cursor), COMPOSEBANDS1 + HUDBPM1 (Arena), RECEPTION1B (cloud Cursor issue #132). Board Q-S208-1 = clothes budget (money). Digest: research/S209_DIGEST.md.

Traps that cost a pass:
- `run_tests.py --only` takes ONE comma list (`--only a,b,c`); repeated `--only` flags keep only the last.
- AgentComms JSON (roadmap, route_decisions, live_runs*) is written with `indent=1`, ensure_ascii=False - indent=2 rewrites the whole file.
- Applying an agent's asset diff (MH4) failed on untracked Godot import products with the same names in the main checkout; moved them to E:/FightCamp/backup_untracked_S209_mh4 (reversible), then applied. Use `git add/commit --pathspec-from-file` when the file list is too long for argv.
- Arena chat UI in the hidden browser pane: set the tab viewport to 1280x1100 (resize_window) or the Agent Mode menu item is off-canvas.
- Maria's gbot machine link to this PC failed 4 handoffs running - ask her to paste SVG/text deliverables inline instead.

METAHUMAN1 profile stage: patch v2 saved (research/METAHUMAN1_profile_stage.patch) - apply after MHNATIVE1 (retargeted jab scrambles on MH; the Tripo stand-in boot misfits MH feet -> WARDROBE1). Related: [[project-session-s208]], [[feedback-metahuman-only-no-mpfb]].

LESSON (operator rejected 1B cross after Claude accepted it): numbers + a side sheet passed a cross whose fist wrapped AROUND the
opponent's head with a looping elbow-up path and a 141-deg elbow. Before accepting any punch: open the FRONT and TOP views at the
contact frame, check the fist lands ON the target (not past it), the path is straight, the elbow is ~straight at contact. A gate only
counts if it fails the rejected clip. Also: never re-run check_workflow just to re-read output - it re-imports uncached (RED 86 C).

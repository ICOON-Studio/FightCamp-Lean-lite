# TASK Q179 - QWEN - HUB DISPLAY EVALUATION (your lens of TASK_HUB_DISPLAY_EVAL)
Owner: qwen. Assigned S81, 2026-09-26. Model: qwen3-coder, medium, --yolo. Branch: `qwen/q179-hub-eval`.

## Read first (whole files, both short)
- `research/TASK_HUB_DISPLAY_EVAL.md` - the brief, the three options, YOUR LENS line ("qwen"), the deliverable.
- `research/S80_DIGEST.md` - what the game looks like now. Look at `research/s80_look/current_look_sheet.jpg` and `02_home.jpg`.
- Context, optional: `research/S81_CAGE_LEGACY_SURVEY.md` and `S81_FIGHT_BUSINESS_SURVEY.md` (two competitors; one ships stills, one claims 3D fights). The operator also wants separate gym ROOMS (recovery suite, kitchen, dorms, film room, media office) - see the S81 block in HANDOFF.md's Active claims only if your lens needs it.
Blind: do not open any other agent's *_HUB_DISPLAY_EVAL.md before yours is committed. All research in RESEARCH_INDEX.md is open to you.

## What would a human do?
Answered in the brief: a management-game UI lead decides from what the player must read at a glance, what must visibly change as the business grows, and what the team can afford to keep in sync. Answer it for your lens in your memo's first paragraph.

## Owned files
a new tool Godot/tools/q179_training_clip_census.gd (or .py); your memo research/Q179_HUB_DISPLAY_EVAL.md. NOTHING in Godot/scripts/ is edited. Do not edit HANDOFF.md.

## Tier
No shipped script edited. Parse gate on your new tool only (`python Godot/tools/check_scripts.py <tool>`), then run the tool. NO test suite. Any windowed Godot run goes through `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>`. The PC runs hot: one Godot at a time, nothing else alongside.

## Done
Commit memo + tool on `qwen/q179-hub-eval`, push, then `python Tools/agent_comms.py send --from qwen --to claude --topic Q179 --body "<one line: recommendation + the key number>"`.

## The trap
Measure, do not estimate: a number in your memo that no tool printed must be marked ESTIMATE.

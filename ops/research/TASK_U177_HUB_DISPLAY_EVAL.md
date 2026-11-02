# TASK U177 - CURSOR - HUB DISPLAY EVALUATION (your lens of TASK_HUB_DISPLAY_EVAL)
Owner: cursor. Assigned S81, 2026-09-26. Model: composer-2.5, medium (research, no Godot run needed). Branch: `cursor/u177-hub-eval`.

## Read first (whole files, both short)
- `research/TASK_HUB_DISPLAY_EVAL.md` - the brief, the three options, YOUR LENS line ("cursor"), the deliverable.
- `research/S80_DIGEST.md` - what the game looks like now. Look at `research/s80_look/current_look_sheet.jpg` and `02_home.jpg`.
- Context, optional: `research/S81_CAGE_LEGACY_SURVEY.md` and `S81_FIGHT_BUSINESS_SURVEY.md` (two competitors; one ships stills, one claims 3D fights) and `S81_PUNCH_CLUB_2_SURVEY.md` (a shipped option-B hub: one pixel room per place, the objects are the actions - read it, it is your lens). The operator also wants separate gym ROOMS (recovery suite, kitchen, dorms, film room, media office) - see the S81 block in HANDOFF.md's Active claims only if your lens needs it.
Blind: do not open any other agent's *_HUB_DISPLAY_EVAL.md before yours is committed. All research in RESEARCH_INDEX.md is open to you.

## What would a human do?
Answered in the brief: a management-game UI lead decides from what the player must read at a glance, what must visibly change as the business grows, and what the team can afford to keep in sync. Answer it for your lens in your memo's first paragraph.

## Owned files
your memo research/U177_HUB_DISPLAY_EVAL.md only (no tool needed; a sprite-pipeline cost table from what is in the repo and what you can source with a licence you name). NOTHING in Godot/scripts/ is edited. Do not edit HANDOFF.md.

## Tier
Research: no gate. `git status -s` before staging is the whole check. Do not run Godot.

## Done
Commit the memo on `cursor/u177-hub-eval`, push, then `python Tools/agent_comms.py send --from cursor --to claude --topic U177 --body "<one line: recommendation + the key number>"`.

## The trap
Measure, do not estimate: a number in your memo that no tool printed must be marked ESTIMATE.

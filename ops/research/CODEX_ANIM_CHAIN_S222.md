You are Codex (model gpt-6-astra, reasoning high) on FightCamp, repo ICOON-Studio/FightCamp, repo root C:\Users\user\OneDrive\Documents\ChatGPT\Game.
Read first: AgentComms/CODEX_TOOLKIT.md, CLAUDE.md sections 4-7, .claude/skills/visual-gate/SKILL.md, research/GDSCRIPT_TRAPS.md.

GOAL: clear the open ANIMATION DEFECT list of the boxing demo in ONE run, in this order, each to its own gate. Do the items one after
another; never start item N+1 while item N is red. If an item cannot go green in ~3 honest attempts, write why in its digest, commit the
WIP, and move to the next item (do not stall the chain).

THE CHAIN (each TASK file is the full spec - read it WHOLE before you start that item):
1. FLYFOOT2 - feet pointed like a ballet dancer's (operator: "the feet do not look normal"). research/TASK_FLYFOOT2.md.
   Worktree E:\FightCamp\wt\FLYFOOT1, branch codex/flyfoot1.
2. PAIRLIVE1 - the authored jab pair plays wrong in the live room (fight_pair_live_test red: pair not played, 1-frame clock drift, foot
   lock/push inside the pair, lead glove 10 cm off its authored spot) + one boxer throws 8 punches/min vs 19 (CompuBox 15-19/min).
   research/TASK_PAIRLIVE1.md. Worktree E:\FightCamp\wt\PAIRLIVE1, branch codex/pairlive1 (create from master; seed it first:
   powershell -NoProfile -ExecutionPolicy Bypass -File Tools\seed_godot_cache.ps1 -Worktree E:\FightCamp\wt\PAIRLIVE1).
3. ANIMSOURCE1D - the lead body hook (guard roll, face clearance, spacing) on GLOVES. research/TASK_ANIMSOURCE1D.md +
   TASK_ANIMSOURCE1D_FIX2.md (Claude's 3 rulings). Worktree E:\FightCamp\wt\ANIMSOURCE1, branch codex/animsource1 (WIP b5bb8c06 is there).
(The buried neck KM3B is already fixed by another agent - PR #176 - do not touch FighterCapsules.gd.)

EVERY ITEM, SAME LOOP:
a. git fetch origin && git merge origin/master in that worktree (keep both sides on conflicts; never take a whole file from another branch).
b. RED FIRST: run the item's gate on the shipped tree and paste the red lines. A gate that reads green on master is blind - fix the
   instrument before the animation.
c. Find the CAUSE (the first system that writes the wrong value each frame) and fix it there - never clamp in the recorder or the test.
d. Gate: parse `python Godot/tools/check_scripts.py <touched .gd>`; the item's own test(s); then
   `python Godot/tools/run_tests.py --jobs 2 --only <the systems it touches>` (--jobs 1 unless the watchdog is GREEN). Never the full suite.
e. VISUAL: stills ONLY through record_room.gd -- as_game + Godot/tools/still_framing.gd save_if_framed (both men head to feet), guard AND
   mid-move, plus a 20 s clip; per still report gap / noses / wrists / feet (numbers). You cannot call a visual defect fixed - Claude and
   the operator close it.
f. Commit + push the branch, write research/<ITEM>_CHAIN_DIGEST.md (red lines, cause, fix, green lines, still paths), then next item.

HARD RULES (the operator's):
- PC: before EVERY Godot/test run: powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once ; exit 1 = RED = wait.
  CPU never above 84 C. Never run two Godot processes at once.
- Nothing opens on the operator's screens: windowed Godot ONLY via powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1
  <godot args>; never Godot_*_console.exe, never start/explorer/os.startfile; view images with your file tool only.
- Never two identical fighters in a measurement; never delete, skip or loosen a test, a threshold or a seed; never master.
- git: explicit `git add -- <files>`; never bare stash / reset --hard / checkout . / clean / add -A; never commit *.import churn.
- New behaviour ships ON (GameSwitches.GAME_ON), the plain --script tests stay the OFF control arm.

WHEN THE CHAIN ENDS: write AgentComms/messages note to Claude listing per item: branch, last commit, gate red->green lines, stills, what is
still open. Claude reviews, merges by diff, and puts the stills on the operator's board.

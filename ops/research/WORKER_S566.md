# Console workers of S566 - read this BEFORE your task file (owner S566: "move arenas work do notwait")

Arena reached its daily limit, so the two measure briefs written for it run on the PC as console workers. Where a brief
says "Seat: Arena", "the clone", "ONE pull request" or "FightCamp-Lean-lite", read instead:

- You work in the MAIN checkout `E:\FightCamp\Lean`, on `main`. No branch, no pull request, no worktree.
- Other workers and the main session are alive in the same checkout. Commit ONLY your own files, by pathspec, in one
  command: `git commit -m "<msg>" -- <your files>` (after `git add -- <new files>`). Never `git add -A`, never a bare
  stash / reset --hard / checkout . / clean. `git pull --rebase` is refused if the tree is dirty: use
  `git push` and, if it is rejected, `git fetch` then `git rebase origin/main` only when YOUR files are the only staged ones;
  otherwise leave the commit local and say so in your result.
- Push after each finished run (one push per result, not per edit).
- Table files (`*.vt.json`) go to `E:\FightCamp\wt_tmp\<TASK ID>\` (make it), never into the repo.
- CPU: KICKFIX4 uses `jobs=3`, TELLS4M uses `jobs=2`. Before each table or n=56 / n=84 run:
  `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; on RED wait 5 minutes and look
  again (do not start). If the output names ArcheAge among the top processes (the owner is playing), drop to `jobs=1`.
- Long runs write to a file (`> E:\FightCamp\wt_tmp\<TASK ID>\<name>.log 2>&1`) and you wait on the process, not on a string.
- Nothing opens on the monitors: no browser, no image viewer; read files with your file tool.
- Do not ask questions: a tab that asks cannot be answered. Decide, write why in the result page, carry on.
- The game is called Puncher's chance. Never write "Ring Switches" in a result.
- End: the result page named in your brief, its last line `<ID> DONE` or `<ID> BLOCKED: <why>`, committed and pushed.
  Then stop.

KDPIC1 (the render worker): your brief is complete as written; the rules above about commits, questions and the watchdog
apply too. One windowed render at a time, only through the hidden desktop tools the brief names.

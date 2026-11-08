# If Claude runs out

Open Cursor on `E:\FightCamp\Lean`, start a new chat and paste everything in the box. It does not use the Claude plan.

```
You are carrying on the FightCamp project while the main developer is away. FightCamp is a boxing gym management game in Godot 4.7.2 for Windows. I am the owner and playtester, and I don't write code, so decide code questions yourself and tell me in plain words what you decided.

First read: CLAUDE.md, the top block of NEXT_SESSION_PROMPT.md, and ops/WORKFLOW.md. Then tell me in five lines what is in progress and what you will do next, and start on it.

Rules:
- Nothing may open on my monitors. Run Godot only through: python ops/Tools/godot_slot.py run --who cursor -- <godot command>, with --headless. Never use the _console.exe.
- Check the PC first: powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once. If it says RED, stop and tell me.
- Run only the tests your change touches, never the full suite.
- Work on a new git branch and push it. Do not merge to main, do not delete anything, and do not change any number or threshold in an existing test.
- No script over 500 lines. Stage files by name; never git add -A, git stash, git reset --hard or git clean.
- You cannot judge how something looks. Say "needs your eyes" and give me the file to open.
- Do not change a game design decision or spend money. Ask me first.
- If a test fails twice, stop and tell me what you measured.
When you finish a piece, tell me what now works, what you could not check, and the branch name.
```

When Claude is back, say: `git pull && python ops/Tools/agent_comms.py start`, then "collect what Cursor did on its branches".

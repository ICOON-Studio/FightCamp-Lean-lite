# TASK Q33 — QWEN — THE BOTS' CHATS NEVER RESET, AND `read` CRASHES ON AN EM-DASH

Model: qwen (its CLI in this checkout), effort MEDIUM, `--yolo`.
Owner: qwen. Task id: Q33.

## Why this exists

**Operator instruction, 2026-09-10: clear the other agents' chats/sessions to
avoid credit waste.** Auditing that produced one good answer and two defects:

- Codex, Cursor and Qwen are **fine and need nothing** — every launch is a
  one-shot stateless invocation (`codex exec`, `cursor-agent -p`, `qwen -p`).
  Nothing accumulates between tasks.
- Grok in the browser is fine too, because a new chat is opened per task.
- **Kalli, John Research and Maria Art Director are NOT fine.** Their chats live
  in the Grok Bot desktop app and grow without limit — every `send` re-reads the
  whole history, so each task costs more than the last. `Tools/grokbots/grokbots.py`
  has **no command to start a fresh chat**, even though the app plainly has a
  "New chat" control: the script already names it at `grokbots.py:138`, in a
  regex that EXCLUDES it from the chat listing.

And, found while verifying a delivery:

- **`grokbots.py read` crashes outright on an em-dash.** `cmd_read` at
  `grokbots.py:301` does a bare `print("  " + line[:200])`, Windows stdout is
  cp1252, and any `—` or `→` in a bot's reply raises
  `UnicodeEncodeError: 'charmap' codec can't encode character '→'`.
  The traceback lands mid-transcript, so a read looks like a tool failure when
  the bot actually replied fine. Our own task files are full of em-dashes, so
  this fires constantly.

## Owned files

- `Tools/grokbots/grokbots.py` — **the only file you change.**
- `research/Q33_DIGEST.md` — short.

Do NOT touch `Tools/agent_comms.py`, any `.gd`, `HANDOFF.md` or `CURRENT_STATUS.md`.

## Job 1 — make the output survive real text

Fix the encode crash properly rather than by stripping characters. The bots write
em-dashes, arrows and curly quotes and we want to READ them, not mangle them.

Reconfigure the process's stdout to UTF-8 with a replacement error handler at
start-up (`sys.stdout.reconfigure(encoding="utf-8", errors="replace")` guarded
for the case where stdout has no `reconfigure`), so **every** command benefits
rather than just `cmd_read`. Then confirm no other bare `print` of bot text can
still throw.

`PYTHONIOENCODING=utf-8` in the environment is the workaround, not the fix — the
script must work when run plainly.

## Job 2 — `newchat`

Add a subcommand:

```
python Tools/grokbots/grokbots.py newchat --to "<bot name>"
```

It opens that bot's chat and clicks the app's **"New chat"** control, so the next
`send` starts from an empty context. Print a clear one-line confirmation naming
the bot, and a clear failure line if the control was not found — **never exit 0
silently on a miss**, because a silent no-op here would look exactly like
success and quietly keep costing us money.

Follow the existing CDP patterns in the file; do not invent a second mechanism.
Line 138 already shows the accessible label the app uses.

Also accept `--new` on `send`, meaning "start a fresh chat, then send". That is
the form Claude will actually use, because it makes a task's delivery and its
context reset one action.

## THE SAFETY CONSTRAINT — READ THIS TWICE

**Two bots are mid-task RIGHT NOW: `John Research` is working J16 and `Kalli` is
working K27.** Starting a new chat on either would destroy work in flight.

- **Test ONLY against `Maria Art Director`**, who has delivered M14 and is idle.
- Do NOT run `newchat` against `Kalli` or `John Research` for any reason.
- Verify with `--dry-run` first if you add one.

If Maria turns out to be busy when you get there, implement the command, verify
it as far as you safely can, and **report that the live click was not exercised**
rather than testing it on a working bot. An unverified command reported honestly
is worth more than a delivered task that cost us John's research.

## Test tier — THIS IS PYTHON, NOT GDSCRIPT

No parse gate (that tool is for `.gd`). No Godot. No test suite. The gate is:

```
python Tools/grokbots/grokbots.py --help
python Tools/grokbots/grokbots.py chats
python Tools/grokbots/grokbots.py read --to "Maria Art Director"
python Tools/grokbots/grokbots.py newchat --to "Maria Art Director"
python Tools/grokbots/grokbots.py read --to "Maria Art Director"
```

The `read` before and after is the proof: a chat that reset reads empty. Show
both in your digest. And confirm the read no longer crashes on an em-dash —
the transcript you print will contain plenty.

**NEVER pass `--godot` to `run_tests.py`.** You have no reason to run it at all.

## Close-out

`git rev-parse --abbrev-ref HEAD` before believing any commit landed. Commit,
push to **master**, write `research/Q33_DIGEST.md`, and send:

```
python Tools/agent_comms.py send --from qwen --to claude --subject Q33-done --body "<sha> newchat=<verified-on-maria|implemented-not-exercised> read-utf8=ok send--new=<yes|no>"
```

Do NOT edit `HANDOFF.md`.

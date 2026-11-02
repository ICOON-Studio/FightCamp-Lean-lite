---
name: bash-tool-heredoc-and-crlf-gotchas
description: "Long quoted heredocs in the Bash tool are parsed as shell (nothing written); repo files mix CRLF/LF so Python patches must normalise line endings; never preload a .tscn at a test's top level"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e0bcb3e6-dc42-42b9-a427-513d8b9508aa
  modified: 2026-09-12T23:20:11.193Z
---

Three traps hit on 2026-09-05 while shipping R20 steps 2-3:

1. A long `cat > file <<'EOF'` or `python - <<'EOF'` heredoc in the Bash tool is NOT honoured: bash parses the body as commands and dies on the first apostrophe ("unexpected EOF while looking for matching `''"). Heredocs of ~100 lines worked; ~200+ did not. It fails safe (nothing is written) but costs a whole turn.
2. Several repo files are CRLF (`AthleteProfileShellScreen.gd`, `OfficeHub.gd`, most tests) while others are LF. An exact-string Python patch opened with `newline=''` silently misses on CRLF files.
3. A test that `preload`s a `.tscn` at its top level compiles that scene's script - and everything the script preloads (`FightSimulation.gd`) - before the autoloads exist; the depended script fails and its statics are "nonexistent" at runtime. Same class as the CLAUDE.md smoke_test rule, now proven for scenes.

4. PowerShell here-string syntax (`@'...'@`) passed to the **Bash** tool is not here-string syntax there: the `@` delimiters land in the data. `git commit -m @'...'@` on 2026-09-05 produced a commit whose subject was a bare `@`. The two tools take different syntax; a multi-line commit message goes to Bash as a `-m $'...'` string or a scratchpad file with `-F`, and only to PowerShell as `@'...'@`.

**Why:** each miss is a full turn plus a re-read of every anchor; the credit budget is the standing constraint.

**How to apply:** write new files with the Write tool; put patch scripts in the scratchpad with Write and run `python script.py <repo>`; in patch scripts read with `raw.replace('\r\n', '\n')`, keep `crlf = '\r\n' in raw`, and write back with the original ending; in tests `load()` scenes inside the function. See [[credit-budget-2026-09]] and [[godot-verification-gate]].

## IT HAPPENED TWICE MORE ON 2026-09-12, IN ONE SESSION, AFTER THIS WAS WRITTEN

Both times patching `Tools/agent_comms.py` through a bash heredoc, and both times
the file was left **broken on disk**:

1. `\\n` inside the Python string became a REAL NEWLINE, so the regex literal was
   split across two lines -> `SyntaxError: unterminated string literal`.
2. The retry used `\\b`, which became a LITERAL BACKSPACE (`\x08`) in the file.

Recovery was `git checkout -- Tools/agent_comms.py` (scoped to that one path,
never a bare checkout) and then the Write tool.

**THE RULE, HARDENED: never patch a file through a bash heredoc or a PowerShell
text pipeline. Write the patch script with the Write tool and run it.** The
escape sequences do not survive either shell, and the failure is silent until
something parses the file.

Two more details that cost time the same day:
- **Locate by the SMALLEST unique substring, not a multi-line block.** A
  four-line anchor failed to match because `agent_comms.py` is CRLF while the
  `.gd` files nearby are LF. Always detect: `nl = "\r\n" if "\r\n" in s else "\n"`.
- **Make the script print BEFORE and AFTER of the line it changes**, and abort
  with "ANCHOR NOT FOUND - file untouched" rather than writing a partial edit.

## 2026-09-13: THE DETECTOR ITSELF LIED

- **`grep -c $'\r' file` in Git Bash prints 0 on a CRLF file** - its grep strips the
  CR. It reported `FightSimulation.gd`, the catalogue and the vocabulary as LF; they
  are CRLF in the worktree (index LF, `core.autocrlf=true`). A Python patch built
  on that answer missed its anchor. **Use `git ls-files --eol -- <file>`** (`w/crlf`)
  or read bytes in Python. The Edit tool preserves endings on its own.
- A heredoc patch failed AGAIN that day (a `\\n` replacement never matched). The rule
  holds without exception: Write the script, then run it.
- **Backticks inside a double-quoted `git commit -m "..."` are command
  substitution:** a message containing `` `now` `` ran `now` ("command not found")
  and silently dropped the word from the pushed message. Use single quotes, a
  `$'...'` string, or `-F <file>` for messages that quote code.
- **A patch-run-restore harness must survive a hang.** A patched `.gd` that does not
  COMPILE (e.g. `return true` before code = unreachable, a parse error) hangs the
  headless test before `quit()`, and the restore in `finally` never runs while it
  hangs - the patch sits on disk. Give `subprocess.run` a timeout that taskkills both
  Godot exes, and prefer breaks that compile (`if false and ...`).

**Recurred twice on 2026-09-13:** a Python converter with `"\n".join` inside a quoted bash heredoc came out
with a real newline in a string literal (SyntaxError), and a patch script's `\\b` regex never matched. Any
Python that contains a backslash goes into a file through the Write tool, then runs - never a heredoc.


**A BACKTICK INSIDE A DOUBLE-QUOTED `git commit -m` IS COMMAND SUBSTITUTION
(2026-09-21).** A commit message containing `` `head -25` `` made bash RUN
`head -25`, which blocks reading stdin that never arrives. **The shell sat dead
for 90 minutes** and the operator spotted it before I did — no output, no error,
no git process, no index.lock, because git was never reached.

**How to apply:** write commit messages with `git commit -F -` and a QUOTED
heredoc (`<<'EOF'`), never `-m "..."`. Quoted heredocs disable substitution
entirely, so backticks, `$`, quotes and apostrophes are all safe. And when a
background task stops producing output, KILL IT — do not work around it and
leave it running; a dead waiter is invisible to you and visible to the operator.

**Backticks in a `git commit -m "..."` are COMMAND SUBSTITUTION and get eaten
silently (2026-09-22).** A message written with `` `body_condition` `` inside a
double-quoted bash string pushed with four identifiers simply MISSING and two
sentences ungrammatical — bash printed `command not found` but the commit still
succeeded, so the failure is invisible unless you read the message back. Once
pushed to a shared master an amend needs a force push, which is not worth it.

**How to apply:** write commit bodies with a single-quoted heredoc
(`git commit -F - <<'EOF'`), which is literal, or leave the backticks out. Read
the message back with `git log -1 --format=%B` before pushing anything whose
wording matters. And put the durable explanation in a CODE COMMENT as well —
that path goes through the Write tool or a Python patch, never the shell, so it
cannot be mangled.

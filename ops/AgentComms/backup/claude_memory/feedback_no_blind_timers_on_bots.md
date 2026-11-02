---
name: feedback_no_blind_timers_on_bots
description: "Never wait on a Grok Bot agent (John/Kalli/Maria) with a long blind timer - let grokbots.py send wait on the bot's own status line"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 630f77ee-c380-4003-a8d3-fa9a8cecfea8
  modified: 2026-09-12T21:27:07.965Z
---

Operator, 2026-09-13: **"dont use 25minute long timer to check on a bot"**. J26's
retry answered in about a minute; a 25-minute hands-off timer left the answer unread
until the operator said "he answered already check now".

**Why:** the overcorrection came from J26's first run, which stopped without
replying while Claude re-opened the chat every 30-60 s with separate `read` calls.
The fix for that was never "wait blind" - it was a tool that can tell working from
done.

**How to apply:**
- `python Tools/grokbots/grokbots.py send --to "<bot>" --file <task> --timeout 1800`.
  Since `7014702` it watches the bot's `<bot> is working` line, returns when that
  clears, and stops on `stopped without replying`.
- To collect later: ONE `read --to <bot> --wait 1800 --out <file>` - a single call
  that polls the page without re-opening the chat. Never a loop of separate reads.
- Check the transcript is the new task's: a `--new` chat may not be the thread
  `read --to` opens.

**A SILENT SEND IS NOT AN EXHAUSTED BOT (S26, 2026-09-20).** `send --file` delivered the whole of
TASK_R151 to John and reported *"the bot STOPPED WITHOUT REPLYING - there is nothing to collect"*.
The message was in his chat. **A one-line nudge naming only the FIRST question came back complete
and sourced in 45 s** ("Start with question 1 only: quote the denominator verbatim with the URL").
So on a silent send: re-read the chat to confirm delivery, then nudge with a NARROWER ask rather
than resending the task or concluding the credits are gone. A long multi-part task file seems to be
what stalls them.

Related: [[project_shell_less_agents_unavailable]], [[feedback_drive_qwen_and_grok_to_delivery]],
[[reference_knockdown_rate_definition]].

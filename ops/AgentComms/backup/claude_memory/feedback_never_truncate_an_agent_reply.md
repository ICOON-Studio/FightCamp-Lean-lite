---
name: feedback_never_truncate_an_agent_reply
description: "An agent reply arrives as a TAIL and reading it through another window drops the start; gate the digest, not the intention"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 928672c1-cd85-44c1-9dba-06a222f809a3
  modified: 2026-09-22T11:08:48.391Z
---

**Never apply `head`/`tail`/`sed -n` to an agent reply whose length you have not
checked, and treat output that ENDS ON A HEADING as proof there is more.**

2026-09-22: Dola's evaluation was landed as a digest that read as complete and
was not. Two separate cuts:

1. `cici.py send --wait` printed only the last 40 lines under a `--- tail ---`
   banner — **while holding the full body in memory.** Fixed at source: it now
   always writes the complete capture to a file and says how much the tail hides.
2. **Then that tail was read through `sed -n '1,36p' | head -34` on a 44-line
   file.** The output ended on the words "FINAL NOTE" with nothing beneath it,
   and that signal was ignored. Her closing — one diagnosis unifying all four
   problems she'd been asked about — was dropped, along with her lead line and
   two sections the tool had already cut.

**Why:** the first cut was the tool's, the second was mine, and no fix to the
tool touches the second. Assurance that "I read it" is worth nothing — that
assurance was given and was false.

**How to apply:**
- `wc -l` before any windowed read; never stack two windows.
- Run `python Tools/check_digest.py <digest.md> <raw-capture>` — it fails when a
  section heading present in the capture is unmentioned in the digest.
- Keep the raw capture in `research/_captures/` beside every digest
  transcribed by hand from a chat pane, so the check is re-runnable by anyone.
- A deliverable an agent STAGED as a file needs none of this: `diff -q` the
  staged copy against the landed one, which is stronger.

Related: [[feedback_open_the_output_before_the_gate]],
[[project_agent_comms_truncation]], [[feedback_collect_before_you_assign]].

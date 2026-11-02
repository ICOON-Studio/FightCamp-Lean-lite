---
name: feedback_drive_qwen_and_grok_to_delivery
description: "When Claude assigns Qwen or Grok, Claude drives it to delivery itself - never hand the operator prompts to answer or files to relay"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: c8a93b87-8450-443f-8aed-5b495d370a60
  modified: 2026-09-12T23:19:49.022Z
---

Operator rule 2026-09-09: **assign Qwen or Grok, then control it until it
delivers.** Do not count on human input for either of them — no "press 1 at the
prompt", no "paste this into the terminal", no `SendUserFile` relay.

**Why:** the operator's job is to DECIDE, not to be an input device. An
assignment that stalls waiting for them to approve a tool call has just moved
the work back onto them, which is the same failure as
[[feedback_deadend_means_assign_research]] in a different costume. Extends
[[project_qwen_and_grok_reachable_in_app]], which established that both are
reachable in-app; this says reachable is not enough, it must be finished.

**How to apply:**

- **Qwen: launch headless with `--yolo`, never `--approval-mode auto`.**
  **CURRENT FORM (verified 2026-09-13, Q74/Q75/Q76 all delivered):** from the repo
  root, in PowerShell, background:
  `Get-Content <prompt.txt> -Raw | & "$env:LOCALAPPDATA\qwen-code\bin\qwen.cmd" --yolo -m qwen3-coder *> <out>`.
  `-p` is DEPRECATED since CLI 0.23 and a multi-line argument is re-split by the
  shim - pipe the prompt on stdin. (The `-p` forms below are the 2026-09-09 history.)
  `qwen --yolo -p "<prompt>"` from the repo root, run in the background.
  **The binary is not on the bash PATH** — `which qwen` fails and
  `qwen --version` is "command not found" even when it is installed and
  authenticated. It is a Windows `.cmd`: invoke it through PowerShell as
  `& "$env:LOCALAPPDATA\qwen-code\bin\qwen.cmd" --yolo -p $prompt`, passing a
  long prompt via `Get-Content <file> -Raw` rather than inline. Verified
  2026-09-09 driving Q17 to a clean delivery (5214 checks, suite 203/0). Verified
  2026-09-09: `--approval-mode auto` in one-shot mode leaves Qwen with **no
  shell tool at all** — it exits 0 having done nothing but ask Claude to run
  the commands for it, because it falls back to the tiny `permissions.allow`
  list in `.qwen/settings.json`. `--yolo` gives full tools and zero prompts.
  Set `QWEN_CODE_SUPPRESS_YOLO_WARNING=1` to quiet the banner.
- **An interactive Qwen in the operator's terminal cannot be driven by Claude.**
  `mcp__terminal__read_terminal` reads and runs nothing; there is no write-to-
  terminal tool. So never plan around that instance — launch your own headless
  one, and tell the operator to leave the terminal one untouched so two agents
  do not work the same task.
- **`--yolo` is unsandboxed and auto-executes every write.** Before launching,
  copy any uncommitted work to the scratchpad and record `git log --format=%H -1`,
  so a bad `git stash`/`reset` is recoverable ([[feedback_shared_index_git_add_gotcha]]).
  Put the destructive-git prohibitions in the prompt explicitly, and name both
  the owned files and the not-yours files.
- **Never tell it to rebase or pull first** unless it is genuinely behind:
  `git rev-list --left-right --count HEAD...origin/master`. A rebase against a
  dirty tree fails with "Please commit or stash them", which dangles exactly
  the destructive word in front of an agent whose own unfinished work is the
  only dirty thing there.
- **One task per Qwen launch.** Q19's prompt queued Q20 behind it; Qwen
  shipped Q19 cleanly, then reported "no further loop wakeups needed" and
  exited without touching Q20 (2026-09-10). A one-shot `-p` run finishes the
  task it was given and stops. Launch it again for the next one.
- **Grok is driven through the in-app browser, and the composer is a
  `contenteditable`, not a `textarea`** — `document.querySelector('textarea')`
  finds an unrelated hidden element and returns junk. Verified 2026-09-10:
  `computer{action:"type"}` with real `
` characters inserts 5k+ characters
  WITH structure intact and does NOT submit on newline, so the older
  `form_input`-flattening workaround is unnecessary — just type it, then check
  the length with
  `document.querySelector('[contenteditable="true"]').innerText.length`.
  (`innerText` reports paragraph breaks as `

`; the sent message is fine.)
- **Grok's model menu must be clicked from JS, not by coordinate.** The
  chevron beside the model name opens it, but `find` does not match the option
  labels and coordinate clicks land on whatever scrolled underneath. Use
  `[...document.querySelectorAll('[role="menuitemradio"]')].find(e =>
  e.textContent.trim() === 'Expert').click()`. Tiers are Auto / Fast / Expert /
  Build / Heavy; **Expert** is the research tier — Fast will not do a sourced
  survey, and a stray click lands you in Build mode silently.
- **Grok's file deliverable cannot be read out of the browser.** A long answer
  comes back as a Document artifact with a Download button; its text is not in
  `body.innerText`, the "open" and expand controls do not put it there, and
  downloading is a permission-gated action. Ask it in a follow-up to **print
  the entire document inline as raw markdown, verbatim, no attachment**, then
  take it with `get_page_text` and write the file yourself. Budget for
  reconstructing the markdown: `get_page_text` returns tables as tab-separated
  lines and drops code fences.
- Ask it to end its reply with the facts you will verify (commit hash, suite
  line), then check the diff yourself — a `--yolo` agent's summary and its
  commit are two different things.

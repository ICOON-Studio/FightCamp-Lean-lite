---
name: feedback_grok_build_mode_trap
description: "How to actually drive Grok in the in-app browser — real pane is 323x246, viewport emulation breaks every click, Enter does not submit"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 67e4b1a8-d436-488c-82ee-666290bfaa0d
  modified: 2026-09-11T10:14:27.065Z
---

Driving Grok through `mcp__Claude_Browser__*`. Corrected and expanded 2026-09-11
(G56), when the old advice cost most of an hour.

**The pane's real viewport is about 323x246.** Read it with
`window.innerWidth/innerHeight` before clicking anything.

**NEVER call `resize_window` to emulate a bigger viewport.** Emulating 1280x900
in a 323x246 pane makes every reported click coordinate land somewhere else:
clicks silently do nothing, the composer never takes focus, and `computer.type`
types into the void with no error. Reset with preset `desktop` and use the pane's
own tiny coordinates from `getBoundingClientRect()`.

**The composer is a TipTap/ProseMirror contenteditable DIV, not the textarea.**
There IS a stray `<textarea>` on the page; writing to it does nothing.

**Synthetic events do not work.** `document.execCommand('insertText')` puts text
in the DOM but NOT in ProseMirror's state, so the app submits nothing and the
click looks dead. A constructed `ClipboardEvent` paste is ignored outright. Only
real `computer` clicks and `computer.type` reach the editor.

**ENTER DOES NOT SUBMIT** (this reverses the old note). Pressing Return leaves
the text sitting in the composer. **Click the `button[aria-label="Submit"]` at
its live `getBoundingClientRect()` centre.** Because Enter is inert, a newline in
typed text is safe — but keep the message single-line anyway, it is one `type`.

**Escape DOES close the model menu** (also reverses the old note). Verify with
`button#model-select-trigger`'s `data-state`.

**Verify the tier from the DOM, not the label** — at this viewport the button's
text is empty. Open the menu and read `aria-checked` on the `[role="menuitem"]`
entries: `Auto / Fast / Expert / Build / Heavy`. Confirm **Expert checked=true
and Build checked=false** before submitting; Grok's weekly limit is scarce.

**Confirm the send happened**: the URL changes from `grok.com/` to
`grok.com/c/<uuid>` and the composer empties. See
[[project_qwen_and_grok_reachable_in_app]] and
[[feedback_drive_qwen_and_grok_to_delivery]].

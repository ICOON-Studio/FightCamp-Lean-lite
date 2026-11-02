---
name: reference_reaching_operator_browser_state
description: "How to reach the operator's own Chrome state - the extension shares their profile, so IndexedDB and cookies ARE reachable"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 50b85198-25e9-4e6d-968f-a6a49b10cbf7
  modified: 2026-09-21T19:02:58.563Z
---

Three browsers are in play and they are NOT equivalent (established 2026-09-21):

1. **My pane**, `mcp__Claude_Browser__*` - a browser inside the Claude app with
   its OWN profile. Separate cookies, separate localStorage, separate
   IndexedDB. It sees only what is on the server.
2. **The operator's Chrome** - where their real sessions live.
3. **The extension**, `mcp__claude-in-chrome__*` - runs IN their Chrome, in
   their profile.

**What the extension CANNOT do:** attach to a tab they already had open.
`tabs_context_mcp` creates and lists only its own tab group; their other tabs
are invisible to it. In-page JS variables of an existing tab are therefore
unreachable.

**What the extension CAN do, and I got this wrong once:** a NEW tab it opens at
the same ORIGIN shares that origin's storage in their profile - cookies,
localStorage, IndexedDB. So unsaved work that an app persists to storage IS
readable, even though the other tab's memory is not. I told the operator "no
tool can do this" and it was only half true.

**Perchance specifically** keeps unsaved state in IndexedDB at
`https://perchance.org`:
- `perchance-src-pending` - stores `files` and `meta`; meta rows are keyed by
  generator id and hold `workingManifest`, `baseLastEditTime`, `baseSaveCount`
- `recoveryStash-db` - store `recoveryStash-store`
- `localBackups-db` and `perchance-local-backups-v2`
- `aiAgentChat` - store `chats`, one row per AI-helper conversation

Server-side truth is `await window.__fetchGeneratorDataVersion()` ->
`{lastEditTime, saveCount, editorPayloadRevision}`. `saveCount: 0` means the
generator has never been saved, whatever a tab is showing.

**How to apply:** before telling the operator something is unreachable, check
whether the app persists it to storage and open a same-origin tab through the
extension. Clean up any tab opened this way with `tabs_close_mcp`.

Related: [[feedback_use_my_own_browser_panel]],
[[project_agent_host_capabilities]].

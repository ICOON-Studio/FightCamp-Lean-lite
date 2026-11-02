---
name: feedback_chrome_extension_traps
description: "Claude-in-Chrome operational traps - only ONE tab may hold an in-page AI conversation, the extension cannot see tabs outside its own MCP group, and click coordinates are FRAME coordinates (x 1568/1920), not page coordinates"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 9e3da6ad-2507-4165-a508-3ceb3183e36d
  modified: 2026-09-21T22:12:01.314Z
---

**Six failed send attempts on 2026-09-22 traced to three causes, none of which
announce themselves.** The operator's reaction — *"i dont understand why you
cannot use the opned perchance webpage in my chrome and you always open a new
one?"* — was fair, and the answer was a capability limit I should have stated
the first time instead of quietly opening another tab.

## 1. The extension can only see its OWN tab group

`tabs_context_mcp` returns tabs inside the extension's MCP tab group and
nothing else. **The user's own open tabs are invisible to it** — there is no
tool to enumerate them or attach to one. So "use the tab I already have open"
is not possible; a new tab in the group is the only option. **Say this plainly
the first time** rather than opening tab after tab.

## 2. Only ONE tab may hold an in-page AI conversation

A second tab is refused with *"that AI conversation is open in another tab;
close that tab (or wait for it to disconnect), then retry"*, and the message
lands in a **"Not delivered"** retry banner instead of sending. Combined with
trap 1 this is genuinely confusing: **the blocking tab is one the extension
cannot see**, so the refusal looks like a length limit or a dead agent.

**Diagnosis:** read the page text for `Not delivered` and the error line above
it before theorising. It names the cause exactly.
**Fix:** the user closes theirs, then Claude drives it end to end. That is also
what removes them from the relay seat.

## 3. Click coordinates are FRAME coordinates, not page coordinates

The tool frame was **1568 wide against a 1920 viewport** — a factor of
**0.8167**. `getBoundingClientRect()` returns PAGE pixels, so clicking those
values directly **misses silently**: the click lands, nothing happens, and
there is no error. Three Send clicks were lost to this before it was spotted.

```js
const F = 1568 / 1920;                    // read the real frame from a screenshot
{x: Math.round((r.x + r.width/2) * F),    // then scale every rect
 y: Math.round((r.y + r.height/2) * F)}
```

A click that lands with no effect is the tell. Take a screenshot, read the
reported frame size, and rescale.

## 4. Programmatic value-setting does not always register

Setting `textarea.value` via the native setter plus an `input` event left the
Send button inert, and the framework's own Restore buttons did **not**
repopulate the composer either. **Typing with real keystrokes worked.** When a
submit control ignores text that is visibly present, suspect this.

Related: [[reference_reaching_operator_browser_state]],
[[feedback_use_my_own_browser_panel]],
[[feedback_verify_the_launch_not_the_guess]],
[[project_perchance_bjj_3d_probe]].

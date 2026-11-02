# Perchance BJJ sim — the cage/fence work, rescued from browser storage (2026-09-22)

## What happened

The cage/fence task sent to the Perchance agent on 2026-09-22 ~01:10 **did real
work and then lost it**. Measured from the operator's Chrome, not inferred:

| where | chars | lines | "fence" | "cage" |
|---|---|---|---|---|
| server, rev 10 / saveCount 5 | 238,611 | 4,760 | **0** | **0** |
| live editor buffer | 238,611 | 4,760 | **0** | **0** |
| `perchance-src-pending` IndexedDB | **246,573** | **4,925** | **72** | **4** |

So the editor was showing the SAVED version, the fence work existed only in the
`perchance-src-pending` IndexedDB record, and **nothing on the server or in the
editor knew about it**. A save from the editor as it stood would have taken the
generator to saveCount 6 and dropped the 132 lines permanently.

`baseSaveCount` on the pending record is **5**, matching the server exactly, so
the recovered source is a clean descendant of rev 10 — there is no three-way
merge to do and no divergence to reconcile.

## What was recovered

`PERCHANCE_gro5f7k2s5_rev10_pending_recovered_2026-09-22.json` — the whole
pending panel set, 261,270 characters:

- `outputTemplate` — 246,573 chars, 4,925 lines
- `modelText` — 3,818 chars
- `baseSaveCount` / `baseLastEditTime` — the rev 10 anchor it was edited from

The delta against the saved version is **132 added lines, 7,483 characters**.

## What the agent actually built, from the identifiers in those 132 lines

`CAGE`, `FENCE`, `FENCE_FACE`, `fenceRadius`, `fencePoint`, `fenceOn`,
`fenceHold`, `projFence`, `projFenceNN`, `segFenceOver`, `fenceOverP`,
`fenceOverNN`, `fencePass`, `kFence`.

That is the shape that was asked for: **the fence as a third contact surface**
(`projFence` / `segFenceOver` project a capsule onto it and measure how far it
is over), with **fence violations scored separately from mat violations**
(`fencePass`, `fenceOverP` / `fenceOverNN` as their own penetration terms).

## What is NOT in it

**Zero occurrences of "underhook".** The eight standing wrestling positions
(collar tie, double collar, underhook, over-under, double-leg with the head
OUTSIDE the hip, single-leg with the head INSIDE, sprawl, front headlock) were
NOT delivered — "collar" appears 10 times and "sprawl" twice, both of which are
already in the saved rev 10. The agent reached the fence surface and stopped
there. Cage clinch / wall wrestling / body lock on the fence are unverified: the
machinery to support them is present, the positions are not.

## Why it stalled

The operator's own report, verbatim: *"error: that AI conversation is open in
another tab; close that tab (or wait for it to disconnect), then retry so this
tab can continue it safely — your message is saved for retry"*. That is the
documented one-tab trap — only ONE tab may hold the AI conversation, and the
Chrome extension cannot see tabs outside its own MCP group, so the offending tab
has to be closed by the operator.

## State on leaving it

**NOTHING WAS WRITTEN BACK AND NOTHING WAS SAVED.** The operator's decision was
to rescue to a file first and decide afterwards. The server is untouched at rev
10 / saveCount 5, the editor is untouched, and the pending IndexedDB record is
still in place as a second copy. Both tabs opened for the rescue were closed.

## How to put it back, when that is decided

Load `outputTemplate` and `modelText` out of the JSON into
`outputTemplateEditor` / `modelTextEditor` and save. Two preconditions, because
two writers collide: the operator's own perchance tab must be closed first, and
`__fetchGeneratorDataVersion()` must still read `saveCount: 5` — if it reads 6
or higher, someone has saved since and this is no longer a clean descendant.

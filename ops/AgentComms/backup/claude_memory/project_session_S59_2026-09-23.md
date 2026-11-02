---
name: project-session-s59-2026-09-23
description: S59 - carry_progress ON; animation without filming (operator ruled filming OUT); checked stills, split-screen and colour suits; Reallusion installed on D:
metadata:
  type: project
---

S59 (2026-09-23). Shipped `carry_progress` default ON (operator "Yes, ship it ON"). Suite total=359 fails=9 (the nine documented reds).

**The operator ruled FILMING OUT** for animation ("this is not an option, find a way... innovate"). Never recommend filming people again; G76 (Grok) did and was overruled. The routes that remain, in order: (A) key poses from CHECKED stills + Cascadeur AI inbetweening; (B) colour-suit video (one fighter solid red, one solid green; `Tools/footage/track_colour_suits.py` masks by hue - 3/4 skeletons right on a wrapped closed guard); (C) two-person motion models (G77 ranking them). Black/white suits rejected: brightness leaks into shadows/gloves/hair; hue survives lighting.

What was measured about generation:
- Text-to-video gets familiar shapes (mount, closed guard) and fails orientation/contact ones (north-south, knee-on-belly); **a checked still first fixes them**.
- Seedance 2.5 blocks shirtless/bare-fist studio stills as NSFW (refunded); cage + gloves + broadcast framing passes. Seedance 2.0 is cheaper (36/8 s) and accepted every fight prompt.
- The operator's **split-screen** idea tracks OPEN positions (mount side views 92.7/100%, swaps 5.8/3.6%) but not wrapped ones (guard 37-40%); overhead/end-on never separate bodies.
- Kimodo text-to-motion cannot produce a southpaw (0/16) - mirror orthodox clips instead.
- RamsterZ Full Mount (the only paired ground SKU anywhere) is ALREADY OWNED, 14/16 bound.

Codex (astra) twice passed every number while the render was wrong (flat closed guard, upright stance) - see [[feedback-open-the-output-before-the-gate]]. Posing to a checked image (C174) fixed both.

Reallusion CC5 trial + iClone 8 installed on **D:\Reallusion** (C: has 34 GB free). Trial FBX export is limited to **30 exports total**. iClone's Video Mocap is one actor per task, so it does not solve grappling - the operator was told not to buy iClone for that.

`codex queue --thread <id> --message` reaches a RUNNING Codex exec session (thread id = newest ~/.codex/sessions/<date>/rollout-*.jsonl). `cici.py open` used to ARCHIVE Dola chats (clicked a hover button) - fixed.

**Why:** these are the facts the next session needs so it neither re-proposes filming nor re-pays for the dead routes.
**How to apply:** S60 = one Character Creator fighter beside the old one; then animation routes A/B/C. Related: [[project-session-log]], [[project-higgsfield-mma-study]].

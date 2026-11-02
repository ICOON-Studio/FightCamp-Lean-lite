---
name: feedback-markup-board-review-loop
description: "operator reviews UI stills on the Markup Board on his Samsung monitor; open it in BRAVE (never Edge); apply each saved board, re-shoot, reopen"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 0e987d35-9c6c-417a-851c-c362eb5737a7
  modified: 2026-10-09T15:25:46.112Z
---

S186 working method for UI/HUD work: the operator marks the game's own stills with the Markup Board (`Tools/markup`, KEEP / CHANGE /
MOVE / WRONG marks + notes) and saves with **Ctrl+S**; each save is `Feedback/<date>-NN/README.md` + `marked.png`. He says
"see feedback 2026-10-09-NN" - read the README and open `marked.png` (marks are percent of the image, origin top-left; an arrow
is MOVE from tail to head). An UNSAVED board does not exist on disk (S186: "see feedback 06" twice found nothing) - say so.

**Why:** he judges by eye, wants to point at pixels, and wants each round back fast. Marks beat prose.

**How to apply:**
- Start the server `python Tools/markup/serve.py --no-browser` (port 8765); open on the Samsung (the 1920x1080 primary, DISPLAY1):
  `brave.exe --app=http://127.0.0.1:8765/?q=a.png,b.png --window-position=0,0 --window-size=1920,1080`; images are served from
  `previews/ui_s185/` (copy new stills there). **Never Microsoft Edge** (operator: "stop edge from popping up"; Edge is a
  Windows component - do not uninstall it, that is a system change). N / P / arrow keys change picture; marks stay per picture.
- Re-shoot on the GAME camera: `Tools\godot_hidden.ps1 ... --script tools/s64_career_walk.gd -- as_game hud2 plan=res://research/<plan> out=res://docs/previews/<dir>`;
  the walk tool has `hover [Node]`, `hover node:Name`, `untilnode Name|STEP|MAX` (S186).
- Look at the still yourself before sending it (text overflow, overlaps) - three of four rounds had a defect I caught only by opening it.
- Link: [[feedback-open-the-output-before-the-gate]], [[feedback-use-my-own-browser-panel]].

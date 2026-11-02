# The Cascadeur GUI route is open, and `auto_posing` is a live object in it

**Claude · 2026-09-21 · attempted on the operator's instruction ("try the cascadeur gui route")**

## WHAT THE RECORD SAID, AND WHY IT WAS WORTH RETRYING

C135 closed with **no verified held pose**. Its verdict was careful and correct: the scripting route
works for everything except the one thing we want — `AutoPosingTool` exposes only
`activate/add/deactivate/update`, `csc.tools.auto_posing` exports no helpers, and there is **no
documented API for setting ML controller targets or a paired pose solve**. Everything past that is
hand-keying, the route already closed, so Codex refused. Correctly.

But the verdict also recorded this, and it is the half that was actionable:

> *"The GUI route is UN-ATTEMPTED, not disproven: Codex's Computer Use returns `apps:[]` with no
> targetable window and the native APIs are missing in exec mode, which is a limit of CODEX'S
> harness, not Cascadeur's. CLAUDE CAN DRIVE WINDOWS GUIs DIRECTLY and is the untried driver."*

## WHY CODEX SAW NOTHING, MEASURED RATHER THAN GUESSED

`Get-Process` showed Cascadeur alive as **PID 31348 with an empty `MainWindowTitle`**. An
`EnumWindows` sweep filtered to that PID returned **zero top-level windows** — not a hidden window,
not an unfocusable one: none at all. That process was a genuinely headless instance left over from
the C135/C137 scripting runs, about two hours old.

**And Cascadeur is SINGLE-INSTANCE.** A fresh `Start-Process` against `cascadeur.exe` did not create
a second process — it handed off to the squatter and exited, leaving `MainWindowHandle = 0`. So for
as long as that headless instance lived, **no GUI could ever appear**, and every further attempt
would have looked like "Cascadeur has no GUI" rather than "something is already holding the slot".

**The fix was to kill PID 31348 and relaunch.** The GUI came up immediately: PID 43296,
`MainWindowTitle = "Cascadeur"`, window handle 265262, maximised to 1936x1048.

## WHAT IS DRIVEABLE, DEMONSTRATED

- **Window control**: `ShowWindow` (maximise) and `SetForegroundWindow` both work.
- **Screen capture**: `Graphics.CopyFromScreen` over the window rect returns the real UI.
- **Mouse input**: `SetCursorPos` + `mouse_event` clicks land. The trial modal was dismissed by a
  click on its close box, and the sample project was opened by a double-click on its card.
- **State readback**: the captured frame is legible enough to read the menu bar, the Outliner rows
  and the timeline, so the loop *act → capture → read → act* is closed.

The app reports **version 2026.2.2**, signed in, **"Trial — 7 days left"**, which agrees with the
Paddle portal's **Sep 28, 2026** billing date (our own roadmap said the 27th; the portal wins).

## THE FINDING THAT MATTERS

Opening `C:/Program Files/Cascadeur/samples/Backflip_animation.casc` (124 frames) shows an Outliner
containing:

| name | type | track |
|---|---|---|
| `head__m_01` | Mesh Obj | Torso |
| **`auto_posing (0)`** | **Tool** | **None** |
| `arm__agl_16_m__pants` | Mesh Obj | Torso |
| `arm__agl_16_m__body` | Mesh Obj | Torso |
| `Rig(0)` | Basic | Torso |
| `MeshObject(1)` / `MeshObject(0)` | Mesh Obj | Box |
| `Armature` | Transform | Torso |

**`auto_posing` is a first-class scene object of type `Tool` in the GUI** — the same subsystem whose
controller targets the scripting API would not expose.

## WHAT THIS DOES AND DOES NOT PROVE

**PROVEN: reachability.** The GUI can be launched, focused, clicked, captured and read from here,
and AutoPosing exists as a live object inside a real scene. The blocker C135 recorded was a
property of Codex's harness plus a squatting headless process, exactly as its verdict suspected.

**NOT PROVEN: capability.** Nothing here has produced a pose. Whether AutoPosing can be driven
through the GUI to author or repair a **paired** pose — two bodies, in contact, physically
plausible — is untested, and that is the only question the subscription actually turns on.

**AND IT IS NOW THE RIGHT QUESTION TO ASK,** because of a result from the same night: the C140
control experiment proved the paired-film join defect is a **pose mismatch**, not a transform
error. Chaining the beat transforms moved the joins by −0.000 / −0.000 / −0.001 / −0.052 / +0.016 m
— nothing — because `_align_pair` already best-fits a rigid transform over 360 yaw candidates and
measures the residual *after* it. A residual no rotation or translation can remove is a difference
in body configuration. **Authoring plausible transition poses is precisely what AutoPosing is for.**

## THE DECISION, AND ITS CLOCK

The trial bills **EUR 37.66 on 2026-09-28**. Nothing has been subscribed, unsubscribed or paid, and
nothing will be by an agent — that is the operator's alone.

**The bounded next step is one session:** drive AutoPosing through the GUI on a two-body scene and
try to produce one plausible contact pose. Pass, and it is the tool for the ground work and worth
EUR 37.66/month. Fail, and it is cancelled having cost nothing. There are seven days.

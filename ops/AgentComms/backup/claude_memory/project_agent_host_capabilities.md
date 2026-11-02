---
name: project-agent-host-capabilities
description: Cursor cannot see the local drives; Claude CAN screenshot and drive installed games; the full ViGEm/XInput rig and its gotchas
metadata: 
  node_type: memory
  type: project
  originSessionId: 547a59a5-a62e-4f36-b301-7660c40b8175
  modified: 2026-09-21T15:05:29.244Z
---

Established 2026-09-09 while tearing down installed games for the fight stage.

**Cursor runs on a host WITHOUT the local drives.** On U23 it searched for
`D:/SteamLibrary/steamapps/common/TEKKEN 7/` and `tkdata.bin` and found
nothing, though both exist on this machine. So **never assign Cursor a task
that depends on reading an installed game, a local disk path, or anything
outside the repo checkout.** It correctly pivoted to documented sources and
said so rather than inventing findings, but the task was partly unassignable.
Local-machine inspection belongs to Claude (Codex's host access is still
unverified - check before relying on it).

## Claude can drive installed games end to end. The working rig:

**Capture.** `Graphics.CopyFromScreen` grabs the virtual screen (3280x1080
here) or one window via `GetWindowRect`; save PNG, read back with the Read
tool. Scripts in the scratchpad: `grab.ps1` (focus + window capture +
downscale), `crop.ps1` (fractional region + upscale, for reading HUD text),
`click.ps1`, `key.ps1`, `pad_daemon.py`, `watch_corner.ps1`.

**Input, in order of what actually works:**
1. `SendKeys` - **never works on Unity/Unreal.** They read raw input, not
   window messages. Do not bother.
2. `keybd_event` with `KEYEVENTF_SCANCODE` - reaches most games.
3. **Gamepad-only games need ViGEm.** `winget install ViGEm.ViGEmBus` (needs
   admin; installs clean and silent) plus `python -m pip install vgamepad`.

**THE XINPUT SLOT TRAP, which cost an hour.** A game's menu obeys **XInput
slot 0 alone**. A physical pad already on slot 0 makes a ViGEm virtual pad
(slot 1) completely inert - inputs are delivered and silently ignored, with no
error anywhere. **The physical controller must be UNPLUGGED**;
`Disable-PnpDevice` on its USB parent fails with "Generic failure" while in
use, and disabling only its HID child does not free the slot. Check slots with
`XInputGetState(0..3)` before assuming input is broken.

**The virtual pad must be held open by a LONG-LIVED process.** One process per
command makes the game show "Controller Disconnected" and pause between every
input. Pattern that works: a daemon holding one `VX360Gamepad`, polling a
command file, truncating it after each batch.

**Background PowerShell launched from Bash is blocked by execution policy**
(`running scripts is disabled on this system`) and fails silently into its log.
Launch long watchers through the PowerShell tool with `run_in_background`
instead, not via `powershell -NoProfile` from Bash.

**Catching a transient screen.** Timed waits miss short screens (a between-
rounds corner drifts against wall time). What works: poll a small region where
the panel appears and trigger a full-resolution capture on a **brightness
change** - the corner card read avg luminance 11-16 against 50-140 mid-round.

## Screen capture and pose, 2026-09-13 (R144)

* **`dxcam` (DXGI Desktop Duplication) holds 58.6 fps at 1080p under load; GDI (`mss`, `CopyFromScreen`)
  managed 29 full-screen and 53 for a 960x800 region.** `dxcam.create(output_idx=1)` is the second monitor
  (1360x768). Crop and downscale at grab time and stream JPEGs from a writer thread, or 60 fps of RAM runs out.
* **Pose: MediaPipe 1.0.1** (`mp.tasks.vision.PoseLandmarker`, VIDEO mode) is installed; the model
  `pose_landmarker_full.task` (9.4 MB, storage.googleapis.com) must sit beside the script - not in the repo.
  Validated on our own `docs/previews/s4a_hips` renders. Rig and README: `Tools/r144_capture`.
* **The in-app Browser pane does not render while hidden** (screenshots and scrolls time out): read with
  `get_page_text` / `find`. A YouTube video the operator opens plays in THEIR Chrome on the primary monitor:
  check `WindowFromPoint` is chrome before one click on the player; move the cursor off it afterwards.

## Watching YouTube to learn moves (2026-09-14, operator: "watch YouTube videos and learn the moves")

* **Neither browser plays video for Claude:** the in-app Browser pane is only ~305x246 px (viewport emulation just
  scales it down, zoom is unsupported), and in Claude-in-Chrome the tab reports `document.hidden` (the window is behind)
  so YouTube never decodes (readyState 0). Search results still read fine from the DOM (fetch `ytInitialData`).
* **What worked:** `pip install --user yt-dlp` (2026.8.19; `--js-runtimes node`), download a NAMED batch the operator
  approves (480p, video only, ~15 MB each), MediaPipe on every frame (36-39 fps, 3 processes in parallel), measure in
  torso lengths, draw skeletons on onset/peak/back frames to validate, then DELETE the videos and the model ("But delete
  them after you do your work"). The scripts lived in that session's scratchpad - rebuild them under `Tools/r144_capture`
  rather than from scratch. Result: `research/V1_BOXING_FROM_VIDEO.md`.

## Driving Unity Hub / Editor — 2026-09-20: Claude can do ALL OF IT BUT ONE CLICK

On 2026-09-20 Claude downloaded a 452 MB asset (MMA Arena) this way. The operator dismissed the
admin dialog on the first run; Claude then proved it can dismiss it itself (see the dialog bullet
below), so the whole route is automatable. The working route:

Unity Hub (`Get-Process 'Unity Hub'`, front it with `SetForegroundWindow`) -> **Projects** ->
**`My project`** (a URP sample at `C:\Users\user\My project`, Unity 6.6; the old `AssetFetch`
entry is still listed as "Project not found") -> wait ~2 min, the title goes from "Opening
project..." to the real one -> Editor toolbar **Asset Store -> My Assets** -> select -> **Download**.

* **THE "Administrator Privileges Detected" DIALOG IS STILL THERE AND IT BLOCKS THE OPEN — but
  CLAUDE CAN CLEAR IT.** Claude first wrote that the dialog had gone; the OPERATOR CORRECTED THAT
  ("no, i clicked on it, it is still there") — they had dismissed it while Claude polled the window
  title, which is why the title looked like it advanced on its own. Then tested properly:
  * The dialog is its own window titled **"Administrator Privileges Detected"**, 372x200. Find it by
    enumerating the Unity process's windows (EnumWindows filtered by pid).
  * **"Ignore Warning" is at the dialog's rect + (306, 173)** — on this display it lands at
    1080,613. `mouse_event` reaches it. R142's rule stands: "Restart as Standard User" is the wrong
    button.
  * **YOU MUST LAUNCH THROUGH UNITY HUB.** Launching `Unity.exe -projectPath <p>` directly and then
    dismissing the dialog makes Unity EXIT every time (tested twice, it dies within ~7 s of the
    click). Hub -> Projects -> the project row, then clear the dialog, and it opens fine — verified
    end to end 2026-09-20.
  * The status-bar line "Unity is not designed to run with Administrator privileges" is what remains
    AFTER dismissal. Never read it as evidence the dialog did not appear.
* **The Package Manager opens as its OWN top-level window**, not inside the Editor frame, and it
  landed on the LEFT monitor at negative x. Enumerate the Unity process's windows (EnumWindows by
  pid) to find it rather than screenshotting the Editor and wondering where it went.
* Clicks work with `mouse_event` (SetCursorPos + 0x02/0x04). The "SendKeys never works on Unity"
  note still applies to a running GAME, not to the Editor's UI.
* **There is NO web download.** assetstore.unity.com's My Assets page has no download control, its
  `Download_MyAssetsController` bundle calls no download endpoint, and the legacy
  `/api/en-US/account/downloads/search.json` is 404. The Editor is the only route. A package id is
  readable from the page as `data-test="open-asset-<id>"` (MMA Arena = 330811).
* Downloads land in `%APPDATA%\Unity\Asset Store-5.x\<Publisher>\<Category>\<Name>.unitypackage`
  - poll for the file rather than watching the progress bar.
* A `.unitypackage` is a tar.gz; read `*/pathname` members to list its contents without extracting.

Superseded advice follows.

## Driving Unity Hub / Editor (2026-09-13, R142) — mostly: let the operator click

* **This Windows session runs everything elevated**, so the Editor shows "Administrator
  Privileges Detected". **"Restart as Standard User" LOOPS** (it relaunches just as
  elevated). Only "Ignore Warning" gets past it.
* The Editor launched with no project **exits silently**. The old fetch project
  `C:\Users\user\UnityAssetFetch\AssetFetch` was deleted and the Hub lists it as "Project
  not found", so Package Manager needs a new project first.
* **The operator is often using the same desktop** (a stream on the primary monitor).
  A click, Ctrl+A and typed text landed in their browser because focus had moved and
  the Hub had been dragged. After that, the auto-mode classifier **blocked all further
  desktop input**. Rule: check foreground PID before every SendKeys and re-read the
  window rect before every click. For a one-off download, **ask the operator to press
  Download**. It took them one minute.
* A `.unitypackage` never needs Unity to READ: `tar -xzf`, `pathname` + `asset` per GUID
  folder, `FBXDocument` reads the FBX headless.

## The Cici / Dola desktop app is a DRIVEABLE AGENT — 2026-09-21

The operator pastes recipes from a "Dola" chat. That app is **Cici**
(`%LOCALAPPDATA%\Cici\Application\app\Cici.exe`), a Chromium shell
(`--annotation=prod=Dola`), so `--remote-debugging-port` exposes its renderer to
CDP exactly as Grok Bot's does. `Tools/cici/cici.py` is the channel, **port 9333**
(Grok Bot owns 9222 and both run from this console): `launch / status / chats /
open / read / attach / send`, plus `--dry-run` that stages text and stops.

* **The app must be started BY `launch`.** Chromium is single-instance per
  user-data-dir, so relaunching while it is up hands off to the live instance and
  silently drops the flag. **Closing its window is not enough** — it stays
  resident in the tray with ~12 processes and must be fully quit first. The
  auto-mode classifier blocks force-killing it, so ask the operator to quit it.
* **The composer is tiptap/ProseMirror.** Assigning `innerText` leaves the editor
  model empty and the send button disabled; text goes in as a `paste` event
  carrying a DataTransfer.
* **Attachments accept `.md .txt .pdf .csv .docx .xlsx .pptx .epub` and images —
  NOT `.py`, `.glb` or `.fbx`.** Briefs go over as files; code comes back as text.
* **Take the LAST substantial `<pre>`, not the biggest**, when extracting code —
  picking the biggest re-runs an older version and produces byte-identical
  "results" that look like a fix which changed nothing.
* **Everything it ships must be run before it is believed.** Its first delivery
  came with a seven-tick validation checklist and had never been executed: it
  died at export, both fighters were 0.596 m tall, one was upside down, and the
  "gripping" hands were 1.229 m apart. The one right number was right *by
  construction*. `Tools/cici/measure_delivered_pose.py` is the harness.

## Which installed games are worth the time

* **Undisputed** (Steam 1451190, E:, Unity/IL2CPP, 17.4 GB) - **the reference.**
  Gamepad-gated at the title. `SIDE SELECT` offers `X = AI only fight`, which
  is how to reach live-bout screens without having to box. Findings are in
  `research/R85R_UNDISPUTED_HUD.md`, not here.
* **NBA 2K26** (Steam 3472040, E:, 99 GB) - **code and data are closed:** the exe carries an anti-tamper
  protector's `.arch` / `.xcode` / `.srdata` sections plus EasyAntiCheat and Quago; data is Oodle-compressed
  archives. Never unpack or disassemble it. Its value is watching it (offline modes only) and its published
  blogs (K34). First launch builds shaders on 12 threads and overheated the PC - see [[project_pc_thermal_limit]].
* **MMA Championship** (1825010, E:) - **worthless to us.** Online arcade
  brawler, free-roam hub, gem counter, no bout structure, no HUD, no judges.
* **Tekken 7** (D:) - 55 GB of UE4 paks; do not unpack. `tkdata.bin` is a
  290 MB opaque blob. Its value is the documented frame model only.
* **WMMA5** (`D:/Databases/Default/WMMA5.mdb`) - 168 tables, readable with the
  `access-parser` pip package (installed). The Access ACE/ODBC provider is NOT
  installed and is not needed. `parse_table('tblFighter')` returns one bogus
  column - a known parser limit, not a bug to chase.

Related: [[feedback-check-research-record-first]],
[[project-cursor-pushes-to-branches]], [[feedback-drive-qwen-and-grok-to-delivery]].

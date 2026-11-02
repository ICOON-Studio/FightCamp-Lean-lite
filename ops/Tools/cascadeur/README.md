# Driving Cascadeur from this checkout

Cascadeur 2026.2 is scriptable **from inside the running GUI**. That is the whole
point of this folder: C135 closed with "no documented API for a paired pose solve"
and S29 could only prove the window was clickable. Neither found the channel, and
it ships with the app.

## Open the channel (once per Cascadeur launch)

For unattended animation work, use **`python Tools/cascadeur/ensure_server.py --hidden`**.
It launches both the persistent GUI and forwarded bootstrap on
`WinSta0\FightCampCascadeur` via `Tools/cascadeur_hidden.ps1`; it never switches
the input desktop. A live in-app Win32 desktop assertion verifies every reuse.
An existing instance without a verified server is refused. Cold-start bootstrap
requests are retried on the same hidden desktop. Application/profile access may
require the approved application-access context on a restricted Windows host.

`animsource1/` contains the native MetaHuman pipeline and export-packaging repairs;
see `research/ANIMSOURCE1A_DIGEST.md` for the exact source preparation,
per-move authoring, physics and raw-GLB review sequence. Recycle only the task's
verified, saved hidden instance between populated scene loads: Cascadeur can
deadlock replacing a scene while its Physics Assistant worker is active.

**NO CLICK IS NEEDED ANY MORE — 2026-09-22.** This file used to say the only way
in was the menu, and that put the operator in the loop for every session:

```bash
python Tools/cascadeur/ensure_server.py
```

It launches Cascadeur if it is down, starts the script server, verifies
`/health`, and is idempotent — run it as often as you like. **It works because
`cascadeur.exe --run-python-code <code>` executes INSIDE THE LIVE APP**; the pid
that code prints is the running instance's, so the server can be started over
the same channel it goes on to serve. Proven end to end: file write → matching
pid → `start(scene)` → port 8765 LISTENING owned by that pid → `/health` ok →
`csend.py` returning `untitled.casc`.

**TWO THINGS THAT COST A SESSION IF YOU GUESS.** `start` is
`start(scene, host, port)` — a bare `start()` raises `TypeError: missing 1
required positional argument: 'scene'`. And **`--run-python-code` SWALLOWS THE
TRACEBACK**: the launcher prints `Application finished with exit code 0` even
when your code raised, so a clean launcher log means *nothing*. Write the
traceback to a file and read it, which is what `ensure_server.py` does.

The manual route still exists and still works, for a human at the machine:
**`Scripts > MCP > Start script server`**.

It then listens on `127.0.0.1:8765`:

- `GET  /health`
- `POST /run` with `{"code": "..."}` — runs Python **in the live app**, with
  `scene`, `csc` and `app` already in scope, on the next `scene_idle`.
- `POST /mcp` — the same thing as an MCP tool (`.mcp.json` declares it as the
  `cascadeur` server).

Cascadeur's own docs for it are at
`C:/Program Files/Cascadeur/resources/scripts/python/scripts/mcp/script_server/README.md`
and `.../python/AGENTS.md`. The full class reference is
`.../python/samples/api_document.py` (5,413 lines).

```bash
python Tools/cascadeur/csend.py -c "print(app.current_scene().name())"
python Tools/cascadeur/csend.py Tools/cascadeur/dump_rig.py <workdir>
```

`csend.py` injects `WORKDIR` as a global, so a script reads and writes its JSON
beside the caller instead of carrying an absolute path.

## The pieces

| file | what it does |
|---|---|
| `csend.py` | send a script to the live app; prints its output, fails loudly |
| `casc.ps1` | PowerShell GUI driver — focus, screenshot, click, drag, wheel, keys, list modal windows |
| `dump_rig.py` | every controller and joint world position -> `RIG.json` (centimetres) |
| `apply_pose.py` | set controller world positions from `POSE.json`, then report asked-vs-got per controller |
| `build_clinch.py` | derive a two-man collar-and-elbow clinch from the rig's OWN rest pose -> `POSE.json` |
| `measure_contacts.py` | closest joint pairs between the two fighters, in METRES -> `MEASURE.json` |

## Five things that cost S30 a session each

1. **Cascadeur is single-instance.** A leftover headless process swallows every
   `Start-Process` and you get `MainWindowHandle = 0` for ever. `EnumWindows`
   filtered to its PID returning zero top-level windows is the tell; kill the
   squatter first.
2. **Two characters in one scene:** `File > Import > Import Scene To Current...`.
   The second copy is namespaced `character1:` on every one of its 289 objects,
   which is also how you tell the two rigs apart in script.
3. **Move a character by its CONTROLLERS, never by its joints or its mesh.**
   Writing `global_position` on the joints mangles the skin (the arms stretch
   across the room) because the rig re-solves from the controllers anyway.
   Transform the `Point` and `Limb Direction` objects — 47 of them per character
   — and the joints, the skin and the mesh all follow exactly.
4. **Do not write a controller the rig solves.** Set `hand_MainPoint_*` and the
   elbow, its additional point and its limb direction follow on their own. Write
   them too and you are fighting the solver.
5. **`scene.modify_update` returns True having done nothing** if you forget
   `scene_updater.run_update(<the data ids you touched>, frame)`.

## What AutoPosing did and did not do (measured, S30, 2026-09-21)

`AutoPosingTool` is reachable live —
`app.get_tools_manager().get_tool("AutoPosingTool").editor(app.current_scene())`
gives the real `csc.tools.AutoPosingTool` with `activate/add/deactivate/update`,
and `Settings > Hotkeys Window > AutoPosing Tool` lists an **Auto Posing**
function (unbound by default; S30 bound it to `Ctrl+Alt+P` and the app log
confirms `corresponding action "AutoPosingTool.AutoPosing"` fires).

**It did not produce a whole-body ML solve.** Dragging a hand controller 37 cm
moved the shoulder 2.8 cm and the chest, spine, pelvis and feet 0.00 cm, and that
was true on both sides of the toggle. `ap.update(session)` runs, returns cleanly,
and silently discards a controller value written in the same modify block.

So pose through the controllers and measure the result. That works, it is exact,
and it is what `build_clinch.py` does.


## ANIMSOURCE1B native boxing sources

Continue the 1A quick rig; do not retarget or replace its skeleton. The native
source, RIG.json, raw exports and .casc scenes remain local and ignored.
`python Tools/cascadeur/animsource1/produce_move.py guard_pose` saves the shared
orthodox guard (including `guard_pose.casc`). Review its side/front/top stills
before producing the jab, then review/fix the jab before the other three moves.
`produce_move.py` checks the PC watchdog before heavy stages, uses one verified
hidden Cascadeur instance, runs the real AutoPhysics toolbar actions, and
requires actual solver-completion evidence in `physics_1b.json`.

`animation_only.py` removes render payloads after 1A normalization, deduplicates
identical accessors without changing their bytes, and retains all 341 native
joints and one animation. Per-move receipts bind the source, raw export and
final animation-only hashes. Clip import settings preserve immutable bone
tracks and disable AnimationPlayer optimization/compression. The default
optimizer blurred snap returns and introduced over 1 cm of uppercut foot drift;
normal imported playback is independently gated after this settings repair.

Run `powershell -NoProfile -ExecutionPolicy Bypass -File
Tools/cascadeur/animsource1/probe.ps1 -Sheets` for private frame sheets, or omit
`-Sheets` for the headless shape gate. The helper always selects the absolute
non-console Godot 4.7.2 executable, checks parse/runtime errors, waits on watchdog
RED and routes captures through `Tools/godot_hidden.ps1` on its hidden desktop.
Use `-Moves guard_pose -Sheets` for the three guard stills, `-Imported` for the
normal ResourceLoader path, and `-Clips <directory> -Out <directory>` for the
retained 1A negative witness. Both paths apply unchanged native bone tracks to
mh_boxer_01; the receiver is the distinct mh_boxer_02 in the shared guard.

Contact remains frame 8 and final guard frame 20 at 30 fps. Straights hold the
guard through frame 4, extend in four frames and retract in three. Uppercut rise
is measured from its chest-level chamber (frame 3), rather than from the
jaw-level guard; its last-40-percent forearm, dip, continuity and planted-foot
rules are retained. See ANIMSOURCE1B_DIGEST.md for the full final evidence.

# Two bodies, in contact, authored in Cascadeur - and the channel that made it possible

**Claude · S30 · 2026-09-21 · the operator asked for the paired pose by name, with seven days on the trial**

## THE ANSWER

**PASS.** Two rigged bodies stand in one Cascadeur scene in a collar-and-elbow
clinch: heads passing right-to-right, one man's hands at the other's nape, the
other's hands gripping his upper arms, both men's feet flat on the floor.
`research/S30_PAIRED_POSE.png` is the picture; the numbers are below and in
`S30_MEASURE.json`.

**But the thing that made it work is NOT the thing the stage expected**, and that
distinction is the whole value of this session, so it is stated before the pose.

## THE FINDING: CASCADEUR SHIPS AN AUTOMATION CHANNEL, AND NOBODY HAD FOUND IT

**`Scripts > MCP > Start script server`.** It listens on `127.0.0.1:8765` and
`POST /run {"code": ...}` executes Python **inside the running GUI**, with
`scene`, `csc` and `app` in scope. Its own documentation is in the install:
`resources/scripts/python/scripts/mcp/script_server/README.md`, an `AGENTS.md`
written for exactly this, a `.mcp.json` declaring it as an MCP server, and a
5,413-line `samples/api_document.py` class reference.

This retires the premise both previous attempts were working under:

- **C135** concluded "no documented API for setting ML controller targets or a
  paired pose solve", which was true of the *headless* `exec` mode it could
  reach. With the GUI alive the same API is a different thing: the live tools,
  the selection, the viewport camera, the undo stack and the file dialogs are
  all there.
- **S29** proved the window could be clicked and captured. It did not need to be:
  clicking is now the fallback, not the method.

Everything below was done through that channel plus `Tools/cascadeur/casc.ps1`
for the four things that genuinely need a mouse (the menus and the file dialog).

## THE POSE, AND THE NUMBERS BESIDE THE PICTURE

Two copies of Cascadeur's own rigged sample character (`samples/Cascy.casc`,
66 joints, 47 controllers, 1.70 m tall), brought into one scene with
`File > Import > Import Scene To Current...`. The second is namespaced
`character1:` on all 289 of its objects.

Distances are between JOINT CENTRES, in metres, measured by
`Tools/cascadeur/measure_contacts.py` over all 66x66 joint pairs:

| | metres |
|---|---:|
| **closest joint pair of the whole scene** — A's right arm ↔ B's left hand | **0.054** |
| A's left hand ↔ B's neck (the collar tie) | 0.074 |
| A's right hand ↔ B's neck | 0.098 |
| B's right hand ↔ A's left upper arm (the grip) | 0.078 |
| B's left hand ↔ A's right upper arm | 0.107 |
| head ↔ head | 0.223 |
| chest ↔ chest | 0.420 |
| hip ↔ hip | 0.557 |
| lowest joint, each man (toe) | 0.028 above the floor |

A hand is about 0.04 m thick and an upper arm about 0.05 m in radius, so a
0.054 m centre-to-centre distance is **surfaces in contact, not near-miss**, and
the same reading for the heads (0.223 m apart, head about 0.17 m wide) is two
heads beside each other rather than through each other. Both men's lowest joint
is at 0.028 m, which is exactly the toe height of the rig's own rest pose: nobody
floats and nobody sinks.

**Nothing about the body is invented.** The reach the pose is built against is
the rig's own — upper arm 26.4 cm plus forearm 23.1 cm, measured off the rest
pose — and `build_clinch.py` refuses a target further from the shoulder than
that. All four arms land inside it (38.9, 33.2, 22.1, 22.1 cm).

The pose is 78 controller world positions, `S30_POSE.json`, generated from four
readable numbers: hips 56 cm apart, each torso leaning 18 degrees over its own
hips, hips sliding 4 cm back and dropping 6 cm into the knees, and each head
passing 12 cm to the other man's right.

## AUTOPOSING: WHAT IT DID, MEASURED, NOT GUESSED

The stage's own question was whether AutoPosing can be driven to author the pose.
It was reached, it was fired, and **it did not do the thing its name promises.**

- The live tool is there: `get_tool("AutoPosingTool").editor(scene)` returns a
  real `csc.tools.AutoPosingTool` with `activate/add/deactivate/update`, and the
  viewport reports `mode_visualizers = ViewportMode.AutoPosing` by default.
- `Settings > Hotkeys Window > AutoPosing Tool` lists an **Auto Posing** function
  with no hotkey. Bound to `Ctrl+Alt+P`, the app log confirms
  `Shortcut "Ctrl+Alt+P" triggered, corresponding action "AutoPosingTool.AutoPosing"`.
- **A hand drag of 37.2 cm moved the shoulder 2.8 cm and the clavicle 0.16 cm,
  the chest 0.01 cm and the pelvis, head, other hand and both feet 0.00 cm.**
  That is a two-bone IK chain, not a whole-body solve. Repeating it on the other
  side of the toggle gave the same shape: a 19.8 cm hand move, 5.5 cm at the
  shoulder, 0.01 cm at the pelvis.
- `ap.update(session)` runs, returns cleanly, and **silently discards** a
  controller value written in the same modify block — so it is holding state, but
  nothing exposed writes a target into it.

**So the ML pose model is not reachable from here, and it did not need to be.**
The rig's own IK plus 78 exact controller positions produced the pose, and unlike
a dragged ML solve, that pose is a file that reproduces byte for byte.

## WHAT THIS IS WORTH, AND THE MONEY

The trial bills **EUR 37.66 on 2026-09-28** (the Paddle portal's date). Nothing
has been subscribed, unsubscribed or paid, and nothing will be by an agent.

**The recommendation is KEEP IT, conditional on one intention:** that we author
the five ground and clinch holds we do not own film for. S6c ruled `cage_clinch`
"a PURCHASE: a clinch film", and the breadth gap named for S31 is side control,
guard, half guard, back control and the clinch — all of them **held positions**,
which is precisely what a paired pose is. R144 line 3 priced authoring-from-
nothing at 6-10 h of scripting with the posing left deliberately unpriced; that
scripting is now done and in `Tools/cascadeur/`, and the posing cost has a real
number against it for the first time: this clinch is four parameters and one
apply, and a second hold is under an hour.

If we are not going to author holds, cancel it. The answer is not "the tool is
impressive", it is "we have five specific positions to build and this builds
them".

## REPRODUCE IT

In Cascadeur: dismiss the Home screen, then `Scripts > MCP > Start script server`.

```bash
D=/c/Users/user/AppData/Local/Temp/s30 && mkdir -p $D
python Tools/cascadeur/csend.py -c "print(app.get_data_source_manager().load_scene('C:/Program Files/Cascadeur/samples/Cascy.casc'))"
# then in the GUI: File > Import > Import Scene To Current... the same Cascy.casc
python Tools/cascadeur/csend.py Tools/cascadeur/place_second.py     $D
python Tools/cascadeur/csend.py Tools/cascadeur/dump_rig.py         $D
python Tools/cascadeur/build_clinch.py                              $D
python Tools/cascadeur/csend.py Tools/cascadeur/apply_pose.py       $D
python Tools/cascadeur/csend.py Tools/cascadeur/measure_contacts.py $D
```

**This was run end to end from a COLD START** - Cascadeur killed, relaunched,
Home screen dismissed, server started, scene built - and every number in the
table above came back identical to four decimal places, with the rest-pose guard
reporting `fighter B sits 78.0 cm downrange, rigid to 0.00 cm`. The pose is a
file, not a sequence of drags, which is the difference between this and hand
animation.

**One crash is worth recording:** calling `dsm.close_scene()` on a tab that is
not the current one, from the script server, took the whole application down
mid-call (`ConnectionResetError` at the client). Close tabs by hand, or do not
close them.

`Tools/cascadeur/README.md` carries the five traps that cost this session the
most time - chief among them that a character is relocated by its **controllers**
and never by its joints or its mesh, which mangles the skin into stretched arms
across the room, and that Cascadeur is single-instance so a leftover headless
process makes the GUI unreachable for ever.

The scene itself is 6.1 MB and is not committed; it was sent to the operator, and
the four commands above rebuild it exactly.

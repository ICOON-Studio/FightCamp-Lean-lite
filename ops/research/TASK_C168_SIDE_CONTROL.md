# C168 — AUTHOR SIDE CONTROL IN CASCADEUR, AND PROVE IT IN THE GAME

**Owner:** codex. **Model: `gpt-6-astra`** (operator ruling 2026-09-21 — astra
for 3D animation work; this authors motion on a skeleton).
**Effort: MEDIUM.**

**Tier: parse gate on every touched `.gd`, then `s31_contact_probe.gd` on YOUR
new key, then `--only clip`, `--only pair`, `--only grapple`, then the control
arm. NO FULL SUITE** — it is Claude's, once, at integration.

## THIS IS THE FIRST CLIP OF THE BATCH, AND THE BATCH IS THE POINT

**376 of 534 motion techniques have no clip.** Cascadeur Pro is kept and paid
for so we can author what cannot be bought — R144 closed every purchase line:
no paired BJJ positional SKU exists on Fab, the Unreal Marketplace or the Unity
Asset Store, and the two packs the operator checked on 2026-09-22 are standing
striking with zero ground work.

The commitment the operator accepted names five holds in order: **the clinch
(done, S31), then SIDE CONTROL, guard, half guard, back control.**

**Two blockers stood in front of this and both fell today:**

1. **The arms did not arrive.** C167 fixed it — `att_lhand_to_vic_neck` went
   **545% → 15%**, because `SILHOUETTE_SEGMENTS` asks for `Chest→UpperChest`
   and the Cascadeur rig has no `UpperChest`, so the synthetic joint fed a
   **zero-length source segment** into the silhouette correction. A clip
   authored today keeps its contacts.
2. **Cascadeur needed a human to click `Scripts > MCP > Start script server`.**
   It does not any more: **`python Tools/cascadeur/ensure_server.py`** launches
   the app, starts the server and verifies `/health`. Idempotent. Run it first.

**So author ONE hold, end to end, and prove it with the same instrument the
clinch was proved with.** Not four holds. The second one is a separate task
written against your numbers, and an unbounded animation run on astra has
already burned a 5-hour limit here with nothing committed.

## WHAT SIDE CONTROL IS, FOR THE POSE

Top man **perpendicular** across the bottom man's chest, chest-to-chest, hips
low and off to the side. The near arm is an **underhook** or a **cross-face**;
the far arm controls the near hip. The bottom man is **supine**, framing with
forearms against the top man's neck and hip. **Both men are on the mat** — this
is the first GROUND hold this project has authored, and it is the half that the
clinch did not exercise.

**DERIVE THE POSE FROM THE RIG'S OWN REST, NEVER FROM TYPED-IN COORDINATES.**
`Tools/cascadeur/build_clinch.py` is the pattern and it is the reason the clinch
worked: it derived a two-man collar-and-elbow from the rig's own proportions, so
the numbers scale instead of being a guess about one body. **S31's first hour
was lost to exactly this** — the clinch was first authored at 0.557 m hip-to-hip
and that turned out to be 0.15 m below the closest approach anyone has observed
in footage, so it was retired. A number you choose is a number you will retire.

## THE STEPS

1. **`python Tools/cascadeur/ensure_server.py`**, then confirm with
   `python Tools/cascadeur/csend.py -c "print(app.current_scene().name())"`.
2. **Two characters in one scene:** `File > Import > Import Scene To Current...`
   — the second copy is namespaced `character1:` on every one of its 289
   objects, which is also how you tell the two rigs apart in script.
3. **Author the pose through the CONTROLLERS**, never the joints or the mesh.
   Write the `Point` and `Limb Direction` objects (47 per character) and the
   joints, skin and mesh all follow. Writing `global_position` on joints mangles
   the skin — the arms stretch across the room — because the rig re-solves from
   the controllers anyway.
4. **Measure what you actually got:** `Tools/cascadeur/measure_contacts.py`
   gives the closest joint pairs between the two fighters in METRES. **Those
   measured figures become the authored contract** — do not write down what you
   intended.
5. **Give it life.** The clinch got four seconds. A hold is not a freeze; it
   breathes and shifts. Keep it short and keep it a hold.
6. **Export two single-actor GLBs**, `<Key>_Att.glb` and `<Key>_Vic.glb`, to
   `Godot/assets/anim/audition/cascadeur/`. `Tools/cascadeur/export_pair.py` is
   the path.
7. **Bind it.** One entry in `FightClipBinding.PAIRED_BINDINGS`, shaped exactly
   like `mma_dirty_boxing` at `:2018` — `pair_key`, `att`, `vic`, `start_s`,
   `end_s`, `content_s`. Pick the technique id from the unbound grapple ids;
   **say in the digest which id you chose and why**.
8. **Prove it in the game** with the contact probe on your own key.

## THE GATE — A CEILING, NOT A TARGET

**Every contact you declared in step 4 must read 30% drift or better through
`s31_contact_probe.gd` on your key.** If you land lower, say so and push.

**THE PROBE'S `AUTHORED` TABLE IS HARDCODED TO THE CLINCH** (`:33`). You will
need it to take your key's contacts too. **Extend it; do not replace the
clinch's row and do not change what the probe MEASURES** — the clinch's numbers
are a regression control and they must still read what they read today.

**If you cannot reach 30%, that is still a delivery.** Commit the clip, the
binding, the real numbers and a written account of which part of the chain lost
them. **A measured negative with the cause narrowed beats a pose tuned until the
number passes** — and tuning the POSE to fix a RETARGET defect is fixing the
fixture instead of the engine.

## THE CONTROL ARM — NON-NEGOTIABLE

```
python Godot/tools/run_tests.py --only clip
python Godot/tools/run_tests.py --only pair
python Godot/tools/run_tests.py --only grapple
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/pair_gap_report.gd -- grapple_control
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s31_contact_probe.gd -- mma_dirty_boxing
```

- **The bought RamsterZ pack reads `0.302639` / `0.304671` and must still read
  it.** Eleven bound films ride that path.
- **The clinch must still read `att_lhand_to_vic_neck` at 15%.** You are adding
  a hold, not changing the retarget.
- `--only` does **NOT** stack — one per invocation, and read the `total=`.
- Known-red and NOT yours: `fight_pair_live` is **PARKED by the operator**;
  `fighter_reachability_contract` is **red on purpose**.

## Owned files

- `Godot/assets/anim/audition/cascadeur/<Key>_Att.glb` and `<Key>_Vic.glb` (new)
- `Tools/cascadeur/build_side_control.py` (new — the derivation, like
  `build_clinch.py`)
- `Godot/scripts/FightClipBinding.gd` — **the ONE new `PAIRED_BINDINGS` entry
  and nothing else**
- `Godot/tools/s31_contact_probe.gd` — **extended to carry your key's contacts,
  with the clinch's untouched**
- `research/C168_SIDE_CONTROL.md` and `research/C168_DIGEST.md`

**You own NOTHING else.** Do not touch `FightClipRetarget.gd` (C167 just landed
there), `FighterCapsules.gd`, `CapsuleShape.gd`, `ApproachBand.gd` or
`FightPoseSolver.gd`.

## Read these and nothing else

- `Tools/cascadeur/README.md` — **read it whole, it is short and it is five
  sessions of traps.**
- `Tools/cascadeur/build_clinch.py` — the derivation pattern to copy.
- `research/S31_THE_AUTHORED_CLINCH.md` — how the clinch was done and
  what went wrong.
- `research/C167_DIGEST.md` — why the arms arrive now.
- `Godot/scripts/FightClipBinding.gd` — **it is ~2,400 lines; do NOT open it
  whole.** `sed -n '1824,1845p'` for the paired constants and `sed -n
  '2015,2025p'` for the clinch entry you are copying.

Do **NOT** read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
other digest, and do not explore to "get oriented".

`RESEARCH_INDEX.md` is 231 KB — **GREP IT, NEVER READ IT WHOLE.** Worth running:
`grep -i 'side control' RESEARCH_INDEX.md`, `grep -i 'cascadeur' RESEARCH_INDEX.md`.
**A negative result is a result.**

## THE TRAPS, EACH OF WHICH HAS COST A SESSION

- **Cascadeur is SINGLE-INSTANCE.** A leftover process swallows every launch and
  you get `MainWindowHandle = 0` for ever. Kill the squatter first.
- **`--run-python-code` SWALLOWS TRACEBACKS** — it prints `exit code 0` even
  when your code raised. Write the traceback to a file and read it.
- **`scene.modify_update` returns True having done nothing** if you forget
  `scene_updater.run_update(<the data ids you touched>, frame)`.
- **Do not write a controller the rig solves.** Set `hand_MainPoint_*` and the
  elbow, its additional point and its limb direction follow on their own.
- **`AutoPosingTool` does NOT do a whole-body solve** — measured S30: dragging a
  hand controller 37 cm moved the shoulder 2.8 cm and the chest, spine, pelvis
  and feet **0.00 cm**. Pose through the controllers and measure the result.
- **rc=0 IS NOT A PASS.** A GDScript runtime error exits 0; a parse error HANGS
  a headless run for 600 s. Parse gate first, always.
- **The attach/import dialogs accept `.md .txt .pdf`, NOT `.py .glb .fbx`** —
  irrelevant to scripting, fatal if you try to drive the GUI by file drop.
- **`var x := <call>` fails on Variant** — write the type. **`%` must be `%%`.**
  **Reusing a variable name in one function is a parse error.**

## Rules

- **DO NOT fetch and DO NOT rebase** — the checkout is current.
- Never `git stash`, `git reset --hard`, `git checkout .`, `git clean` or
  `git add -A`. Stage explicit paths only; `git show --stat HEAD` after each.
- **Commit after each step — an honest partial beats an uncommitted whole.**
  The clip is worth committing the moment it exports, before it is bound.
- Push to master, write the digest, send one line with
  `python Tools/agent_comms.py send --from codex --to claude --subject C168
  --body "<one line with the worst contact drift you reached>"`.
  **Do NOT edit `HANDOFF.md`.**

## And then argue against yourself

End the digest with the strongest case that **authoring holds one at a time in
Cascadeur will never close a 376-clip gap** — that at one session per hold this
is a decade of work, and that the honest answer is either to cut the catalogue
to what can be shown or to make the contact solver generate held positions from
a specification instead. **Name your own weakest point unprompted, and say what
the per-clip cost actually was in your hands**, because that number is what
decides whether the batch is a plan or a fantasy.

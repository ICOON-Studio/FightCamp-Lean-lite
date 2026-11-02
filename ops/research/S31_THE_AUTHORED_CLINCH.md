# The first hold this project authored instead of buying — and the one thing that did not survive

**Claude · S31 · 2026-09-21 · the clinch, from a Cascadeur pose to playing in the game**

## THE ANSWER, BOTH HALVES OF IT

**The chain works end to end.** A collar-and-elbow clinch was authored in
Cascadeur, given four seconds of measured life, exported as two separate
single-actor GLBs, retargeted onto our fighters and bound to
`mma_dirty_boxing` — the technique S6c refused on position and called "a
purchase nobody has made". It is now a hold that plays, and nothing was bought.

**And the arms do not arrive.** The hips land within 4% of the authored
separation; the hands land **0.47 m from the other man's neck** against 0.073 m
authored. The hold is real, its distance is right, its breathing is right, and
its collar tie is not a collar tie. That is measured, not guessed, and the
instrument that measures it is committed.

**So: the stage's gate is met and the operator's bar is not.** The ruling on
paired assets is "the movements need to be accurate" (2026-09-20), and an
attacker whose arms finish over his head is not accurate. This digest reports
the working chain and hands over the one defect with a diagnosis attached.

**AND ONE CLAIM IS DELIBERATELY NARROWER THAN IT COULD BE.** The hold plays
through `PairedStagePlayer.graft_pair` - the same path `FightWorldLiveScreen`
routes a paired beat down - on two different fighters, and every number below
was measured there. It has NOT been watched firing inside a live bout, and that
was not attempted: putting a hold whose arms are 0.47 m out into a recorded
fight would be asking the operator to judge a defect this session already
found.

---

## WHAT PLAYS, IN NUMBERS

`tools/pair_gap_report.gd` (U115), hip-to-hip across the bound window, on
`f01_m_box_welter` against `f02_m_box_heavy` — two different men, different
frames:

```
PAIRGAP key=mma_dirty_boxing table=strike frames=121
        min_gap_m=0.753896 max_gap_m=0.802424 mean_gap_m=0.778145
```

| | value |
|---|---|
| **min gap** | **0.754 m** |
| **max gap** | **0.802 m** |
| excursion | 0.049 m |
| Q115's measured clinch band | 0.72–0.87 m |

The hold sits inside the band it was authored against, and it **breathes**:
4.9 cm of hip excursion in the game against the 4.6 cm Q116 measured off real
footage.

**THE BOUGHT PACK DID NOT MOVE.** `grapple_control` reads
`min_gap_m=0.302639 max_gap_m=0.304671` — the same numbers U115 measured before
any of this landed.

## THE POSE, AND WHY IT IS NOT S30'S

S30 authored the clinch at **0.557 m** hip-to-hip. Q115 measured real footage at
**0.719 m** (p50, 57 frames) against a range control arm of 1.050 m, with a p10
of 0.709 m — so S30's number sat 0.15 m below the closest approach anyone
observed. It was retired.

**75 cm broke the pose, and that is the finding of the first hour.** At 0.75 m
the collar tie is 55.2 cm from the attacker's shoulder and the rig's own arm is
26.4 + 23.1 = **49.5 cm**. The arms could not reach. The repair is not a tighter
clinch — it is a deeper lean: **18° → 28°**, at which the same tie is 41.0 cm
away and all four arms are inside reach on all 121 frames. Hips back, heads
together, which is what a clinch is. The lean is DERIVED from the rig's own
reach, not chosen.

Measured on the live rig after applying the pose
(`Tools/cascadeur/measure_contacts.py`):

| contact | metres |
|---|---:|
| A left hand → B neck | 0.073 |
| A right hand → B neck | 0.097 |
| B right hand → A left arm | 0.083 |
| head ↔ head | 0.216 |
| **pelvis ↔ pelvis** | **0.746** |
| lowest joint, each man | 0.028 (the rig's own rest toe height) |

## THE LIFE, AND WHAT IT IS HONESTLY WORTH

4.0 s at 30 fps, 121 frames, loop seam **0.000 cm**. Amplitudes are Q116's
measured excursions:

- hip separation breathes **4.6 cm** peak-to-peak (Q116 p50 0.046 m)
- each man's hips bob **3.2 cm** (Q116 p50 0.032 m)
- lateral sway is **ZERO**, because Q116 could not resolve it above the noise
  floor. Absent evidence, none was invented.

**THOSE AMPLITUDES ARE A FLOOR, NOT A TARGET, AND THE DIGEST SAYS SO BECAUSE
THE CLIP CANNOT.** Q116's three usable runs are **0.1–0.9 s of contact** — brief
approaches, not the 4–7 s clinch episode J32 anchors (Davis et al., Olympic
boxing: 5.0/5.4/6.0 s mean per clinch by round, by inference). A sub-second
window cannot contain a four-second drift, so these figures *under*-measure a
real hold. They were used anyway: a measured floor beats an invented number.

The periods (4.0 s, 2.0 s, 1.33 s) and the grip adjustment ARE authored — Q116
found no resolvable period and says so. 4.0 s of content sits inside J32's
episode anchor and inside C143's contract bound of 3–8 s.

---

## THE DEFECT: THE SPINE LEAN DOES NOT SURVIVE THE RETARGET

`tools/s31_contact_probe.gd`, nine samples across the bound window, game
against authored:

```
S31CONTACT measure                   authored      min      max     mean    drift
S31CONTACT att_lhand_to_vic_neck        0.073    0.447    0.497    0.471     545%
S31CONTACT att_rhand_to_vic_neck        0.097    0.447    0.500    0.473     387%
S31CONTACT vic_rhand_to_att_larm        0.083    0.710    0.758    0.733     783%
S31CONTACT head_to_head                 0.216    0.307    0.328    0.318      47%
S31CONTACT hip_to_hip                   0.746    0.754    0.802    0.778       4%
```

**READ THE SHAPE OF THAT COLUMN, NOT ONLY ITS WORST ROW.** The error GROWS UP
THE CHAIN: hips 4%, heads 47%, hands 387–783%. That is not a broken arm map —
a broken map would be wrong at the shoulder and no worse at the wrist. It is a
rotation error low in the spine that the arms inherit and amplify.

**AND IT IS THE LEAN.** Our fighters are 1.047× Cascy, so the authored
head-to-head of 0.216 m should arrive at ~0.226 m. It arrives at **0.318 m** —
the two men are standing straighter than they were authored. Straighten a
28° lean and the heads separate and the hands, furthest out on the chain, stop
reaching the other man's neck entirely. Every number in that table fits that one
cause, and the contact sheet shows exactly it: the attacker upright with his
arms over his head.

**THE PRIME SUSPECT IS NAMED AND IT IS THE THING U114 FLAGGED AS UNFORECAST.**
Cascy has no third spine segment, so `FightClipRetarget._inherit_upper_chest`
gives our `UpperChest` **Chest's global `Transform3D`** — the same global pose,
not a separate rotation drive. Our clavicles and arms hang off `UpperChest`. If
that assignment costs the chain the lean, this is where it is lost. **That is a
hypothesis with a number attached, not a conclusion: it was NOT tested, because
testing it means editing the retarget and this stage had already shipped its
suite.**

## HOW TO CHASE IT, NEXT SESSION

The instrument already exists and it is cheap — headless, no render:

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s31_contact_probe.gd -- mma_dirty_boxing
```

Drive `att_lhand_to_vic_neck` down. It is 545% now; anything under ~30% is a
collar tie on a differently-proportioned body. **Do not gate on hip_to_hip —
it already passes and it is what made this defect invisible for an hour.**

Order of attack, cheapest first:

1. Make `_inherit_upper_chest` a no-op and re-measure. If the drift falls, the
   lean was being eaten there. This is one line and it is the whole hypothesis.
2. Print the retargeted vs source LOCAL rotation for `Spine`, `Chest`,
   `UpperChest` at t=0 and find which one loses the 28°.
3. Only then consider the arms themselves.

**AND A CONTROL ARM:** whatever changes, re-run `--only clip`, `--only pair`,
`--only grapple` and `pair_gap_report.gd -- grapple_control`. The bought pack
reads 0.302639/0.304671 and must still read it; a "fix" that moves the RamsterZ
pairs has broken eleven bound films to repair one.

---

## FIVE THINGS THAT COST THIS SESSION A PASS EACH

**1. `set_data_value` at a non-zero frame returns True and writes nothing.** A
fresh Cascy scene has `frames_count == 1`. The timeline has to be OPENED first —
`layers_editor.set_fixed_interpolation_or_key_if_need(track, last, true)` then
`model_editor.fit_animation_size_by_layers()` — and then **every track needs a
key at every frame**, not just an anchor at the end. With only the anchor, all
121 writes returned True and the rig read back one constant pose.

**2. Cascadeur's quick-export writes FBX whatever you name the file.**
`FbxSceneLoader.export_scene_selected_objects("x.glb")` produces `x.glb.fbx`.
That is not cosmetic: `is_cascadeur_clip` keys on the extension to choose
`CASCY_TO_UE4`, so an FBX from Cascadeur retargets through the RamsterZ map with
no error at all. The glTF channel is `csc.glb.process_export` with
`ExportOptions`, and **`include_animation` defaults to FALSE** — the obvious call
exports one rest frame and looks like a successful export of nothing.

**3. Godot turns `character1:pelvis` into `character1_pelvis`.** U114 added
`_strip_namespace`, which splits on the colon — and Godot's glTF importer
sanitises the colon to an underscore before the retarget ever sees it. The
victim half mapped to **ZERO bones**, `retarget_clip` succeeded, `graft_pair`
succeeded, the pair played all 121 frames with one man in his rest pose, and the
only symptom was a wrong distance. Patching `_strip_namespace` to eat an
underscore prefix is not safe — `foot_r`, `calf_LimbDir_l` and every other bone
is underscore-separated too. So the namespace is removed from the FILE:
`Tools/cascadeur/strip_namespace_glb.py`, before Godot sees it.

**4. A retargeted clip is deliberately re-centred on its own first frame, and
for a pair that deletes the separation.** `hips_xz(t) - hips_xz(0)` is right for
one body and fatal for two: the authored 0.75 m arrived as 0.06 m. The repair is
a SHARED sway origin — the midpoint of the two authored roots, passed to both
halves — so each film keeps its offset from the pair's centre and the separation
travels inside the films.

**THE OBVIOUS ALTERNATIVE IS WRONG AND IT WAS MEASURED, NOT ASSUMED.** Placing
the two bodies apart on the mount produced the right gap and a RED
`fight_grapple_seam_test`, which asserts "one mount: both bodies sit at the same
transform while the film plays". Worse, reading authored roots back for EVERY
pair moved `grapple_control` from a 0.303 m mount to **3.337 m apart**: the
RamsterZ halves are NOT authored on one spot (`tools/s31_root_probe.gd` reads
BodyLock_Loop at att (-0.090, 2.019) and vic (0.088, -1.147), 3.17 units apart,
while `grapple_takedown` in the same pack is 0.004 apart). That pack RELIES on
per-clip re-centring. Both repairs are therefore gated on
`is_cascadeur_clip` — a property of an authoring pipeline, never a truth about
pairs.

**5. `carry_sway` defaults FALSE, and the vertical bob hides it.** With sway off
the hold measured `min_gap_m=0.773758 max_gap_m=0.773759` — frozen to the sixth
decimal — because both men bob in phase and an in-phase bob does not change the
distance between them. The gap number alone would never have shown it.

---

## REPRODUCE IT

In Cascadeur: dismiss the Home screen, `Scripts > MCP > Start script server`.

```bash
D=C:/Users/user/AppData/Local/Temp/s31
python Tools/cascadeur/csend.py -c "print(app.get_data_source_manager().load_scene('C:/Program Files/Cascadeur/samples/Cascy.casc'))"
# GUI: File > Import > Import Scene To Current... the same Cascy.casc
python Tools/cascadeur/csend.py Tools/cascadeur/place_second.py $D
python Tools/cascadeur/csend.py Tools/cascadeur/dump_rig.py     $D
CLINCH_LEAN_DEG=28 python Tools/cascadeur/build_clinch_clip.py  $D
python Tools/cascadeur/csend.py Tools/cascadeur/apply_clip.py   $D
python Tools/cascadeur/csend.py Tools/cascadeur/export_pair.py  $D
python Tools/cascadeur/strip_namespace_glb.py $D/Cascy_CageClinch_Vic.glb
```

**THE SCENE MUST CARRY TWO MESHES, NOT TWO SKELETONS.** Check it before
posing — `Mesh Object` count must be 2. S31 built the whole pose on a tab whose
fighter A had no mesh, measured it, and only caught it by looking at the render.

## WHAT IS ON DISK

| file | what |
|---|---|
| `Tools/cascadeur/build_clinch_clip.py` | the four parameters walked over time -> CLIP.json |
| `Tools/cascadeur/apply_clip.py` | opens the timeline and keys 121 frames x 78 controllers |
| `Tools/cascadeur/export_pair.py` | two separate single-actor GLBs through the glTF channel |
| `Tools/cascadeur/strip_namespace_glb.py` | removes `character1:` before Godot mangles it |
| `Tools/cascadeur/probe_frames.py` | the keying question, asked empirically |
| `Godot/tools/s31_contact_probe.gd` | **the instrument the next slice needs** |
| `Godot/tools/s31_root_probe.gd` | what a pair was authored at, and in what units |
| `research/S31_SHEETS/` | the quarter and top-down contact sheets |

The clinch plays down the mount's own +Z (`line_deg = -0.0` across all six
sheet cells), which is the axis the room faces fighters down — so it plays
along the fight's line, not across it.

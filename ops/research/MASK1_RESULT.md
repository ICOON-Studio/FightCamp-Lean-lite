# MASK1 - the limb under the mouse lights up, from the 3D (S559)

Task: `ops/research/TASK_MASK1.md`. Prior research followed: RS3D1 Option B (`ops/research/RS3D1_ASSESSMENT.md`).

## What he gets
`proto/twohands/body.html` (the body toy), now on the real body:
- Point at a limb of either man: THAT limb glows - a soft outline in its corner's colour (blue for you, red for him), taken
  from a part mask rendered from the 3D beside each picture. No circle, no label, no text on or near the men.
- Four parts a man: lead arm, rear arm, legs (= Feet: step in, back off, stand), body (= the clinch).
- The switches of your part open in ONE fixed panel left of the ring (the page's own compact toggles with icons, details
  in the tooltip, the same rules). A thin dashed line runs from the lit limb to the panel, drawn BEHIND the men, so it
  never lies on a body. Click = the part stays open ("kept open: click it again to let go").
- His parts light too; the panel then says what that limb did in his last three beats (his hands: punch thrown or where
  held and what it shut; his feet: stepped in / backed off / stood; his body: clinched or not).
- The page is today's order.html (compact board, the distance bar, the commentators) plus this layer; the board moved
  into the side panel, so the ring is taller (60% of the screen height). 1920x1080, no scroll.
- The guard (both hands punching) is now a run too, `blue_guard` / `_r2` / `_r1`, so it has masks and shows the range.

## How the masks are made (`tools/pics2d_mask.gd`, new, 205 lines; hook in `tools/pics2d_anim_more.gd`, +22)
- A second SubViewport on the SAME world, its own camera copied from the picture camera before each draw: the picture
  and its mask are the same drawn frame (nothing waits between them).
- Each body mesh gets a twin on render layer 20 (the picture camera no longer sees layer 20; the mask camera sees only
  it): same mesh, skin and skeleton, one flat colour per part as a vertex colour = the part whose bones carry the most of
  that vertex's skin weight. Lead / rear from `stage.hand_of(i, "LeftHand")` (blue is a southpaw-mirrored man: his lead
  is his right). The gloves are rigid pieces moved by a script (not skinned, no BoneAttachment): they take the part of the
  bone nearest their middle; the boots hang on a bone (legs).
- A tiny shader, unshaded, colour interpolation FLAT: the first render used smooth vertex colours, and a triangle across
  the waist blended torso and legs into a third colour that snapped to the OTHER man's part (red glow on blue's shorts).
  Flat = exactly the 8 colours, no blends (checked: 8 colour buckets, nothing else).
- Linear tone map, no MSAA / FXAA, transparent background. `mask=off` skips it; `mask_debug` prints each twin's part.
- `<run>_<k>_mask.png` beside each picture; `proto/twohands/tools/anim_web.py` copies it at 480 px, nearest-neighbour,
  every pixel snapped to its part colour (palette PNG, ~3.6 KB each, 171 masks = 0.7 MB) and lists them in frames.json
  as the run's `masks`.
- CONTROL: the same runs with `mask=off` gave BYTE-IDENTICAL pictures (24 of 24): the twins change nothing in the
  pictures.

## Renders (GREEN/AMBER PC, godot_slot + hidden_desktop, set=m art=toon south=blue)
`only=blue_guard,blue_lead_high,blue_lead_low,blue_rear_high,blue_rear_low,blue_both`: 27 runs, 171 frames, refused 0,
gate failed 0 (every hold passed HOLD_GATE, the GUARDEAR1 ear bar included). ~4 minutes. Raw: `E:/FightCamp/tmp/mask1/full`.

FOUND, AND CHANGED BY THIS RE-RENDER: the blue hold pictures committed by GUARDEAR1 (483bfcbae) were rendered WITHOUT
`south=blue` - blue stood with his back half to the camera in the holds, while the punches, the feint and the guard show
him chest-on (HOLDTAKES1: "always with south=blue"). The re-render is `south=blue`, so the 24 blue hold runs now match
the rest (before / after checked by eye on blue_rear_high_r1_3 and blue_both_high_high_6). The red hold runs (red_*,
not shown by the page) were not re-rendered and still carry GUARDEAR1's unmirrored render.

THE OWNER'S CAMERA: `tools/pics2d_camera.json` appeared at 01:11:42 (his save #12); this render finished at 01:08:04, so
every picture and every mask here is the OLD camera, the same as all other pictures. Nothing is mixed. When RINGCAM1
re-renders the pictures with his camera, the masks come with it for free: re-run the command below in the same pass
(the mask camera copies the picture camera).

## The check (`node proto/twohands/tools/mask_shots.mjs ops/previews/s559_mask`, headless Edge, nothing on a monitor)
At Long, Mid and Inside, the mouse on the middle of each of the 8 parts (found on the mask), a screenshot each, and what
the panel says (`ops/previews/s559_mask/mask_report.txt`):
- 24 of 24 hovers open the right part (your lead / rear / feet / body switch group; his lead / rear / feet / body story).
- The lead hand clicked, mouse moved away: it stays open ("kept open").
- Page height 1080 of 1080, width 1920: no scroll.
- Seen by me on every shot (`mask_sheet.png`): the lit limb is that limb (glove + forearm + upper arm for an arm, both
  legs and boots for the feet, head and trunk for the body), nothing else lit, no circle or text on a man. A part
  boundary is a triangle edge, so the outline steps a little at the waist and the shoulder.
- First run of the check found two page faults, fixed: the page kept the Long mask after a range change (a cached
  picture set again fires no load event: the page now follows every src change), and his two hands read swapped
  while the hold run was still playing (the AI's look-ahead holds the page ~5 s; the check now waits for the last picture).

Regression: `node proto/twohands/tools/anim_check.mjs` PASS (138 of 138); `node proto/twohands/tools/page_play_test.mjs`
4 passed (order.html untouched). On the review board: "Lit limbs from the 3D" (sheet + one shot).

## Reproduce
```
python ops/Tools/godot_slot.py run --who MASK1 -- python tools/hidden_desktop.py run --timeout=2400 --log=<log> <godot.exe> --path . --windowed --resolution 1920x1080 --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_anim_more.gd -- <dir> art=toon set=m south=blue only=blue_guard,blue_lead_high,blue_lead_low,blue_rear_high,blue_rear_low,blue_both
python proto/twohands/tools/anim_web.py <dir>
node proto/twohands/tools/anim_check.mjs
python proto/cardgame/serve.py 8797 twohands      (in a terminal tab)
node proto/twohands/tools/mask_shots.mjs ops/previews/s559_mask
```

## Not done / open
- Masks only for the pictures he plans on (the guard and the holds, blue's runs). The action pictures have none (the
  glow is off while a beat is fought) and the kick pictures (KICKTAKE1) have none yet: the same `mask=on` pass gives
  them when they are rendered through pics2d_anim_more.gd's `_frame` (pics2d_anim.gd / pics2d_kick.gd runs would need
  the same 8-line `_frame` hook).
- His last-three-beats panel shows nothing until he has fought a beat ("Nothing seen of him yet").

## Seen while working (not mine, not changed)
- The KICKTAKE1 amend (ae4121fce, since reset by its session to 8ae56646d) had swept 8,256 working-tree files into one
  commit, my uncommitted MASK1 files among them. I committed only my paths, by pathspec, after that.

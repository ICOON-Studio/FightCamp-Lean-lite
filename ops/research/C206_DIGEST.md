# C206 — Marpa arena fit and hall exposure

Delivered on `codex/c206-arena-fit`; `venue_art` remains OFF by default. No engine dimensions, simulation, RNG, ArenaRig, or live-room code changed.

## Control verdict

Recorded BOTH original arms before editing: seed 5150, boxing, broadcast, 300 frames at 30 fps. `control_off.mp4` and `control_on.mp4` in `previews/c206/` preserve the ten-second controls; matching `control_*_8s.jpg` frames were opened and inspected. The supplied command requests 1280x720, but the live room sets its viewport to 1920x1080; that is the actual output size.

**Fighter B has bare hands OFF as well as ON.** This predates the venue adapter and was left for the fighter-equipment owner, as instructed. **The left fighter's foot also crosses the boxing rope line in both arms.** The boxing ring already has the correct centre and scale. Enlarging it to encompass that animated foot would violate the task's engine-bounds rule. The live-room limb clamp explicitly returns for non-octagon shapes; this is a separate presentation issue, not repaired or concealed by moving art. The final boxing stills deliberately retain this visible limitation. C206 is not a claim that those two pre-existing fighter defects are fixed.

## Measured fit (world metres)

The live room's contest boundary and its fighter-centre limit are different by its existing 0.30 m body margin. The art belongs on the contest boundary, not on the inset centre limit. RingSpace's diagonal octagon walls use the same apothem as its axis walls.

| Live discipline | Engine centre half-width | Contest half-width | Mesh before | Mesh after |
| --- | ---: | ---: | --- | --- |
| Boxing | 2.443200 | 2.743200 | Rope centreline 2.743200; outer mesh 2.752725 | Unchanged, outer-mesh error 0.009525 |
| MMA / 30 ft | 4.272000 | 4.572000 | Eight directional extents 4.518907–4.585963; worst error 0.053093 | 4.538328–4.605672; worst error **0.033672** |

The original cage fit tested only X/Z AABBs. Its asymmetry missed a diagonal wall by 53 mm. MarpaArena now measures transformed mesh vertices along all eight wall normals and balances their nearest/farthest support planes with one horizontal scale correction. The door receives the same correction; deck height and floor remain unchanged. The 25 ft and 6 m cage presets also pass: maximum errors 0.028060 and 0.022095 m. Boxing remains exactly centred; no invented correction is applied where the control disproved the premise.

`venue_art_test.gd` independently traverses actual mesh vertices and checks every wall within 5 cm, rather than accepting measurement metadata. A real source mutant translated the cage fence and boxing ring by +0.20 m: **82 checks, 20 failures, exit 1**. Restored source: **82 checks, 0 failures**. Raw measurements and mutant output are beside the stills.

## Canvas and hall

The pale octagon was ArenaRig's `canvas_centre_paint`, not a leaked imported cage floor. Marpa's ring branch removes only that decoration, covering boxing and kickboxing while preserving the OFF arm.

Hall meshes use their own light layer, two opposed shadowless ambient fills, and a soft overhead fill. The fighter/ring key is untouched. A shared diffuse shader preserves source albedo/normal detail and alpha cutouts, raises absolute-black atlas regions to a dim diffuse floor, compresses seat contrast, uses roughness 0.9/specular 0.15, and limits fixture emission. The absolute-black texture regions were why simply adding light did not remove the void. One material instance is shared per source material within each arena.

## Visual evidence and reproduction

Opened and inspected boxing and MMA broadcast/establishing PNGs and engine-bound overlays under `previews/c206/`. Hall walls, seating tiers, and floor now read behind the brighter contest area; the seat edges are subdued and the boxing octagon patch is gone. The hall is still empty of spectators. This is venue fitting, not a crowd-system delivery.

Overlay: red = contest boundary; cyan = engine fighter-centre limit. Overlays are capture-only, and both images use the same frozen pose. `establishing` in this review harness is a wide arena-relative camera (55 degree FOV) because the normal gameplay establishing preset cropped the fighters' heads at this seed/time; the broadcast camera is unchanged. No shipping camera code was edited.

Reproduce each of the four views (substitute `boxing`/`mma` and `broadcast`/`establishing`):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script assets/venues/mma_arena/tools/capture_fit.gd --fixed-fps 30 --resolution 1280x720 -- seed=5150 discipline=boxing shot=broadcast venue_art=1
```

## Gates and scope

- Parse: three touched GDScripts, `CHECK total=3 fails=0`.
- Required focused gate: `python Godot/tools/run_tests.py --only venue_art,arena,fight_world_live,asset_manifest --jobs 1`: **SUITE total=7 fails=0**.
- Initial control attempt had missing worktree font imports and was discarded; controls were rerun after editor import. Import reported an unrelated missing Blender editor path. Final captures have no script errors; existing FBX short-read and shutdown leak warnings remain.
- Task-specific branch startup and prohibition on HANDOFF superseded the general entry/rebase and HANDOFF-block rules. No HANDOFF, CURRENT_STATUS, or archive was read or changed. No full suite run; integration remains Claude's.
- Only explicit task paths and preview evidence are committed. AVI intermediates, import cache, local logs, unrelated generated UIDs, and the pre-existing `.c205_source/` remain uncommitted.

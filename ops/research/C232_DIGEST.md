# C232 — walkout in the booked venue

Boxing and other ring walkouts now build VenueRig with the intro's booked venue id and the same ArenaSurface/ArenaRig spec as the bout. FightNightScreen passes only `bout_venue(...)`; FightNightIntro enables the long walkout for venue-bearing booked specs. Headless, unavailable assets, unsupported surfaces, short intros and explicit opt-outs still omit it. MMA retains the owned Marpa set.

VenueRig changes are seven additive lines: an `entrance` marker inside each venue's seating banks, with the ballroom mouth between banquet tables. No crowd, seating, materials or venue lighting implementation was edited. WalkoutShot uses the existing wide-shot venue light tuning and a local aisle key. The Cut Glass has a closer front three-quarter camera to avoid foreground chairs. C207's source, retarget and horizontal foot-contact integration remain; the baked travel is rotated toward the actual +X stairs. Interpolated poses receive a vertical sole correction because the first test caught a non-support toe up to 35.5 mm below the floor.

The shot ends **0.55 m before the lowest stair**, at its centre Z. It does not animate a stair climb: the owned source is a level-floor walk. Entrances are floor-side aisle mouths, not a newly constructed tunnel or doorway. No new motion asset or provider spend.

## Measured checks

- Final parse: `CHECK total=5 fails=0 autoload_refs=0 autoload_warnings=0`.
- Required affected gate: `python Godot/tools/run_tests.py --jobs 2 --only walkout,fight_night,venue,arena_rig,smoke` → **SUITE total=8 fails=0**.
- Final C232 focused test: **31 checks, 0 failures**; independent stair mesh bounds, entrance occurrence, actual path endpoint (<25 mm), floor contact at 151 poses, and 0.25 m body clearance from chair/plank AABBs. Headless tests build the path directly rather than calling the framebuffer availability guard.
- Paths: Iron Parish **2.180 m**, The Cut Glass **2.916 m**, Northlight **3.533 m**. Sample stature 178 cm, 73.4 kg. Maximum sole-landmark floor residual after correction: **0.000000021 m**. This is a rig landmark check, not a skinned-mesh collision certificate or a new claim of zero foot slip.
- The full affected gate preceded final camera/light refinement; the C232 focused gate was repeated on the final scripts after the clearance assertion and capture-mode changes. No full suite was run.

## Live evidence

All recordings use `Tools/godot_hidden.ps1`, Dummy audio, a live Godot world, 30 fps; final MP4s are H.264 **1280×720 with no audio stream**. No viewer was opened. All nine requested 1/3/4.8-second PNGs and decoded MP4 contact sheets were inspected using the file image tool.

- [Iron Parish](../docs/previews/c232/iron_parish.mp4), 5.067 s; [decoded sheet](../docs/previews/c232/iron_parish_review.jpg).
- [The Cut Glass](../docs/previews/c232/the_cut_glass.mp4), 5.067 s; [decoded sheet](../docs/previews/c232/the_cut_glass_review.jpg).
- [Northlight plus live bout](../docs/previews/c232/northlight.mp4), 13.067 s: five-second walkout followed by eight seconds with both fighters active, seed 232, `set_player_view()` game camera; [walkout sheet](../docs/previews/c232/northlight_review.jpg).
- Individual stills: `<venue>_030.png`, `_090.png`, `_144.png` under `docs/previews/c232/`. Live bout frames at `_bout_060.png`, `_bout_150.png`, `_bout_230.png`.

Review caught and corrected the unlit aisle, the ballroom camera crossing behind a chair, and the ballroom foot framing. The walk paths avoid chairs and approach the steps. The current R1 room has sparse visible crowd from this angle; R5 has the existing schematic faceless crowd. The Cut Glass's existing elevated banquet geometry remains visible. These are evidence of current venue quality, **not an AAA visual acceptance claim**.

The supplemental live-bout recording exposes severe folded/floating leg poses in the unedited live fighter pipeline. Both men and the clock advance, but its presentation counter reports zero beats/played/carried over the eight seconds. This footage is retained as a failure witness, not certified fight animation. A separate `bout_only` baseline runs the identical room without ever constructing WalkoutShot; the same folded-leg pose recurs at two seconds ([baseline still](../docs/previews/c232/northlight_baseline_bout_060.png), [baseline video](../docs/previews/c232/bout_baseline.mp4), 3.033 s). This isolates the defect from WalkoutShot; no fight-animation files were edited.

## Reproduce

Create `previews/c232` before launching Movie Maker (otherwise its writer cannot open the output). For each venue:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/pc_watchdog.ps1 -Once
# Continue only on GREEN/acceptable non-RED output.
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tests/walkout_venue_test.gd --write-movie E:/FightCamp/wt/C232/previews/c232/iron_parish.avi --fixed-fps 30 --resolution 1280x720 --quit-after 180 -- capture=iron_parish
```

Use `capture=the_cut_glass` or `capture=northlight`; add `bout` and `--quit-after 420` for the appended live bout. Add `bout_only` for the isolated 90-frame room comparison. Encode with ffmpeg `-an -vf scale=1280:720 -c:v libx264 -threads 2 -crf 20 -pix_fmt yuv420p`. AVI intermediates are ignored and not committed.

## Scope and environment

Task precedence overrides generic HANDOFF updates and the stale multi-task mailbox: only C232 was implemented; HANDOFF was never edited. The initial clean branch was fetched/rebased. Godot import completed in the fresh worktree; its 2,644 tracked `.import` changes and 119 untracked generated sidecars were removed, preserving source and evidence. Required Windows health checks needed unsandboxed CIM access (the sandbox's denied metrics falsely reported zero free disk). Real checks showed roughly 84 GB free on C:. A RED CPU sample occurred during concurrent activity; the last R3 job was already complete when the scoped stop check ran. Further heavy work resumed after GREEN. No Godot process was killed by image name.

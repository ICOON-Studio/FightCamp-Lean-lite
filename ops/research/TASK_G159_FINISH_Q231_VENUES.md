# TASK G159 - finish the national/international venues Qwen left uncommitted (Q231)

Model: Grok Build default (grok_task.ps1). Owner: Grok CLI. Worktree `E:/FightCamp/wt/Q231` (REUSE it - the work is
there), current branch `qwen/q231-venues-big`; you will push to a NEW branch `grok/g159-venues-finish`.

## Why (operator, verbatim, S143)
"finish the venues with grok"

## The state (primary source, read S143)
Qwen ran TASK_Q231_VENUES_NATIONAL_INTERNATIONAL.md (read it in full - it is your spec, rubric and test list) and
ran out of quota (resets 10-08) before committing anything. In the worktree, UNCOMMITTED:
- `Godot/scripts/VenueRig.gd`: +835/-29 lines (the four venue builders: northlight, limehouse_bowl, the_cut_glass, the_quarry).
- `Godot/assets/venues/{northlight,limehouse_bowl,the_cut_glass,the_quarry}/` (new), `previews/q231/`
  (before/ + four `*_review.png` concept-vs-render sheets), re-rendered `previews/venues/*.png`.
- The branch is **54 commits behind origin/master**, and master's VenueRig.gd changed +463/-127 since (Q230 regional
  venues own the SHARED shell helpers; G157 replaced box spectators with a VAT MultiMesh crowd beside
  `_add_seated_silhouette`). The Q231 review sheets still show the OLD box crowd.
- Claude opened `northlight_review.png`: materials, banners, lit ring under a dark house are real and close to concept.

## Do, in this order
1. **Save Qwen's work before anything else:** `git checkout -b grok/g159-venues-finish`, then `git add` BY EXPLICIT PATH
   only VenueRig.gd, the four `Godot/assets/venues/<id>/` dirs, `previews/q231/`, the
   `previews/venues/{northlight,limehouse_bowl,the_cut_glass,the_quarry}_*.png` - NOT the stray `*.uid`,
   `*.import` or other files - and commit "Q231 (Qwen) WIP checkpoint, committed by G159". Push.
2. **Merge `origin/master`** into the branch. In `VenueRig.gd` conflicts KEEP BOTH SIDES: master's shared shell helpers
   (Q230) and the G157 crowd code win where they overlap; Q231's four `_build_*`/`_add_<venue>_*` functions win for
   those venues. Never delete a master function. Parse gate after the merge.
3. **The crowd:** the four venues must seat the G157 VAT crowd (the way master's regional venues do), not box
   silhouettes.
4. **Finish against the Q231 rubric** (MATERIAL / LIGHT / LIFE per venue): fix what the review sheets still miss.
5. **Renders + sheets:** per venue the `capture_venue.gd` command in the Q231 task, then `python Tools/room_review.py`
   before/after sheets. OPEN every image with your file tool and write the rubric per venue in the digest.
6. **Tests:** `python Godot/tools/run_tests.py --jobs 2 --only venue,arena,fight_night,smoke` - all green, paste the summary.
7. `research/Q231_DIGEST.md` (what changed per venue, rubric, test output, image paths). Commit, `git push -u origin grok/g159-venues-finish`.

## Owned files
Exactly the Q231 task's owned list (VenueRig.gd's four national/international builders + their assets/previews) plus
merge-conflict resolution in VenueRig.gd (1,699+ lines - never read whole: `grep -n "^func _build_\|^func _add_"` and
`sed -n` windows). Nothing else.

## Prior research
`python Tools/prior_research.py venue arena look` -> S138_AAA_VISUAL_GAP.md, G74 digests, Q230_DIGEST.md (regional
venues, the shared helpers), G157 digest (the crowd).

## What would a human do?
An environment artist who inherits a colleague's unsaved scene saves it first, rebases on the latest build, then
finishes the set against the art-director's rubric with before/after captures.

## Prefab check
Textures: the CC0 sets already in `Godot/assets/venues/*/textures/` (licences in `Godot/assets/venues/LICENCES.md`). Crowd: G157's VAT crowd.

## The one trap
`git add -A` or `git add .` in this worktree would commit thousands of regenerated `.import`/`.uid` files and other
agents' leftovers. Add explicit paths only, and check `git status -s` before every commit.

Rules: watchdog `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` before every Godot run
(exit 1 = wait); windowed renders ONLY through `Tools\godot_hidden.ps1`; never open a viewer or window on the operator's
screens (file tool only); never kill a process you did not start; never edit HANDOFF.md. Do not stop at written.

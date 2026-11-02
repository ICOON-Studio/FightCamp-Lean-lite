# TASK PROFILE2B_FIX - the profile overview fills the screen and nothing overlaps (behind switch `profile2`)

Model: Cursor (UI seat). Claude opened the game-camera still `previews/s205_profile2/2_profile_overview.jpg`
(made by `Godot/tools/profile2_stills.gd`) and found these defects in PROFILE2B (commit on master "PROFILE2B collected"):

## Defects (each one becomes a check in the test)
1. NOT FULL SCREEN: the overview content ends at x~1348; x 1348..1895 shows the 3D gym through it. The layer
   (`ProfileOverviewLayer`, GymHallPanel `_on_quick_look_open_full`) has no opaque backing. Fix: an opaque full-rect backing
   (#0B0F17 or the panel token) under the overview, and the right column (Ludo r37: fight card / next bout / camp / notes -
   whatever ProfileOverview already builds, or the bout + camp blocks from ctx["bout"], ctx["camp"]) placed in x 1360..1896.
2. BODY DIAGRAM OVERLAP: the front and back silhouettes (x 60..310, y 655..965) draw over the region labels
   (HEAD / NECK ... RIGHT LEG at x 260..470). Fix: the two figures side by side in the LEFT part of the block (each <=110 px wide)
   and the six rows in a column to their right that starts after the figures end - no label rect may intersect a figure rect.
3. EMPTY PANEL: the centre lower panel (x 505..1347, y 650..1020) is an empty dark box. Fill it with the r37 overview content
   meant for it (recent fights / form strip from ctx["history"], or the month-ago deltas from ctx["month_ago"]); if there is no
   data, a one-line empty state ("NO BOUTS ON RECORD YET"), never a blank box.
4. HAND ON TOP: the FighterHand cards (bottom-left, y~1020..1080) draw over the profile. While the profile layer is open,
   hide the hand (and the hall's speed/time bar, the goals card and the HUD V3 feed if present) and restore them on back.
5. TOP BAR GHOST: the hall's speed bar (x 360..1560, y 12..64) shows through behind the tabs row. Covered by fix 1's backing
   (the layer must sit above every hall HUD node: move_child to last, z_index if needed).

## Owned files
- Godot/scripts/ui/ProfileOverview.gd (474 lines)
- Godot/scripts/GymHallPanel.gd (only `_on_quick_look_open_full` ~line 991-1030 and the back handler)
- Godot/tests/profile_overview_test.gd (192 lines)

## Acceptance test (tier: script edited)
Extend `profile_overview_test.gd` with geometric checks at 1920x1080: (a) a full-rect opaque backing exists and covers
(0,0)-(1920,1080); (b) the union of the overview's visible blocks spans x <= 40 to x >= 1880; (c) no body-region label rect
intersects a silhouette rect; (d) every top-level block has at least one visible child with text or a texture (no empty box);
(e) with the layer open, the hand / speed bar / goals nodes in GymHallPanel are hidden, and visible again after "back".
Each new check must FAIL on the current master first (say so in your report), then pass.
Parse: `python Godot/tools/check_scripts.py Godot/scripts/ui/ProfileOverview.gd Godot/scripts/GymHallPanel.gd Godot/tests/profile_overview_test.gd`
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/profile_overview_test.gd` (run `--import` once first
in your worktree), then `python Godot/tools/run_tests.py --jobs 2 --only profile_overview,quick_look`. Import-cache failures
from missing LFS assets in a worktree are not yours - say which tests hit them; Claude re-runs in the main checkout.
Commit on your branch and push. Do NOT take stills or open any window/image; Claude shoots the still.

## Prior research
LUDO_ROUND37_S202_reply2a.txt / reply2b.txt (the r37 profile layout: header, portrait, 9 attribute tiles, region wear, right
column), TASK_PROFILE2B.md, TASK_PROFILELAYOUT1.md (ProfileLayout geometry module - use it for rects if it has them).

## What would a human do?
Put an opaque page behind a full-screen page, lay the diagram out as figure | table, hide the floor HUD while a page is up.

## Prefab check
None needed - Godot Controls + the existing UIKit/ProfileLayout helpers.

## The one trap
GymHallPanel also carries the HUD V3 work (switch hud_v3, committed today) - keep those lines; touch only the profile open/back
handlers. Never take whole files from master over yours: rebase onto origin/master first (`git pull --rebase origin master`).

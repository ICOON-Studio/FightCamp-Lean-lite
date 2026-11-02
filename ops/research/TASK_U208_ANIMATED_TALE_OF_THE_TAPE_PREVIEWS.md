# TASK U208 - the tale of the tape with LIVE fighters, three previews to pick (UI + 3D, Cursor)
Model: Cursor default (Tools\cursor_task.cmd). Owner: Cursor. Worktree E:/FightCamp/wt/U208, branch cursor/u208-tott-previews (from master).
Operator 2026-10-01, verbatim: "i want the fighters in tale of the tape animated like in real ufc fights (latest DWCS has
nice presentation) assign someone to make previews to pick" and "the tail of the tape needs to be changed according to
our art direction always compare titles from our researches and try to surpass them visually".

## What the operator gets from you
THREE preview videos (MP4, 1920x1080, 30 fps, 8-12 s each, SILENT) + one still per video, each a different tale-of-the-tape
presentation with the two fighters ANIMATED (not still pictures). He picks one; the pick is built into the game in a
follow-up task. This task does NOT replace the in-game screen.

## The reference (research it first - web search is allowed)
- UFC broadcast + Dana White's Contender Series (2025-2026 seasons): fighters shot as looping video cut-outs - a slow push
  in, breathing, a shoulder roll, a glove touch, a hard stare into the lens, a turn from 3/4 to camera; corner colours;
  stats in a centre column; rows that slide in one by one. Find 2-3 real frames/clips (YouTube, UFC.com, broadcast design
  portfolios) and name them in the digest with URLs.
- Our own research: `research/S138_AAA_VISUAL_GAP.md` (section "Tale of the tape": DAZN/Sky layout - cut-outs at
  the edges, centre stat column, bars filling toward the winner, rows wiping in; and how to SURPASS it with camp rows:
  weigh-in fitness, game plan, last-5 form), `research/M34_PITCH_PRESENTATION.md`, `M22_VISUAL_LANGUAGE.md`
  (our art direction: Cage Desk - graphic broadcast plates, sodium #F2C14E / ice #5EC8E0), R85R_UNDISPUTED_HUD.md.

## The three variants
1. DWCS / UFC broadcast: both fighters full-height cut-outs at the left/right edges on a dark gradient, the stat column
   in the middle, rows sliding in, red/blue corner bars.
2. Face-off close-up: head-and-shoulders of both men turning to camera and staring, a split frame, the record + rank as
   big type, the rest of the stats on a lower third.
3. FightCamp's own (surpass): our art direction (Cage Desk plates, brass type) + the camp rows nobody else has (weigh-in
   fitness, camp grade, game plan, last-5 form as W/L pips), each bar filling toward the winner.

## How to make the fighters move (in-engine, real game fighters)
- The fighters are the game's own: `Godot/scripts/FighterLook.gd` (MPFB generator bodies + skins; `apply`, `apply_skin`)
  in a studio scene like `Godot/scripts/FighterPortrait.gd` (105 mm lens, 3/4 view, SSS skin, AgX). Use two DIFFERENT
  legal boxers (different ids, sexes match, same weight class) - operator rule: never identical fighters.
- KNOWN BUG to fix first: FighterPortrait's studio renders white mannequins (the skin texture is not applied in that
  path - compare with the live ring, where `FighterLook.apply_skin` works). Fix it there; say what it was.
- Motion: the guard idle clip the ring uses (`guard_idle` / Bouncing_Boxing_Idle) plus camera moves (push-in, slight
  orbit) and a head turn; a transparent background (`transparent_bg` on the SubViewport, CameraAttributesPractical -
  physical light units make it fully transparent, see godotengine/godot#95805) so the cut-out sits on your layout.
- Render frames with `Tools\godot_hidden.ps1 --path Godot --script tools/u208_tott_previews.gd -- variant=1|2|3`, encode
  with imageio-ffmpeg (see `Tools/anim_previews.py` for the ffmpeg call), `-an` (no audio).
- Faces: the head/body source may change (operator decision pending: MetaHuman / Character Creator 5 / MPFB+). Build the
  layouts so the fighter layer is a swappable render - say in the digest exactly where the fighter comes from.

## Owned files
- `Godot/tools/u208_tott_previews.gd` (new)
- `Tools/u208_tott_encode.py` (new - the MP4 encoder the previews need; added to the owned list S143 by Claude at merge)
- `Godot/scripts/FighterPortrait.gd` (the skin fix only)
- `previews/u208/*` (3 MP4 + 3 PNG + a contact sheet)
- `research/U208_DIGEST.md`

## Prior research
`python Tools/prior_research.py tale tape portrait broadcast` - G128_A_PORTRAIT_THAT_IS_THE_SAME_MAN, G125, R85R, M34.

## What would a human do?
A broadcast graphics designer: shoot the fighters against a key, animate the plates in After Effects, and show the
producer three looks side by side before building one.

## Prefab check
Our own fighters and fonts (`Godot/assets/fonts`: Bebas Neue, Inter, IBM Plex Mono). No purchases.

## Tests (tier: new tool + one script fix)
Parse gate on the touched .gd; `python Godot/tools/run_tests.py --jobs 2 --only portrait,tale_of,fight_night`.
OPEN every still and watch every video before you call it done - a fighter that is a white mannequin, frozen, or cut off
at the head is a fail. Watchdog before every heavy run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`.

## The one trap
Headless draws nothing - every render goes through Tools\godot_hidden.ps1 (windowed, hidden). A SubViewport does not
inherit project anti-aliasing: set msaa_3d on it.

## Finish
git add by explicit path, commit, git push -u origin cursor/u208-tott-previews. Never edit HANDOFF.md. Do not stop at written.

## SEND-BACK 1 (Claude, S138, primary source: docs/previews/u208/u208_contact_sheet.png on the branch, f1a08bc6)
NOT shown to the operator - all three variants fail the "open it" check:
1. FRAMING: the camera frames the crotch/torso; heads are cut off (variants 2 and 3) - frame from the Head bone
   (FighterPortrait.head_position): full-height variant = head at 12-15% from the top, feet in frame; face-off = eyes on
   the upper third line, chin to mid-chest.
2. POSE: the fighters stand in T-pose / A-pose - they must play the GUARD IDLE clip the ring uses (hands up, knees bent,
   weight shifting), plus the head turn to camera. A T-pose in any frame is a fail.
3. TWO FIGHTERS: every variant shows BOTH men (red corner left, blue right) at the same time - today only one is in frame.
4. STATS: the centre column is nearly empty (one AGE row) - fill it: record, age, height, reach, weight, stance, rank,
   KO %, last-5 form pips (+ in variant 3 the camp rows: weigh-in fitness, camp grade, game plan), each row sliding in.
5. Light: a key + rim per fighter in his corner colour (red / blue rim) so they separate from the dark background.
Re-render all three, OPEN the contact sheet and one frame per second of each video, then push. Same branch.

## SEND-BACK 2 (Claude, S139, primary source: u208_contact_sheet.png + frame at 5.0 s of variant_1 and variant_3, e0ff79f9)
NOT shown to the operator. Point 3 (both men) and point 5 (rims) are fixed. Still failing:
1. POSE (point 2 again): at 0 s AND at 5 s both men stand in an A-pose, arms out, knees straight. `ap.play("guard_idle")`
   runs but nothing moves - the grafted clip's track paths do not resolve against this skeleton (the AnimationPlayer's
   root_node / the Skeleton3D path), or the retarget wrote no keys. DEBUG AT THE POINT OF WRITE: print the clip's track
   count, its first track path, and the LeftForeArm global pose before and after `ap.advance(0.5)`; if they match, the
   clip is inert. Prefer what the LIVE fight room already uses for the guard (grep `idle_metadata_for` and the guard
   clip in Godot/scripts/FightWorldLiveScreen.gd / FightClipBinding.gd) over a new retarget. Gloves on: both men wear
   the gloves the ring gives them (FighterKit). A frame without hands up in guard is a fail.
2. TWO DIFFERENT MEN (project rule: never identical fighters): both corners render the SAME body and the SAME face
   though the column says 5'11" vs 6'0". Use two generator fighters that differ in height, build and head, and show it.
3. BARS: every row's bar is the same yellow/cyan split whatever the values - each bar must fill toward the man who leads
   that row (longer reach, better record, higher KO %), equal only when equal.
4. DATA: weight 170 vs 168 on a WELTERWEIGHT card is impossible (boxing welterweight limit 147 lb). Read weight and
   division from the fighters' real data; a booking must match the weight class.
5. FRAMING variant 3: both heads are cut by the top edge again - head 12-15% below the top, as point 1 said.
6. SHORTS: a jagged white band runs round both waistbands and leg hems (a texture/UV seam) - fix or use the ring's trunks.
Re-render all three, OPEN the contact sheet AND one frame per second of each video, then push. Same branch.

# FP2POSE1 - the blue cross that looks away and "crosses its legs"; the guard that reads weak (owner C454, C458)

S536, 2026-11-21. Fight player v2 only (METHOD S510). Follows FIGHTPLAYER2_SCOPE_S510 and the S529 stance refit study.
Tools: `tools/fp2pose_probe.gd` (numbers, headless, read after every layer), `tools/fp2pose_still.gd` (game-camera stills,
the same frames every run). Stills: `ops/previews/s536_fp2pose/`. The owner closes this, not a test.

## C454 - the blue cross ("wtf is that legs doing and where the fuck is he looking at")

The still plays `pro_right_cross` (Punch PRO, Box1_M3_Right_Cross) frozen at its contact, 0.30 s in.

| at the contact | before | after | a real cross |
|---|---|---|---|
| face off the other man's head (turn) | 86 deg | 9 deg | eyes on the target, chin behind the shoulder |
| the same, worst of the 8 cross takes v2 plays | 27 - 86 deg | 3 - 16 deg | |
| head against the chest | 17 deg FURTHER round | 60 deg back | |
| chest turned past the fight's line | 69 deg | 69 deg (the take's own) | 45 - 70 |
| left foot left of the right foot (across the line) | 47 cm | 32 - 47 cm | never crossed |
| the least over all 8 takes | 22 cm | 23 cm | |
| lead foot ahead of the rear | 42 cm | 39 - 42 cm | |
| rear knee | 164 deg (straight) | 163 | bent, heel up |
| rear foot turned out | 27 deg (38 in the guard: it pivots 11) | the same | pivots 40+ on the ball |

**Where he looks - cause.** It is in the bought take itself, not in our bake, the stance refit, the step layer or the
facing. Read off the raw FBX in Blender: the actor's head is 76 deg off his own punch line at the contact, 21 deg further
round than his chest (he shadow-boxes: nobody stands in front of him, his head rides his shoulders). Our bake copies it
(86 deg against the line to the other man; the same number with every pose layer off). And v2 had **no gaze at all**: the
shipped player's head layers are switched off under v2, and nothing replaced them.

**The legs - cause.** The feet do NOT cross: the left foot stays 22 cm or more to the left of the right through every
cross take. What reads as scissored legs is the upper body: on the side-on camera the chest (69 deg) and the face (86 deg)
point into the lens, so the eye reads a man standing FRONT-on - and then his side-on split stance looks like one leg
crossed over the other, and his forward lean looks like tipping sideways. The part that IS the legs: the actor throws it
flat-footed. The rear foot pivots 10 deg in the raw file (11 on our body) while the hips turn 54, and the rear knee stays
straight (159 raw, 164 drawn). That is the take as bought.

**Fix (in v2, at the cause).** `scripts/fight3d/v2/Gaze.gd`: the take gets the one thing a shadow boxer has not got, a
target. The neck and head turn until the face is within 6 deg of the other man's head as drawn, never more than 70 deg
against the chest (the chin goes behind the punching shoulder); the chin stays down but the eyes are at most 15 deg under
the line to his head. A man being hit, down, or in a director's scene keeps the take's own head. `-- fp2nogaze` = as before.

**Not fixed, said plainly: the flat rear foot.** The rear-foot pivot is missing from all 8 Punch PRO cross takes. Putting
it in is a re-bake of those takes (turn the rear foot about its ball with the hips, lift the heel, solve the leg again),
the same kind of offline work as the S529 refit - not a runtime layer. It needs its own item and a film.

## C458 - the blue woman's guard ("legs are weird and looks like a weak 12 year old kid")

The guard take itself (`st_wait_g` on mh_boxer_10, steady, every layer on) against a real stance:

| | measured | a real boxing stance |
|---|---|---|
| feet apart across the line / along it / in all | 32 / 35 / 47 cm (men 33 / 36 / 49) | about shoulder width across, 1 to 1.5 of that along |
| knees | 148 and 143 deg, each 0 to 4 cm OUTSIDE its hip-ankle line | soft, over the toes - not knock-kneed |
| trunk | 2 deg forward, chest 1 cm over the hips | hips under the shoulders |
| hips and chest turned from the line | 47 and 41 deg | bladed 30 to 45 |
| lead toe / rear toe | 23 / 55 deg turned in | 15-30 / about 45 |
| face under the line to the other head | 24 deg (now 15 with the gaze) | chin down, eyes up |
| shoulder joints apart | 27 cm (the men: 36) | - |

So the take is a boxer's stance, a little narrow and at the far end of bladed. **The picture he marked was not this
pose.** Three causes, by size:

1. **The still tool.** `tools/fight3d_still.gd` freezes the SHIPPED player's clips (`cross`, 154 bones keyed, bone
   positions too) behind v2's back and shoots 0.1 s after asking v2 for the guard. Replayed in numbers
   (`fp2pose_probe.gd only=c458`): the trunk leans 15 deg sideways and 11 forward, the chest is twisted 18 to 26 deg
   against the hips, the feet are 4 cm narrower - and it STAYS so (the same 1.5 s later): rounded shoulders, hips back.
   A pose the v2 fight never shows. Fixed: the tool refuses to run under v2 and names `tools/fp2pose_still.gd`, which
   plays v2's own takes.
2. **Why it stays (found, fix written, NOT yet measured).** A bone the last clip keyed and the next clip does not key
   stays where it was left. Punches, reactions and every Punch PRO take key 26 bones; v2's waiting and step takes key 23
   (not spine_02, spine_04, neck_02 - their bake takes those joints to stand at rest); the corner-minute clips key 49-55.
   So a man back in his waiting take can stand on the in-between trunk joints of whatever played before, until his next
   punch resets them. How big that is inside a fight is not measured: the PC ran out of memory (98 %) and the batch was
   stopped. The fix (the step takes key those three joints at rest, in `StepClips.load_into`, switch `fp2nofold`) is
   below as a patch, NOT in the tree, because nothing has run it.
3. **Body shape (BODYTEX2's, not touched).** mh_boxer_10 reads slight whatever she does: shoulder joints 27 cm apart
   against the men's 36 (three quarters), thin upper arms and thighs. For her to read as a fighter the body needs wider
   shoulders (about 30-31 cm between the joints), fuller deltoids and thighs. Pose cannot give that.

Also true in the fight, not fixed here: the feet are pinned where the last take left them, so the guard's width is not
one number - across the line it read 23 to 51 cm on the same man, by which cross he had just thrown (FootTake steps a
foot back only when it is 17 cm off). The S529 critics' "stance width jumps". It wants its own measured change.

## Prefab check
Mixamo cross takes are in his Downloads (Cross_Punch, Back_Hand_Cross, Boxing_Jab_Cross_*). Not measured: the PC was RED
when their turn came. Measure head and rear-foot pivot with the Blender script before any re-bake of the PRO crosses.

## Tests
`tests/player2_test.gd` GAZE (blue's face within 25 deg of red's head around the contact, all 8 cross takes) and FEET
(left foot 10 cm or more left of the right). With `fp2nogaze` (today's take): **FAIL GAZE worst 86 deg, pro_right_cross**;
with the gaze: PASS, worst 20 deg. FEET passes both ways (least 23 cm) - the feet never crossed.
Regression with the gaze on: player2_test failures=0 (landed gloves median 0.006 m, 14 of 14; JUMPS 1 and SLIDE 6.67 / 6.92 m
are the same DEBT with and without it), choreographer_test failures=0, arm_build_test failures=0.

## The patch that waits for a run (step takes key the folded joints)
```diff
diff --git a/scripts/fight3d/v2/StepClips.gd b/scripts/fight3d/v2/StepClips.gd
index 2eabeea20..d89b96606 100644
--- a/scripts/fight3d/v2/StepClips.gd
+++ b/scripts/fight3d/v2/StepClips.gd
@@ -41,6 +41,13 @@ const REFIT := {
 ## S531 (the owner: "they look like robots" - both men bounced ONE loop): red waits in st_wait, blue in st_wait_g
 ## (Player2.WAITS). Boxing_Idle was tried as a third: refitted it stands knock-kneed (the hips come down 7 cm for reach).
 const LOOPS := ["st_wait", "st_wait_g"]
+## S536 FP2POSE1 (the owner on a guard still, C458: "legs are weird and looks like a weak 12 year old kid"): the step
+## takes are baked through three MetaHuman joints they do not key (RkRetarget folds them: they are taken to stand at
+## their rest), but every other take keys them - and a joint the last take moved and the next does not key STAYS where
+## it was left. A man back in his waiting take stood on the trunk and neck of whatever played before (tools/
+## fp2pose_probe.gd only=stuck). Every step take now keys them, at the rest it was baked on. `-- fp2nofold` = as it was.
+const FOLDED := ["spine_02", "spine_04", "neck_02"]
+static var fold_on: bool = not OS.get_cmdline_user_args().has("fp2nofold")
 
 
 static func names() -> Array:
@@ -66,6 +73,13 @@ static func load_into(lib: AnimationLibrary, skel: Skeleton3D, prefix: String) -
 			if anim.track_get_type(t) == Animation.TYPE_POSITION_3D:
 				for k in anim.track_get_key_count(t):
 					anim.track_set_key_value(t, k, rest + (anim.track_get_key_value(t, k) as Vector3))
+		for joint in (FOLDED if fold_on else []):
+			var jb := skel.find_bone(str(joint))
+			var jp := NodePath("%s:%s" % [prefix, str(joint)])
+			if jb >= 0 and anim.find_track(jp, Animation.TYPE_ROTATION_3D) < 0:
+				var jt := anim.add_track(Animation.TYPE_ROTATION_3D)
+				anim.track_set_path(jt, jp)
+				anim.rotation_track_insert_key(jt, 0.0, skel.get_bone_rest(jb).basis.get_rotation_quaternion())
 		anim.loop_mode = Animation.LOOP_LINEAR if str(name) in LOOPS else Animation.LOOP_NONE
 		lib.add_animation(name, anim)
 		added.append(name)
```
Check with a probe that plays a take, returns to the guard and prints those joints' angle off rest, with and without
`fp2nofold`; then player2_test, choreographer_test, arm_build_test and the stills again.

# Maria reply via xAI API (model grok-4.7, route responses+web_search (stream), 10594 chars, 239 s)
# Task: research/TASK_M43_JAB_GUARD_BAR.md

I’ll lock the jab and live-guard bar to measurable stills: pose angles, body read, and named broadcast/coaching references the animator can match.The last stills failed four reads: splayed arms, no gloves, a bulging torso, and a hook that wrapped the fighter’s own head. A frozen guard is not a pass either. Next sheet is orthodox (mirror it for southpaw), existing MetaHuman, existing gloves, existing gym lights. No new asset purchase. If a box below is unticked, it does not come to me.

## How the still is shot

Approval stills are not the wide profile viewer. That lens plus bare hands made every retarget fault look like a costume.

- **Camera.** Two frames per moment, same body, lead foot pinned so the three jab frames overlay. Beauty: broadcast 3/4, 35° off the lead side, camera at 1.7 m, tilt down 8°, horizon through the chest. Godot `Camera3D` vertical FOV **28–32°** (about a 50 mm). Do not send the wide gameplay FOV — it balloons the gut and throws the elbows out. Check frame: pure lead-side profile, same height, fist path parallel to the film plane. Fighter from mid-thigh to a hand of headroom. No DOF. No bloom.
- **Light, so the pose can be measured.** Key `#FFD7A8` (about 4000 K), front-left, 40° off axis, 35° up. Fill `#8EAE9A` off the canvas, key:fill about 3.5:1. Rim `#FFB067` from back-right, kissing the rear glove and the trap. Shadows on. Apron behind him `#14171C`, canvas `#1E4D3A`, so the silhouette is the first read.
- **Proof shadows.** Rear glove must cast a contact shadow on the cheek. Lead shoulder must shade the chin at contact. A lit gap means the hand is floating. A fully lit chin means the shoulder missed.
- **Materials, current meshes only.** Skin roughness 0.45–0.55, shadow `#6E4638`, lit `#C4896A`, tight spec `#E0B09A`. SSS small and warm in the ear only — wax skin is part of the “not a human” read. No fresnel rim; that draws a line around every limb and brings the stitch back. Gloves on: leather `#B42334`, roughness 0.32–0.38, metallic 0, cuff `#F3EDE4`. Wraps `#EFE8DC`, a 3–4 cm band between cuff and forearm. Trunks `#1B2744`, waistband `#E3B341` — that band is the waist mark. Shirtless or the existing tight vest. No baggy tee.

## 1. Jab — three stills

Straight punch, not a lead hook. Fist path from chin to target stays inside one glove-width (~10 cm) of a straight line. If the glove finishes nearer his own rear ear than the opponent’s face plane, it is the rejected wrap. Palm starts in, finishes down; rear hand never leaves the cheek.

| | Chamber | Mid-extension | Contact |
|---|---|---|---|
| Lead shoulder | Line ~40° off the opponent’s center. Deltoid is the outer point, not a dropped shelf. | Risen ~10–15° and rolling in. Chin starting to sit in the pocket. | Up ~20–25° from chamber. From the opponent side the jaw is ≥ half hidden behind the deltoid. |
| Chin | Tucked, pitch down ~15°. Not on the chest. | Still down. Head 4–6 cm off the centerline, outside the lead shoulder. | Pitch still ~15°. Head 8–12 cm offline, outside. Eyes down the arm. |
| Rear glove | Knuckles on the cheekbone, ≤2 cm. Contact shadow. | Still ≤2 cm. Elbow has opened ≤10°. | Still on the cheek. Contact shadow. If it has dropped to the chest, fail. |
| Elbow line | Lead flexion ~85° (75–95°). Rear ~90°. Both elbows inside the lat. Point down, not out. | Lead opening through ~110–120°. Elbow **below** the fist, ≤15° off the punch line. Wider than the shoulder = the splayed reject. | Lead **168–175°**. Not locked dead straight, not under 155°. Elbow still under the fist. |
| Fist | Palm in, thumb up. Rotation 0. | Pronation ~45°. Palm not yet flat. | Palm down, 85–95°. Thumb toward the midline. Wrist kink ≤5°. First two knuckles in line with the forearm. |
| Hip and lead foot | Hips at stance. Weight ~55% rear. Knees ~20°. Lead foot planted. | Hips +8–12° only. Rear heel just unweighting. No chest past the lead knee. | Hips **+15–25° total**, not 40°. Weight ~60% lead. Spine pitch ≤10°. Rear heel light. Lead knee over the lead foot. |
| Head vs arm | Hands in front of the face, not beside it. | Fist has not arced outside the shoulder. | Fist, elbow, and shoulder nearly stack in profile. Belly is not the closest point to camera. |

A coach’s jab is a small body turn, on the order of 30°, with the arm staying quiet until the shoulder has come across — not a hook rotation. Another coach’s version is even quieter: an arm snap with the delt brought to the chin, specifically not rotated like a lead hook. Our bar is the quieter shape. Hips stop at 25°. Shoulders cover the chin. The arm does not wrap. Palm finishes down, elbow stays under the fist the whole way, rear hand stays glued to the face, wrist stays straight. The return is the same line, faster than the extension. A jab that hangs out is a pose.

## 2. Guard is a cycle, not a stance

Send three guard stills plus the feint peak, same camera. Label the Godot times. On a 1.8 m body, 6 cm is `0.06`.

Between punches, measure the delta, don’t pose a statue:

- **Hand drift.** Lead glove orbits 4–8 cm vertical, 3–6 cm depth, 2–4 cm lateral, around the cheek. Rear glove 2–4 cm, and stays within 2 cm of the cheek plane. Rear hand is the anchor. Lead hand is the one that lives.
- **Bounce.** Two layers. Breath, 3–4 s: shoulders +1–2 cm, gloves +2 cm, ribs +1 cm, no belly balloon. Ready pulse, 1.5–2 Hz, capped at 1–3 cm. Above 4 cm at that speed it reads as a bug, not a fighter.
- **Elbows.** Lead breathes ±8–15° around an ~85° base. Rear ±8°. Neither elbow crosses the outer lat line. A flared guard is the same fault as the splayed jab.
- **Weight.** Oscillate between about 55/45 and 45/55 over 1.5–3 s. Knees stay soft. Head bobs 2–4 cm. The head does not nod forward ahead of the hands — that is a telegraph, and it is the bulge shot from a new angle.
- **Rhythm on the sheet.** Frame A breath-low, frame B breath-high, frame C lead glove 4 cm forward and 3 cm up from A, rear glove only 2 cm up and still on the cheek. If A and C are the same pose, it is still a still guard.

When the opponent feints, the hands go **closer to the head**, then leave again:

- 0–100 ms: eyes, chin +5° down. Hands have not flown.
- 100–250 ms: both gloves 3–6 cm in toward the skull, elbows pinch 10–15°. Jab-side feint: lead shoulder also lifts 10–15°, weight settles ~60% rear. Body feint: rear elbow drops ~15° over the short rib, lead glove stays at the cheek. Both hands dropping is a fail.
- By ~400 ms, if nothing arrived, the gloves have started back out into the orbit. Do not hold the shell. A tight guard frozen longer than about 0.3 s is the same note he already gave us.

Feints do not drop the rear hand. The rear glove stays on the chin while the lead shoulder or the lead hand does the answering.

## 3. Body — athlete from this camera

Measure on the chamber beauty and the profile, before anyone looks at the punch.

- Shoulders read **≥1.4×** the waist on the 3/4 frame. Target 1.5. The gold waistband is the mark. If that band is as wide as the chest, fail.
- Neck narrower than the head. A cylinder with no shadow under the jaw is a stuffed retarget, not a heavyweight.
- Profile: chest is the forward point, then a waist in, then the hip. If the abdomen leads while the jab is still chambered, the spine is folded and the mesh is being pushed out. That is the “too fat” note.
- Deltoid is a cap on the shoulder tip. There is a hollow under the jaw and a shadow at the pit of the neck. Gloves and the wrap break the sausage arm.

Three retarget faults that read as parts stitched together. Spot them on the still, fix them on this skeleton.

1. **Clavicle collapse.** A shelf or dent between neck and deltoid, arm root inboard of the shoulder mesh, elbows hung wide even in chamber. Line from the base of the neck to the shoulder tip should slope gently down and out. A flat line, a V, or a dip means the clavicles came across from the source pose wrong — a known MetaHuman retarget miss. Separate the clavicle chain from the arm chain and set the rest pose so the shoulders sit level. Do not buy a body.
2. **Arm twist / pole vector.** This is the splayed jab and the hook around his own head. On the profile the elbow is not under the fist. On the 3/4 the forearm crosses the face or the glove points at his own ear. Thumb at the floor at full extension means the twist is inverted. Pole vector stays down and in. Check thumb-up at chamber and thumb-to-midline, palm down, at contact.
3. **Spine scale hunch.** Ear in front of the chest, chin over the sternum, gut is the silhouette leader, and a shading break at the neck or the deltoid insertion. That break is the stitch, even when the pose is close. It comes from forcing a different torso length through the spine chain. Fix the spine FK offset on the retarget. If this MetaHuman already has a leaner body blend in the project, use it. Do not commission a mesh, and do not hide it with a wider vest.

## 4. References — freeze these, copy the shape only

No packs, no purchases. Three sources.

1. **Larry Holmes vs Gerry Cooney, 11 June 1982, Caesars Palace, HBO.** Any early-round jab at full extension. This is the contact still: long arm, shoulder on the chin, rear hand home, palm down. Coaches still call that shape the Holmes whip. Do not copy his height. Copy the line of the arm.
2. **Floyd Mayweather Jr. vs Canelo Álvarez, 14 September 2013, MGM Grand, rounds 1–2.** The live guard and the probing jab. Hands drift, gloves bounce, they snug to the cheek when Canelo steps or feints, then they drift back out. Same habit is readable in **Mayweather–Pacquiao, 2 May 2015**, early rounds. Do not copy the lean he sometimes puts on the front foot — that lean is an opening, not the bar.
3. **Tony Jeffries with Seth, “Former Olympic Boxer Makes My JAB More Effective,” Sensei Seth, YouTube, 2 Dec 2021.** Shoulder brought to the chin, rear hand stays up, jab while the feet move, feint then jab. Use his feint-response timing for section 2. Free to scrub frame by frame.

## Pass line

Gloves on. Rear glove has a contact shadow on the cheek in all three jab frames and all four guard frames. Lead elbow never outside the shoulder. Contact elbow 168–175°, palm down, chin behind the lead shoulder, hips ≤25°, fist path inside one glove-width of straight. Guard frames A and C are not the same pose. Feint frame has the gloves closer to the skull, and the clip shows them leave again inside half a second. Waistband visibly narrower than the shoulders. No neck seam, no shoulder shelf, no gut leading the profile. Shot on the 50 mm broadcast camera, not the wide viewer.

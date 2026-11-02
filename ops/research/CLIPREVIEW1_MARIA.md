# CLIPREVIEW1_MARIA - Maria answer (seat queue SQ2)

Brief: research/CLIPREVIEW1_SEAT_MARIA.md
Sent: 2026-10-19 04:21 | collected: 2026-10-19 05:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm on the fight-motion review now. First I'm pulling sourced numbers on punch speed, footwork and spacing, so the speeds and distances aren't guesses, and then I'll write the full answer from the art-direction side.

I'll send the full review once the sourced numbers are in.

**1. Which reads more like two real boxers, and where the motion breaks**

The "after" clip is the better one, and the blue boxer is the closer of the two to a real fighter. The teleporting is gone (zero frames above 4 m/s). Blue stands at boxing height (only 5 frames below 0.70 m) and moves more calmly (66 frames above 1.5 m/s, against red's 140). It still doesn't read as a boxing match from the broadcast camera, and here's why, in order of how much each hurts the picture:

- **Spacing.** At a 0.557 m chest-to-chest distance, two adult chests are almost touching. A typical chest is roughly 0.25 to 0.30 m deep, so the gap between them is about 0.25 to 0.30 m. That's my estimate, not sourced. Add red's forward lean and the torsos overlap. From a high three-quarter camera, merged torsos turn two boxers into one blob, and that kills the read before anything else gets a chance.
- **Red's posture.** 116 frames with the hips below 0.70 m means a deep, knees-bent crouch, plus a lean into blue. Real boxers punch from a moderate knee bend. Dinu & Louis (2020) measured knee angles of about 142 to 147° at impact, with the body's centre of mass about 0.9 m up ([Dinu & Louis 2020](https://pmc.ncbi.nlm.nih.gov/articles/PMC7739747/)). Red's silhouette reads as a wrestler shooting for the legs, not a boxer.
- **Feet.** 13 to 15% of planted frames slide, so the feet glide over the canvas. That's what the operator means by "legs fly, not walk".
- **Torso twist.** More than 50° on 19 frames isn't wrong in itself, because a hook or cross rotates the shoulders a lot. It looks weird when the shoulders twist while the hips and feet don't follow. Real rotation runs up from the ground: rear foot, then hips, then shoulders, then arm. Cheraghi et al. (2014) found the ankle, knee and elbow start extending at about 45%, 60% and 80% of the punch cycle ([Cheraghi 2014](https://aassjournal.com/article-1-136-en.pdf)). A torso that twists on its own, with planted, sliding feet, reads as a broken spine.
- **Stance width.** Feet more than 0.95 m apart on 25 to 29 frames is too wide for most boxers. A boxing stance is about shoulder width or slightly wider ([myboxingcoach](https://www.myboxingcoach.com/stance-and-on-guard/)). For a typical adult man that's roughly 0.45 to 0.65 m, which is my estimate. Over 0.95 m is a lunge.

**What the two should look like side by side (art direction)**
- **Silhouette:** two upright, slightly bent figures in a bladed stance (lead shoulder towards the opponent, about 30 to 45° side-on), chins tucked, and gloves up at the cheekbones. Two clear vertical shapes with a visible gap of canvas between them.
- **Height:** both heads at roughly natural height minus 5 to 10 cm for the knee bend. If one boxer is consistently a head lower, the viewer reads it as a mismatch or a knockdown.
- **Lean:** the spine leans forward 10 to 15° from vertical at most during a punch. It never folds at the hips into the opponent.
- **Broadcast camera:** at a high three-quarter angle, put the gap between the two boxers across the frame, not along the camera's line of sight, so the canvas between them is always visible. If the camera looks straight down the line between the two fighters, they overlap on screen even when they're apart in the 3D scene.
- **Colour:** bare feet and red gloves on both boxers throw away an easy read. Both should wear the Hightops boots and kit colours from M43, with gloves in each boxer's own kit colour, so the eye can follow each boxer's hands.

**2. Feet: what planted feet do in a punch, and when a foot must move**

A planted foot never slides. It can do three things:
- Stay locked.
- Pivot on the ball of the foot, with the heel turning and lifting while the ball stays put.
- Lift and step to a new spot, landing and locking again.

Anything else is a glide.

**What the research says:**
- In a jab, the rear leg pushes. Stanley et al. (2018) measured peak ground force of about 0.63 N/kg on the lead foot against 1.56 N/kg on the rear in the jab. In the cross it was 1.06 against 1.21. ([Stanley 2018](https://chesterrep.openrepository.com/server/api/core/bitstreams/3e769a4f-d46b-4921-a2e9-093e0a80e436/content))
- In the cross, weight moves forward. Elite boxers at impact had about 60% of their vertical force on the lead foot and 40% on the rear. In the hook it was about 59/41, and in the uppercut about 50/50 (Dinu & Louis 2020).
- In a rear straight punch, the hips move about 28 cm towards the target, and the ankle and knee extend by about 12° and 25°, which is the leg drive (Cheraghi 2014).
- I found no study with step lengths, the rear heel's pivot angle in the cross, or the lead foot's pivot in the hook. Treat the numbers below as animator starting points, NOT VERIFIED.

**Per punch (starting points to tune by eye)**
- **Standing jab:** both feet locked. The weight shifts slightly forward through the rear leg's push; the feet don't move.
- **Stepping jab:** the lead foot lifts a few centimetres and steps forward about 15 to 25 cm. The step lands at the same moment as the punch or just before it. The rear foot then slides up by the same distance, a push-step that lifts rather than drags. That lift is what separates it from a glide: the rear foot leaves the canvas.
- **Cross:** the lead foot stays locked. The rear heel lifts and turns outward 45 to 90° on the ball of the foot, with the ball pinned in place. The rear knee turns in, and the hips rotate before the shoulders.
- **Lead hook:** the rear foot stays locked. The lead heel lifts and the lead foot pivots inward on the ball, roughly 45 to 90°, with the knee turning in the direction of the punch.
- **Uppercut:** both feet stay locked. The punching side's knee bends then extends, so the power comes from the legs, and the heel on that side can lift slightly.
- **Footwork between punches:** a small step-and-slide, 10 to 30 cm per step. The foot nearest the direction of travel moves first: the lead foot when moving forward, the rear foot when moving back. The feet never cross, and the stance width comes back after every step.

**Your 5% target and the slide measure.** Check how your sliding number is defined before chasing 5%. In NVIDIA's Kimodo benchmark, a foot counts as sliding while it's on the floor (toe below 0.05 m) and moving faster than 0.2 m/s. Their sample numbers show even real motion capture scoring about 12 to 14% on that measure ([NVIDIA Kimodo metrics](https://research.nvidia.com/labs/sil/projects/kimodo/docs/benchmark/metrics.html)).
- A pivot moves the heel without moving the ball, so separate "ball of foot moving" from "heel turning". Only the first is a slide.
- I'd set the target on the ball of the foot: under 1 cm of movement per planted step.

The fix is what Ubisoft's motion-matching talk recommends: lock the toe when it barely moves in the source animation ([Clavet, GDC 2016](https://archive.org/download/GDC2016Clavet/GDC2016-Clavet_djvu.txt)). Use foot IK to pin it, and blend only while the foot is in the air.

**3. Punch speed: real numbers and what to show**

**Real fist speeds, peak (m/s)**
- **Stanley 2018 (amateur boxers):**
  - Jab 5.85 ± 0.85
  - Cross 6.97 ± 0.86
  - Lead hook 11.95 ± 1.84
  - Rear hook 11.48 ± 1.90
  - Lead uppercut 10.60 ± 2.30
  - Rear uppercut 11.55 ± 1.72
- **Dinu & Louis 2020, elite versus junior, at impact:**
  - Cross 8.1 versus 8.1
  - Hook 11.2 versus 8.9
  - Uppercut 10.2 versus 7.3
- **Kimm & Thiel 2015:** jab 8.1 ± 1.4 (men) and 6.6 ± 1.6 (women); cross 7.7 ± 1.5 and 5.7 ± 1.5 ([Kimm & Thiel 2015](https://doi.org/10.1016/j.proeng.2015.07.232)).
- **Whiting 1988:** peak speeds 6.6 to 12.5 m/s, reached 8 to 21 ms before contact ([Whiting 1988](https://pubmed.ncbi.nlm.nih.gov/3377096/)).

So the jab and cross peak at about 6 to 8 m/s, and hooks and uppercuts at about 10 to 12. Elite boxers are faster than juniors mainly on hooks and uppercuts; on the cross they're about the same.

**Real timing (ms)**
- **From the start of the wind-up to contact (Stanley 2018):**
  - Jab 405 ± 150
  - Cross 495 ± 150
  - Lead hook 657 ± 145
  - Rear hook 586
  - Lead uppercut 627 ± 103
  - Rear uppercut 606 ± 100
- **The visible arm-extension phase is much shorter:**
  - Cheraghi 2014 timed a rear straight at 310 ± 60 ms from fist motion to impact, with the fist travelling about 0.655 m. The elbow's extension phase alone was 105 ± 20 ms.
  - Piorkowski et al. (2011) measured about 223 ± 99 ms for a single maximal cross from the forearm starting towards the target to contact ([Piorkowski 2011](https://knowledge.lancashire.ac.uk/id/eprint/3757/1/piorkowski-et-al-2011-punch-kinematics.pdf)).
- **Return to guard:** NOT VERIFIED. No study I found measures it. Cheraghi notes the return is slower than the throw, and Kimm & Thiel couldn't measure it reliably.
- **Elite against amateur timing:** NOT VERIFIED. No study compares it.

**Why your jab "fires like a bullet"**

A real jab isn't instant. It's about 0.4 s from the first shift of weight, and the arm's final snap is only about 0.1 to 0.2 s. A viewer reads the whole thing: the weight shift, the snap, and the slower return. If our jab is just the snap, guard to full extension with no wind-up and a fast snap back, it reads as a muzzle flash, even if the fist speed is realistic. Please measure our jab's guard-to-extension time and peak glove speed in the clip. I can't see our clip data, so I don't know the current numbers.

**How games show it**
- Street Fighter 6's standing light punch hits after 4 frames, about 67 ms at 60 fps, and takes about 7 frames to recover ([SF6 Ken frame data](https://www.streetfighter.com/6/en-us/character/ken/frame)).
- Tekken 8's generic jab hits on frame 10 (about 167 ms) and lasts 29 frames in total ([Tekken generic movelist](https://wavu.wiki/t/Generic_movelist)).
- These count from the button press, not from a wind-up, so they aren't directly comparable to the studies.
- Fighting games add readability by freezing both characters for a few frames at the moment of contact (hit-stop). Capcom describes typical values of 8, 12 and 16 frames for light, medium and heavy hits, "to give the player a sense of the attack hitting as well as the weight". Capcom also notes that a move that misses "may move so fast that you can barely see it" ([Capcom SF Seminar, Hour 11](https://game.capcom.com/cfn/sfv/column/131545?lang=en)).
- I found no source on how EA's Fight Night times its punches, or on broadcast slow-motion conventions.

**What I'd show (art-direction targets for a watched simulation, NOT VERIFIED; tune by eye)**
- **Jab, about 0.40 s in total:**
  - About 80 to 120 ms of anticipation: the weight shifts forward and the shoulder starts to turn.
  - About 100 to 150 ms of extension.
  - About 30 to 50 ms holding at full extension.
  - About 150 to 250 ms back to guard, slower than the throw.
  - That keeps the true peak speed (about 6 to 8 m/s) but gives the eye a beginning and an end.
- **Cross, about 0.50 to 0.55 s:** a longer anticipation, with the rear heel pivot and hips leading. Hold 40 to 60 ms, return 200 to 250 ms.
- **Hooks and uppercuts, about 0.60 to 0.70 s:** a visible load-up in the knees and hips, a fast whip in the middle (the glove is faster than a jab, about 10 to 12 m/s), and a heavier return.
- **On contact:** freeze both bodies for 2 to 4 frames on a clean hit (about 33 to 67 ms), and 0 to 1 frame on a blocked or glancing one. That's a much lighter version of Capcom's hit-stop. We're a watched simulation, not a fighting game, so the freeze is for weight, not for player timing.
- **Don't slow the punch itself into slow motion.** Keep real speed in the middle of the move and add the time to the anticipation, the hold and the return. Slow motion is for replays only.

**4. Spacing: chest-to-chest distances and how games stop torsos merging**

**What's sourced**
- A lab dodge study set attacker-to-target distances of 75, 85 and 95 cm, chosen to sit just beyond the attacker's fully extended arm ([Rev. Psicol. Deporte 2017](https://ddd.uab.cat/pub/revpsidep/revpsidep_a2017v26n2/revpsidep_a2017v26n2p87.pdf)).
- In a rear straight punch, the lead foot ends about 0.50 m from the target (Cheraghi 2014).
- I found no sourced clinch distance and no average reach. Arm span is roughly equal to height.

**What I'd use: chest-centre to chest-centre (my estimates from arm length plus torso depth, NOT VERIFIED; tune in-engine)**

| Range | Chest-centre to chest-centre | What it looks like |
|---|---|---|
| Outside, out of range | 1.4 to 1.8 m | Clear canvas between them, feeling each other out |
| Jab range | 1.1 to 1.3 m | Arm's length plus a step; the jab just lands |
| Hook and uppercut range | 0.7 to 0.9 m | Close, but a visible gap between the chests |
| Clinch | 0.35 to 0.50 m | Chests touch or nearly touch, with heads to one side |

At 0.557 m, the engine is holding everything in clinch range. The two boxers should only be that close when they're actually clinching.

**How fighting games stop bodies merging**
- **Street Fighter's collision box:** a box on the body, without the arms and legs, that exists "to keep two characters from overlapping". Walking into the other character pushes them back, and when special moves end overlapped, the two are separated sideways ([Capcom SF Seminar, Hour 7](https://game.capcom.com/cfn/sfv/column/131422?lang=en)).
- **Pushback on hit or block:** the defender slides back further for heavier attacks. In the corner, the attacker moves back instead ([Capcom SF Seminar, Hour 11](https://game.capcom.com/cfn/sfv/column/131545?lang=en)).
- **EA's Fight Night Round 4:** built on physics, with full-body collision between the two boxers, punches that re-aim based on how close the boxers are, iterated collision volumes, and a dedicated clinch tie-up ([GameSpot, Fight Night Round 4](https://www.gamespot.com/articles/fight-night-round-4-the-physics-of-fighting/1100-6233939/)).

**What I'd do for us**
- Give each boxer a torso capsule about 0.30 to 0.35 m in diameter, from hip to shoulder height, plus a head sphere. Arms don't get capsules. Never let the two torso capsules overlap.
- Instead of a hard push, give each range a preferred distance (from the table) that the simulation steers towards with footwork steps. That way the boxers step back to range, which matches the feet fix, rather than being shoved apart by physics.
- Make the punch reach the opponent, not the other way round. Pick the punch from the current distance, and make small IK adjustments to the arm, a few centimetres, so the glove lands on target. Don't move the body forward to make a punch connect.
- Treat the clinch as its own state with its own animation, where chest contact is allowed and expected.

**5. The three things to fix first, in order**

**1. Spacing and torso collision.** Merged torsos make two boxers unreadable from the broadcast camera before anything else is visible.
- An animator would add body capsules with a no-overlap rule and set preferred distances per range.
- The punch would be chosen from the current distance, and IK on the arm would land it.
- The clinch would be a separate state with contact allowed.
- Red's forward lean would be capped at about 10 to 15° and the crouch limited (hips not below about 0.80 m outside of defensive ducks), so red stands like blue.
- **Success means** chest centres stay at or above 0.70 m apart outside the clinch, and canvas is visible between the boxers on every frame.

**2. Planted feet.**
- Lock the ball of the foot with IK whenever the source animation's foot is nearly still.
- Let pivots rotate the foot around its ball.
- Allow foot moves only as lift-step-land, with the foot clearly off the floor.
- Keep stance width between about shoulder width and 1.5× shoulder width, recovering after each step.
- Fire the pivot from the feet up, so the torso can't twist past the hips.
- **Success means** the ball of a planted foot moves less than 1 cm, and stance width never goes above about 0.75 m outside a deliberate lunge.

**3. Jab timing, and every punch's anticipation and recovery.**
- Keep the real snap speed (about 6 to 8 m/s for the jab) but add a visible wind-up: weight shift, shoulder turn and the rear foot pushing.
- Hold briefly at full extension and slow the return.
- Hit-stop is 2 to 4 frames on a clean hit only.
- Scale the cross, hooks and uppercuts up from there.
- **Success means** a viewer at 1080p and on a phone can name each punch as it happens, and the operator stops calling the jab a bullet.

Once those three are in, the remaining things are presentation: the Hightops boots, kit-coloured gloves from M43, and camera framing that puts the canvas gap between the boxers across the frame. Those are quick wins that make the match read at a glance. The research notes behind every number are saved on my computer at `/workspace/clipreview1/research.md`; I can copy them to Beast if you want them next to this review.

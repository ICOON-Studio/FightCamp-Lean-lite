# CLIPREVIEW1_JOHN - John answer (seat queue SQ1)

Brief: research/CLIPREVIEW1_SEAT_JOHN.md
Sent: 2026-10-19 04:21 | collected: 2026-10-19 04:40 by Tools/seat_queue.py (the 30-min reconcile)
Attachments on the bot's box (not downloaded): CLIPREVIEW1_JOHN.md
Verify the sources before using it.

---

On it. I'm pulling the measured boxing numbers now: footwork, punch speed and timing, spacing between the two boxers, and how fighting games keep torsos from merging. I'll paste the full CLIPREVIEW1 answer with sources when it's done.

The CLIPREVIEW1 research is running now. I'll paste the full answer to all five questions here and attach the file when it's done.

CLIPREVIEW1 is done. The "after" clip reads better, but it still isn't two real boxers. The biggest break is spacing: the engine holds 0.557 m between the boxers, while elite boxers average 1.23 m apart. The real jab is about as fast as ours, and it looks like a bullet because nothing comes before it or after it. Full answer below, file attached.

## 1. Before vs after, and where the motion breaks
Each figure is a share of 1,200 frames per boxer, red / blue.

| Measure | Before | After | Real benchmark |
|---|---|---|---|
| Planted foot sliding | 26% / 28% | 15.5% / 13.4% | About 0% outside deliberate pivots; goal ≤5% |
| Root above 4 m/s | 0.7% | 0% | Ring average about 0.86 m/s (estimate: 155 m per round ÷ 180 s, French elite boxers, [S1]) |
| Root above 1.5 m/s | 19% | 11.7% / 5.5% | Short bursts only (steps, lunges). Burst speed NOT FOUND |
| Hips below 0.70 m | 13% / 3% | 9.7% / 0.4% | Stance hips about 0.78–0.88 m for a 1.78 m boxer (estimate) |
| Feet more than 0.95 m apart | 3.5% | 2.1% / 2.4% | About 0.45–0.75 m (estimate from shoulder width) |
| Red torso twist above 50° | 17 frames | 19 frames | Above 50° is plausible only if the pelvis turns too |
| Distance between boxers in exchanges | 0.557 m | 0.557 m | 1.23 ± 0.16 m, elite mean [S1] |

**The four breaks:**
- **Feet:** they still slide 13–15% of the time.
- **Red's crouch:** red is too low and drives forward into blue (116 frames of deep crouch). Deep crouches should happen only on ducks and slips.
- **Spacing:** torsos overlap at 0.56 m against a real 1.23 m.
- **Twist:** it comes from the spine instead of the hips. Experienced boxers turn the pelvis and thighs, while novices twist the spine ([Izumi 2018](https://core.ac.uk/download/223208425.pdf): "trunk rotation, not trunk twist"). In elite boxers the trunk contributes only 6.7% of the cross ([Dinu & Louis 2020](https://pmc.ncbi.nlm.nih.gov/articles/PMC7739747/)). Red's twist got worse while everything else improved, which suggests the spine alone is doing it.

**Correction to my earlier memos:** the ~43° jab / ~73° trunk-rotation figures I cited in J63 and J67 couldn't be re-confirmed in this pass. Treat them as unverified until someone opens that 2026 BMC paper.

## 2. Feet during each punch
- **Jab:** weight loads onto the rear foot, the rear leg drives, and the lead foot unloads and steps ([Lenetsky 2020](https://journals.lww.com/nsca-jscr/fulltext/2020/04000/defining_the_phases_of_boxing_punches__a.22.aspx)). The jab is the only punch with a significant force difference between the legs ([Stanley 2018](https://doi.org/10.1080/24748668.2018.1525651), 15 amateurs). For a step-jab, the lead foot moves about 10–30 cm (estimate; the measured length was NOT FOUND) and the rear foot slides up the same amount afterwards. In a standing jab, neither foot moves.
- **Cross:** ground force splits 60.6% lead / 39.4% rear in elite boxers and 54.1% / 45.9% in juniors (Dinu). The rear heel lifts and the rear foot pivots on the ball, which stays in place. A measured pivot angle was NOT FOUND.
- **Hook:** the lead foot pivots on the ball with the heel turning out. No force imbalance between the legs was found. Angle NOT FOUND.
- **Uppercut:** the knees dip and drive up, both feet stay planted, and there's a slight pivot on the punching side.
- **Engine rule:** the ball of a planted foot never moves. It may only pivot or lift its heel. A foot moves only in an explicit step (step-jab, advance, retreat, circling) of about 10–30 cm, taking about 4–6 frames at 30 fps (estimate). Outside those step windows, a 0% slide target is realistic.

## 3. Punch speed
| Punch | Number | Population and source |
|---|---|---|
| Jab, guard to contact | **117 ± 25 ms** experienced; 135 ± 42 ms inexperienced | 11 experienced and 20 inexperienced boxers, [Sensors 2021](https://www.mdpi.com/1424-8220/21/23/7882) |
| Jab, back to guard | **262 ± 42 ms** experienced; 212 ± 75 ms inexperienced; whole jab about 0.49–0.52 s | same |
| Jab delivery | 405 ms | 15 amateurs, Stanley 2018 |
| All punches, peak fist speed | 6.6–12.5 m/s, reached 8–21 ms before contact | 4 experienced boxers, [Whiting 1988](https://doi.org/10.1177/036354658801600207) |
| Maximal punch | 9.26 ± 2.09 m/s at contact; hooks faster than jab or cross | 10 competition boxers, [Piorkowski 2011](https://knowledge.lancashire.ac.uk/id/eprint/3757/1/piorkowski-et-al-2011-punch-kinematics.pdf) |
| Cross | 8.1 m/s elite and junior; 8.48 ± 0.61 m/s | Dinu; [boxing vs sanda study, 2024](https://pmc.ncbi.nlm.nih.gov/articles/PMC11466798/) |
| Hook | **11.2 ± 2.0** elite, 8.9 junior; lead hook 11.95 m/s | Dinu; Stanley |
| Uppercut | **10.2 ± 1.8** elite, 7.3 junior | Dinu |

A clean jab-only peak speed, and the papers by Smith, Walilko, Atha and Kimm read first-hand, were NOT FOUND in this pass.

**Why it fires like a bullet:** a real 117 ms jab is only 3.5 frames at 30 fps. Real footage sells it with a weight shift beforehand, a step, and a long, slow return of about 8 frames.

**What games do:**
- **Street Fighter 6:** Ken's jab is 4 frames startup, 3 active and 7 recovery at 60 fps, about 0.23 s in total ([SF6 frame data](https://sf6-lab.net/en/fighters/ken/frame)).
- **Tekken 8:** the jab hits on frame 10 (about 167 ms), followed by 17–19 recovery frames ([Wavu Wiki](https://wavu.wiki/t/Frame)).
- **Animation craft:** use strong key poses, a short anticipation, smears and overshoot ([Cartwright, GDC 2014](https://gdcvault.com/play/1020971/)), and a hit-stop freeze on impact ([Sakurai on hitstop](https://sourcegaming.info/2015/11/11/thoughts-on-hitstop-sakurais-famitsu-column-vol-490-1/)).
- **Fight Night and Undisputed:** their timing data was NOT FOUND.

**Suggested jab at 30 fps (estimate), 13–18 frames, about 0.43–0.6 s:**
- 1–2 frames loading the hip and shoulder
- 3–4 frames of extension, with a smear or motion blur
- 2–3 frames of hit-stop
- 7–9 frames easing back to guard

That matches the 0.52 s measured for a whole jab.

## 4. Spacing
- **Measured:** 1.23 ± 0.16 m between the boxers ([ECSS 2023](https://www.ecss.mobi/DATA/EDSS/C28/28-2883.pdf), 33 French elite boxers). The game's 0.557 m is 45% of that, more than 4 standard deviations below the mean.
- **Jab range (estimate):** about 0.9–1.1 m chest to chest, from a reach of about 1.78 m.
- **Hook range (estimate):** about 0.6–0.75 m.
- **Clinch (estimate):** about 0.25–0.35 m, chests touching. This is the only state where under 0.5 m is legitimate.
- **How games stop torsos merging:** each fighter has a separate pushbox that only collides with the other fighter's pushbox. Overlap is split 50/50 along the line between the fighters, and any leftover goes to the fighter who isn't cornered ([Press Button Win](https://www.pressbuttonwin.com/p/why-did-that-miss), [Game Developer](https://www.gamedeveloper.com/design/hitboxes-and-hurtboxes-in-unity)). In 3D, give each boxer a vertical capsule and resolve it every tick, after animation and before foot IK.

## 5. Fix first, in order
1. **Minimum spacing (pushbox).** This fixes the merging, red's lean, and part of the twist.
   - Give each boxer a capsule of radius about 0.22–0.28 m.
   - Preferred AI range: about 1.0–1.25 m between exchanges, 0.65–0.75 m for hooks, and under 0.5 m only in a clinch state.
   - An animator would author spacing into each move: step in on the jab and hook, then step out.
2. **Lock planted feet with step triggers.** This fixes the 13–15% slide and the gliding.
   - Lock the ball of each planted foot in world space, allowing only a heel lift or a pivot on the ball (rear foot on the cross, lead foot on the hook).
   - When the root drifts more than about 0.15 m from a foot, trigger a 4–6-frame step instead of a slide.
   - Cap the root at 1.5 m/s outside authored lunges.
   - An animator would author step clips with foot-contact curves and use their root motion.
3. **Punch timing curve and posture targets.** This fixes the "bullet" jab and the twist.
   - Use the 13–18-frame jab from section 3.
   - Drive rotation from the pelvis and cap the twist between shoulders and pelvis at about 30° (estimate).
   - Hold hip height at about 0.80–0.88 m for a 1.78 m boxer (scaled by height) and feet 0.45–0.75 m apart, crouching below 0.70 m only on ducks and slips.
   - Put shoes on both boxers and match blue's posture to red's.

**Not found and marked as estimates:** measured stance width, stance hip height, step-jab length, foot pivot angles, and Fight Night or Undisputed timing.

# CLIPREVIEW1_KALLI - Kalli answer (seat queue SQ3)

Brief: research/CLIPREVIEW1_SEAT_KALLI.md
Sent: 2026-10-19 04:21 | collected: 2026-10-19 04:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Writing the motion review now. It's from my own boxing and game-feel knowledge rather than a fresh research pass, so every number is labelled as coming from memory.

PART 1 of 3. The "after" clip reads better as two people: no teleports, half the speeding, and the blue man stands like a boxer. Neither clip reads as two boxers yet. The three worst breaks, in order, are torsos merging at 0.557 m, planted feet sliding 13-15% of the time, and a jab with no wind-up or follow-through. The red boxer's crouch-and-lean is a symptom of the spacing break: he's leaning into a man who is too close.

**1. Which reads more like real boxers, and where it breaks**
- **Teleports:** going from 8-9 frames over 4 m/s to 0 is the single biggest win in the after clip. That jump is what makes a viewer think "glitch" instead of "fight".
- **Feet:** 13-15% sliding planted frames is still roughly 3 times the 5% goal, and the eye reads that as skating. It breaks in the moments that matter, punches, because the root is pushed while the feet are pinned.
- **Hips:** red below 0.70 m for 116 of 1,200 frames (about 10%) is a constant crouch. Blue at 5 frames is right. A boxer's hips drop briefly on a slip or a body shot, then come back. Red is staying low, probably because the spacing solver or IK is folding his knees to fit him into a gap that's too small (INFERENCE).
- **Torso twist:** 17-19 frames over 50° is not a lot, and real hooks and crosses do rotate the shoulders that far. The "weird twist" the operator sees is more likely the twist happening while the hips and feet don't turn. A real cross turns from the rear foot up through hip, then shoulder. If only the shoulders spin, it looks like a wrung towel.
- **Spacing:** this is the root defect. 0.557 m between chest centres is close range. At that distance, with forward lean, the two torsos must overlap. The red crouch, the merged torsos and the over-twist all follow from it.

**2. Feet**
Planted feet during a punch don't translate. They rotate on the ball of the foot and the heel lifts. Slide on a planted foot should be about 0 cm (anything over 1-2 cm per step reads as skating). Rough per-punch footwork from boxing coaching practice (from memory):
- **Jab:** standing jab, both feet planted, with a small weight shift forward. Step-jab: the lead foot pushes forward 10-20 cm as the punch lands, and the rear foot follows the same distance right after (push-step). The feet never cross and never leave the canvas high.
- **Cross:** the rear heel lifts and the rear foot pivots on the ball 30-60° inward ("squash the bug"). The lead foot stays planted. The body's root moves forward 5-15 cm at most.
- **Lead hook:** the lead foot pivots on the ball 45-90° with the heel turning out, and the rear foot stays planted. The root barely moves.
- **Uppercut:** a knee bend of 5-10 cm on the loading side, then the legs drive up. The feet stay planted.
- **Moving between exchanges:** steps of 10-25 cm with a push-off (the back foot pushes the front foot forward, and the reverse to go back), a lateral shuffle, or a pivot of 30-90° on the lead foot. Never a glide where both feet slide together.
- **Rule for the engine:** feet move only on a step event. Between step events the root may move only as far as the planted feet allow (a lean of 10-15 cm from centre). If the AI wants the body farther, it has to call a step, not push the root.

PART 2 of 3

**3. Punch speed**
From memory, from sport-science measurements of amateur and elite boxers (verify before quoting):
- **Jab:** peak fist speed of roughly 6-9 m/s for trained boxers, at the top end for elites. Guard to full extension takes roughly 0.15-0.30 s for amateurs and 0.10-0.20 s for elites. The return to guard is about the same time or a little longer, 0.15-0.30 s.
- **Cross:** roughly 7-10 m/s peak, taking 0.20-0.35 s guard to impact.
- **Lead hook:** roughly 8-11 m/s peak, taking 0.25-0.40 s, including the hip turn.
- **Uppercut:** roughly 6-9 m/s, taking 0.25-0.40 s with the knee dip.

How games show it:
- Real speed reads as "bullet" on screen, because a 0.15 s punch is 4-5 frames at 30 fps. Fight games read well at roughly 0.3-0.5 s per punch, counting anticipation, strike and recovery.
- Animator practice is to keep the strike itself fast (3-6 frames at 30 fps, about 0.1-0.2 s) and add 3-6 frames of anticipation (a shoulder or hip load, a tiny weight shift) and 6-12 frames of recovery. The punch feels fast, and the viewer sees it start and end.
- Fight Night Champion and Undisputed both play punches slower than real life, with anticipation added for readability. I can't give an exact frame count from memory, so that part isn't checked.

A target for our watched sim (game-feel guideline, INFERENCE):

| Punch | Wind-up | Strike | Recovery | Total |
|---|---|---|---|---|
| Jab | 0.08 s | 0.12 s | 0.18 s | about 0.38 s |
| Cross | 0.12 s | 0.15 s | 0.25 s | about 0.52 s |
| Hook | 0.15 s | 0.18 s | 0.30 s | about 0.63 s |
| Uppercut | 0.15 s | 0.18 s | 0.30 s | about 0.63 s |

That's about 1.5-2x slower than an elite boxer overall, but the strike part stays close to real speed.

**4. Spacing**
Chest-centre to chest-centre distances for welterweights with about 180 cm reach (from body proportions, INFERENCE):
- **Jab and cross range:** 1.0-1.3 m. That's arm length (about 0.70-0.75 m) plus shoulder offset and torso depth, with the glove just reaching the face.
- **Hook and uppercut range:** 0.65-0.85 m.
- **Inside fighting, heads close:** 0.45-0.60 m. Torsos are near, with the heads usually to one side.
- **Clinch:** 0.30-0.45 m, and the torsos may touch. A chest is about 0.22-0.28 m deep, so below about 0.30 m between centres the bodies have to overlap.

So 0.557 m as the exchange distance is inside-fighting range, held all the time. Every punch at that distance hits through the opponent's body.

What fighting games do to stop torsos merging:
- **Push boxes:** a simple box or capsule per body on the root that the two bodies can't overlap. If they would, both are pushed apart at once, in the same frame. Street Fighter and Tekken work this way.
- **Range by punch:** each move has a designed range (its hit box at full extension). The AI only throws when the opponent is in that range, and steps in or out first otherwise.
- **Motion warping:** the animation is stretched a little to land on target, a short step forward or back of 0.1-0.2 m before contact. Fight Night and UFC both use some form of this, but I'm not sure of the exact technique (NOT CHECKED).

For us:
- A torso capsule per boxer, about 0.15 m in radius, with a hard minimum of 0.30 m between centres. The solver pushes the root apart, and the push-out becomes a step event so the feet move instead of sliding.
- Exchange distance depends on the punch chosen: about 1.1 m for jabs, about 0.75 m for hooks, about 0.40 m for the clinch.
- The engine stops holding a fixed 0.557 m.

PART 3 of 3

**5. The three fixes, in order**
1. **Spacing by punch range, plus a push-out capsule.** The animator's move is to give each punch a range and make the AI step into it. A hard capsule stops overlap, and any push-out has to be a step event. This one fix should also take care of most of red's crouch and lean, the merged torsos, and some of the foot slide.
2. **Planted feet locked, movement only by steps.** A fight animator would put foot-lock markers on each clip (planted, or pivoting on the ball). IK pins planted feet to the canvas and allows only rotation on the ball. Root motion is driven by the clip's own step frames, not pushed by the AI. A foot may only move in a step clip (push-step 10-25 cm, pivot 30-90°). Target: under 5% sliding planted frames, measured with the same tool as above.
3. **Punch timing with wind-up and recovery.** The animator would re-time the jab to about 0.08 s of wind-up, 0.12 s of strike and 0.18 s of recovery, so the punch reads at about 0.4 s overall and the strike part stays fast. A hit-pause of 2-3 frames on a clean landed punch, with the camera holding, is standard fighting-game practice and tells the eye "that landed".

**What the watcher needs to read, and which defects hurt that most**
The player watching a sim bout has three questions: who is winning, what landed, and is my boxer doing what I asked in the corner. The motion has to answer all three without reading numbers.
- **What landed:** a clean hit needs a target reaction: the head snaps 10-20°, or the body folds on a body shot, plus the 2-3 frame hit-pause. A missed punch needs a visible miss: a slip, a blocked glove, or the punch passing beside the head. Merged torsos destroy this, because hits and misses look the same when the glove is already inside the other man. That's why spacing is fix 1.
- **Who is winning:** posture tells it. The man walking forward with an upright head is winning, and the man backing up, hips low, guard high is losing. Right now red's constant crouch reads as "red is hurt" all fight, whatever the sim is doing. That's a design bug: the motion lies about the score.
- **The corner call:** each call (keep her long, walk her down, wait and counter) has to show in distance and footwork. If spacing is fixed at 0.557 m, "keep her long" can't look any different.

**How the reference games stage the watched fight**
- **Fight Night Champion:** a broadcast camera at chest height, a slow-motion replay of the knockdown, and a hit-pause on big punches. Punch speed is slower than life, and the knockdown is the punctuation.
- **Undisputed:** footwork and range are the game. Spacing drives everything, and players read range from foot position.
- **Sim-manager games (Football Manager's 3D match, Motorsport Manager's race view):** they show the key moments and skip filler. FM highlights only play the chances. For us, the watched bout could show full rounds at 1x, with an auto-cut to replays of knockdowns and big landed punches, plus a round-end strip with numbers.

The strongest case against my own ruling is that foot slide should come first, because it's what the operator saw first ("legs fly not walk"). Spacing still goes first. Most of the slide comes from the solver pushing the root while the feet are planted, and it's pushing because the bodies are too close. Fix feet first and the slide comes back the moment spacing pushes them again.

None of the numbers above are computed: the punch speeds and times come from memory of sport-science papers and coaching practice, and I haven't checked them against sources in this pass. Ask John for a sourced research pass if you need numbers to quote.

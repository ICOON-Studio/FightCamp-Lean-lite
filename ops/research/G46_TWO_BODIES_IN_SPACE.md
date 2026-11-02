# G46 — TWO BODIES IN SPACE

**Grok, Expert tier, 2026-09-10. Research only, 135 sources.**

> Landed by Claude from the Grok session. The in-app browser sandbox blocks
> downloads, so the document was pasted into the chat verbatim and captured from
> there; this is Grok's text, not a summary of it.

Research only. No code. Situation as stated: a 20 Hz fight sim owns distance,
who throws, which region, how hard. It emits metres and impact distance. It does
not emit stance, feet, facing, step, or hand. Presentation plays in-place clips
only. Root motion is forbidden. The view may drop an event; it may never invent
one.

Sources that disagree are left standing. A hole is written **not found**. Nothing
is filled with a plausible guess.

---

## DECISIONS

- **FACING** — Always face the opponent with a **lagged turn, not a snap**.
  Head/torso track first; feet follow. Instant yaw snap is the known break (feet
  skate, twist through the mesh, clip the other body).
- **SPACING** — No shipped boxing/MMA title publishes pocket/clinch metres.
  Sanity-check against real anatomy only: mean boxer arm length **75 cm**; mean
  wingspan **180 cm** (HW 194 cm). Treat long range as "about an arm plus a
  gap", pocket as "less than an arm", clinch as "bodies touching / arms
  tangled". **If our 2.1 m / 1.4 m do not sit in those bands, the metres are
  wrong — not the clips.**
- **FOOTWORK** — Sim owns translation. Play in-place locomotion **matched to sim
  speed** (blend tree or motion-match). Never slide a T-pose. Never let a clip
  move the root.
- **DISAGREEMENT** — Default: **warp the clip toward the sim contact with
  bounded IK** (the UFC 2009 / EA MMA path). Cap the stretch. If the gap exceeds
  the cap, refuse that clip and pick a shorter-reach one, or drop the event. Do
  not snap the body to the clip. Do not play a miss against a scored hit.
  Camera-hiding is presentation sugar, not a fix.
- **HAND** — Derive limb from **stance + punch family**, not from the sim. Keep
  the choice deterministic for a given (stance, punch family, seed) so replays
  match. **Southpaw needs a mirrored clip set or a captured southpaw set — a
  mirrored idle pose is not enough.**
- **WHAT IS SHOWN** — Keep dropping. Gate full clips by intensity / importance.
  Layer cheap additives on the rest. **Do not slow the 20 Hz sim to the
  animation budget.** Do not invent combo clips that the sim did not emit.

---

## 1. FACING

### What shipped games do

Combat-sports and close-quarters melee titles treat the opponent as the facing
target.

- **EA Sports MMA** used Autodesk HumanIK for "head tracking with attitude" so
  the head stays on the opponent while the body plays other layers (Simon Sherr,
  Animation Director; Autodesk / GameDev.net write-up of EA MMA, 2010).
- **UFC 2009 Undisputed's** Full Body IK Targeting pipeline includes an explicit
  Twist pass and a Lean pass after a Movement pass, then Punch Direction —
  facing and torso aim are solved as part of hitting, not left to the clip
  (Hiroki Ueno, Yuke's, GDC 2010).
- **For Honor** (Ubisoft): gameplay code owns the desired trajectory and future
  orientation; motion matching searches clips whose future orientation matches
  that request. Animation is "a cosmetic detail on top" (Simon Clavet, GDC 2016).
- **Facebook AI Research** boxing/fencing paper trains a facing reward that
  points the root at the opponent's ground-projected position (Won, Gopinath,
  Hodgins). Research, not a shipped title, but it states the same rule the games
  imply: face the other body.

**Always-squared vs lagged**: shipped talks describe continuous tracking
(head/IK) and trajectory matching **with delay**, not a per-tick snap. For
Honor's desired trajectory is a spring-damper on desired velocity; Clavet reports
about **1 metre of stopping delay** and a ramp-up from a start. Predictability is
the goal, not maximum responsiveness.

**Turn-rate numbers** for Fight Night, EA UFC, or Undisputed: **not found**. No
GDC session or dev blog in this pass states degrees-per-second for a boxer's yaw.

### What breaks when facing snaps

Documented failure modes, not guesses:

- **Feet slide** when the root yaws and the planted foot is not unlocked
  (HumanIK in EA MMA exists specifically "to prevent the foot from slipping as
  the body moved").
- **Physics entanglement / fighters stuck together** — UFC 2009 listed this as a
  named challenge and limited how close fighters could get (Ueno GDC 2010).
- **Loose-axis facing in Undisputed**: player/analyst reports that leaving the
  shared axis (loose footwork, rock-walk) breaks punch tracking and produces
  desync because punches stop being canned and start depending on live physics.
  Steel City Interactive has not published a facing-rate paper.
- Instant snap also reads as a **teleport of the chest** toward the opponent
  while the feet stay — the same class of error For Honor avoids by clamping
  centre-of-mass to **15 cm** of the simulated point rather than warping the
  whole actor.

Server-authoritative shooters face the same problem with remote pawns:
interpolation of position and rotation over **50–150 ms**, never a snap to the
latest snapshot (Gambetta, "Entity Interpolation"; SnapNet "Snapshot
Interpolation"; VALORANT netcode note on corrections causing camera/character
jumps). Same pattern, different genre.

## 2. SPACING

### What games state in metres

**not found** for pocket, long range, or clinch in Undisputed, Fight Night
Champion, EA UFC 1–6, or UFC Undisputed 2009/2010/3. Those titles **name**
ranges. They do not publish the metre values.

**UFC 2009 Undisputed** standing ranges, as shipped and documented in
contemporary guides (Altered Gamer controls guide, 2009):

- **Probing range** — far edge of strikes: jabs, hooks, straights, lunging
  punches, long kicks.
- **Striking range** — close enough to clinch, far enough for power punches and
  kicks. The range where landed strikes are "the most powerful possible".
- **Clinching range** — as close as standing allows; short strikes (knees,
  elbows); power reduced.

**World Boxing Manager** design note (Aggroblakh / GameDev.net, 2017) — an indie
boxing-manager combat model, not a 3D shipped fighter, but it states the same
three bands in words:

- Outside: "slightly further than and up to an arm's length".
- Inside / pocket: "less than an arm's length".
- Clinch: "so close that their arms get tangled".

**EA UFC 6** (2026) developer Q&A: movement overhaul makes "reach, movement
speed, and distance management" first-class. No numbers.

### Real-world numbers that are published (for sanity-check only)

These are sport measurements, not game engine constants.

- Mean professional boxing wingspan / reach across WBA weight classes:
  **71 in / 180 cm**. Heavyweight mean 76.3 in / 194 cm. Cruiserweight mean
  77.4 in / 197 cm (ShortBoxing compilation of champion data).
- Named extremes: Tyson Fury 85 in / 216 cm; Mike Tyson 71 in / 180 cm; Rocky
  Marciano 68 in.
- **BOXFIT protocol** (Edward Thomson PhD, University of Chester, 2015): average
  boxer arm length **75 ± 4 cm** (n = 12; Hawes & Martin 2001 cited). Floor
  pattern used an internal radius of **160 cm** so that a forward/back step of
  85 cm stayed inside punching measure; lateral marks at 100 cm.
- Wrestling-range approximation in a HEMA essay (Ernst Fechten / Craig Peters,
  2018): about **90–105 cm** as the band many practitioners call wrestling
  range. Not a boxing source. Kept because it is a named figure for "close
  enough to grab".

**Reach in boxing is fingertip-to-fingertip, not fist-to-target.** Fist reach
from the shoulder is shorter than half the wingspan. No shipped title in this
pass converts that into a centre-to-centre metre the engine should hold.

### How to use this against 2.1 m and 1.4 m

A 0.75 m arm plus two half-torsos (roughly 0.25–0.35 m each) plus a small gap is
the long-range jab band in the real measurements above. **A scored punch at 2.1 m
centre-to-centre with a 0.7 m clip reach is the exact picture-vs-scorecard
failure in the brief: the clip cannot touch.** Either the sim's metre is a
different unit than the clip's, or the clip was authored for pocket distance and
is being asked to play at probing range.

**Disagreement to keep**: game design blogs speak in "arm's length"; motion-
capture sports guides speak in m/s of locomotion (walk 0–2, jog 2–4 — MoCap
Online sports animation guide) and never in pocket metres; UFC 2009 speaks in
three named bands with no SI units. All three are right about different things.
None gives a pocket metre we can copy.

## 3. FOOTWORK

When the sim moves a fighter from 2.1 m to 1.4 m, the presentation must show
travel without owning travel.

**A. In-place clip + code translation** (the constraint we already have).
Standard for any title where simulation or a server owns position. MoCap Online's
multiplayer note states the convention outright: "In-place animations controlled
by server-authoritative physics are the standard for multiplayer. The animation
plays in place. World position is driven entirely by the physics/movement
component." Fight Night Champion ran physics at **120 Hz**, game sim at **60 Hz**,
render at **30 Hz** with motion blur — three clocks, one owned position.
*Cost*: clip set of directional shuffles / steps / pivots, a speed parameter,
foot-lock or IK so planted feet do not skate. Cheap compared with motion
matching. **Looks like skating if playback rate is not tied to sim speed.**

**B. Playback-rate / stride matching.** Sports mocap practice: measure
metres-per-cycle of each walk/shuffle clip, set playback rate so the visual
stride matches the code speed. If the sim covers 0.7 m in 0.4 s, a shuffle whose
cycle travels 0.35 m at 1.0x must play at 2.0x or be blended with a longer-stride
clip. *Cost*: measurement pass on every locomotion clip; a rate clamp so 3x
playback does not look like a cartoon.

**C. Directional blend tree / motion field.** EA UFC 1–2: "an animation step
forward, an animation moving at 45 degrees to the right and left… if you moved in
between that, we kind of blended the animations" (Brian Hayes, UFC 3 Creative
Director, Player.One, 2018). UFC 3 replaced that with a "structuralist motion
field" sampled in real time. EA UFC 2013 "Precision Movement": "The fighter's
feet are actually connected to the floor" (Xbox Wire). *Cost*: UFC 1-style trees
are authoring-heavy (every 45°). Motion fields need a capture day designed for
coverage, not isolated punches.

**D. Motion matching to a simulated trajectory.** For Honor: code emits the
desired path; the matcher picks the frame whose future position / orientation /
velocity best match. Centre-of-mass clamped to **15 cm** of the simulated point.
Delay of about 1 m on a stop. "The goal is not to be as responsive as possible,
the goal is to be as predictable as possible" (Clavet, GDC 2016). *Cost*: large
continuous mocap corpus, a feature database, a cost function, and a clamp.
Highest build cost of the four. Best at hiding the sim-vs-clip seam.

**E. Slide with no leg animation.** No shipped combat-sports title defends this.
PES vs FIFA commentary treats missing foot-plant as the thing that makes movement
"floaty". For Honor's 15 cm clamp exists because unconstrained cosmetic animation
drifts.

**Two-character exception (kept as disagreement)**: For Honor itself switches
owners — locomotion is sim-driven; throws and finishing kills are
animation-driven displacement "to keep them in sync". WWE 2K uses canned paired
clips for holds and finishers (technical postmortem **not found**). EA MMA used
paired "touch tags" rather than root motion. That exception is out of scope for
stand-up presentation, but it is the documented reason a studio sometimes lets
animation own translation: **when two bodies must occupy one authored
relationship.** Our constraint forbids that on strikes.

## 4. THE DISAGREEMENT

Sim says 2.1 m. Clip reach is 0.7 m. Five strategies exist in shipped or
documented work. None is free.

### Strategy A — Warp / IK-stretch the clip to the sim contact

*Who*: UFC 2009 Undisputed (Ueno, GDC 2010). EA Sports MMA (HumanIK auxiliary
effectors parented to the opponent's wrist/chin; reach weights blended on over
the punch). Academic boxing: Zordan et al., "Motion Capture-Driven Simulations
That Hit and React" — punches modified with IK "so that the boxing simulations
are able to hit specified locations".

Ueno's pipeline, in the order the slides give it: **Movement → Twist → Lean →
Punch Direction → Arm Extension → Foot Locking.** Target frame is chosen; a
calibrated pose is stored as a delta; the delta is faded in before the hit frame
and out after. "2-Link IK to prevent foot sliding."

EA MMA: "we can't have a strike point that just sits out there in space… we need
to be able to put it on the guy's chin". Non-uniform player scaling plus relative
IK plus touch tags. Fight Night-derived physics only "cleans up
interpenetrations"; it does not pose the body (Sherr).

*When it goes wrong*: rubber arm; shoulder popped out of the socket; punch that
arrives from an angle the feet did not load; two different-sized bodies sharing
one authored contact. Ueno himself called the solver "limited" and "no iterative
processing".

*Trade-off*: **picture matches the scorecard. Clip library stays small.**
Failure is visible as anatomy, not as a miss.

### Strategy B — Play the clip anyway and accept the miss

*Who*: visible in **Undisputed** as a player-reported failure, not as a published
design. Dev updates admit uppercuts "can be thrown from too greater range" and
were range-capped (Undisputed Dev Update — Punch Changes, 2024). Players record
body straights that stop short at contact distance, crosses that fly off-axis,
"ghost punches", and hits that should land and do not (2024–2025). Fight Night
Champion is the comparison title players cite as "the punch needs to go where the
head is when the punch is thrown".

*When it goes wrong*: **exactly the failure in the brief.** Sim scored a hit. The
arm did not arrive. Or the clip plays through empty air and the HUD still counts
it.

*Trade-off*: cheapest. Zero solver. Deterministic. **Breaks the
picture-scorecard contract the moment metres and authored reach diverge.**
Undisputed's public reception is the cost written down.

### Strategy C — Snap or warp the position to the clip

*Who*: For Honor throws and finishers; WWE paired moves; cutscenes.
*When it goes wrong*: the body teleports relative to the sim. Next sim tick puts
them back. Rubber-band. **In a title whose sim is the authority, this is a lie
about distance.**
*Trade-off*: perfect contact on that one clip. Destroys the "sim owns metres"
rule. **Illegal under our constraint** except for authored two-body clinch clips
(out of scope).

### Strategy D — Refuse the clip; pick a different one

*Who*: motion matching cost functions (For Honor: a candidate that would not land
you on the desired trajectory has a higher cost and loses). Independent football
work states the rule in words: if the correct foot cannot reach the contact
corridor naturally, "the answer is not to force the animation. It's to keep
trying until we get one that can". UFC 3's motion field is a softer version.

*When it goes wrong*: **the punch the sim named is not the punch on screen** (a
hook plays because the jab clip cannot reach). That is close to inventing, which
our design forbids, unless the substitute is in the same punch family and the
event is still the same impact. Also adds selection latency.

*Trade-off*: anatomy stays honest. Requires a clip library with **reach
variants** (jab at range, short jab, step-in jab — Undisputed separately authored
"step in straight" and "step in body jab"). Highest clip-count cost.

### Strategy E — Move the camera so the gap is not visible

*Who*: Fight Night / EA UFC broadcast presentation, replays, motion blur at
30 fps. FIFA "Play Highlights". **No talk in this pass says "we hide missed
tracking with the camera".**
*When it goes wrong*: a static wide shot, a player-controlled camera, or a replay
from over the shoulder shows the miss anyway.
*Trade-off*: cheap for broadcast view. **Useless as the only strategy.**

### Strategy F — Physics cleanup after the clip (partial, often stacked on A)

*Who*: EA MMA / Fight Night physics "to clean up interpenetrations" while
procedural systems keep artist intention (Sherr). UFC 2009 Havok ragdoll blended
with animation; fighters limited in how close they may get (Ueno).
*When it goes wrong*: entanglement, jitter, "stuck together" (Ueno's named
challenge).
*Trade-off*: hides mesh intersection. **Does not extend a 0.7 m arm to 2.1 m.**

### Which disagreements to keep

- Ueno and Sherr say IK-to-target is how you make a small clip set hit a moving
  chin. Undisputed's live game shows what happens when tracking and authored
  reach diverge and the clip is allowed to play. **Both are true.**
- Clavet says locomotion is cosmetic on a sim point and that paired moves should
  be animation-owned. **Both are true in one title, on different move classes.**
- Sherr says physics must not pose the fighter. Ueno's title does blend Havok
  into the pose. Different houses, different year, different engine. **Keep
  both.**

## 5. THE HAND

The sim never names a hand. A punch on screen must.

Player-controlled titles pick the limb from **input + stance**: UFC 2009 face
buttons mapped to limbs; Fight Night Champion's Full Spectrum Punch Control;
Undisputed's 60+ individual punches, directional, plus stance. **The hand is in
the punch identity.** The game knows the hand because the player named it.

Our case is the other case: a non-animation source emits "a strike happened" and
the view must choose lead or rear.

**Documented analogue** — games that receive a hit from code and must pick a
*reaction* clip: CRYENGINE Hit and Death Reactions (evaluate a list, first match
wins — direction, power, custom validators); Jungbluth, "Anatomy of a Hit
Reaction" (directional hit reactions front/back/left/right, intensity gates,
additive flinches, or procedural bone offsets). **Both are defender-side. The
attacker's limb is not in that system.**

**Attacker-limb choice from a nameless strike: not found** as a published rule in
Fight Night, EA UFC, or Undisputed. What those games actually do is not "the sim
forgot the hand" — **they never let the sim forget the hand.**

What we can say without inventing a convention:

- Boxing structure is **stance-relative**: orthodox lead is the left jab, rear is
  the right cross. Southpaw swaps that. **A punch family (jab / cross / lead hook
  / rear hook / lead uppercut / rear uppercut) plus a stance is enough to name
  the limb.**
- Combo order is a second cue: a 1–2 is lead then rear. If the sim emits two
  impacts and no hands, a stable convention is "start on lead, alternate", and
  **that is an invented convention unless we document it as ours.** Shipped
  source for that rule: **not found**.

### Stability across replays

- Canned clip selection from a seed / from event order **is stable**.
- Live IK toward a moving chin is stable **only if** the target pose is
  deterministic given the same positions.
- Undisputed's physics-driven tracking is reported as **not stable** once loose
  footwork leaves the axis — same input, different arm path. That is the warning.

Server-authoritative shooters keep animation state-machine **inputs** in sync,
not playheads. Same lesson: **lock the decision (which clip, which limb), let
each viewer play it.**

### Southpaw

- Real boxing: mirrored stance lines the lead hands up and the rear hands up.
  Lead-foot fight is the whole tactical layer.
- Shipped AAA statement of "we recapture every punch southpaw" vs "we mirror the
  clip set": **not found** for Fight Night, EA UFC, Undisputed.
- What is on record: EA UFC treats stance as **fighter-specific capture**. UFC 5
  interview: Conor McGregor's Debut Alter Ego uses a karate stance at range; the
  welterweight model uses a boxing stance from the post-Mayweather period
  (Sherdog / Raman Bassi). **That is recapture of a stance, not a mirror toggle.**
- **Indie counter-example, kept because it is explicit**: Bloody Knuckles Street
  Boxing. First attempt at a southpaw switch left the fighter in a southpaw
  stance **still throwing orthodox punches**; "his body would get all twisted up
  and his targeted system would get out of whack". Fix: duplicate the animator
  controller and **mirror the clip set**. A mirrored skeleton pose was not enough.

What goes wrong when it is faked: hands and hips disagree; liver-side hooks land
on the wrong rib; IK targets aimed at "the lead shoulder" hit the rear shoulder;
footwork clips advance the wrong foot and the lead-foot fight reads backwards.

**Mirrored clips cost a second set** (or a reliable runtime mirror that mirrors
*contacts*, not just joint local-space). Recapture costs a capture day per
stance. **Pose-only mirror is the option that has a published failure.**

## 6. WHAT IS SHOWN AT ALL

896 impacts, 66 shown, 92.6% dropped. Dropping is already legal. Inventing is not.

### Shipped conventions

**Show a representative / intensity-gated subset.**

- **EA UFC 6**: fighters who are knocked down "will automatically pop back up
  more often. You'll only see the more elaborate and extended animations when the
  fighter is really hurt and very vulnerable to be finished" (Raman Bassi,
  Forbes, 2026). **Same event class, two presentation budgets.**
- **Jungbluth**: not every hit gets a full-body reaction. Light hits are
  additives or procedural bone offsets on top of the current action; only some
  hits earn knock-backs / knock-downs. Synced combat (attacker and defender share
  a clip pair) is a different, more expensive lane than unsynced.
- **CRYENGINE**: first valid reaction in a list. No requirement to consume every
  stimulus with a unique clip.
- **FIFA 23 Play Highlights**: the match continues in sim; the player is dropped
  only into "the most important moments".

**Do not slow the sim to the animation.** Fight Night Champion is the opposite
architecture: sim and physics run faster than render (120 / 60 / 30).
Presentation is a sampled view of a hotter sim. Slow-the-sim-to-animation as a
shipped combat-sports convention: **not found**.

**Batch several events into one longer clip.** Fighting-game combos and UFC
"combination punching" are this, but they are authored as **one player action**,
not as a presentation squash of independent sim events. Using one cinematic combo
to stand in for N separate sim impacts would **invent timing and invent a rhythm
the scorecard does not have.** No source in this pass recommends it.

**Cut away.** Broadcast cameras, replays, and Fight Night motion blur hide
micro-misses and skip dead time. They do not replace the need for a policy on the
two bodies when the camera is on them.

### Server-authoritative analogue

Shooters and MOBAs at 10–30 Hz snapshots do not present every micro-adjustment.
They interpolate between confirmed states and show the remote pawn in the past.
The convention is: **present confirmed events, smooth the gaps, do not fabricate
contacts the authority did not emit.** That maps onto our stream: present a
subset of confirmed impacts; do not add a punch the sim did not throw; do not
move a hit to a region the sim did not name.

### Practical gate (from the sources, not a new rule)

What the cited systems actually gate on: **intensity / hurt state** (UFC 6
knockdown length); **direction and power** (CRYENGINE, Jungbluth); **whether a
full-body clip is already playing** (additive layer instead); **importance to the
broadcast** (FIFA highlights).

**A 92% drop is larger than any figure a cited talk names. No source says 92% is
normal. No source says it is forbidden.** The consistent rule across titles is:
when the budget is smaller than the stream, **degrade the presentation of an
event** (additive, shorter get-up, camera), **do not fabricate a different
event.**

---

## SOURCE LIST

Named titles and talks only. Web write-ups are listed when they are the
accessible form of a talk.

- Hiroki Ueno, Yuke's — "The Next Generation of Fighting Games: Physics &
  Animation in UFC 2009 Undisputed", GDC 2010 (Full Body IK Targeting,
  physics+animation, navigation; 4Gamer.jp Japanese report of the same session).
- Simon Clavet, Ubisoft Montreal — Motion Matching in For Honor, GDC 2016.
  Written up: Michael B, Game Anim, 3 May 2016. Also nucl.ai 2016.
- Geoff Harrower & Jeremy Mathiesen, EA Canada — "Embracing Animation Complexity
  in EA UFC 2 Through Procedural Techniques", GDC 2016.
- Geoff Harrower & Lee Dowsett, EA — GDC 2015 Animation Bootcamp on EA UFC.
- Brian Hayes — UFC 3 motion-field interview, Player.One, 2018.
- Raman Bassi — EA UFC 5 ratings interview, Sherdog, 2023; EA UFC 6 Forbes
  interview, 2026; EA.com UFC 6 developer Q&A, 2026.
- Simon Sherr, Rob Hyder, et al. — "Building Brawl-Handling Interacting
  Characters in EA Sport's MMA", GameDev.net, 2010. Autodesk HumanIK / EA MMA
  video.
- Fight Night Champion — developer interview on 120 Hz physics / 60 Hz sim /
  30 Hz render, 2011. EA.com "Fight Night Champion Art", 2011.
- Steel City Interactive — Undisputed punch-range dev update, 2024; Steam page.
  Player-facing range/tracking failures documented in contemporaneous videos.
  **Treat player reports as evidence of the failure mode, not as a design
  document.**
- Won, Gopinath, Hodgins — "Control Strategies for Physically Simulated
  Characters Performing Two-player Competitive Sports", Facebook AI Research.
- Zordan et al. — "Motion Capture-Driven Simulations That Hit and React".
- Edward Thomson — PhD thesis, University of Chester, 2015 (BOXFIT: 75 ± 4 cm
  arm length; 160 cm radius; 85 cm / 100 cm steps).
- ShortBoxing — average professional reach by weight class.
- Wikipedia — Reach (boxing); UFC 2009 Undisputed; Undisputed (video game).
- Altered Gamer — UFC 2009 standing strike ranges (Probing / Striking /
  Clinching).
- Aggroblakh — "World Boxing Manager: Fight Night — Range and Offense",
  GameDev.net, 2017.
- Mike Jungbluth — "Anatomy of a Hit Reaction", Konsoll / Game Anim, 2016–17.
- CRYENGINE 5 documentation — Hit and Death Reactions System.
- Gabriel Gambetta — "Entity Interpolation".
- SnapNet — "Netcode Architectures Part 3: Snapshot Interpolation".
- Riot Games — "Peeking into VALORANT's Netcode".
- Xbox Wire — EA Sports UFC Precision Movement Q&A, 2013.
- MoCap Online — in-place vs root motion; sports locomotion stride matching;
  multiplayer animation sync (secondary practice notes, not a shipped-title
  postmortem).
- Bloody Knuckles Street Boxing / Luvseatshawty — southpaw switch requiring a
  mirrored controller, not a mirrored pose (indie; explicit failure report).

## Explicit holes

- Degrees-per-second facing turn rate in any boxing/MMA title: **not found**.
- Pocket / clinch / long-range metres published by Fight Night, EA UFC, or
  Undisputed: **not found**.
- Official AAA policy on southpaw = mirrored clips vs recapture: **not found**.
- Official policy for choosing lead vs rear when the sim omits the hand:
  **not found**.
- Official "hide a miss with the camera" design in a combat-sports title:
  **not found**.
- Official "slow the fight sim until the clip finishes" design in a
  combat-sports title: **not found**.
- WWE 2K pairing algorithm postmortem: **not found**.
- EA FC / FIFA HyperMotion implementation paper with numbers: **not found** in
  this pass (existence of motion matching in the line is widely reported).

Where two houses disagree (physics poses vs physics informs; clip plays through
vs clip is warped to the chin; sim owns travel vs animation owns the throw),
**both are recorded. The disagreement is the finding.**

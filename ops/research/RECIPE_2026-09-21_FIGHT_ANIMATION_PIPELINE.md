# Pasted recipe, 2026-09-21 — "fight animation pipeline"

**Recorded VERBATIM below, before assessment, per the standing rule on pasted AI
recipes.** The operator's question was: *"anything we are missing from this
process?"* Claude's assessment is in `## ASSESSMENT` at the foot; the recipe
itself is untouched so a later reader can judge it independently.

---

## THE RECIPE AS PASTED

Phase 1: Know Your Disciplines First
Before opening any software — get the movement right:
Table
Discipline	Core Traits to Model
Boxing	Upright stance, head movement, footwork, hands up, straight punches + hooks, limited kicks/grappling
Kickboxing / Muay Thai	Shorter stance, heavy kicks, knees, elbows, clinch striking, shin checks
MMA	All above + takedowns, transitions, ground striking, submissions, cage control
Wrestling / BJJ	Low stance, level changes, sprawls, takedowns, guard/pass/mount positions, leverage over power
Action: Build a reference library — watch slow-motion footage of real fights; note timing, weight transfer, recovery times.

Phase 2: Character & Asset Pipeline
Step 1 — Modeling
Block out body proportions (height, reach, build matter for simulation)
High-poly sculpt → retopologize to game-ready low-poly
UV-unwrap + bake normal/ao maps
Tools: Blender, Maya, ZBrush, 3ds Max
Step 2 — Texturing & Materials
Skin, clothing, sweat, wear/dirt as fight progresses
Consistent PBR workflow for realism
Include facial variation: cuts, swelling, fatigue
Step 3 — Rigging (CRITICAL for realism)
Build a humanoid skeleton with proper joint hierarchy
Add: spine twist bones, shoulder/hip helpers, finger controls
IK (Inverse Kinematics) for feet/hand contact with floor, cage, opponent
Define animation bone masks so you can blend upper/lower body separately
Tools: Blender Rigify, Maya HumanIK, Auto-Rig Pro

Phase 3: Animation — The Realism Engine
Step 4 — Reference & Storyboard Every Move
For each action: anticipation → windup → impact → follow-through → recovery
Example: A jab isn't just "arm forward" — shoulder rotates, hip turns, weight shifts front foot
Plan transitions between stances and between standing → clinch → ground
Step 5 — Build Animation Sets (Layered Approach)
Group animations by category:
Table
Layer	What It Includes
Locomotion	Walk, jog, shuffle, circle left/right, pivot, slip
Idle/Stance	Boxing, Muay Thai, southpaw, orthodox, wrestling crouch — with subtle breathing
Attacks	Jab/cross/hook/uppercut; leg/body/head kicks; knees/elbows; takedowns; clinch strikes
Defense	Block high/low, parry, slip, duck, lean back, sprawl, cover up
Hits/Reactions	Light graze → solid hit → knockdown → knockout; staggered recovery
Transitions	Break clinch, shoot for takedown, guard pass, mount, stand up from ground
Ground	Escapes, submissions, ground-and-pound, sweeps
Keep animations short and modular — blend them in-engine rather than making one long sequence
Aim for 60–120 frames per second in source; game playback is usually 30–60fps
Step 6 — Weight & Timing = Realism
Anticipation: ~6–12 frames before the hit (fast for strikes, slower for power moves)
Impact: 1–3 frames — the moment of contact is sharpest
Recovery: 10–30 frames — longer recovery = more committed move
Heavy strikes = more body recoil, slower return to stance
Never animate legs as static while upper body moves — everything connects through the hips
Step 7: Motion Capture vs Keyframe
Budget option: Use free/paid mocap libraries (Mixamo, Reallusion, Adobe Mixamo, Rokoko) then clean up
Custom: Phone/VR mocap → process → polish by hand
Pure keyframe: Full control but slower — great for stylized or unique moves
Always use reference footage as your timing benchmark

Phase 4: In-Game Integration — Where Simulation Lives
Step 8 — Set Up the Animation Graph
Use Animation Controller (Unity) or Animation Blueprint (Unreal)
Parameters: Stance, MoveSpeed, AttackType, IsBlocking, Health, Stamina, GripLevel
Blend Trees for smooth transitions between walking/circling/attacking
Layer masks: e.g., legs continue footwork while upper body throws combinations
Step 9 — Add Physics & Reactions
Hit Reactions: Don't just play an animation — apply force:
Jab to head = slight head snap back + small step back
Heavy cross = body twist + stagger
Clean shot = full-body impulse → knockdown animation
Inverse Kinematics (IK): Feet stay planted on uneven ground; hands rest on cage or opponent
Physics Layers: Ragdoll only on knockdown/KO; blend from animated → ragdoll for impact moment
Step 10 — Discipline-Specific Logic
Since this is a management/sim, tie animations to your fighter's stats:
Higher Boxing = tighter, faster, more economical movement
Higher Muay Thai = longer range, more knees, stronger stance
Higher Wrestling = faster takedown entries, better balance when hit
Stamina = slows movement, hands drop, wider stance, slower recovery as fight drags on

Phase 5: The Environment — Your Octagon/Ring
Model the cage/ring with accurate dimensions (your 30ft / 9.14m across flats)
Add collision for cage walls, ropes, corners
IK targets: hands can grab fence; body can lean against it
Camera angles: wide for overview, close-on-hit for impact, corner/top-down for simulation view

Phase 6: Polish & Feedback
Sound design makes it feel real — different impacts: glove on head, shin on thigh, fist on gut, canvas thud
Visual feedback: hit sparks, slow-mo on big impact, screen shake (subtle), damage decals
Test against stats: a 99-speed boxer should visibly move faster than a 60-speed wrestler
Iterate timing: watch playtesters — if moves feel floaty, tighten anticipation/recovery

Recommended Toolchain
Table
Purpose	Tools
Modeling/Animation	Blender (free), Maya, 3ds Max
Mocap	Rokoko, Kinect, phone apps, Mixamo (free library)
Game Engine	Unity or Unreal Engine 5
Rigging	Blender Rigify, Auto-Rig Pro, HumanIK
Reference	FightLoom, YouTube slow-motion, UFC/Boxing archives

Pro Tip for Your Management/Sim Genre
You don't need to animate every possible exchange — create modular motion building blocks, then let the game's AI logic pick and blend them based on fighter stats, opponent style, stamina, and positioning. This is how games like EA Sports UFC and Fight Night achieve infinite-looking variety from finite animation sets.

---

## ASSESSMENT — Claude, 2026-09-21

### WHAT IT GETS RIGHT, AND WE ALREADY DO

Modular clips blended in-engine rather than long sequences; upper/lower layer
masks (`FightBodyLayers`, wired and verified in S5); stat-driven selection (the
technique catalogue + `FightMoves`); foot IK (merged b73ca90, R3 0.114); the
anticipation → impact → recovery shape (S4a's move script); and the cage at
9.144 m, which landed today as `mma_cage_ufc_30ft`. The "Pro Tip" is exactly our
architecture. **None of that is a gap.**

### THE FIVE THINGS IT MISSES, IN ORDER OF WHAT THEY HAVE COST US

**1. IT HAS NO CONCEPT OF A PAIRED ANIMATION, AND THAT IS THE WHOLE GRAPPLING
PROBLEM.** Every step treats animation as one character at a time — "Attacks",
"Hits/Reactions", "Transitions" as separate clips blended per fighter. A
takedown, a clinch or a guard pass is ONE motion performed by TWO bodies on ONE
clock, and it cannot be assembled from two independently-authored clips. We
measured this rather than assumed it: `compose_takedown.py` deliberately aligned
6 attackers against 6 defenders and scored **0 of 36** — every attacker stops at
the grab (follow-through 0.00–0.06 m) and the torsos interpenetrate in 16–81% of
frames. The recipe's model cannot produce the half of the game that is hardest.

**2. "USE A MOCAP LIBRARY (MIXAMO, ROKOKO)" IS NOT AVAILABLE FOR GRAPPLING.**
It is sound advice for locomotion and single-character strikes. For paired
grappling the catalogue does not exist: R144 surveyed it and the Higgsfield study
ran 8 two-fighter generations across two prompt styles and two seeds — **all 8
came back as ONE BODY**, and of 4 armbar prompts none reached the ground at all.
The recipe offers a budget option that is empty precisely where the budget
matters.

**3. NO RETARGETING PHASE — AND THAT IS WHERE OUR QUALITY ACTUALLY DIES.** It
goes model → rig → animate → engine and never mentions that a bought or captured
clip must be retargeted onto your own skeleton. That step is our single largest
measured quality loss: mean error **7.21° across nine joints** on the corrected
path, and the operator's verdict on the retargeted clips was "pretty bad".
Because we retarget rotations only with no IK, and the bodies are not
Mannequin-proportioned, **punches do not land where they were captured.** A
pipeline that omits this phase will produce clips that look right in the DCC tool
and wrong in the game.

**4. ITS ONLY QUALITY GATE IS "WATCH PLAYTESTERS — IF MOVES FEEL FLOATY".** That
is the failure mode this project has paid for most often. Deliveries pass their
gates and are still wrong; a green suite covered the wrong vocabulary entirely
(the presenter reported `strike_head` while the player held `jab`); agents'
summary sentences were wrong 4 times in 14 on one day. What is missing is
**numbers against real footage** — J20's anchors, the contact probe, the
per-discipline distributions. "Feels floaty" cannot be regression-tested and does
not survive a handover.

**5. NO SIM↔PRESENTATION CONTRACT.** In a management sim the engine decides WHAT
happened — technique id, outcome, position — and the animation layer presents it.
The recipe jumps straight from blend-tree parameters to stats and never names the
seam between them. That seam is exactly where we have been bitten, and it is also
where determinism lives: our fight is seeded and must replay identically
(`SEED_MOVEMENT` and separate per-subsystem streams), so an animation layer that
samples its own randomness silently breaks replay. The recipe never mentions
determinism.

### THREE THINGS WORTH TAKING FROM IT

- **The frame budgets are a spec we do not have.** Anticipation 6–12 frames,
  impact 1–3, recovery 10–30, longer recovery = more committed. We have engine
  timing per technique but no authored anticipation/recovery budget per move
  class, and this is concrete enough to measure against footage.
- **Animated → ragdoll blend at the impact moment for knockdowns.** We have no
  ragdoll at all. The knockdown rate is 3.9% of the denominator J20 defines, so
  this is a small number of events buying a large amount of readability.
- **Shin checks, level changes and sprawls as first-class locomotion.** Our
  locomotion binding is thin — C94 found 37 clips and only WalkForward and
  WalkBack are bound.

### THE ORDERING IT GETS WRONG FOR US

It presents the phases as equal and sequential. Our ordering was ruled on
2026-09-14: **ENGINE FIRST** — cage position, stances, real dodges, feints and
commitment, and the states between exchanges — before clips. Phases 2 and 3 of
this recipe are largely where a team with an animation budget starts; we start at
Phase 4 and buy or author only what the engine proves it needs.

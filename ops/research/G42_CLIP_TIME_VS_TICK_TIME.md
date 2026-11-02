# G42 — THE CLIP IS 0.82 s AND THE ENGINE TICKS AT 20 Hz

Grok, Expert, 2026-09-10. Driven in the in-app browser by Claude; 60 sources.
Research only — no tick loop, no state machine, no GDScript. The seeded 20 Hz
core is settled and this paper does not slow it down. Ground game is one line at
the end of §4. Spliced verbatim by Claude, who wrote this header and the HANDOFF
block and changed nothing else.

**The measured mismatch:** clip `Combo (Jab-Cross-Hook)` = 2.47 s for three
punches ≈ **0.82 s per punch**. The engine can emit impacts 7 ticks apart =
**0.35 s**. A 3×5 bout is ~18,000 ticks. Judges and stoppage read the ticks. The
view cannot be told to hurry the clip without looking wrong, and the engine
cannot be told to wait.

**A note on "0.82 s is roughly honest."** Elite boxing 1–2 intervals are often
shorter than that; a readable mocap three-punch string is not the same object as
a live flurry. The engine's 0.35 s is not a cartoon. **The clip is the slow
object.** That does not change the architecture question.

---

## §1 — WHO IS AUTHORITATIVE, IN SHIPPED GAMES

Three answers. The industry has shipped all three.

### (a) The animation is authoritative

Street Fighter (IV/V/6), Tekken, Guilty Gear, Virtua Fighter, Smash. Dustloop /
SuperCombo document the contract: a frame is 1/60 s, a move is **startup /
active / recovery**, and those numbers *are* the rules. A 5-frame jab hits on
frame 5 because the animation says so. Combos exist because recovery of move A
and startup of move B were authored to fit. Cancels are holes cut in recovery by
design, not a view catching up to a sim.

- **Buys:** readable offense, a community that can lab the game, byte-identical
  replays that match what you saw.
- **Costs:** you do not have a separate physics/damage clock. Change the clip,
  you change the sport. You also author every cancel window. **A versus-fighter
  budget.**

**We cannot become this.** Our cards already sit on a seeded tick that does not
know what a startup frame is.

### (b) The simulation is authoritative; animation is a view

Named shipments:

- **For Honor** (Ubisoft; GDC / Game-Anim writeup of Simon Clavet's
  motion-matching talk): code chooses the trajectory; animation is "a cosmetic
  detail on top." Entity clamped ~15 cm to the simulated point. Delay accepted
  because predictability beat responsiveness.
- **Just Cause 3** (Avalanche, GDC "Realizing Responsive High Fidelity Character
  Movement"): game-driven movement — logic moves the capsule, animation is
  selected to match. Animation-driven movement was **rejected as the default**
  because coverage would explode.
- **EA UFC 2009 Undisputed** (Yuke's, GDC 2010, Hiroki Ueno): Havok physics +
  animation reference poses + full-body IK targeting so a punch reaches the body
  the collision system named. Stated goal: **"Use fewer animations more
  efficiently."**
- **EA Fight Night Champion** (2011): damage, stun, cuts, stoppage are a
  body-region sim. The punch stick selects a clip; a stun interrupts that clip;
  the KO replay is a camera on an event the sim already called.
- **Madden Super Sim / Play the Moment**: the play-count sim is the game. The 3D
  broadcast is optional dressing. Fast Super Sim drops to GameCast text so the
  view does not have to keep up.
- **Football Manager / Total War unit melee**: the 3D layer is allowed to be
  wrong in the small so the ledger stays right.

- **Buys:** a deterministic core you can seed, replay and judge. The animation
  library can be incomplete. One clip can serve twelve fighters (we already have
  this).
- **Costs:** the picture lags the fact. If you insist every impact is visible at
  authored timing, **the picture lies or the card waits.** You must decide, in
  public, that the card wins.

**We are this kind.** The useful question is how the second kind keeps the
picture from becoming a second fight.

### (c) A negotiated middle

The sim proposes an action; the animation system can refuse or delay inside a
commitment window.

- **Dark Souls / Sekiro / Nioh**: a swing is committed once started, but poise,
  stamina, i-frames and incoming damage are a separate meter. The animation gates
  the player, not the world's clock.
- **For Honor** on the matching layer: gameplay declares a goal, the matcher
  finds a clip; if nothing fits, you still move, you just look late.
- **EA UFC (1–6)**: layered state machines — locomotion base, additive copy of
  the same machine on spine/hips, procedural foot plant, head IK, "intelligent
  contact windows" (UFC 6 language: a strike lands when the opponent is in range,
  **not** when the clip's contact frame arrives). UFC 2 GDC: **1,957 two-player
  ground clips** — that number is the cost of negotiating grappling. Striking is
  cheaper because a punch is one body.
- **Undisputed** (Steel City, 2024–26): combo-flow work to make 1–2–3 look like
  one string; community reports of **desync** the moment physics leaves the
  canned axis. That is the negotiated middle failing in public: two clocks, no
  declared winner.

- **Buys:** contact looks like contact; footwork can continue under a punch.
- **Costs:** a second clock you now have to debug. Commitment windows also need
  authored in/out poses or the blend pops.

**What (b) and (c) actually do, compressed.** They never let the clip write the
damage event. They cut, blend, layer, or hide. They treat a long combo clip as a
suggestion, not a sentence. They spend budget on reactions and contact IK, not on
making the 2.47 s string the unit of combat.

---

## §2 — THE TECHNIQUES, BY NAME

For each: what it is, what it needs from the library, and whether a generic
humanoid preset pack can supply it.

### 1. Animation cancelling (cut the clip)

On the engine's impact tick — or on the next punch being emitted — stop the
current clip and start the next, from a marked contact pose or frame 0 of a
single-punch clip. **This is not a Street Fighter cancel** (a designed hole in
recovery); this is "the fact happened, the picture is now late." Fight Night does
the interrupt version on stun.

- **Library:** single-punch **in-place** clips (jab, cross, hook, uppercut, both
  hands). **A 2.47 s 1-2-3 combo clip is the wrong purchase for this technique.
  You cancel out of it.**
- **Buyable off a generic pack:** yes, as separate punches.

### 2. Cross-fades and blend trees

0.10–0.20 s blend from clip A to B so the cut is not a pop. Blend trees are not a
punch solution by themselves.

- **Library:** clips that share a stance. If the pack's jab ends in a different
  guard than the hook starts, the blend will swim.
- **Buyable:** yes, inside one stance family. Bespoke in/out poses for every pair
  are a fighting-game authoring list. **Do not start that list.**

### 3. Additive layers

A hit-reaction on the upper body while the legs keep the footwork cycle. EA UFC 1
(GDC, "Inside the UFC Animation System") ran a second copy of the locomotion
state machine as **additive on hips/spine** specifically so a punch and a step
could coexist.

- **Library:** short flinch / snap / body-fold clips, directional — head left,
  head right, body, rear.
- **Buyable:** yes. **The highest-leverage purchase after single punches.**

### 4. Partial-body masking

Play the punch on spine-up, keep the walk on hips-down. Dynamic masks were tried
at UFC 1 and were **not enough on the shared spine joints** — which is why they
added the additive twin machine.

- **Library:** nothing extra if the mixer can mask. Lower quality ceiling than a
  real additive react.

### 5. Time-scaling the clip

Play the 0.82 s punch at 2.3× to fit a 0.35 s gap.

- **What is published:** Madden's own 2024 BOOM-tech deep dive — QB dropbacks had
  been sped "almost 2X the speed of the original animation capture" across
  cycles, and **they walked it back** because the motion read as wrong against
  the line. A studio measurement, not a blog.
- **What is folklore:** "you can time-scale 20 percent before anyone notices."
  Animator shop talk. **No named postmortem measures 20 percent as a threshold
  for attack clips.** Compression talks measure quantization error, not playback
  rate. **Mark unsourced.**
- **Safe to say:** locomotion cycles are routinely rate-scaled to match capsule
  speed. **Attack clips are usually re-authored, not stretched**, and past ~2× a
  shipped sports team undid it.

### 6. Root motion versus engine-driven position

For Honor, Just Cause 3 and the standard Unreal "root motion from montages only"
recommendation all agree for a sim-driven actor: **locomotion is in-place, the
capsule is the truth.** UFC 2009 used IK to make the glove arrive without letting
the clip walk the man.

**If root motion from a purchased clip translates our fighter, the engine's
distance check at tick 4,113 and the body on screen at tick 4,113 are different
fights. Judges score the first.**

- **Library:** in-place punches. Most marketplace boxing packs are in-place or
  can have root stripped.
- **Not buyable as a solution:** a root-motion combo that also happens to match
  our footwork sim. That clip does not exist on a 0.2-credit shelf.

### 7. Committed versus interruptible

A committed clip plays to the end — knockdown, wave-off, celebration, the walk
back to the corner. Fight Night commits the KO. UFC 6 selects a long knockdown
only when the sim says the man is really hurt — **commitment gated by the sim**,
which is the right direction of the arrow.

- **Library:** a few committed full-body clips (down, up, corner, stun-walk) and
  many short interruptible punches/reacts.
- **Do not use the 2.47 s combo as a committed object. It will desync on punch
  two.**

### 8. Contact IK / targeting

The engine named a region (jaw, liver, guard); IK bends the arm so the glove is
there on the impact tick even if the clip's contact frame is elsewhere. UFC 2009
GDC is the canonical shipped version; UFC 6's "intelligent contact windows" is
the same idea with a marketing name.

- **Library:** a punch that generally extends. IK does the last 20 cm.
- **Worth more than a second combo string.**

### 9. Hitstop (view freeze)

Both actors freeze 2–8 frames on contact so the impact reads. Capcom measured
this (Final Fight: 6 frames universal). **It does not require the sim to wait if
the freeze is display-only.** If hitstop is applied to the authoritative clock,
you have changed the core — out of scope, and a refusal if anyone proposes it on
the 20 Hz loop.

### 10. Motion matching

For Honor: search a database of poses for the one matching current pose +
desired trajectory. Buys coverage, costs For Honor's animation budget. **A
97-clip pack is not a matching database.** Named so we do not wander into it.

### The shopping list

**Purchasable off a generic humanoid boxing-ish pack, in order:**

1. Single punches, **in-place**, both hands, two heights (head/body).
2. Additive or standalone **hit-reacts**, four directions plus body.
3. Guard / block / flinch.
4. Idle and a footwork cycle **in the same stance**.
5. One knockdown and one get-up (committed).

**Not purchasable — do not pretend:**

- Paired two-person exchanges (UFC's ground numbers exist to scare you).
- Per-fighter signature libraries (Fight Night's Tyson / Ali / Pacquiao sets).
- A combo string whose internal timing matches a 20 Hz event stream.
- Motion-match coverage.
- Ground. Already measured: **1 grappling clip in 97.**

**The 2.47 s combo clip is useful as a broadcast replay of an exchange the engine
already closed, or as a menu flourish. It is the wrong unit for live ticking.**

---

## §3 — THE PRESENTATION ESCAPE HATCH

A broadcast does not show every punch. Neither do shipped games when the sim
outruns the picture.

**What they do:** drop impacts from the view (Madden Fast Super Sim gives you a
GameCast line; Football Manager's 3D is a skin on a result); aggregate into one
shown strike; slow the camera / stun cam (Fight Night Champion swings to the hurt
man, colour drains — the sim has already applied the stun, the view
editorializes); cut away to wide, crowd, corner or scoreboard during a flurry the
library cannot voice.

### Which preserve the scoreboard, which lie

| View move | Scoreboard truth |
|---|---|
| Don't draw punch N; HUD / judges still have it | **Preserves** |
| Cut to wide / crowd / corner during an un-animatable flurry | **Preserves**, if you do not subtitle "he missed" |
| Replay the knockdown the engine called | **Preserves** (it is after the fact) |
| Stun cam / hitstop as display only | **Preserves** |
| Play one 2.47 s combo while the engine landed five | **LIES** — player sees 3, card has 5 |
| Time-scale so every engine impact is visible | Usually **lies in the body** (weight, telegraph) even if the count matches |
| Hold the next engine punch until the clip finishes | **Lies the other way**, and is forbidden here anyway |
| Root-motion the fighter to where the clip wants | **Lies about distance**, which is how we miss or land |

**The distinction this project actually cares about: judges score the engine. A
prettier fight that is a different fight is a bug.** Fight Night's KO replay
works because it is labelled as a replay of a decided event. Undisputed's desync
clips are the failure mode of an unlabelled second clock.

**We are allowed to show an exchange and then a replay. We are not allowed to
show a different exchange.**

---

## §4 — THE REFUSALS

1. **Driving the sim from clip lengths.** *Confirm.* That is becoming Street
   Fighter after the cards are already printed.
2. **Time-scaling attack clips past the point a shipped team already undid.**
   *Confirm as a refusal at ~2×* (Madden dropback, named and published). The "20
   percent is invisible" rule is **unsourced folklore — do not build a policy on
   it.** Modest rate tweaks on locomotion cycles are normal and not the same
   thing.
3. **Per-strike unique animations for a management game.** *Confirm.* Fight Night
   and UFC paid for signature sets because the fight is the product. We have
   twelve fighters, one clip, 0.2 credits.
4. **Letting root motion move a fighter the engine positions.** *Confirm.*
   Distance is a tick-resolved fact; a purchased clip's root is not a second
   physics authority.
5. **Animating the ground off one grappling clip in 97.** *Confirm, and stop.*
   Timing on the ground is a different problem (holds last seconds, not 0.35 s)
   and is blocked on sourcing, not on the 20 Hz gap.
6. **Showing every impact.** *Confirm as a refusal.* Broadcasts do not. Madden
   Super Sim does not. **Dropping a punch from the view is not dropping it from
   the card.**
7. **Motion matching / two-person capture / driven-ragdoll as the live layer.**
   *Confirm.* Those are other companies' decade-budgets.

### Unsourced, refused BY NAME

- "±20% playback is invisible on punches." Shop talk. No named postmortem.
- "Combo clips can be retimed to any event spacing and still read as boxing."
  Contradicted by Undisputed's own combo-flow recapture and Madden's 2×
  walk-back.
- "Just use hitstop on the sim clock." Hitstop-as-view is documented;
  hitstop-as-rules is a fighting-game choice already refused in §1.

---

## §5 — WHAT YOU WOULD NOT BUILD

We are a management game. The 3D fight is one screen among many. The operator
already collapsed per-commission corner rules into one authored rule because no
player picks a state athletic commission. **Same call.**

### Worth it — small list

1. **Treat the purchased combo as a replay/editorial clip, not the live unit.**
   Live unit = single punches + cut on the engine's impact.
2. **Additive (or masked) hit-reacts on the body region the engine already
   named.** The six-region model is the one thing the view should honour, because
   the card honours it.
3. **In-place clips.** The engine owns translation.
4. **Contact IK** so the glove is near the region at the tick, without a second
   ruleset.
5. **Permission to not show a punch.** Wide camera, HUD flash,
   replay-of-the-knockdown. That is the hatch that keeps the card honest.
6. **Hitstop / camera punch as display-only juice** on impacts you do show.

That is a shopping list and a presentation rule. **It is not a fighting-game
animation graph.**

### A fighting-game budget we should never spend

- Startup/active/recovery authoring and a cancel graph — re-deriving the sport in
  frames after deriving it in ticks.
- Motion matching.
- Per-fighter signature libraries.
- Two-person synced exchanges.
- Re-authoring clip timing so a 2.47 s string lands on ticks 4113 / 4120 / 4128.
- Ragdoll-as-authority.
- **A negotiated action window that can refuse an engine impact.** Refusal means
  the view and the judges diverge — that is the §3 bug with a state machine
  attached.
- Any ground-animation program until the library exists.

---

## The call, in one sentence

**Keep the 20 Hz core as the fight. Buy short in-place punches and reacts. Cut
and layer. Show an exchange, not 18,000 ticks. Never let a 0.82 s clip write a
0.35 s fact.**

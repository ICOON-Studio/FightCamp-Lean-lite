# G56 — A Three-Second Reaction on a One-Second Beat

**Agent:** Grok, Expert tier, 2026-09-11. Worked 1m 33s, 97 sources.
**Supersedes:** G55 (miss modelling), composed but never sent.
**Commissioned for:** R109, which wires eleven retargeted clips into the presenter.

Grok was asked to separate **DOCUMENTED** from **FOLKLORE** from its own
**INFERENCE**, and it did. The labels below are its own.

---

## The headline: THREE CLOCKS, and only one of them may stall

The answer to the management-game case — the part G56 told it to spend the most
effort on — is that shipped games in our position run **three separate clocks**:

1. **The sim clock.** It has already decided the beats. It never waits.
2. **The presentation queue.** Consumes beats, picks a clip pair, and **may drop
   or merge beats.**
3. **The authored clip clock.** Allowed to own time **only for set pieces** —
   knockdown, ref step-in, between rounds.

> "Shipped management games do not let a long celebration clip stall the match
> result." — Grok, labelled inference across the genre

**Named evidence:**

- **Football Manager (Sports Interactive).** One match engine produces the
  result whether you watch it or click Instant Result; the 3D view is a separate
  graphics/animation engine visualising events. The FM22 talk describes
  rebuilding the animation engine because presentation had been the slave of a
  simpler mover. FM26 uses Motion Matching + IK to select a clip that fits an
  **already decided** action. **The highlight reel is the official admission
  that presentation drops most sim events.**
- **Soccer Manager 2025 "Match Motion"** (documented postmortem). The old engine
  queued too many sim actions into too little time and produced glitchy
  double-kicks and players running through actions. The new system lets
  animation selection drive the on-pitch path and **space or drop actions that
  would look false** — presentation gating the *display* of sim intent, never
  the result.
- **OpenFoot Manager** (open docs): engine decoupled from domain; instant mode
  resolves, live mode steps events for the watcher. Same split.
- **Auto-battlers:** sim ticks in the background, the board plays a short attack
  anim and a short hit flash, then the next tick. **They accept clipping. They
  do not time-stretch every unit to the longest clip in the pack.**

**What nobody does, in named practice: pause the match sim so one victim clip
can finish.** That is animation-as-state — the Tekken / Street Fighter model,
where the animation IS the game state. It is not available to us and it is not
what our cousins do.

---

## The receiver, specifically

- **Player fighters: the reaction clip is not the authority — hitstun frames
  are.** The animation is written or looped to fill that window, then cancelled
  on the first actionable frame (Smash: FAF / IASA — Mario fsmash is 56 frames
  of animation, interruptible at frame 48). Capcom treats stun as *state*, not
  as "finish the file".
- **CryEngine Hit/Death Reactions** (documented): a hit reaction may not
  interrupt another hit reaction; default `maximumReactionTime` **4.0 s** with a
  **~3 s failsafe force-end**; reactions play as override on layer 0 or additive
  on a higher layer; transition in **0.1 s**.
- **EA Sports UFC / Fight Night / EA MMA** (documented talks): receiver impact is
  **layered** — face/muscle deform, a short reaction, ragdoll later for
  knockdowns. **They do not play a 3 s authored performance to completion on
  every connect.**
- **Jungbluth, "Anatomy of a Hit Reaction" (GDC 2017):** additive overlay on a
  running base, **1-frame blend in**, fade out across the rest of a 12-frame
  clip. His own verdict: additive reactions are **"a half-measure at best."**

---

## Cutting a reaction short — the honest non-answer

**There is no published universal fraction.** Grok could not attach "play N%
then cut" to any talk or postmortem, and says plainly: *"Treat any 'must play
50%' rule as invented."* That is worth more than a confident number.

What IS documented:

| source | number | basis |
|---|---|---|
| Crytek | force-end at ~3–4 s | so a stuck clip cannot freeze the character |
| Smash | interruptible at an authored frame (often last ~10–15% of the file) | not a percentage rule |
| Jungbluth | readable additive hit = **12 frames**, impact on frame 1–3 | 0.40 s @ 30 fps, 0.20 s @ 60 fps |
| Capcom (SFV lecture) | hitstop **8 f** + hitstun **13 f** @ 60 fps | ≈ 0.13–0.35 s of locked receiver time — **not 3 s** |
| GDKeys | player reaction ≈ 0.25 s (8 f @ 30, 15 f @ 60) | about INPUT, not about spectator readability |

Grok's inference: a watchable light reaction at 60 fps is **8–16 frames
(0.13–0.27 s)** of distinct contact pose, then blend out. **A 3.03 s head
reaction is a performance, not a hit.**

---

## Upper/lower split — and the specific way our pack will break

Named systems: **EA Sports UFC (GDC 2015)** — base full-body idle, lower-body
locomotion with foot IK, plus an **additive copy of the same locomotion state
machine on hips/spine**. Per-bone dynamic masks **were tried and were not
enough, because punches and stance both own the spine.** **EA MMA (2010)** —
explicit per-body-part layer / override / add / subtract.

**This is the warning that lands directly on us.** Our reactions and our
locomotion came from the same pack but were authored as **separate whole-body
performances**. What breaks:

- Legs in the reaction clip fight the stance clip → **foot slide, stance collapse**.
- Shared hip/spine gets two authors → stiff or disconnected torso. *This was the
  actual failure mode in the UFC talk.*
- A stagger containing a weight shift reads as sliding while "holding stance".
- **An additive extracted from a full-body performance is not a true additive** —
  it still carries the locomotion delta.

> "Bake true additives off a shared reference pose; do not mask a 3 s full-body
> HitReaction01 and hope." — Grok

**We have that shared reference pose: `T_pose.fbx`.** R108 already proved it is
the rig's real rest and built the correction from it.

---

## The recommendation, and what it costs

**Tier the eleven clips and let the BEAT own time — except for knockdowns.**

| clip class | treatment |
|---|---|
| Jab / light stagger | additive upper-body over stance; hold the impact pose **8–12 f @ 60 fps (0.13–0.20 s)**, blend out **0.10–0.15 s**; next beat may cancel immediately after the hold |
| Head reaction 3.03 s | **do not play the file.** Use only the first readable peak (contact + recoil), or swap in the ~1 s StaggerSmall. Reserve the long clip for a called heavy/stun beat or a replay |
| Idle 4.67 s | loop under everything; **never gate a beat on it** |
| KnockDown01 | **this one may own the clock.** Treat it as a scene beat and drain or pause the exchange queue — the FM-highlight exception |

Support with **hit stop of 4–8 frames @ 60 fps (67–133 ms)** on connect, so
weight comes from the freeze rather than from clip length. Capcom, Sakurai
(Famitsu 490) and Mike Z (Skullgirls, GDC 2014) all treat freeze as the cheap
impact signal; Mike Z: *"You damn well don't make a game without hitstop."*

**The single biggest failure of this choice, named:** a documented heavy shot
plays as a flinch — the sim told the truth and the presenter under-sold it.

**But the opposite failure is worse for us:** playing `HitReaction01` at its
authored 3.03 s turns the whole card into slow motion and the next engine beat
arrives while the head is still travelling. **Prefer the lie of a short,
readable hit plus VFX/camera/hitstop over the lie of a fight that no longer
matches its own result.**

---

## What R109 takes from this

1. **The presentation queue is a real component, not an implementation detail.**
   It consumes beats and is permitted to drop and merge them.
2. **Clip length must not gate a beat.** Only knockdown is allowed to own time.
3. **Do not mask the whole-body reactions we own.** Bake true additives against
   the `T_pose.fbx` reference, or accept override on the upper body only.
4. **The 3.03 s HitReaction is the wrong default.** C87's ladder puts
   `react_head` at 56.9% of 9,715 shown beats — so the most-demanded role is
   exactly the clip we must not play in full. Use its first peak, or the ~1 s
   stagger.
5. **Hit stop is cheaper than animation length** for selling weight.

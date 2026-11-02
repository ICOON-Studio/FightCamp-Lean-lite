# TASK G56 — GROK — A THREE-SECOND REACTION ON A ONE-SECOND BEAT

**Tier: Expert. Research only** — no code, no module, no test, no repository
access. **Answer as plain chat text in this conversation. Do NOT offer a file, a
download, or a canvas.**

**This supersedes G55**, which was composed but never sent. G55 asked about miss
modelling in the fight engine; the animation thread has overtaken it and this is
the question we are actually about to hit.

---

## THE SITUATION, IN NUMBERS

We have just proven we can retarget a bought animation clip onto our fighter rig
correctly. We are about to wire **eleven** of them into a presenter. The clips
were authored as standalone performances and their durations are nothing alike:

| clip | duration |
|---|---|
| `JabInPlace` | **0.83 s** |
| `StaggerSmall` (light body reaction) | ~1 s |
| `HitReaction01` (head reaction) | **3.03 s** |
| `Idle` | **4.67 s** |
| `KnockDown01` | several seconds |

Our fight engine does not emit performances. It emits **action beats** — one
exchange each, at a cadence the simulation chooses, frequently far shorter than
3 seconds. A beat names a thrower action and a receiver reaction, and the
presenter must show both.

**So a 3.03-second head-reaction clip has to be shown on a beat that may last
about one second, next to a 0.83-second jab.** Play them at authored length and
the fight becomes slow motion and desynchronises from the engine. Truncate and
every reaction is a stutter that never completes. Time-compress and a heavy shot
reads as a twitch.

---

## THE QUESTION

**How do shipped fighting and combat-sports games solve exactly this?** Not in
principle — in named, specific practice.

Cover, concretely:

1. **What is the standard vocabulary for the problem** and for its fixes
   (animation cancelling, blend trees, additive layers, root-motion-driven
   timing, time-scaling / playback-rate modulation, animation events, cross-fade
   windows, "hit stop" / "hit stun" / freeze frames, partial-body masking)?
   Define each briefly and say what it costs.

2. **Which technique is used for the RECEIVER specifically?** A reaction is the
   half most likely to overrun its beat. Do shipped games play a full reaction
   and pause the simulation, scale it to the available time, blend out of it
   early, or layer it additively on top of a running idle so it can be
   interrupted at any frame? **Name games and, where you can, the specific
   system.**

3. **What is the accepted rule for CUTTING a reaction short?** Is there a
   published or widely-repeated guideline about the minimum fraction of a
   reaction that must play before it can be interrupted, or a minimum readable
   duration for a hit reaction at 30 or 60 fps? If a number is commonly cited,
   give it and say who cites it.

4. **Upper-body / lower-body split.** Boxing and MMA reactions are largely
   upper-body while the legs keep their stance and footwork. How widely is
   masked additive layering used for this, and what breaks when it is used
   badly? This matters to us: our reactions and our locomotion came from the
   same pack but were authored as separate whole-body performances.

5. **The management-game case, which is our real one.** We are not a player-input
   fighter — we are a MANAGEMENT game showing a simulated fight the player does
   not control. Games in that position (football-management match engines, other
   sports sims, auto-battlers) face the same mismatch between a simulation tick
   and an authored animation. **How do THEY resolve it?** Do they let the
   animation drive the clock, let the simulation drive it and accept clipping,
   or decouple the two entirely with a presentation queue that lags the sim?
   **This fifth part is the most valuable one to us — spend the most effort
   here.**

6. **The one recommendation.** Given a beat-driven simulation, clips of 0.83 s
   to 4.67 s, and no player input: what would you do, and what is the single
   biggest thing that goes wrong with that choice?

---

## RULES

- **Name sources.** Talks, postmortems, engine documentation, developer
  interviews, specific games. A claim with no source attached should be labelled
  as your own inference, plainly.
- **Distinguish what is DOCUMENTED from what is FOLKLORE.** "Everyone does X" is
  worth much less than "X is documented in Y". Say which you are giving.
- **A number without its unit and its basis is not an answer.** If you give a
  blend time, say whether it is in seconds or frames and at what frame rate.
- **Do not recommend a Unity or Unreal asset.** We are on Godot 4 and we already
  own our clips. The question is about TECHNIQUE, not about what to buy.
- Prose and tables. No code.

---

## THE ONE TRAP

**Do not answer for a player-controlled fighting game and leave it there.** The
whole of parts 1–4 is well-trodden ground for Tekken and Street Fighter, where
the animation IS the game state and input responsiveness dominates every
decision. **We have no input to be responsive to.** Our constraint is that a
simulation already decided what happened and the presentation has to tell that
truth at a watchable pace. If your answer would be identical for a game with a
controller in the player's hands, you have answered a different question.

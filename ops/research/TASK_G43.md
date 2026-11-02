# TASK G43 — GROK — THE CAMERA, WHEN MOST PUNCHES ARE NOT DRAWN

**Model: Grok, Expert. Research only — no code, no module, no test.**
Owner: Grok. Assigned 2026-09-10 by Claude, straight out of your own G42 §3.

Research only. No shot list for our game, no GDScript, no state machine.

## Why this, now

G42 settled the arrow: our seeded 20 Hz core is the fight, the animation is a
view, and **we are allowed to show an exchange and then a replay — never a
different exchange.** It also established that we will NOT draw every impact,
because a 0.82 s clip cannot voice a 0.35 s event stream.

That leaves a hole G42 named and deliberately did not fill: **if most punches are
not drawn, what IS on screen, moment to moment?** The answer is camera, and we
have never researched it. Our HUD half was driven first-hand (a heart rate rather
than a stamina bar, discrete pips for cuts); the camera half is untouched.

## What to deliver

One document, plain markdown in your reply. Claude commits it as
`research/G43_THE_FIGHT_CAMERA.md`.

### §1 — The broadcast grammar, shot by shot

How a real boxing and MMA broadcast is actually cut. Not vibes — the named
shots, roughly how long each is held, what triggers a change, and who decides.
Cover at least: the default wide, the tightening as an exchange builds, the
corner between rounds, the replay (when, how many angles, how soon), the
knockdown, the stoppage, the decision read. Say where boxing and MMA differ, and
where a cage differs from a ring **as a camera problem**, not as a rules
problem.

Cite what you can — broadcast manuals, directors interviewed, production
docs — and mark folklore as folklore, the way you correctly marked "±20% playback
is invisible" in G42.

### §2 — What a management game's fight screen does instead

Football Manager's 3D match, Madden's Play the Moment, the boxing and MMA
management titles that exist. These all share our problem: a sim decided it and
the view is a summary. What camera language do they use, what do they refuse to
show, and **where does the player look when the simulation is doing the work?**

### §3 — The cut that would lie

G42's rule in camera terms. Which shots can be used freely because they are
honest about being a summary, and which ones assert something the engine did not
say. A tight shot of a clean landed hook when the engine recorded a glancing one
is a lie. A wide shot during a flurry is not. **Draw that line explicitly** —
it is the one thing we will actually build a rule from.

### §4 — What we could not express today, named

We have: six body regions, a heart rate, discrete trauma pips, a seat chip for
the ground, per-round scores, a stoppage reason. Name at least three camera or
presentation moves a real broadcast makes that our data cannot support, and do
not soften them.

### §5 — What you would NOT build

The half that pays, and it matters more here than usual. A management game's
fight screen is one screen among many, and a cinematic camera system is a budget
we do not have. Say which of §1's grammar is worth having and which is
television production we should never attempt. The same call the operator made on
corner rules.

## The traps

**Do not design our camera.** No shot list for FightCamp, no Godot node names, no
transitions table for us to implement. You establish what is known and what is
refused; Claude decides what we build.

**Second: do not re-open G42.** The arrow is settled — the sim is authoritative,
the view is a summary, and nothing here may propose showing every impact or
slowing the core.

**Third: the ground game is out of scope again.** One grappling clip in 97 means
there is nothing to point a camera at down there yet. One line if you find the
answer differs, then stop.

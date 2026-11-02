# KALLI_HITFEEL_ASK_KALLI - Kalli answer (seat queue SQ10)

Brief: research/KALLI_HITFEEL_ASK.md
Sent: 2026-10-21 03:40 | collected: 2026-10-21 04:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

The structure is right: a pure clip for the thrower, a reaction only on the man hit, nothing on a miss. But the numbers are tuned like an arcade fighter. The hit stop runs about 2x too long for a broadcast camera, and the impulse formula makes almost every clean jab "solid". Here's what I'd change. The impulse figures below are computed from your formula; the frame and stiffness numbers are my game-feel judgement and haven't been tested in the build.

**1. Hit stop (60 fps)**
I recommend a clean head blow at 2 + 5 × power, which gives 2 to 7 frames:
- A 12-frame freeze is 0.2 s. On a broadcast camera at three-quarter height, it reads as the video stalling, not as an impact, because TV boxing never pauses. Arcade fighters run 8 to 15 frames because the player has to feel their own input. Our viewer only needs the eye caught on the landing, and 3 to 5 frames does that.
- Glancing: half, with a minimum of 1 rather than 2. A glancing blow should barely register, and 2 frames on every graze adds up across a 10-round fight.
- Blocked, missed or slipped: 0. That's correct, and it matters for reading the fight: the freeze itself tells the viewer "that landed".
- Body blow: change "2 fewer" to the same frames as a head blow, with a different reaction (the torso folds, not the head snaps). A clean liver shot is as big a moment as a head shot. Two fewer frames would teach the viewer that body work doesn't count, and in boxing it wins fights.
- Freeze the thrower too, but only for the first 60% of the frames, then let his clip carry on. That way the punch reads as having landed, not as both men getting stuck.

**2. Impulse**
The effective mass is 0.45 + 1.75 = 2.2 kg, which is fine as a mass model. The problem is that the bands sit too low for the speeds the clips produce:
- A clean jab at 7 m/s and power 0.3 comes out at 2.2 × 7 × 0.65 = 10.0, which is "solid". A jab should be light.
- A cross at 9 m/s and power 0.6 comes out at 2.2 × 9 × 0.8 = 15.8, which is "heavy". A good cross should be solid.
- A hook at 10 m/s and power 1.0 comes out at 22, which is heavy. That's correct.
- So only glancing blows ever land "light".

My fixes:
- Use speed in the formula as (wrist speed − 3 m/s), with a floor of 0. Guard-to-extension speed below about 3 m/s is arm travel, not impact.
- Or keep the formula and move the bands to under 9 light, under 17 solid, otherwise heavy.
- With the bands moved, that jab is light (10.0 only just passes, so you'd lower the jab's power curve a little), the cross is solid, and the hook is heavy.
- Keep the cap at 25. A KO hook should hit the cap, nothing else should.
- Absorbed at 0.2 is fine. Glancing at 0.45 is a little high; 0.35 keeps glancing blows from rolling into "solid".

**3. Reaction profiles**
- **Light:** stiffness 50 to 25 (not 20), damping 6, recovery 0.12 s, head only. The head should flick and snap back. 0.15 s with a 20 floor wobbles a little too long for a jab that lands 6 times a round.
- **Solid:** keep 50 to 8, but raise damping to 5 and recovery to 0.20 s, on head, neck and upper chest. Damping 4 at stiffness 8 lets the head bob twice, and a solid shot should give one clear snap and a settle.
- **Heavy:** keep 50 to 3, damping 2 and the chest added, but raise recovery to 0.30 s. When the hit drives severity to the cap (a knockdown or a hurt state), don't return to the clip. Hand off to a stagger or knockdown clip instead. 0.25 s straight back into a guard pose after a fight-changing shot undoes the moment.
- **Mass:** head to torso at 1:7 is about right. A real head is about 4.5 to 5 kg and the upper torso about 30 kg. Heavy at 1:6.5 is fine. One addition: limit the head's yaw to about 35° on a heavy blow, so the neck never twists past what a human neck does. That keeps the "torso twists weird" note from coming back as a neck problem.

**4. Jabs and big moments**
- A jab should hit-stop, but cap a jab at 2 frames, and only a clean one. A clean jab is a scoring punch, and the viewer should see it land. With 30 to 60 jabs landing per fight, anything over 2 frames makes the fight stutter.
- Don't scale the freeze with the crowd or broadcast moment. A longer freeze in a title fight changes the time feel of the sport, and the same punch should read the same everywhere. Mark the moment with the broadcast tools instead:
  - On a knockdown, freeze 6 to 8 frames, then cut to the slow replay angle after the referee's count starts.
  - In a title fight, add crowd swell and a camera push-in, not longer freezes.
  - In the final round, add a scorebug pulse.
- One exception is the KO, the punch that ends the fight. It can get 10 to 12 frames, plus a cut to a closer angle. It happens once per fight at most, so it earns it.

The strongest case against my own advice: shorter freezes may be too subtle on the high camera, so the viewer misses landings. If playtests show that, raise the target's head reaction, not the freeze. Movement on the hit man reads from far away better than a frozen frame does.

Not computed:
- the actual wrist speeds our mocap clips produce (my examples assume 7 to 10 m/s),
- how many clean landings per round the sim produces, which decides how often the freeze fires.

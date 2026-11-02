# G57 — THE BLEND LENGTH: HOW LONG A FIGHT GAME'S CROSSFADE IS, AND WHEN IT IS ZERO

Owner: grok (Expert mode). Task: `research/TASK_G57.md`.
**Answered in an earlier session and never collected.** Found on 2026-09-13 in the Grok
chat "Short Fight Blends: 0.2s Strikes, Zero Snap" (Expert, "Worked for 57s", 127
sources) and filed verbatim in substance by Claude. No new query was spent on it.
Labels are Grok's own: DOCUMENTED / INFERENCE / NOT FOUND.

## THE ONE NUMBER

**0.10 s — INFERENCE.** The first number to try on a 0.7–1.2 s strike that fires every
~1.1 s. Grounded in: the animation-graph practice of "six or seven frames, 0.2–0.3 s"
as a typical locomotion transition; combat montages that drop blend-in to 0–0.10 s so
the strike is not eaten; and Mizuguchi/EA's warning that a long blend turns a kick
shallow. At 60 fps it is 6 frames — about 14% of a 0.700 s clip and less than half of
the 0.233 s readable land.

**The cheap stack Grok recommends for this game (INFERENCE):** freeze the outgoing pose,
fade 0.10 s into the incoming clip started on a pose-similar frame if one can be found
by sampling, and snap to 0 on the knockdown.

## 1. What shipped games actually use

**NOT FOUND** — no published blend-in/out in seconds or frames for Street Fighter,
Tekken, Soulcalibur, Virtua Fighter or Mortal Kombat combat clips. Those titles treat
attacks, hitstun and knockdowns as frame-authored states with cancels: the cut is the
product. Engine docs, GDC talks and post-mortems do not turn up a Capcom/Namco/Sega number.

Documented figures from adjacent shipped or engine practice:

| Source | Number | What it is |
| --- | --- | --- |
| Mizuguchi, Buchanan, Calvert — *Data driven motion transitions*, Eurographics 2001 (EA Canada) | 10 frames @ 30 fps = 0.33 s as a starting point; 5 frames (0.17 s) "discontinuous for most cases"; 20 frames (0.67 s) "generally more than enough" | General interactive-character transitions, not fighting-game strikes. The same paper: a long blend makes "an exuberant kick" shallow. |
| Wang & Bodenheimer, SCA 2004 | Cite Mizuguchi's 0.33 s; their measured optima on walk/run data were 5–35 frames (~0.17–1.17 s @ 30 fps), none clustered on 10 | Research, locomotion. |
| Rose et al. / Pullen & Bregler (cited in that paper) | 0.3–0.8 s and 0.2–0.8 s | Operator-chosen research blends. |
| Unreal Engine 5 transition docs (inertialization) | Keep the duration short, preferably < 0.4 s; do not inertialize when poses are extremely different | Engine rule shipped in UE, used in Gears-style combat. |
| Unity `Animation.CrossFade` | Default fade 0.3 s | Engine default, locomotion-oriented. |
| Gabor Szauer, *Hands-On C++ Game Animation Programming* | "Usually short — a quarter of a second or less" | Textbook, general characters. |
| Animation-graph talk (state transitions) | "Relatively short. Six, seven frames usually. 0.2 to 0.3 seconds" | Production graph practice. Six frames @ 60 fps = 0.10 s. |
| Spine runtime guidance | Default mix 0.2–0.5 s; attacks ~0.1 s; walk ~0.3 s | 2D skeletal, not a 3D fighter, but the attack-vs-idle split is explicit. |
| s&box / Source-like sequence fades | Idle 0.25 / walk 0.20 / run 0.15; hit-react 0.05 s in, 0.20 s out; "defaults around 0.2 s if you don't need per-clip tuning" | A documented per-clip table. |
| UE combat-montage practice | Attack blend-in 0 s, blend-out 0.2 s so the strike is not "shy"; a 0.25 s blend-in on a fast spin "skips over the spin", cut to 0.1 s; blend-out to idle commonly 0.2–0.3 s | Tutorials and asset defaults, not a AAA post-mortem, but the numbers people actually type onto attack montages. |
| UFC Undisputed 2010 (THQ / Yuke's, Kendall) | Guard → half-guard 30 frames @ 60 fps = 0.50 s; a 90-frame (1.5 s) pass cut to 60 frames (1.0 s); "15–35 frames" are the gameplay-necessary frames of a position-change clip, not a crossfade; punches were allowed to overlap instead of waiting for the retract | MMA sim. Useful for clip length, not blend length. |

By destination, where the sources distinguish:
- **Into a strike:** shortest, 0–0.10 s. Documented as 0 so the attack "plays right away".
- **Into a hit reaction:** very short in (0.05 s in the one table that publishes it), because
  the flinch must read on the first frame. Fighting games more often RESTART the hit clip
  than blend into it.
- **Into idle/stance:** longest of the three; 0.20–0.30 s is the engine-default cluster.

## 2. The penalty for blending too long on a short clip

**DOCUMENTED (Mizuguchi 2001):** a longer blend gives a smoother join and a watered-down
target — their example is exactly a kick going shallow. If poses and tempo already match,
the blend can be 0; if they do not, it needs more time, at the cost of the incoming pose.

On a 0.700 s clip whose readable land is 0.233 s:
- A **0.33 s** blend (EA's "good start") is 47% of the clip and 1.4x the readable moment:
  the kick never exists as authored. That is the mushy/floaty failure the paper names.
- A **0.20 s** blend is 86% of the readable window: the land is still being averaged with
  the outgoing pose when it happens.
- A **0.10 s** blend leaves ~0.13 s of unblended readable after a linear fade — enough to see
  the kick, not enough to hide a hard pose mismatch.

**Rule: a FIXED duration, not a percentage of the incoming clip.** DOCUMENTED (a Unity
animation-engine discussion by a working tech-animation director): a normalised
blend-as-%-of-clip has had no production use case in 25 years. Combat wants the same
snappy entry on a 0.7 s kick and a 1.2 s kick; a percentage would smear the short clip and
leave the long one popping.

**INFERENCE, the failure threshold:** mush starts when the blend approaches the time to the
readable pose — ~0.15–0.20 s on this clip. Above that the land is a weighted average, not a
kick. Grok declines to invent a sharper fraction: pick 0.10 s and look at it.

## 3. When the blend should be zero

**DOCUMENTED:**
- An incoming attack that must read on frame 1 — UE combat setup: blend-in 0, blend-out
  0.2 s, because a non-zero blend-in makes the strike look timid.
- Re-entry into the same hit reaction — Killer Instinct / Street Fighter restart the hit clip
  from the beginning on another hit. That is a cancel, not a crossfade.
- Pose and tempo already match (Mizuguchi: the blend can be 0).
- A jump out of a run where a blend would suck the feet to centre — one published
  implementation simply switched with no blend.
- Unreal inertialization: do not inertialize across extremely different poses — the "this
  is a different action" case.

**INFERENCE from observable fighting-game practice (not a published blend-time memo):**
traditional fighters snap into knockdown, hard knockdown, crumple, wall-splat, throw tech and
wake-up — states that own the clock. Smash switches among discrete flinch / fly / knockdown
clips by knockback thresholds; it does not ease from a standing punch into a knockdown. The
player must not wonder whether the body is still fighting. **Our knockdown set piece is that
class of beat.**

**NOT FOUND:** no Capcom/Namco/Harada/Sakurai post-mortem saying "knockdown blend = 0 s". The
practice is still a hard state change: treat snap-into-knockdown as standard, not as an
experiment. Also zero or near-zero: counter-hit reactions, the first frame of a named
cinematic beat, and any cancel window whose frame data is the game.

## 4. Uniform or per-animation

**INFERENCE, with documented cover.** One global number is defensible and is how engines
ship: Unity's 0.3 s default, Spine's default mix, s&box's "~0.2 s if you don't need per-clip
tuning", Mizuguchi's single 10-frame start — all uniform first.

What the uniform version costs at this cadence (a clip every 1.1 s, strikes 0.7–1.2 s):
- **Strike → strike:** 0.10 s hides small pose error. A large one (opposite-leg support, torso
  twisted the other way) still pops for a frame. That is the 20% a table would buy.
- **Strike → idle:** 0.10 s is a bit abrupt — readable, not pretty. Idle tolerates
  0.20–0.25 s, and it will be felt on stance returns.
- **Hit-react / knockdown:** 0.10 s is already too long if the beat must be unambiguous. These
  two destinations are the only ones worth a second number.

**Honest split if only one exception is ever added: 0.10 s default, 0 s into a knockdown
(and into a fresh hit reaction).** That is most of the benefit of a table without the table.
Wang & Bodenheimer measured that a single 0.33 s was not optimal even across walk/run pairs
(optima 5–35 frames) — so uniform is not "correct", it is "80% and shippable", and their
result is the cost statement.

## 5. What else makes two clips read as one movement

Assumption given to Grok: we can play, window and time-scale a clip, and cannot author new
animation.

**Cheap — doable with the clips we own:**
- **Incoming start frame.** Mizuguchi: do not always start the target at frame 0; pick an
  interior frame whose support leg matches. The wrong support leg reads as a hop. The
  highest-leverage lever after blend duration.
- **Frozen outgoing pose** (Jason Gregory, *Game Engine Architecture*): stop the outgoing
  clip's clock and fade from that held pose into the incoming clip. The correct choice when
  the two clips are unrelated — which every strike-to-strike cut here is. Smooth dual-playing
  fades are for synced loops.
- **Overlap in time, not in pose.** Start the next clip before the current one would have
  ended (we already fire every ~1.1 s into 0.7–1.2 s of content); the blend lives in that
  overlap.
- **Time-scale a few percent** on the incoming clip so its first readable pose lands on the
  same wall-clock tick as the old clip's exit. It invents no frames.
- **Hit-stop / hold 1–4 frames at the contact pose.** Makes the land read even if the blend
  ate the wind-up. Standard combat juice, not a blend.
- **Phase-match** only when both clips are stance/idle cycles — useless strike-to-strike.

**Needs an animation pipeline we do not have:**
- Authored lead-in / header-trailer frames (one 2003 write-up used a second of header and
  trailer per transitional clip so blends had room).
- Pose matching / motion matching (a feature database and a search).
- Additive layers / difference poses (an authored reference pose).
- Inertialization / dead blending (Bollo, *Gears of War 4*, GDC 2018): a post-process decay of
  the pose offset so only the incoming clip is evaluated. An engine feature — keep it short
  (< 0.4 s), not across wildly different poses; cheap if the engine has it, not something to
  fake with a lerp.
- Per-bone blend profiles (legs longer, spine/arms snap) — needs a bone mask.
- Sync markers / matching events / registration curves (Kovar & Gleicher) — authored markers.

## Where it already went (Claude, 2026-09-13)

**The answer was USED before it was filed.** R120 (`64210cd`, 2026-09-12) set
`FightStagePlayer.BLEND_S := 0.10` as `AnimationPlayer.playback_default_blend_time`, citing
this study and its INFERENCE label; before that every clip was cut in cold. R120 kept it
uniform on purpose and left the knockdown snap (section 3) undecided because we own no
knockdown clip to watch, and it records that 0.10 s itself is not visually confirmed — only
that the blend mechanism reaches playback (an A/B at 0.60 s measurably mushes the picture).
Only this file was missing, which is why the board still showed G57 open.

For S4a (why the bought clips look bad): the cut is no longer cold, so a bad-looking clip is
not explained by a missing crossfade alone. Judge one clip played in isolation before judging
a sequence, so the retarget and the cut are never blamed for each other. Section 5's other
cheap levers — a frozen outgoing pose, a pose-matched start frame, a few frames of hit-stop —
are the next candidates if the sequence is what reads badly.

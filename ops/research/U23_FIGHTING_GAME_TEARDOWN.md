# U23 — What a real fighting game models, and what it refuses to

Owner: Cursor. Source of the *model*: Tekken 7's publicly documented frame
system. Source of *our* gaps: `R84_DIGEST.md`, `RingSpace.gd`, and the named
window of `FightRealtime.gd`. Claims are labelled `verified locally`,
`documented`, or `impression`.

The question this file exists to answer: **what should a hit do to the next two
seconds of a fight?**

---

## Source honesty

**Tekken 7 is not on this host.** The documented install
(`D:/SteamLibrary/steamapps/common/TEKKEN 7/`) is a Windows Steam path. A
filesystem search for `tkdata.bin` and any `TEKKEN*` directory returned
nothing. `verified locally`

**`tkdata.bin`, one pass.** Absent here, so there is nothing to hex. On a
machine that has the file: it is a 290 MB unnamed blob. "It is opaque" is the
finding this task asked for if a cheap string/magic pass yields no move table.
Do not spend a second pass. `impression` on contents; `verified locally` on
absence.

**The `.pak` files were not touched.** They are UE4 archives (~55 GB). Unpacking
them needs an AES key, takes hours, and yields character meshes we cannot ship.
Ripped art never enters the repo. The model is public; the paks are not the
work.

The named `FightRealtime.gd` window (`sed -n '168,240p'`) is `begin()`, not the
tick loop — the file has grown past the 909-line anchor. That window still
shows the facts this teardown needs: `DEFAULT_HZ`, integer `tick`, per-subsystem
RNG streams, and a fighter dict with no recovery or stun field. `verified locally`

---

## 1. The state machine

A Tekken fighter is a state machine. A FightCamp fighter, after R84, is a bag
of numbers that is equally able every tick.

Tekken states a FightCamp fighter cannot occupy, and whether they mean anything
in a **watched, non-player-controlled** bout:

| State | What it is | Watched bout? |
| --- | --- | --- |
| Startup | Attack committed, not yet active. Cannot guard. `documented` (Wavu, *Frame*) | **Yes.** The viewer sees the punch coming. |
| Active | The frames the attack can connect. Usually 1. `documented` | **Yes**, but at 20 Hz this collapses to "this tick is contact." |
| Recovery | Attack spent; cannot act or guard until it ends. `documented` | **Yes.** This is how a punch can be punished. |
| Hitstun | Defender cannot act. Usually longer than blockstun. `documented` | **Yes. This is the whole gap.** |
| Blockstun | Same, on a guarded hit. `documented` | **No as input-block.** We will never have blocking on a button. Guard as a *contact quality* (U20's `guard_region`) is a different channel and is not this. |
| Counter-hit | Hit landed while the opponent was attacking. Extra stun or a launch. `documented` | **Yes, as a consequence of commitment** — not as a named CH flag. If A is in recovery and B lands, that *is* a counter. |
| Knockdown (grounded) | Down, with a get-up menu: tech roll, stay down, rising kicks. Seconds, not a frame. `documented` (Wavu, *Wake-up*) | **Yes, as time on the count.** The get-up *mixup* (3 vs 4, stay down) is player input — refuse the menu, keep the seconds. |
| Juggle / bound / screw | Airborne combo state. `documented` | **No.** Arcade. A boxing knockdown is a man on the canvas, not a 12-hit air string. |
| Wall splat / wall bounce / wall crush | Wall converts a hit into a longer plus-state or a combo. `documented` (Wavu, *Attack*; T7 S5 patch notes) | **No as splat.** The *idea* — trapped, extra follow-up window — belongs to our CORNER. See §5. |
| Throw-break window | ~20 frames to mash the right break. `documented` (player reports; i10–i12 throws) | **No.** There is no button. A later grappling scramble is not this window. |
| Sidestep / backdash / crouch / jump | Movement states that beat tracking or highs. `documented` | **Sidestep as a button: no.** Lateral cutting-off of the ring: yes, and we already have a 2-D floor. |
| Rage / power crush | Low-HP damage buff; armour through a hit. `documented` (Tekken Wiki, *Rage*) | **No.** Comeback meters and armour are fighter-game score, not a sports bout. |

FightCamp after R84 has `shocked` (hurt), `knockdown`, and `flash_knockdown` as
*event vocabulary*. None of them is a state that occupies the next tick.
`verified locally` from `R84_DIGEST.md`: a man who has just been cracked is, on
the next tick, exactly as capable as before.

---

## 2. Startup / active / recovery

Tekken runs at 60 fps. A frame is 16.67 ms. `documented` (Wavu, *Frame*)

A generic jab (Jin `1`, the standard i10): **10f startup, total 27, recovery
17, +1 on block, +8 on hit.** `documented` (geppopotamus Jin data; Wavu generic
`1`: `i10 t27 r17 +1 +8`). The attacker cannot guard for any of those 27
frames.

FightCamp is 20 Hz. One tick is 50 ms = **three Tekken frames.** An i10 jab is
three or four ticks of windup; seventeen recovery frames are about six ticks;
+8 on hit is about three ticks of advantage. You cannot import 60 fps frame
data onto this clock. You can import the *shape*:

**Cheapest honest version, nobody pressing a button:**

1. When a fighter originates an impact attempt, he enters `committed` for N
   ticks and cannot originate another until it expires.
2. N is longer on a miss than on a land (whiff is the punishable thing).
3. The victim, if hit, enters `hurt` for M ticks and cannot originate an
   impact either.

That is the whole of startup/active/recovery on a 20 Hz spectator engine. No
per-move frame table. No blockstun. The current impact subsystem running every
2 ticks with each attempt independent of the last is the opposite of this:
812 impacts per 3×5 (`verified locally`, R84) because nothing ever has to
finish.

Worked numbers, not a spec to copy blindly:

| Band | Attacker recovery | Victim hurt | Wall-clock |
| --- | --- | --- | --- |
| Jab / force ~0.3 | 4–6 ticks | 6–10 ticks (~+8) | 0.3–0.5 s |
| Shot / force ~0.6 | 8–12 ticks | 12–20 ticks | 0.6–1.0 s |
| Bomb / `shocked` | 10–16 ticks | 20–40 ticks | 1.0–2.0 s |
| Miss of the same | +2–4 ticks on the attacker only | — | the opening |

A jab's +8 is ~0.4 s of the victim being unable to fire. That is already "the
next half-second." A shocked bomb is the next two seconds. `documented` on the
jab math; `impression` on the 20 Hz bands.

---

## 3. Hit reaction and stun

**How Tekken scales it.** It mostly does not scale with "how flush." Each move
authors its own hitstun, blockstun, and on-hit state (stand, crumple, KND,
launch). Counter-hit is a second authored row, not a multiplier. Clean hit is a
*proximity* flag on named moves (Paul's Deathfist at point-blank), usually
extra damage, not a universal flushness curve. `documented` (Wavu *Attack*;
Steam "what is clean hit"; Jin CH column often identical to NH on the jab)

**How long is a fighter compromised.**

- Light (jab +8): ~25 frames of hitstun from contact ≈ **0.4 s**. `documented`
  (recovery 17 + advantage 8).
- Typical mid that's +12 to +17 on hit: **0.5–0.8 s**. `documented` as frame
  advantage; conversion is arithmetic.
- Crumble / CH stun: long enough to launch, on the order of **1 s**.
  `documented` as a property (e.g. Kazuya CH crumple +13), duration `impression`.
- Launch / juggle: **2–8 s** of airborne. `impression` on length; `documented`
  that the state exists. Refuse the juggle; the useful fact is "he cannot act
  for seconds."
- Knockdown on the ground: a get-up situation, not a tick. `documented`.

**What to steal.** We already have `force` 0.0–1.0 and `shocked`. R84 settled
that `shocked` is HURT, not a knockdown — 5.43 shocks a fight vs 0.68
knockdowns. `verified locally`. The flag currently changes nothing about the
next tick. That is the defect.

Map `force` (and `shocked`) onto **hurt ticks**, not onto a 60 fps table:

- Ordinary connect: hurt ticks from `force`, in the jab-to-shot band above.
- `shocked`: floor at ~20 ticks (1.0 s) so the viewer sees a man in trouble.
- `contact` (clean vs not) can scale M the way Tekken's clean hit scales
  damage — we already emit it. Do not invent a second flushness axis.
- The attacker is still in his own recovery, so the *window* is M minus his
  remaining recovery. If M is larger, he gets a free follow-up. That is frame
  advantage without frames, and it is what a combo *is* in a spectator sport:
  a man who cannot return fire.

This is the single most likely thing to be worth stealing. Everything else in
this file is in service of it.

---

## 4. The fatigue question

**Tekken has no stamina system.** A round-three fighter is as fresh as a
round-one fighter. The only resource is the health bar. Rage lights at roughly
20% HP and *buffs* the losing man. `documented` (Tekken Wiki *Health*, *Rage*;
no stamina meter exists in T7 HUD descriptions). Not `verified locally` — the
game is not installed — but the documentation is unambiguous and a second
source (StrategyWiki T7 overview) lists Rage Art and Power Crush, not a gas
tank.

**Why that is right for Tekken.** Best-of-three rounds of about a minute.
Identity is juggle, wall combo, i10 punish. Stamina would cut the 10-hit air
string that *is* the game. Harada has said on record that Tekken aims at manga
physics ("wouldn't it be nice"), not ring realism. `documented` (Gamasutra /
Game Developer Harada interview). Freshness is the condition their skill
expression needs.

**Why that is wrong for us.** We are a watched sports bout. The story of rounds
two and three *is* fatigue. The player coaches; he does not mash. We already
spent G30/R84 on a real tank: a 3×5 finishes at stamina 57.7–65.7, "tired but
standing." `verified locally` (R84). Importing Tekken's freshness would delete
that on purpose.

### What the boxing/MMA sims actually degrade

| Game | Model | Output | Defence / accuracy |
| --- | --- | --- | --- |
| **Fight Night Champion** | Current stamina (yellow, recovers in-round) vs maximum/endurance (black, recovers between rounds, and only as much as the last round's work allows). Regional anaerobic fatigue on left arm, right arm, torso, legs. `documented` (EA *Controls Tutorial*; GameRant damage/endurance trailer; IGN stamina tips) | Power drops. `documented` (Title Update #2: "weaker") | **Yes, defence.** Low stamina: more susceptible to damage; slower to raise a block; lean/agility degrades. `documented` (EA Title Update #2, 2011; TheSixthAxis review: stamina affects how quickly you raise your block; FNC manual: stamina affects hit hardness, movement speed, and recovery; leaning agility falls with stamina). Accuracy as miss-chance is not stated; "less effective" is the word they use. |
| **EA UFC 3** (the three-layer tank) | Current stamina + long-term stamina + a per-punch **stamina floor** (straights cannot dump you as far as hooks; floors fall toward zero as long-term drains). Between rounds you may draw up to 50% of a fight-start reserve set by endurance. `documented` (Operation Sports, Geoff Harrower, 2017) | Damage "reduced greatly" as current stamina falls. `documented` | **Yes, defence.** Low stamina raises *vulnerability* (up to 6× damage on a vulnerable region). Empty bar: grey-flash state, single slow strikes, exceptionally susceptible. `documented` (same Harrower write-up; ScreenRant UFC 3 guide). Not an accuracy roll — you still throw; you get hurt more and hit softer. |
| **EA UFC 5** | Stamina still gates output; missed/blocked/evaded strikes cost more. `documented` (UFC 5 patch notes). Stun icons (head/body/leg) and vision/breathing penalties come from *damage*, not from the gas tank. `documented` (EA deep dive / TheSixthAxis) | Yes | Vision penalty increases hurt taken to that side; breathing penalty slows stamina recovery. Defence-ish, but it is injury, not fatigue. |
| **Undisputed** | Short-term and long-term stamina; missed punches cost more; between-round recovery tied to last-round work. `documented` (Steam patch 1.0). Gassed/dazed: more time *between* punches rather than slowed animations. `documented` (same). Punch damage rebalanced off current stamina; flash KO chance rises when the opponent is low on stamina. `documented` (patch 1.4.4) | Yes | Dazed is a hit-reaction (tracking, "punches would miss dazed opponents" was a *bug they fixed*). Tired accuracy is "cannot throw as often," not a miss roll. |

**Which of them degrades accuracy and defence, not just output.** Fight Night
is the landmark on **defence** (block-raise speed, toughness, susceptibility).
UFC 3 is the landmark on **vulnerability while gassed**. None of the four
publishes a clean "tired men miss more" accuracy curve I can cite; Undisputed
and UFC 3 both spend the tired man by *rate and power*. If we want tired
defence, steal Fight Night's toughness/block-raise and UFC 3's vulnerability
multiplier — not a new miss-chance.

G30 already spends the tank. G31 (`FatigueCurve`, landed on the same master
this task branched from) already authors the Fight Night half as *multipliers*:
technique and defence go first, power holds, output collapses hardest. This
teardown does not re-propose that curve. What is still missing is the *hit*
half of tiredness: a shocked tired man is the one who stays hurt longer and
goes down — Undisputed now ties flash KO to low stamina the same way.
`verified locally` that G31's commit message states that ordering; the file
itself was not opened.

---

## 5. Positioning

`RingSpace` is a real floor: `place_of` returns `CENTRE` / `ROPES` / `CORNER`
off both edges vs a 0.75 m margin; `pressure` is how close to the ropes you
already are. `verified locally` (`RingSpace.gd`).

Tekken's wall is not a tag. It is a **state converter**:

- **Wall splat** — the hit sticks him to the wall; a wall combo is now
  guaranteed. `documented`
- **Wall bounce** (T7 Season 2) — he rebounds into a juggle. `documented`
- **Wall crush** — extra frame advantage at the wall, never a guaranteed
  follow-up, plus chip. `documented` (T7 v5.00 notes; Wavu)
- **Ring-out** on some stages. `documented`
- **Sidestep** into a wall fails; the trapped man has fewer exits. `impression`
  as play-feel; the splat/crush facts do not need it.

What Tekken gets from the wall that we are not getting from the corner: **time
and a follow-up window.** Splat is "you may now hit him for a second while he
cannot leave." Crush is "your next turn comes sooner." That is identical in
kind to hitstun, keyed off place.

What we should *not* take: juggle off the ropes, balcony breaks, ring-out as a
win. Boxing's corner already has a rule for a man who cannot leave (the
referee, the ropes, the count). The honest steal is: when `place_of == CORNER`
(and less so `ROPES`), hurt ticks last longer and the trapped man steps out
slower. `pressure` is already the continuous version of that knob.
`verified locally` that the knob exists and currently does nothing to a hit.

---

## What FightCamp should take, and what it should refuse

1. **TAKE.** `shocked` (and ordinary `force`) must occupy the next 0.4–2.0 s as
   a hurt state during which the victim cannot originate an impact — jab-scale
   at the low end, shocked-scale at the high end.
2. **TAKE.** Every impact attempt commits the attacker for a handful of ticks,
   longer on a miss, so the other man can fire into an opening. Independent
   every-2-tick swings are why nothing can be punished.
3. **TAKE.** A knockdown occupies clock time (the count). R84 already rolls
   flash vs KO; play those seconds instead of standing him up on the same tick.
4. **REFUSE.** Tekken's juggle, wall-splat, rage, power crush, throw-break
   window, and input-block. They are a player's game. The coach does not press
   1+2.
5. **REFUSE.** Tekken's no-stamina physics, and a second fatigue curve.
   G30's tank plus G31's defence-first multipliers are the Fight Night steal.
   Do not delete fatigue because juggles need a full bar; do not re-author
   G31. The remaining join is hitstun × fatigue (hurt lasts longer when the
   tank is empty), which is R86's to wire, not a new module.

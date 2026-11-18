# GUARDDMG1 V2 — Critic review (Goose, sports management-sim designer)

Read: the full critic pack (CRITIC_PACK.md, CRITIC_ACCESS.md), the code's current guard behaviour
(section 0 of the design map), and the design map at the end of the brief. No other critic's answer
read before writing this.

## Scores

SCORE depth=5 general=6 play=5

---

## DEPTH — 5/10

The design has six rules, five player-decision contexts and a menu wiring table. The skeleton of a
good resource-management defence system is here: guard as a depleting shield, two defence styles
with different costs, corner calls that shift between them, training that invests in either side.

What is missing:

1. **No guard posture.** Real boxing has a high guard (shell, earmuffs) and a low guard (hands at
   cheek level, ready to parry or counter). The design treats "guard" as one number. A high guard
   absorbs head shots better but costs more shoulder; a low guard invites head damage but keeps the
   body ready to absorb and the counter faster. Without posture, the player has no identity choice
   for their boxer's defensive style — every boxer covers the same way.

2. **No combination vs single-shot distinction.** In real boxing the danger of a broken guard is
   not one punch getting through — it is the third and fourth punch of a combination finding gaps
   the first punch opened. The design applies the same "share through" to every blocked punch
   regardless of whether it is punch one of a four-shot combo or a lone jab. This flattens the
   mechanic: a pressure fighter throwing 60 punches a round and a counter-puncher throwing 20 have
   the same guard-wear-per-block ratio. The design needs a combo multiplier (punch 3+ through a
   tiring guard lets more through than punch 1).

3. **No body-shot guard interaction.** Rule 2 says a blocked body punch does "rib damage and energy"
   through the guard. But a boxer can drop their guard to protect the body (elbows in, torso twist)
   at the cost of head exposure. The design has no body-specific guard posture. The existing body
   map (head, eyes, nose, left ribs, right ribs) is not mentioned anywhere in the guard rules — how
   does guard damage distribute across those zones? Is it random? Does a blocked hook to the head
   always damage the head zone, or can it leak to the eyes?

4. **No clinch as a guard emergency valve.** When a real boxer's guard is breaking, they clinch.
   The design has no clinch mechanic. The corner call "Go to the arms" is the closest thing, but it
   is an offensive tactic (attack the guard), not a defensive emergency. A boxer with a broken guard
   and no clinch option has literally no escape until the bell — the design forces them to eat
   punches for 30 seconds. That is not a choice; it is a sentence.

5. **Guard recovery is undefined.** "Comes back slowly while the boxer is not being hit" — how
   slow? 1 point per exchange? 5? Per second of the round? Without a rate, the player cannot plan.
   The corner recovery (15 points) is concrete, but the in-round recovery is a blank. This is the
   single most important number in the system and it is missing.

6. **No weight-class or style modifier.** A heavyweight's punch carries far more force through a
   guard than a flyweight's. The design scales by "the puncher's power" but does not say whether
   the guard's capacity (100 points) scales with the defender's weight class or durability. A
   bantamweight and a heavyweight both have 100 guard points — that cannot be right.

7. **No feint interaction.** Feints are a core part of the playbook. Does a feint cost guard? In
   real boxing, a feint makes a boxer flinch and raise their guard, wasting energy. The design is
   silent.

## GENERAL DESIGN — 6/10

The core idea is correct: blocking must not be free. The current game has blocking as a zero-cost
action, which means the optimal strategy against any opponent is to hold the guard and wait. The
design fixes that. The two-defence tradeoff (cover up vs. move) is the best single idea in the
document — it creates a real choice with real costs on both sides.

What works:

- **The cover-vs-move tradeoff** is elegant. Cover saves legs, wears guard, leaks damage. Move
  saves guard, wears legs, leaks nothing but costs energy. The crossover point must land inside a
  normal fight; the design flags this risk but does not prove it.
- **Corner calls** give the player three meaningful between-round decisions. "Hands up" / "Move,
  don't cover" / "Go to the arms" each change the next round's dynamics.
- **The opponent file reads** ("covers up under pressure", "heavy hands") give the player
  information to act on before the fight.
- **The menu wiring table** is thorough — every screen the mechanic touches is named and linked to
  a rule.

What does not work:

1. **The through-guard percentages are backwards for realism.** Jab 10%, power 20%, big 30% through
   a fresh guard. In real boxing, a well-held guard absorbs almost all of a jab's impact to the
   head — 10% is plausible. But a big shot (overhand right, looping hook) on a fresh guard should
   NOT let 30% through. A good guard is specifically designed to stop big shots. The percentage
   should be lower for big shots on a fresh guard and higher for jabs that accumulate. As written,
   the design makes the guard less effective against the punch it is best at stopping.

2. **The broken-guard rule contradicts itself.** Rule 4 says under 20 guard, "one blocked punch in
   three counts as landed." Rule 5 says "a block never scores for the judges." These conflict. If a
   blocked punch "counts as landed," does it score? The design needs to say clearly: it causes
   damage and can cause a hurt moment, but the judges still see it as a blocked punch (no exchange
   score). Or it counts as landed for everything, including judges. Pick one.

3. **Guard points (100) and punch costs (1/3/5) create a math problem, not a feel problem.** 100
   divided by an average cost of ~2.5 per block = 40 blocks to break a guard. At 60 punches a
   round with half blocked, that is 30 blocked punches a round — the guard breaks in round 1 or 2
   of every fight against a pressure fighter. Against a counter-puncher throwing 20 a round with a
   third blocked, it takes 15 rounds. The spread is too wide. The design needs to say what a
   "normal" fight's guard trajectory looks like, round by round, for at least two styles.

4. **The guard bar doing double duty (tired shoulders AND shield points) is confusing.** Section 0
   says the guard bar today shows tired shoulders. Rule 3 says it is now guard points, and tired
   shoulders "still lower it." How? Is it a subtraction? A multiplier? If shoulders are at 50%,
   does the guard bar start at 50 instead of 100? Or does it drain faster? This is a critical
   interaction and it is not specified.

5. **No mention of how guard interacts with the existing exchange system.** The game settles rounds
   as exchanges. Does a blocked punch that leaks damage still lose the exchange? Does a "counted as
   landed" punch win the exchange? The design adds damage but does not say how it changes the
   exchange winner — which is the fight's core scoring loop.

6. **"Go to the arms" is an offensive tactic in a defensive mechanic.** This corner call tells the
   player to attack the opponent's guard. That is a fight-plan decision, not a guard decision. It
   belongs in the offensive playbook, not bolted onto the guard system. If it stays, it needs its
   own section with its own costs (your fighter throws more blocked punches, wearing their own
   guard and arms).

## PLAY — 5/10

I played the mechanic in my head for one three-round amateur bout and one six-round pro bout.

### Three-round amateur (my fighter: 4-0, footwork-heavy, Defence 55)

**Round 1.** Fight plan: "Move your head." Opponent: pressure fighter, 2-1, covers up. I move,
slip, pull. His guard does not wear because I am not blocking. My legs start to tick down. I land
more because he walks into shots. Guard bar: 100/100 (untouched). Legs: 90. Boring — I have no
decision to make. Moving is just better.

**Round 2.** He is closer now, I cannot slip everything. I block three jabs and a hook. Guard: 92.
Leak damage: trivial. I go back to moving. Guard: 92. Legs: 78. The choice is still obvious.

**Round 3.** Legs at 65. Slips start failing (the design says they fail more when legs are gone).
I am forced to cover. Guard drops to 80 in the round. Leak damage: still trivial because his
punches are amateur (low power). Fight goes to cards. I win on the exchanges I landed in rounds
1-2. The guard mechanic did nothing that changed a decision.

**Verdict for amateur:** The guard mechanic is decorative. Leak damage is too small against amateur
power to matter. The player's optimal strategy is "move until legs run out, then cover, guard
barely drops, fight goes to cards." The design's own open question 4 is the answer: in a 3-round
amateur bout, the guard does not break and the leak does not hurt. The mechanic needs an
amateur-specific rule (e.g. guard breaks faster because amateurs hold their guard wrong, or leak
damage is higher because amateurs leave gaps).

### Six-round pro (my fighter: 8-2, balanced, Defence 70, vs pressure fighter 10-1, power 65)

**Round 1.** Fight plan: "Cover up early, move late." I block his opening barrage. Guard: 85. Leak:
4 head damage. Corner: "Move, don't cover." Round 2 I slip and pull. Guard: 85. Legs: 82.

**Round 3.** He adjusts, cuts the ring. I have to block more. Guard: 60. Leak: 8 head damage.
Corner: "Hands up." Guard recovery: +20 (with good cutman). Guard: 80.

**Round 4.** He is throwing combos now. Guard: 50 (shares double at 50). Leak jumps: 12 damage in
the round. This is the first round where I felt a real decision — do I keep covering and eat 12 a
round, or switch to moving and eat leg cost? I switch. Legs: 55. Guard: 50 (no recovery because I
am not blocking).

**Round 5.** Legs at 40. Slips failing. I am forced back to covering. Guard drops to 30, then 20.
BROKEN. Half of everything through. He lands a big shot through the guard — hurt moment. I clinch
— wait, I cannot clinch, there is no clinch. I eat three more punches. Bell.

**Round 6.** Guard at 20. Corner call does not matter — I have to survive. I cover, eat damage,
try to land enough to win on exchanges from rounds 1-3. Guard: 5. Fight goes to cards. I lose.

**Verdict for pro:** Rounds 4-5 are genuinely tense. The guard breaking is dramatic. But rounds 1-3
are a slow, predictable decline — the player can see the trajectory and knows the guard will break
in round 5 no matter what they do. There is no recovery, no comeback, no surprise. The "Hands up"
corner call delays the inevitable by one round. The player's decisions in rounds 1-3 are: "I know
the guard will break, I am just choosing when." That is not play; that is watching a timer.

### Where it was boring
- Amateur bouts: the mechanic does not engage. Leak damage is trivial, the guard does not break,
  the player has no reason to think about it.
- Pro rounds 1-3: the decline is linear and predictable. No moment of "can I recover?" because
  recovery is too slow to matter.

### Where the choice was obvious
- Moving is always better than covering when legs are fresh (no leak, no guard wear). The design
  needs covering to be better in at least one common situation (e.g. against a wild swinger whose
  punches miss often — covering catches the misses safely, moving wastes energy on slips that have
  nothing to dodge).

### Where the player had nothing to do
- Once the guard is broken (pro round 5-6), the player has zero decisions. They cannot clinch,
  they cannot change posture, they cannot retreat (the design has no "backpedal and survive"
  option). They just eat punches until the bell. This is the worst 90 seconds of the fight and the
  player is a spectator.

---

## Missing options (what the screen offers that it should not, and what it lacks)

### Useless as designed
- **"Go to the arms" corner call** — this is an offensive plan, not a guard decision. It does not
  belong here. Move it to the offensive playbook or remove it.
- **Gloves as a gear modifier** — "bigger gloves let less through and hit softer" is a one-line
  afterthought. If gloves matter, they need their own design (weight classes, glove sizes, a
  choice the player makes). As written, this is a line in the design that will never be built.

### Missing entirely
- **A clinch option** when the guard is broken (the player's only emergency escape).
- **A guard posture choice** in the fight plan (high guard / low guard / peek-a-boo) that changes
  what the guard is good at.
- **A combo multiplier** so that pressure fighters break guards faster and counter-punchers do not.
- **A body-shot guard posture** (elbows in, torso twist) that trades head protection for body
  protection.
- **An in-round guard recovery rate** (the single most important missing number).
- **A weight-class guard capacity modifier** (heavyweights need more guard or take more through).
- **A "back off and survive" corner call** for when the guard is broken — trade exchange points
  for guard recovery time.
- **A feint interaction** (does a feint waste the opponent's guard or make them flinch?).

---

## To reach 10/10

Most important first, each specific enough to build:

1. **Define the in-round guard recovery rate.** One number: X guard points per exchange where the
   boxer is not being hit. Test it in the balance harness: a pressure fighter vs a mover, 6 rounds,
   the guard should dip to 40-50 in a hard round and recover to 70+ in a quiet round. Without this
   number, nothing else in the system can be tuned.

2. **Add a clinch as a defensive emergency.** When guard is below 20 (broken), the player can call
   a clinch once per round. It costs 10 legs, stops the action for 5 seconds, guard recovers 10
   points. The referee breaks it after 5 seconds. This gives the broken-guard boxer one active
   decision instead of being a spectator.

3. **Add a combo multiplier to guard wear and leak.** Punches 1-2 of a combination: normal wear
   and leak. Punches 3+: 1.5x wear, 2x leak. This makes pressure fighters dangerous to the guard
   and rewards the player for breaking up the opponent's rhythm. Without it, every blocked punch is
   the same and the mechanic is flat.

4. **Fix the through-guard percentages for realism.** Fresh guard: jab 15%, power 10%, big 8%.
   The guard is best at stopping the punch it is best at stopping (big shots). Jabs accumulate —
   that is their danger. At 50 guard: jab 25%, power 20%, big 15%. At broken (under 20): jab 40%,
   power 35%, big 30%. This inverts the current curve and matches how real boxing works.

5. **Resolve the broken-guard contradiction.** State clearly: a blocked punch on a broken guard
   causes full leak damage and can cause a hurt moment or knockdown, but the judges still score it
   as a blocked punch (no exchange win). Or: it counts as landed for everything. The current
   wording says both. Pick one.

6. **Add guard posture to the fight plan.** Three options: High guard (head leak -20%, body leak
   +20%, guard wear +10% because shoulders burn faster), Low guard (head leak +20%, body leak -20%,
   counter speed +10%), Peek-a-boo (balanced, but slip chance +10% because the head moves more).
   This gives each boxer a defensive identity and makes the opponent file reads more meaningful.

7. **Specify how tired shoulders interact with guard points.** Decision: tired shoulders are a
   multiplier on guard wear rate, not a subtraction from guard points. Shoulders at 50% = guard
   wears 1.5x faster. This keeps the guard bar as a clean number (0-100) and makes shoulder
   endurance training meaningful in two ways (slower wear AND slower shoulder fatigue).

8. **Add an amateur-specific guard rule.** Amateur bouts are 3 rounds x 3 minutes. The guard
   mechanic must matter in that window. Option: amateurs have lower guard discipline (start at 70
   guard instead of 100, or leak percentages are 1.5x because they leave gaps). Or: amateur
   scoring rewards activity so heavily that covering up loses exchanges even without guard damage —
   the player is punished for covering not because the guard breaks but because the judges see a
   passive fighter.

9. **Remove "Go to the arms" from the guard corner calls.** Replace it with "Back off, recover" —
   trade exchanges for 20 guard points back and 15 legs. This is a defensive corner call that fits
   the system. "Go to the arms" belongs in the offensive playbook.

10. **Add a weight-class guard capacity modifier.** Heavyweights: 120 guard points but take 1.3x
   leak. Lightweights: 80 guard points but take 0.8x leak. Middleweights: 100, 1.0x. This makes
    weight class matter in the guard system and prevents a one-size-fits-all balance.

11. **Show a round-by-round guard trajectory for two styles in the design document.** One pressure
   fighter (60 punches/round, 30 blocked) and one counter-puncher (20 punches/round, 6 blocked).
   Show the guard bar, leak damage, and legs for each, round by round, for 6 rounds. Prove that
   the crossover point exists and that neither style is dominant. Without this proof, the design
   is a guess.

12. **Define how guard leak damage distributes across the body map.** A blocked head punch: does
   leak damage go to head, or split between head and eyes? A blocked body punch: ribs or energy or
   both? The existing body map (head, eyes, nose, left ribs, right ribs) needs a clear mapping from
   punch type and guard posture to damage zone. Without it, the body map and the guard system are
   parallel systems that never touch.

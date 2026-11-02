# TASK J13 — THE BODY, THE DIET, AND THE FULL PICTURE (John)

**Status: COMPLETE (2026-09-07).** Delivered:
`research/J13_THE_BODY_THE_DIET_AND_THE_PICTURE.md` plus
`research/CLAUDE_LAND_NOTE_J13.md`. Research only. No `.gd` /
HANDOFF / data writes from John. Claude writes the HANDOFF block and cites
DA*/DB*/DC*.

Model: top tier, effort **high**, Fast off. One session.

**This is every piece of deep research the project currently owes, in one
task** (operator instruction, 2026-09-07). Three areas, one file, one numbered
ruling list per area. You have no repository checkout and need none: everything
the game currently does is stated below.

Deliver:

- `research/J13_THE_BODY_THE_DIET_AND_THE_PICTURE.md`
- `research/CLAUDE_LAND_NOTE_J13.md` (the short one — what binds, what
  reopens, what an implementer must not do)

You never edit `HANDOFF.md`. Claude writes your block.

## How to answer

Same instrument as J1–J12. Every finding is a numbered **D-ruling** — `DA1`,
`DA2`… for area A, `DB1`… for B, `DC1`… for C — written so an implementer can
cite it by number. **If a ruling cannot be written as "the game does X, never
Y", it is research and not a ruling: say so and put it in the discussion.**

Grade every ruling with your J1 vocabulary (evidenced / inferred / authored),
and keep a first-class **§ UNKNOWN** list per area: things that could not be
sourced are a deliverable, not a failure. Naming a number as unsourced is more
valuable here than supplying a plausible one — this project has thrown away
whole systems for being invented, and will again.

End each area with a priority ruling: what to build first, and what to refuse.

---

## AREA A — THE TREATMENT OF BODY PARTS

**This is the standing operator decision of 2026-09-07:** *"The game will model
recovery and healing per BODY PART, realistically. Not a single readiness clock
with an age multiplier on top — a torn hamstring, a broken hand and a
concussion are not the same injury slowed down by the same factor."* Your pass
is the research that stage waits on.

### What the game has today, exactly

- Six regions and nothing else: `head_neck`, `torso_core`, `left_arm`,
  `right_arm`, `left_leg`, `right_leg`.
- Each region is **one integer, 0–100**, called readiness. It is banded for
  display, has a training threshold, an amber threshold and a per-region
  competition threshold.
- Damage is applied by fight and by activity; recovery is applied by activity
  (rest, light work, a recovery facility), a week's flat amount split into
  seven daily slices.
- A forecast exists: weeks until a region is clear to train again.
- **There are no injuries.** No fracture, no tear, no laceration, no
  concussion, no dislocation — nothing is NAMED. A hand broken in round one and
  a bruised thigh are the same number going down and the same number coming
  back up.
- There is exactly ONE medical clock in the game, `medical_hold_until_week`,
  and it is also the amateur suspension.
- Age does NOT scale healing anywhere, deliberately (J12 D1: no sourced rate).
  R54 ships extra CLEARANCE requirements at age and mileage thresholds and
  never longer hold days.
- Where the body was hit is recorded per region as a history ledger.

### What binds you, already established — do not re-derive

- **J12 D1**: per-region recovery rates are UNKNOWN. No source was found.
- **J12 D2**: training-load recovery and injury healing are SEPARATE clocks.
- **J12 D4**: there is no 30/33 age cliff; the deleted cutoffs were wrong in
  shape, not merely unsourced.
- **J12 D5**: years and mileage are both real and NOT interchangeable.
- **J12 D7**: "older is more sore" is not law; the literature conflicts.
- **J12 D8**: return-to-sport ODDS may fall with age while weeks-to-heal stays
  UNKNOWN. Do not conflate them.
- **J12 D9**: concussion hold days are NOT age-scaled in any commission
  rulebook, and a per-region model may not quietly scale them either.

### Answer these

1. **What is actually injured.** For each of the six regions, what are the
   injuries a combat athlete really presents with, at what rough frequency, and
   which of them a management game must distinguish? Name them. This is the
   taxonomy the whole stage rests on and it must be sourced, not imagined.
2. **What treatment IS.** Rest, ice, immobilisation, stitches and glue,
   physiotherapy, injection, surgery, a doctor's clearance, a commission
   suspension. Which of these change the timeline and which only change the
   cost? Which are decisions a manager actually makes, and which happen to them?
3. **The timelines.** Return-to-training and return-to-COMPETITION are
   different dates. Where real published figures exist (mandatory suspensions,
   surgical protocols, concussion return-to-play stages) give them with the
   source. Where they do not, say UNKNOWN and say what the game should key off
   instead.
4. **Who clears a fighter, and on what.** Commission medicals, ringside doctor,
   the gym's own physio — who has the authority to say a fighter may compete,
   and what evidence do they act on?
5. **What it costs.** Money, weeks, and lost preparation. A management game
   that models an injury without its price has modelled a delay, not an injury.
6. **The permanent ones.** Scar tissue, a hand that never fully returns, an
   accumulating head-injury record. Is there sourced ground for permanence, or
   is this folklore? Answer honestly — a refusal here is a real deliverable.
7. **The shape for the game.** Should a region carry a readiness NUMBER and a
   separate named INJURY, or should the injury own the number? Rule on it.

**Refuse**: a whole-body age multiplier; any healing rate presented as sourced
when it is not; a second medical clock beside `medical_hold_until_week`; a
gruesome-detail injury simulator. This is a management game.

---

## AREA B — SHOULD THE GAME MODEL DIET

### What the game has today, exactly

- A fight camp has a **cut plan**. Choosing one sets two scalars: a training
  gain scale and an injury-chance scale. There is a walking weight, a limit for
  a booked bout, a weigh-in, and a settled scale fact that can block a belt.
- **That is the entire nutrition model, and it exists only inside a fight
  camp.** Outside camp there is no food, no calories, no macronutrients, no
  hydration, no supplement, no meal, no dietitian.

### Answer these

1. **Does diet belong in a management game at all?** Argue both sides from the
   genre before you argue from the sport. Survey what comparable management
   games actually model, and what players demonstrably engage with versus what
   reads as a chore. A "no" is an acceptable and useful answer.
2. **What diet demonstrably affects**, with sources: making weight; rehydration
   and performance after a cut; energy availability and RED-S; recovery and
   soft-tissue injury risk; body composition over a career; walking weight
   drifting between camps and forcing a weight-class move.
3. **The honest granularity.** If it ships, is it a weekly PLAN (a choice with
   consequences), a standing DISCIPLINE stat, or a daily task? Rule on it, and
   rule on how much of it the player should be able to micromanage.
4. **The seam with Area A.** Nutrition is claimed to affect healing. Is that
   sourced strongly enough to move a per-region recovery clock, or is it a
   modifier the game must mark UNKNOWN?
5. **The seam with the weight cut that already exists.** If diet becomes
   year-round, what happens to the two camp scalars — replaced, kept, or fed?
6. **Where it would be shown**, in one paragraph, so no screen invents a place
   for it. Do not design the screen.

**Refuse**: a calorie counter; a macro tracker; a food inventory; anything that
makes the player type a number a nutritionist would type. Rule out what the
game must never do as explicitly as what it should.

---

## AREA C — WHAT STATS A FULL FIGHTER ACTUALLY NEEDS

### What the game has today, exactly

Six stats, every athlete, every discipline, each 0–100:

| stat | what it drives today |
| --- | --- |
| POWER | damage after a strike lands |
| TECHNIQUE | quality of basic fallback actions |
| SPEED | with Fight IQ, who acts next in an exchange |
| DEFENSE | opponent's chance to land; submission resistance |
| CONDITIONING | stamina cost, recovery between exchanges and rounds |
| FIGHT IQ | with Speed, initiative — and it is DERIVED from experience, not trained |

Beside them the game already carries **per-discipline proficiency** and
**per-move mastery**, so "how good are you at this specific technique" is
already answered elsewhere and is NOT a stat question.

The game's disciplines are: MMA, boxing, kickboxing, muay thai, wrestling,
judo, Brazilian jiu-jitsu, karate, taekwondo, sanda, sambo, capoeira, savate,
pencak silat, arnis.

**Nothing in that table distinguishes a wrestler from a boxer.** There is no
grappling, no clinch, no takedown defence, no chin or durability, no footwork,
no reach usage, no pressure or aggression, no ring generalship, no flexibility,
no strength separate from power, no cardio separate from conditioning.

### Answer these

1. **What is genuinely missing** for the game to depict a full fighter of ANY
   of those disciplines? Propose the additions as a ranked list, each with what
   it would drive and what it would take away from an existing stat.
2. **One set or many?** Does one stat set serve a boxer and a judoka honestly,
   or does each discipline need its own? Rule on it. This is the most expensive
   decision in the area and the one an implementer most needs settled.
3. **The overlap trap.** For every stat you propose, say what it is NOT — the
   existing stat it would otherwise silently duplicate. A stat that overlaps
   another is worse than a missing one.
4. **Durability and the chin.** Is there sourced ground for a chin/durability
   attribute, or is it folklore? J10 D8 already ruled the medical hold outranks
   chin folklore; say whether that closes the question or only narrows it.
5. **Derived versus trained.** Fight IQ is derived from experience and cannot
   be gym-trained. Which of your proposals must be derived the same way, and
   which are trainable?
6. **The ceiling.** How many stats can a management game show before the player
   stops reading them? Answer with evidence from comparable games, and give a
   number.
7. **What the sexes do not share.** Where a stat's real distribution differs by
   sex, say so and say whether the game must model it.

### The open operator question you are also answering

J10 left one call unmade and it belongs here: **the peak-years window is
currently ONE window for everyone.** J10 D6 found women are OLDER than men in
amateur boxing and YOUNGER in judo and taekwondo, so a single window is a real
loss of fidelity — but J10 also found no sourced per-discipline curves for most
of this game's disciplines. Rule on which the game should adopt: one window,
one per sex, or one per discipline — and say plainly what is lost by each.
Whatever you rule, name the disciplines for which the number would still be
invented.

**Refuse**: a hidden stat the player cannot see; a "potential" second axis (the
game already has one); a stat that only exists to make a number go up.

---

## The one thing that would make this pass worthless

Supplying a confident number for something nobody has measured. Three of this
project's systems have been rebuilt because a plausible constant was taken for
a sourced one. **An UNKNOWN you name is worth more than a figure you infer**,
and the § UNKNOWN lists are read as carefully as the rulings.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/J13_THE_BODY_THE_DIET_AND_THE_PICTURE.md
```

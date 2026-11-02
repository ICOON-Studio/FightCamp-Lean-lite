# G59 — HOW LONG A FIGHTER STAYS OFF BALANCE

**Agent:** Grok (Expert / research mode), 145 sources, 1m 42s. Assigned and
collected 2026-09-12. Every label below is Grok's own: **DOCUMENTED**,
**INFERENCE**, **NOT FOUND**.

---

## THE THREE-LINE ANSWER

> **Decay:** 0.2–0.8 s for a converted kuzushi window; 0.5–2 s if the man stays up.
> **Scalar state plus a facing line.**
> **Yes** — a stuffed shot leaves the shooter worse than neutral.

And the sentence that matters most for the spec:

> **"Placeholder magnitude × 0.1 s (0.1–2 s) is the right order for (a) and (d).
> It is not one curve for (a)–(d)."**

---

## 1. THE DECAY RATE — R131 §7's OPEN NUMBER

Our placeholder was a linear decay over `magnitude * 0.1` fight-seconds. **The
order of magnitude survives. The single curve does not.** The four cases want
three different mechanisms.

### (a) A kuzushi that is converted — 0.2–0.6 s, and nearly binary

- **DOCUMENTED:** Sacripanti timed competitive throws at **~0.6 s total**;
  tsukuri **0.20–0.21 s**, kake **0.40 s**, whole movement **0.61 s**
  (arXiv:1010.2658).
- **DOCUMENTED:** Kodokan pedagogy treats the three phases as one continuous
  action — *"there is not a true time wise between each of these phases"*
  (Sacripanti 2012, arXiv:1206.1135).
- **DOCUMENTED:** Olympic time-motion attack sub-phase median **1.29 s**
  (IQR 1.97) — the whole attack envelope, not the balance-break sliver
  (Miarka et al., JSCR). Throwing time 1.3 ± 0.5 s in one elite split.
- **INFERENCE:** the usable conversion window after a real break is **tenths of a
  second**. If tori does not enter, uke is already restacking (Koizumi: relax the
  hold and uke returns to "four corners").
- **NOT FOUND:** any study isolating "kuzushi onset → throw fails" in milliseconds.

**So (a) should be sub-second and close to binary — converted or lost — not a fade.**

### (b) A sweep the man recovers from — ~0.5–1.5 s, and the number is BORROWED

- **NOT FOUND:** measured seconds of compromised base after a failed osoto, trip
  or MMA sweep in competition film.
- **NEAREST DOCUMENTED, and Grok flags it as the wrong task:** force-plate
  **time-to-stabilization** after a jump landing, ~0.5–2 s (plyometric TTS
  0.50–0.99 s; jump-land TTS ~1.1–2.0 s). That is recovery from a known large
  perturbation while already airborne.
- **INFERENCE:** half a second of "still light on one foot" is plausible;
  **two-plus seconds of fight-usable deficit is not published.**

### (c) A stuffed takedown — DO NOT DECAY IT. CHANGE STATE.

- **NOT FOUND:** any timed postural recovery of a shooter after a sprawl.
- **DOCUMENTED pedagogy (not a clock):** after a stuff the shooter is bent, hips
  behind, head under the defender. **Front headlock / guillotine / go-behind is
  the taught next state, not "neutral standing".** Recovery is *"post up or get
  choked"*, not a half-second fade.

**This is the finding that changes the design.** A stuffed shot is not "attacker
balance = 12, decaying over 1.2 s". It is a POSITION HANDOVER.

### (d) Staggered by a strike, still standing — 0.5–2 s, and honestly labelled

- **DOCUMENTED for KO, not stagger:** impact-induced loss of tone onset ~17 ms;
  some fighters regain arm tone to brace by ~450 ms. That is a flaccid fall, not
  a standing wobble.
- **DOCUMENTED reflex, not recovery:** judoka tibialis-anterior onset to a
  backward perturbation **20.6 ± 7.1 ms** vs 28.3 ms untrained — how fast the
  ankle fires, not how long the man is compromised.
- **NOT FOUND:** video-coded visible wobble duration after a non-knockdown punch.
  Searched punch kinematics, NIRS recovery, the ILoMT paper, TTS papers.
- **INFERENCE:** longer than (a), shorter than concussion postural noise.
  **0.5–2 s matches what fighting games use — not what anyone measured on a
  rocked boxer**, and Grok says so explicitly.

### Grok's numbers, if we must pick without inventing a study

| case | value | honesty label |
|---|---|---|
| (a) converted kuzushi | **convert in 0.2–0.6 s or lose it** | documented |
| (b) recovered trip | ~0.5–1.5 s | **borrowed from TTS, label it borrowed** |
| (c) stuffed shot | **don't decay — change state** | pedagogy |
| (d) standing stagger | ~0.5–2 s | **game-plus-TTS, not fight-lab** |

---

## 2. VECTOR OR SCALAR — THE EVIDENCE SAYS SCALAR PLUS A FACING BIT

**This question was already answered by the operator's own briefing** (eight
geometric directions, weak lines perpendicular to the stance), so what follows is
corroboration and shipped-game precedent, **not a decision input**. It cannot
overturn the briefing. It does bear directly on R131 §4's "if the vector is too
much for the first pass, say so and ship the scalar".

### What judo pedagogy actually does with the eight directions

- **DOCUMENTED:** happō-no-kuzushi is Kano's expansion of Tenjin Shin'yō-ryū
  roppō into eight horizontal compass points. **It is a didactic model.**
  De Crée / Sacripanti: happō often just means "all directions"; the diagram is
  **2-D, ignores the vertical break**, and does not account for competition reality.
- **DOCUMENTED:** Koizumi — a throw depends on *"the direction of weakness and the
  direction of movement"*; tsukuri balances uke on the toes or heel of one foot.
  **Direction is real. The eight named rays are a teaching grid.**
- **INFERENCE:** coaches use happō to teach beginners where to pull; high-level
  analysis uses the line of weakness relative to stance and motion, not a stored
  8-enum. **"Your engine already knowing orthodox/southpaw is the useful half."**

### What shipped games do

| game | system | directional? | bought / cost |
|---|---|---|---|
| **Tekken** | no standing balance meter; crush is height, Heat is a timer | height + sidestep | Harada/Murray interviews: Heat is an offence timer, not posture. Off-axis weakness is only "you sidestepped a linear" |
| **Virtua Fighter** | stagger/stumble — can't guard, throw-invulnerable; struggle shortens it | **scalar** duration; evade is directional | readable "wobble then mash out". **2026 producer letter: they CUT stagger because stick-vs-pad recovery was unequal** — they shrank it rather than vectorise it |
| **EA UFC 3→6** | hidden stun meter + per-zone stun icons (head/body/legs); grapple advantage is a tug-of-war scalar | **zone of trauma, not compass of base** | "he's hurt, pour on". Community film calls out rock state clearing on hitting the floor — design, not physiology |
| **Sifu** | Structure — one white bar; break → takedown | **scalar**; throws have direction *after* the break | readable "break then finish". Cost: **no weak line — a man is equally broken from every angle** |
| **Sekiro** | Posture bar; fill → deathblow; recovers when idle, slower at low HP | **scalar** | the rhythm duel. Posture is not a facing |
| **For Honor** | guard in 3 directions (simplified from four historical quarters); Guard Break → ~800 ms stun then a directional throw | **directional defence**, GB itself a short scalar | the three-lane mind game; cut a quarter for the HUD |
| **WWE 2K** | stun meter → no reversals for a few seconds | scalar | zero relation to base |

- **NOT FOUND:** any shipped 3D fighter storing happō as **eight independently
  decaying channels.**
- The closest real pattern in shipping games is **scalar break + directional
  follow-up** (Sifu's throw, For Honor's throw, VF's evade).

> Grok's warning, worth keeping: *"Scalar meters exist because they read on a HUD
> and close a combo. Compass weakness exists in judo because a stance has two
> feet. Do not copy Sekiro's bar and call it kuzushi."*

---

## 3. DOES A FAILED TAKEDOWN BREAK THE ATTACKER? — YES, AS A POSITION

- **DOCUMENTED:** stuffed shot → **front headlock** is taught as a winning
  position for the defender (sprawl hip on shoulders, shooter's spine flexed).
  From there: guillotine, d'arce, anaconda, go-behind / back-take, or knees while
  he posts.
- **DOCUMENTED:** the **guillotine is the second most common UFC submission**
  (~264 wins, ~17% of tapouts) and is routinely described as **the takedown
  punisher** — the neck is exposed on a shot.
- **DOCUMENTED:** UFC takedown defence ~56% in one 2018–23 summary; other samples
  put takedown success at ~32%. **Most shots already fail.** That says nothing
  about the next ten seconds.
- **NOT FOUND:** the exact figure we asked for — the fraction of stuffed takedowns
  after which the defender scores within 10 s. Grok names what it searched:
  UFCStats / FightMetric public splits, PMC MMA outcome papers, FightAlpha TD-edge
  tables, submission-type tallies, sprawl instructionals. **They store attempts,
  completions, TDD% and control time — not a conditional clock after a stuff.**
- **INFERENCE:** most stuffs are survived, or every wrestler shooting four times a
  round would be submitted. The ones that matter look like Oliveira-on-a-shot.

---

## WHAT THIS CHANGES IN R131

1. **§7's decay is no longer invented — but it must become THREE mechanisms, not
   one.** A converted kuzushi is a sub-second binary window; a recovered sweep is
   a ~1 s fade borrowed from TTS and must be labelled borrowed; a stagger is
   0.5–2 s and is a game convention we are choosing, not a measured fact.
2. **§9's third open question is answered YES — and answered in a way that says
   not to model it as balance at all.** A stuffed shot hands the defender a front
   headlock. That is a POSITION, and the engine already has grapple positions.
   Modelling it as a decaying scalar on the attacker would be modelling the wrong
   thing.
3. **§4's fallback is now evidenced.** Ship the scalar plus the stance line the
   engine already carries. No shipped 3D fighter stores eight decaying channels,
   and the eight directions are a teaching grid rather than an analytical tool.
   **The operator's briefing is correct about real judo; the open question was
   only ever whether to model it, and the answer is: not in the first pass.**

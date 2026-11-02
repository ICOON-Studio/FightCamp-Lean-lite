# R131 — BALANCE BREAK (KUZUSHI): THE SPEC

**This is the operator's design ruling, 2026-09-12, written up as a spec.** The
domain content is theirs; what is mine is the mapping onto the engine, and every
such mapping is marked **ENGINEERING CHOICE** so it can be overruled without
unpicking the design.

**THE OPERATOR'S SOURCE TEXT IS NOW STORED VERBATIM** in
`R131_BALANCE_BREAK_BRIEFING_SOURCE.md`, with its citations. This file quotes
fragments of it; that file is the evidence. Until 2026-09-12 the briefing existed
only in a chat window, so a `/clear` would have left nothing but my paraphrase.

It answers the question U59 ranked and never resolved: **balance is a STATE, not
an eighth attribute.** Every phrase in the operator's briefing is transient —
*"momentarily neutralizes"*, *"a safe window"*, *"mid-strike"*. Nobody is
permanently off-balance. That also makes it the cheap option: no save-format
bump, no new row on every stat strip.

---

## 1. WHAT IT IS

A balance break (**kuzushi**) is deliberately pulling or pushing an opponent's
centre of gravity outside their base of support.

**While broken, a fighter cannot:**
1. generate power
2. defend effectively
3. strike back

Those are three distinct penalties, not one, and they are what the state must
actually apply.

---

## 2. THE RULE THAT CHANGES THE MOST: BALANCE GATES THE TAKEDOWN

> *"In grappling, a balance break is the mandatory first step before executing
> any successful throw or takedown. If you attempt to throw an opponent while
> they are perfectly upright and balanced, you must rely on brute force, which is
> easily countered. If you break their balance first, their own body weight and
> momentum assist the throw."*

**TODAY THE ENGINE HAS NO SUCH CONCEPT.** `GrappleResolve` weights the attacker
`grapple .45 / power .20 / speed .15 / technique .10 / fight_iq .10` against the
defender `grapple .40 / defense .30 / speed .15 / fight_iq .15`. **Balance
appears nowhere.** A takedown against a perfectly planted man and one against a
man stumbling off a teep resolve identically.

**THE SPEC:**

- A takedown against a **balanced** opponent is the brute-force case: the
  attacker's `power` term carries it, and the attempt is **highly counterable**
  (it is the natural entry point for `stop_hit` — see R130 group 1).
- A takedown against an **off-balance** opponent is assisted: the defender's
  resistance is reduced in proportion to how broken they are, and the attempt is
  much harder to counter because they cannot strike back.

**ENGINEERING CHOICE:** apply it as a scalar on the defender's side of the
existing contest rather than as a new weight — `defender_score *= (1.0 -
kuzushi)` where `kuzushi` is 0.0–1.0. This keeps the authored weights untouched
and makes the mechanic removable.

---

## 3. "WHEN BALANCE IS BROKEN, STRENGTH BECOMES OPTIONAL"

> *"It allows a smaller or weaker fighter to completely compromise a stronger
> opponent using timing, angles, and leverage."*

**This is the most important line in the briefing and it must be modelled
literally.** It is the rule that makes a technical lightweight viable against a
powerful heavyweight, and the game currently has no such rule — power is simply
worth .20 of every takedown, always.

**THE SPEC:** while the defender is off-balance, the **attacker's `power`
contribution is reduced and their `technique` contribution raised**, in
proportion to the break. A fighter who sets up properly wins with leverage; a
fighter who shoots on a planted man needs to be strong.

**ENGINEERING CHOICE:** redistribute within the existing attacker weights rather
than adding terms — at full kuzushi, `power .20 → .05` and `technique .10 → .25`.
The weights still sum to 1.0, so nothing else needs rebalancing.

---

## 4. IT HAS A DIRECTION — EIGHT OF THEM

> *"A person standing has strong lines of balance (directly between their feet)
> and weak lines (perpendicular to their stance). A balance break forces the
> opponent's torso or head toward those weak lines, typically in one of 8
> geometric directions."*

**Balance break is a VECTOR, not a scalar**, and this is the part most likely to
be dropped in implementation, so it is stated separately.

A teep that pushes a man straight back and a clinch twist that turns his upper
body away from his legs are not the same break, and they do not set up the same
follow-up. A break along a **weak line** should be worth far more than one along
a strong line.

**ENGINEERING CHOICE:** store the state as `{magnitude: float, direction: int}`
with direction on the standard 8-point compass **relative to the defender's own
stance**, not to the world. Stance already exists on every fighter
(`orthodox` / `southpaw`), which is what defines where the weak lines are.

**IF THE VECTOR IS TOO MUCH FOR THE FIRST PASS, SAY SO AND SHIP THE SCALAR** —
but ship it knowing the direction is missing, rather than discovering later that
every break was treated as identical.

---

## 5. HOW IT IS CAUSED — AND THE ACTION/REACTION SETUP

**Grappling:** *"if a fighter pushes an opponent, the opponent will instinctively
push back. The fighter then suddenly switches to a pull, using the opponent's
forward momentum to overextend them."*

**This is a two-beat mechanic and the engine has the machinery for it** — chains
already exist, and `combo_reads` already tracks a defender learning a pattern. A
push followed by a pull should produce a LARGER break than either alone.

**Striking:**
- **Muay Thai** — the teep pushes an opponent backward mid-strike; the clinch
  twists the upper body away from the legs.
- **Boxing** — footwork or a heavy jab forces the opponent onto their heels.

**This is already in the authored data and is why the catalogue is worth
trusting:** `balance_break` sits on **16 techniques**, and the values are
graded — a teep is **5**, a throw is **14**. Somebody authored this as a
transient deficit, which is exactly what the operator has now confirmed it is.

---

## 6. WHAT IT OPENS: THE SAFE WINDOW

> *"Once the balance is broken, the opponent cannot return fire with power,
> creating a safe window for a combination attack."*

**This links balance directly to the counter layer and to the rhythm layer**
(R130 groups 1 and 2). The safe window is why a fighter commits to a
combination: it is not a free choice, it is earned.

**THE SPEC:** while the target is off-balance, (a) their counter roll from R130
group 1 is suppressed, (b) their outgoing damage is scaled down, and (c) the
attacker's chain-continuation chance rises.

---

## 7. DECAY

Not stated in the briefing, so it is flagged rather than assumed.

**ENGINEERING CHOICE, NEEDS A RULING:** kuzushi decays to zero over a short
window. A teep's `balance_break: 5` should be gone in well under a second of
fight time; a throw entry's `14` should last long enough to finish the throw.
**Proposed: linear decay over `magnitude * 0.1` fight-seconds**, so 5 gives half
a second and 14 gives 1.4 — but this is invented, and it is the one number here
that nothing in the briefing or the data pins down.

---

## 8. WHAT THIS COSTS

- **Seeded verdicts move.** This changes who wins, by design. It is a rebaseline:
  change the engine and re-pin the scorecards **in the same commit**, because a
  commit that deletes the old pinned cards without adding new ones is forbidden.
- **No save-format change**, because it is state and not an attribute.
- **`GrappleResolve`'s authored weights are not edited** under the choices above —
  only scaled — so the change is reversible.

---

## 9. WHAT IS STILL OPEN

1. **Decay rate** (§7) — invented, needs a ruling or a measurement.
2. **Vector or scalar** for the first pass (§4).
3. Whether a **failed** takedown attempt should itself break the attacker's
   balance — real fights punish a bad shot, and nothing in the briefing covers it.

---

## ANSWERED — OPERATOR RULING, 2026-09-12, ON SECTIONS 9.2 AND 9.3

**9.2 — VECTOR OR SCALAR: SHIP THE SCALAR PLUS STANCE.** The first pass stores
`{magnitude}` and uses the fighter's existing `orthodox` / `southpaw` stance. The
8-point compass of section 4 is **not** in the first pass.

Section 4 attached a condition to exactly this answer and the condition stands:
**ship it knowing the direction is missing, and say so** — in the spec, in the
code comment, and in the digest — *"rather than discovering later that every
break was treated as identical."* A break along a weak line and a break along a
strong line will be worth the same until the vector lands. That is a known,
recorded deficiency, not an oversight.

Because balance is STATE and not an attribute there is no save-format change, so
adding `direction` later is additive.

**9.3 — A FAILED TAKEDOWN BREAKS THE ATTACKER'S OWN BALANCE: YES.** Nothing in
the operator's briefing covered it; this is a new ruling, not an interpretation
of the briefing. A stuffed shot leaves the attacker overextended and briefly
vulnerable, which is what makes shooting a risk rather than a free roll.

**9.1 — THE DECAY RATE IS CLOSED, BY G59, AND SECTION 7 ABOVE IS SUPERSEDED.**
No new research was needed and none was assigned. `G59_BALANCE_RECOVERY.md`
section 1 was commissioned for exactly this number, delivered on 2026-09-10, and
never folded back into this file. Its four cases, with G59's own honesty labels
kept because they are the point:

| case | value | honesty label |
|---|---|---|
| converted kuzushi | **convert in 0.2–0.6 s or lose it** | documented |
| recovered trip / sweep | ~0.5–1.5 s | **borrowed from TTS — say so in the code** |
| stuffed shot | **do not decay — change state** | pedagogy |
| standing stagger | ~0.5–2 s | **game precedent plus TTS, not fight-lab** |

Section 7's proposed `magnitude * 0.1` linear fade is **withdrawn**. A converted
kuzushi is near-BINARY — converted or lost — not a ramp, and modelling it as a
fade makes a throw entry feel like a slider.

**THE COLLISION WITH 9.3, WHICH MATTERS MORE THAN THE NUMBER.** The operator has
ruled that a failed takedown breaks the attacker's own balance. G59's stuffed-shot
row says that case must **not** be a decaying number at all — a sprawled-on
shooter is in a taught next position (*"post up or get choked"*), not carrying a
deficit that fades. Both are correct. **The ruling settles THAT a bad shot costs
the attacker; G59 settles WHAT the cost is — a position handover.** Do not
implement 9.3 as `attacker.balance -= n` on a timer: that is the cheap reading,
and it models the single case the research names as not-a-fade.

# TASK J24 — JOHN — WHAT A STOP-HIT COSTS WHEN IT FAILS

**Research only.** No checkout, no engine, no repo access — none is needed. Do not
propose code. Prose, numbers, sources. One pass.

**This task was four times longer an hour ago and was cut deliberately.** We were
about to commission research into five mechanics; then we measured our own
catalogue and found most of what we would have asked for is already encoded in
data we own (R135). **One question survived, because the data genuinely cannot
answer it. That is this one. Do not broaden it.**

---

## THE SITUATION

We are building a 3D fighting-simulation game. Our technique catalogue tags ten
techniques with `stop_hit` and two with `intercept` — striking a man as he
commits to an entry, typically a takedown shot. Our design lead asked for exactly
this when they pushed back on our takedown model: a takedown should be contested
by *"counters, like knees or dodge"*.

We are about to build it. Our proposal is that a defender holding such a
technique gets a roll to land first; on success the attacker's action is aborted.

**Every tag in our catalogue is a BENEFIT. Not one encodes a cost.** So our
mechanic, as proposed, lets a defender attempt an interception for free — he
rolls, and if he loses the roll nothing bad happens to him. We are fairly sure
that is wrong, and we cannot fix it from our own data.

## THE QUESTION

**What actually happens to a fighter who tries to intercept a committed attack
and fails?**

Specifically:

1. **The takedown case, which is the one we are building.** A man throws a knee
   or an uppercut at an opponent shooting a double-leg, and misses. What happens
   to him? Is he taken down *more* easily than a man who simply defended — one
   leg in the air, weight forward, hands committed? Any published figure: takedown
   success rate against a defender who attempted a strike versus one who sprawled.
2. **The striking case.** A counter-puncher who commits to a check hook or a
   stop-hit and mistimes it. Is he hit harder than a man who was just covering?
   Why — his own forward weight, an open guard, no time to roll with it?
3. **Is there a name for this in coaching literature?** Trading a defensive
   posture for an offensive gamble must be taught somewhere, with a stated cost.
   Boxing, wrestling, muay thai, fencing (which has the oldest formal vocabulary
   for stop-hits and counter-time) — fencing may well be the best source here and
   we have not searched it.
4. **How do shipped games price the failure?** EA UFC, Undisputed, Tekken, Virtua
   Fighter, For Honor, Sifu. A failed parry or counter attempt — does it cost
   recovery frames, a guard break, extra damage taken, nothing? **What stopped
   interception from becoming the only thing players do?** A named developer
   interview or GDC talk is worth far more than a wiki.

## RULES FOR THE ANSWER

**LABEL EVERY CLAIM: DOCUMENTED** (published source, named and linked),
**INFERENCE** (your reasoning, and from what), or **NOT FOUND** (you looked and it
is not published — a perfectly good answer and we want it explicitly).

**DO NOT INVENT A NUMBER.** This goes straight into a fight engine. A fabricated
rate is far worse than NOT FOUND, because it will be typed into a formula and
then defended for months as though it were measured. A study on this project once
concluded a whole category of animation did not exist anywhere, and a ten-euro
listing disproved it the same day — so search properly, then say what you
searched.

**DISTINGUISH REAL COMBAT FROM GAME DESIGN.** We want both and must never confuse
a convention that feels good with a measured human fact.

**LEAD WITH TWO LINES:** what a failed interception costs a real fighter, and how
shipped games stop it being free. Everything else underneath.

## DELIVERY

You have no checkout. **Reply in the chat; Claude collects it and writes
`research/J24_THE_FAILED_INTERCEPTION.md`.** No git command, no test
command, no repo path.

## Owned files — the collection target

This agent has **no checkout and cannot push**. The deliverable is real
regardless: Claude collects the answer and writes the file below. Naming it here
is what lets `python Tools/agent_comms.py done --task J24` mean *"has this been
collected yet?"* rather than passing on nothing.

- `research/J24_WHAT_A_STOP_HIT_COSTS_WHEN_IT_FAILS.md` (delivered 2026-09-13 under this name;
  the name asked for above was `J24_THE_FAILED_INTERCEPTION.md`)

**The agent is not asked to create it and must not be given a git command.**

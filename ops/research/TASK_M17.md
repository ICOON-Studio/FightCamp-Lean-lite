# TASK M17 — MARIA — THE REACTION IS THE PUNCH

Art direction. No code, no repository access, no test command.
Owner: maria. Deliverable: `research/M17_THE_REACTION.md` plus boards in
`DesignLibrary/screens/fight_frame/m17_01..m17_NN`.

## Why this exists — it is your own M16 finding, being spent against

M16 §3 and §7, and they are the reason this task exists:

> At HOME, **the opponent's reaction out-reads the thrower's arm.** Fine
> straight taxonomy does not survive. Prefer **reaction clips** over buying jab
> as distinct from cross — those few reactions carry more type-feeling at HOME
> than a sixth punch.

That is a spending flip, and it is being taken. You cut the punch list from six
types to three (+1 optional straight), which **freed slots**. M16 says the
freed money goes to reactions. **So now we have to know what a reaction must
show**, and nobody has boarded one.

## What you are working against — all measured, all landed today

The engine does not name a technique. It names a **region** and a **contact**,
and those are the only two facts a reaction may honestly express:

- **Regions**, with their measured shares of presented strikes:
  `head_neck` **65.3%**, `torso_core` **28.2%**, legs **3.2%**, arms **0%**.
- **Contacts**, with theirs: `clean` **92.7%**, `glancing` **5.6%**,
  `absorbed` 0.8%, `blocked` **0.2%**, `slipped` 0.1%, `missed` 0.5%.

Two consequences that are settled and not yours to reopen:
- **`blocked` and `slipped` are not purchased clips** (J17, and the 0.2% share
  agrees). Do not board them as buys.
- **A boxing bout emits leg strikes at ~6% of presented strikes** — a known
  engine defect being fixed at the target picker, not an art problem. **Do not
  board a leg reaction for boxing.**

So the honest reaction space is small: **head or torso, clean or glancing**,
plus the knockdown M15 already owns.

## The question

1. **How many reaction clips, and which?** Given the shares above and M16's
   ranking, name the buy. Two (`react_head`, `react_body`)? Four, splitting
   clean from glancing? Board the candidates and rank them.
2. **What must a reaction SHOW at HOME** — fov 50, pitch −20 to −22°, eye
   3.8–4.2 m, stand-off 9–11 m? M16 §4 already found the surviving cues are
   whole-body silhouette path, head snap / torso fold / stumble, and
   follow-through mass, while glove detail and face are dead at that distance.
   Apply that to the *receiving* body: what does a head shot look like from
   there, versus a body shot?
3. **Does the reaction carry the punch TYPE?** This is the load-bearing one and
   it follows straight from M16 §3. If a hook and a straight produce visibly
   different reactions — a turn versus a snap back — then **the reaction is
   where type lives**, and we should spend there rather than on a fourth punch.
   If it does not, say so; that closes the flip rather than extending it.
4. **Severity, not just location.** Our engine emits a continuous force and a
   `shock` flag, and a fighter carries per-region damage and a stamina tank. Does
   a reaction need **levels** — took it well / hurt / badly hurt — and is that a
   purchase, a playback-speed change, or a procedural lean? Say which, and say
   what the cheapest version is.
5. **`glancing` at 5.6%.** Is it worth its own clip, or is it the clean reaction
   played smaller? It is the second most common contact by a wide margin, so it
   is the one candidate for a third reaction.
6. **What we must NOT buy.** Same discipline as M16 §8. Name the reaction
   purchases that would look reasonable and be waste.

## Standards

- Boards as PNGs in a new folder, numbered, in the M14/M15/M16 house style.
- A **DECISIONS** section at the top: typeable lines — the reaction buy count,
  the ranking, and one-line answers to questions 3 and 5.
- Mark what is art invention versus what follows from the measured shares, the
  way M16 §9 did. That candour is why M16 is being spent against.
- Do not write GDScript, do not specify an implementation, do not reopen M14's
  camera, M15's KD CAM, M16's ranking, or J17's decisions.

Land it the way you landed M14/M15/M16. **Do not edit `HANDOFF.md`** — Claude
writes your block. Do not wait on Claude for more files.

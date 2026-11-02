# TASK Q50 — QWEN — THE GI AND THE SHIN GUARDS: WHAT TO BUY ON 2026-09-14

Model: Qwen CLI, medium effort. Owner: qwen.
Study. **No GDScript, no engine work, no test command.**
Test tier: **RESEARCH, NO `.gd` TOUCHED — NO GATE AT ALL.** `git status -s`
before staging is the whole check.

## Owned files

- `research/Q50_GI_AND_KIT.md` — **NEW. Yours alone.**

Nothing else. Do **not** edit `HANDOFF.md`, `CURRENT_STATUS.md`, `TASKS.md`, any
other task file, or any script. Do not read `HANDOFF.md`, `HANDOFF_ARCHIVE.md`,
`CURRENT_STATUS.md` or any digest, and do not explore the repository.

## Why this exists, and the deadline

The game's title screen is now a live 3D room with three fighters in it. The
operator asked for **four**: a boxer, an MMA fighter, **a karate fighter in a
white gi with a black belt**, and a **kickboxer**. We delivered the first two and
a filler. The other two are blocked on ASSETS WE DO NOT OWN:

- **A gi is geometry, not a texture.** It cannot be painted onto a bare torso.
- **A kickboxer needs kit** — shin guards, kickboxing shorts. Our only other
  signifier would be a kicking pose, and every kick in the pack we own is a
  FLYING kick that reads as levitation when held.

**A Unity Asset Store sale opens 2026-09-14, 50% off 300+ best sellers.** This
study decides what to put in the basket before it opens.

## The hard constraint that rules out most of the market

Our twelve fighters are rigged to the **standard humanoid bone profile, 22 bones
through one map** (verified across 161 clips). A bought character is only useful
to us if it can be driven by the animation library we already own.

So for every candidate you MUST answer: **is it rigged, to what skeleton, and
will a humanoid clip retarget onto it?** A beautiful unrigged gi model is worth
nothing here. A character on a proprietary non-humanoid rig is worth nothing
here. **Say so plainly when the answer is no or unknown** — "rig not stated on
the listing" is a finding, not a gap in your work.

## The questions

1. **Karate gi characters.** What is available with a white gi and a black belt,
   rigged and humanoid? Unity Asset Store first, since that is where we buy.
   Give name, publisher, price, whether the listed price is in the sale, and the
   rig it ships on.
2. **Kickboxing kit.** Same, for shin guards and kickboxing shorts. Note whether
   it is a whole character or a gear set that would need a character under it.
3. **THE LICENCE, AND THIS IS NOT OPTIONAL.** This project is developed
   end-to-end by AI agents. We already refuse one vendor's direct store because
   its EULA forbids AI use — *the money saved buys a worse licence*. For every
   candidate, state what the licence says about AI-assisted development, and
   flag anything restrictive. **An asset we cannot legally use is not a
   candidate**, however cheap.
4. **Free routes, honestly assessed.** Mixamo ships rigged humanoid characters
   and is free — is there a gi or kickboxing character there, and what does
   Adobe's licence permit? (Note: a previous session was blocked by an Adobe 403
   and never got in, so this may be NOT FOUND rather than absent.) Anything
   comparable elsewhere.
5. **The cheap alternative nobody asked about.** Is there a route that avoids
   buying a character at all — a gi as a separate garment mesh fitted to a rig we
   already own, or a vendor selling clothing rather than people? Rank it against
   buying whole characters on cost and risk.
6. **What would you actually buy?** One recommendation with a price, and a
   fallback. We need two figures, not a wardrobe.

## Standards

- **Use web search.** Prices, sale inclusion and licence terms are facts to
  check, not recall.
- **Separate DOCUMENTED from FOLKLORE from your own INFERENCE, and label each.**
  You did this well in Q48 and Q49; do it again.
- **Mark anything unpublished as NOT FOUND.** Do not invent a price or guess a
  rig. A listing that does not state its skeleton is a listing whose skeleton is
  unknown, and that is what you write.
- Do not write GDScript.

## Deliverable shape

A **DECISIONS** section at the very top: short typeable lines, including the one
thing to buy, its price, and a yes/no on whether its licence permits AI-assisted
development. Body and citations below. **Be concise.**

## Deliver

Stage **only your own file**:

```
git add -- research/Q50_GI_AND_KIT.md
```

Never `git add -A`, never stage `audio_exports/`. Check `git status -s` first —
another agent's work in progress may be pre-staged in this shared checkout.
**Never `git stash`, `reset --hard`, `checkout .` or `clean`** here.

Commit, push to `master`, then send one line:

```
python Tools/agent_comms.py send --from qwen --to claude --subject Q50-done --body "<sha> <what to buy> <price> <AI-licence yes/no>"
```

Do **not** edit `HANDOFF.md` — Claude writes your block.

## THE ONE TRAP THAT WILL COST YOU THIS TASK

It is very easy to come back with a list of gorgeous karate models and no answer
about **rigging** or **licence** — the two things that actually decide whether we
can use one. A model that will not take a humanoid clip, or whose EULA forbids AI
work, is not a cheaper option: it is not an option. **Lead with those two columns
for every candidate, and mark them NOT FOUND rather than guessing.**

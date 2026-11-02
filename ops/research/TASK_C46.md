# TASK C46 — THE BELT'S OWNER: WHO SANCTIONS A TITLE, DISCIPLINE BY DISCIPLINE (codex)

Model: gpt-5.6-luna, effort **high**, Fast off. One session. Research only —
**no `.gd`, no `.json`, no scene.**

## Why this exists, and why it is first

R68 (2026-09-08) gave every belt a promotion: the highest-standing organization
in the world that runs that discipline, tier before reputation. It shipped
because J3 **D1** already ruled that house promotions own one belt per
`discipline|weight_class|sex`, and J3 **D3/D4** ruled the boxing alphabet out of
the catalogue. That ruling is sound for the eight MMA promotions.

**It is unexamined for five of the eight disciplines the game seeds belts in.**
The real-organization catalogue has exactly one entry each for judo, wrestling,
taekwondo and karate, and those four are `entity_type: "federation"` — the IJF,
United World Wrestling and World Taekwondo are Olympic international
federations. R68's `promotions_by_standing()` **excludes federations on
purpose** (J2 section 0: a federation runs a national selection pathway, not a
professional belt). So a `judo|Lightweight|male` belt is sanctioned by
whichever generated national market organization happens to list judo in its
`discipline_weights` — "Cyprus Combat Association" holding a world judo title.

Nobody decided that. This study decides it.

## The question, stated once

**For each of the eight disciplines the game seeds belts in — mma, boxing,
kickboxing, muay_thai, wrestling, judo, brazilian_jiu_jitsu, karate (and
taekwondo, sanda, sambo where seeded) — what real-world body owns a
professional world title, and what should the game's belt therefore be?**

Four candidate answers per discipline; pick one and say why:

1. **Promotion-owned** (UFC / ONE / GLORY model) — the belt is the promotion's.
2. **Sanctioning-body-owned** (boxing alphabet) — an overlay on someone else's
   card, per J3 D4.
3. **Federation-owned** (Olympic sports) — a championship EVENT, not a standing
   belt somebody defends.
4. **No world title exists** — the game should not seed a belt here at all.

## What to deliver

`research/C46_THE_BELTS_OWNER.md`, in J3's shape — that file is the
standard you are held to and the only research file you must read besides this
one. Specifically:

- A **decisions page** first: one row per discipline, the call, the
  recommendation, one line why. Operator-readable without the body.
- **Evidence, cited**, with J3's UNKNOWN discipline: a claim you cannot source
  is written UNKNOWN, never filled in. Primary sources (a federation's own
  statutes, a promotion's own site) beat journalism.
- **What the game does today**, honest / invented / absent, from the code —
  this is the half that needs your shell. Read
  `Godot/scripts/WorldPopulation.gd` (`ensure_championships`,
  `promotions_by_standing`, `sanctioning_organization_id`,
  `organization_disciplines`, `_migrate_championship_organizations` — all in the
  window `sed -n '1036,1200p'`) and
  `Godot/assets/data/real_organizations.json`. Say exactly which disciplines
  currently land on a federation, a market association, or nothing.
- **Minimum change**: the smallest honest fix, as a build order, not a system.
  If the answer is "stop seeding a judo belt", say that and cost it.
- **The migration cost of each option**, because belts are live in saves and
  R68's stamp is written once and never overwritten.

## Do NOT

- Do not edit any `.gd`, `.json` or `.tscn`. Do not edit `HANDOFF.md` — Claude
  writes your block.
- Do not recommend a gameplay mechanic. Name the call and the evidence; the
  operator rules.
- Do not reopen J3 D3/D4. The boxing alphabet stays out of the catalogue. Your
  boxing row answers "given no alphabet body exists here, what is a
  `boxing|...` belt", not "should we add the WBC".
- Do not read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
  digest. Read this file, `research/J3_THE_DECISION_QUEUE.md`, and the two
  code/data files named above.

## Owned files

```
research/C46_THE_BELTS_OWNER.md
research/C46_DIGEST.md
```

## Parse gate

None — this task owns no script. `python Tools/agent_comms.py done --task C46`
will say so and pass.

## Test

None. Research task.

## The one trap

**A federation is not a promotion with a bad reputation.** If you find that a
judo world title is an EVENT (World Championships, held on a date, won by
whoever wins it that year) rather than a belt somebody carries and defends,
then the honest answer is that the game's belt object does not fit judo at all
— and saying so is the deliverable, not a failure to answer.

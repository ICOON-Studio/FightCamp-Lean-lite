# TASK C47 — THE CHALLENGER, AND HOW LONG A CHAMPION MAY SIT (codex)

Model: gpt-5.6-luna, effort **high**, Fast off. One session. Research only —
**no `.gd`, no `.json`, no scene.**

## Why this exists

J3 named eight open calls. Three of them are still open, none is built, and all
three are the same question asked from different ends: **who gets the next title
shot, and what happens if nobody does.**

- **J3 call 2** — mandatory vs discretionary challenger. Does #1 get the shot,
  or does the promotion book whom it wants?
- **J3 call 3** — how long a champion may sit. Vacate on inactivity? After how
  long? Whose clock?
- **J3 call 8 / D5** — ranking method: published formula, media vote,
  promotional discretion, or mixed, and **do we ship a number**?

J3 D5 already recommends storing `ranking_mode ∈ {discretionary,
published_criteria, mixed}` and NOT inventing a formula. `grep` says
`ranking_mode` exists nowhere in the repository. Nothing was built.

## What to answer

1. **Ranking method per organization.** For each of the real organizations in
   `Godot/assets/data/real_organizations.json`, what is the published method?
   D5 already establishes UFC = media-panel discretion, IBF = written criteria
   with an exceptions clause, GLORY = published discretion, Meta UFC Rankings
   2026 = qualitative model with the formula UNKNOWN. Extend that to the rest,
   and mark UNKNOWN where it is unknown.
2. **Mandatory challengers.** Which bodies actually publish a mandatory, on what
   clock, and what happens when it is ducked? Boxing alphabet mandatories are
   out of the catalogue (J3 D4) — the question here is whether any HOUSE
   promotion in the 13 publishes one, and the honest answer may be no.
3. **The inactivity clock.** Does any promotion publish a period after which a
   belt is stripped or made interim? R41 already ships `title_status` with
   `interim`, and J3 D2 says interim is created when the holder is unavailable
   "past a data-authored window". **What is that window, and is it published
   anywhere, or is it invented?** If it is invented, say so and recommend where
   the number lives.
4. **What the game does today.** Read the code and say it honestly — this is
   the half that needs your shell:
   - `Godot/scripts/WorldPopulation.gd`: `division_rankings`, `ranking_snapshot`,
     `p4p_rankings`, and the interim rules around `TITLE_STATUS_INTERIM`.
   - `Godot/scripts/GameState.gd` — **13,900+ lines, never open it whole.** The
     ranking and title seams are `get_division_rankings` and
     `get_championships_read` at `sed -n '10430,10560p'`, and the title-bout
     path around `get_bout_title_stakes`.
   - `Godot/assets/data/championship_rules.json` — the interim window as it
     stands today. Say whether it is sourced or authored.

## What to deliver

`research/C47_THE_CHALLENGER.md`, in J3's shape: decisions page first
(one row per call, recommendation, one line why), then cited evidence with
UNKNOWN kept as UNKNOWN, then what the game does today (honest / invented /
absent), then the minimum change as a build order.

Plus `research/C47_DIGEST.md`, short.

## Do NOT

- Do not reverse-engineer a ranking formula from results. J3 D5 exists to stop
  exactly that, and a plausible-looking formula is worse than an honest
  `discretionary`.
- Do not edit `HANDOFF.md` — Claude writes your block.
- Do not read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
  digest. Read this file, `research/J3_THE_DECISION_QUEUE.md`, and the
  code and data files named above.

## Owned files

```
research/C47_THE_CHALLENGER.md
research/C47_DIGEST.md
```

## Parse gate

None — this task owns no script.

## Test

None. Research task.

## The one trap

**A number you cannot source is the thing this desk exists to refuse.** If the
honest answer to "how long may a champion sit" is that no promotion publishes
one, then the recommendation is a data-authored window with a comment saying it
is authored — not a figure dressed up as a rule.

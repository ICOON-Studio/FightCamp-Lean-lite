# K27 — STANCE AND THE SOUTHPAW

**Kalli, 2026-09-10. Research only.**

> **Provenance note, stated rather than smoothed over.** Kalli delivered K27 in
> chat and never pushed a file, unlike J15/M14/J16 which landed on disk. This
> document is the **captured tail of that chat** — the decision, the evidence
> bands, the refusals and the full source list, which is the actionable content.
> The long-form body (the per-question prose) was above the captured window and
> is **not** reproduced here. Everything below is Kalli's text.

---

## DECISION

**Assign 2 southpaws of the twelve** (preferred default), **or 3 if the roster is
elite-skewed.** Optionally **0–1 switcher** with a declared primary stance.
Spread them across sexes and disciplines **without inventing per-division quotas**
beyond what Loffing supports.

**Mirror the clips. Leave switching rare.**

## Evidence band for pure southpaw

| Population | Share | Of twelve |
|---|---|---|
| Broad pro boxing / MMA | ~16–20% | ~2 / 12 |
| Elite boxing, top tiers | ~20–25% | ~2–3 / 12 |
| Female-boxing-like | ~12.5% | toward 2 / 12 if the six women pull the mix down slightly |
| **50%** | **unsupported by every sourced sample above** | — |
| **0 / 12** | **contradicts every pro sample** | — |

## REJECTS, BY NAME

Kalli refused each of these explicitly rather than picking a number:

- Averaging 17% and 25% into one "true" rate.
- Using **writing-handedness (~10–13%) as fight stance**.
- **Muay Thai southpaw prevalence — not found.**
- **Kickboxing southpaw prevalence — not found.**
- Treating BetMMA switch tags as mid-round switch frequency.
- A single shipped "southpaw win advantage %".
- An all-orthodox roster "until the engine cares" — **the picture already cares.**
- Half the roster southpaw "for interest".

## Sources (all read 2026-09-10 unless noted)

- Sorokowski et al. 2014 — https://doi.org/10.2478/anre-2014-0025
- Loffing & Hagemann 2015 — https://doi.org/10.1080/1357650X.2014.961471
- Loffing, Sölter & Hagemann 2014 — https://doi.org/10.1371/journal.pone.0105800
- Baker & Schorer 2013 — https://doi.org/10.1371/journal.pone.0079793
- Richardson & Gilman 2019 — https://doi.org/10.1038/s41598-019-51975-3
- Pollet et al. 2013 — https://doi.org/10.1016/j.anbehav.2013.07.026
- BetMMA stance stats — https://www.betmma.tips/mma_fighter_stance_statistics.php
- FightAlpha (article 2026-06-25) — https://fightalpha.com/articles/southpaw-advantage-ufc
- Cardiff Met thesis — http://hdl.handle.net/10369/4967
- Ring Kong stance note (2026-06-08) — tactical geometry only

---

## What this means for the build (Claude's reading, not Kalli's)

Two things, and they point in opposite directions on cost:

1. **The engine does not model stance at all.** The athlete record carries one
   (`FightSimulation.gd:928` reads `athlete.get("stance", "ORTHODOX")`), but the
   real-time engine never reads it — grep confirms the only "stance" it knows is
   a grappling posture. So assigning southpaws changes the PICTURE before it
   changes the fight.

2. **"Mirror the clips" is a clip-list cost, and G46 confirms it from the other
   side.** G46 found an indie title that shipped the pose-only mirror: the
   fighter stood southpaw and still threw orthodox punches, hands and hips
   disagreeing, until the studio duplicated the controller and mirrored the whole
   clip set. **A mirrored skeleton pose is not enough.** So a southpaw is a
   second clip set, not a flag — which is exactly the kind of thing worth knowing
   before the purchase rather than after.

`FightStageDirector.hand_for()` currently names "lead" and "rear" as the near and
far hand of whatever stance the caller mounts, and deliberately makes no claim
about which glove that is. That stays correct under either decision.

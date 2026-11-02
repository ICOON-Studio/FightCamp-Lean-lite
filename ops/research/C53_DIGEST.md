# C53 DIGEST — The Belt Nobody Sanctions

**Landed:** 2026-09-08
**Scope:** research only; two markdown files, no runtime or data changes.

## Decision

Keep boxing's twelve standing championship belts unsanctioned for now and
display `no sanctioning body`. R70 made the empty `organization_id` deliberate:
boxing is `sanctioning_body`, while J3 D4 keeps WBA/WBC/IBF/WBO out and no
generated market association may be substituted.

The only clean future authority is a deliberately fictional, text-only body
(working name `FightCamp Boxing Authority`) with real gameplay: published
ratings, a named mandatory challenger, eliminators, a defence window,
approval/refusal, sanction fees, appeals and vacancy/stripping rules. A name
without those powers is not worth modelling.

## Findings

- Sanctioning bodies differ from promoters by owning/recognizing the title,
  publishing ratings rules, designating mandatory challengers, sanctioning or
  refusing title contests, collecting disclosed fees and withdrawing
  recognition. See [15 U.S.C. §6307c](https://uscode.house.gov/view.xhtml?req=%28title%3A15+section%3A6307c+edition%3Aprelim%29),
  [ABC ratings criteria](https://www.abcboxing.com/abc-ratings-criteria/),
  [WBC rules](https://wbcboxing.com/en/download/wbc-rules-and-regulations/)
  and [IBF rules](https://www.ibf-usba-boxing.com/wp-content/uploads/IBFChampionshipContestRules06_25.pdf).
- Mandatory status is not simply rank one: WBC rules allow designation or an
  elimination route and retain discretion; IBF uses a leading available
  contender with six-month initial and no-more-than-nine-month recurring
  windows in the cited rules.
- Regional/national titles are a real middle ecosystem, but not a universal
  novice-to-world ladder. WBC's [affiliated titles](https://wbcboxing.com/en/about-us-affiliated-titles/)
  and the [BBBofC rules](https://www.bbbofc.com/build/documents/Rules_and_Regulations_2025.pdf)
  support the pattern; project policy still forbids adding those real bodies.
- A promoter-owned title has precedent: official UFC material calls the
  `Zuffa Boxing World Championship` a Zuffa title. It is a house title, not
  proof of independent sanctioning governance; see [Zuffa Boxing results](https://www.ufc.com/news/zuffa-boxing-10-results).
- WBC-style ratings are best classified `mixed`; ABC's record/competition/
  activity rules are specific enough to implement for a future authored body
  if all tie-breaks and exceptions are made explicit.

## Price and migration

| Option | Build | Honesty | Existing saves |
|---|---|---|---|
| Authored fictional sanctioning body | High | Clean only with full rules | Leave old empty belts unsanctioned; opt in future titles |
| Promoter-owned house title | Medium-low | Honest only as a house title | Additive and distinct; do not relabel old belts |
| Explicitly unsanctioned | Low | Cleanest | No migration |
| Regional/national layer | High | Real pattern, but authored names required | Additive separate title family |

## Non-decisions

No alphabet-body alias, generated-association fallback, retroactive authority
stamp, universal ladder claim, grade/belt-colour work, invented UNKNOWN
numbers, artwork, code, JSON or tests.

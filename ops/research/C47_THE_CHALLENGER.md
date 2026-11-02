# C47 — The challenger, and how long a champion may sit

**Research cutoff:** 2026-09-08
**Scope:** J3 calls 2, 3 and 8/D5. Research only; no gameplay or data writes.

## Decisions page

| Call | Recommendation | Why |
|---|---|---|
| Mandatory vs discretionary challenger | **Discretionary by default for house promotions. Do not auto-promote #1 to a title shot.** A mandatory challenger is an explicit, sourced organization rule; none is sourced for the catalogue's 13 house promotions in this pass. | Rankings inform booking, but J3 D1 makes the title-bout flag the authority. GLORY's current rules expressly leave rankings and title administration to GLORY's discretion. |
| Champion inactivity | **Use a data-authored availability window, not a claimed real-world number.** Keep the current eight-week game window labelled authored; its expiry creates eligibility for an interim, not an automatic stripping. | GLORY publishes a four-month defense requirement, but UFC and the other house promotions do not provide a comparable public day/week clock in the reviewed primary material. |
| Ranking method / D5 | **Store `ranking_mode ∈ {discretionary, published_criteria, mixed}`. Never reverse-engineer a formula.** Keep unknown weights/formulae UNKNOWN. | The catalogue mixes media panels, published points systems and explicit discretion. A result-shaped formula would be an invented claim, not evidence. |

## Evidence and UNKNOWN discipline

### Ranking method by catalogue organization

The table covers all 18 entries in `real_organizations.json`. `published_criteria`
means a primary rules/ranking document publishes a points or criteria system;
`discretionary` means the published method is a panel or an express grant of
organizational discretion. It does **not** mean that the game should implement
the method numerically.

| Organization | Entity | Published method found | Recommended mode | Evidence / boundary |
|---|---|---|---|---|
| UFC | promotion | Media panel vote. Separately, Meta UFC Rankings describe a qualitative mathematical model driven by opponent, win type and recency, but publish no weights. | `discretionary` for the media board; `published_criteria` for Meta with formula UNKNOWN | [UFC rankings](https://www.ufc.com/rankings) |
| PFL | promotion | Combat Registry administers vote collection and tabulation; MMA journalists and industry experts ballot after each event. | `discretionary` | [PFL's official 2026 rankings announcement](https://pflmma.com/news/professional-fighters-league-introduces-independent-fighter-rankings-powered-by-combat-registry) |
| ONE | promotion | ONE's official ranking announcement describes an independent media/industry panel considering wins/losses, recent performance and opponent quality. The current 2026 page announces refreshed rankings but does not publish a new formula. | `discretionary` (last explicit primary method; current refresh details UNKNOWN) | [ONE ranking announcement](https://www.onefc.com/jp/press-releases/ranking/); [current rankings page](https://www.onefc.com/rankings/) |
| RIZIN | promotion | No current primary ranking formula or panel rule located. | `discretionary` only as the J3 default for an unscoped house board; published method UNKNOWN | The catalogue's official organization identity is not evidence of a ranking method. |
| GLORY | promotion | GLORY Rules 2026 v2: GLORY has discretion to determine rankings using a variety of judging points and may consider fights outside GLORY. | `discretionary` | [GLORY Rules 2026 v2, §5.09](https://glory.pinkyellow.network/assets/rules/glory-rules-2026-v2.pdf) |
| Karate Combat | promotion | No current primary ranking method located. | `discretionary` default; published method UNKNOWN | Do not infer a formula from the displayed standings. |
| Cyprus MMA Federation (CMMAF) | federation | No professional ranking method located; the catalogue evidence is an amateur IMMAF inheritance. | `published_criteria` is not established; ranking method UNKNOWN | A federation ranking is not a house-promotion title-shot ladder. |
| Jungle Fight | promotion | No current primary ranking method located. | `discretionary` default; published method UNKNOWN | Do not inherit UFC or GLORY practice. |
| IBJJF | tournament operator | Official points system: placing points multiplied by championship and season weights, with current and prior seasons included according to the published version. | `published_criteria` | [IBJJF Athlete Ranking Information](https://ibjjf.com/athlete-ranking-info) |
| Rajadamnern World Series (RWS) | promotion | No current primary ranking method located. | `discretionary` default; published method UNKNOWN | RWS's event identity does not publish a challenger formula here. |
| LUX Fight League | promotion | No current primary ranking method located. | `discretionary` default; published method UNKNOWN | UNKNOWN is preferable to borrowing a Mexican commission or UFC formula. |
| ROAD FC | promotion | No current primary ranking method located; the catalogue itself flags conflicting secondary material about its points overlay. | `discretionary` default; published method UNKNOWN | Conflicting secondary claims are not a published rule. |
| Kunlun Fight | promotion | No current primary ranking method located. | `discretionary` default; published method UNKNOWN | Do not turn a K-1 analogue into a Kunlun formula. |
| United World Wrestling (UWW) | federation | Ranking Rule Book publishes event classes, points, best-result counting and seeding use. | `published_criteria` | [UWW Ranking Rule Book](https://cdn.uww.org/2024-01/ranking_series_rules.pdf) |
| International Judo Federation (IJF) | federation | Official 2026 explanation publishes event points, 100%/50%/expiry treatment and tie-break hierarchy. | `published_criteria` | [IJF 2026 World Ranking Season](https://www.ijf.org/index.php/news/show/understanding-the-2026-ijf-world-ranking-season) |
| World Taekwondo (WT) | federation | WT Ranking Bylaw publishes event grades, rank points, validation/deduction and update rules. | `published_criteria` | [WT Ranking Bylaw, in force June 1 2024](https://www.worldtaekwondo.org/att_file/documents/WT%20Ranking%20Bylaw%20%28June%201%2C%202024%29.pdf) |
| ARES Fighting Championship | promotion | No current primary ranking method located. | `discretionary` default; published method UNKNOWN | Do not infer a French federation rule as an ARES ranking rule. |
| URCC | promotion | No current primary ranking method located. | `discretionary` default; published method UNKNOWN | The catalogue's regulatory note is not a ranking method. |

The Meta UFC board is the important D5 trap: the official page says the model
uses who was faced, how the fight was won and when it happened, with decay and
inactivity penalties, but it does not publish coefficients. The correct stored
answer is qualitative criteria plus UNKNOWN weights, not a formula recovered
from standings.

### Mandatory challengers

No catalogue house promotion has a sourced, binding “#1 is mandatory” rule in
the primary material reviewed here.

- UFC's official page documents a media vote and champion/interim placement; it
  does not create a mandatory challenger. A ranking position is therefore not a
  booking entitlement.
- PFL's official 2026 rankings announcement documents a journalist/industry
  panel. PFL's tournament route is a bracket/season object, not a universal
  #1-mandatory rule.
- ONE's official ranking announcement describes the panel and factors, not a
  mandatory-shot clock. The current rankings page announces refreshed rankings
  without publishing such a rule; the mandatory status is UNKNOWN.
- GLORY's current rules give GLORY discretion over rankings and title handling;
  they do not say that #1 must receive the next title bout. This is not the same
  as saying GLORY has no internal booking practice.
- RIZIN, Karate Combat, Jungle Fight, RWS, LUX, ROAD FC, Kunlun, ARES and URCC:
  mandatory policy UNKNOWN. No result-derived inference is allowed.

Boxing-alphabet mandatories are deliberately outside this catalogue. The IBF
rules are a useful contrast: Rule 17 publishes an interim mandatory path and an
18-month cap, while its ratings criteria also retain an exceptions clause. The
WBC rules contrast with a six-month interim condition and a vacancy estimate
over one year, while stating that #1 is not necessarily the official mandatory.
Those are sanctioning-body rules, not a house-promotion default. See the
[IBF championship rules](https://www.ibf-usba-boxing.com/wp-content/uploads/IBFChampionshipContestRules06_25.pdf),
[IBF ratings criteria](https://www.ibf-usba-boxing.com/wp-content/uploads/RatingsCriteriawithJune2025Amendment.pdf)
and [WBC championship rules](https://www.wbcboxing.com/downloads/NEW_RULES_AND_REGULATIONS_WEB_FINAL_2009.pdf).

### Inactivity and interim clocks

GLORY is the only catalogue house promotion for which this pass found a
published inactivity/defense clock: its 2026 rules say a champion may be required
to defend at least once every four months; if the champion cannot defend or
refuses an opponent/event/tournament, GLORY may declare the title vacant at its
discretion, and may approve an interim title at any time. The rule does not make
#1 mandatory.

For UFC, PFL, ONE, RIZIN, Karate Combat, Jungle Fight, RWS, LUX, ROAD FC,
Kunlun, ARES and URCC, a single published inactivity day/week count was not
located. The answer is UNKNOWN, not zero and not a guessed shared industry
clock. The federation/tournament organizations are not house champions with a
comparable belt-sitting rule.

The WBC six-month / one-year and IBF 18-month figures above remain comparison
evidence only. They do not authorize a universal number for the 13 promotions.

## What the game does today

### Rankings

`WorldPopulation.division_rankings` filters retired athletes and then matches
discipline, class and sex (`WorldPopulation.gd:1529-1545`). It sorts the pool
by `_leaderboard_points` (`:1546`), places the belt holder first when present,
and emits `ranking_points`, record, title-fight count and movement in each board
entry (`:1551-1570`, `:1573-1584`). There is no organization-specific ranking
source, panel, criteria set or `ranking_mode` in this seam.

`p4p_rankings` repeats the same `_leaderboard_points` sort across all non-retired
athletes, optionally sex-filtered (`WorldPopulation.gd:1587-1616`).
`ranking_snapshot` builds every discovered division and three P4P lists from
those functions (`:1619-1639`). This is a live gameplay leaderboard, not a
claim that UFC, PFL, ONE or a federation uses the same points.

`GameState.get_division_rankings` and `get_p4p_rankings` simply pass the world,
the player's roster, a limit, “ours” markers and previous snapshots into those
functions (`GameState.gd:10444-10457`). `_refresh_ranking_snapshots` stores
previous/current board IDs (`:10475-10478`). The title read uses the same
division ranking to populate contenders and separately indexes promotions
(`GameState.gd:10524-10542`); it does not decide a mandatory challenger.

### Title stakes and inactivity

`get_bout_title_stakes` is a copy-safe read over the event, championship map and
available athletes, delegated to `ChampionshipRead.bout_stakes`
(`GameState.gd:10803-10810`). Its callers read the booking-time title flag;
they do not select a challenger or apply an organization ranking method.

The interim seam is real but authored:

- `may_crown_interim` requires a non-vacant holder and
  `hold_weeks_left(holder, week) >= championship_rule("interim_hold_weeks", 8)`
  (`WorldPopulation.gd:1241-1250`).
- A booking between two non-champions is eligible only while that condition is
  true (`:1258-1275`).
- Settlement stores `title_status = "interim"`, interim holder identity and
  `interim_since_week` on the **same belt entry** (`:1383-1416`).
- The next title fight consumes those interim fields and restores champion status
  (`:1289-1299`); vacancy elevation also prefers the interim holder
  (`:1471-1489`).

`championship_rules.json:3-6` makes the boundary explicit: `interim_hold_weeks`
is **8**, the note calls it a “GAME RULE” and says no sanctioning body publishes
a week count for this condition, and the interim is never a second keepable belt.
The number is therefore authored, not sourced. The code correctly keeps it
data-authored; the missing piece is an evidence/mode read that tells an operator
which parts are sourced organization policy and which are the game's policy.

### Honest / invented / absent

| Surface | Today | Classification |
|---|---|---|
| Division and P4P ordering | `_leaderboard_points` sort with snapshots/movement | **Invented gameplay method**, honest only when labelled as such |
| Organization ranking mode | No per-organization method field in the inspected seams | **Absent** |
| Mandatory challenger | No mandatory-challenger decision in the inspected reads | **Absent**; default recommendation is discretionary booking |
| Interim eligibility | Holder availability plus authored eight-week window | **Live and invented as a number**, with the data file honestly labelled |
| Interim representation | One belt entry, temporary holder fields, consumed on champion fight | **Live and consistent with J3 Q3** |
| Bout stakes | Read of the stamped title flag and belt state | **Live read**, not a challenger policy |

## Minimum change / build order

1. Add organization-level `ranking_mode` using exactly
   `discretionary`, `published_criteria` and `mixed`. Store the evidence/source
   label beside it; do not store guessed coefficients.
2. Add an explicit challenger-policy read with `discretionary` as the house
   default and `mandatory` only where a future primary rule is filed. Keep
   `mandatory_clock` absent/UNKNOWN unless it is sourced. #1 remains an input
   to booking, not an automatic title-bout flag.
3. Keep `interim_hold_weeks` in championship rules as the authored simulation
   window. Preserve the existing eight-week value unless a design pass changes
   it; never relabel it as UFC, GLORY, WBC or IBF law. If org-specific clocks are
   ever added, make them explicit per organization and evidence-backed.
4. Teach ranking and championship reads to expose the mode/evidence labels so a
   UI or operator can distinguish gameplay points from a published federation
   ranking. Do not make the Meta UFC description executable while its weights
   remain UNKNOWN.
5. Add focused contracts later for: no automatic #1 shot, no formula claim for
   UNKNOWN methods, authored-window interim creation, and interim consumption on
   the champion's next title fight. No tests were run for this research task.

## Sources

Primary organization sources are linked inline above. The prior decision boundary
and UNKNOWN policy are [J3_THE_DECISION_QUEUE.md](J3_THE_DECISION_QUEUE.md),
especially D1, D2, D5 and Area 1. The organization identities and catalog
entity types are `Godot/assets/data/real_organizations.json` (snapshot
2026-09-01). Boxing-alphabet sources are comparison only and do not expand the
catalogue.

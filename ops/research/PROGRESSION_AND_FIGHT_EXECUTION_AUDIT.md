# Progression and Fight-Execution Audit

Part of the CLAUDE RESEARCH ASSIGNMENT (see `HANDOFF.md`, 2026-08-30). Audits
Codex's proposals A, B, D, E against the actual numbers already committed in
`athlete_progression_rules_v1.json` and `technique_catalog.json` v2. This is
an internal simulation/game-design audit — it does not depend on the
external competition-rules research and is not blocked by it. Where a
conclusion *does* depend on the ruleset research (age/weight eligibility
specifics), it is marked and deferred to `COMPETITION_RULESET_RESEARCH.md`.

Status: **PROPOSAL, not final.** No runtime code changed.

## A. Physical minimums — auditing the three-layer model

Codex's recommended model (entry safety gates hard / recommended preparation
soft / advanced-technique safety thresholds hard-contextual) is sound and
matches how the *existing* catalog data already behaves in practice, once
you look at what the `requires.attributes` values on tier-1 nodes actually
do: they gate **training eligibility**, not real-world competition entry.
For example `boxing_stance_guard` requires `defense:20, conditioning:20` —
low enough that nearly any beginner clears it quickly, which is functionally
already Codex's "soft, falling short slows you down" layer, not a hard wall.

**Finding: the hard entry-safety layer doesn't exist yet.** There is
currently no medical-clearance field, no age-division check, and no
minimum-mobility-for-hazardous-practice check anywhere in the data or
runtime. The soft layer already exists in spirit; the hard layer is pure gap.
Recommend implementing exactly the three layers as Codex proposed, with this
concrete allocation against the new fields from `ATHLETE_MODEL_PROPOSAL.md`:

1. **Entry safety gates (hard):** `medical_clearance_status`,
   `health_injuries` (active restriction check), age-division membership
   (derived from `birth_date` against the researched ruleset's actual age
   categories — see `COMPETITION_RULESET_RESEARCH.md`). No new "minimum
   strength to start Judo" gate — none of the disciplines researched publish
   one, and inventing one would contradict the assignment's own instruction
   not to fabricate an official minimum where none exists.
2. **Recommended preparation profile (soft):** the *existing*
   `requires.attributes` values on catalog nodes, unchanged in spirit. Falling
   short should slow the `weekly_progress` rate (already true structurally,
   since a node is simply ineligible until met) rather than block training
   outright.
3. **Advanced technique safety/execution thresholds (hard/contextual):**
   apply specifically to the tier-3/4 nodes already flagged with elevated
   `power`/`speed`/`technique` requirements (`wrestling_suplex`,
   `judo_uchimata`, `tkd_spinning_hook`, etc.) — these already have high
   numeric requirements in the catalog; the only proposed change is treating
   *some* of them (specifically ones with real injury risk if attempted
   underprepared — throws and inverted/spinning strikes) as a genuine hard
   floor rather than merely slowing progress, per Codex's framing. Exactly
   which nodes get this hard/contextual treatment vs remaining soft is a
   design call this document does not make unilaterally — flagged `UNKNOWN`,
   recommend a short tagging pass (a boolean `hard_safety_floor` per node)
   during implementation, informed by the technique catalog audit.

**Verdict: adopt Codex's three-layer model as proposed.** It avoids the
"weak beginner can't start Judo" failure mode correctly, and it costs nothing
structurally since layer 2 already exists — the only real work is adding
layer 1 (currently absent) and selectively promoting a subset of layer-3
nodes from soft to hard.

## B. MMA transition gate: strict vs accessible, with worked estimates

Both interpretations are legitimate design choices; per the assignment, this
document returns the tradeoff rather than picking one.

- **Strict (current v1 design):** two *fully mastered* source disciplines
  (`discipline_mastery` definition: `proficiency_min: 70`,
  `learned_nodes_min: 6`, `advanced_or_signature_nodes_min: 1`,
  `verified_fight_uses_min: 3`), one striking family + one grappling family,
  before the MMA transition program even opens.
- **Accessible (Codex's proposed alternative):** competent/advanced (not full
  mastery) in one striking + one grappling discipline unlocks transition;
  full mastery instead reduces transition time and raises starting MMA
  proficiency.

### Worked calendar-week estimate

All numbers below use the **actual** `weekly_progress` formula and tier
defaults from `athlete_progression_rules_v1.json`, under an explicitly stated
"average support" assumption (a competent but not elite camp — this is a
game-design input, not a real-world fact):

```text
coach_factor = facility_factor = equipment_factor = partner_factor = 1.0
readiness_factor = 0.9
fight_iq_factor = 0.85 + 0.005 * fight_iq   (fight_iq ≈ 30 for an early-career athlete)
→ effective weekly rate ≈ 22 * sessions_per_week * 0.9 * 1.00

tier 1 (2 sessions/wk):  ≈ 40 progress-units/week
tier 2/3 (3 sessions/wk): ≈ 59 progress-units/week
tier 4 (4 sessions/wk):  ≈ 79 progress-units/week
```

Example path to `learned_nodes_min: 6` (incl. 1 advanced/signature node) in
one discipline, using Boxing's actual node reps and prerequisite chain
(`stance_guard → jab → cross → lead_hook → slip_counter → body_hook`):

| Node | Tier | Reps | Weeks (reps ÷ rate, floored by tier minimum) |
|---|---|---|---|
| stance_guard | 1 | 40 | 1.0 |
| jab | 1 | 80 | 2.0 |
| cross | 1 | 100 | 2.5 |
| lead_hook | 2 | 180 | 3.0 |
| slip_counter | 2 | 240 | 4.0 |
| body_hook | 3 | 360 | 6.1 |
| **Subtotal (reps/tier-time only)** | | | **≈ 18.7 weeks** |

This subtotal only satisfies `learned_nodes_min` and
`advanced_or_signature_nodes_min` — mastery also requires
`proficiency_min: 70` (a discipline-wide stat, not literally these six
nodes' reps) and `verified_fight_uses_min: 3` (three fights where the
athlete actually used techniques from this discipline, which the game's own
fight-booking cadence gates). **Neither of those two components has an
explicit formula anywhere in the current data** — this is a real gap, not an
oversight in this audit: `discipline_proficiency`'s growth curve is
unspecified. Treating it illustratively as roughly tracking cumulative
training investment across *all* learned nodes in the discipline (not just
the minimum six), plus ~8–16 weeks of realistic calendar time to actually
book and complete three fights with recovery between them, gives an
**illustrative total of roughly 30–45 weeks (7–10 months) for one
discipline's full mastery** under average support. This range is a
game-design estimate built from stated assumptions, not a certified number —
flagged `UNKNOWN` on the proficiency formula specifically; recommend Codex
define `discipline_proficiency`'s growth formula explicitly before this
estimate is treated as load-bearing.

**Strict path total:** two disciplines mastered sequentially ≈ 60–90 weeks
(14–21 months), or somewhat less with partial overlap once the first
discipline's Foundation tier is done (Codex's own progression path already
implies this — cross-training in a second art starts once "competency/
mastery" not "the moment the game begins"). Plus the 12-week MMA transition
floor (see the internal-consistency finding just below) → **~72–100+ weeks
(1.4–2 years) before amateur MMA eligibility.**

**Accessible path total:** if "competent/advanced" means roughly the same
node/reps investment as one discipline's Foundation+Core tiers without the
fight-verification requirement, that's closer to the ≈18.7-week subtotal
above **per discipline**, i.e. **≈35–55 weeks (8–13 months)** for both
disciplines before transition, **~47–70 weeks (11–16 months) total** —
noticeably friendlier to a fighter who wants to reach MMA without two full
separate careers first, while still requiring real investment in both a
striking and a grappling base.

**Recommendation:** the accessible variant fits the stated goal better
("avoids an excessively long pre-MMA game" for fighters who want to start
toward MMA directly) without removing the strict path's value — implement
both, with full mastery of both source disciplines granting the transition
program's stated benefits (reduced time, higher starting proficiency, access
to "elite chains" i.e. the tier-4 MMA nodes) rather than being a prerequisite
to start it at all.

### Internal consistency finding: the 12-week MMA transition floor

The `mma_transition.program` block specifies
`minimum_total_calendar_weeks: 12` and `required_total_progress_units: 1200`,
with `minimum_calendar_weeks_can_be_bypassed: false`. Checking whether 1200
units is actually reachable in 12 weeks under the same weekly-rate model used
above: the three phases (4+4+4 weeks) imply roughly 3–4 sessions/week
depending on tier defaults, i.e. a weekly rate in the ~59–79 unit range under
"average support," peaking higher only under excellent conditions (coach,
facility, partner factors all near the top of their [0.65–1.3] ranges, plus
high `fight_iq_factor`). At the "average support" rate used throughout this
document, 12 weeks yields roughly **710–950 progress units**, short of the
1200 required — meaning a typical (non-elite-support) athlete will actually
take **~15–20 weeks**, not 12, to clear the transition program, even though
12 is stated as the floor. This isn't necessarily wrong — "12 weeks" reads
correctly as a *floor only an excellent camp can hit*, similar to how a real
fight camp's minimum length assumes strong training conditions — but it's
worth Codex confirming that's the intended reading rather than an
accidental mismatch between the stated floor and the weekly-progress formula,
since as written the 12-week number will rarely be the binding constraint in
practice.

## D. Fight plan and current-execution formulas

The proposed action-gate order (learned → legal → phase/position/target
valid → body part usable → stamina above floor → execution attributes pass
→ AI assigns weight) is the right shape: it correctly orders a hard
knowledge gate before a hard legality gate before soft tactical weighting,
which prevents an athlete from ever being simulated attempting something
they haven't learned or that's illegal in that ruleset, while still letting
mastery smoothly affect *how well* a legal, known, appropriate action lands.

**Audit of the suggested formulas** (explicitly marked in the assignment as
"for audit, not final truth"):

```text
effective_execution_requirement = max(safety_floor, base_requirement * (1 - 0.20 * mastery_norm))
effective_stamina_cost = base_stamina_cost * (1 - 0.25 * mastery_norm) * fatigue_modifier * injury_modifier * failed_setup_modifier
action_weight = tactical_base * ruleset_legality * opportunity_fit * current_execution_quality * fight_plan_priority * opponent_vulnerability * score_and_time_urgency * stamina_affordability
```

- The 20%/25% mastery caps are conservative and reasonable — they let
  mastery meaningfully help without ever removing the safety floor or making
  a technique free, matching the assignment's own stated intent. **No change
  recommended to the cap values themselves** pending actual simulated-fight
  testing (which this research pass did not run — flagged as follow-up work
  before caps are treated as final).
- **Risk with the fully multiplicative `action_weight` formula:** it chains
  seven factors together. If several sit in the 0.6–0.8 range simultaneously
  (a very plausible mid-fight state — moderate opportunity fit, moderate
  urgency, moderate stamina), the product can collapse toward a very small
  number even though no single factor was actually disqualifying, which can
  produce an AI that never seems to *want* to do anything except the one or
  two actions where every factor happens to be high. Recommend one of: (a)
  clamp each factor to a stated minimum floor (e.g. 0.35) so no factor alone
  can crush the product to near-zero, or (b) compare weights via softmax
  across the *eligible* action set (post-hard-gate) rather than reading the
  raw product as an absolute probability, so relative ranking stays sane even
  when all raw products are small. Either fixes the failure mode; (b) is
  closer to how these formulas are typically consumed downstream (as ranking
  weights, not literal probabilities), so it's the lighter-touch fix.
- `PRIMARY`/`SECONDARY`/`OPPORTUNISTIC`/`EMERGENCY`/`AVOID` as a
  `fight_plan_priority` multiplier is a good, simple way to keep the plan a
  "preference not mind control," matching the assignment's own framing.
  Suggested starting multipliers (a tuning question, not a research finding):
  `PRIMARY ×1.3–1.5`, `SECONDARY ×1.0`, `OPPORTUNISTIC ×0.8` (only fires on a
  clearly good opportunity, per `opponent_vulnerability`/`score_and_time_urgency`
  being high), `EMERGENCY ×1.0` but only eligible when a defined trigger
  state is active (badly hurt, losing on the cards late), `AVOID ×0.15` (near
  zero but not literally zero, so a sufficiently extreme opportunity can still
  override a standing instruction — matches "the plan is a preference, not
  mind control").
- Every proposed per-move metadata field (base stamina/energy cost, execution
  attributes + safety floor, mastery efficiency caps, phase/range/position/
  target/setup requirements, risk-on-failure/counter-vulnerability/injury
  tags, fight-plan category, legal ruleset IDs) is necessary and matches what
  the action-gate order actually needs to check — no additions or removals
  proposed to this field list.

## E. Fight IQ, fame, and promotion access

- **Derived Fight IQ as a scouting/interest signal rather than an absolute
  contract gate:** agreed, and correctly reasoned — no researched governing
  body publishes anything resembling a numeric "Fight IQ" signing threshold
  (this is necessarily a Fight-Camp-only invention; real promotions weigh
  marketability, style matchups, connections, and opportunistic replacement
  bookings that a single derived number can't capture). Recommend keeping
  `promotion_access.tiers[].fight_iq_min` as a *soft consideration threshold*
  feeding `contract_interest`'s existing `0.15 * fight_iq` term, while
  loosening the tier gate itself: an athlete slightly under a tier's
  `fight_iq_min` but strong elsewhere should still be able to generate
  interest through the existing `prospect_exception` mechanism, or a similar
  narrower exception, rather than hitting a hard wall. Safety/experience
  requirements (`completed_fights_min`, medical, ruleset eligibility) should
  stay hard, exactly as designed — those *are* the kind of thing real
  promotions and commissions actually gate on.
- **Fame requiring public proof:** the existing `discipline_mastery_bonus`
  (awarded once per discipline, requiring the full mastery definition
  including `verified_fight_uses_min`) already ties fame to demonstrated,
  witnessed competence rather than private gym progress — this is correctly
  designed already and needs no structural change. The
  `anti_exploit` list (diminishing returns vs overmatched opponents,
  cancelled/exhibition fights never counting) is sound and standard practice
  for anti-farming systems; no changes recommended.
- **Keeping fame, ranking, competitive merit, marketability, and gym
  reputation distinct:** already a stated design principle and already
  reflected in `profile_ui`'s separate `fame_band`, `mastered_disciplines`,
  and `next_promotion_tier` fields. No change recommended — this section of
  Codex's design was already correct; this audit's job here is to confirm
  it, not find something to fix.
- **Real organization trademarks:** `licensed_name_policy` already states the
  correct rule (fictional names unless separately licensed, `UFC-like`
  mapped conceptually to `global_elite`). No change recommended.

## Summary of open items requiring a user/design decision

1. `discipline_proficiency`'s actual growth formula is unspecified — needed
   before the section B calendar-week estimates can be treated as more than
   illustrative.
2. Which tier-3/4 catalog nodes get the *hard* advanced-technique safety
   floor (section A layer 3) vs remain soft — needs a tagging pass, informed
   by `TECHNIQUE_CATALOG_AUDIT.md`.
3. Strict vs accessible MMA transition gate — this document recommends
   accessible, but per the assignment this is the user's call, not a
   decision made unilaterally here.
4. The 12-week MMA transition floor likely needs either a faster achievable
   weekly rate during that program or an explicit acknowledgment that 12
   weeks is a best-case floor, not a typical outcome.
5. `action_weight`'s multiplicative-collapse risk (section D) — recommend a
   floor-clamp or softmax fix before this formula is implemented as literal
   AI decision weights.

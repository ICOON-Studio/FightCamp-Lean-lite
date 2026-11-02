# Athlete Model Proposal

Part of the CLAUDE RESEARCH ASSIGNMENT (see `HANDOFF.md`, 2026-08-30). Research
and proposal only — no runtime/save code is changed by this document.

Status of this document: **PROPOSAL, not final.** It answers assignment
question 4 (new athlete parameters) and section C (parameter taxonomy). It is
written to compile cleanly against `COMPETITION_RULESET_RESEARCH.md`'s actual
findings, but does not itself invent ruleset-specific numbers (weight-class
boundaries, age-division cutoffs) — those come from the research doc and are
only referenced here by shape, not value.

## 1. Why the current model is insufficient

Current runtime athletes (`GameState.gd`) store: integer `age`, a display
`weight_class` string, one `primary_discipline`, a `specialties` dictionary,
five broad trainable stats (`power`, `technique`, `speed`, `defense`,
`conditioning`) plus a randomly-seeded `fight_iq`, `potential`, W-L-D record,
`fatigue`, and `morale`. There is no birth date, height, reach, stance,
walking/competition weight, belt/rank, or division eligibility data anywhere.
No production system currently checks ruleset legality, age/weight
eligibility, or per-technique stamina cost — none of that data exists to
check against.

`athlete_progression_rules_v1.json` already anticipates most of this gap in
its `save_migration.new_athlete_fields` list (`attribute_ceilings`,
`discipline_proficiency`, `discipline_mastery_awards`, `learned_techniques`,
`technique_progress`, `fight_iq_components`, `fight_iq_evidence_confidence`,
`fame`, `fame_history`, `mma_transition`) — this proposal is additive to that
list, focused specifically on identity/body/state fields it does not cover.

## 2. Proposed field taxonomy

Grouped exactly as the assignment's section C requests. Every field below
states its purpose (what simulation or eligibility decision it drives) —
per the assignment's instruction, nothing is added without a stated use.

### 2.1 Identity/body — set once, changes rarely if ever

| Field | Type | Purpose |
|---|---|---|
| `birth_date` | ISO date (in-career calendar) | Age is *derived* each week from this, not stored as a mutable integer. Required for every real federation's age-division eligibility (see ruleset research for actual cutoffs). |
| `sex_or_competition_division` | enum, federation-defined | Several researched federations run separate men's/women's competition and, in a few cases, separate rule variants by division (confirm per-ruleset in the research doc). Drives which ruleset-division row applies. |
| `height_cm` | float, metric canonical | Used for reach-estimation fallback, some judging aesthetics call it out, and MMA broadcast-style profile display. Not an eligibility gate in any researched ruleset so far. |
| `reach_cm` | float, metric canonical | Boxing/MMA commonly display and lightly weight this in simulation (range-control effects already exist in `technique_catalog.json` `match.effects`, e.g. `range_control`). |
| `frame_natural_weight_range_kg` | `[min, max]` float pair | Not a competition rule — a game-simulation input: how far an athlete can safely cut/bulk from their natural frame before conditioning/health penalties apply. Distinct from a competition weight-class rule. |
| `dominant_side` | enum `orthodox` / `southpaw` / `ambidextrous` | Already implied by existing partner role tags (`southpaw`, `orthodox` appear in `athlete_progression_rules.json`'s `partner_matching.role_tags`) but never stored on the athlete itself — needed to actually match against those tags. |
| `stance_family` | enum, discipline-scoped | Distinct from `dominant_side`: e.g. a wrestler's stance vs a striker's guard is a different concept from lead-hand side. Only needed if a discipline's technique eligibility ever keys off it (none currently do in the 150-node catalog — **flagging as `UNKNOWN`/deferred**: propose the field, but recommend not populating discipline-specific stance logic until a real node requires it, to avoid unused complexity). |

### 2.2 Trainable physical — the actual substrate stats

Replaces the flat `power`/`technique`/`speed`/`defense`/`conditioning` five
with the assignment's suggested finer set, since those five conflate several
independently-trainable qualities (the assignment's own audit note: *"current
`power` conflates strength/explosiveness/technical delivery; current
`conditioning` conflates aerobic endurance, anaerobic work and recovery"*).

| Field | Replaces / relates to | Purpose |
|---|---|---|
| `strength` | part of old `power` | Feeds `striking_power`, throw/takedown execution requirements. |
| `explosive_power` | part of old `power` | Feeds burst actions (level changes, spinning strikes) distinctly from raw strength. |
| `speed` | old `speed` (kept, narrowed) | Pure movement/strike speed, no longer also carrying reaction/technical load. |
| `agility` | new, split from old `speed` | Change-of-direction, footwork-heavy techniques (capoeira, savate, taekwondo all lean on this per their catalog nodes' `speed`+`technique` pairing). |
| `balance` | new | Explicitly needed by the assignment's advanced-technique safety gate (throws, spinning kicks) and by several catalog `match.effects` like `balance_break`. |
| `coordination` | new | General technical-learning-rate modifier; distinct from any single discipline's `technique` stat. |
| `mobility_flexibility` | new | Kicking-height/range techniques and safe-training gating for high-risk stretches (splits kicks, some Judo/Sambo positions). |
| `aerobic_endurance` | part of old `conditioning` | Multi-round output, per the assignment's split. |
| `anaerobic_conditioning` | part of old `conditioning` | Short-burst output (a takedown scramble, a finishing sequence) distinct from round-length endurance. |
| `recovery_capacity` | part of old `conditioning` | Between-round and between-session recovery rate; feeds `fatigue` decay rate and injury-risk-under-fatigue. |

`technique` and `defense` are **not kept as global stats**. Per-discipline
technical proficiency already exists structurally as each catalog node's
`requires.discipline` threshold — this proposal formalizes that into a
first-class `discipline_proficiency: {discipline_id: 0..100}` map (already
listed in `athlete_progression_rules.json`'s migration field list) rather
than inventing a new global number. Defense becomes a *derived* value (see
2.6), since real defensive execution is phase/discipline-specific (a BJJ
guard-retention defense is not the same substrate as a boxing slip).

### 2.3 Current state — changes week to week or fight to fight

| Field | Purpose |
|---|---|
| `current_weight_kg` | Actual current body weight; drives whether a cut is needed for a booked competition weight class. |
| `target_competition_weight_kg` | Set per booking; distance from `current_weight_kg` drives the cut/hydration model. |
| `hydration_or_cut_status` | enum `normal` / `cutting` / `depleted` / `rehydrated` — only meaningful in the days around a weigh-in; short-lived state, not a permanent attribute. Whether this is *justified* at all (vs a simpler "weight-cut penalty" scalar) is flagged `UNKNOWN` pending user direction — it adds realism but also UI surface; recommend starting with a scalar penalty and only expanding to the full enum if playtesting shows the simpler version feels shallow. |
| `weight_history` | array of `{week, weight_kg}` | Needed to detect unsafe/impossible cuts and to support a "walking weight" display distinct from fight-week weight. |
| `fatigue` | kept from current model | Already exists; now also read by the per-move `effective_stamina_cost` gate (assignment section D). |
| `health_injuries` | replaces the current single `status` flag | A structured list (per-injury: body part, severity, expected recovery week, whether it blocks specific techniques) rather than one global `"injured"` string, since the assignment's action-gate step 4 requires knowing *which* body part is compromised, not just that the athlete is generically hurt. |
| `morale` | kept from current model | Unchanged. |
| `confidence` | new, distinct from morale | Morale is about gym/career satisfaction; confidence is fight-specific self-belief that should swing faster (a big win/loss) and feed a different simulation knob (risk-taking tendency in a bout) than morale's slower gym-management signal. |
| `technique_sharpness` | new, per learned technique or per discipline | Already implied by `athlete_progression_rules.json`'s `sharpness_can_decay_after_learning: true` design principle, but no field currently stores it. Feeds the mastery-efficiency formulas in section D of the progression audit. |

### 2.4 Mental/tendency — slow-moving personality-like traits

| Field | Purpose |
|---|---|
| `composure` | How much performance degrades under adversity (badly hurt, losing rounds). |
| `determination` | Recovery-of-effort after a bad moment; comeback tendency. |
| `adaptability` | Speed of in-fight game-plan adjustment; also feeds the existing `cross_discipline_transfer_factor` in `fight_iq.development_effects`. |
| `work_discipline` | Training-session reliability/quality; a soft multiplier on weekly progress independent of physical attributes. |
| `aggression_risk_tendency` | AI action-selection bias toward `PRIMARY`/`OPPORTUNISTIC` high-risk actions vs `AVOID`; directly consumed by the fight-plan action-weight formula (section D). |
| `coach_trust` | Per-athlete-per-coach relationship value; gates how much of a coach's own rating actually transfers into that athlete's training factors, distinct from the coach's raw skill. |

These five are genuinely new scope, not a renaming of something that exists.
Recommend treating them as slow-drifting values seeded at career start and
nudged by outcomes, not directly trainable stats — flagging this as a
**game-design choice**, not a real-world requirement, since no governing body
publishes psychological eligibility criteria.

### 2.5 Knowledge — what the assignment's own migration list already covers

`discipline_proficiency`, `learned_techniques`, `technique_progress` (partial
reps/weeks per in-progress node), `discipline_mastery_awards`,
`verified_fight_uses` (per technique, needed for the mastery definition's
`verified_fight_uses_min: 3`), `fight_iq_components` +
`fight_iq_evidence_confidence` (already specified in full in
`athlete_progression_rules.json`). No changes proposed here beyond what
Codex's v1 rules file already commits to — this proposal just confirms these
belong on the athlete record, not a separate side table, since eligibility
checks need them inline with every other gate.

### 2.6 Competition/eligibility — new, ties directly to ruleset research

| Field | Purpose |
|---|---|
| `rank_by_discipline` | map `{discipline_id: rank_value}` | Belt/kyu/dan/amateur-pro status, shape TBD per discipline from `COMPETITION_RULESET_RESEARCH.md` (a BJJ belt is a very different structure from a boxing amateur/pro split). Store as a discipline-scoped opaque string + a numeric ordinal for comparison, not a single global enum — the researched disciplines do not share one rank taxonomy. |
| `competition_weight_class_id` | resolved, not stored raw | A *function* of `current_weight_kg` + the target ruleset's own weight-class table (from the research doc), not a stored display string like today's `weight_class`. Different rulesets slice weight differently; storing one global string (as today) cannot represent that. |
| `medical_clearance_status` | enum + expiry date | Required by essentially every researched ruleset's admin requirements (exact cadence/authority TBD per ruleset). Hard gate per the assignment's entry-safety-gate layer. |
| `amateur_or_pro_status_by_discipline` | map | Several disciplines (boxing, MMA, Muay Thai) have amateur/pro as a *status* independent of belt/rank; others (BJJ) don't have a real "pro" tier at all per current research-in-progress findings. Kept discipline-scoped rather than one global flag. |

## 3. Derived/display values — avoid duplicate visible ratings

Per the assignment's guidance, the UI's default profile view should show a
small number of *derived* broad numbers, not 15+ raw substrates at once. Using
the assignment's own example formulas as the starting shape (final weights
are a tuning question the progression audit flags, not answered here):

```text
striking_power       = strength + explosive_power + discipline_technique_contribution
conditioning_display = aerobic_endurance + anaerobic_conditioning + recovery_contribution
defensive_execution  = relevant_learned_defense + agility + speed + fight_iq + current_state
takedown_execution   = strength + balance + discipline_technique_contribution + fight_iq
grappling_control    = strength + coordination + discipline_technique_contribution
```

Raw substrates stay queryable (an "advanced/scout view" toggle, matching how
`profile_ui.skills_tab_states` already anticipates multiple detail levels),
but the default athlete card should read closer to today's five-stat card
than to fifteen bars, to avoid a net UX regression while gaining simulation
depth underneath.

## 4. Migration from the current save format

| Old field | Disposition |
|---|---|
| `age: int` | Replaced by derived age from `birth_date`. Migration: pick a `birth_date` that produces the same current age at migration time (exact day/month arbitrary, flagged as a cosmetic approximation, not a real fact). |
| `weight_class: String` (display only) | Replaced by `current_weight_kg` (back-calculated from a reasonable mid-point of the old class, flagged as approximate) + the new resolved `competition_weight_class_id`. |
| `power`, `technique`, `speed`, `defense`, `conditioning` | Split per section 2.2's mapping. Migration heuristic: seed each new substrate from the old stat it most overlaps with (e.g. `strength = old_power * 0.6`, `explosive_power = old_power * 0.5`, clamped 0–100, accepting the two won't sum cleanly — this is a one-time seed, not a preserved identity) — **exact split ratios are a tuning question for the user/Codex, not asserted as correct here.** |
| `fight_iq` (randomly seeded) | Per `athlete_progression_rules.json`'s already-specified `legacy_fight_iq` migration (preserve as `tactical_aptitude_seed`, blend toward derived value as evidence accumulates). No new proposal needed — already solved by v1. |
| `potential` | Kept as-is; still a meaningful ceiling concept, orthogonal to this proposal. |
| `fatigue`, `morale` | Kept as-is. |
| `specialties` (dictionary) | Superseded by `discipline_proficiency` + `learned_techniques`; migration should attempt a best-effort mapping from whatever the current `specialties` values represent (needs a read of every call site before writing a migration script — **not done in this research pass**, flagged as an implementation task for the handback). |

## 5. Explicitly not proposed

- No numeric "official minimum" attribute for starting any discipline — per
  the assignment's constraint, none of the researched federations publish a
  physical-attribute floor for *entry*; only medical/age/weight eligibility
  and, for advanced/dangerous techniques, federation-side experience
  requirements (see `PROGRESSION_AND_FIGHT_EXECUTION_AUDIT.md` section A).
- No single global "rank" or "level" number spanning all fifteen disciplines
  — real rank systems (belts, amateur/pro, dan grades) are not
  commensurable across sports, so this proposal keeps them a discipline-keyed
  map rather than inventing a fake universal ladder.
- No psychological/mental attribute is claimed to reflect real sports-science
  literature; section 2.4 is explicitly labeled game-design invention.

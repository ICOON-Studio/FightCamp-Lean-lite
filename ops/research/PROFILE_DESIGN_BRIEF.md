# Fighter Profile Design Brief (data-bound)

Status: research only — **do not implement in `.gd` until the operator says go.**
Author: Kalli · 2026-09-04
Companion preview: `research/PROFILE_DATA_BOUND_2026-09-04.html`

## Source of truth

| Source | Role |
| --- | --- |
| `AthleteProfileScreen.gd` | Live tabs + body regions + camp CTA rules |
| `AthleteStatModel.STAT_ORDER` | power, technique, speed, defense, conditioning, fight_iq |
| `GameState` getters | loyalty, ambition, combos, awards, request, media, rivalries, promotion, title, fight camp, weight |
| `featured_real_athletes.json` | Sample numbers (Ilia Topuria / `real_ilia_topuria`) |
| AAA + 2026-09-04 previews | Visual hierarchy and shell kit |

`PROFILE_DESIGN_BRIEF.md` was missing from disk; this file is the replacement brief.

## Tabs (keep — do not invent new names)

1. **ATHLETE LAB** — Overview / Physical & Mental + Medical modes (existing)
2. **DEVELOPMENT** — discipline_proficiency, belts, MMA transition
3. **SKILLS & MOVES** — technique_progress trees
4. **FIGHT RECORD** — history, rivalries, awards & media (G2)
5. **FIGHT CAMP** — `FightCampPanel.setup(athlete_id)`

## Hierarchy

### Tier 1 — Decide now
- Identity hero: name (large), discipline + division as coloured chips, record, overall letter dial from six stats vs `potential`
- Next bout (red glow): only active when `booked_fight` is set; owns Tape / Fight Plan / Fight Camp CTAs; weight line from `get_weight_status`
- Condition (cyan): readiness, `fatigue`, `morale`, training + competition clearance

### Tier 2 — What wins
- Attribute bars (STAT_ORDER) current → ceiling
- Weapons: `get_athlete_combos` (tightness, signature, game plan) + duel record
- Camp shape: `get_fight_camp` bout-only edges when live
- Body: six regions `head_neck`, `torso_core`, `left_arm`, `right_arm`, `left_leg`, `right_leg`

### Tier 3 — Long game
- Corner & gym: coach rapport, `get_athlete_loyalty`, contract weeks / salary, listen rate
- Ambition ladder: `get_athlete_ambition`
- Awards & media (G2): `get_athlete_awards`, hype from fight log, `get_athlete_request`, `get_media_questions`
- Signing / titles / rivalries: `get_athlete_promotion`, `get_athlete_title`, `get_athlete_rivalries`

## Shell rules (standing)

- Left nav rail always present (collapsible)
- Breadcrumb: OFFICE › FIGHTERS › NAME › TAB
- Headline = name + discipline + division (not finance chips)
- Belts / trophies / ranks as graphics when assets exist
- Entity names are links
- Gym colour accents the chrome; gold for primary actions

## Sample binding (Topuria)

| Field | Value |
| --- | --- |
| id | real_ilia_topuria |
| record | 17-1-0 |
| stats | 94 / 95 / 90 / 91 / 90 / 94 |
| fame | 930 |
| morale / fatigue | 78 / 12 |
| potential | 98 |
| personality / ambition | Confident / Redemption |
| weight_class | Lightweight |
| primary_discipline | mma |

## Build order (when go)

1. Restyle `AthleteProfileScreen` shell to rail + breadcrumb + instrument kit (no new systems)
2. Bind Overview cells to existing getters; honest empty states
3. G2 awards/media panel on Fight Record
4. Asset pass: discipline glyphs, belt/trophy shelf, muscular body figure


## API return keys (verified)

- **loyalty:** `score`, `band`, `parts` {rapport, morale, pay, tenure}, `market_salary`, `weekly_salary`, `contract_remaining_weeks`, `striking`
- **ambition:** `id`, `label`, `progress`, `milestones` [{id, label, done}], `complete`, `started_week`, `completed_week`
- **combos:** `tightness`, `signature_chain`, `game_plan_chains`, `chains` [{id, name, tier, links, usable, signature, game_plan, attempts, lands}]
- **awards:** array of athlete.awards entries
- **request:** `request`, `open`, `status_line`, `actions`, `deadline_weeks`, `grudge`, …
- **rivalries:** array with `heat`, `band`, `rival_name`, `record`, `grudge_match`, …
- **promotion:** `{org_id, org_name, tier, signed_week, status}` or `{}`
- **title:** first held belt + discipline/class/sex, or `{}`
- **fight_camp:** empty or camp + `edges`, `film`, `fatigue`, `counters`, …
- **weight_status:** `limit`, `weight`, `walk`, `on_track`, `can_make`, `penalty`, `plan`, `booked`, …

## Sample athlete extras (Topuria)

- city Alicante · competition_weight_kg 70.3 · ranking_points 940 · contract_weeks 52 · salary_expectation 17000
- specialties: mma 96 · boxing 93 · BJJ 90
- fight_history (3): loss Gaethje TKO R4 UFC Freedom 250 · win Oliveira KO R1 UFC 317 · win Holloway KO R3 UFC 308
- achievements include two-division UFC champ lines (display as trophy shelf graphics, not walls of text)

## Honesty gotchas

1. Featured JSON uses `primary_discipline`; career remaps to `discipline` on sign.
2. Ambition label `"Redemption"` is **not** in Ambitions.LABEL_TO_ID — runtime assigns a default from the pool. Profile UI should show the **evaluated** label from `get_athlete_ambition`, not the raw string blindly.
3. `stance` / `nickname` / `body_state` / `technique_progress` / `booked_fight` / `fight_camp` / `promotion` are absent on the featured JSON until runtime systems fill them — design must show honest empty states.
4. `featured_real` is stamped at world merge, not stored in the JSON row.

## Align with PROFILE_PREVIEW_2026-09-04 panels

When building, prefer that preview’s named frames under the three tiers:
- T1: HE IS ASKING · NEXT FIGHT · CAMP & WEIGHT
- T2: ATTRIBUTES · BODY · STYLE & PLAN · FORM & READINESS
- T3: AMBITION · RELATIONSHIPS · CONTRACT · MEDIA & AWARDS
- Below: LAST FIVE (from `fight_history`)

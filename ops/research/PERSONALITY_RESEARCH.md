# Personality — research and design (2026-09-04)

Author: Grok (investigation only). Requested by the user: "i want an
investigation on the possibility of adding a personality parameter to
bridge the weight value in the game. the personality can affect
relationships and the fight/fight build up and the ceiling of other
values like how physically the fighter can develop, when will he reach
peak, and also consider age to affect the duration of the peak, the
length of a fighter's career, or how injury prone a fighter gets."
Addendum 2026-09-04: visible artifact (standing presentation rule) and
LEARNING (user: "add learning to G3 so grok defines it with personality").
Addendum 2026-09-04 (feedback -03 mark 3): CAREER GOALS — 1–3 goals from
personality and situation, with progress the save can already compute.

Nothing here is implemented. The user decides what gets built.

---

## 0. Verdict in one paragraph

Personality is already a **save field and a world-gen label**, not a new
stat. Generated fighters pick one of eight strings in
`WorldPopulation.PERSONALITIES`. That string is live in **two** systems
(asks, loyalty) and displayed in a third (recruitment). It is **not**
read by rapport, rivalries, press, camp, the sim, development, aging or
injury — and the 100 featured athletes mostly do not even use the eight
labels, so they currently receive the default (asks ×1.0, loyalty +0).
The honest model is Football Manager's, not a ninth slider: **keep the
word the player sees, store five 0–100 axes under it**, derive the axes
from the eight labels so no save breaks, and map featured flavour
("Ice-cold", "The Greatest") through a synonym table so those 100 names
stop being dead. Do **not** invent aging or career-long damage in the
same stage as personality. Age does not tick for roster fighters today;
`status: retired` exists only on world candidates. Injury proneness
should scale the rolls that already exist. A future CAREER DAMAGE stage
(not written as a Direction-notes block on this tree — cumulative scars
that outlive a week) should own permanence; personality should only own
the **rate**. Personality is not a bag of hidden multipliers: the player
reads a TRAIT PLATE before they sign (§9). LEARNING is a separate
development trait, not a sixth axis and not a seventh combat stat:
Fight IQ stays in-ring under WHAT WINS; Learning sits under DEVELOPMENT
as a fog-band gauge (§10).

---

## 1. What personality is TODAY (verified, not the assignment's list)

### 1.1 The eight labels

`WorldPopulation.gd:54`

```
const PERSONALITIES := ["Disciplined", "Ambitious", "Loyal", "Analytical",
  "Fearless", "Reserved", "Charismatic", "Temperamental"]
```

Assigned at world gen: `_generate_athlete` (`WorldPopulation.gd:484`) and
on generated coaches (`WorldPopulation.gd:448`). Copied onto the roster
at hire (`GameState.gd:3204`, `3276`). Default if missing: `"Disciplined"`.

### 1.2 Live reads (the assignment said three; here is the actual map)

| Site | File | Function / constant | What it does | Who it hears |
| --- | --- | --- | --- | --- |
| Ask roll | `FighterRequests.gd:67` `personality_weight`, `:114` `roll_chance` | `base_chance 0.3 × weight`, capped `max_chance 0.75` | How often a fighter raises an ask | **All eight**, authored in `fighter_requests.json:12-20` |
| Ask fire | `GameState.gd:6182` | `roll >= roll_chance(personality) * request_daily_scale` | Daily request pass (R8) | Same |
| Loyalty | `Retention.gd:26` `PERSONALITY_SHIFT`, `:81` `loyalty()` | Loyal +8, Temperamental −8, Ambitious −4, else **0** | Live loyalty score | **Three of eight** |
| Recruitment card | `RecruitmentScreen.gd:648` | `"CURRENT: %s  •  %s" % [gym, personality]` | Display only | Any string |
| Request context | `GameState.gd:5514`, `:5680`, `:5898` | stuffed into the desk / poach / presser context | Pass-through | Any string |

Weights already in data (`fighter_requests.json:12-20`):

| Label | Ask weight | Loyalty shift | Rapport | Everything else |
| --- | --- | --- | --- | --- |
| Ambitious | 1.6 | −4 | unused | unused |
| Temperamental | 1.4 | −8 | unused | unused |
| Charismatic | 1.2 | 0 | unused | unused |
| Fearless | 1.1 | 0 | unused | unused |
| Disciplined | 0.9 | 0 | unused | unused |
| Analytical | 0.9 | 0 | unused | unused |
| Reserved | 0.7 | 0 | unused | unused |
| Loyal | 0.6 | +8 | unused | unused |

**Correction to the assignment.** "Four of the eight labels currently do
nothing at all" is true for **Retention**, false for **asks**. All eight
already change how often a fighter knocks on the office door. The four
that are loyalty-silent are Charismatic, Fearless, Disciplined,
Analytical (Reserved also silent on loyalty; it is not "four").

### 1.3 The comment that lies

`CoachRapport.gd:65-82` talks about a "personality set-point". The
function `set_point` (`CoachRapport.gd:106`) does **not** read
`athlete["personality"]`. It reads `athlete["ambition"] == "Gym Loyalty"`
(`SETPOINT_LOYALTY_BONUS := 15`) plus a hash of the athlete id
(`SETPOINT_SPREAD := 10`) on `SETPOINT_BASE := 55`. Test
`coach_rapport_test.gd:57-59` asserts exactly that. Personality is a
documented hook that was never wired.

Listen rate (`CoachRapport.listen_probability`, `:142`) is rapport +
Fight IQ + hurt/gassed. No personality.

### 1.4 Featured athletes are a second vocabulary

`featured_real_athletes.json` authors flavour, not the eight:
"Composed", "Determined", "Professional", "Creative", "Technical",
"Stoic", "Mercurial", "Showman", "Ice-cold", "The Greatest",
"Violent artist", "Lioness", "Timebomb", "Machine-calm", …
`FighterRequests.personality_weight` falls back to **1.0** for any
unknown string. `Retention.PERSONALITY_SHIFT` falls back to **0**. So Ali
("The Greatest") currently asks like a blank generated fighter and is
loyalty-neutral. That is the first thing Stage A has to stop doing,
without renaming anyone.

### 1.5 What is not personality today (and must stay that way)

- **Ambitions** (`Ambitions.gd`) — measurable career arcs. Do not merge.
  "Gym Loyalty" is an ambition, not a personality.
- **Rapport** — a per-coach 0–100 matrix. Personality should bias the
  *set-point*, not replace the matrix.
- **Morale / fatigue / fame** — state, not identity.
- **Natural style / fight plan** — already a discipline archetype. Fearless
  is not "pressure wrestler".
- **Fight IQ** — in-ring decision-making, derived
  (`AthleteDevelopment.derive_fight_iq` `:583`), already one of the six
  combat stats and inside overall. Do not merge.
- **LEARNING** — gym absorption, proposed in §10. Personality *modulates*
  it. It is not an axis and not a combat stat.

---

## 2. What the sport and the management games actually do

Real combat sports do not have a "personality" rating. Coaches talk about
**professionalism** (does he do the camp), **killer instinct** (does he
finish a hurt man), **chin / composure** (does he panic when tagged),
**media** (does he sell the fight), **gym loyalty**, **durability** (does
he break in camp). Those are five questions. One enum cannot answer five
questions without becoming a lookup table — which is axes with extra
steps.

Football Manager is the honest analogue: a public **personality label**
("Determined", "Temperamental") sitting on hidden mental attributes
(Professionalism, Ambition, Temperament, Pressure, Sportsmanship). The
label is flavour; the attributes do the work. MMA Tycoon hid a similar
bundle behind happiness and training. MMA Manager 2 / Pound for Pound
surface a relationship ring and a letter, not eight booleans.

Combat-sport facts this model must respect:

- **Peak age is sport-specific, not personality-specific.** Boxing
  punchers often peak ~27–30; wrestle-heavy MMA can peak later; women's
  strawweight peaks earlier than heavyweight. Personality can *shift* a
  peak by a year or two (a professional lasts; a chaotic one burns). It
  cannot invent a 38-year-old flyweight prime.
- **Injury proneness is load × recovery × luck.** Reckless camp (hard
  sparring, making weight mean) raises the rate. A "Fearless" fighter who
  never takes a hard camp is not injury-prone. Personality must scale
  *choices and rolls*, not apply a flat "fragile" tag.
- **Champ-champs and long primes are professionalism + luck**, not a
  Charisma score. GSP, Aldo, Namajunas: camp discipline. McGregor, Ngannou:
  drive and nerve, shorter windows. The game already has Fight Camp
  protocols and a weight cut. Personality should bias **which protocol a
  fighter will actually do**, not add a parallel "prime" meter.

---

## 3. THE MODEL — one label versus scored axes

### 3.1 Recommendation: **label stays, five axes do the work**

Keep `athlete["personality"]` as a string forever. The player reads one
word. Systems read five integers, 0–100, stored as
`athlete["personality_axes"]` when present, otherwise **derived from the
label at read time** so old saves and generated fighters need no
migration.

Why not "one label, giant switch": that is today's Retention table, and
four labels already fell off it. Every new system would grow another
switch. Why not "axes only, drop the word": the featured roster's flavour
is identity, and the office already prints the word. Why not 0–100
sliders on the profile: FM taught that a wall of mentals is unreadable;
a word plus consequences is readable.

### 3.2 The five axes

Names the player can be shown later (profile redesign). Ranges 0–100,
neutral 50, authored not simulated.

| Axis | Player word | High means | Low means |
| --- | --- | --- | --- |
| `composure` | COMPOSURE | Listens when hurt, small morale shock, low press backlash, lets feuds cool | Panics, blows up at the mic, stokes heat |
| `drive` | DRIVE | Asks, uses potential headroom, hungry peak, hard contract | Coasting, late peak, fewer asks |
| `bond` | BOND | Rapport set-point, loyalty, stays for less | Mercenary, poachable |
| `show` | SHOW | Hype, fame from media, callouts | Quiet, Reserved, no-comment default |
| `nerve` | NERVE | Finishes a hurt man, accepts hard sparring, walks through damage; **higher camp/fight injury rate** | Safety-first, technical-flow camp, survives not finishes |

These five cover the user's brief without a sixth "injury" axis: injury
proneness is `nerve` up and `composure` down (they take the hard camp and
they do not bail when tired). Peak/ceiling is `drive` (hunger) ×
`composure` (they still do the work at 33). Career length is age-system
(§6) × those two, not a sixth slider.

### 3.3 How the eight labels map (so no save breaks, no identity lost)

Runtime helper (proposed, not written):
`Personality.axes(athlete) -> Dictionary`. If
`athlete["personality_axes"]` exists, use it. Else look up the label,
else synonym, else all 50.

| Label | composure | drive | bond | show | nerve |
| --- | ---: | ---: | ---: | ---: | ---: |
| Disciplined | 70 | 55 | 60 | 40 | 50 |
| Ambitious | 45 | 85 | 35 | 60 | 65 |
| Loyal | 60 | 45 | 90 | 40 | 50 |
| Analytical | 75 | 50 | 50 | 35 | 40 |
| Fearless | 40 | 60 | 45 | 55 | 90 |
| Reserved | 70 | 45 | 55 | 20 | 35 |
| Charismatic | 50 | 60 | 50 | 90 | 55 |
| Temperamental | 20 | 55 | 25 | 70 | 70 |

This mapping is **backwards-compatible with today's two live systems** if
Stage A keeps the existing `personality_weight` and `PERSONALITY_SHIFT`
tables as the source of truth for asks/loyalty, and only *new* hooks read
axes. Stage B can then *replace* those two tables with axis formulae
(`ask_chance ≈ 0.3 * lerp(0.6, 1.6, drive/100) * lerp(1.15, 0.85, bond/100)`)
once the numbers are re-tuned. Do not do both in one commit.

### 3.4 Featured flavour — synonym table, not a rewrite

A static map, nearest of eight, then the table above. Examples:

| Flavour (live in the 100) | Maps to |
| --- | --- |
| Composed, Ice-cold, Ice-veined, Machine-calm, Stoic, Precise | Disciplined (composure high) |
| Showman, Charismatic, Provocateur, Golden Wolf | Charismatic |
| Fearless, Ferocious, Relentless, Unstoppable, Warrior | Fearless |
| Temperamental, Volatile, Mercurial, Timebomb, Livewire | Temperamental |
| Analytical, Professor, Technical, Methodical, Calculating | Analytical |
| Loyal, Humble icon, Gracious, Warm | Loyal |
| Ambitious, Driven, Determined, Surging | Ambitious |
| Reserved, Quiet storm, Elegant | Reserved |
| The Greatest, Monumental, Queenly, Lioness | Charismatic + authored axes override (high drive AND show) |

Unknown flavour → all 50 (today's behaviour) until someone authors an
override. Stage A can ship the table with ~30 keys covering the 100;
anything missed stays neutral and is honest.

---

## 4. RELATIONSHIPS — exact hooks

### 4.1 CoachRapport

| Hook | File | Notes |
| --- | --- | --- |
| Set-point | `CoachRapport.set_point` `:106` | Today: ambition "Gym Loyalty" + id hash. **Attach personality here**: `base += int(round((bond - 50) * 0.3))` so Loyal settles ~+12, Temperamental ~−8, still on top of the ambition bonus. Constants: `SETPOINT_BASE 55`, `SETPOINT_LOYALTY_BONUS 15`, `SETPOINT_SPREAD 10`, `SETPOINT_MIN 35`, `SETPOINT_MAX 85`. |
| Listen | `CoachRapport.listen_probability` `:142` | Today: rapport + IQ + `LISTEN_HURT_PENALTY 0.15` + `LISTEN_GASSED_PENALTY 0.10`. **Attach composure**: reduce the hurt penalty as composure rises (`0.15 * (1 - composure/150)`), so a composed fighter still hears the corner when tagged. Do not let personality dwarf rapport — rapport stays the main lever. |
| Training XP | `CoachRapport.training_multiplier` `:129` | 0.85–1.20 from rapport. Leave it. Drive can later scale *headroom use* in `_apply_focus_stat_gains`, not this multiplier, or chemistry and hunger double-count. |
| Corner reset | `CoachRapport.corner_recovery_multiplier` `:154` | Rapport only. Leave it. |

`coach_rapport_test.gd:57-59` asserts Gym Loyalty > mercenary set-point.
Any set-point change must keep that inequality and add a Loyal vs
Temperamental case.

### 4.2 Retention

| Hook | File | Notes |
| --- | --- | --- |
| Loyalty shift | `Retention.PERSONALITY_SHIFT` `:26`, applied `:81` | Replace the 3-key dict in Stage B with `bond`-driven ±10, and a small `drive` penalty (Ambitious already −4). Stage A: fill the missing five labels with modest values (Charismatic +2, Fearless 0, Disciplined +3, Analytical +1, Reserved +2) so nobody is silent. |
| Poach / leave / toxic | `POACH_THRESHOLD 60`, `LEAVE_THRESHOLD 40`, `TOXIC_THRESHOLD 20` | Indirect: they read the score. Do not add a second personality gate. |
| Renewal | `renewal_ask` | Excellent takes a cut. High `bond` already pushes the band; no extra formula. |

Tests: `retention_test.gd:30-35` (Loyal ≥85 Excellent, Temperamental ≤20
Toxic, Disciplined Neutral), `:182-202` (lifecycle with those three
labels). Filling the five silent labels in Stage A does **not** break
those three assertions. Replacing the dict with axes in Stage B **does**,
and must re-tune until the same three fixtures still land in the same
bands.

### 4.3 Rivalries

| Hook | File | Notes |
| --- | --- | --- |
| Stoke | `Rivalries.stoke` `:89` | Heat += delta. Personality is not read. **Attach composure inverted** on the weekly decay (`heat_after_week` `:101`, `decay_per_week`) and a small bonus on *starting* a feud (callout / media / sparring war in GameState). Temperamental keeps heat; Reserved lets it cool. |
| Sim | `attack_bonus` `:142`, `hurt_penalty` `:146` | Heat already makes a rival swing harder. Do not also add nerve here or a Fearless-vs-rival stacks twice. Nerve belongs on the generic finish path, not the rivalry path. |

No rivalry test currently seeds personality. Stage B needs one: two
fighters, same event, Temperamental heat remaining > Reserved.

### 4.4 FighterRequests (already scaled)

| Hook | File | Notes |
| --- | --- | --- |
| Weight table | `fighter_requests.json:12-20` | Keep as the Stage A source of truth. Synonym-map featured labels onto the eight *before* lookup, otherwise Ali stays at 1.0. |
| Roll | `FighterRequests.roll_chance` `:114` | `clampf(0.3 * weight, 0, 0.75)` |
| Fire | `GameState.gd:6182` | Daily. `request_daily_scale` is R8; do not touch the daily pass shape. |

If Stage B moves asks onto `drive`/`bond` axes, the test
`fighter_requests_test.gd:36` (`Ambitious > Loyal`) is the contract:
whatever formula ships must keep that inequality. Effects (morale/grudge
on promise/decline) stay as they are — those are gym answers, not
personality.

---

## 5. THE FIGHT AND THE BUILD-UP — exact hooks

### 5.1 PressConferences

| Hook | File | Notes |
| --- | --- | --- |
| Options | `press_conferences.json` `options[].effects` / `risk` | Player currently picks. World/AI answers (if any auto-pick exists later) should weight by `show` (high-hype options) and `composure` (avoid `risk`). |
| Backfire | `PressConferences.backfires` `:146` | `roll < risk.chance`. **Attach composure**: `chance *= lerp(1.4, 0.6, composure/100)` so Temperamental actually blows up and Disciplined rarely does. |
| Hype pay | `PressConferences.purse_bonus` / `fame_on_win` | Scale by `show` at settlement, small (×0.8–1.2). The bout already has hype from booking; this is the mic, not the card. |
| No-comment | `no_comment_hype: -5` | Reserved/low `show` defaults toward no-comment if the player does not answer; Charismatic should hate that default. |

Do not hide options from the player by personality. The gym still picks.
Personality is the *fighter's instinct and the backlash odds*.

### 5.2 FightCamp

| Hook | File | Notes |
| --- | --- | --- |
| Protocol list | `FightCamp.protocols` `:83`, UI `FightCampPanel.gd:116` | Player picks hard sparring / technical flow / scientific recovery. **Stage B: a willingness gate**, not a lock. High `nerve` + low `composure` flags hard sparring as NATURAL (no extra cost in morale); low `nerve` pays a morale hit if the gym forces it, and the panel says so. Never hide the protocol — the gym still owns the camp. |
| Injury roll | `FightCamp.injury_chance` `:141` | Already: protocol base × track × readiness red/amber × fatigue ≥60 × **age ≥30 / ≥33**. Constants in `fight_camp.json:210-211` (`age_30_mult 1.2`, `age_33_mult 1.4`). **Attach nerve**: `chance *= lerp(0.85, 1.35, nerve/100)`. Fearless hard camps actually hurt. Technical flow stays 0 (`injury_base` 0) — personality must not create injury on a protocol authored as safe. Test `fight_camp_test.gd:39-45` is the contract (6% base, amber double, red × fatigue × age, zero on technical flow). |

### 5.3 FightSimulation

| Hook | File | Notes |
| --- | --- | --- |
| Listen | `FightSimulation.gd:557-571` | Already calls `CoachRapport.listen_probability`. Personality arrives if §4.1 ships. |
| Pace | plan pace curve + corner `pace` | Do not let personality override the plan. A Fearless fighter with a Muay Femur plan is still a technician until the corner says otherwise. Optional Stage C: default *opening* pace leans aggressive if `nerve` ≥ 75 and the plan did not set one. |
| Morale shock | `MORALE_HURT := -4.0` (`FightSimulation.gd:175`), `MORALE_TOOK_DAMAGE := -1.0` | **Attach composure**: multiply the hurt delta by `lerp(1.5, 0.6, composure/100)`. Temperamental melts; Disciplined takes the shot. |
| Finish instinct | hurt-reaction option `"Look to finish"` (`:528-530`), emphasis `finish` (`:91`) | **Attach nerve**: when the other man is hurt, AI corners (and the starred suggestion) bias to finish if `nerve` ≥ 70; Reserved/Analytical bias survive. Player still sees both chips. |
| Finishing-grade techniques | catalog tiers 3–4 (`:160`) | Gate stays learned + stamina. Personality must not unlock moves. |

---

## 6. DEVELOPMENT CEILINGS — exact hooks

There is **no age-based peak function**. Potential is a flat ceiling.

| Hook | File | What it does today |
| --- | --- | --- |
| Potential | `athlete["potential"]`, gen `WorldPopulation.gd:478` (55–96) | Hard cap. |
| Weekly stat gain | `GameState._apply_focus_stat_gains` `:3881-3903` | `headroom = clamp((potential - current) / 20, 0.15, 1.0)`, gain `0.6 * quality * condition * coach * headroom * fraction`, clamp to `potential + 10`. |
| Discipline XP | `AthleteDevelopment.preview_discipline_week_gain` `:538` | `BASE_DISCIPLINE_GAIN_PER_WEEK := 2.0` × coach/facility/equipment/partner/readiness/rapport/IQ/headroom. No personality, no age. |
| Fight IQ | `AthleteDevelopment.derive_fight_iq` `:583` | Experience / depth / breadth / application / ring. No personality. |

**How personality should scale this (Stage C, not A):**

- `drive` raises the *use* of headroom: multiply `headroom` by
  `lerp(0.85, 1.15, drive/100)` so Ambitious actually approaches
  potential and a low-drive veteran plateaus earlier. Do **not** raise
  `potential` itself — that is talent, already generated.
- `composure` scales the discipline-week gain the same way rapport does
  (a second 0.9–1.1 factor). Professionals get the week in; chaotic ones
  waste some of it. Keep it smaller than rapport (0.85–1.20) so chemistry
  with the coach remains the visible lever.
- Peak *age* is §7. It does not belong in `_apply_focus_stat_gains` until
  age ticks.
- Gym *absorption* (how fast a technique, a transition, a combo, a film
  pack actually lands) is LEARNING (§10), not `drive`. Drive is hunger
  for headroom; Learning is how much of a session sticks. Do not put a
  sixth personality axis on `_session_progress_units`.

`athlete_progression_rules.json` has an age gate only as a **promotion
interest** example (`age_24_or_younger` around line 457). It is not a
growth curve. Do not overload that file with personality; keep a new
`personality.json` next to `fighter_requests.json`.

---

## 7. AGE — proposing a system, not tuning one

Honest baseline:

- Roster `age` is **static**. World gen sets 18–31 (`WorldPopulation.gd:473`).
  Nothing in `advance_week` / `advance_day` increments it. R8 daily
  progression did not add birthdays.
- `status: "retired"` is filtered on **world candidates**
  (`GameState.gd:5135`, `:5300`). Player roster has `"available"` /
  `"injured"` / camp / booked. No retirement pass.
- The only age math in the game is Fight Camp injury
  (`FightCamp.injury_chance` age 30 / 33 multipliers) and whatever a
  featured athlete was authored as.

So "duration of the peak" and "length of a career" are a **new system**.
Personality can shape it; it cannot be a one-line multiplier on code that
does not exist.

### 7.1 Proposed aging (own stage, after personality A/B)

1. Store `birth_week` (career week of 18th birthday) or increment `age`
   every 52 career weeks from a stored `age_week_counter`. 52-week tick,
   not daily. Do **not** put this inside Claude's `_advance_day` rewrite
   without coordination — a `_tick_ages(career_week)` next to the other
   weekly passes is enough.
2. **Peak window** from sport + class + `drive`:
   - striking-primary lighter classes: peak 26–30
   - grappling-primary / heavier: peak 28–33
   - `drive` high: window starts slightly later and holds 1 year longer
     (they still push); `drive` low: window shorter
   - `composure` high: decline after peak is 50% slower
3. **In peak**: today's gain formula, unchanged.
4. **After peak**: multiply `_apply_focus_stat_gains` and discipline XP by
   a decline factor (year 1 after peak 0.85, then 0.7, then 0.55… floor
   0.35). Speed/conditioning decline faster than fight_iq/technique.
5. **Retirement**: a pass, not a cliff. Offer the chair when age ≥ 36 **or**
   (age ≥ 33 and two years of decline and morale/bond low). Player can
   refuse; a Temperamental low-bond fighter may walk (`Retention` toxic).
   World candidates already have `retired`; roster retirement writes the
   same status and vacates titles via `WorldPopulation.vacate_title`
   (R7).

Personality's job in that system is **shift the window and the decline
slope**, not the birthday.

---

## 8. INJURY PRONENESS — exact hooks, and CAREER DAMAGE

Three live rolls, none of them personality:

| Roll | File | Chance today |
| --- | --- | --- |
| Fatigue blow-up | `GameState.gd:4767-4771` | If `fatigue >= 95` and status available, seed `injury|id|week`, **flat 0.15** → `status = injured` |
| Fight Camp week | `GameState.gd:1220-1237` via `FightCamp.injury_chance` | Protocol × track × readiness × fatigue × **age**; severity 12–30 on a real region |
| Fight night | `GameState.gd:9377-9380` | Seed `fight_injury|id|offer|week`, **0.55 if not a win else 0.35** → broad `injured` |

BodyReadiness recovery (`_apply_recovery` `:347`) is rest/recovery base
+ equipment + coach, **no personality, no age**. Region thresholds 80
green / 60 amber are global.

### 8.1 What personality should do

Scale the **rate**, not invent a fourth roll.

- Camp: `nerve` on `injury_chance` (§5.2). Technical flow stays zero.
- Fatigue blow-up: `0.15 * lerp(0.75, 1.4, nerve/100)` so Fearless at 95
  fatigue actually breaks, Loyal/Disciplined slightly less. The 0.15 is
  currently magic; moving it to data is a gift to tests.
- Fight night: keep the win/loss split; multiply by
  `lerp(0.85, 1.2, nerve/100)` and invert composure a little (they don't
  protect themselves). Small — the fight already hurt the regions.
- Recovery: `composure` as a 0.9–1.1 on `_apply_recovery` base. Professionals
  actually rest.

### 8.2 CAREER DAMAGE (planned, not present)

There is **no Direction-notes block titled CAREER DAMAGE** on this tree.
What exists is weekly/fight-local: regions recover, `injured` clears when
fatigue ≤ 30 and min readiness ≥ 80 (`GameState.gd:4758`). Nothing
accumulates into a shorter career.

The two stages must not fight:

| | Personality (this brief) | CAREER DAMAGE (future) |
| --- | --- | --- |
| Owns | Rate of the existing three rolls; camp protocol willingness | Permanence: scar per region, chin, minutes, KO count, cut tissue |
| Reads | `nerve`, `composure`, age multipliers already in camp | Those scars, plus the same rolls' *outcomes* |
| Must not | Write `career_damage` or lower potential on a whim | Re-roll injury with a second personality check |

Contract to write into both stages: personality may multiply a chance;
only CAREER DAMAGE may write a lasting scar. If a Fearless fighter eats
the 0.15, CAREER DAMAGE decides whether that becomes a bad knee.

---

## 9. THE VISIBLE ARTIFACT — what the player reads before they sign

Personality must not be a bag of hidden multipliers. Today it is worse than
hidden: it is a **muted caption**. Recruitment prints
`"CURRENT: %s  •  %s" % [gym, personality]` (`RecruitmentScreen.gd:648`) in
11px `COLOR_MUTED`. The profile does not show the word at all. Four of eight
labels are loyalty-silent; featured flavour is dead. A player signing a
Temperamental fighter cannot tell they are poachable. A player signing
"The Greatest" cannot tell the word does nothing.

### 9.1 Market pass

| Game | What the player sees | What it actually is |
| --- | --- | --- |
| Pound for Pound | A **relationship ring** around the overall badge on the profile modal; a **RivalryHeatMedallion** on list rows | Rapport / heat wearing a circle. Identity is not on the ring. Recruitment does not carry it. |
| Football Manager | A public personality **word** ("Determined") and a wall of hidden mentals the player infers from behaviour | The honest analogue for the *model*. The wall is unreadable; the word is the artifact. |
| MMA Tycoon | Almost nothing. Happiness and training hide the bundle | Hidden multipliers. Exactly what this rule forbids. |
| Elite MMA Manager / MMA Sim King / Cage Empire | Trait text, sometimes a colour pip | Legible, cheap, not a moment. |
| FightCamp today | A muted caption on recruitment; nothing on the profile | Dead. |

P4P's ring is the thing to beat, and it is the wrong object. A ring is a
**meter**. Rapport and loyalty are already meters (`CoachRapport`,
`Retention`) and they already have bars on the proposed profile. Putting
personality on a second ring would make identity look like a relationship
score. The RivalryHeatMedallion is heat, not who the fighter is.

### 9.2 Enhancement — the TRAIT PLATE

Our identity shape is the **corner-cut block** (ring apron / fight poster),
not a circle. Personality is a **word with consequences**, not a 0–100.

**THE TRAIT PLATE:** one cut-corner tile, championship gold on
arena-broadcast-dark, the same object on recruitment and on the profile so
the player reads it **before they sign**.

```
      cut
     ╱─────────────────────────────────────────────╮
    │  TEMPERAMENTAL                                │
    │                                               │
    │  NERVE   ████████████░░░░░░░░  70             │
    │                                               │
    │  ┌────────────┐ ┌───────────┐ ┌────────────┐  │
    │  │ ASKS OFTEN │ │ POACHABLE │ │ HARD CAMPS │  │
    │  └────────────┘ └───────────┘ └────────────┘  │
     ╰─────────────────────────────────────────────╱
```

Inline SVG (the same object, tinted from the token ladder; do not build):

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 420 148" width="420" height="148">
  <rect width="420" height="148" fill="#0c1218"/>
  <path d="M18 8 H402 L412 18 V130 L402 140 H18 L8 130 V18 Z"
        fill="#141c26" stroke="#f0c233" stroke-width="1.6"/>
  <text x="28" y="40" font-family="IBM Plex Mono, monospace" font-size="18"
        fill="#f5c23b" letter-spacing="2">TEMPERAMENTAL</text>
  <text x="28" y="68" font-family="IBM Plex Mono, monospace" font-size="9"
        fill="#8aa0b4" letter-spacing="1.6">NERVE</text>
  <rect x="88" y="58" width="220" height="10" fill="#1c2836"/>
  <rect x="88" y="58" width="154" height="10" fill="#e24b4b"/>
  <text x="318" y="68" font-family="IBM Plex Mono, monospace" font-size="11"
        fill="#e8eef4">70</text>
  <rect x="28" y="88" width="108" height="22" rx="2" fill="#1a2430" stroke="#f0c233"/>
  <text x="82" y="103" text-anchor="middle" font-family="IBM Plex Mono, monospace"
        font-size="8" fill="#f5c23b">ASKS OFTEN</text>
  <rect x="144" y="88" width="108" height="22" rx="2" fill="#1a2430" stroke="#c45c5c"/>
  <text x="198" y="103" text-anchor="middle" font-family="IBM Plex Mono, monospace"
        font-size="8" fill="#e8a0a0">POACHABLE</text>
  <rect x="260" y="88" width="120" height="22" rx="2" fill="#1a2430" stroke="#8aa0b4"/>
  <text x="320" y="103" text-anchor="middle" font-family="IBM Plex Mono, monospace"
        font-size="8" fill="#c5d4e0">HARD CAMPS</text>
</svg>
```

Three parts, no more:

1. **The word** the save already stores, gold, 18px+, never muted. Featured
   flavour stays the flavour ("THE GREATEST"), not rewritten to Charismatic.
2. **One dominant-axis bar** — the axis furthest from 50 for this label
   (Temperamental → nerve, Loyal → bond, Reserved → show *low*, Analytical
   → composure, Charismatic → show, Ambitious → drive, Fearless → nerve,
   Disciplined → composure). One bar. Not five sliders. FM taught that a
   wall of mentals is unreadable. Until Stage A of personality actually
   stores or derives axes, **do not print a fake 70**. Show the bar only
   when `Personality.axes` exists; until then the plate is word + chips.
3. **Consequence chips from live systems**, so a trait that currently does
   nothing becomes a sentence:
   - ask weight ≥ 1.3 → `ASKS OFTEN`; ≤ 0.7 → `RARELY ASKS`
   - loyalty shift ≤ −4 → `POACHABLE`; ≥ +8 → `STAYS`
   - after Stage B: nerve ≥ 70 → `HARD CAMPS`; composure ≤ 30 → `BLOWS UP AT THE MIC`; show ≥ 80 → `SELLS THE FIGHT`

A chip the live table cannot support is not drawn. That is how Analytical
(loyalty-silent today) still earns its place: Stage A fills the silent
labels, and the plate grows a `STAYS` / `STUDIES` chip instead of lying.

### 9.3 Why this beats P4P

| | P4P ring / medallion | TRAIT PLATE |
| --- | --- | --- |
| Object | A meter around overall | Identity tile in our cut-corner language |
| When you see it | After you own them | On recruitment AND the profile |
| What you learn | How much they like you / how hot a feud is | Who they are and what they will do |
| Dead traits | N/A (the ring is always a number) | A silent label becomes a missing chip, which is honest, then a real chip once Stage A fills the table |
| Motion | CSS glow | Intro fill on the axis bar (kit 0.38 s ease-out quart); gold edge **pulses** when the trait is about to fire (an ask forming, a presser with high backlash). Reduced-motion: static plate |

Think-ahead, not in v1: the plate is a deep link. Clicking a chip opens the
desk that chip is about (ASKS OFTEN → the request overlay; POACHABLE → the
retention / contract line). One object, never a second personality screen.

LEARNING is **not on this plate**. It is a development gauge (§10). Mixing
them would turn identity into a training stat.

### 9.4 Where it sits

- Recruitment card: replace the muted `"CURRENT: gym  •  word"` line.
- Profile hero (redesign P4 in `PROFILE_DESIGN_BRIEF.md` §8): a pill on the
  identity strip that **expands to the plate** on hover/focus; collapsed it
  is the word in gold.
- Roster row: the word only, gold if the dominant axis is ≥ 70 or ≤ 30
  (a Temperamental / Analytical should catch the eye; a Disciplined 50-ish
  should not scream).

Do not build any of this in the G3 commit. Sketch only.

---

## 10. LEARNING — how fast a fighter absorbs

User (2026-09-04): "add learning to G3 so grok defines it with personality."

### 10.1 What it is, and what it is not

**LEARNING is a development trait: how fast gym work sticks.** Distinct from
FIGHT IQ.

| | Fight IQ | Learning |
| --- | --- | --- |
| Question | Does he *decide* well in the ring? | Does the gym *take*? |
| Profile home | WHAT WINS (with the six combat stats) | DEVELOPMENT (with potential, headroom, the Move Lab) |
| Source today | `AthleteDevelopment.derive_fight_iq` `:583` (experience 0.40, depth 0.25, breadth 0.13, application 0.10, ring 0.12) plus `stats.fight_iq` | **Does not exist.** Gym speed currently hijacks `stats.fight_iq` |
| In overall? | Yes. `GameState.get_athlete_rating` `:4874` is the mean of `STAT_KEYS` (`power, technique, speed, defense, conditioning, fight_iq`) | **No. Never.** Not a seventh combat stat, not in `stats{}`, not in the grade dial |
| Personality | Not read | Modulates seeding and, later, the stubbornness of the fog |

The leak to close: `_session_progress_units` (`AthleteDevelopment.gd:754`)
already uses `stats.fight_iq` as a gym-speed factor
(`0.85 + 0.005 * fight_iq`, clamp 0.85–1.35). That is Learning wearing
Fight IQ's clothes. Smart in the ring and sponge in the gym are different
fighters (the Analytical who studies tape; the Fearless closer who does not).

### 10.2 Range and seeding (deterministic, no save migration)

Range **0–100**, neutral **50** (identity-at-50, same contract as the
personality axes). Bands the player can be shown once the fog collapses:

| Band | Range | Player word |
| --- | ---: | --- |
| SLOW | 0–34 | LEARNS SLOW |
| STEADY | 35–64 | STEADY |
| QUICK | 65–84 | LEARNS FAST |
| SPONGE | 85–100 | SPONGE |

Stored as `athlete["learning"]` **only if authored**. Otherwise derived at
read time by `Personality.learning(athlete)` so old saves and generated
fighters need no migration. Never written into `stats{}`.

**Seeding**, deterministic per fighter:

```
shift = LEARNING_SHIFT[resolved_label]          # table below
spread = (hash("learn|" + athlete_id) % 21) - 10   # ±10, two Analyticals differ
value = clamp(50 + shift + spread, 18, 90)
```

World gen (`WorldPopulation._generate_athlete` `:484`) already picks a
label from `PERSONALITIES` with the world RNG. Learning does **not** roll
again there. The id-hash keeps it stable across a re-load and a re-gen of
the same id. Featured athletes use the synonym map (§3.4) then the same
formula; unknown flavour → shift 0, still hashed, so Ali is not a clone of
every other unmapped star.

### 10.3 How personality modulates it

Stage A source of truth is a **label table**, same pattern as
`fighter_requests.json` ask weights. Axes may replace it in a later retune.

| Label | composure | drive | nerve | Learning shift | Why |
| --- | ---: | ---: | ---: | ---: | --- |
| Analytical | 75 | 50 | 40 | **+12** | Studies. The assignment's example. |
| Disciplined | 70 | 55 | 50 | **+8** | Does the work every session. |
| Reserved | 70 | 45 | 35 | **+8** | Quiet in the room, takes the note. |
| Loyal | 60 | 45 | 50 | **+3** | Shows up; not a student. |
| Ambitious | 45 | 85 | 65 | **0** | Hungry, not studious. Drive is headroom, not absorption. |
| Charismatic | 50 | 60 | 55 | **0** | Neutral. The gym is not a stage. |
| Fearless | 40 | 60 | 90 | **−6** | Trains hard, skips the classroom. |
| Temperamental | 20 | 55 | 70 | **−14** | The assignment's example. Walks out of the session. |

Axis form (Stage B, not A):
`round((composure-50)*0.35 + (drive-50)*0.10 - (nerve-50)*0.15)`
lands in the same neighbourhood (Analytical ~+10, Temperamental ~−13). Keep
the table until a retune, identical to asks/loyalty.

Drive is **not** the Learning lever. An Ambitious fighter still approaches
potential (§6); they do not magically complete a technique in half the reps.
Nerve high pulls Learning down (they will not sit for tape or mitt
corrections). That is the Fearless / Temperamental cost.

### 10.4 Exact hooks (file, function, what to attach)

Every multiplier is `lerp(lo, hi, learning/100)` with **identity at 50**
(`lerp(a,b,0.5) = 1.0` ⇒ `a + b = 2`). Default missing Learning to 50 so
every existing test that omits the field stays valid.

#### A. Technique learning speed

| | |
| --- | --- |
| Function | `AthleteDevelopment._session_progress_units` `:754` |
| Today | `BASE_UNITS_PER_SESSION 22.0` × coach × facility × equipment × partner × **fight_iq_factor** × readiness × rapport |
| Called from | `train_technique` `:282` ← `TechniqueTrainingCoordinator.run_scheduled_week` `:419` (one call per scheduled session) |
| Attach | Replace `fight_iq_factor` with `learning_factor = lerp(0.70, 1.30, learning/100)`. Fight IQ no longer speeds the Move Lab. |
| Do not hook | `run_scheduled_week` itself — it is a loop around `train_technique`. One factor, one place. |

`fight_iq_factor` today is `clampf(0.85 + 0.005 * stats.fight_iq, 0.85, 1.35)`.
A 50 IQ already sits at 1.10, so current gym speed is biased *up* for anyone
with a mid fight_iq. Replacing it with identity-at-50 Learning is a **small
nerf at the default** and must be called in the handback. Do not keep both
factors (double-count: the smart sponge becomes a cheat code).

#### B. Discipline transitions

| | |
| --- | --- |
| Function | `AthleteDevelopment.advance_mma_transition` `:693` |
| Today | Same `_session_progress_units` as techniques |
| Called from | `TechniqueTrainingCoordinator.run_mma_transition_week` `:284` |
| Attach | **Nothing extra.** Hook A covers it. A sponge crosses to MMA faster; a Temperamental sits in the program. |
| Sister hook | `preview_discipline_week_gain` `:538` still uses `transfer_factor` from `derive_fight_iq` (0.75–1.4). That is discipline *XP*, not a technique. Stage L1: add a Learning factor here (0.90–1.10, smaller than the session factor) and **keep** the IQ transfer term — a high-IQ fighter still converts ring-sense into a second discipline; Learning is how much of the week's drilling sticks. |

#### C. Film-study depth per week

| | |
| --- | --- |
| Gain | `FightCamp.week_effects` `:201-204` |
| Today | `film_gain = film_study.depth_per_week` (1, `fight_camp.json:169`) **+ 1** on week 1 if corner or specialist tactical ≥ threshold (80 / 70) |
| Applied | `GameState.gd:1217` `camp["film_depth"] = mini(max_depth 3, film_depth + film_gain)` |
| Readout | `FightCamp.film_report(opponent, depth, ruleset_id)` `:286` — **pure readout**. What a given depth *shows*. Learning must not rewrite the opponent. |
| Attach | On `week_effects`, not on `film_report`. Identity at 50 = 1/week, no extra. Learning ≥ 75: the week-1 tactical bonus may also fire on week 2 (they actually watch the tape). Learning ≤ 30: 50% chance `film_gain` is 0 that week (seeded), they did not sit still. Technical-flow / taper unchanged. `max_depth` 3 stays the cap. |
| Test | `fight_camp_test.gd:66-68` asserts film_report *contents* at depth 1/2/3, not the gain. Safe if we do not touch `film_report`. |

#### D. Combination tightness build rate

| | |
| --- | --- |
| Gym mitts | `ComboMastery.tightness_gain` `:39` — `TIGHTNESS_GAIN_PER_WEEK 6.0` × quality × condition × coach × fraction. Called from `GameState.gd:3920` (combinations station). |
| Camp | `FightCamp.week_effects` `:196` — `track_entry.tightness_per_week * scale`. A **second path**, not `tightness_gain`. |
| Attach | Multiply `ComboMastery.tightness_gain` by the same `learning_factor` (0.70–1.30). Camp tightness_delta gets the same factor in L1 so a camp week and a mitt week agree. Decay (`TIGHTNESS_DECAY_PER_WEEK 3.0`) is rust, not stupidity — **do not** scale decay by Learning. |
| Test | `combo_training_test.gd:26-29` (strong > weak, a day's slice is a seventh). Identity at 50 leaves the numbers alone. A seeded Analytical vs Temperamental case is the new contract. |

#### E. Fight-plan comprehension (how much of an archetype's edge he gets)

Two live sites, both apply the plan at **full strength** today:

| Site | File | What it does |
| --- | --- | --- |
| Duel | `PlanCoach.duel_score` `:37` | `0.55*stats*freshness + 0.25*arsenal + 0.10*FightPlans.duel_alignment(plan, battle) + 0.10*roll` |
| Draw | `FightSimulation._weighted_choice` `:2181` | `FIGHT_PLAN_MULTIPLIER` (PRIMARY 1.4 … AVOID 0.15) from the archetype `role_map`, then `phase_factor`, then the duel edge |

**Attach to the alignment term first**, not the whole score:
`alignment * lerp(0.55, 1.45, learning/100)` so at 50 the 0.10 weight is
unchanged. A sponge actually runs the plan in the duel; a slow learner
fights their habits even when the corner named a Muay Khao.

The draw (`_weighted_choice` `:2209-2211`) is Stage L2. Scaling PRIMARY 1.4
toward 1.0 for a slow learner *is* "how much of the archetype they get",
but it retunes every plan-vs-plan test. Do not bundle it with the gym
hooks. Identity at 50 = 1.0 on that scale too, when it ships.

Do not let Learning unlock techniques or rewrite `requires.roles`. The
catalog gate stays learned + stamina.

### 10.5 What the player sees — VISIBLE BUT UNCERTAIN

A **fog-band gauge**, kit language (gauge cell, not a slider). Scouting
says "might learn fast"; eight weeks in *this* gym say whether he does.

```
     LEARNING                              ?
    ─────────────────────────────────────────
    ░░░░░░██████████████░░░░░░░░░░░░░░░░░░░░
          └──── fog band ────┘
     SCOUT: MIGHT LEARN FAST
     8 WEEKS IN THE GYM TO KNOW
```

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 420 96" width="420" height="96">
  <rect width="420" height="96" fill="#0c1218"/>
  <rect x="8" y="8" width="404" height="80" fill="#141c26" stroke="#2a3a4a"/>
  <text x="20" y="28" font-family="IBM Plex Mono, monospace" font-size="11"
        fill="#8aa0b4" letter-spacing="1.8">LEARNING</text>
  <text x="400" y="28" text-anchor="end" font-family="IBM Plex Mono, monospace"
        font-size="16" fill="#f5c23b">?</text>
  <rect x="20" y="40" width="380" height="12" fill="#1c2836"/>
  <rect x="110" y="40" width="152" height="12" fill="#3d5a73"/>
  <rect x="110" y="40" width="152" height="12" fill="#f0c233" fill-opacity="0.35"/>
  <text x="20" y="72" font-family="IBM Plex Mono, monospace" font-size="9"
        fill="#f5c23b">SCOUT: MIGHT LEARN FAST</text>
  <text x="400" y="72" text-anchor="end" font-family="IBM Plex Mono, monospace"
        font-size="9" fill="#8aa0b4">8 WKS TO KNOW</text>
</svg>
```

Rules:

- The player **never sees the true number** until the band has collapsed.
  No midpoint tick (a smart player would just read the middle).
- Band always contains the true value. Width starts at **18**.
- Each *productive gym week* (a Move Lab session that returned
  `advanced`/`learned`, a mitt week that applied `tightness_gain`, or a
  fight-camp week) narrows width by **2.25**. Eight such weeks → 0 → the
  number and the band (SLOW / STEADY / QUICK / SPONGE) print in gold.
- Phrase from what the band **guarantees**, not from the midpoint:
  - `high ≤ 34` → LEARNS SLOW
  - `low ≥ 65` → LEARNS FAST
  - `low ≥ 85` → SPONGE
  - otherwise → MIGHT LEARN FAST if more than half the band sits ≥ 65,
    MIGHT LEARN SLOW if more than half sits ≤ 34, else UNCLEAR
- Recruitment / world fighters the gym has not trained: full width 18,
  phrase from the band. Personality is allowed to colour the *expectation*
  in flavour text ("Analytical — the tape may take") but the gauge still
  follows the band, not the label.
- Tenure is **not** the fog source. Sitting on the roster without drilling
  must not collapse it. Derive L0 from evidence already on the athlete:
  max `technique_progress.*.weeks_trained` plus 2 if
  `combo_tightness_trained` plus fight-camp history weeks. No new save
  field until that proves noisy (then `athlete["learning_seen"]` as an int).

Home on the profile: DEVELOPMENT tab / the training column, next to
potential. Not on the grade dial. Not on the TRAIT PLATE.

### 10.6 Cheapest honest first version, then what follows

**L0 — one derived value, the fog-band gauge, two hooks (1 commit).**

1. `Personality.learning(athlete)` + the shift table + id-hash spread.
   No `athlete["learning"]` write. Missing → 50.
2. Fog helper from existing gym evidence (§10.5). Gauge specified for the
   profile redesign; **not built in this research commit**.
3. Two hooks, identity at 50:
   - `AthleteDevelopment._session_progress_units` (techniques **and** MMA
     transition, one factor). Replace the fight_iq gym-speed term.
   - `ComboMastery.tightness_gain`.
4. Tests: Analytical derived > Temperamental; omitted field = 50 leaves
   `combo_training_test` and any session-unit fixture unchanged; rating
   (`get_athlete_rating`) unchanged when Learning is 90.

This is the whole "the gym already pretends Fight IQ is Learning" bug,
plus a scoutable number, without touching camp, the sim, or the profile
scene.

**L1 — film + discipline XP + camp tightness (1 commit after L0).**

- `FightCamp.week_effects` film_gain as in §10.4 C; camp tightness_delta
  the same factor as mitts.
- `preview_discipline_week_gain` Learning term, IQ transfer kept.
- Build the fog-band gauge on DEVELOPMENT (profile P4) and a scout pip on
  recruitment. Pulse the TRAIT PLATE? No. Learning is not personality.

**L2 — the fight understands the plan (own commit, after L1).**

- `PlanCoach.duel_score` alignment term × Learning.
- Then, separately, `_weighted_choice` plan multiplier. Re-tune, do not
  sneak it into L1.
- Optional authored `athlete["learning"]` on featured names that need to
  sit off the hash ("The Greatest" as a sponge).

Do not bundle L0 with personality Stage A if A is already the "four labels
do nothing" commit. Personality A makes the word true; L0 makes the gym
honest. They share `Personality.gd`. Ship A first, L0 immediately after,
same file.

---

## 11. WHAT BREAKS

Every number already tuned against today's flat behaviour.

| Fixture | File | Assertion | If we… |
| --- | --- | --- | --- |
| Ambitious asks more than Loyal | `fighter_requests_test.gd:36` | `roll_chance("Ambitious") > roll_chance("Loyal")` | Keep the inequality. Featured synonym map does not touch this. |
| Loyal Excellent / Temperamental Toxic / Disciplined Neutral | `retention_test.gd:30-35` | bands | Filling silent labels: safe. Axis rewrite: re-tune until these three still land. |
| Gym Loyalty set-point > mercenary | `coach_rapport_test.gd:57-59` | ambition bonus | Personality add-on must not invert this. Test a Loyal vs Temperamental pair as well. |
| Camp injury 6% / amber / red×fatigue×age / zero technical | `fight_camp_test.gd:39-45` | exact 0.06 / 0.12 / >0.3 / 0.0 | Default axes = 50 must leave these numbers unchanged (`lerp` through 50 = 1.0). Seeded tests that omit `personality` stay valid. |
| Fatigue 0.15 | `GameState.gd:4770` | no dedicated test found; seeds `injury|id|week` | Changing 0.15 changes who gets injured on a given week. Keep 50-axis as 0.15. |
| Fight injury 0.55 / 0.35 | `GameState.gd:9379` | settlement tests may seed this | Same: identity at 50. |
| Featured ask rate | none | currently 1.0 | **Stage A synonym map will change** how often named stars ask. That is the point. Call it out in the handback. |
| Request daily scale (R8) | `GameState.gd:6182` | daily × weekly weights | Do not retune `request_daily_scale` to "fix" personality. |
| Mitt tightness day-slice | `combo_training_test.gd:26-29` | strong > weak; 7 days = 1 week | Identity at Learning 50 must leave these equal. |
| Film report by depth | `fight_camp_test.gd:66-68` | depth 1/2/3 contents | Hook `week_effects`, never `film_report`. |
| Session units use fight_iq | `AthleteDevelopment.gd:760-767` | no dedicated test found | L0 *replaces* this factor; default Learning 50 is a slight nerf vs mid fight_iq (today 50 IQ → ×1.10). Call it in the handback. |
| Overall rating | `GameState.get_athlete_rating` `:4874` | mean of six `STAT_KEYS` | Learning must not enter the mean. Assert a sponge rates the same as a slow learner with the same stats. |
| Duel weights | `PlanCoach.duel_score` `:47` | 0.55 / 0.25 / 0.10 / 0.10 | L2 scales the 0.10 alignment term only; identity at 50. |

Do not touch `_advance_day` / `_advance_week` / `_advance_*` from a
personality commit. R8 owns those. New ticks (`_tick_ages`) are a later
stage and need Claude's insertion point.

---

## 12. STAGES (each shippable alone; cheapest honest first)

### Stage A — make the word true (1 commit, no new save field)

1. `Personality.gd` (pure, like `Retention.gd`): eight-label table,
   synonym map for featured flavour, `axes(athlete)` derived at read
   (no write).
2. `FighterRequests.personality_weight`: resolve synonyms before lookup
   so "Showman" = Charismatic = 1.2, not 1.0.
3. `Retention.PERSONALITY_SHIFT`: fill the five silent labels with modest
   values (table in §4.2). Three existing fixtures unchanged.
4. `CoachRapport.set_point`: add a `bond`-scaled term on top of Gym
   Loyalty. Tests extended, Gym Loyalty assertion kept.
5. Tests: `fighter_requests_test` (Showman == Charismatic weight),
   `retention_test` (Charismatic now slightly above Disciplined, Loyal
   still Excellent), `coach_rapport_test` (Loyal label > Temperamental).
6. Still no fight, camp, aging, injury, development.

This is the whole "four labels do nothing" bug, plus the featured-roster
hole, without asking the user to accept a new system. The TRAIT PLATE is
specified in §9; it is built in profile redesign P4, not here. LEARNING
is **not** in Stage A — it is L0, next paragraph.

### Stage B — relationships + build-up + the fight (1–2 commits)

Axes become the source of truth for **new** hooks; asks/loyalty still
use the tables until a dedicated retune commit.

- Press backlash × composure; hype pay × show.
- Camp protocol willingness (morale, not a lock); `injury_chance` × nerve
  with identity-at-50.
- Sim: morale-hurt × composure; finish suggestion × nerve; listen hurt
  penalty × composure.
- Rivalry decay × composure.
- Optional: persist `personality_axes` on featured athletes that need a
  custom mix ("The Greatest").

No aging. No potential rewrite.

### Stage C — ceilings, aging, career length (own stage, after A/B, coordinated with Claude)

- `_tick_ages` (52-week), peak window, post-peak decline, retirement offer.
- `drive`/`composure` on headroom and decline slope.
- Injury rates already from B; CAREER DAMAGE (future) reads outcomes.

Do not bundle C with A. The user asked for an investigation, not a
birthday system smuggled in under personality.

### Stage L0 / L1 / L2 — LEARNING (own track, after personality A)

Specified in §10.6. L0 is the cheapest honest version: one derived
value, fog from existing gym evidence, two hooks
(`_session_progress_units`, `ComboMastery.tightness_gain`). Shares
`Personality.gd` with Stage A. Do not fold L0 into A; A is already the
synonym-and-silent-labels commit. L1 is film + discipline XP + the
fog-band gauge on DEVELOPMENT. L2 is plan comprehension in the duel,
then the draw.

---

## 13. Decisions for the user

1. **Model:** label + five derived axes (recommended), keep eight-label
   switches forever, or replace the word with sliders. Recommendation:
   label + axes.
2. **Featured 100:** synonym map (recommended, Stage A), rewrite every
   flavour string to one of eight (destroys identity), or author axes on
   each of the 100 now (correct, expensive).
3. **First ship:** Stage A only (recommended), or A+B together.
4. **Asks/loyalty tables:** keep as source of truth until a retune
   (recommended), or jump to axis formulae in the first commit (breaks
   `retention_test` / `fighter_requests_test` until re-tuned).
5. **Camp protocols:** willingness + morale (recommended), or personality
   locks hard sparring away (the gym should still be allowed to force it).
6. **Aging / retirement:** new Stage C after A/B (recommended), or leave
   age static forever and only use the existing 30/33 camp multipliers.
7. **CAREER DAMAGE:** personality owns rates, future stage owns scars
   (recommended). Do not start scars here.
8. **Injury identity at 50:** any formula must be 1.0 at axis 50 so
   `fight_camp_test` and un-seeded injury rolls do not move (required).
9. **Visible artifact:** TRAIT PLATE (recommended — cut-corner word +
   one dominant axis + live chips, same object on recruitment and the
   profile), five-axis radar (FM's wall), or a P4P-style ring around
   overall (wrong object: that is a relationship meter).
10. **Learning:** derived development trait 0–100, out of overall, fog-
    band gauge (recommended); a seventh combat stat in `stats{}` (pollutes
    the grade dial); or hidden (forbids the visible-artifact rule).
11. **First Learning ship:** L0 only — two gym hooks + derived value +
    fog helper (recommended); L0+L1 with the gauge built; or L0 folded
    into personality Stage A (makes A too big).
12. **Fight IQ in `_session_progress_units`:** replace with Learning
    (recommended — that factor is already a fake Learning); keep both
    (double-count); or keep IQ and add Learning on top of camp only
    (leaves the Move Lab lying).
13. **Career goals:** 1–3 derived goals on top of the existing one
    Ambition (recommended — Ambitions stay the long arc, goals are the
    near-term cards); replace Ambitions with personality goals (throws
    out a shipped system); or display-only with no ask/contract hooks
    (cheap, and the Career Arc on DEVELOPMENT stays a caption).

---

## 14. CAREER GOALS — 1 to 3, from personality and situation

Added 2026-09-04, feedback -03 mark 3: the Career Arc on DEVELOPMENT
must show the fighter's *own* goals with progress, as cards. This is
the investigation; nothing here is built.

### 14.1 What already exists (do not invent a second ambition)

`Ambitions.gd` is already a **single** long-horizon arc per fighter
(`athlete["ambition"]` → one of six labels, `evaluate` `:75` returns
`{id, label, progress 0–100, milestones[], complete}`). Context is
wins / fame / belt / earnings / learned_count / proficiency / signed
tier / tenure. Effects: morale per milestone, morale+fame on
fulfilment. Distinct from weekly objectives.

There is **no `ContractTalks.gd`**. Contract conversations today are:

| What the assignment named | What actually exists |
| --- | --- |
| ContractTalks | `Retention.renewal_ask` `:130` (expired-contract demand from the loyalty band) and `FightContract.package_value` `:198` (bout terms, not gym tenure) |
| Asks | `FighterRequests` + `fighter_requests.json` — seven ids: `title_shot`, `step_up`, `raise`, `rest`, `hometown`, `release`, `rematch` |
| Rivalries | `Rivalries.stoke` / `heat_after_week`; title-chase +2/week while both top 5 |

Career goals must **not** replace Ambitions. Ambition is "I want to be
world champion someday." A goal is "I want a title shot *this season*."
One arc, up to three live goals. Pound for Pound's request list is the
market analogue for the *ask*; Football Manager's short-term player
goals (play in first team / win a trophy) are the analogue for the
*card*. Ours should be the card with a fill, not a second ambition
ladder.

### 14.2 The seven goals (assignment's list, made measurable)

Each goal is a card: id, player label, progress 0–100 from state the
save already has, a kept-condition (what a booking / signing / raise
does to it), and the ask it would raise.

| id | Player label | Progress (all live fields) | Personality bias | Situation gate |
| --- | --- | --- | --- | --- |
| `rank_up` | RANK UP | from division rank 15→1 (`get_division_rankings`) | drive high (Ambitious, Fearless) | ranked 4–15, no belt |
| `top_promotion` | REACH THE TOP PROMOTION | 0 unsigned / 50 signed below S / 100 signed S (`get_athlete_promotion`) | show + drive (Charismatic, Ambitious) | not S-tier signed |
| `champion` | BECOME CHAMPION | 50 if top 3, 100 if `get_athlete_titles` is non-empty | drive + nerve (Ambitious, Fearless) | no belt |
| `mastery` | MASTER THE ART | `learned_count/10 * 50 + proficiency/80 * 50` (same numbers Ambitions already uses) | composure (Analytical, Disciplined) | proficiency < 80 or learned < 10 |
| `get_paid` | GET PAID | salary / market (`Retention.loyalty` already takes both) | drive, low bond (Ambitious) | salary < market |
| `stay_loyal` | STAY HERE | tenure/52, same as Gym Loyalty ambition | bond (Loyal) | rostered, not toxic |
| `retire_on_top` | RETIRE ON TOP | 0 until age ticks (§7). Honest: **do not ship this card** until Stage C aging exists. Showing it now would be a fake. | composure | age ≥ 33 *once age ticks* |

Pick **1–3** at read time. Score each gated goal
`personality_shift + situation_urgency`, take the top three that score
above a floor (recommend 0). A Loyal fighter with a belt and a fair
wage may hold only `stay_loyal`. An Ambitious unsigned prospect holds
`rank_up` + `top_promotion` + `champion`.

Deterministic: `Personality.career_goals(athlete, context) -> Array`.
No save field in Stage A. When a goal completes it drops off and the
next eligible one slides in (same helper, next week). Do not persist a
queue until a fighter actually needs a memory of a abandoned goal.

Featured flavour uses the synonym map (§3.4) so "The Greatest" scores
as Charismatic+drive, not as a blank.

### 14.3 How goals move the systems that already fire

**Asks (`FighterRequests`).** Today `roll_chance` is
`base_chance * personality_weight`, then a trigger decides *which* ask.
Goals re-tune the *which*, not the dice:

| Goal | Ask it promotes | What to attach |
| --- | --- | --- |
| `champion` | `title_shot` | extra weight if the goal is live and rank ≤ 3 |
| `rank_up` | `step_up` | extra weight; a `title_shot` trigger still wins if both fire |
| `get_paid` | `raise` | extra weight; Loyal+`stay_loyal` currently *suppresses* raises (ask weight 0.6) — keep that inequality |
| `stay_loyal` | suppresses `release` | do not raise a release while this card is live |
| `top_promotion` | none today | a future "sign me" ask; until then the DWCS/signing desk is the path. Do not invent a request id in Stage A. |
| `mastery` | none | the Move Lab is the path; a goal card, not an ask |

Stage A: no roll change. Stage B: multiply that ask's trigger weight by
`1.4` when the matching goal is live, identity when none is. Test
contract: `fighter_requests_test.gd:36` Ambitious > Loyal still holds.

**Morale.** Completing a goal: `+6` (same band as a kept promise,
`fighter_requests.json` `kept_morale: 6`). A booking that *contradicts*
a live goal (a local can when `rank_up` is live; a rest-week when
`champion` is live): `-4` once, not a grudge. Ambition milestone morale
(`Ambitions.MORALE_PER_MILESTONE := 4`) stays; do not double-pay if the
ambition and the goal complete on the same week — pay the ambition, skip
the goal bump.

**Contract talks (`Retention.renewal_ask`).** The band already prices
the renewal. Goals nudge *inside* the band, they do not skip it:

- `stay_loyal` live: treat the band as one step kinder (Strained uses
  Neutral's formula). Loyal fighters already get `PERSONALITY_SHIFT +8`;
  this is the visible "I'll stay for less" on the card, not a second
  loyalty axis.
- `get_paid` live: never take the Excellent pay-cut (`* 0.9`). An
  Ambitious Excellent fighter with `get_paid` open wants market.
- Identity at "no live money goal": today's table unchanged.
- `FightContract` bout talks stay purse/clauses. Goals do not belong on
  a fight-night contract.

**Rivalries.** `champion` or `rank_up` live: the weekly title-chase
`+2` (already in `Rivalries` / GameState) is enough; do not add a second
heat drip. `stay_loyal`: do not start a teammate feud from a sparring
war while the card is live (the gym is the point). Fearless + `champion`
can still accept a callout — nerve is not loyalty.

**Booked fight.** `_note_request_booking` already keeps or breaks asks
from the bout. Goals ride the same hook:

- A title bout keeps `champion`. A bout one tier up keeps `rank_up`.
- A hometown card does nothing to these cards (that is still the
  hometown ask).
- A rest booking while `champion` or `rank_up` is live is the `-4`
  contradiction, not a broken promise (the ask machinery stays for
  promised asks).

Do not touch `_advance_*`. Same insertion rule as personality: the
helper is pure; GameState calls it from the request/booking sites that
already exist.

### 14.4 The card (presentation)

Feedback -03 mark 3 asked for **goal cards**, not a caption. DEVELOPMENT
Career Arc, kit pair/gauge language, gold on near-black:

```
  ┌─────────────────────────────────────────┐
  │  BECOME CHAMPION              50%       │
  │  ██████████░░░░░░░░░░░░                 │
  │  TOP 3 · NO BELT YET                    │
  └─────────────────────────────────────────┘
  ┌─────────────────────────────────────────┐
  │  REACH THE TOP PROMOTION      50%       │
  │  ██████████░░░░░░░░░░░░                 │
  │  SIGNED · NOT S-TIER                    │
  └─────────────────────────────────────────┘
```

One card per live goal, fill from the progress formula, a one-line
situation under it (not a paragraph). Completing a card is a small
hold — gold fill to 100, then the next goal slides in. Reduced-motion:
instant swap. This is P4 profile work, not G5.

### 14.5 Cheapest honest first version

**G0 (research is this section).** No code.

**G1 — derive and show (1 commit, after personality A).**
`Personality.career_goals(athlete, context)` returns 1–3 cards from the
table above. Context is the same dict Ambitions already receives. No
new save field. DEVELOPMENT draws the cards (profile P4) or, until then,
a desk line. `retire_on_top` omitted. No ask/contract/rivalry change.
Tests: Loyal unsigned fighter includes `stay_loyal`; Ambitious unsigned
includes `top_promotion` and not `stay_loyal` as the lead; a champion
drops `champion` and does not keep a 100% filled dead card.

**G2 — hooks (1 commit after G1).** Ask weights, renewal nudge,
booking contradiction morale. Identity when no money/title goal is live
so `retention_test` and `fighter_requests_test` stay green.

Do not fold G1 into personality Stage A. A is the word; this is the
Career Arc. They share `Personality.gd`.

### 14.6 What breaks

| Fixture | If we… |
| --- | --- |
| Ambitions six-label evaluate | Goals must not write `ambition_state`. Separate helper. |
| `fighter_requests_test.gd:36` Ambitious > Loyal | G2 extra weights on *which* ask, not `roll_chance`. |
| `retention_test.gd` Loyal Excellent / Temperamental Toxic | Renewal nudge stays inside the band; Excellent+`get_paid` is the one new case and needs its own test. |
| Title-chase +2 heat | Do not add a second drip. |

---

## Sources

Live code: `WorldPopulation.gd` (`PERSONALITIES`, `_generate_athlete`),
`FighterRequests.gd` + `fighter_requests.json`, `Retention.gd` +
`retention_test.gd`, `CoachRapport.gd` + `coach_rapport_test.gd`,
`RecruitmentScreen.gd:648`, `GameState.gd` (request fire `:6182`, fatigue
injury `:4767`, camp injury `:1220`, fight injury `:9377`, stat gain
`:3881`), `FightCamp.gd:141` + `fight_camp.json` + `fight_camp_test.gd`,
`FightSimulation.gd` (morale constants, listen, finish option),
`PressConferences.gd` (`backfires`, `option_hint`), `Rivalries.gd`
(`stoke`, `heat_after_week`), `AthleteDevelopment.gd` (discipline gain,
fight IQ), `BodyReadiness.gd` (`_apply_recovery`),
`featured_real_athletes.json` flavour strings, `Ambitions.gd` (kept
separate), `ComboMastery.tightness_gain` `:39` + `combo_training_test.gd`,
`AthleteDevelopment._session_progress_units` `:754` / `train_technique`
`:257` / `advance_mma_transition` `:686` / `preview_discipline_week_gain`
`:538` / `derive_fight_iq` `:583`,
`TechniqueTrainingCoordinator.run_scheduled_week` `:409` /
`run_mma_transition_week` `:284`, `FightCamp.week_effects` `:196-217` /
`film_report` `:286` + `fight_camp.json` `film_study`,
`PlanCoach.duel_score` `:37`, `FightPlans.duel_alignment` `:74`,
`FightSimulation._weighted_choice` `:2181` (`FIGHT_PLAN_MULTIPLIER`),
`GameState.get_athlete_rating` `:4874` (`STAT_KEYS`),
`PROFILE_DESIGN_BRIEF.md` §8 (earlier plate sketch; this document is now
the source for the artifact). House style: `research/FIGHT_PLANS_RESEARCH.md`.

Sport / management: Football Manager personality-as-label-over-mentals
(Professionalism, Ambition, Temperament, Pressure); MMA Tycoon hidden
training/happiness; common coaching language (professionalism, killer
instinct, composure, media, durability). FM's hidden Determination /
Professionalism is the closest analogue to LEARNING; nobody in the MMA
manager set surfaces a scoutable absorb-rate with a collapsing fog band
— that is the beat. Peak-age ranges are coaching
heuristics, not a study — Stage C must keep them authored and
class-specific, not a single curve.

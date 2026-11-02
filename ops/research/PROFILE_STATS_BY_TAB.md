# Fighter Profile — stats by tab & subtab

Content map only (what to show). Grounded in live `GameState` / athlete fields.
Sample binding: featured athlete shape + runtime getters. No UI chrome brief.

---

## Persistent chrome (every tab)

Always visible while on this fighter:

| Block | Stats / fields |
| --- | --- |
| Identity | `name`, discipline glyph (`primary_discipline` / `discipline`), `weight_class`, `country` (+ flag), `age`, `sex`, `status` |
| Tape basics | `height_cm`, `reach_cm`, `competition_weight_kg` / walk weight when present, `stance` (when set) |
| Record | `record.wins/losses/draws`, `record_display`, KO/SUB/DEC splits when available (`wins_by_ko` etc.), `streak` |
| Accomplishments shelf | World/division **rank** (from rankings), **overall grade** (derived from six stats), **ceiling** (`potential`), **belt(s)** (`get_athlete_title` / multi later), **night awards count** (`get_athlete_awards`), **fame** + band, **promotion standing** stars if signed |
| Status chips | Open ask band, rivalry heat chip, in-camp week, weight-move settling, personality label, medical hold |
| Primary actions | Compare, Tale of the Tape, Training Plan, **Send to Fight Camp** (enabled only if `booked_fight`) |

---

## Tab 1 — OVERVIEW (Athlete Lab)

### Subtab 1.1 Decide Now
| Panel | Stats |
| --- | --- |
| He is asking | `get_athlete_request`: ask type, quote/prompt, deadline weeks, actions (PROMISE/DEFER/DECLINE/GRANT), consequence hints, grudge, promises kept/broken |
| Next fight | `booked_fight` offer: opponent name/id, event, tier, purse, win bonus, heat/grudge band, `bout_hype`, chosen fight plan archetype + coach line, weeks out, press questions waiting count |
| Camp & weight (summary) | Camp week `weeks_done/weeks`, focus track, protocol, film depth, injury risk %; weight: current, limit, walk, % to cut, on_track / can_make, weigh-in day, cut plan |

### Subtab 1.2 Form & Readiness
| Panel | Stats |
| --- | --- |
| Form | Last N results (W/L/D), streak text, sharpness note |
| Vitals | Body readiness average + minimum region, `fatigue`, `morale`, derived/current conditioning |
| Clearance | Training clearance clear/reasons, competition clearance clear/reasons, medical hold until week + reason |
| Fight-ready snapshot extras | Coach-adjusted stats preview, `corner_rapport`, `combo_tightness`, settle penalty if mid weight-move |

### Subtab 1.3 Attributes
| Panel | Stats |
| --- | --- |
| Six bars | `power`, `technique`, `speed`, `defense`, `conditioning`, `fight_iq` — each **current → potential/ceiling** |
| Derived | Overall letter + numeric average, `potential`, career rating / current rating if exposed |
| Deltas | Week-over-week arrows when available from training/fight gains |

### Subtab 1.4 Snapshot strip
| Panel | Stats |
| --- | --- |
| Specialties | Per-discipline specialty scores (e.g. mma / boxing / BJJ) |
| Natural style | `get_natural_fight_plan` / best-fit archetype id + plain brief |
| Ambition peek | Ambition label + progress % (full ladder on Career) |

---

## Tab 2 — BODY

### Subtab 2.1 Regions
| Stats |
| --- |
| Six regions: `head_neck`, `torso_core`, `left_arm`, `right_arm`, `left_leg`, `right_leg` — value, colour band, leaders |
| Selected region detail: severity, recovery forecast weeks, assigned recovery station, focus |

### Subtab 2.2 Medical
| Stats |
| --- |
| Competition / training clearance, hold reason & week, injury list from camp/fight, doctor notes |
| Fatigue, permanent vs current conditioning |

### Subtab 2.3 Weight
| Stats |
| --- |
| `get_weight_status`: class, limit, allowance, current weight, walk weight, excess, needed/safe/max cut fractions, on_track, can_make, night penalty (stamina / hurt), message |
| Diet `plan` (none/moderate/aggressive), weigh-in `action`, booked flag, weigh_in_week/day, weeks_to_fight |
| Weight-move program if active: direction, weeks done/total, projected walk, ranking carry, belt warning, cooldown |

---

## Tab 3 — STYLE & ARSENAL

### Subtab 3.1 Fight plan
| Stats |
| --- |
| Natural style id + explainer |
| Booked plan archetype: role priority, pace curve summary, target bias, phase, banks, availability reason |
| Signature battle: duel name for ruleset, career `signature_battles` won/lost/last, last-fight duel result |

### Subtab 3.2 Combos
| Stats |
| --- |
| `get_athlete_combos`: `tightness`, `signature_chain`, `game_plan_chains` |
| Per chain: name, tier, links, usable, signature flag, game_plan flag, attempts, lands |

### Subtab 3.3 Skills & moves
| Stats |
| --- |
| Catalog counts: learned / in-training / locked |
| Technique tree by primary discipline: tier, branch, progress %, gate blockers (proficiency, belt, ranked win) |
| Moves leveled by fight use; “learned in fight” flags from history |

### Subtab 3.4 Development
| Stats |
| --- |
| `discipline_proficiency` per art + belt rank chip (karate/tkd/judo/BJJ) or gatekeeper status (other arts) |
| MMA transition: requirements list, progress, begin CTA state |
| Derived Fight IQ breakdown vs raw |
| Age / peak notes when aging system exists (today: static `age` only — show age, don’t invent peak curve) |

---

## Tab 4 — CAMP

### Subtab 4.1 Setup / Progress / Report (state machine)
| Mode | Stats |
| --- | --- |
| Setup | Tracks, protocols, partner role + candidates (roster/world + fee), visiting coach slots/fees, counters unlocked by film, cut plan, **full projection** (edges, tightness, fatigue on night, injury risk, film depth, cash, Fight IQ) |
| Progress | Week strip, log lines, edges vs projected, film depth, body/fatigue, injury rolls, counter pick at depth 3, cash spent, pull-out |
| Report | Grade, built vs projected, injuries, cost, Fight IQ gained, history entry |

### Subtab 4.2 Camp shape (bout-only)
| Stats |
| --- |
| Active edges with magnitudes (strike success, TD weight, sub defense, stamina cost, evasion, etc.) |
| Partner role, specialist name, protocol name, weeks remaining |

---

## Tab 5 — RECORD

### Subtab 5.1 Fight log
| Stats |
| --- |
| Full `fight_history` / recent: result, opponent (link), event (link), tier, method, round, time, hype / hype_earned / hype_bonus, purse, awards_total, duel note, short_notice, promotion/DWCS flags |
| Filters: all / finishes / decisions / title / grudge |

### Subtab 5.2 Rivalries
| Stats |
| --- |
| `get_athlete_rivalries`: rival name, heat, band, record, status, source, meetings, weeks since contact, grudge_match on board, last log beat |

### Subtab 5.3 Tale of the tape (deep link / embed)
| Stats |
| --- |
| Side-by-side vs next opponent: record, rank, stance, reach, height, plan, specialties, recent form |

---

## Tab 6 — CAREER

### Subtab 6.1 Ambition
| Stats |
| --- |
| `get_athlete_ambition`: **evaluated** `label` (not raw JSON if unmapped), `progress`, milestones `{id,label,done}`, complete, started/completed week |

### Subtab 6.2 Fame & ranking
| Stats |
| --- |
| `fame`, fame band text, `ranking_points`, division rank, title holders nearby |
| Career purses / `career_earnings`, wins by method |

### Subtab 6.3 Achievements
| Stats |
| --- |
| Featured `achievements[]` lines (as trophy shelf captions) |
| `get_athlete_awards` list: name, event, week, payout |
| Grand Prix titles if any |

### Subtab 6.4 Contender / signing path
| Stats |
| --- |
| `get_athlete_promotion` or unsigned |
| Live signing offers / DWCS invite: org, tier, **in-fight goals** text, cooldown if failed |
| Promotion standing, slate remaining bouts if exclusive |

---

## Tab 7 — RELATIONSHIPS

### Subtab 7.1 Gym & corner
| Stats |
| --- |
| Corner coach name (link), `coach_rapport` score/band, listen rate % |
| `get_athlete_loyalty`: score, band, parts (rapport/morale/pay/tenure), market vs weekly salary, contract_remaining_weeks, striking flag |
| Open poach / renewal offer if any |

### Subtab 7.2 Contract
| Stats |
| --- |
| `weekly_salary` / `salary_expectation`, `contract_weeks`, remaining, clauses on last deal (gate points, title-shot guarantee, rematch, missed-weight penalty) |
| Renegotiate / release affordances (desk actions) |

### Subtab 7.3 Media
| Stats |
| --- |
| `get_media_questions`: prompts, options with hype/heat/morale/fame/rep hints + risk |
| Bout hype now, hype earned this booking, last answer quote + fallout |
| Media history (last N) |

---

## Empty-state rules (honest)

Show the panel chrome, but empty copy when missing:

- No `booked_fight` → Next Fight + Camp CTA locked; Camp tab shows “book a fight”
- No `fight_camp` → shape/edges hidden
- No `technique_progress` → Skills shows zero learned
- No rivalries / awards / asks / media → “None yet”
- Unsigned → Signing path shows offers or “not on a roster deal”
- Ambition: always prefer `get_athlete_ambition.label` over raw `athlete.ambition` when they disagree

---

## Suggested default landing

Open on **Overview → Decide Now**. If an open ask or fight-week presser exists, that subtab stays primary until answered.

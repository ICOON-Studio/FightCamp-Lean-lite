# Q118 — What Does the Game Loop Actually Demand of the Player, Week by Week?

**Agent:** Qwen · **Date:** 2026-09-21 · **Source:** GameState.gd (14,808 lines)
**Check:** `python research/Q118_check.py` — exits 0, recomputes from source.

---

## 1. The Weekly Pass — What Happens When a Week Advances

The engine has two entry points: `advance_day()` (line 4989) and `advance_week()` (line 5131).
Days 0–5 call `advance_day()`; day 6 (Sunday) delegates to `advance_week()`. A direct
`advance_week()` call is also supported and gives the same result as walking seven days.

### Ordered steps, with kind

| # | Step | Kind | File:Line |
|---|------|------|-----------|
| 1 | Enforce pre-fight medicals (cancel bouts the commission blocks) | AUTOMATIC | GameState.gd:5001 |
| 2 | Check blocking athletes — fights due today must be attended | AUTOMATIC | GameState.gd:5008 |
| 3 | If Sunday: delegate to advance_week() | AUTOMATIC | GameState.gd:5030 |
| 4 | Apply daily training tick (1/7 slice of body/training effects) | PLAYER-DECIDED | GameState.gd:4810 |
| 5 | Advance daily systems (retention, requests, rivalries, media, short-notice) | AUTOMATIC | GameState.gd:4892 |
| 6 | Resolve unwatched events for the day | PLAYER-INTERRUPTIBLE | GameState.gd:2724 |
| 7 | Resolve weigh-ins scheduled today | AUTOMATIC | GameState.gd:1861 |
| 8 | **Sunday rollover → advance_week()** | | GameState.gd:5131 |
| 9 | Enforce pre-fight medicals (whole week) | AUTOMATIC | GameState.gd:5148 |
| 10 | Settle attended fights (pending_fight_result) | PLAYER-DECIDED | GameState.gd:5193 |
| 11 | Apply week_program slices (per-day training plan) | PLAYER-DECIDED | GameState.gd:5207 |
| 12 | Apply legacy training_focus (if no week_program) | PLAYER-DECIDED | GameState.gd:5231 |
| 13 | Apply weekly morale drift | AUTOMATIC | GameState.gd:5081 |
| 14 | Advance ambitions | AUTOMATIC | GameState.gd:6484 |
| 15 | Advance career goals | AUTOMATIC | GameState.gd:6551 |
| 16 | Advance aging (birthdays + retirement consideration) | AUTOMATIC | GameState.gd:7807 |
| 17 | Advance grades | AUTOMATIC | GameState.gd:5725 |
| 18 | Advance remaining unticked days of daily systems | AUTOMATIC | GameState.gd:5397 |
| 19 | Advance combo training (tightness decay) | AUTOMATIC | GameState.gd:10360 |
| 20 | Advance fight camps | AUTOMATIC | GameState.gd:1263 |
| 21 | Advance weight moves | AUTOMATIC | GameState.gd:1759 |
| 22 | Advance weight cuts | AUTOMATIC | GameState.gd:1838 |
| 23 | Settle billing (accrue payroll/upkeep, bill on month turn) | AUTOMATIC | GameState.gd:4942 |
| 24 | Sponsorship settlement | AUTOMATIC | GameState.gd:5426 |
| 25 | Increment week counter, reset day to 0 | AUTOMATIC | GameState.gd:5431 |
| 26 | Advance injuries | AUTOMATIC | GameState.gd:6468 |
| 27 | Advance tournaments | AUTOMATIC | GameState.gd:9631 |
| 28 | World population advance | AUTOMATIC | GameState.gd:5447 |
| 29 | Award completed cards | AUTOMATIC | GameState.gd:5449 |
| 30 | Refresh ranking snapshots | AUTOMATIC | GameState.gd:5450 |

**Summary:** 24 of 30 steps are AUTOMATIC. 4 are PLAYER-DECIDED (steps 4, 10, 11, 12). 1 is
PLAYER-INTERRUPTIBLE (step 6). The player's weekly work is choosing training and attending fights.

---

## 2. The Decision Inventory

24 decisions. Every one has a player writer. Zero UNKNOWN defaults.

### The ones that ruin a career if silently skipped

| Decision | Default if never made | Frequency (5yr) |
|----------|----------------------|-----------------|
| attend_fight | **BLOCKED** — day/week cannot advance | 104 |
| retention_renewal | Fighter **leaves the gym** | 12 |
| respond_to_request | Morale −6, grudge +6 after 4 weeks | 30 |

### The ones with sane defaults (can live three clicks deep)

| Decision | Default if never made | Frequency (5yr) |
|----------|----------------------|-----------------|
| training_focus | Rest for the week | 1040 |
| week_program | Falls through to training_focus or rest | 1040 |
| fight_plan | "balanced" | 104 |
| weight_cut_plan | "moderate" | 104 |
| set_selected_ruleset | "boxing" | 3 |

### Full table

| # | Decision | Reader | Writer | When | Default | Freq |
|---|----------|--------|--------|------|---------|------|
| 1 | training_focus | GS:5231 | assign_training():4123 | Every week | rest | 1040 |
| 2 | week_program | GS:5207 | set_week_program_day():4574 | Every week | rest (via legacy) | 1040 |
| 3 | technique_training_target | GS:5237 | assign_technique_training():4201 | Per session | No technique work | 100 |
| 4 | discipline_training_target | GS:5260 | assign_discipline_training():4276 | Per program | No discipline work | 10 |
| 5 | fight_offer_selection | GS:5152 | book_fight():10654 | Before fight week | No fight booked | 104 |
| 6 | fight_plan | GS:10654 | Player at booking | At booking | "balanced" | 104 |
| 7 | weight_cut_plan | GS:1847 | set_weight_cut_plan():1547 | Before weigh-in | "moderate" | 104 |
| 8 | weight_move_target | GS:1759 | start_weight_move():1706 | Any week | No move | 5 |
| 9 | sponsorship_offer | GS:322 | accept_sponsorship_offer():322 | When available | No sponsor income | 20 |
| 10 | promotion_signing | GS:5929 | accept_signing_offer():5929 | When available | Free agent | 4 |
| 11 | promotion_bout | GS:6354 | accept_promotion_bout():6354 | When on slate | Not booked | 52 |
| 12 | retention_renewal | GS:6673 | accept_renewal():6673 | On contract expiry | **Fighter leaves** | 12 |
| 13 | sign_recruitment | GS:452 | sign_recruitment_candidate():452 | When available | Not signed | 20 |
| 14 | negotiate_terms | GS:612 | propose_negotiation_terms():540 | During negotiation | Not signed | 20 |
| 15 | purchase_equipment | GS:3269 | purchase_equipment():3269 | Any time | No equipment | 20 |
| 16 | assign_coach | GS:14418 | assign_coach():14418 | When available | No coach bonus | 50 |
| 17 | release_coach | GS:14463 | release_coach():14463 | Any time | Coach stays on payroll | 10 |
| 18 | set_selected_ruleset | GS:3480 | set_selected_ruleset():3480 | Any time | "boxing" | 3 |
| 19 | accept_short_notice | GS:8630 | accept_short_notice():8630 | When slot open | Slot passes | 15 |
| 20 | accept_grand_prix_invite | GS:9099 | accept_grand_prix_invite():9099 | When announced | Seat forfeited | 5 |
| 21 | accept_contender_series | GS:6070 | accept_contender_series_invite():6070 | When invited | Invite expires | 5 |
| 22 | respond_to_request | GS:7047 | respond_to_request():7047 | Before deadline | **Ignored: morale −6** | 30 |
| 23 | attend_fight | GS:5008 | record_live_fight_result():11992 | Fight day | **BLOCKED** | 104 |
| 24 | watch_undercard | GS:2724 | record_watched_world_bout():2542 | On event day | Auto-resolved | 100 |

---

## 3. Frequency Ranking (5-Year Career, 260 Weeks)

Derived from the loop. Not measured by simulation. Assumes 4 athletes on the roster.

### Tier 1 — Touched constantly (1000+ times)
These are the weekly heartbeat. The interface must make them one or two clicks.

| Decision | Count |
|----------|-------|
| training_focus | 1040 |
| week_program | 1040 |

### Tier 2 — Touched regularly (50–200 times)
Per-fight decisions and recurring management.

| Decision | Count |
|----------|-------|
| fight_offer_selection | 104 |
| fight_plan | 104 |
| weight_cut_plan | 104 |
| attend_fight | 104 |
| watch_undercard | 100 |
| technique_training_target | 100 |
| promotion_bout | 52 |
| assign_coach | 50 |

### Tier 3 — Touched occasionally (10–50 times)
Per-season or per-event decisions.

| Decision | Count |
|----------|-------|
| respond_to_request | 30 |
| sponsorship_offer | 20 |
| sign_recruitment | 20 |
| negotiate_terms | 20 |
| purchase_equipment | 20 |
| accept_short_notice | 15 |
| retention_renewal | 12 |
| release_coach | 10 |
| discipline_training_target | 10 |

### Tier 4 — Touched rarely (1–5 times)
Once-per-career or once-per-division decisions.

| Decision | Count |
|----------|-------|
| weight_move_target | 5 |
| accept_grand_prix_invite | 5 |
| accept_contender_series | 5 |
| promotion_signing | 4 |
| set_selected_ruleset | 3 |

---

## 4. The Three Verbs

### BOOK — From offer to fight night

| Step | Action | File:Line | Surface |
|------|--------|-----------|---------|
| 1 | Present available fight offers | GS:11870+ | Fight desk UI |
| 2 | book_fight(athlete_id, offer_id, plan_id) | GS:10654 | Book fight button |
| 3 | advance_week blocks if due and unattended | GS:5152 | NO SURFACE — engine gate |
| 4 | _advance_fight_camps — camp progression | GS:1263 | NO SURFACE — automatic |
| 5 | _advance_weight_cuts — diet per weight_cut_plan | GS:1838 | Weight cut panel |
| 6 | _resolve_weigh_ins — weigh-in day before bout | GS:1861 | NO SURFACE — automatic |
| 7 | advance_day blocks on fight day | GS:5008 | Attend fight button |

### TRAIN — From assignment to body effect

| Step | Action | File:Line | Surface |
|------|--------|-----------|---------|
| 1 | assign_training(athlete_id, focus) | GS:4123 | Training hub panel |
| 1 | set_week_program_day(athlete_id, day, focus) | GS:4574 | Schedule hub panel |
| 2 | assign_technique_training(athlete_id, technique_id) | GS:4201 | Move Lab UI |
| 3 | assign_discipline_training(athlete_id, discipline_id) | GS:4276 | Discipline training UI |
| 4 | _apply_daily_training_tick — 1/7 slice per day | GS:4810 | NO SURFACE — automatic |
| 5 | advance_week resolves remaining slices + morale | GS:5207 | NO SURFACE — automatic |
| 6 | assign_coach(athlete_id, coach_id) | GS:14418 | Staff assignment UI |

### WATCH — From fight night to settlement

| Step | Action | File:Line | Surface |
|------|--------|-----------|---------|
| 1 | advance_day blocks — must attend | GS:5008 | Attend fight button |
| 2 | FightSimulation runs — produces sim_result | FightSimulation.gd | Live fight viewer |
| 3 | record_live_fight_result — freeze pending result | GS:11992 | NO SURFACE — called by viewer |
| 4 | _apply_fight_result — settle at week rollover | GS:12175 | NO SURFACE — automatic |
| 5 | record_watched_world_bout — watch undercard | GS:2542 | World event viewer |
| 6 | _resolve_unwatched_events — auto-resolve | GS:2724 | NO SURFACE — automatic |

---

## The One Trap — Player Writer vs. Engine Writer

Every decision in this inventory has a **player writer** — a function the UI calls when the
player makes a choice. There are no NO PLAYER WRITER decisions in the current engine. This
means every decision the engine reads is one the player CAN make, but not all of them have
a visible surface today. The gaps between "the engine reads this" and "there is a screen for
it" are exactly what the interface rebuild must close.

The decisions most in need of a surface, ranked by how silently they damage the career:

1. **attend_fight** — already has a surface (the fight night gate), but it is a HARD BLOCK
2. **retention_renewal** — fighter leaves if ignored; needs to be in the player's face
3. **respond_to_request** — 4-week silence penalty; needs visibility
4. **training_focus / week_program** — touched 1040 times; must be one click

# FightCamp Profile — three AAA information architectures

Three competing ways to organise **every live system** on the fighter profile.
Same data. Different subtab counts and decision gravity. Pick a direction.

Grounded in: `STAT_ORDER`, BodyReadiness regions, Fight Camp, WeightCut, Combos,
Plans/duels, Ambitions, Loyalty/Rapport, Requests, Rivalries, Press/Hype, Awards,
Promotion/DWCS, Titles, fight history.

---

## Shared AAA rules (all versions)

1. **Persistent identity strip** never changes between tabs: name, discipline, division, country, age, record, overall dial vs potential, fame, rank medal, belt/trophy shelf, status chips.
2. **Decide-first**: anything with a deadline (ask, presser, weigh-in, camp injury, poach) surfaces before vanity stats.
3. **Progressive disclosure**: summary numbers on the landing surface; drill-downs on subtabs — never hide a live system, never dump every field on one scroll.
4. **Honest empties**: chrome stays; copy says why it’s empty (no booking, unsigned, no chains yet).
5. **Entity links**: fighter, coach, gym, org, event names always deep-link.
6. **Evaluated ambition label** from `get_athlete_ambition`, not raw unmapped JSON strings.
7. **One primary CTA per context**: Promise / Answer press / Send to camp / Weigh-in act — never five equal gold buttons.

---

## Version A — “Command Deck” (FM / Racing Manager density)

**Philosophy:** One athlete = one deep desk. Few primary tabs, **rich subtabs**, tables and paired instruments. Best when the player lives in this screen for minutes.

**Primary tabs: 5** · **Subtabs: 18 total** (~3–4 each)

### A1 Overview
| Subtab | What is shown |
| --- | --- |
| **Alerts** | Open ask (type, deadline, four answers + consequence math); media questions waiting; poach/renewal; doctor hold |
| **Next Bout** | Opponent, event, tier, purse/bonus, heat medallion + band, bout hype, plan archetype + coach line, weeks out, short-notice flag |
| **Form** | Streak, last 5 W/L method, readiness avg/min, fatigue, morale, conditioning current vs permanent, clearances |
| **Attributes** | Six STAT_ORDER bars current→ceiling, overall letter, potential, week deltas, specialties radar (mma/boxing/BJJ…) |

### A2 Physical
| Subtab | What is shown |
| --- | --- |
| **Body Map** | Six regions with values; selected region detail, recovery forecast, assigned station |
| **Weight** | Limit, walk, current, cut %, plan, on_track/can_make, night penalty, weigh-in day/action, weight-move program |
| **Medical** | Training + competition clearance, hold reason/week, camp/fight injuries list |

### A3 Performance
| Subtab | What is shown |
| --- | --- |
| **Plan & Duel** | Natural style, booked plan (pace, targets, phase, banks), signature battle name + career W-L |
| **Combos** | Tightness, signature chain, game-plan list, per-chain usable/attempts/lands |
| **Skills** | Learned / training / locked counts + full technique tree with gates |
| **Development** | Discipline proficiency, belt or gatekeeper chip, MMA transition checklist, Fight IQ derived vs raw |

### A4 Camp
| Subtab | What is shown |
| --- | --- |
| **Board** | State machine Setup / Progress / Report — projection, edges, film, injury %, cash, IQ weeks |
| **Shape** | Bout-only edge magnitudes vs projected; partner/specialist/protocol |

### A5 Career Desk
| Subtab | What is shown |
| --- | --- |
| **Log** | Filterable fight_history (result, opponent, event, tier, method, rd, hype, purse, notes) |
| **Rivalries** | Heat, band, record, grudge offer, last beat |
| **Ambition & Fame** | Milestone ladder, fame band, ranking points, earnings |
| **Deal** | Loyalty parts, rapport, listen %, salary vs market, contract weeks, clauses, promotion/DWCS/standing, awards list |

**Why it’s AAA:** Matches Football Manager’s “one person, many ledgers” fantasy. Power users never leave the profile.

**Risk:** Can feel heavy for a first-year indie; needs ruthless visual hierarchy so Alerts still scream.

---

## Version B — “Fight Week Broadcast” (sports-TV / P4P-beater)

**Philosophy:** The profile is a **broadcast package**. Medium tabs. Subtabs only where the sport changes mode. Moments and shelves first; ledgers second.

**Primary tabs: 6** · **Subtabs: 11 total**

### B1 Tonight (default in fight week / with booking)
No subtabs — single composed surface:
- Ask / presser strip (if any)
- Next bout hero (opponent, heat, hype, purse)
- Camp & weight instruments
- Form lights (ready / fatigue / morale)
- Six attributes as compact pairs
- Signature duel + tightness as weapons HUD

### B2 Athlete
| Subtab | Stats |
| --- | --- |
| **Lab** | Body map + clearances + fatigue/morale |
| **Attributes** | STAT_ORDER → potential + specialties |
| **Weight** | Full cut / weigh-in / move program |

### B3 Corner
| Subtab | Stats |
| --- | --- |
| **Plan** | Natural + booked plan + duel record |
| **Combos & Skills** | Combos API + technique tree summary (deep tree link) |
| **Camp** | Full FightCampPanel modes |

### B4 Story
| Subtab | Stats |
| --- | --- |
| **Record** | Log + rivalries side panel |
| **Ambition** | Ladder + achievements/awards shelf |
| **Media** | Questions, hype history, last quotes |

### B5 Business
| Subtab | Stats |
| --- | --- |
| **Loyalty & Pay** | Loyalty breakdown, rapport, listen %, contract, clauses |
| **Promotion** | Signing state, DWCS goals, standing, slate |

### B6 Compare (optional modal-as-tab)
Tale of the tape vs booked or scouting target — not a data home, a tool.

**Why it’s AAA:** Feels like a premium fight-night UI. Beats text-manager competitors by making **Tonight** cinematic while still binding every system somewhere.

**Risk:** “Tonight” must degrade gracefully with no booking (becomes **This Week** gym focus).

---

## Version C — “Athlete OS” (console sports / franchise mode)

**Philosophy:** Many shallow primary tabs (console bottom bar energy), **0–1 subtabs** each. Instant recognition. Every system gets a door; none share a crowded room.

**Primary tabs: 10** · **Subtabs: 4 total** (only where unavoidable)

| Tab | Subtabs | Stats on the page |
| --- | --- | --- |
| **Home** | — | Identity shelf, alerts stack, next bout or “book a fight”, 3 vitals, overall dial |
| **Stats** | — | Six attributes → ceiling, specialties, ratings |
| **Body** | Regions · Medical | Region map / clearances & holds |
| **Weight** | — | Full weight + move program |
| **Style** | Plan · Arsenal | Plan/duel · combos + skills tree |
| **Camp** | — | Setup/Progress/Report |
| **Record** | — | Log + rivalries toggle in-header |
| **Fame** | — | Ambition, awards, achievements, ranking, earnings |
| **Locker** | — | Rapport, loyalty, contract, clauses, promotion/DWCS |
| **Press** | — | Media questions + hype timeline |

**Why it’s AAA:** Thumbable, teachable, streamer-friendly. Each tab is a poster.

**Risk:** More tab hopping; cross-links (“View camp from Tonight”) become mandatory.

---

## Side-by-side

| | A Command Deck | B Fight Week Broadcast | C Athlete OS |
| --- | --- | --- | --- |
| Primary tabs | 5 | 6 | 10 |
| Subtabs | **18** | **11** | **4** |
| Best fantasy | Deep manager | Fight-night producer | Franchise athlete card |
| Landing | Overview → Alerts | Tonight | Home |
| Closest comps | FM / Motorsport Manager | Broadcast package + P4P moments | NBA 2K / UFC 5 career menus |
| Build cost | Highest (many panels) | Medium (Tonight is the jewel) | Medium-high (many doors, shallow) |

---

## Recommendation (enhancement pass)

Ship **Version B** as the public face: **Tonight** is the screenshot that sells the game; Athlete / Corner / Story / Business hold the depth.

Keep **Version A’s Career Desk Deal subtab** packing (loyalty + clauses + promotion on one ledger) inside B’s Business tab — that’s the FM muscle players expect once they’re hooked.

Use **Version C’s tab names** as the vernacular in tutorials (“open Weight”, “open Press”) even if B’s grouping is what ships — language stays console-clear.

---

## Coverage checklist (must appear in whichever version you pick)

- [ ] Requests + deadlines + grudge/promises
- [ ] Bout hype + media Qs + fallout
- [ ] Next bout economics + heat + plan
- [ ] Fight camp projection / edges / film / injury
- [ ] Weight cut + weigh-in + weight move
- [ ] Six attributes → potential
- [ ] Six body regions + clearances
- [ ] Combos tightness / signature / game plan
- [ ] Signature duel record
- [ ] Technique tree + discipline/belts/gates
- [ ] Ambition milestones (evaluated)
- [ ] Loyalty parts + rapport + listen %
- [ ] Contract + clauses
- [ ] Promotion / DWCS goals / standing
- [ ] Titles / awards / achievements
- [ ] Rivalries heat
- [ ] Full fight log fields

Nothing on this list is inventable chrome — each maps to a live field or getter.

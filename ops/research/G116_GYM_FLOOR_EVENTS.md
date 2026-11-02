# G116_GYM_FLOOR_EVENTS (Grok, collected by Claude S85, 2026-09-26)
Source: grok.com chat "Gym Floor Incidents: Injuries, Equipment Failures" (Expert, 136 sources). Condensed from Grok's
reply, tags kept. Brief: TASK_G116_GYM_FLOOR_EVENTS.md.

## What would a human do?
A small fight gym's week is classes, pairing spars, chasing no-shows, wiping mats, checking bag hardware and stopping
one ego round. Visible "events" are rare; most days are routine. At most one every few days, usually less.

## 1. Incidents, 20-40 member fight gym
- People: walk-in who wants to "just spar" (weekly, PROXY gymdesk); sparring no-show (weekly among competitors,
  JUDGEMENT); visiting boxer for rounds (a few times a month, SOURCED rossboxing.com); hygiene complaint (weekly-monthly,
  PROXY); ego round the coach must stop (monthly, SOURCED btblegal.com).
- Equipment: bag filling goes dead (months, SOURCED muaythaicitizen); chain/spring/swivel wear, inspect monthly, a snap
  yearly-plus per station (SOURCED sherdog owner report, askmeboxing); vinyl seam split (years, SOURCED heavybag.pro);
  shared gloves/mitts flat in 6-18 months (SOURCED); mats 3-7 years (SOURCED akathletics).
- Injury: hand/wrist sprain roster-wide ~monthly time-loss (SOURCED JSAMS); cut/bloody nose stopping a round monthly on
  hard spar nights (SOURCED PMC2579447); skin infection occasional, outbreak rare (SOURCED); concussion rare (SOURCED).
- Media: member films without asking (weekly now, PROXY); mildly viral clip a few times a year (SOURCED examples).
- Business: drop-in fee argument (policy, $20-40, SOURCED gymdesk); waiver reminder after a scare.

## 2. Injury rates
Amateur boxing training 1.3 injuries / 1000 h (CI 0.2-7.0; Alevras, JSAMS 2022, SOURCED). MMA 1.4 / 1000 h (Healthcare
2026, SOURCED). Hand/wrist ~29-31 days lost in elite GB boxing (Loosemore, BJSM, SOURCED). A 30-person roster at 5-8 h/week:
~1 noted injury a month, a fighter missing several days 1-2x a month (JUDGEMENT).

## 3. Equipment
Leather bags 10-20 y, synthetic 1-3 y; chains/springs checked every 1-3 months; a mid-session drop is the feared event,
not a weekly one (SOURCED staghide, heavybag.pro). Gloves 6-18 months. Mats 3-7 y.

## 5. Sim pacing
Two Point: opt-in emergencies, disasters come from neglected maintenance, not RNG cruelty. Football Manager: players cut
inbox frequency because spam kills fun. Punch Club: fun when tied to the build. **Rule: rare, readable, one choice,
consequence on a system the player already manages. Never a weekly jackpot.**

## 6. First-release six (JUDGEMENT)
| Event | Cadence | Choice | Consequence |
|---|---|---|---|
| Spar partner no-shows | ~1 / 2 weeks | wait / sub a raw member / cancel | missed rounds or mismatch risk |
| Visiting amateur wants rounds | ~1 / month | accept controlled / decline | prospect XP + fatigue or reputation hit |
| Bag chain/swivel suspect | ~1 / 2 months | close station / tape and run | safety vs lost bag-hours |
| Cut or hand sprain in spar | ~1 / month | stop them / "one more" | week hold or worse injury |
| Member filming hard spar | ~1 / 6 weeks | allow / kill the phone | hype and leads or ugly clip |
| Skin-infection scare | ~1 / quarter | deep-clean + sit fighters / shrug | short mat closure vs outbreak |
Visiting pro / viral fame wait for a reputation flag: season beats, not floor noise.

## Claude's note (S85)
The first event built is **the bag chain** - it lives on a station the tier 1-2 floor always draws, its consequence is
station CONDITION (a system the player already manages, which feeds TrainingPreview), and G116 prices it (~1 / 2 months).
The design page's "visiting pro" is deferred per §6. Spar no-show and the spar cut wait for gym sparring (step 4).

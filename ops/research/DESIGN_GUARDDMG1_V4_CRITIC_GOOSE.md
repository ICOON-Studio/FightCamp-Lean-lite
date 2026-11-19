# GUARDDMG1 V4 - Independent Critic Review (Goose)

Critic: Goose (sports management-sim designer, fresh read)
Date: 2026-11-18
Source: DESIGN_GUARDDMG1_V4_CRITIC_DOLA.md (design map only, no earlier critic scores read)

---

## Scores

SCORE depth=8 general=7 play=7

---

## DEPTH: 8/10

**What works:**

The design creates genuine strategic tension through multiple interacting systems. The posture triangle (High/Neutral/Low) is well-balanced - each has a clear counter and no dominant pick. The defence paths (Cover/Move/Parry) force real trade-offs: Cover is predictable but safe, Move costs stamina but rewards timing, Parry is high-risk high-reward with a hard skill gate. The combo threat meter (0/3 → 1/3 → 2/3 → COMBO) builds anticipation beautifully - you can see the danger coming and must decide whether to weather it or spend a recovery option.

Ring generalship integration is smart: trapped on ropes = +12% wear creates urgency to move, while open ring = -5% rewards good footwork. This ties guard management to positioning, which is real boxing. Weight cut interaction (condition <70 = +10% wear, missed weight = +18%) makes the pre-fight decisions matter during the bout - a cut that seemed manageable on the scale becomes a liability in round 3.

The opponent adaptation rule (same posture 3+ rounds → opponent shifts target) prevents exploitation and rewards variety. The 10 opponent reads give progression - you're learning their habits, not just reacting. Defence proficiency tiers (Usable/Sharp/Signature) mirror the move mastery system, creating consistency.

**What's missing or weak:**

The clinch is once per round only, which feels arbitrary. In real boxing, you can clinch multiple times but it's tiring. Consider: clinch available when guard <50, costs 15 stamina, opponent gets one free exchange, resets after 2 exchanges. This makes it a resource decision, not a cooldown.

Parry has a hard unlock at Defence ≥50, which might feel arbitrary to players. Consider: parry always available but effectiveness scales with Defence (baseline 15% failure at Defence 30, 5% at Defence 70). This removes the gate and makes it a skill expression.

The "active rest" option (slip without counter, +2-3 guard, +4 stamina, give up initiative) is interesting but might feel too punishing. In practice, giving up initiative for 2 exchanges could let the opponent build too much pressure. Consider: active rest available only when opponent's combo threat is 0/3 or 1/3 (not 2/3 or COMBO), so you're not surrendering during their peak.

Shoulder endurance is derived (Stamina × 0.7 + Strength × 0.3), which is good, but the effect curve (50 baseline, 65 = -12% wear, 80 = -20% wear, cap -25%) might be too linear. Consider: 50-65 = -5% per 5 points, 65-80 = -8% per 5 points, 80+ = -10% per 5 points. This makes the last 15 points feel more rewarding.

---

## GENERAL DESIGN: 7/10

**What works:**

The design builds on existing systems rather than adding new ones. Shoulder endurance comes from Stamina and Strength (already tracked). Defence proficiency uses the same tier system as moves (Usable/Sharp/Signature). The wiring table is comprehensive - every menu shows the right information, nothing is orphaned. The preset system (5 archetype profiles) is practical and reduces cognitive load during fight prep.

Amateur vs Pro scaling is clear: amateurs have max guard 70, +15% wear, +4 recovery per quiet exchange. This matches the amateur rules (shorter bouts, faster pace). Weight class differences (Lightweight 80 max, Middleweight 100, Heavyweight 120) make sense - heavier fighters have stronger guards but slower recovery.

The formula `Transmission % = Base × (0.5 + (100 − Guard) ÷ 100)` is mostly clear, but there's an inconsistency: the multiplier table shows ×1.0 at guard 100 and ×2.0 at guard 0, but the formula gives ×0.5 at guard 100 and ×1.5 at guard 0. This needs clarification - either the formula or the table is wrong.

**What's missing or weak:**

The "Protect the Lead" mode (High Guard + Cover Up combined, -15% punch output, -8% wear) might be too strong. It's a one-click solution that combines two defensive options without the usual trade-offs. Consider: Protect the Lead costs an additional 5 stamina per exchange (on top of Cover Up's normal cost), so it's not free defence.

The corner minute now has 5 calls (Hands Up, Move Don't Cover, Back Off Recover, Clinch & Rest, Protect the Lead). This might be too many choices under pressure. Consider: group them into 3 categories (Recovery / Switch / Emergency) and let the player pick a category, then the game suggests the best option based on context. Or: keep 5 but make "Protect the Lead" a toggle (on/off) rather than a call, so it doesn't compete for the 2-instruction limit.

The result screen shows "Guard trajectory: bar graph per round (start · end · peak leak)" which is good, but the "Defence breakdown" (Cover 42% / Move 38% / Parry 20%) might be too granular. Players care about outcomes, not process. Consider: show "Blocks: 23 · Slips: 15 · Parries: 7 · Got through: 12" instead, which is more intuitive.

The training recommendations after a fight ("Train shoulder endurance" / "Practise parries" / "Work on movement conditioning") are actionable, which is excellent. But they should link directly to the Week screen - one click and the recommended session is added to the plan.

---

## PLAY: 7/10

**What works:**

The combo threat meter creates genuine anticipation - you see the danger building and must decide whether to weather it or spend a recovery option. The visual cues (green/yellow/orange/red) give immediate feedback on guard state. The "Guard held" moment on the result screen ("They threw everything and your guard held — great management") is rewarding and validates good play.

The preset system reduces cognitive load - you can prepare for a pressure fighter before the bout and load the preset in one click. The opponent reads (10 total) give a progression feeling - you're learning their habits, not just reacting. The wiring table ensures every menu shows the right information at the right time.

The "They've spotted your pattern" warning when you use the same posture 3+ rounds is excellent - it's a clear, plain-words alert that something needs to change.

**What's missing or weak:**

The design is number-heavy. Transmission %, wear modifiers, proficiency tiers, combo threat, ring position, clinch counter - this is a lot to track during a fight. Consider: hide the numbers behind hover cards and show only the visual cues (colour-coded guard bar, combo threat meter, position cue) during the bout. The numbers are for the result screen and fight plan, not the live exchange.

The corner minute choices might feel overwhelming. Five calls, each with different effects, under time pressure. Consider: show the recommended call based on context (e.g., "Guard low, ahead on points → Hands Up") and let the player override it. This reduces cognitive load while keeping agency.

The "active rest" option (give up initiative for +2-3 guard) might feel bad in practice. Players want to feel in control, not passive. Consider: rename it to "Reset the pace" and frame it as a tactical choice ("Your boxer slows the fight, catches their breath, resets the guard") rather than a surrender.

The clinch being once per round might feel restrictive. In real boxing, clinching is a rhythm breaker, not a limited resource. Consider: clinch available when guard <50, costs 15 stamina, opponent gets one free exchange. This makes it a resource decision, not a cooldown, and feels more like boxing.

The weight cut interaction (condition <70 = +10% wear) is hidden during the fight. Players might not connect the pre-fight decision to the in-fight consequence. Consider: show a warning on the Fight Prep screen ("Weight cut will affect guard endurance in later rounds") and a reminder on the Camp screen ("Dehydrated: guard wears 10% faster").

---

## Which options are missing, useless, or what each changes

**Missing:**

1. **Guard recovery training focus.** The design mentions shoulder endurance builds via Cover Up usage, but there's no explicit training option to accelerate it. Add: a "Guard endurance" focus in camp (like Conditioning or Defence), which gives +15% shoulder endurance gain for that camp. This lets players address a weak guard before a tough bout.

2. **Guard-specific sparring.** Sparring nights could include a "Guard work" card (like a drill card) that gives +2 shoulder endurance per sparring night. This ties training to the mechanic more directly.

3. **Guard fatigue visual during the fight.** The guard bar shows the current state, but not the trajectory. Add: a small arrow next to the guard bar (↑ recovering, → stable, ↓ wearing) so players can see the trend without tracking numbers.

4. **Guard-based judge scoring.** The design says "Every 3 blocked punches = +1 effective strike to opponent — for scoring only." This is good, but it's not visible during the fight. Add: a "Effective strikes" counter on the fight screen (separate from landed punches) so players can see how their defence is affecting the scorecards.

**Useless:**

1. **The "Back Off, Recover" call (+20 guard over next round, cedes range/initiative).** This is too strong. +20 guard is a full reset, and the cost (ceding range) is abstract. In practice, players will use this whenever guard drops below 40, making it a panic button. Consider: reduce to +10 guard over next round, or make it cost a corner instruction (so it competes with other calls).

2. **The "Clinch & Rest" call (+10 guard immediately, resets rhythm, lose position, opponent free exchange).** This overlaps with the in-fight clinch option. Having both a corner call and an in-fight option for the same action is confusing. Consider: remove the corner call and keep only the in-fight clinch (available when guard <50, once per round).

3. **The "Protect the Lead" preset.** This is a defensive mode, not a preset. Presets are for opponent archetypes (Pressure / Counter / Volume / Brawler / Body). "Protect the Lead" is a situational call, not a pre-fight plan. Consider: remove it from the preset list and keep it only as a corner call.

---

## To reach 10/10

Most important first, specific enough to build:

1. **Fix the transmission formula inconsistency.** The formula `Transmission % = Base × (0.5 + (100 − Guard) ÷ 100)` gives ×0.5 at guard 100 and ×1.5 at guard 0, but the table shows ×1.0 and ×2.0. Decide which is correct and update the other. Recommendation: use the table values (×1.0 to ×2.0) and adjust the formula to `Transmission % = Base × (1.0 + (100 − Guard) ÷ 100)`.

2. **Reduce corner minute cognitive load.** Group the 5 calls into 3 categories (Recovery / Switch / Emergency) and show a recommended call based on context. Or: keep 5 calls but make "Protect the Lead" a toggle (on/off) rather than a call, so it doesn't compete for the 2-instruction limit.

3. **Make clinch a resource decision, not a cooldown.** Remove the "once per round" limit. Instead: clinch available when guard <50, costs 15 stamina, opponent gets one free exchange, resets after 2 exchanges. This feels more like boxing and gives players more agency.

4. **Remove the parry hard unlock.** Parry is always available, but effectiveness scales with Defence. Baseline failure: 20% at Defence 30, 10% at Defence 50, 5% at Defence 70. This removes the arbitrary gate and makes parry a skill expression.

5. **Add guard recovery training focus.** Camp can focus on "Guard endurance" (like Conditioning or Defence), giving +15% shoulder endurance gain for that camp. This lets players address a weak guard before a tough bout.

6. **Hide numbers behind hover cards during the fight.** Show only visual cues (colour-coded guard bar, combo threat meter, position cue) during the live exchange. Numbers (transmission %, wear modifiers) are for the result screen and fight plan. This reduces cognitive load and keeps the fight screen clean.

7. **Add guard trajectory indicator during the fight.** Show a small arrow next to the guard bar (↑ recovering, → stable, ↓ wearing) so players can see the trend without tracking numbers.

8. **Reduce "Back Off, Recover" strength.** Change from +20 guard over next round to +10 guard over next round. Or: make it cost a corner instruction (so it competes with other calls).

9. **Remove "Clinch & Rest" corner call.** It overlaps with the in-fight clinch option. Keep only the in-fight clinch (available when guard <50, resource-based as in item 3).

10. **Add weight cut warning on Fight Prep screen.** Show "Weight cut will affect guard endurance in later rounds" when condition <70 or weight is being cut. This connects the pre-fight decision to the in-fight consequence.

---

## My 10/10 (1920x1080 page description)

**Fight Screen (live exchange):**

Top third: the 3D fight view (or still if headless). Bottom two-thirds: the coach's corner.

Left column (40% width):
- Guard bar (large, colour-coded green/yellow/orange/red) with a small arrow (↑/→/↓) showing trajectory
- Combo threat meter (0/3 · 1/3 · 2/3 · ⚠️ COMBO) as a vertical bar filling up
- Ring position cue ("Trapped on ropes" / "Open ring" / "Centre")
- Clinch counter ("Clinch available" / "Clinch used")

Centre column (30% width):
- Exchange result (Clean hits · On guard · Got through)
- Opponent mode clue ("Pressing" / "Boxing at range" / "Waiting to counter" / "Loading up" / "Tiring" / "Hurt")
- Active rest option (greyed when combo threat is 2/3 or COMBO)

Right column (30% width):
- Corner calls (3 categories: Recovery / Switch / Emergency)
- Recommended call highlighted based on context
- "Protect the Lead" toggle (on/off) beside the calls, not competing for instruction limit

Bottom bar:
- Pace (Push / Steady / Save) and Aim (Own game / Head / Body / ribs / the hurt head) as persistent toggles
- Set-up "NOW!" button (fires a learned combination into a gap)

**Result Screen:**

Top half: scorecards, win/loss/draw, "What decided it" (plain lines).

Middle half:
- Punch stats (Thrown · Landed · Blocked · Got through %)
- Guard trajectory graph (per round: start · end · peak leak)
- Defence stats (Blocks: 23 · Slips: 15 · Parries: 7 · Got through: 12)
- Effective strikes counter (for judge scoring)
- Plan success highlight ("They threw everything and your guard held — great management")

Bottom half:
- "The plan, lit up" flow (which lines worked, which didn't)
- Training recommendations (3 buttons: "Train shoulder endurance" / "Practise parries" / "Work on movement conditioning") - each links directly to the Week screen
- Next week button

**Fight Plan Screen (Defence tab):**

Top: round-group selectors (R1–2 · R3–4 · R5+).

Middle:
- Defence style dropdown (Cover / Move / Parry)
- Guard posture dropdown (High / Neutral / Low)
- Transmission estimate vs opponent (projected guard range per round group)
- Preset dropdown (5 archetype profiles: Pressure / Counter / Volume / Brawler / Body) with Save/Load buttons

Bottom:
- Opponent reads (10 total, locked lines say what unlocks them)
- "They've spotted your pattern" warning (if same posture used 3+ rounds in last fight)

**Camp Screen:**

- Camp focus dropdown (Conditioning / Power / Technique / Defence / Guard endurance)
- Weight cut warning ("Weight cut will affect guard endurance in later rounds") when condition <70
- Amateur guard note ("Amateur: guard recovers fast but degrades quick — don't trade non-stop")
- Opponent style warning if scouted (combo/feint/body/rope)

**Training Screen (Fighter Week):**

- Shoulder endurance display ("Guard wear −X% · Tier: Usable/Sharp")
- Defence proficiency progress bars per style (Cover / Move / Parry)
- "Guard work" sparring card option (+2 shoulder endurance per sparring night)

---

## Summary

The GUARDDMG1 V4 design is strong. It creates genuine strategic tension through multiple interacting systems, builds on existing mechanics rather than adding new ones, and is well-wired to the game's menus. The combo threat meter, ring generalship integration, and opponent adaptation are excellent additions that make guard management feel like real boxing.

The main weaknesses are cognitive load (too many numbers during the fight), a formula inconsistency, and some overlapping options (clinch corner call vs in-fight clinch). The fixes are straightforward: hide numbers behind hover cards, fix the formula, remove the overlap, and make clinch a resource decision rather than a cooldown.

With these changes, the mechanic would reach 10/10 on all three scores. As it stands, it's a solid 7-8/10 that needs refinement, not redesign.

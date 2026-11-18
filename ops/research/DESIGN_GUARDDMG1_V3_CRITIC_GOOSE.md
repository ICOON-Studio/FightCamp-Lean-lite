# GUARDDMG1_V3 - Independent Critic Review (Goose)

**Critic role**: Sports management-sim designer, fresh eyes  
**Discipline**: Boxing  
**Date**: 2026-11-18

---

## What I Read

The full critic pack (game facts, no prior scores), then the GUARDDMG1_V3 design map. I judged the MECHANIC, not the screens.

---

## Scores

**DEPTH: 7/10**

**Reasons:**
- Real trade-offs exist: Cover preserves energy but leaks damage; Move costs stamina but blocks clean; Parry is high-risk high-reward
- Weight-class scaling (80/100/120 max guard) creates meaningful variety across divisions
- Combo multiplier (punches 3+ = ×1.5 wear, ×2.0 transmission) makes pressure fighters a genuine guard threat
- Per-round defence planning (R1-2 / R3-4 / R5+) adds strategic depth before the fight
- Clinch as emergency valve with real costs (position, free exchange, stamina) is well-designed
- In-round recovery (+3 per quiet exchange) rewards creating space - good tactical layer
- Guard postures (High/Neutral/Low/Peek-a-Boo) add pre-fight customization

**Why not higher:**
- The transmission formula `base × (100/guard)` creates a runaway cliff: at guard 25, a heavy shot transmits 220% (capped at 80%). This is a weird discontinuity - why not a smoother curve?
- Four guard postures feels like one too many. Peek-a-Boo is a specific boxing style (Tyson, not a generic guard height) and doesn't fit all fighters
- No interaction with ring generalship - cutting off the ring should affect guard wear (pressure fighters who trap you vs those who let you move)
- The interaction between posture, style, and corner calls could overwhelm - is this too much for a management sim where the player doesn't throw punches?

---

**GENERAL DESIGN: 6/10**

**Reasons:**
- Clear rules with explicit numbers - every value is documented
- Consistent with existing systems: builds on the guard bar (shoulder fatigue), defence skill, stamina, body damage bands
- Weight-class scaling is smart and realistic (heavyweights have bigger gloves, more power, but also more guard)
- Amateur vs pro distinction (max 80, +20% wear, +33% recovery) is well thought out
- The wiring table is comprehensive - every menu knows what to show
- Feint interaction (+2 guard wear on successful feint) is a nice touch
- Judge scoring rule (3 blocked = 1 effective strike) resolves the V1 contradiction

**Why not higher:**
- The transmission values feel arbitrary: why 42.5% for cross/hook? Why not 40% or 45%? The 25%/42.5%/55% spread lacks clear justification
- "Shoulder endurance" as a training focus is new - the critic pack says attributes are Strength, Explosiveness, Speed, Stamina, Recovery, Flexibility, Durability, Fight IQ, Composure, Heart. Where does shoulder endurance fit? Is it part of Stamina? Durability? This needs clarification
- Peek-a-Boo posture is too specific - it's a style, not a guard height. A slugger won't use it; an out-boxer might. This should be a fighter trait, not a universal option
- The damage distribution (85% head / 15% eyes for blocked head punch) is oddly specific without biomechanical backing
- The formula `transmission = base × (100/guard)` means at guard 50, transmission doubles. At guard 25, it quadruples. This is a steep cliff that could feel unfair
- No mention of how guard interacts with weight cutting - a fighter who missed weight should have compromised guard (dehydrated muscles fatigue faster)

---

**PLAY: 5/10**

**Reasons:**
- Guard trajectory visual (bar graph per round) is satisfying
- Feedback tiers (yellow/orange/red with corner comments) add atmosphere
- Result screen breakdown (punches, blocked, through, defence mix %) is excellent
- The tension of watching guard drop is real - "Arms tiring — damage starting to show" is good writing
- Per-round planning adds anticipation ("I set High Guard for R1-2 because they're head-focused")
- Clinch as emergency tool creates dramatic moments ("Guard at 38, one clinch left, do I use it now or save it?")

**Why not higher:**
- For a management sim, this is very granular during the fight. The player doesn't control punches - so guard management is the main in-fight decision. But is watching a bar drain fun?
- The "fastdraw" concern in the task hints at performance issues with the 3D fight. If the software GPU takes an hour for 30 seconds of fight, the visual payoff is limited
- The interaction between posture, style, corner calls, and per-round planning could feel like spreadsheet management rather than coaching
- No clear "aha" moment - when does the player feel clever for managing guard well? The result screen shows it, but during the fight it's just watching numbers
- The combo multiplier is good but invisible until it's too late - the player sees "Combo bonus active" but doesn't feel the buildup
- Missing: a moment where the player's guard plan pays off dramatically ("They threw 30 punches in R3 and my guard held because I planned Move for that round")

---

## What Each Option Changes

**Cover Up**: Guard wears per block, transmission grows. Costs: leakage accelerates below 40 guard. Gains: no stat check, legs preserved. **Changes**: Forces the player to decide when to absorb vs when to move.

**Move / Slip**: Stamina cost per exchange, success falls as stamina drops. Costs: fresh legs needed. Gains: 0% transmission on clean miss. **Changes**: Rewards conditioning and punishes wild opponents.

**Parry / Redirect**: Higher failure vs power punches, Defence ≥50 unlock. Costs: unreliable below Defence 55. Gains: minimal wear (0.3 pts/block), counter opportunity. **Changes**: Makes Defence skill matter more, rewards counter-punching plans.

**High Guard**: Head transmission −20%, body +20%, guard wear +10%. **Changes**: Protects the head (where most damage lands) but exposes the body.

**Low Guard**: Head transmission +20%, body −20%, counter speed +10%. **Changes**: Protects the body (for body punchers) and rewards counters.

**Peek-a-Boo**: Balanced head/body, slip chance +12%, guard wear +15%. **Changes**: Reactive counter style, but high wear.

**Clinch**: +10 guard points, once per round, costs position and free exchange. **Changes**: Emergency valve - prevents guard breakdown but gives up ring position.

**Feint interaction**: Successful feint draws +2 guard wear. **Changes**: Makes feinting a viable offensive tool against tired guards.

---

## Missing Options

1. **Ring generalship interaction**: Cutting off the ring should affect guard wear. A pressure fighter who traps you against the ropes should wear your guard faster than one who lets you move. Currently missing.

2. **Weight cutting compromise**: A fighter who missed weight or is dehydrated should have compromised guard (muscles fatigue faster). Currently not mentioned.

3. **Mid-fight posture switch guidance**: The player sets posture per round group, but what if the opponent changes style in R3? No clear mechanic for adapting.

4. **"Safe mode" for protecting a lead**: If the player is ahead on points with one round left, they should be able to play safe (high guard, no risks). Currently no explicit option.

5. **Clinch frequency guidance**: The player can clinch once per round, but when? No clear feedback on "you've used 0/3 clinches, save them" vs "you've used 2/3, one left".

6. **Guard vs chin interaction**: A fighter with a great chin should be able to absorb more guard leakage without being hurt. Currently guard and chin are separate.

---

## Useless Options

1. **Peek-a-Boo posture**: Too specific. It's a style (Tyson, early Ali), not a universal guard height. A slugger won't use it; an out-boxer might. This should be a fighter trait or style-based unlock, not a universal option. **What it changes**: Nothing useful - it's a niche option that clutters the decision space.

2. **The 4-posture system**: High/Neutral/Low is enough. Peek-a-Boo is redundant with Low Guard (both protect the body, both add wear). **What it changes**: Simplifies pre-fight planning from 4 choices to 3.

3. **Damage distribution (85% head / 15% eyes)**: Overly specific without clear gameplay impact. Does "eyes" damage cause cuts? If so, say so. If not, why track it? **What it changes**: Nothing visible to the player.

---

## To Reach 10/10

**Most important first:**

1. **Clarify shoulder endurance**: Where does it fit in the 10 attributes? Is it part of Stamina? Durability? Make it explicit. Currently it's a new training focus that doesn't map to the agreed attribute list.

2. **Remove Peek-a-Boo posture**: It's a style, not a guard height. Keep High/Neutral/Low. If Peek-a-Boo is important, make it a fighter trait (e.g., "Reflexive guard" - unlocks Peek-a-Boo for reactive counter-punchers).

3. **Smooth the transmission curve**: Replace `transmission = base × (100/guard)` with a gentler curve. Example: `transmission = base × (1 + (100-guard)/100)`. At guard 50, transmission is 1.5× (not 2×). At guard 25, it's 1.75× (not 4×). This prevents the runaway cliff.

4. **Add ring generalship interaction**: Pressure fighters who cut off the ring should wear the opponent's guard +10-15% faster. This rewards footwork and ring control, not just punch volume.

5. **Add weight cutting compromise**: A fighter who missed weight or is dehydrated (condition <70) should have guard wear +15%. This connects weight management to fight performance.

6. **Add mid-fight posture switch**: Allow the player to switch posture in the corner minute (costs one of the two instructions). This rewards adaptation, not just pre-fight planning.

7. **Add "safe mode" for protecting a lead**: If ahead on points, the player can call "Protect the lead" - high guard, no risks, punch output −20%. This gives a clear endgame strategy.

8. **Make the combo multiplier visible during buildup**: Show "Combo threat: 2/3 punches" so the player sees the danger building, not just the result.

9. **Connect guard to chin**: A fighter with Chin ≥70 should absorb guard leakage with less actual damage (−10% transmission). This connects two related attributes.

10. **Add a "guard held" dramatic moment**: If the player's guard plan succeeds (e.g., they planned Move for R3 and the opponent threw 30 punches but guard stayed above 60), show a moment: "Your plan worked - they threw everything and your guard held." This creates the "aha" moment.

---

## My 10/10 as a 1920x1080 Page

If the design reaches 10/10, the fight screen shows:

**Top third**: The 3D fight (or words if headless). Guard bar (0-100, color-coded green/yellow/orange/red) with hover showing exact transmission %. Combo threat indicator (0/3, 1/3, 2/3 punches - glows red at 3+). Opponent style clue ("Pressing", "Boxing at range").

**Middle third**: Exchange panel - Clean hits, On guard, Got through, Combo bonus active. Defensive options row (Cover/Parry/Move/Clinch, greyed when unavailable). Corner call buttons (3 that fit, or say nothing).

**Bottom third**: Per-round guard trajectory (mini bar graph). Defence style breakdown ("Cover 42% / Move 38% / Parry 20%"). Shoulder endurance status ("Arms tiring - guard wear +8%"). Plan reminder ("R1-2: High Guard / Cover").

**Result screen**: Full breakdown - punches thrown/landed/blocked, damage through guard (%), guard trajectory per round, defence mix %, judge strike differential. "Your plan worked" moment if guard held against pressure. "Train shoulder endurance next week" button if guard broke down.

**Fight plan screen**: Defence tab with round-group selectors (R1-2 / R3-4 / R5+). Style dropdown (Cover/Move/Parry). Posture dropdown (High/Neutral/Low). Transmission estimate vs this opponent. Save preset button. "If they switch to pressure in R3, consider switching to Move" hint.

**Corner minute**: Guard recovery calls (Hands Up, Back Off, Clinch). Switch style call (Move, Don't Cover). Posture switch (costs one instruction). Effects previewed ("Hands Up: +5 guard next round, punch output −10%").

---

SCORE depth=7 general=6 play=5

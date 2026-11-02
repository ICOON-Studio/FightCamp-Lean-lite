# TASK D64 - Guard styles as measurable poses, and how guard quality ties to defence

Owner: Dola (Cici, driven by Tools/cici/cici.py). Tier: research, no gate.
Advances: ACTIVE MILESTONE "PLAYABLE WITH A BOXER" step 6. Operator S119: "the guard needs some adjustments, don't make
all fighters hold their [guard] the same way", "how good a guard is and defence should be connected, there must be big
variety on the guard stance".

## Why
Every boxer in the game stands in ONE guard clip (Mixamo Bouncing_Boxing_Idle). J50 already lists the defensive menu and
names peek-a-boo, shoulder roll and high guard, and says Fight Night Champion ties auto-blocking to Reflex and Blocking
ratings. What we lack is the POSE: numbers an animator can build a guard from, and how guard quality shows on screen.

## What would a human do?
A boxing coach describes a guard by hand height (eye / cheek / chin / chest), elbow position (tucked to ribs / flared),
chin (tucked / up), lead-hand extension, stance width and angle, weight distribution, and rhythm. A game animator makes a
base guard per style and blends it by a "quality" value: good defenders hold tight, high and still; poor or tired ones
drop the hands and flare the elbows.

## Prior research
- `research/J50_HOW_A_DEFENDER_DEFENDS.md` (sections 1.2, 2, 4, 9 - defence menu, FNC ratings, guard techniques)
- `research/G54_WHAT_IS_DEFENCE.md` (peek-a-boo vs Philly shell paper)
- `research/Q71_BOXING_EVASION.md` (engine guard kinds)
- searched: guard, guard stance, philly shell, peek-a-boo, high guard (prior_research.py, S119)

## Prefab check
Name any guard/idle animation packs (Mixamo, RamsterZ, Unity/Unreal stores) that ship several DISTINCT boxing guards,
with licence.

## Ask - each answer with source URL + date, tagged SOURCED / PROXY / UNSOURCED
1. A catalogue of 6-10 real boxing guards (e.g. high guard, peek-a-boo, Philly shell / shoulder roll, long guard,
   cross-arm, low-hands / hands-down, orthodox classic, Mexican/pressure guard): for each, hand height, elbow tuck, chin,
   lead-hand extension, stance width and angle, weight split, known fighters, what it defends well and what it opens.
2. How common each is among pros (any count or proxy).
3. How guard quality visibly changes with skill and fatigue (hands dropping late in fights, elbows flaring) - any
   measurement (hand height vs round, CompuBox by round).
4. How shipped games show guard variety and tie it to stats (Fight Night Champion styles, Undisputed, UFC 5).
5. Your recommended mapping for us: fighter style + defence rating + fatigue -> guard style and the pose numbers.

## Deliver
File `D64_GUARD_STYLES.md`: the guard table, the prevalence and fatigue findings, the game precedent, the mapping.
No code.

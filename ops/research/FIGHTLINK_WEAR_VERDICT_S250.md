# FIGHTLINK step 1b - training wear and readiness carry into the bout (verdict S250)

Source: Ludo r116 Part A, verbatim in `research/ludo_rx/LUDO_R116_raw.txt` (lines 9-146, reply 22,504 chars + continuation).
Operator ruling this sits under: S248 "Go - build FIGHTLINK in that order". Boxing only (demo discipline).

## The problem today
Every fighter walks into the ring at 100% in all six body regions and full stamina, whatever his fight week was.
Training hard on Friday before a Saturday bout costs nothing.

## Verdict (what gets built)
1. **Starting condition per region** = clamp(100 - 0.75 x wear, 70, 100). The floor is 70%: no region is ever worse than that.
   Wear left at the weigh-in comes from the gym's existing per-region wear. Each night it drops:
   - training day: x0.75, then -4
   - light day: x0.55, then -10
   - full rest: x0.35, then -18

   A 2-day taper (light, then rest) clears about 45 wear, i.e. back to 100%.
2. **Stamina from readiness R (0-100)**:
   - max stamina = clamp(80 + 0.2 x R, 80, 100)
   - starting stamina = max x clamp(0.85 + 0.15 x R/100, 0.85, 1.0)
   - so R 100 = 100/100, R 80 = 96/93, R 50 = 90/83.
3. **What a worn fighter feels**: only the levers already in the fight.
   - Legs: evasion x (0.60 + 0.40 x leg condition). 70% legs = -12% evasion.
   - Head: chin x (0.70 + 0.30 x head condition). 70% head = -9% chin.
   - Arms: accuracy x (0.75 + 0.25 x arm condition). 70% arms = -7.5% accuracy.
   - Lower stamina makes the existing whiff cost bite sooner.
   - Nothing new is invented.
4. **What you see before the bell**: one status line under the name.
   - `STATUS: PEAK CONDITION [Readiness 98% | Body 99%]`
   - or `STATUS: IMPAIRED [Legs 82% - Heavy from late roadwork | Readiness 84%]`
   - The line names the worst region. Colours: green >= 95, amber 85-94, red < 85.
5. **The trap avoided**: normal training must never feel like sabotage. Mitts, tactics and film generate no wear, and a sensible 2-day taper clears it.
   **Balance target**: about 82% of sensible camps enter at >= 95% everywhere. Under 5% enter badly worn, and only after sparring on Thursday or Friday, short notice, or a bad weight cut.

## Left out of Ludo's answer
- Ludo's "+10% execution speed from camp sharpness": a new lever, not in the fight today. Not built.
- Ludo's wear numbers per activity (sparring +18-24 head, and so on): we keep the gym's EXISTING wear amounts. Only the overnight recovery and the conversion above are new.

## How it is tested
- A red test first: two identical camps except the last two days (sparring Fri vs rest Fri).
- The worn fighter must enter below 100% and connect/evade measurably less.
- The rested one must enter at 100%.
- An average sensible camp must stay at today's numbers (control arm).

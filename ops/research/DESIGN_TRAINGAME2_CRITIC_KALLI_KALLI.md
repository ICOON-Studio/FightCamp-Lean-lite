# DESIGN_TRAINGAME2_CRITIC_KALLI_KALLI - Kalli answer (seat queue SQ173)

Brief: research/DESIGN_TRAINGAME2_CRITIC_KALLI.md
Sent: 2026-11-15 11:10 | collected: 2026-11-15 11:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it: I'm scoring TRAINGAME2 as a fresh critic now, with To reach 10/10 and a 10/10 page at the end.

# TRAINGAME2: critic score (S459 loop, fresh critic, 2026-11-15)

**Depth 4 · General design 5 · Play 4. Not yet DESIGNED: the bar is 6+ on depth and on general design.**

`ops/research/CRITIC_ACCESS.md`, the Miro board and `training_k.png` weren't opened, because the owner's computer is offline. This score comes from the critic pack and the map's own text.

## 1. Depth: 4
- **It's a calibration note, not a design map.** It corrects numbers but states no choice, no trade-off and no test for a dominant pick. Judged as a mechanic, the depth on show is what the pack already has: session and intensity per morning, cards on pad nights, and diet.
- **The map's own finding undercuts a built option.** At about 0.03 mastery a minute, a 70/30 split instead of 50/50 moves roughly 1.5 mastery over a night (DERIVED from the map's figure). So the split pills are close to decoration.
- **The real trade-off is in the numbers, but the map doesn't see it.** Mon puts check hook 12 → 20.7, Wed puts body hook 29 → 35.4, and Fri puts check hook 20.7 → 28.2. If Wed's night went to the check hook instead, it would reach about 28 on Wed and about 35 on Fri (ESTIMATE, same rate). The body hook would stay at 29, short of a weapon. So the week's real choice is **body hook ready, or check hook ready, not both**. That's a strong decision, and the page should be built around it.
- **The coach lever is missing.** The probe uses pad coach 58. If pad rating feeds the coach factor like the overall rating (CHECK), a coach with pads 74 multiplies gains by about 1.12 (0.5 + rating × 0.7%). That would put the check hook at about 30.2 by Friday (ESTIMATE). Hiring, nights and cards would then interact. That's depth, and the page doesn't show it.
- **Learning in fight week isn't questioned.** The hook turns Usable at the Monday pad night of fight week, which is TAPER. Coaches commonly hold to "nothing new in fight week". The map should rule on whether taper pads teach at full rate. It should also flag that a line on a move that just turned Usable fires only 1 in 2.

## 2. General design: 5
- **Good:** every number traces to a named rule (`WeekPlan.full_day`, `PadWeek.drill`, `FireLevel.GAME_SHARES`), and the false promise ("Usable by Friday") is caught and fixed honestly.
- **Not verified, but still on the page:** the tiredness line, the Neck and Mobility tiles, the +1.5% win share per usable move, the injury risk and the coach's-week row. A page titled "with the game's real numbers" can't ship drawn numbers. The tiredness line matters most, because overreach at 80 is the week's main cost.
- **One word per concept is broken twice:**
  - "Stamina → Cardio" cites S431, but `Attrs.gd` and the pack say **Stamina** (Cardio was the BJJ word folded into it).
  - The sparring line says **Ring IQ** where `Attrs.gd` says **Fight IQ**.

  Both need a ruling (CHECK).
- **Rings point at the wrong target.** They track mastery toward Sharp (60), but the decision this week is Usable (30). A ring should show the next tier.
- **Name and class:** the probe's body is a named boxer. The page body must say "your boxer" (S448). The 70.0 kg limit is the new women's 70 class (Q-S294-233), which the pack's weight section doesn't list yet, so the pack needs that update.
- **Too small to read:** morning gains of +0.06 to +0.17 mean nothing alone. The page needs weekly sums and "weeks to the next whole point".

## 3. Play: 4
- The emotional hook ("ready by Friday") is broken and nothing replaces it. "Ready Monday of fight week, fires 1 in 2" is a letdown.
- Week to week, the visible reward is decimals. The week review's bars filling to whole points carry the anticipation, but this page doesn't promise any.
- The tension that would make it fun (one hook or the other, or pay for the better pad coach) is there in the numbers and not on the page.

## 4. Options: what each changes, which are missing, which are useless (S403)

| Option | What it changes | Verdict |
|---|---|---|
| Morning session (roadwork through neck work) | One stat, about +0.10–0.17 a Normal morning | Keep. Show the weekly sum |
| Light / Normal / Hard | Gain ×0.6 / ×1 / ×1.3, and tiredness | Keep. The tiredness line has to be real |
| Diet Hold / Cut 500 | −0.04 to −0.09 kg a morning on the cut | Keep |
| Pad night card | About +6–10 mastery to that card | Keep. **It's the main lever** |
| Split 50/50, 70/30, 30/70 | About ±1.5 mastery a night (DERIVED) | **Near useless.** Cut, or turn into "whole night / half night" with its numbers |
| Sparring night | Fight IQ +0.12, and drills only moves at 30+ | Keep |
| Rest | Tiredness −8 | Keep |
| Neck, Mobility tiles | Not verified | **Cut** unless a number moves |
| Coach's-week comparison row | Not verified | Cut, or verify |

**Missing options**
1. **The trade card:** "Wed night: Body hook or Check hook ready this week", with both outcomes.
2. The pad coach's rating, shown as a lever on the night: "With a pads-74 coach: ready Friday".
3. A taper rule for new moves (teach or hold), with the 1-in-2 fire warning on any plan line using a move that just turned Usable.
4. Swap a peak-week sparring night for pads, with its cost (sparring twice is the PEAK rule, so the swap must show what's lost).

## 5. To reach 10/10 (most important first)
1. **Build the page around the week's trade.** Add a card for "Body hook or Check hook ready, not both", fed by `PadWeek.drill`, with each choice's mastery by Friday and its fire share on fight night.
2. **Redraw the tiredness line** from the boxer's real carried-in value. Show the 80 overreach band (gains ×0.6, injury ×3) and mark the night it's crossed. Probe it, don't draw it.
3. **Decide the split.** Either cut the 50/50, 70/30 and 30/70 pills, or show their mastery difference on each pill. The map's own finding says the night is the unit.
4. **Rule on fight-week learning.** Taper pads either teach at a reduced rate (ESTIMATE ×0.5) or at full rate, written down. Any plan line on a move turned Usable in fight week gets the warning "fires 1 in 2, untested in sparring".
5. **Show the coach lever:** the gain at the current pad rating and at the other coach's (Luke pads 74, Marcus pads 58). CHECK whether the pad rating feeds the coach factor.
6. **Fix the words:** a single ruling on Stamina vs Cardio and on Fight IQ vs Ring IQ, then apply it to every row. CHECK S431 against `Attrs.gd`.
7. **Rings to the next tier:** 30 under Usable, 60 under Sharp, 85 under Signature.
8. **Weekly sums and whole points:** "Power +0.6 this week, next whole point in 2 weeks" replaces the per-morning decimals.
9. **Verify or cut** the Neck and Mobility tiles, the +1.5% win share, the injury risk and the coach's-week row.
10. **A bot probe for dominance:** the best week for each goal against the coach's week, over 200 seeds. If one week wins every goal, there's no depth: report the gap.
11. **Names and class:** the page body says "your boxer". Add the women's 70 kg class to the pack's section 4.4.

## 6. My 10/10 page (1920×1080)
- **Header:** portrait, name, class 70 kg, "Fight Sat 28 · weigh-in Fri 27". This is the only name on the page.
- **Top strip:** the goal line "Check hook needs 30 by fight night", with the ring at 20.7 of 30 and the weeks left.
- **Centre:** seven day columns as whiteboard magnets. Mornings show session, intensity and the stat moved. Evenings show the night and its card, with mastery before and after ("20.7 → 28.2").
- **Under the columns:** the real tiredness line, with the 80 band shaded and the crossing night marked.
- **Right column, THE TRADE:** two cards side by side.
  - "Wed: Body hook": body hook 35 Usable, check hook 28 not ready.
  - "Wed: Check hook": check hook 35 Usable Fri, body hook 29 not a weapon.

  Each shows its fire share on fight night. A small line under them reads "Pads-74 coach: both by Fri" (only while that coach is hireable).
- **The coach's pick:** a card with its reason in one line under 70 characters, no numbers. **Gold** goes on this card only.
- **THIS WEEK BUYS:** weekly stat sums, weight on the day against the limit, and moves reaching a tier.
- **Bottom:** Back to the coach's week. Green on Continue only.
- **Look and fonts:** Look B whiteboard, Bebas Neue for headings and IBM Plex Mono for the numbers. Every number hovers to its rule.

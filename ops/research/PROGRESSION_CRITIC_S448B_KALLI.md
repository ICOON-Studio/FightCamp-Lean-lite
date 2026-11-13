# PROGRESSION_CRITIC_S448B_KALLI - Kalli answer (seat queue SQ51)

Brief: research/PROGRESSION_CRITIC_S448B_BRIEF.md
Sent: 2026-11-13 10:45 | collected: 2026-11-13 11:02 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Got it. I'm scoring PROGRESSION map v2 on what's in this brief only, and I'll paste the critic as text in parts.

Part 1 of 3

# PROGRESSION, design map v2: critic (S448, Kalli)

Judged on this brief only. I couldn't open the Miro board, the real screens on E:, or the S432/S428/S439/S429 maps it cites, so anything taken from those maps is judged as the map quotes it.

**Verdict:** Depth 6/10, Play 6/10. I would not defend it to the owner yet.

The specialty fixes the queue problem. Held moves cost the club's real scarce thing, which is pad time, and the plan's sparring holds its own moves. That makes "keep my identity or plan for this opponent" a real trade. Being read gives professionals a different job from amateurs.

Three things are broken underneath. The holding numbers don't match the pad night in the pack or the code's gain formula. Fight week has no sparring, so the example's "held by sparring" fails exactly in bout weeks. And the first style named is always the cheapest one.

## 1. Logic check

**1. The pad night's length is wrong.** M3 says a pad night is 240 minutes; the pack says 75 minutes split over its cards. At 75, a fighter on 2 of the club's 8 nights has 150 pad minutes a week. Holding 4 Sharp moves (80) and 1 Signature (40) leaves 30 minutes to learn. So "4 to 5 Sharp, 1 to 2 Signatures and still learn" is true only at 240. CHECK (Claude): `PadWeek` night length and `spar_pool` 180.

**2. Holding can't work through the gain formula.** Gain is pads 2.1 an hour x the coach factor x (1 - m / cap). At Sharp 60 with a cap of 75, the last factor is 0.2. Twenty minutes with Reid then gives about 0.18 mastery a week against a fade of 1.5. Holding must be a rule (minutes met means no fade that week), not a gain. The map never says which, and a builder will wire it through `MoveMastery` and every held move will fade.

**3. Fight week breaks the example.** TAPER is light, with three rest days and no sparring (pack 4.1). In section 6, Samira's Jab and Cross are "covered by sparring" in the week of her bout, which can't happen. Every fighter's held moves face a week with no sparring before every bout, and PEAK (sparring twice) is the only time sparring holds well. The map has no fight-week rule.

**4. The first style is always the cheapest.** Volume puncher (Jab, Cross, Step out) and Boxer-puncher (Cross, Lead hook, Step in) use only row-1 moves. Jab and Cross start at 51 and 45, nearest to 60. Every style adds the same +1 plan line, so the first style named is whichever is closest, and for most starts that's Volume puncher. Slugger, one of the code's six style words, has no set, so a Slugger can never be named.

**5. The plan line cap and losing a style mid-camp have no rule.** The plan holds 4 to 6 lines by the coach (CODE). A named style makes it 7 with the best coach. And when a style is lost in fight week (point 3 makes this likely), the map doesn't say which line is cut from a written plan. CHECK (Claude): whether the plan editor takes a seventh line.

**6. Gating the Feint takes away something that works today.** Feint is one of today's `StrikeMap` arrows and "always works in full" (pack, S448 code check). Making it pros-only removes a plan answer amateurs have now, which contradicts "saves load as they are".

**7. The read's mechanics are unwritten.** "A second Signature splits the read" and "the Feint draws the read" are named but have no rule: how the corner picks between two lines, how often it switches, or what the Feint actually does when the read fires. The measured fact is a 7-in-100 cost with no answer winning back more than 3.7 (pack 4.2). Unless the new answers are measured as better than that, going pro is a lasting tax of at least 3.3 wins in 100. READ1's pass line ("each answer wins back at least 2") allows that.

**8. The head coach's pads make the slot gate free.** Ex-pro (70) and Amateur coach (66) clear the 65 line on day 0 with no hire. For two of the four starts, the second slot is decided at character creation, and the young coach's selling point ("grows into the second slot") is worthless to them.

**9. The day-0 awards pass on their own.** Standard (Jab and Cross 30) and Bronze (Lead and Body hook 30) are met by the starting masteries at Technique 60. The first two season milestones are just 16 coached sessions.

**10. Day 0 depends on exact numbers.** Body hook is 0.5 x 60 = 30.0, and steps are 0.55 x 55 = 30.25. At Technique 59 or Footwork 54, the "six Usable, row 2 open, first pick in week 1" promise fails. The first-hour guide step can't rely on it.

**11. A combination is wrong.** "Uppercut opens 1-2-3b": 1-2-3b is jab, cross, body hook and needs no uppercut. Only 1-6-3 opens.

**12. The veteran has two definitions.** It is "31+ or 20+ pro bouts" in section 5 and "31+" in M8.

**13. The map breaks its own pronoun rule.** Section 6 says "her slot frees", "she holds Cut off", "her plan holds 6 lines". It breaks S412 and the map's own line "Game text never uses he, she".

**14. The market implies letting coaches go.** A market with "hire two" implies swapping, and letting the main assistant go is NOT ESTABLISHED (pack 4.12). The cost and what happens to growth on departure need a rule.

**15. Some screen rows can't be acted on as written.**
- The bout card's "open: Pivot (Pick)" can't be done with no slot free. It must read Swap, with its price.
- "Your Jab line was read in rounds 3-4" in the Why is actionable only if the Playbook shows the read target before the next bout. Add it to Fight prep.

Part 2 of 3

## 2. Depth: 6/10

**What is now a real decision:**
- **What to hold.** Pad minutes are shared by four fighters. Moves in the plan hold themselves in sparring, so writing a plan for this opponent decides which part of the identity survives the camp. That links the Playbook (the owner's favourite part) to progression, and it is the best idea in the map.
- **The coach hire.** Moves now, bodies now, or a coach who grows.
- **Answering the read** as a professional, once it has rules.

**What is still a lookup:**
- **The first style:** the nearest set, which is Volume puncher (logic 4). Styles differ only in their name and the plan line they add, so after the first, the player names whichever set they already hold.
- **What to hold:** "what's in my plan". The plan holds itself, and Sharp moves outside it fade to 50, still weapons. Dropping them is nearly free, so the board's real choice comes up only for Signatures. One Signature per fighter for most of a career means one decision.
- **The pick:** mostly the card that answers the next opponent's style word. With no pre-mark that improves, but PICKSPREAD1's pass line (first card best under 5 in 10) is the right test.

**Nodes nobody would take:**
- Herd (after Cut off, for the same pressure job) and Push off (an exit from a clinch the fighter chose to enter). Both depend on TREEVALUE1.
- Feint as an amateur, since it's now gated.
- Roll out against Pivot for "when pressed", unless their grades differ.

**The chore:** four fighters, each with a pick every 2 to 4 weeks, holds to place, fading lists every Monday, and the club's pad nights to share. The map says "at most two decisions a fighter", so eight on a busy Monday. The "Coach runs it" control (AGREED, NOT BUILT) is the obvious way out and the map doesn't use it.

**What changes fight night:**

| Unlock | Numbers | 3D |
|---|---|---|
| Move to Usable | Yes | Yes |
| Sharp, Signature | Only with FireLevel on (+2.8 / +2.7) | No |
| Grade | Yes (x1.2 / 0.85 / 0.35) | Steps only |
| Height and reach | Yes, 1 to 4 in 100 | Steps |
| Style named | +1 plan line | No |
| Award | Energy discount | No |
| FIGHT-PROVEN | +3 mastery | No |
| Being read, and its answers | Yes, once written | No |

About a third of what the player works for (Sharp, Signature, styles, awards) never shows in the 3D, only in the dice.

## 3. Play: 6/10

**What would make me press Continue:** a line crossing nearly every week, the three-clock strip with dates, the coach milestones ("9 pad sessions to 65"), the Why naming the node that would have answered, the professional's read, and veterans teaching club mates. The amateur and pro arcs now differ in kind, not just in row count.

**What holds it back:**
- **The read is a lasting tax.** It costs up to 7 and gives back at most 3.7 (measured), so the pro stage feels like losing ground until READ1 shows the new answers do better.
- **The early season clock is empty.** Standard and Bronze come from sessions alone, and the first style is automatic.
- **A held move can't be seen fading.** The player learns it from a list, not from the fight. A Sharp jab that slips back should look slower on fight night, or the cost is invisible.
- **Fight week punishes holding** (logic 3). Every bout costs identity, which is the opposite of the reward the player expects.

## 4. Options

**Missing:**
- **A fight-week hold rule.** Holds are frozen in TAPER (the fade pauses), because the camp phase is the game's own rhythm.
- **Styles that differ in fight effect,** not just a line (see To reach 10/10).
- **"Coach holds it" per fighter.** The coach holds the plan's moves and the Signature by default, and the player overrides on the board. It uses the agreed "Coach runs it" control.
- **The read target shown in Fight prep** before a pro bout ("their corner will wait for your 1-2"), with "Change the plan" on it.
- **A rule for a style lost while a plan is written:** the extra line stays until the next bout, then goes.
- **A rule for letting a coach go,** for the market.

**Useless as written:**
- The Feint gate for amateurs.
- The head coach's pads opening the second slot.
- The Standard and Bronze tests at today's start.
- Push off and Herd, until TREEVALUE1.
- The amber "Signature fading" need in fight week (it will fire every bout).

**Coaches and staff:** deep enough, close to too much. Five hires, two at once, growth, a slot line, a Signature rate and the head coach's own pads are six levers. Cut the head coach's pads from the slot rule and keep the rest behind COACHMARKET1. Staff jobs need nothing.

**The menus:**

| Menu | Right place? | Found? | Can't act on |
|---|---|---|---|
| Profile, NEXT UNLOCKS | Yes | Yes | Nothing; each row opens its node |
| Playbook > Moves, the tree with the Specialty board | Yes | Yes | Nothing |
| Playbook > Combos | Yes | Yes | Pick needs a free slot; show Swap otherwise |
| Game plan, greyed lines and the style line | Yes | Yes | Needs the line cap rule |
| Week tray, hold minutes | Yes | Yes | Fight week needs its rule |
| Monday review | Yes | Yes | Nothing |
| Home, "A move to pick" and "A Signature fading" | Yes | Yes | The fading need fires every fight week |
| Fighters cards, style and award | Yes | Yes | The award is decoration until the tests are re-set |
| Fights > bout card | Yes | Yes | "Pick" without a slot; use Swap |
| Fight prep after a tell | Yes | Yes | Add the read target for pros |
| Fight night, grade on hover | Yes | Hover | Fine |
| Result and the Why, read line | Yes | Yes | Needs the read target before the next bout |
| Club > People, the market | Yes | Yes | Needs the let-go rule |
| Signing card | Yes | Yes | Fine |
| Pro offer, read line | Yes | Yes | Fine |

Part 3 of 3

## 5. To reach 10/10

Mechanics, most important first.

1. **Holding is a rule, not a gain.** A move's weekly minutes met means no fade that week, checked in `Specialty.gd`, never through `MoveMastery` gain. Set the minutes against the real pad night (75 minutes, unless `PadWeek` says otherwise), so a careful player holds 4 Sharp and 1 Signature on 2 pad nights plus sparring, and still has 30 or more minutes to learn. HOLD1 confirms.
2. **The camp phase sets the holds.** In TAPER, holds are frozen (no fade). In PEAK, sparring counts double for holds. BASE uses the normal rule. A bout week never costs identity.
3. **Make the styles differ in fight effect, and make none free.**
   - Each style needs at least one row-2 or row-3 move. For example, Volume puncher becomes Jab, Cross and Step back; Boxer-puncher becomes Cross, Lead hook and Pivot.
   - Each style gets one fight effect from the code's existing levers, ESTIMATE until STYLE1 measures it:
     - Pressure fighter: pressure built x1.2.
     - Out-boxer: range steering +0.1.
     - Counter-puncher: edge on "waiting to counter" exchanges +0.15.
     - Volume puncher: a combination's energy x0.9.
     - Boxer-puncher: plan edge at mid range +0.1.
     - Add Slugger (Cross, Uppercut, Body hook): knockdown chance x1.1.
   - The extra line stays.
4. **Write the read as a rule, then measure it.**
   - The corner waits for the line fired most in the last two bouts.
   - If a second line is within a fifth of its fires (a second Signature does this), the corner alternates by round and the cost halves.
   - A Feint at Sharp makes the read wrong 1 time in 2 when it fires.
   - READ1 passes only if a careful pro gets back to within 2 in 100 of not being read. Otherwise lower the read's cost. Show the read target in Fight prep.
5. **Keep the Feint for amateurs as today** (Usable from day 0 or old saves). Professionals gain Feint at Sharp as the read answer. Drop row 4, or make it the professional's Signature work on the Feint.
6. **The second slot needs an assistant with pads 65+.** The head coach's pads apply only to the head coach's own pad places (RPG 2).
7. **Re-set the award tests to the tree:** Standard means Jab, Cross, Step in and Step out at 30 plus 8 sessions; Bronze means two row-2 moves; Silver means the Check hook and a held move at Sharp; Gold means two held Sharp moves and one row-3 move. Then no award passes on day 0.
8. **Plan line rule:** a named style allows one line past the coach's cap (at most 7). A style lost while a plan is written keeps its line until that bout.
9. **"Coach holds it" per fighter,** on by default: the coach keeps the plan's moves and any Signature; the player overrides on the board. Only a fading Signature outside the coach's hold raises a need.
10. **Show fading on fight night:** a held move's 3D clip slows by up to 10% as it falls from 60 toward 50 (with the Speed reads, after stills).
11. **A rule for letting a coach go:** a week's pay; growth already earned stays with that coach; the slot re-reads at once.
12. **Make day 0 robust:** start steps at max(30, 0.55 x Footwork) for every fighter with Footwork 50 or more, so the first pick lands in week 1 for nearly every start.
13. **One veteran rule (31+), the 1-6-3 fix, and no pronouns in section 6.**
14. **Measure before build, in order:** FIRELEVEL3, HOLD1 with the camp-phase rule, STYLE1, READ1 with the written read rule, PICKSPREAD1, TREEVALUE1, COACHMARKET1.

These need things the game can't do yet: a 3D clip that slows with mastery and Speed (after the stills); style fight effects (new levers, measured first); the read rule (built and measured, switched off today).

### The 10/10 tree page at 1920×1080

The shell stays: dark top bar, left rail. The content area is the WarmKit whiteboard.

- **Header strip** (full width, about 120 px): the comic portrait, name, class, record, the style named (or "2 of 3 for Pressure fighter: Body hook 54 of 60"), the award chip, height and reach, and the mastery cap ("Moves top out at 75: Technique 66 opens Signature").
- **Tree** (left, about 1120 x 640 px): four branch columns by three rows, with the professional's Feint work shown as a marker note under the Jab. Each node is a magnet with its bar, ticks at 30 / 60 / 85, a grade letter and a gold pin when proven. Held moves get a coloured ring, learning moves a circled slot mark, locked ones are grey with their line. A toggle sits top right: BY BRANCH or BY PLACE IN THE RING.
- **Selected node** (right top, about 620 x 420 px): the clip on the body, the bar and the day of the next line on this week's pad nights, which opponent modes it answers, its grade and the two abilities behind it, what it opens, the minutes to hold it, and buttons Watch, Drill, Pick or Swap (with the price), and Hold or Drop.
- **Specialty board** (right, under it, about 620 x 340 px): held moves as frames, each with its minutes this week, how they're covered (plan sparring or pads) and the phase rule ("TAPER: frozen"). Below them, the style each set is near and its fight effect, then "Coach holds it" with the override marks.
- **Clocks strip** (full width, bottom, about 140 px): WEEK (the nearest line and its day), SEASON (the next award or the style's missing move, and the nationals date), CAREER (the pro offer or the next Signature with its Technique need; for a pro, the line the next corner will wait for). At the right end, the pads coach, rating and next milestone ("Reid: Signature rate 0.95").

There's no score and no best-pick badge. Hovering any number shows its rule.

CHECK (Claude): the pad night's length and `spar_pool`; whether the plan editor takes a seventh line; whether a bout attributes exchanges to lines (FIGHT-PROVEN); the cost of letting the main assistant go.
CHECK (John): the GB Boxing Awards tests, if the award tests are re-set as above.

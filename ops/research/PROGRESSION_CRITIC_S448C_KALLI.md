# PROGRESSION_CRITIC_S448C_KALLI - Kalli answer (seat queue SQ53)

Brief: research/PROGRESSION_CRITIC_S448C_BRIEF.md
Sent: 2026-11-13 11:05 | collected: 2026-11-13 11:23 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Got it. I'm scoring PROGRESSION map v3 on what's in this brief only, and I'll paste the critic as text in parts.

Part 1 of 3

# PROGRESSION, design map v3: critic (S448, Kalli)

Judged on this brief only. I couldn't open the Miro board, the real screens on E:, or the S432/S428/S439/S429 maps it cites, so anything taken from those maps is judged as the map quotes it.

**Verdict:** Depth 6/10, Play 7/10. I would defend Play to the owner. I would not defend Depth yet.

What now works: holding is a rule, not a gain; the camp phase freezes fades; the plan holds its own moves, so writing the plan decides what survives; styles change the fight; the read is written down and shown before the bout. The first pick comes in week 1, and pros have their own season milestone.

What keeps Depth at 6:
- One node (Pivot) sits in three of the six style sets.
- The cheapest style is still the same for nearly every start.
- Silver forces the Check hook on every amateur.
- The sparring numbers don't hold a Signature, or a full plan, the way the map says.

## 1. Logic check

**1. Sparring doesn't hold the whole plan.** The 180 sparring units are shared over the moves "on the fighter's cards and plan" (pack S448). A 6-line plan plus 3 pad cards is 9 moves, 20 units each. That just covers Sharp (20), but never Signature (40), and with a 7th line or a 4th card even Sharp falls short. "The plan holds its own moves" is true only for a short plan with no Signature. Section 6 (Samira's Jab and Cross held by Thursday sparring) only works because PEAK doubles it. And if the coach's BASE week has no sparring night, nothing in the plan is held between camps. CHECK (Claude): whether the coach's BASE and BUILD weeks contain a sparring night.

**2. Injuries and suspensions have no hold rule.** A stoppage loss means at least 30 days out. While out, the fighter gets a quarter of gains (pack 4.10) and can't do pads or spar. Four or five weeks at 1.5 a week takes a Signature from 85 to about 78 and drops a style. The map freezes fades in fight week but says nothing about injury, which is when the player can do least about it.

**3. Volume puncher is still the cheapest style.** It's Jab (51), Cross (45) and Step back, with one row-2 node one step from Step out. Boxer-puncher needs the Pivot from 0 through Step back. Out-boxer needs Step back and Pivot. For a Technique-60 start, Volume puncher is reached first nearly every time. STYLE1's "no style in more than 1 career in 3" will fail on day-0 distance alone.

**4. Pivot is a lookup.** It's in Out-boxer, Counter-puncher and Boxer-puncher, it opens the Check hook, and the Check hook is the Silver test. Picking Pivot as soon as Step back is Usable is right for most fighters. PICKSPREAD1 will show the coach's first card winning whenever Pivot is on it.

**5. Silver forces one move on every amateur.** "Check hook at 30" is a fixed node on every amateur's road, which makes the pick a lookup for that whole stretch. Gold (two held Sharp and any row-3 move) is less specific than the award before it.

**6. The awards carry real names with invented tests.** The pack uses the real GB Boxing Awards (`SkillAwards.gd`), and M10 swaps in invented tests under those names. The owner's rule allows real organisations only where legal. CHECK (John): whether the award names may stay with tests that aren't the real ones.

**7. The young coach is the worse long bet.** The young coach grows +1 per 20 pad sessions (100 sessions to 65). Hale grows +1 per 10 (70 sessions to 65) and has conditioning 90. Hale reaches the second slot sooner, so the young coach is only the cheap option, not the one who grows. CHECK (Claude): whether Reid, as a sessional coach, can run enough of the 8 pad nights to grow and to cover two fighters.

**8. The Feint rule is ambiguous.** "Makes the read wrong 1 time in 2 when it fires": it's unclear whether that means when the Feint fires or when the read fires. These are different rules with different READ1 results.

**9. The game can't see the number READ-PROOF needs.** "The read costing under 2 in 100" is a counterfactual. It needs the Why's replay (the swing count already replays the dice without the plan's edge) run again with the read off. That's new work in `FightWhy`, not a rule read from state. CHECK (Claude).

**10. Old saves with Feint lines.** A Feint already in an amateur's plan starts at 60, but it now sits in row 3 behind 9 Usable moves and Jab 60. The map doesn't say whether a node with mastery in a locked row is usable. If it isn't, old saves lose a working line, which contradicts the old-saves rule.

**11. The pad-night board changes an agreed rule.** The owner approved the Week's top row "two fighters in camp only, until a camp ends" (R55, pack section 6). The map makes it permanent whenever 2+ fighters train. It's actionable, but it changes an approved conditional element and needs his OK.

**12. Names appear outside headers (owner S448).** The pad-night board ("who holds each night") lists fighters by name in rows. Home's "A MOVE TO PICK" and "A SIGNATURE FADING" notes need to say for whom. The market lists five coaches by name in body rows. Use portraits or class and record in rows, with the name only in the page or card header. Section 6 is a designer example and is fine.

**13. The pack contradicts itself on pronouns.** The pack's new line says options use "her / him", while SANDBOX S412 says never a fixed he or she. The map follows S412 ("when pressed", "the opponent's pressure"). That's the safe reading, but the pack line needs fixing so builders don't follow it.

**14. "Four fighters" is three boxers.** In section 6 there are three boxers plus Ana on the mat. The four-boxer case (12 wanted pad nights against 8) is the one that stresses the hold rule, and it isn't played.

Part 2 of 3

## 2. Depth: 6/10

**Real decisions, week after week:**
- **Who gets the club's pad nights.** Learning against holding, across fighters: the best decision in the map.
- **Writing the plan.** It now decides which identity survives the camp, which ties the owner's favourite area to progression.
- **Which style to name** when two sets are held.
- **The coach market:** Reid now, Hale for bodies, the old trainer for speed.
- **For professionals,** covering the read with a second Signature, a Feint or a plan change on the shown target.

**Still a lookup:**
- Pivot as soon as Step back is Usable (logic 4).
- Volume puncher as the first style (logic 3).
- The Check hook in the Silver stretch (logic 5).
- Holds left on the coach's default. It's the right default for the chore, but it means most players never meet the specialty choice except through the plan. That's fine for the plan, but it means the Specialty board is a screen most players won't open.

**Nodes nobody would take:** Herd and Push off until TREEVALUE1 clears them (the map admits this). Roll out has one job ("loading up") that Pivot and Step back partly cover.

**Chore check:** with the coach's hold on, a usual Monday is one pick per freed slot plus the pad-night board. That's acceptable. The one chore left: after every injury the player rebuilds holds by hand, because the map has no rule for it (logic 2).

**What changes fight night:**

| Unlock | Numbers | 3D |
|---|---|---|
| Move to Usable | Yes | Yes |
| Sharp, Signature | Yes, with FireLevel on | Fading moves slower |
| Grade | Yes | Steps only |
| Height and reach | Yes | Step length |
| Style named | Yes (one lever, 1.5 to 4 in 100) and +1 line | No |
| Award | Energy discount | No |
| READ-PROOF | Shows the read is covered | No |
| FIGHT-PROVEN | +3 mastery | No |

A style has no look on fight night. A Pressure fighter named in the dice walks forward the same as before. Style is the biggest season unlock, and it should be the one the player sees in the ring.

## 3. Play: 7/10

**It makes me press Continue:**
- A line crossed most weeks, and the first pick in week 1.
- A style on the season clock that changes the fight.
- Fight weeks that never cost identity.
- READ-PROOF as a professional season milestone, with the read target shown in Fight prep.
- Coach milestones with session counts.
- The three-clock strip with dates on every row.

Amateur and pro weeks are now different in kind: build an identity, then defend it.

**What stops it at 7:**
- Injuries silently cost identity.
- The style doesn't show in the ring.
- The veteran arc depends on the sparring pair (C17) being built first, so until then veterans have only "fades x0.5".
- The early amateur season is Standard by sessions in about week 3, then a forced Pivot and Check hook road to Silver.

## 4. Options

**Missing:**
- **An injury and suspension hold rule** (frozen while out; the bars come back with the body).
- **A style's look in the 3D** (stance and distance through the existing step reads).
- **A rule for nodes with mastery in a locked row** (old saves).
- **The four-boxer pad-night case,** played.
- **The read replay** in the Why, for READ-PROOF.

**Useless as written:**
- The Check hook as the Silver test (it forces one pick).
- Pivot in three sets.
- The young coach as a growth bet.
- Herd and Push off until cleared.
- The permanent pad-night row without owner sign-off.

**Coaches and staff:** about right in size: five hires, two at once, one slot line, one Signature rate, growth, and let-go priced. The growth figures are the wrong way round (logic 7). The head coach's pads, now limited to the head coach's own pad places, are fine.

**The menus:**

| Menu | Right place? | Found? | Can't act on |
|---|---|---|---|
| Profile, NEXT UNLOCKS | Yes | Yes | Nothing |
| Playbook > Moves, the tree and Specialty board | Yes | Yes, through the plan | Nothing |
| Playbook > Combos | Yes | Yes | Nothing (Pick or Swap) |
| Game plan, extra line, read target | Yes | Yes | Nothing |
| Week, pad-night board | Yes | Yes | Names in rows; the permanent row needs owner OK |
| Monday review | Yes | Yes | Nothing |
| Home, pick and fading needs | Yes | Yes | Use the portrait, not the name |
| Fighters cards, style and award | Yes | Yes | Nothing |
| Fights > bout card | Yes | Yes | Nothing |
| Fight prep, read target | Yes | Yes | Nothing |
| Fight night | Yes | Hover | Style has no look |
| Result and the Why | Yes | Yes | "Read in rounds 3-4" needs the replay |
| Club > People, market | Yes | Yes | Names only on card headers |
| Signing card | Yes | Yes | Nothing |
| Pro offer | Yes | Yes | Nothing |

Part 3 of 3

## 5. To reach 10/10

Mechanics, most important first.

1. **Write the sparring hold as its own rule.** A sparring night holds every Sharp move in the plan, whatever the share. A Signature needs a sparring night plus 1/12 of a pad night, or a pad share of 1/6. The coach's BASE and BUILD weeks carry at least one sparring night (or the map says plainly that plan holds happen only in camps). HOLD1 tests a 7-line plan with a Signature and four boxers on 8 nights.
2. **Freeze holds while out.** Injured or suspended means fades frozen and learning stopped. On return, a "back in the gym" Monday line shows the holds kept. A loss never costs identity twice.
3. **Balance the style sets.**
   - Each set holds exactly one row-2 or row-3 node, and its total distance from a Technique-60 start is within 20 mastery points of every other set's.
   - No node sits in more than two sets.
   - Example sets: Boxer-puncher becomes Cross, Lead hook and Feint; Counter-puncher becomes Check hook, Roll out and Step back; Volume puncher becomes Jab, Cross and Roll out.
   - STYLE1 prints the day-0 distance table first.
4. **Give every style a look.** The existing 3D step reads use it, with no new clips: Out-boxer with longer range and more step-backs, Pressure fighter with forward steps, Counter-puncher with a held stance. Needs the stills gate.
5. **Free the award tests from single nodes.** Silver means any row-3 move at 30 plus one held Sharp. Gold means a style named. Rename the grades if the real GB names can't carry invented tests (CHECK, John).
6. **Make the young coach the long bet:** +1 per 8 pad sessions to 72, so the second slot comes in about 6 weeks of pads and the Signature rate passes Hale's within a season. Check Reid's sessional night limit.
7. **Fix the Feint rule:** when the Feint line fires in a round, the read misses its target for the rest of that round 1 time in 2.
8. **Build READ-PROOF on a replay.** The Why replays each read exchange without the read (the existing swing replay). READ-PROOF uses that number. Show it in the Why.
9. **Old saves:** a node with mastery 30+ in a locked row counts as known and usable, and the row's lock applies only to learning new nodes.
10. **Names only in headers:** portraits or class and record in the pad-night rows, Home notes and the market rows.
11. **Keep the R55 row conditional** (two in camp), or take the always-on row to the owner as its own question.
12. **Herd and Push off** merge into Cut off and Tie up unless TREEVALUE1 clears them, leaving 14 nodes.
13. **Veteran teaching** waits for C17. Until then, veterans get "fades x0.5" plus a clear end: retirement talk (AGREED career clock).
14. **Probe order:** FIRELEVEL3, HOLD1 (with injuries and four boxers), STYLE1 (with the distance table), READ1 (with the written Feint rule), PICKSPREAD1 (with Pivot's share reported), TREEVALUE1, COACHMARKET1.

These need things the game can't do yet: a style's look and fading clips (after the stills); a read replay in the Why; the sparring pair (C17); the "Coach runs it" control (C20).

### The 10/10 tree page at 1920×1080

The shell stays: dark top bar, left rail. The content area is the WarmKit whiteboard. The fighter's name appears once, in the header.

- **Header** (full width, about 120 px): the comic portrait, name, class, record, the style named and its effect ("Pressure fighter: pressure x1.2"), or the nearest set ("2 of 3: Body hook 54 of 60"), the award chip (amateurs) or READ-PROOF and Signatures (pros), height and reach, and the cap ("Moves top out at 75: Technique 66 opens Signature").
- **Tree** (left, about 1120 x 620 px): four branch columns by three rows, 14 to 16 magnets. Each has its bar with ticks at 30 / 60 / 85, a grade letter and a gold pin when proven. Held moves get a ring, coloured blue when the coach holds them and marker-red when you do. The learning slot is circled. Locked nodes are grey with their line. A toggle sits top right: BY BRANCH or BY PLACE IN THE RING.
- **Selected node** (right top, about 620 x 400 px): the clip on the body, the bar and the day of its next line on this week's nights, which opponent modes it answers that nothing held covers, its grade and the two abilities behind it, what it opens, the hold share and how it's covered now (sparring, pads or frozen), and buttons Watch, Drill, Pick or Swap (with its price), and Hold or Drop.
- **Specialty board** (right, under it, about 620 x 340 px): held moves as frames with their weekly share and cover, the phase line ("Fight week: frozen" or "Injured: frozen"), the style named and any second set held with Name this style, and the coach's hold switch.
- **Clocks strip** (full width, bottom, about 140 px): WEEK (the nearest line and its day), SEASON (the award or READ-PROOF, the style's missing move, the nationals date), CAREER (the pro offer or the next Signature and its Technique need; for a pro, the line the next corner will wait for). At the right, the pads assistant as a portrait with pads, Signature rate and the next milestone in sessions.

There's no score and no best-pick badge. Hovering any number shows its rule.

CHECK (Claude): sparring nights in the coach's BASE and BUILD weeks; Reid's sessional night limit; a read replay in `FightWhy`; whether nodes in a locked row can stay usable.
CHECK (John): whether the GB Boxing Awards names may carry tests that aren't the real ones.

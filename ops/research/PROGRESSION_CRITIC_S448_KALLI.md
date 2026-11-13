# PROGRESSION_CRITIC_S448_KALLI - Kalli answer (seat queue SQ49)

Brief: research/PROGRESSION_CRITIC_S448_BRIEF.md
Sent: 2026-11-13 10:21 | collected: 2026-11-13 10:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Got it. I'm scoring PROGRESSION map v1 on what's in this brief only, and I'll paste the critic as text in parts.

Part 1 of 3

# PROGRESSION, map v1: critic (S448, Kalli)

Judged on this brief only. I couldn't open the Miro board, the real screens on E: or the S432/S428/S439 maps it cites, so anything taken from those maps is judged as the map quotes it.

**Verdict:** Depth 4/10, Play 6/10. I would not defend it to the owner yet.

The parts that help: the three clocks with dates, the body deciding how well, footwork that is learned, the coach as a gate, and turning FireLevel on. The core decision is weaker than it looks. Every node in the tree is eventually learned to Usable by every fighter, so "which move next" decides the order, not the fighter. The real scarcity (Sharp and Signature, capped by Technique and paid for in pad hours) has no pick at all. As written, the tree also can't be climbed (hole 1).

## 1. Logic check

**1. The awards and the rows lock each other.** A row opens on its award, but the awards test moves that sit in the row they open. Section 6 has Tess picking the Uppercut because "Bronze needs it", but the Uppercut is in row 3, which Bronze opens. Samira's "Bronze next week if Body hook reaches 30" has the same problem: the Body hook is row 3 too. As written, no fighter gets past Standard. Each award must test only moves from rows already open. That means re-mapping `SkillAwards.AWARDS` tests to rows. CHECK (Claude): which moves each award tests today.

**2. The start state contradicts the code.** Today a signed fighter starts with Lead hook 0.62 x Technique (about 37 at Technique 60, already Usable) and Body hook 0.5 x Technique (about 30). The map has them arrive knowing row 1 only, with the rest "open or locked". Either the locks are fake (a hook at 37 behind a Standard award) or masteries get cut. Section 12 says row 1 keeps today's starting levels, but says nothing about the hooks. It also says nothing about fighters in existing saves.

**3. Grading uses attributes the game doesn't have.** M4 grades by accuracy, reach, strength, timing, explosiveness, inside and flexibility. Those are the AGREED, NOT BUILT 10 attributes and 12 skills. The built stats are Power, Hand speed, Technique, Defence, Conditioning, Ring IQ and Chin. M4 can't ship before the attribute rework, but the build order puts LINEGRADE2 at step 5. Reach is also a written fact in centimetres, and the pack says height and reach are facts, not bars. It can't be averaged with a 0-100 stat against the 62 and 50 lines.

**4. The Technique cap already gates Signature, and the map adds a second wall.** The mastery cap is 40 + 0.4 x Technique + 0.2 x Ring IQ. An amateur woman at Technique 60 and Ring IQ 55 caps at 75, so she can't reach Sharp-to-Signature (85) whoever coaches her. The map's "first Signature in the first pro year" depends on Technique growth it never states. On top of that, M6 adds a 75 pads-coach gate. Two walls on one line, and the player sees only the coach one.

**5. Marcus Hale can never open Signature.** His pads are 58, with a +12 ceiling, so 70 at most, under the 75 gate. Signature is closed for good in any gym that hired only Hale. The map also says Hale reaches pads 65 "in about two seasons". At +1 per 10 sessions that is 70 pad sessions; at 8 pad nights a week (PADPOOL1) that's about 9 weeks, not two seasons. CHECK (Claude): Reid's 74 and Hale's 58 pads ratings aren't in the pack.

**6. Some nodes have no fight hook in the pack.** Feint, Roll, Herd and Push off appear nowhere in the pack's moves, calls or plan answers. The map says every node "already has a fight hook and a clip or a step", but counts 8 steps, 2 defences plus Slip, 6 punches and links, and Feint has no source. CHECK (Claude): `StrikeMap.gd` and `ComboFlow` for each of the 22.

**7. The counts don't add up.** Section 0 says 6 punches, 8 footwork moves, 3 defences and 5 links. The table has 7 footwork nodes (counting in-and-out as one), 4 defence and inside nodes, and 4 links.

**8. Link nodes give combinations a second bar.** Book combinations already open on their own when their punches reach 30, and each has its own pad mastery. A "1-2 and 1-1-2 link" node puts a second bar on the same thing, which breaks the map's own "one bar per thing".

**9. Stamps are a second currency in all but name.** The award already requires its moves at their lines. Stamps add a parallel total (3/8/14/22/30) that the moves mostly satisfy anyway. Only FIGHT-PROVEN adds anything new.

**10. Some numbers are tagged CODE but the pack doesn't support them.** "Mood +5 on an award (CODE morale)": the pack's morale list has no award line. "Reputation +1" is NEW and invisible.

**11. The lead time differs from the pack.** "A fight week, no camp, 1 to 2 weeks out (S428)": the pack says club offers come 8 to 12 weeks ahead, or 2 to 4 in the first hour. "About 3 free mornings (C31)": the pack's week has seven mornings per fighter. If S428 and C31 changed these, the pack needs updating. Until then, the novice column is judged against a game that doesn't run that way.

**12. Four fighters need roster places a new gym doesn't have.** A new gym holds 3; four needs the bigger unit or a second club coach.

**13. The map breaks its own pronoun rule.** "Game text never says he, she": yet the node text says "answers 'when she presses'" and the Why says "Her pressure won 4 exchanges". It breaks S412. Use "when pressed" and "the opponent's pressure".

**14. A swapped-out move doesn't simply stop.** M2 says a move taken out of a slot "simply stops growing". Undrilled moves fade 0.75 a week, and only a move already at 30 is protected. A half-learned move swapped out decays, and the swap card must say so.

**15. The map rejects coach perks of +5%, then adds one.** Section 11 rejects them, but M6 gives strength and conditioning "x1.1 on those attributes". That's the same invisible +1.

**16. Some screen lines can't be acted on.** The bout card's "what this opponent tests" names a node and how far away it is. With no slot free, the player can't do anything there (owner rule, section 7). Grade letters in fight-night captions can't be changed during a bout.

Part 2 of 3

## 2. Depth: 4/10

**The pick decides the order, not the build.** With one slot and about 3 weeks to Usable per node (GAME formulas: pad night 2.1 an hour x 1.25 h x the coach factor), 22 nodes take about 60 weeks for one slot and about 30 for two. Every open amateur has every row-1-to-4 node at Usable within two seasons whatever the player picked. Picking only changes which move arrives a few weeks sooner. A tree everyone completes is a queue.

**The scarce end has no decision.** What actually separates fighters is Sharp and Signature: the Technique cap, the pad hours from 30 to 85 (the bar slows as it nears the cap), and FireLevel paying for each tier. The map lets any move at 30+ be drilled freely and puts its one pick at the cheap 0-to-30 step. It should be the reverse.

**These picks are a lookup:**
- With a bout booked: the card that answers what the opponent tests, if it reaches 30 before the date. Otherwise the award-path card. The coach ranks the cards in exactly this order and pre-marks the first, and an unpicked slot takes it. PICKSPREAD1's bar of "the coach's first card best under 7 in 10" admits this up to 69%.
- Step back first. Once steps are gated, every novice loses more to pressure without it (FOOTWORK1 measures exactly that), so it's always the first footwork pick. Gating a step that works today only to give it back is a penalty dressed as a reward.

**These nodes nobody would take:**
- Herd and Push off, unless a plan line or a fight call uses them (neither is in the pack).
- Roll beside Slip, for the same job.
- Feint, until it does something.
- Link nodes, which open on their own anyway.
- Any node that is neither a plan answer nor a weapon is worth +0.3 at most, past the fourth weapon (`BoutRules`).

**The chore:** four fighters, a pick every 2 to 3 weeks each, and three cards ranked by the same three rules. By season two the player presses the pre-marked card. The map's own fix (one click, auto-take) removes the decision instead of making it worth thinking about.

**What changes fight night, and what is an invisible +1:**

| Unlock | Numbers | 3D |
|---|---|---|
| Move to Usable | Yes: a weapon, a plan answer, combinations | Yes: the clip or step appears |
| Sharp, Signature | Only with FireLevel on (+2.8 / +2.7 wins in 100, GAME S427) | No |
| Grade Good / OK / Poor | Yes (x1.2 / 0.85 / 0.35), once attributes exist | Steps only (length, tempo) |
| Award passed | Energy discount on its moves | No |
| Stamps, reputation +1, mood +5 | Invisible | No |
| Style named | Nothing stated: a word and a card order | No |
| FIGHT-PROVEN | One stamp and some mastery | Gold on the node, off-screen |
| Strength and conditioning x1.1 | Invisible | No |

About half the unlocks are invisible on fight night.

**The fix that makes depth:** a fork, and a cap at the top.
- Reaching Usable stays cheap and ordered (the coach's teaching order is fine as a queue).
- **SHARP SLOTS**: an amateur can hold 3 moves at Sharp, a pro 5. **SIGNATURE**: 1 for an amateur, 2 for a pro with the coach.
- Choosing which moves fill them is the career pick. It is paid in pad hours and limited by the Technique cap, and the style you can be named comes only from what fills the Sharp slots.
- Push a fourth move to Sharp and the oldest Sharp move fades back to Usable. A fighter becomes the moves you specialised in, not the moves they have.

## 3. Play: 6/10

**What would make me press Continue:** the NEXT UNLOCKS strip with a date on each clock, the coach's pads gate as a milestone you can see coming ("Reid: 3 pad sessions to 75"), the Why naming the node that would have answered, and new plan answers arriving as moves cross 30. The week clock works.

**What doesn't:**
- The amateur and pro arcs barely differ. The pro arc is a 4-node row, a second slot (already possible as an amateur with a 65 coach) and Signature work the Technique cap may block. The veteran column has nothing to be eager for: "keeping moves" is maintenance.
- The season clock rests on awards gated by stamps (an estimate) and a style word with no effect. Nothing with a printed date sits on it except the nationals and rank, which exist already.
- With the circular gates, the season clock stalls at Standard.

**What's missing for play:**
- A specialty pick for the career (the Sharp and Signature slots above).
- A veteran role: a veteran can pass a Signature to a younger club mate at double speed. The club gains, and the fighter's last seasons have a purpose.
- A visible fight-night effect for a named style. For example, the opponent's corner reads it and the bout card says "plans for your counter-punching". That needs the agreed opponent adjustment, which isn't built.

## 4. Options

**Missing:**
- **Coachability changes learning speed.** It's a built personality value, and it's the obvious link the map ignores. For example, slot speed x0.8 at low coachability and x1.2 at high.
- **Habit fixes as nodes.** "Drops the right after the jab" is fixed by drilling the guard return, and the habit list exists already.
- **A move from the twist card.** The visiting pro teaches one node at x2 for a week (UFC's guest teacher). The card exists.
- **Age changes the speed.** Young fighters learn faster; veterans hold better. The pack has ageing.
- **Swapping a slot**, with the fade shown on the card.
- **A Sharp and Signature choice** (section 2).

**Useless as written:** stamps; link nodes; the pre-marked first card; reputation +1 per award; strength and conditioning x1.1; style named with no effect; "+0 on Sat 28" printed on most cards; the grade letter in fight-night captions.

**Coaches and staff:** the Reid against Hale choice (faster moves or faster bodies) is the best decision in the map. Keep it, but make the Signature gate slow progress, not a wall (below 75, Signature drilling at half speed), so a Hale gym isn't locked out for good. Source the pads ratings. Staff jobs need nothing more. Head-coach experience from your pad places is fine.

**The menus:**

| Menu | Right place? | Found? | Can't act on |
|---|---|---|---|
| Profile, NEXT UNLOCKS | Yes | Yes | Nothing, if each row links to its node |
| Playbook > Moves becomes the tree | Yes, but it loses the move book by ring place | Yes | Locked nodes are fine with their reason |
| Combos greyed with "needs X" | Yes | Yes | Not actionable unless a slot is free; add "pick it" |
| Game plan, greyed lines | Yes | Yes | Fine |
| Week pad tray | Yes | Yes | Fine |
| Monday review | Yes | Yes | Fine |
| Home, "A move to pick" | Yes | Yes | Fine |
| Fighters page award chip | Yes | Yes | The style word does nothing |
| Bout card, "what this tests" | Yes | Yes | Not actionable without a free slot; add "swap the slot" |
| Fight night grade in captions | No | Yes | Can't be acted on; move it to hover |
| Result and the Why, NEXT | Yes | Yes | Fine, it opens the pick |
| Club > People gates | Yes | Yes | Fine |
| Signing card, height and reach | Yes | Yes | Fine |
| Pro offer, Gold row line | Yes | Yes | Fine, it informs the decision |

Part 3 of 3

## 5. To reach 10/10

Mechanics, most important first.

1. **Break the lock between awards and rows.** Award N tests only moves in rows already open. Passing it opens row N+1. Re-map `SkillAwards.AWARDS` tests to the tree before anything is drawn.
2. **Keep today's start state.** A signed fighter owns every move at today's starting mastery. A node already at 30 or more is shown as known, whatever its row. Only nodes at 0 are locked. Old saves load as they are.
3. **Put the pick where moves are scarce.** Reaching Usable stays an ordered queue (one slot, two with the coach). The real pick is **SHARP SLOTS** (3 amateur, 5 pro) and **SIGNATURE** (1 amateur, 2 pro). A fourth Sharp move fades the oldest back to Usable. The style named comes only from the Sharp slots and must change something on fight night.
4. **Grade on built stats until the attributes land.** Map each node to two of Power, Hand speed, Technique, Defence, Conditioning and Ring IQ. Reach and height are a separate modifier (the duel's existing per-cm rule), never in the grade mean. Re-map to the 10 attributes when they ship.
5. **Every node must earn its place before it's drawn.** Run TREEVALUE1 first. Cut or merge any node without a plan-answer or fight-call hook (Herd, Push off, Roll, Feint until shown otherwise). Drop the link nodes; combinations already open on their own. Expect about 16 nodes.
6. **One Signature gate.** The Technique cap stays the wall. The coach's rating changes speed (below 75 pads, Signature drilling at x0.5), not access. Fix Hale's growth timeline against PADPOOL1's 8 nights.
7. **Drop stamps.** An award is its moves at their lines plus 8 sessions. FIGHT-PROVEN gives +3 mastery and the gold mark.
8. **No pre-marked card.** The coach's card shows its reason but isn't first by default. PICKSPREAD1 passes only if the coach's first card is best under 5 in 10.
9. **Personality and age set the speed:** coachability x0.8 to x1.2, under 23 x1.1, over 30 x0.9 to learn and x0.5 to fade.
10. **Make habit fixes nodes,** and let the twist card's visiting pro teach one node at x2 for that week.
11. **Give the pro and veteran arcs their own unlocks.** Pros get the Gold row plus a second Signature. Veterans can pass a Signature to a club mate at double speed.
12. **Fix the slot swap.** The card says a half-learned move fades 0.75 a week.
13. **Cut the invisible bonuses:** reputation +1, strength and conditioning x1.1, mood +5 on an award unless it's added to the morale rules.
14. **Reconcile the novice column with the pack** (lead time, free mornings) or update the pack. CHECK (Claude): S428 and C31 in code.
15. **Turn FireLevel on first** and re-run PROGPROBE1 with the Sharp-slot rule as arm C.

These need things the game can't do yet: grading on the real attributes (the 10-attribute rework), a fight-night effect for a named style (opponent adjustment, AGREED, NOT BUILT), and 3D step length and tempo (the visual gate).

### The 10/10 tree page at 1920×1080

The shell stays: dark top bar, left rail. The content area is the WarmKit whiteboard.

- **Header strip** (full width, about 120 px): the comic portrait, name, class, record, award chip ("Bronze: Body hook Usable to pass"), height and reach, and the Technique cap as a line ("Moves top out at 76").
- **Tree** (left, about 1180 x 760 px): four branch columns (Lead hand, Rear hand, Footwork, Defence and inside) by award rows, top to bottom. Each node is a magnet with its bar, ticks at 30 / 60 / 85, and a grade letter. Known moves are full colour, open ones outlined, locked ones grey with the line they wait for. The learning slot is circled in marker. Lines show what each node opens.
- **Selected node** (right, about 560 x 460 px): the clip playing on the body, the bar and the day it reaches its next line on this week's pad nights, what it opens (plan answers and combinations), its worth in wins in 100 against each of the four styles, and buttons Watch, Drill, and Pick (when a slot is free) or Swap (with the fade shown).
- **Specialty board** (right, under it, about 560 x 300 px): three Sharp slots and one Signature slot as frames, filled or empty, each with its drilling hours a week and the style the current Sharp set names. A move pushed into a full board shows which one fades.
- **Clocks strip** (full width, bottom, about 120 px): WEEK (the nearest line and its day), SEASON (the next award or the nationals and its date), CAREER (the pro offer or the first Signature and what it waits on). Beside them, the pads coach's rating and the next gate ("Reid: 3 sessions to 75").

There's no score and no best-card badge. Hovering any number shows its rule.

CHECK (Claude): which moves each award tests; Reid's and Hale's pads ratings; fight hooks for Feint, Roll, Herd and Push off; the S428 lead time and the C31 mornings in code.
CHECK (John): the GB Boxing Awards order and what each grade tests.

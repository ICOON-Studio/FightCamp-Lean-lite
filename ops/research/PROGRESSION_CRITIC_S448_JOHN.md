# PROGRESSION_CRITIC_S448_JOHN - John answer (seat queue SQ50)

Brief: research/PROGRESSION_CRITIC_S448_BRIEF.md
Sent: 2026-11-13 10:21 | collected: 2026-11-13 10:39 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

# PROGRESSION v1 (S448): critic

Depth **5/10**, play **6/10**. The idea is right: one bar per move, a pick under a cap, the coach as the speed, and three clocks. But as written, the tree mostly gets solved by reading the award tests, every fighter ends up learning the same moves, and two of its main parts grade fighters on stats the game doesn't have.

## 1. Logic check

- **The signing state contradicts the tree.** The code starts every fighter with all six punches: Lead hook at 0.62 × Technique and Body hook at 0.5 × Technique. At a Technique of 55 to 65, that puts Lead hook at about 34 to 40, which is already Usable, and Body hook at about 28 to 33. The tree puts Lead hook behind the Standard award and Body hook behind Bronze. Section 12 keeps "row 1 at today's start shares", but it never says what happens to the Lead hook and Body hook mastery a fighter already has. Either the fighter keeps them, and rows 2 and 3 are half done on day 0, or they're taken away, and every new signing gets weaker than today.
- **Own combinations become pro-only, but they're built for everyone today.** Pack 4.2 and 5.5 say any player can build their own chains in Combos now. Row 5 locks "own chains of 4+" until Gold and the pro offer. That takes away a built feature the owner calls "really fun".
- **M4 grades on attributes the game doesn't have.** Grading by accuracy, timing, explosiveness, inside, flexibility and reach needs the 10-attribute and 12-skill model, which is AGREED but not built. Today's stats are Power, Hand speed, Technique, Defence, Conditioning, Ring IQ and Chin. Reach is also a written fact in centimetres (pack section 3), so it can't be averaged with a 0–100 bar against the 62 / 50 cut points. The S&C link in M6 (x1.1 on Strength and Explosiveness) has the same problem.
- **The pack and the map disagree on height.** S410's versus screen shows height for both boxers. The map says our fighters have no height key. Pack S410 also says the game holds no reach. This is not established, so check the code before BODYFACTS1.
- **The node counts don't add up.** M1 claims 8 footwork moves and 3 defences. The tree draws 7 steps (counting in-and-out) and 4 defences (Slip, Roll, Tie up, Push off). Feint, Roll, Herd and Push off aren't in the pack's moves, plan answers or corner calls, so "every node already has a fight hook" isn't shown for them.
- **The Gold award is tied to turning pro.** The GB Boxing Awards are amateur awards. A boxer who gets the offer at 9 wins with only Silver is a pro whose row 5 never opens, but the Pro offer modal promises "turning pro opens the Gold row". Platinum opens nothing at all.
- **FIGHT-PROVEN needs per-move land counts.** The bout is settled as 30-second exchanges on an edge. The pack only confirms that combinations thrown get marked gold. Whether the bout records which single move landed and how often is not established.
- **The bout card can't name "what this opponent tests" for an amateur.** S410 says there's no scouting before accepting an amateur offer, and tells open only through tape study in camp. Before acceptance, only the free style word is known.
- **The fight-week timing contradicts the pack.** Section 5's novice "fight week, no camp, 1 to 2 weeks out" conflicts with pack 4.5 (club offers usually come 8 to 12 weeks ahead) and 4.3 (camp at 3+ weeks). The code wins.
- **"+5 mood on passing an award" is labelled CODE, but pack 4.11 lists no such morale move.** Award passing also doesn't appear in pack 4.11, so treat the +5 as NEW.
- **Escapes are lost.** The agreed menu folds Escapes into Moves. The tree turns Moves into the tree and has no escapes.
- **The text breaks S412.** M7's "Her pressure won 4 exchanges", M1's "answers 'when she presses'" and section 6's "her next opponent" all use a fixed pronoun. The plan situation names in the code ("she presses", "she tires") have to be renamed too, or every node card repeats them.
- **Coach gates the map can't apply.** It's not stated whether both Luke and Marcus can be hired at once, or what pads rating you, the head coach, have. The new +1 experience for "YOUR pad places" implies you run pads. Hale's ceiling is 58 + 12 = 70, so Hale's fighters can never do Signature work, and the map doesn't say so.
- **Under-30 decay is unstated.** The code stops a move at 30 or above from falling back under 30. When a move under 30 is swapped out of the slot, the map says it "stops growing" but doesn't say whether it fades.

## 2. Depth: 5/10

**The pick is mostly a lookup.** Rows open by award, and awards need the exact moves `SkillAwards` tests. So the right card is almost always whichever move the next award tests, because it opens a whole row. Tess's Uppercut in section 6 is graded Poor and is still the card that matters most, since Bronze needs it. The coach ranks by opponent, build and grade, but the award gate outweighs all three. PICKSPREAD1 will likely fail the "first card best under 7 in 10" bar for exactly this reason.

**Nothing makes the pick permanent.** About 18 nodes at roughly one every 3 to 4 weeks per slot (about 10 to 11 pad nights from 0 to 30 at Reid's rating) is a 1 to 2 year amateur career. After that every fighter knows every node, so fighters converge. The pick decides order, not identity. "Style named" is the only thing that tells fighters apart, and every fighter eventually reaches several styles.

**Breadth stops counting after about six moves.** A plan holds 4 to 6 lines, and the corner has 8 calls. Once a fighter has six Usable answers, a seventh adds nothing on fight night unless the fight punishes missing answers. Today it doesn't: opponents adjusting by round 2 is AGREED, NOT BUILT.

**Nodes nobody would take:** Push off (Tie up already does the job), Herd (a second Cut off), Roll beside Slip, and the 1-2 and 1-1-2 "link nodes". The code already opens those combinations when Jab and Cross reach 30, so they need no pick. Feint and in-and-out are unproven.

**The invisible +1s:** stamps, a reputation +1, mood +5, the award's energy discount (no number given), and FIGHT-PROVEN's +1 to +3 mastery. The parts that do show on fight night are fire share by tier (only once FireLevel is on), the grade multiplier (only if captions print it), and step length in the 3D.

**Chores:** about 1.3 picks a week for four fighters is fine, since the coach's card is pre-marked. The chore comes later: with no cost to holding moves, the Sharp and Signature drilling decides itself.

## 3. Play: 6/10

There's always a next thing in view with a date, and that's the strongest part. The week bar, the next award and the coach gate ("Reid: 3 pad sessions to 75") give real reasons to press Continue.

The amateur and pro arcs aren't different enough in the tree. The pro stage adds one row, a second slot and Signature work, and the pro's week is otherwise the amateur's week with more mornings. What should make the pro stage different is already measured but off: an opponent's corner waiting for your best line (−7 wins in 100). That would make one Signature a weakness and a second one valuable. The map doesn't use it.

The veteran stage has "holding" but nothing to decide. The coach side is a single choice between two hires, Luke for moves and Marcus for bodies, made once and never revisited.

## 4. Options and menus

| Place | Verdict |
|---|---|
| Profile, NEXT UNLOCKS strip | Keep. It's the only place all three clocks sit together. Cut the separate award chip text and fold the stamps into its hover. |
| Playbook > Moves becomes the tree | Right place. Use the BJJ `MatTree` look so both sports read the same, and keep Escapes as a branch. |
| Playbook > Combos greyed by node | Keep, but own chains must stay open to amateurs. |
| Game plan greyed line | Keep. |
| Week pad tray, slot card first | Keep. Add a visible Swap and what the swap costs. |
| Monday review rows | Keep. It has to stay a need on Home, never a pop-up. |
| Home steel need, A MOVE TO PICK | Keep. The amber state is pointless when Monday auto-picks: cut it. |
| Fighters, "Best move" with the award chip | The S410 cards have no Best move tile. Put the award on the card instead. |
| Bout card, "what this opponent tests" | An amateur can't act on it before tape study. Show it on Fight prep after a tell opens, or from the style word only. |
| Fight night grade captions | Fine, if it stays inside the "three rows" rule. |
| Club > People, coach gates | Keep. This is the coach progression the player will actually watch. |
| Pro offer, "opens the Gold row" | It's false for a pro below Gold. Fix the rule (see below). |
| Missing | A swap control, the holding cost of each Sharp move, the head coach's own pads rating, and a coach market beyond two names. |

The coach side is too thin to carry a career. There are two hires, two hard cliffs (65 and 75) and one growth rate. That's one decision, made once.

## To reach 10/10 (mechanics, most important first)

1. **Make held moves cost pad time, so fighters specialise.** A move at Sharp or above fades toward 60, not toward 30, unless it gets a share of pad or sparring minutes each week (for example 20 minutes for Sharp, 40 for Signature). With the club's 8 pad nights, a fighter can then hold about 4 to 5 Sharp moves. Which ones they hold is their style, and the pick becomes permanent. PROGPROBE1 must show that two fighters with the same start end season 2 with different held sets.
2. **Stop the award tests from deciding the pick.** Open rows by stamp total from any branch. Keep only row 1 and row 2's core (Jab, Cross, Lead hook, Step back) as fixed award tests. Re-run PICKSPREAD1 with the award-test move as a named arm, and it must not win more than 6 in 10.
3. **Make breadth pay in the fight.** Turn on the AGREED round-2 adjustment, so an opponent switches to the mode your plan has no answer for. Then each extra Usable answer covers one more mode. TREEVALUE1 needs a breadth curve: wins in 100 against Usable nodes held must still rise from 6 to 9.
4. **Make the pro stage its own thing.** For pros only, turn on the measured "corner waiting for your best line" rule (−7 wins in 100), so a single Signature gets read and a second one, or a Feint, is the answer. Row 5 opens on turning pro, whatever the award, and leaves the Gold name out of it. Platinum opens a perk pick or gets cut.
5. **Fix the signing state.** Map each start share to a node: any move at 30+ on day 0 is known, and its row counts as open for it. Publish the day-0 tree for each of the three starts and the male-boxer start.
6. **Grade on stats that exist, or wait.** Until the 10 attributes are built, grade each node on two of today's stats (Jab: Technique + Hand speed; Cross: Power + Technique; Lead hook: Power + Ring IQ; Body hook: Power + Conditioning; Uppercut: Power + Hand speed; Check hook: Defence + Ring IQ; steps: Footwork + Hand speed; Slip and Roll: Defence + Ring IQ). Reach and height are separate centimetre modifiers in `Duels`, never grade inputs.
7. **Keep own chains open to amateurs.** Gate only their length (2 to 3 moves as an amateur, 4+ as a pro).
8. **Turn FireLevel on after its re-measure,** or the Sharp and Signature lines stay invisible.
9. **Build a coach market.** Add 4 to 6 hireable coaches with different area profiles and ceilings. Give the head coach a pads rating from the chosen card. Replace the Signature cliff at 75 with a rate: Signature gain × (pads − 60) / 15, capped at 1. State whether two assistants can work at once.
10. **Check per-move land counts first.** If the bout can't record which move landed, FIGHT-PROVEN waits for that rule.
11. **Rename the plan situations in code** to fixed nouns ("presses", "boxes at range", "waits to counter", "loads up", "tires"), and fix the Why line.
12. **Cut** the Push off, Herd and link nodes, or merge them (link combinations open on their own, as they do now). Add Feint and Roll only once each one has a fight hook TREEVALUE1 can measure.

## The 10/10 tree page at 1920×1080

- **Rail (96 px) and dark top bar (64 px):** as they are now.
- **Header strip, full width, 120 px:** the comic portrait, name, class, record and rank, then height and reach in cm, the award chip with the stamp count, and the named style or "no style yet: 1 of 3 at Sharp".
- **Tree whiteboard, left, about 1130 × 720:** four marker columns (Lead hand, Rear hand and power, Footwork, Defence and inside) and five rows.
  - Each node is a magnet with the move name, a filling bar with ticks at 30, 60 and 85, and a grade letter.
  - A ring marks the moves in the learning slots. A gold star marks FIGHT-PROVEN moves.
  - Locked nodes are chalk outlines with the line they're waiting for. Thin marker lines join a node to what it opens.
  - Held Sharp moves have a small clock showing the pad minutes they need this week to hold.
- **Right panel, about 600 × 720, with three states:**
  - **A slot is free:** the coach's three cards stacked. Each shows the weeks to Usable on this week's pad nights, what it opens, which opponent modes it answers, its grade, and "waits: X". The first card is pre-marked, with a Pick button.
  - **A node is selected:** a clip of the move on the body (Watch), "Drill it" to the pad tray, what it opens, the plan answers it gives, and its holding cost.
  - **Nothing selected:** the slot's move, its bar and its days to 30, with a Swap button.
- **Clocks strip, full width under the tree, 140 px, three equal tiles:**
  - **Week:** the bar nearest its line and the day it should cross.
  - **Season:** the next award, its stamps, what it opens, and an estimated week.
  - **Career:** the pro offer's distance, or the next Signature, or the coach gate ("Reid: 3 pad sessions to 75").
- **Pad nights line, along the bottom edge:** the club's 8 nights as magnets showing who has each, plus the $75 overtime night as a button.

**Bottom line:** keep the tree, the slot and the three clocks. Add a holding cost, take the award tests out of the pick, and make breadth and a second Signature pay in the fight before drawing anything.

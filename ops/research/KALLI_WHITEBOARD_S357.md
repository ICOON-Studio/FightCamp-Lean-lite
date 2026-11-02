# KALLI_WHITEBOARD_S357 - Kalli answer (seat queue SQ25)

Brief: research/KALLI_WHITEBOARD_S357_BRIEF.md
Sent: 2026-11-02 07:40 | collected: 2026-11-02 08:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

**1. The three biggest first-hour problems**

1. **Too much at once, with no "start here".** Seven columns of two magnets each, plus a fatigue bar, dials, three goal lines, a twist and Test it, all land on one screen. A new player can't tell what to touch first.
   *Fix:* the first time the screen opens, show only the twist sticky and the goal lines. The week grid stays visible but dimmed, with one coach line: "This is my week. Change a day only if you disagree." The grid brightens once the twist is answered. The diet, new move and combo dials go into a collapsed "More" row until camp week 2.

2. **The fatigue numbers don't tell the player what's wrong.** A red bar with a "!" and a number shows a problem, not a consequence. A first-hour player doesn't know that 80 means gains x0.6 and injury risk x2.
   *Fix:* replace the number with a word: FRESH, WORKED, RED DAY or OVERCOOKED. The tooltip names the cost: "Overcooked: gains cut by a third, injury risk doubled." Show the number only in the hover.

3. **The goal column and the days aren't linked visibly.** The core promise is that the lines move the moment a session changes, but the change happens on the left while the lines move on the right. The player misses it.
   *Fix:* when a magnet changes, the affected goal line pulses and shows a small delta for 2 seconds: "Conditioning by fight night 66 → 70". Same for the twist buttons: hovering FIX IT or WAIT previews the goal lines before the player commits.

Also worth fixing, though it hurts the first hour less: there are two separate undo routes, picking the coach's card again and "back to the coach's week". Keep "back to the coach's week" as the only global undo, and put a small undo arrow on each changed magnet.

**2. Is the weekly decision interesting now?**

Half. The twist is a real choice because it has a price and it happens every week. The 0 to 3 edits are only interesting when the coach's week is visibly wrong for this fighter, and most weeks it won't be. The safe play is "never touch the magnets", so they'll stop being used by week 3.

*The one change:* make the coach's week **slightly wrong on purpose, in a way only the player can know**. The coach writes the week from the camp phase only. The player knows the opponent (film study), the fighter's habits (coach notes) and the twist. So every week, one goal line starts amber because the generic week doesn't fit the opponent, for example "Ortega is a pressure fighter: the coach's week has no slip rope". One or two edits turn it green.

The decision then becomes "read the opponent, fix the week", which is the manager's job. And Test it rewards that, because the edited week shows a better range than the coach's.

Arguing against it: a coach who's always a bit wrong may feel incompetent. Framed as "the coach plans the camp; you plan the fight", it reads as a division of roles, not a bad coach.

**3. What a player will misread first**

- **I, II and III look like week numbers or levels, not intensity.** Players will read "roadwork III" as a third session or a tier. *Fix:* use LIGHT, NORMAL and HARD as words on the magnet. Hard is already red. If the space is tight, use L, N and H with a tooltip. Roman numerals mean nothing to a boxing coach.
- **"BUILD / PEAK / TAPER" counted backwards.** In week 2 of 5 the chip says BUILD, which is fine. But "counted back from fight night" means PEAK lands before TAPER, and a non-boxer reads PEAK as the fight itself. *Fix:* show the phase as a strip of 5 small cells along the top (BUILD, BUILD, BUILD, PEAK, TAPER) with "you are here" under week 2, and the fight date circled at the end. Then nobody has to work it out.
- **"(coach)" on a twist button reads as "the coach will do this" not "this is the default".** *Fix:* label it "COACH'S PICK" and say in a small line under the sticky: "No answer by Monday = the coach's pick."

**4. One thing to cut**

Cut the **evening magnet** as a per-day edit. Evenings are pads or sparring, and the camp phase decides that well. Show the evening on the day as text only, and keep one weekly toggle in the dials row: "Sparring nights: 2 / 3". That leaves the morning magnets as the only thing to edit on the grid, halves the clutter in each column, and costs no real decision. Combos are already chosen in the dials row anyway.

**NOT COMPUTED:** whether one amber line a week feels guided or nagging, and whether first-time players find the twist sticky before anything else.

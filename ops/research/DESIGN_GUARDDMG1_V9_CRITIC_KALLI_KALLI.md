# DESIGN_GUARDDMG1_V9_CRITIC_KALLI_KALLI - Kalli answer (seat queue SQ289)

Brief: research/DESIGN_GUARDDMG1_V9_CRITIC_KALLI.md
Sent: 2026-11-22 13:40 | collected: 2026-11-22 14:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Scoring GUARDDMG1 v9 now, as a fresh critic.

**Depth 6, General design 6, Play 5. It fails the 8/8 bar.** v9 is the cleanest guard map yet: it gets the lines off your boxer's own trouble, each guard is built for one kind of opponent, and the feet give every boxer a different answer. But the choice is mostly settled before you make it, and the player barely sees it happen.

**Depth 6**
- **The read is free, so the pick is almost automatic.** The opponent's style word comes free at booking, and the table turns it into one guard: a Slugger gets High, a presser gets Elbows in, an Out-boxer gets Light, and a Counter-puncher gets no line. Nothing has to be found on tape first, so the only real thinking left is your boxer's feet.
- **Moving the stance is rarely right.** The best pair is on the natural stance in 28 of 35 boxer and style cases (25 in run 2). Owning a stance pays off over "a run of similar opponents", but amateur shows mix styles, and that run was never measured. So the long-term choice, the one with the most depth, has no evidence yet.
- **The opponent never answers the guard.** In real boxing a high guard invites body work and a tight guard invites hooks over the top. Here a guard pays the same all night. The game already has the right hook for it (`PlanRead`, where a line pays in full for its first 2 uses in a round), and the map doesn't say whether it applies to guards.
- **It does too little where the career happens.** Pro cells are only +1 to +5, but pros are where division tables repeat the same styles and owning a stance would matter.
- **Bar 4 is the wrong bar.** One answer per opponent across all boxers is the opposite of what this mechanic is for. I score Depth on bar 5 (7 of 7 boxers change their best guard), and that's the map's strongest result.

**General design 6**
- **Words clash with the corner fixes already in the game.** The corner minute's ONE CHANGE already has "Elbows in" (half the body punches go to the head) and "Gloves high". v9 adds a second "Elbows in" with a different effect, plus a "High guard". That's two words for one lever and one word for two effects, which breaks the one-word-per-concept rule.
- **The new Elbows in doesn't touch the body.** It's a flat +8 with no after-effect, while the game already moves body and head damage between the six body places. The guard built for body punchers ignores body damage.
- **The WHEN pick is mostly traps.** 3 guards times 6 moments makes 18 options, and nearly every one off the guard's own moment is negative. The waits-to-counter moment is negative for all three guards.
- **The plan's line budget isn't settled.** It doesn't say whether the guard line takes one of a new coach's 4 lines. That's the biggest cost it could have.
- **No size has a study behind it.** The map says so itself. Every Elbows in size is an ESTIMATE, and so is "not owned for 3 bouts".
- **Run 2's sizes overshoot.** The recommended run 2 gives the best guard pair +14 to +17.5 wins in 100. That's as much as a whole good plan (59 % against 45 %), from one line, and it bends the rule that training beats planning.
- **It uses a fixed he.** "The man in the other corner", "his feet" and "when he boxed at range" sit in lines the player will read. The S412 sandbox rule bans that.
- **In its favour:** it's buildable on existing hooks (`lv["base"]`, `lv["cost"]` and a stance layer on the bout's copy), the cuts from v8 are right, and the boxer's own trouble correctly stays with the corner's shouts.

**Play 5**
- **It's one quiet pick at plan time.** The felt reward is a corner's-eye word and one line in the Why.
- **The thing a player would enjoy seeing waits for a later build.** The pose and the planted or light feet only come with FIGHTPLAYER2.
- **Little to look forward to.** The "1 of 3 bouts to own it" counter is the only hook from week to week, and it's for a move the numbers say is rarely right.
- **The corner swap is good but untested.** It's the one live decision, and it wasn't probed.

**Real-world check.** Arthur Abraham's high guard lost clear decisions to Carl Froch and Andre Ward in the Super Six, both boxing at range with volume. That fits the table's High −8 against range.

## Missing, useless, and what each option changes (S403)

### What each option changes
| Option | Changes | Verdict |
|---|---|---|
| No guard line | nothing, so the line's slot stays free | Keep. It's the right answer against a counter-puncher |
| High guard | +9 when the opponent loads up, negative elsewhere; blocks more, lands less | Keep |
| Elbows in | +8 when the opponent presses; no after-effect | Keep, but merge it with the corner fix and give it a body effect |
| Light guard | +8 at range; lands one more, gets hurt more | Keep |
| WHEN (6 moments) | which moment fires the line | Cut it as a free pick: each guard has one moment |
| Natural stance | which guard is free; the other two keep half or none | Keep. It's the depth |
| Move the stance a step (pad weeks) | power, chin and head movement against feet and energy; not owned for 3 bouts | Keep, but only measured over a run |
| Corner minute swap | changes the guard or its moment between rounds | Keep, and probe it |

### Missing
1. **The opponent adapting to the guard**, through `PlanRead`.
2. **A body effect for Elbows in**, joined to the existing body and head share and the six body places.
3. **Tape that earns the read**: the style word is public, but how often the opponent loads up and their second game should come from tape study.
4. **A rule on whether the guard takes one of the plan's line slots.**
5. **A view of the division**, so a stance move has a reason: "your division's top 10: 6 press".
6. **Something visible in the 2D fight** each time the guard fires, before the 3D feet exist.

### Useless or broken as written
- **Most guard and moment pairs.** Any guard on the waits-to-counter moment, High at range, Light against a loader.
- **Light on tiring or hurt (+5).** It wasn't probed and nobody needs it.
- **The plan's "Elbows in" next to the corner fix "Elbows in".** One of them has to go.
- **Run 2's ×1.5 sizes.** They're bigger than a whole plan.

## To reach 10/10, most important first (sizes are ESTIMATES for the next probe)

1. **One word, one lever.** Use the corner minute's existing "Elbows in" and "Gloves high" fixes as two of the plan's guards, and cut the duplicates.
   - The plan sets the guard, and the corner's ONE CHANGE swaps it.
   - Elbows in keeps the fix's real effect: when it fires, the opponent's body share drops from a third to a tenth and the head share rises. That's paid in head damage, against the six body places.
2. **Make the opponent answer.**
   - The guard line goes through `PlanRead`: full pay for its first 2 fires in a round, less after that.
   - From the 3rd fire the opponent switches: against High they go to the body, against Elbows in they go upstairs, against Light they press.
   - The corner minute then shows "has adapted to your guard", and keep or swap becomes a real call every round.
3. **Drop the WHEN pick.** Each guard carries its moment: High when the opponent loads up, Elbows in when they press, Light when they box at range. The row has four choices: none, High, Elbows in or Light.
4. **Earn the read.** The style word is public. How often the opponent plays their main game, and a hidden second game, open on tape. The guard's grade word ("Beats it / Works / Walks into it") shows only once the main game has been found.
5. **Make the guard take a line slot.** It uses one of the plan's 4 to 6 lines. That's the price on top of the feet, and the reason "no guard" wins against a counter-puncher.
6. **Size it under the plan.** Keep run 1's sizes, not ×1.5. New bar: the best guard pair is worth no more than half of a whole good plan, about +7 wins in 100.
7. **Prove owning a stance over a career.**
   - Probe 10-bout runs: owned and moved against natural, amateur and pro, counted in weeks.
   - Draw pro opponents from the real division table.
   - Find out why pro cells are only +1 to +5. If the line can't fire more in 6 rounds than in 3, say so on the guard row.
8. **Replace bar 4.** The new bar is natural stance by style, with 2 generated boxers per stance and sex, and at least 9 of 15 cells clear of the noise.
9. **Show it in every fire before the 3D exists.** The corner's eye gets one line when the guard fires ("High guard: the hook hit gloves"). The Why counts power shots blocked and body shots taken. The week review shows "stance: 2 of 3 bouts to own it".
10. **Rewrite every player-facing line** with "your boxer" and "the opponent".
11. **Ask John to source the sizes** before the build: guard against puncher type, and how long stance changes take to own.

## The 10/10 page at 1920×1080: Fight plan, the guard row
Look B gym whiteboard, a cream paper sheet on the plaster wall. Kalam marker, Bebas Neue heads, numbers in IBM Plex Mono, nothing under 12 px. One figure: your boxer's comic portrait as a polaroid, head to feet. Gold on one thing, the coach's pick. Green on Continue only. All figures are **example data**.

- **Header** (0–90 px): the boxer's name and "VS" the opponent's name, both once; the bout date circled.
- **Left third:** the polaroid; "Stance: shoulder (natural)"; a small chalk strip "his division's top 10: 6 press, 2 load up, 2 box at range" (pronoun-free in the build: "the division's top 10"). Under it, the stance card: "a step wider: 0 of 3 bouts to own it".
- **Centre, the plan sheet:** the move lines as now; the guard row takes one of the line slots, shown as "LINE 4 OF 4: GUARD". Four magnets: NONE, HIGH GUARD, ELBOWS IN, LIGHT GUARD. Each shows:
  - the moment it fires ("when the opponent presses");
  - its grade word against this opponent ("Beats it", or locked with "open on tape");
  - its foot cost for this boxer ("in the feet", "a step off: keeps half, slower feet", or "two steps off: do not");
  - its after-effect ("body shots: a third to a tenth; more to the head").
  The gold ring is around ELBOWS IN, with the coach's note "The opponent presses 6 times in 10. Keep the ribs shut."
- **Right third:** "what the opponent will do": by round 2, after 2 fires, expect the switch to the head. A small row lists the opponent's games, found and locked, from the tape.
- **Foot:** the plan's checks ("one guard line", "a moved stance isn't owned: slower feet tonight"); "Test it" in slate; Continue in green.
- **Motion:** hovering a magnet tweens the expected wins line and shows the boxer's feet setting wider or narrower on the polaroid. Nothing opens by itself.

GUARDDMG1 v9 scores Depth 6, General design 6 and Play 5, so it fails the 8/8 bar.

The main problems:
- The style word is free at booking, so the guard almost picks itself.
- "Elbows in" and "Gloves high" are already corner fixes in the game, with different effects from the plan's new guards.
- The opponent never adjusts to the guard.
- The size the map recommends makes one guard line worth as much as a whole plan.

The fixes that matter most:
- Merge the plan guards with the corner fixes, and give Elbows in a real effect on body shots.
- Let the opponent adapt after 2 uses in a round, so keeping or swapping the guard in the corner minute is a real call.
- Drop the WHEN pick, and make the guard take one of the plan's line slots.
- Keep the smaller sizes from the first probe run, so planning doesn't outweigh training.

# Round 4: one combined pass on the seven menus

Operator: "so have them check on your designs rate them and make them 8/10". Agreed plan (2026-11-08): one pass built from this list, then critics check this same list. A numbered item is either done or not.

## Rules for every page
1. **One set of facts.** Any name, date, price or weight that appears on more than one page comes from `docs/mockups/s403/facts.json` or `roster_mma8.json`, through `kit.js`. Do not edit facts.json or kit.js: another agent is working beside you. If a shared fact or an icon is missing, use the nearest one, and name what you wanted in your final report.
   Load at the end of body: `<script src="facts.js"></script><script src="kit.js"></script>`. Usage is in the head of kit.js:
   `<span data-f="lucy.weight"></span>`, `<p data-t="Fights {lucy.opp} on {lucy.fight}"></p>`, `<b data-tip="Booked: {lucy.opp}">x</b>`, `<i data-ic="camp"></i>`, `<div data-kit="top"></div>`, `<nav data-kit="rail" data-on="Home"></nav>`, `<span data-face="lucy" style="width:40px;height:48px"></span>`.
   Attribute numbers: `lucy.p.Speed`, caps `lucy.p_cap.Speed`. Skill numbers: `lucy.s.Guard`, caps `lucy.s_cap.Guard`.
2. **One icon set.** Every icon is `data-ic` from kit.js (see `icon_sheet.png`). A fighter's state uses the same eight icons on every page: booked, camp, injured, offer, contract, free, leaving, retiring. Remove the page's own icon script. Only a chart or a body drawing may be inline SVG, and it carries the attribute `data-art`.
3. **10 attributes, 12 skills** (agreed, `ops/research/S400_REVIEW/SKILLS_PROPOSAL_S404.md`). Attributes: Strength, Explosiveness, Speed, Stamina, Recovery, Flexibility, Durability, Fight IQ, Composure, Heart. MMA skills in three groups: Striking (Accuracy, Timing, Defence, Footwork, Inside fighting), Standing grappling (Clinch, Takedowns, Takedown defence), Ground (Guard, Top game, Submissions, Escapes). A punch or a kick is a move and lives in the Playbook.
4. **Grappling is half of MMA.** It gets the same bars, cards and rows as striking on every page. The not-built mark goes on the header, never in place of the content.
5. **Every addition removes something.** Critics called these pages crowded and also asked for more. Each page's list says what goes. Do not add anything beyond the list.
6. **Only what the player can act on** (operator S398). A number that changes no decision goes into a tooltip or goes away. No text addressed to the designer anywhere on a page.
7. **Not usable now** = grey with the reason on it, and no red pin. **Not built** = full colour plus the `.uc` triangle (`MOCKUP_RULES.md`).
8. **The look stays.** Warm Kit art, Marker and Kalam fonts, 1920x1080, nothing overlapping or cut off, body text at least 13 px. One or two tooltips drawn open on each page.
9. **When a need stops the clock:** every dated need stops time on its date until answered. Red pin = this week (Megan, Kwame, Tomas). Amber pin = later (Danny). Never a count of "how many stop the clock".
10. **One home for each decision.** A contract or offer is decided on that fighter's Profile. Home and Money show the fact and a link "Open the talk", never the answer buttons. Bout offers are answered in Fights.

Facts that settled a contradiction: Lucy weighs 60.2 of 61.0. Pad nights are 3 in a week: Lucy has Mon and Wed, Aisha has Fri. Lucy has the 1-2 combination at Usable. Priya's weapon is known (she shoots); her weakness is not, and a tape study can find it. Lucy is unranked, enters the table at 4 wins. No fighter is paid a stipend today: stipends out a week is $0, and a stipend is something you can start ($250 a week). Tomas's goal is Stamina 44 to 46.5 by Mon 23 Mar, and it is off track on his current plan.

Every page: run `python tools/check_mockups.py <page>` until it prints MOCKUPS OK, render with `python tools/render_mockup.py docs/mockups/s403/<page>.html`, and open the PNG with the file tool to look at it. Repeat until nothing overlaps. Never open a browser or an app on the owner's monitors.

---

## HOME (`home`)
- H1 Fight card: a win-chance bar with its width (`lucy.win`, `lucy.win_note`) and one chip for what a win does (`lucy.stake`). Same chip on Megan's offer note.
- H2 Pins follow rule 9, and the legend shows both colours with the words from facts `needs.legend_red`, `needs.legend_amber`.
- H3 "Two in camp: the pads" is amber, a real trade-off, and shows "Pad nights: Lucy 2, Aisha 1".
- H4 State icons from kit.js with no extra dots or flags that have no key.
- H5 The club box shows members `members_of` and reputation, with break-even in the members tooltip.
- H6 Weight shows only when a fight is booked or a limit is near. Josh and Tomas show a quiet dash. Red only for a problem on a date; Aisha is amber.
- H7 A filter row above the table: All, Need me, Camp, Injured, Free.
- H8 Freshness has a tint legend and a tooltip naming the reason.
- H9 "Since last Monday" lines carry the next step where one exists. Danny's line reads Fight IQ, Lucy's reads Speed.
- REMOVE: Cash row in The club (top bar has it), the clipboard icon, the crest under the rail, the "All news and mail" pill's weight (make it a small link).

## FIGHTER WEEK (`fighter_week`, plus a new page `fighter_week_aisha`)
- W1 Pad nights on the grid match the control: Lucy Mon and Wed; Fri reads "Aisha's night" in grey. Weight comes from facts.
- W2 The coach's advice points at the fix: "Takedown defence 41 is the gap: Takedown drills" links to the session chip with its not-built mark. Do-it button must do what the advice says.
- W3 Header row: This week / Next week; Coach runs it / I run it; Copy to next 4 weeks; Copy from a fighter; Back to the coach's week.
- W4 Session chooser opens from a selected card, drawn open on one morning. It shows every session with the same chips, grouped Conditioning, Striking, Grappling (Mat rounds, Takedown drills, Cage work, Mobility), the not-built mark on the Grappling header.
- W5 The "All eight weeks" strip becomes readable: one row, each fighter's face with planned / coach-run / not planned, a red dot on a pad-night clash.
- W6 Forecast shows only the attributes that move, plus one large bar for this fighter's goal with the cap tick.
- W7 Chart labels no longer sit on the curve. Twist card has numbers on both answers. Jab is in the pad tray.
- W8 Icons: `fatigue` beside fatigue numbers, `pads`, `sparring`, `intervals`.
- W9 `fighter_week_aisha`: the same page for Aisha in camp (week 3 of 6), a week of Mat rounds, Takedown drills and Cage work, phase bands BUILD, and her one pad night on Friday.
- REMOVE: the zero attributes line, the always-open row of nine session pills, the grey "all eight" pips.

## PROFILE (`profile` Tomas, plus new pages `profile_aisha`, `profile_kwame`)
- P1 Skills column: all 12 as bars in three labelled groups, same bar everywhere, the fighter's three best marked `star`. The not-built mark goes on the group header. No paragraph.
- P2 A visible one-line key: star = one of the three best, red arrow = falling. Remove arrow-and-plus pairs that contradict. Delta shows only when not zero.
- P3 Goal uses `tomas.goal`, `tomas.goal_by`, `tomas.goal_rate`, marked OFF TRACK with one button to set the week.
- P4 Pay line for every fighter under the name: pay, contract end, next money. The offer card says what Tomas earns now and uses `tomas_offer.why`. Three answers: Match, `tomas_offer.promise`, Let him go.
- P5 Each bar: a band word (weak, fair, solid, strong, elite) in the tooltip, a ghost tick for the division's average.
- P6 Train: on the three weakest attributes and skills only, or a single sticky. Pick one and be consistent.
- P7 Durability uses the shield icon. No lock beside the scale: say "no fight booked".
- P8 `profile_aisha`: a BJJ specialist, ground skills on top. `profile_kwame`: decline view, cap equals now, each attribute's yearly drop, a small age curve, "fights left", the retirement talk as the top card.
- P9 An injured fighter puts the injury and return date in the top card slot: draw the slot's rule in the Kwame page's tooltip, and use Maria's numbers if you draw it.
- REMOVE: the skills paragraph, zero deltas, the weight row when nothing is booked, the "5 of 19 moves" chips.

## PLAYBOOK (`playbook` Megan's game plan, plus new pages `playbook_ground`, `playbook_combos`)
- B1 Every rating is marked an estimate until the opponent is scouted: hatched chip with "?" and width, e.g. "Beats it? (style only)".
- B2 Move preview is a body: silhouette with the target zone lit and the distance. Inline SVG with `data-art`.
- B3 Two tabs: Standing, and Cage and ground. On Standing, a range ruler across the top with one chip per place (Outside, Long, Mid, Inside, Clinch) so holes are visible at a glance. The line list stays under it as the detail.
- B4 Locked "no tell found yet" line offers Scout ($250, `scout`) and says what it opens. Fight-starts marks "best for Megan" and greys the one she cannot do, with the reason (Takedowns 30). A move that needs a coach has "Find a coach".
- B5 "Rate against each kind" is a ready five-bar chart beside Sound plan, one bar per opponent type.
- B6 Rounds and Fight starts fold into one "Fight shape" row, shown open only for a tooltip.
- B7 Drag handle (`drag`) on the book and the words "drag a move here" on the empty sixth line. Swap and clear use the icons `swap`, `clear`; clear is lighter.
- B8 Move group icons from kit.js: hands, kicks, knees, takedown, submissions, ground. Test uses `test`.
- B9 `playbook_ground`: Aisha, the Cage and ground tab, six real lines (on the wall, on top, on the bottom, escape, submission attempt, get-up), full colour, one mark on the header.
- B10 `playbook_combos`: the Combos tab, the part the owner calls fun. Read `docs/mockups/s402/` and `scripts/ui/` for what it is today and draw it with Lucy's and Megan's moves.
- REMOVE: the chalkboard's repeat of the chips, the half-blue Sound plan bar (a number out of 6 instead), "More: flow, map, real plans" as one button.

## FIGHT NIGHT (`fight_night`)
- F1 Set-up is available, Lucy has `lucy.combo`. The Why's right and wrong counts equal the sum of the lit-up plan lines below it: pick numbers that add up.
- F2 "Pick up to two": a chosen card looks different from the coach's suggestion, and the count is true. Every grey has its reason, Clear head included.
- F3 Remove the design note on the cutman card: "Left eye closing" and the two buttons only. Remove the NEW tag.
- F4 Body: one small body figure per fighter (`data-art`), red where it hurts, legs included, a "rocked" mark; only the three numbers that matter this minute. The rest in a tooltip.
- F5 The corner minute is the corner minute. In-round calls move to a clearly separate strip labelled "Once the round starts", each with a small glyph and a word, "2 of 2 used" shown, and a position label: the set changes with the position (a tooltip lists the ground set).
- F6 Energy shows "lasts to round 3 at this pace".
- F7 A one-row strip of round 1 in six exchanges, the big moment marked.
- F8 The Why's NEXT line has a button "Write the line".
- REMOVE: 1x, 2x and Skip from the corner view, the twelve-number body grid, the Clear head and Set-up tiles shrink.

## MONEY (`money`)
- M1 Price tags ranked: what fits now first. Bigger unit last, grey, no red pin, with "cash would fall to 2 weeks". The Club show is grey with no red pin and its date.
- M2 A "Coaches" panel: Striking, Wrestling, BJJ, Muay Thai, one row each with cost, the moves it opens, and face chips of who it helps. One not-built mark on the header.
- M3 Out a week has a Stipends line from `out_stipends`. The fighters table shows stipend as a clear off state with a "Start $250" button and one extra column: what each fighter earns the gym.
- M4 Kit text is true (mats ours, strength coach not hired). Dues bands show the weekly money effect; Cheap is grey with "the place is full".
- M5 On every tag, `runway` icon and a number ("2 wks after"), and a payback number on those that earn.
- M6 Chart runs forward 8 weeks, dotted, with known events: bills, Lucy's purse, Aisha's purse. An "if you do nothing" line.
- M7 Break-even goes into the members tooltip.
- M8 Contract notes become one line each with "Open the talk" (rule 10). An injured fighter's cost shows in Out if there is one.
- M9 Cashbook is a tab beside The books.
- REMOVE: "Leaves N weeks" sentences, the Dues-from-31 sentence, the three big contract stickies (that room goes to Coaches).

## WORLD (`world`)
- R1 Delete "Where your eight stand" and "Fixtures by date". Those are Home's job.
- R2 The ladder: ranks 1 to 10 of the selected division, with your fighter pinned in place or at the bottom with the entry rule (`lucy.entry`). No "places up" sentence that can't be counted.
- R3 Columns: win chance as a band (wide when not scouted), scouted (`scouted` / `unscouted`), trend, age, finish rate, style with a KO or Sub icon. "Ask for this fight" on rows within reach.
- R4 Division picker: one row of eight faces with state icon and rank. Sport tabs small (MMA now, Boxing beside it).
- R5 A side-by-side panel for the selected rival: your fighter against them on the 10 attributes (ranges when not scouted), with Ask for this fight or Scout $250 and what the $250 buys.
- R6 Title route for the selected fighter: "#5 to #1: 4 wins".
- R7 A complete legend, using `champion`, `challenger`, `next_opp`, `scouted`, `up`, `down`. Nothing drawn without a key.
- R8 News box stays.
- REMOVE: the old Dev column, the duplicate action buttons, movement arrows on rows that don't matter to you (dim them).

# Structure critic: grow the gym (week 4 screens 33-41)

Judged against YARDSTICK.md and PLAYER_PATH.md (Fighters: Roster | Find a fighter; Fights; Club; second fighter by week 4; pro offer stops the clock on its last day; trial Monday). Lenses: UX = UX lead, FUN = boxing-manager player, ART = art director.

## Scores /10
- UX lead: 6.5. Flow is right (Find a fighter -> trial -> Sign -> roster) and matches the plan. Weak on scaling and on two screens that are not what their file name says.
- Boxing-manager player: 6.5. Real ranges, traits, a perk road, a starting-focus choice and honest pro-offer costs are real decisions. The second fighter's pull is weak: nothing ties Kira to Lucy, and nothing gives Kira an arc.
- Art director: 6. The Look B whiteboard (marker headings, cork board, sticky note) holds on Home and the At-a-glance note. The roster, the Find a fighter list and the pro offer are plain white cards, not whiteboard. Faces are too small and too dark at roster size.

## Findings by lens
UX
- 37_training.png is byte-identical to 36_roster (capture error, no Training tab shown); 36b_roster_mat is also a duplicate of 36. So Training, mat and 2-fighter Week were NOT reviewed here. Re-shoot.
- Guide banner "Sign a second boxer / Three jobs for the club" stays on every screen after its steps are ticked, and sits above the page title on Roster, Records and Fighter. It is flavour plus a repeat of the Needs-you flag and the top-bar chip. "Meet the walk-in" is on the banner, in the roster, on Home, and in the top bar: four doors to one trial. (Only actionable info rule.)
- Roster at 3 rows is clean and sortable. At 8 rows it is fine as a table, but the Goal column cramps (Ana's "Blue belt ... 70% of the way" is two lines with a gap). Needs-you pills are per club, not per fighter, so at 8 they will overflow.
- Week review modal shows ONE fighter (Lucy). Kira's progress is in a side list. At 8 fighters a per-fighter modal does not scale; PLAYER_PATH says Home replaces it. It also opens over Home with no way to see the other boxers' bars.
- Home (41) keeps a stale red card "Lucy lost to Erin Doyle, Sat 31 Jan" in week 15 while Lucy is 9-2 and turning pro: a result from 11 weeks ago holds the top of Home. Home also stacks 4 sticky notes plus a bout panel; the pro offer itself is not on Home as a note (it arrives as a modal over Fights).
- Pro offer opens as a modal over the Fights page with its own content half hidden behind it; the page behind is a different fighter's offers (Kira). No "decide later" state is shown, though the plan says it stops the clock on the last day.
- Find a fighter: stats shown as ranges (scouted) is good. The list runs past the fold with no sort by weight class or need. Four prospects only; does not scale to a talent pool you hunt in.
- Trial modal duplicates the Fighter overview (attributes, traits, perk road) in a dense 3-column modal; good for the decision, but "Pass" and "Sign Kira" look nearly equal and there is no hint of cost beyond "$250 a week".

FUN
- Trial is the best screen: potential stars "a guess until the trial", out-boxer style tag, trait/habit/signature, perk road with "now 29/needs 30", three starting-focus choices (sharpen signature, fix habit, raise ceiling). Real tradeoffs.
- Prospect cards give style + a four-stat range, but no cost, no weight fit versus the gym's weight gaps, no "who else wants him". Nothing creates a scouting decision beyond "take the highest bars".
- Second fighter reason to care: only her goal "Next bout inside a month - at risk, 28 days" and "1.3 kg over". That is a chore, not a hook. No rivalry with Lucy, no training-partner effect, no shared-camp cost shown here.
- Pro offer is a real moment in content: 4 rounds, ticket sale bar (family 20 / members 27 / wins 18), fighter's cut $125 vs gym $31, gym pays $1,245, stipend and amateur path end, "a pro loss costs more". Stakes are honest. But it is a table, not a moment: no promoter portrait, no debut opponent face, no "this is the first time Bow Lane calls". No consequence preview for Kira (who loses the gym's attention).
- Roster fights sit at "No bout" for both Kira and Lucy while the Records show 12 offer notices in a row for Lucy: offer spam in Records, "Two bout offers came in" repeated 8 times.

ART
- Marker headings (FIGHTERS, CLUB, TRIAL header name, Turn Lucy pro?) work and are legible. Cork board with sticky notes on Home is true Look B.
- Roster portraits are 45 px and the two dark portraits (Kira, Lucy) are near black at that size: faces not readable. Prospect cards at 123 px read well. Records and roster are white-table, not whiteboard.
- Title/resume screen (33): Lucy v Maria portraits are strong and match the comic style; the "Saved" toast and the "Loaded" toast sit over content on 34 and 36 (toast "Declined. Another offer will come." appears on the trial, week review and pro offer screens as a stale message, so it looks like the game just declined something).
- Week review: bars, deltas, pads thumbs are readable; large empty white area at the bottom of the modal; "Gold award" and "NEW BEST rear-hand force 800 N" are dense blue text lines.
- Pro offer: ticket bar uses 4 greys/blues with a tiny legend; the key numbers ($125, $31, -$1,245) are right-aligned and clear. Red/green only on money, which matches "colour means risk".

## Screen table
| screen | UX verdict | fun 1-5 | look B fit 1-5 | the one most important fix (<= 15 words) |
|---|---|---|---|---|
| 33_title_resume | KEEP | 3 | 4 | Show what the resumed career needs (week, next fight), not a generic Lucy v Maria card. |
| 34_scouting (Find a fighter) | CHANGE | 3 | 3 | Add fit to your gym (weight gap, cost) and sort; make cards sticky notes. |
| 35_trial | KEEP | 4.5 | 3 | Make Pass vs Sign weights clear and show what the choice displaces on the roster. |
| 36_roster | CHANGE | 3 | 2 | Bigger faces, per-fighter needs, drop the repeating Needs-you pills and the guide banner. |
| 36b_roster_mat | CUT | 1 | 2 | Duplicate of 36 (capture error); re-shoot the mat/BJJ roster view. |
| 36c_records | CHANGE | 2 | 2 | Collapse repeated "two bout offers" lines; group by fighter, show only things that changed. |
| 37_training | CUT | 1 | 2 | Duplicate of the roster; re-shoot the Week tab for two fighters. |
| 38_moves (Overview) | KEEP | 3.5 | 4 | Fine; put the goal and next step first, stats fold below. |
| 39_review_two | MERGE | 3 | 3 | Merge into Home's Monday for all fighters; modal shows one boxer only. |
| 40_prooffer | CHANGE | 4 | 3 | Make it a moment: promoter and opponent faces, one stakes line, a decide-later note. |
| 41_home_two | CHANGE | 3.5 | 4.5 | Clear stale result card; put the pro offer and trial as notes. |

## MISSING
1. A real Week/Training screen for two fighters (37 is a duplicate) and a roster mat view.
2. A reason to care about the second fighter: rivalry, shared camp, partner bonus, her own story arc and first bout.
3. A scouting decision with cost: scout cost, weight-class need, competing gyms, time limit on a prospect.
4. Pro offer consequence preview for the other boxers, the stipend loss, the debut opponent face and date.
5. Roster at 5-8: sort, filter, per-fighter needs and a Home that scales (three urgent decisions then "and 2 more").
6. A real face size on the roster, with brighter portraits for the dark ones.

## Top 5 fixes (ranked)
1. Re-shoot 37 and 36b (training week for two fighters, mat roster); they were not reviewed.
2. Turn the pro offer into a moment: portraits, promoter, opponent, one stakes line, show the effect on the other fighters.
3. Give the second fighter a pull: partner/rival effect with Lucy and a first-bout arc, not only "bout inside a month".
4. Roster and Records for scale: larger faces, per-fighter needs, collapse repeated offer notes, remove the permanent guide banner and extra "walk-in" doors.
5. Home: clear stale results (Lucy's January loss), put trial/pro offer/camp as sticky notes, and fold the week review into Monday's Home for all fighters.

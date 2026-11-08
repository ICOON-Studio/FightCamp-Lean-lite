# Structure critic - booking to fight night (S400, screens3 10-22)

Read against YARDSTICK.md (look B, only actionable info, deeper not wider; lead = the WHY, the plan, the corner minute) and PLAYER_PATH.md section 8 (the fight flow). Lens tags: [UX] UX lead, [PLAYER] boxing-manager player, [ART] art director.

## Scores for this stretch
- UX lead: **6/10**. The chain offer -> bout -> camp -> weigh-in -> tape -> rounds -> result -> goal is complete and nothing dead-ends. But the plan is never visibly written, three pop-ups open by themselves, and the same job is offered in four places.
- Boxing-manager player: **6.5/10**. Real stats vs estimate, win band, rank stakes, camp with measurable stat gains, a corner minute with a Fix / Recover / Talk / Plan choice, and a result with a "Why" block are all there and they are the right core. Tension is thin before the bell (weigh-in is a non-decision, the plan is invisible) and the Why contradicts itself.
- Art director: **6/10**. Fight night goes dark and tight as allowed, and marker headers carry over. Against that: both fighters are the same blue muscle-holo with no face on the corner and result screens, the 3D camera lets ropes cut through the boxer, and several lines are unreadable.

## Screen table
| screen | UX verdict | fun 1-5 | look B fit 1-5 | the one most important fix (<= 15 words) |
| --- | --- | --- | --- | --- |
| 10_offers | CHANGE | 3 | 4 | Offer cards show 8-68% ranges; show one number plus the single reason it is risky |
| 11_bout_unsafe | CHANGE | 2 | 3 | Do not open a dead page: grey the unsafe offer on the list, drop the page |
| 12_bout | KEEP | 4 | 3 | Best screen here; move the stakes (win -> #6, loss) up beside Accept |
| 13_home_booked (dimmed + toast) | CUT | 1 | 2 | Remove the dim overlay and toast; the settled Home already says it |
| 13b_home_booked_settled | MERGE | 3 | 4 | Fight prep is offered 4 times; keep one pinned note, delete the other three |
| 14_camp | KEEP | 4 | 3 | Great real choice; make it a page of Fight prep, not a modal with "Later" |
| 15_fight_camps | CHANGE | 2 | 3 | After Start camp it dumps you on the roster; land on the plan page |
| 16_weighin | CHANGE | 2 | 2 | Weigh-in with 59.9 on 60.0 is no choice; show it only when there is a cut |
| 17_home_fightnight | KEEP | 3 | 4 | Good "TONIGHT" card; add the plan as a one-line checklist before Go |
| 18_tape | CHANGE | 3 | 3 | Tape says 0/3 tells answered and no plan; block or warn before Begin fight |
| 19_round1 (3D) | KEEP | 3 | 3 | Rope clips through her face and body; keep the camera inside the ropes |
| 19b_corner1 | CHANGE | 4 | 3 | Right idea; hide greyed-out rows (Fix, Set-up, Recover) and show only usable calls |
| 19c_corner2 | KEEP | 4 | 3 | Add each boxer's face in place of the identical holo; fix clipped scroll |
| 20_round3 | CHANGE | 3 | 3 | "EVEN ROUND" banner is cut off at the top; stat rings stay a stray HUD |
| 21_result | CHANGE | 4 | 3 | Why says GOOD PLAN yet she lost; name the one cause and give it a button |
| 22_goaltalk | CHANGE | 3 | 3 | Goal talk opens by itself over the result Home; flag it on the top bar instead |

## Findings by lens
**[UX]**
- Self-opening modals: weigh-in, tale of the tape and the goal talk all open without being asked. PLAYER_PATH s7 and the S268/S275 rule say nothing opens by itself except fight night and weigh-in, and bills and goal talks "wait on Home". The goal talk in 22 breaks that and covers the result headline with a toast on top.
- Duplicates: on booked Home the same task (prepare the fight) appears in the first-fight guide strip, a pinned note ("Fight prep"), a second note ("Set camp"), and the fixture card ("Fight prep"), plus the top-bar pill. Offers adds guide banner + red badge + pill for one offer.
- Flow break: the guide says "make one line against Priya in the Playbook", but nothing in this stretch shows a plan being made, and Home never shows whether it is done. PLAYER_PATH s8 steps 4-5 (checklist "what is unfinished", Write the plan) are not visible. The corner then says "Lucy has no combination yet".
- Weigh-in appears over the Fighters page, not Home; hopping area. Unsafe offer: Accept is greyed and the reason sits below the fold.
- "Pass" vs plan wording "Decline"; "Lucy's offer" label on both cards is unclear.

**[PLAYER]**
- Good: stats vs the estimate with ranges, scouting file with locked tells, rank consequences, camp that shows 62.1 -> 63.7 by fight night and thresholds ("past 60: body call"), three-way corner talk with numbers, a Why block with plan / against you / next.
- Weak: the plan has no visible weight before the bell, so the corner minute is the only decision. The win chance is 38% with a 8-68% guess that tells me nothing. Weigh-in carries no tension.
- The Why contradicts the result: "GOOD PLAN, worth +15%", yet Lucy lost on 28-29, 28-29, 29-28 while out-landing Priya 61 to 56. The reader needs to know why punches landed did not win the rounds (round 2 "on the work done"). NEXT says "the gap was elsewhere, check camp and condition", which is not an action. The fix button promised in PLAYER_PATH s8 step 10 ("one button that sets it") is missing; only "The plan, lit up" and "Back home".
- Corner screens are strong (energy, body shots, coach line) but too many controls at once; the Fix box is greyed-out text.

**[ART]**
- Fits look B: dark, tight fight night; handwritten headers (Lucy's Round, Wins on Points); coach quote set apart.
- Breaks: identical blue holo figure for both fighters on corner and result, so no face and no personality, where S399 chose comic portraits for menus. White fix box with near-invisible grey text ("Fix: Chases the stoppage"); BODY REPORT line almost invisible; small low-contrast helper text throughout. Rope and fighter overlap in 19 and 20, the camera clips the ropes (S347 rule). The cartoon crowd is flat against the dark UI. The booked Home dim overlay looks like a broken state.

## MISSING
1. **A Why screen with one cause and one button** (it exists as a block, but no cause that matches the result and no "set it" action).
2. **A visible plan step in the flow**: no screen between camp and tape shows the plan written or the checklist of what is unfinished (PLAYER_PATH s8 steps 4-5).
3. **A real weigh-in decision** (cut, sauna, miss-weight) - today a read-only confirm.
4. **Fighter faces on the corner and result screens.**
5. **A top-bar flag for the goal talk** (instead of auto-open) and one "Fight prep" entry that shows done/not done.
6. Film study's payoff before the bell (0/3 answered goes into the fight unspoken).

## Top 5 fixes, ranked
1. Make the Why truthful and actionable: reconcile "good plan" with the loss, one named cause, one button that sets the next training/plan change.
2. Put the plan on the path: Accept -> Fight prep page (camp + film + write the plan) with a checklist; tape warns when the plan is empty.
3. Stop self-opening goal talk and de-dupe Home: one fight-prep entry, goal talk as a top-bar flag; remove the dim/toast state.
4. Give weigh-in a real decision or skip it when on weight; fold it into Home.
5. Corner and result art pass: faces instead of identical holos, readable Fix/Body Report text, hide inactive rows, camera inside the ropes, unclip the EVEN ROUND banner.

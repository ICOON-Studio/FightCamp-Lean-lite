# TURNPRO18 - turning pro v18: the matchup decides, the name pays, the bars know the boxer (map + full-size probe) (S543)

Kind: design + probe. Model: claude-opus-5-5 (Code Mode tab). Commit only your paths (`git commit -m "..." -- <files>`), do not
push. Godot only through `python ops/Tools/godot_slot.py run --who TURNPRO18 -- <cmd>` (headless, Dummy audio), ONE run at a
time, output to a file, wait on its done line (a killed waiter leaves Godot running: check by PID). Before each run:
`powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; RED = wait; the owner's game
(ArcheAge) in the top list with memory AMBER = wait. COACHDEEP7 may share the Godot queue.
Estimate: 3 hours. Size the full run to finish in under 45 minutes on one slot (time one cell first), and run the FULL
size (2,000 careers a cell) before any verdict (S542: a 300-career check read a 2,000-career pass as a fail).

## Why
v17 is the owner's design (interview `ops/research/TURNPRO_INTERVIEW_S541.md`, approved rules
`ops/research/TURNPRO17_RULES_S542.md`, Q-S294-320 "Yes, build it"). Its probe passed 6 of 6 at risky purse x1.75
(`docs/TURNPROBE17_RESULT.md`, the S542 addendum on top), but the bar is two critics at 8 on DEPTH and PLAY and the two
critics split: `ops/research/CRITIC_TURNPRO1_V17_BRIEF_KALLI.md` 5/6/6 (code-read) and `..._DOLA.md` 8/9/9 (lines 600-671).
Both lists point the same way. Measured weakness: reading the boxer is worth 2-3% of the score, and a 0.25 change of the
purse multiple flips most picks (x1.5 -> 90% safe, x2 -> 81% risky): the player compares two prices, not two fights.
v18 is ONE round on top of v17: the owner's shape stays (WHEN: the offer, Not yet, three patience marks, the rival gym;
HOW: pro fights 1-6, two bouts side by side; the two bars CONFIDENCE and HUNGER, 0-100). Nothing else of v1-v16 returns.

## The v18 rules (v17 + these; every new number is an ESTIMATE with its real-world reason in the map)
1. THE MATCHUP DECIDES, NOT THE PRICE. Each of the two bouts is a real opponent with a style, a best weapon (public
   tape, as `scripts/state/ProLadder.gd` PUBLIC_TAPE) and one weakness. The promoter still aims the two men (tune-up
   `TUNE_AIM` 0.82 inside `TUNE_READ`, step up `STEP_READ` 0.5) for the boxer on the usual plan; the PRINTED chance is
   then the game's own read of THIS boxer with THIS plan against THIS opponent (`scripts/rules/DebutRead.gd` card ->
   `BoutRead.round_edges` + `CardOdds.result`), no longer squeezed back to the middle of a band. A plan line that answers
   the opponent's tell moves the number; a plan that walks into the weapon lowers it. The card says why in one line
   ("The plan answers the body hook: +6"). The printed number is the number the fight uses. The v17 bands (75-90%, 40-55%)
   are where the promoter aims; the matchup may carry a bout a few points outside. Risky purse stays x1.75.
   MEASURE FIRST (before any career run): for each of the 10 types, the same-rated opponent across every style / weapon /
   weakness the game has (`BoutRead.ANY_WEAK`, `ANY_WEAPON`, the styles `RoundStyle` reads), usual plan v the best plan
   line the boxer can write (`LineGrade`: how well THIS boxer does each line). Print the spread in points. If the game's
   own read moves less than 4 points between the best and the worst plan against a tell for most types, STOP and report
   that as the finding: the matchup cannot decide on today's read, and the next step is the coordinator's.
2. THE NAME PAYS AFTER FIGHT 6. Name from the six fights (tune-up win +1, step up win +3, 0-18) sets where the normal
   booking (`ProLadder._make_offers`, from fight 7) starts: under 6 = unranked reach as today; 6-11 = offers reach five
   places higher; 12 or more = starts inside the ranked band with a step up on the first card. Read what a tier is worth
   from the game's own purses and rounds (`ProLadder` ROUNDS_*, the purse rule it uses), never an invented weight.
3. THE BARS KNOW WHO THE BOXER IS (the two bars stay; their steps scale).
   - HUNGER by ambition (`scripts/rules/Recruit.gd` ambition: potential 78+ chases a title, under 78 wants a steady
     record): a title chaser loses 14 on a tune-up win and gains 12 on a step up; a steady boxer loses 6 and gains 8
     (v17: 10 and 10 for everyone).
   - CONFIDENCE's knockout hit by the confidence trait (`scripts/rules/FighterProfile.gd` TRAITS, shown on the signing
     card as Fragile / Confident by `Recruit`): linear from -40 at trait 35 or less to -20 at trait 65 or more (v17: -30).
     On screen the trait keeps its own words (Fragile, Confident); only the bar is called CONFIDENCE.
   - The card shows the bar's math: "Confidence 66: +1.6 -> 84%".
4. "NOT YET" HAS A REASON. The pop-up prints what four more weeks gives: four weeks of `TrainingPreview.plan_gain` on the
   boxer's current focus fed into the same read (it does not exist today: build it in the greybox; print fight 1's two
   chances now and in four weeks). During a live nationals run (`scripts/state/Champs.gd` active) "Not yet" costs no mark
   and no hunger: the offer waits for the final. A national finalist is called whatever the record (say so; the old
   "only with 0 declines" condition goes with the declines).
5. HUNGER IS FELT IN THE RING AT THE ENDS. Hunger 20 or less = a flat boxer, -3 points; 90 or more = +2. Confidence and
   hunger share ONE cap: together never more than 5 points either way. This rule was held back in v17 as needing the
   owner's yes, so the probe runs it as a SWITCH: every bar is printed with it ON (the design) and OFF (the control arm).
6. CLEAN-UPS from the code read (write each in the map with file and line, read from today's tree, not from memory):
   - Words: TUNE-UP and STEP UP (the booking's own words from fight 7), not SAFE / RISKY. "The boxer", "the opponent";
     no he / she / him / his anywhere in the map's game text.
   - The decline path: `Roster.decline_pro` also moves morale (`ProOfferWire.apply_morale`) and loyalty (`Loyalty` -8),
     and `pro_ready` shuts the door at 3 declines. v18: "Not yet" costs a mark and hunger only; those three go.
   - The hunger clock: fights 1-6 are a fixed 8 weeks apart (`Matchmaking` QUICK_WEEKS / HARD_WEEKS do not apply before
     fight 7) and that gap costs nothing; only extra weeks cost (-5 a full four weeks: the medical rest after a
     stoppage = -10; a "Not yet" is its own -15).
   - The gym's cut is not flat: `Roster.signing_share` drops to the trainer's 10% under loyalty 50. The score reads the
     real share and says so.
   - The two men come from a pair builder over the division's unranked pool by rating (new; `_make_offers` needs a ranked
     name inside the band, which an unranked debutant often lacks). No man inside the step-up band = the card shows the
     tune-up only, with the reason.
   - After fight 6 one page: the record, the name and where the booking now starts, both bars. Then the normal booking.

## Do
1. `ops/research/DESIGN_TURNPRO1_V18.md`: one clean document (not a diff against v17): WHEN, HOW, the two bars, numbers
   with reasons, feedback loops, CUT by file (carry v17 section 6, add the decline-path lines), the menu table (S425:
   pop-up, boxer card, booking of fights 1-6, result line, the after-fight-6 page; what each is wired to), the bars below,
   then the result. Plain game words; names only in headers.
2. Bars, written in the map BEFORE any run, never loosened. Arms: ALWAYS TUNE-UP, ALWAYS STEP UP, ALWAYS WAIT (both
   "Not yet"s, then tune-ups), ALTERNATE, PRICE BOT (picks on printed chance x purse on the usual plan, never touches the
   plan, ignores the bars and the boxer), READER (reads the tell and writes the plan line, reads both bars, the chin,
   the ambition and the name tier in reach; no hidden number).
   - (1)-(6): v17's six bars unchanged (`DESIGN_TURNPRO1_V17.md` section 8), with the new words.
   - (7) The reader's edge is real to a player: the reader beats the best habit by 8% of the score or more in at least 5
     of the 10 types.
   - (8) Not one tuned price: both bouts are each taken in 25% or more of the reader's fights at risky purse x1.5, x1.75
     and x2 (three full runs or one run with three arms; x1.75 is the design).
   - (9) Reading beats pricing: the reader beats the PRICE BOT by more than 2% of the score in at least 5 of 10 types.
   - (10) Waiting is a real call: "Not yet" is in the reader's best line for at least 3 types, and ALWAYS WAIT keeps the
     boxer (under 20% gone) in at least 3 types.
   Print, without a bar: in what share of fights the better bout beats the other by 5% or more of expected score, and
   how often a career's standing after fight 6 differs between the READER and ALWAYS TUNE-UP on the same boxer and dice.
   THE SCORE, written before the run: v17's (gone = 0; 10 a pro win, -5 a loss, 0.2 x (confidence - 50), 1 a $100 of the
   gym's cut) with the name's 2 points each REPLACED by the value of the tier the name buys (rule 2). Parts printed apart.
3. Probe `tools/turnprobe18.gd` + `tools/turnprobe18_rules.gd` (+ `tools/turnprobe18_sum.py`), a GREYBOX: start from
   `tools/turnprobe17.gd` / `tools/turnprobe17_rules.gd` (445 and 146 lines; copy, do not edit them). The read must be the
   GAME's read (the modules named in rule 1), not a formula of your own; the game's numbers are read from its modules,
   never copied by hand. TEN BOXER TYPES that differ in stats (the key is `stats`), techniques, frame, plan, potential
   (both ambitions present) and confidence trait (both ends present); men and women, each against their own sex and
   weight class; opponents differ in style, weapon and weakness; the population named in the output. Each file under 500
   lines. Result `docs/TURNPROBE18_RESULT.md`: verdict first, the bars table (switch ON and OFF), the measure-first
   table, what was tuned (before -> after), honest limits.
4. PASS (all ten, switch ON) -> `ops/research/CRITIC_TURNPRO1_V18_BRIEF.md`: opens with `ops/research/CRITIC_PACK.md` and
   `ops/research/CRITIC_ACCESS.md`; gives the game and the v18 rules and the probe's numbers, never an earlier score, an
   earlier critic's words or our opinion; asks DEPTH and PLAY out of 10 (the bar is 8 on both), which options are missing
   or useless and what each changes, the list of changes to reach 10 (most important first), and the critic's own 10/10
   drawn as a 1920x1080 HTML page. Queue it for kalli and dola: `python ops/Tools/seat_queue.py add --seat <seat> --brief
   research/CRITIC_TURNPRO1_V18_BRIEF.md`. Write in the result that a code-checked critic is still owed (the coordinator
   launches it).
   FAIL -> which bar, the one change that would fix it, stop. No second design round in this task.
Nothing under scripts/ or tests/ changes in this task: the build comes after the critics and the owner's play.
The probe may tune a number (before -> after in the map). It may not add a rule, a bar on the boxer or a choice.

## Feedback loops
- Plan -> chance: one way (the plan is the player's; nothing in this mechanic writes the plan back). Cap: print the largest
  shift the plan makes for any type; over 10 points = stop and say so.
- Confidence -> chance -> wins -> confidence, and knockout loss -> confidence -> chance -> loss: as v17. Cap: the SHARED 5
  points with hunger; the bar stops at 0 and 100. Trial check: fight 6's printed chance is within 5 points of the same
  bout with both bars neutral (confidence 50, hunger 21-89). Print the longest losing run.
- Hunger -> chance (new): tune-up wins lower hunger -> a flat boxer (-3) -> a loss, and a tune-up loss moves nothing, so
  it stops itself; step ups raise hunger -> +2 -> more wins -> hunger stays high. Cap: +2 at most, inside the shared 5;
  the bar stops at 100. Print hunger after each of fights 1-6 per arm and how many careers sit at 90+ after fight 6.
- Hunger -> leaves: a one-way sink fed back only by the player's picks. Ambition only scales the steps: a fixed trait.
- Name -> the booking's start: read only after fight 6; it never changes a fight 1-6 offer. Say so.
- Four more weeks -> stats -> chance: one way; "Not yet" is capped by the three marks.
- Purse -> cash: no rule here reads cash back.
- ONE-REP TRIAL FIRST: one career per type per arm, printed in full, before the sized run. STOP and fix the map if a bar
  leaves 0-100, if every type converges on the same best arm, if any arm never loses a fight, or if the plan's shift is
  the same number for every opponent (the matchup is then not being read).

## Prior research
`ops/research/topics/career_booking.md` and `ops/research/topics/plans_corner.md` (canonical pages),
`ops/research/TURNPRO_INTERVIEW_S541.md` (the spec), `ops/research/TURNPRO17_RULES_S542.md`,
`ops/research/DESIGN_TURNPRO1_V17.md`, `docs/TURNPROBE17_RESULT.md`, both v17 critic answers (above),
`docs/TURNPROBE16_RESULT.md` ("the honest card solves the decision"), `ops/research/DEPTH_AUDIT_S534.md`. Run `python
ops/Tools/prior_research.py pro debut matchmaking prospect` and name the real-world source behind each new number.

## What would a human do?
A manager does not pick a debutant's opponents by the purse: he asks "does this man's style suit mine?" A slick southpaw
is a bad night for a come-forward novice at any price; a slow puncher who fades is a showcase. He takes the step up when
the matchup is right, and he keeps a hungry prospect busy with real fights and a steady one earning.

## Prefab check
None (a rules probe on our own modules).

## Contract
OWNS: ops/research/DESIGN_TURNPRO1_V18.md, tools/turnprobe18.gd, tools/turnprobe18_rules.gd, tools/turnprobe18_sum.py, docs/TURNPROBE18_RESULT.md, ops/research/CRITIC_TURNPRO1_V18_BRIEF.md
RED_TEST: tools/turnprobe18.gd
REGRESSION: none
VISUAL: none

Do not ask questions: decide, and write what you decided in the result.

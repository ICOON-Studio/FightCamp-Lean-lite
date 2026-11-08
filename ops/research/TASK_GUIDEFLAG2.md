# TASK GUIDEFLAG2 - QWEN (qwen3-coder) - round 2: the guide must end, without breaking the first fight

Status: OPEN (S402, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: ops/research/S400_REVIEW/CORNER_KING_REFINED_S401.md, the rule-breaks list, items 2 and 5. Defect fixes on today's screens: no layout or design change.

## Round 2 (S402, Claude): why round 1 was not merged
Branch qwen/guideflag1 ends the guide at week 1, and that breaks the first fight: first_week_test and first_hour_walk_test go red (2 failures each). They are right: after week 1 the guide hands to "offer", and after the first fight to "club". Do not change those tests.
The flag change in Needs.gd is good: keep it.
New rule, replacing rule 1 below: keep every hand-off as on main (restore FirstWeek.gd's week-1 "offer" step and its clearing). The guide ends when its last step, "club", is done, and in any case for good at the end of week 8, however far it got. Sync clears a stale guide past week 8 on an old save. guide_ends_test changes to match: a career at week 20 has guide == "" and no strip; a career inside the first fight keeps it.

## Contract
OWNS: scripts/rules/FirstWeek.gd, scripts/ui/Shell.gd:78-84, scripts/state/Needs.gd:66-69, tests/guide_ends_test.gd
BASE: qwen/guideflag1
RED_TEST: tests/first_week_test.gd -> FIRST_WEEK failures=0
REGRESSION: first_week_test, first_hour_walk_test, golden_path_test, test_jump_test, plain_words_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py guide strip first week`. The operator's standing rule (S398): nothing on screen unless the player can act on it. STRUCTURE_CRITIC_FIGHTPATH.md: the guide strip repeats the fight prep task on a booked Home.

## What would a human do?
Follow the guide through the first week, then never see it again. Read a flag and know at once what to do, without the sentence being cut off.

## Prefab check
None needed.

## How it works today (read these first)
- scripts/ui/Shell.gd refresh(): adds FirstWeekStrip whenever `main.career.guide != ""`, on every page.
- scripts/rules/FirstWeek.gd holds the stages and sync(). Find out why `guide` is still set at week 20: that is the defect, and FirstWeekStrip's texts ("First week 1/2/3/4", "Three jobs for the club, in any order.") still show then.
- scripts/state/Needs.gd line ~68 builds the flag: "Answer a bout offer: <full name> vs <opponent>". HomeNeeds.gd trims it with an ellipsis at the row's width.

## The rule
1. The guide runs through the first week exactly as it does today, on the pages it uses today (first_week_test must stay green unchanged). Once the first week is over, `career.guide` is empty for good and no strip shows on any page. A saved career that already carries a stale guide past week 1 also loses it on load or at the next sync.
2. The flag's title becomes short enough not to be cut: "Answer <first name>'s bout offer". The opponent's name moves to the start of the flag's second line, before "expires <date>". The flag still opens the offer.

## Do
1. tests/guide_ends_test.gd FIRST (prints `GUIDE_ENDS failures=<n>`). Run it on main: it must fail. It covers: a new career has a guide during week 1; a career played or jumped past week 2 has `guide == ""` and no node named FirstWeekStrip; a career with a stale guide at week 20 clears on sync; the offer flag's title is under 34 characters and holds the first name; its second line holds the opponent's name; its act is still openBout.
2. Make it pass inside OWNS. Under 500 lines per file.
3. Run REGRESSION. Do not change any number or threshold in an existing test. If one goes red, stop and put what you measured in the PR body.

## Rules for this seat
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- ...`, headless, `--audio-driver Dummy`. Parse check before any test. No screens opened. Nothing outside OWNS. PR body: `RESULT: tests/guide_ends_test.gd -> GUIDE_ENDS failures=0`.

## The one trap
Two guides share these texts: the first-week steps and the first-fight steps of the first hour. Do not end the first hour's own booked show early: first_hour_walk_test is the check. Test real careers built with main.act("quick"), not a bare Career.new().

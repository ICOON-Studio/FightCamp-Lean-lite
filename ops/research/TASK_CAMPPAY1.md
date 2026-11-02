# TASK CAMPPAY1 (S222) - "the camp pays nothing visible" (S172 review finding 1, CRITICAL): measure it, then show it

You are the FightCamp coding seat (Grok Dev). Repo ICOON-Studio/FightCamp, pull master. Branch grok/camppay1, push, open a PR into master,
never merge. Parse gate first (python Godot/tools/check_scripts.py <touched .gd>); run_tests.py --jobs 2 max. Never delete or loosen a test.
GameState.gd is 20,000+ lines - grep, never read whole. Source: research/DEMO_DESIGN_REVIEW_S172.md finding 1 (read it whole).

## Step 1 - is the camp REAL? (measurement, no UI yet)
Two arms, two DIFFERENT boxers (house rule: never identical fighters), same opponent pool, same seeds: arm A runs a fight camp before the
bout (the game's own camp API - grep start_camp / camp_), arm B books the same kind of bout with no camp. Compare over >= 30 seeded bouts per
arm: win rate, landed %, the drilled punch's landed %, fatigue late. Report the numbers + CI in the PR. If the camp changes nothing, find
why (camp and week programme not talking? "nobody trained" while a camp runs?) and fix THAT first.

## Step 2 - show what the camp bought
Fight week and the result must say it in one line each, from the measured effect: e.g. fight week "Camp: jab drilled - lands ~40% vs ~32%
without"; result "Your camp's jab landed 18 of 41". A running camp counts as training in the week review. New behaviour ships ON
(GameSwitches.GAME_ON - operator rule); plain --script tests stay the OFF arm.

## Acceptance - NEW tests/camp_pays_test.gd
(a) the camp arm beats the no-camp arm on the drilled punch's landed % with non-overlapping CIs (if not, the PR says why and what it
fixed); (b) the fight-week and result lines exist and quote numbers from the same bout; (c) a week with a running camp is not reported as
"nobody trained". Report everything in the PR body. Claude takes the game-camera stills.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md, screen form - added S223 at collect)
1. The defect must first read RED on master's shipped screen (a still of the screen as the game shows it, `-- as_game`).
2. Stills of the changed screen at 1920x1080 and 1280x720 from the game's own flow (no isolated widget renders).
3. For every still report: overlaps, clipped text, the changed element's position, what the player reads.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.

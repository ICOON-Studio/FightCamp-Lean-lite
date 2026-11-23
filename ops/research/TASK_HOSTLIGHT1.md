# HOSTLIGHT1 - the club show as a light money night: the hall read + two reserves, built and wired (S541)

Kind: build. Model: claude-opus-5-5 (Code Mode tab). Commit only your paths (`git commit -- <files>`) and push them.
Godot only through `python ops/Tools/godot_slot.py run --who HOSTLIGHT1 -- <cmd>` (headless, Dummy audio), one run at a time.

## The owner's answer
Five club show probes failed (HOSTPROBE5: 6 of 9, third fail in a row; the card's routes differ by a few hundred dollars).
Board Q-S294-318 "Keep it as a light money night and cut the matchmaking card?" -> **"Yes, light night"** (S541).
The five-route card (above / favour / promise / below / wait, the late no, the weighed pro call) was never built in the game
(probe tools only) - it is CUT: nothing of it enters scripts/. HOSTSHOW1 maps v4-v8 stay as research.

## Do
Today (scripts/rules/ClubShow.gd, scripts/state/GymSpend.gd:338-376): one row on Club > Money, one hall (HALL 400, COST $3,500),
HomeBout main event (S488). Add only:
1. TWO HALLS AS A READ, ONE CLICK: Community hall (250 seats, rent $1,000) and Town hall (400 seats, rent $2,000), numbers from
   `ops/research/DESIGN_HOSTSHOW1_V8.md` 4.2 (reach on the club part: Community x1.0, Town 0.6 + 0.01 x reputation, 0.6-1.25;
   full 85%+ = +4 / +6 rep, half-empty under 50% = -3 / -4 rep). The row names the hall that pays on the club's EXPECTED night
   (five lucks across ClubShow.LUCK) and books it on one click: "Your club fills Community hall: likely +$2,300. Town hall would be
   half-empty: likely -$900". Within $300: "Close - your call" and two buttons. Pure rule in ClubShow.gd (+ unit test).
2. TWO STANDBY RESERVES BY DEFAULT ($40 each, 4.8 of the v8 map) against the game's own pull-out rate: a pull-out on the night is
   filled by a reserve, so the night's sheet never shows a short card while a reserve is unused. No toggle.
3. The night's sheet after the show (seats, net, reputation from full / half-empty) in the existing result message.
Wired and shown (owner S425): the Club > Money row, its hover (what the hall read means, not the label), the result line.
New feature ships ON (GameSwitches.GAME_ON). One golden-path step books a show and reads the hall line.

## Feedback loops
- Members -> turnout -> net + new members -> members: the loop the built show already has (ClubShow.draw: 0.7 a member). Cap:
  HALL seats and EVERY_DAYS (16 weeks); say in the commit whether the bigger hall raises the members it can add per show and keep
  it bounded (no more than today's members-per-show at Community).
- Reputation -> Town reach -> full house -> +6 rep -> reach: cap = the reach clamp 1.25 and the 16-week spacing.
- ONE-REP TRIAL FIRST: a 2-game-year headless run of a grown club booking every show: members and reputation must not run away
  (print both per show); stop and fix before the tests if they do.

## Prior research
DESIGN_HOSTSHOW1_V8.md (4.2 hall, 4.8 reserves), docs/HOSTPROBE5_RESULT.md s7 (the light-night recommendation), ClubShow.gd,
GymSpend.gd, HomeBout (S488).

## What would a human do?
A club secretary books the hall the club can fill, keeps two lads on standby for the night, and counts the takings after.

## Prefab check
None (our own rules).

## Contract
OWNS: scripts/rules/ClubShow.gd, scripts/state/GymSpend.gd, tests/club_show_test.gd, tests/golden_path_test.gd
RED_TEST: tests/club_show_test.gd
REGRESSION: tests/golden_path_test.gd
VISUAL: the Club > Money show row with the hall line, rendered on the hidden desktop and opened

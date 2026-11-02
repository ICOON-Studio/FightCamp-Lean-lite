# TASK C243 - a bookable first fight for every fighter the player can sign (PLAYTEST S144 P32, CRITICAL)
Model: gpt-6-luna, medium. Owner: Codex (next free seat). Worktree `E:/FightCamp/wt/C243`, branch `codex/c243-fight-for-every-fighter`.

## The defect (from the cold playtest, PLAYTEST_S144_PASS1.md)
Empty-gym career (London, UK), signed Isabel Anders (F, boxing, middleweight, 0-0-0). 6 in-game weeks: offers desk 0 every week
("NO AMATEUR CARD IN THIS DIVISION THIS WEEK"), world cards 161 / 0 bookable. Causes found in code:
- `GameState.get_fight_offers()` (~line 7837) generates one offer per tier per roster weight class with an opponent drawn from
  `ROSTER_FIRST_NAMES` (line 206, all male) - "a generated man" (S65 comment). The same-sex rule (operator: females never fight
  males) then blocks every one for a woman. These pro offers are also hidden while the roster is amateur
  (ScheduleHubPanel.gd ~1085 "pro offers stay hidden while your fighters are amateurs").
- The amateur board (`get_amateur_bouts` ~8777, `get_amateur_bout_offer` ~8671, the federation calendar) never produced a
  women's middleweight card in 6 weeks. On day 1, 9 of the 12 UK prospects are women.
- Meanwhile Home, the Fights badge and the Office say "3 offers waiting" (they count the hidden male pro offers).

## Do
1. Generated offers are SEX-AWARE: group the roster by (weight class, sex); a female member's offers have female opponents
   (add a female first-name list beside ROSTER_FIRST_NAMES; keep every male offer's rng stream byte-identical - draw the female
   ones from their own seed string so no existing offer field moves).
2. The amateur calendar gives every (division, sex) that the player's roster holds a card within 2-3 weeks (realistic: club
   shows run women's bouts; a novice gets a bout within weeks). Read how the calendar is built before changing it; keep it
   seeded/deterministic.
3. Honest counts: the "N offers waiting" on Home / Fights badge / Office counts only offers the player can actually take now.
Never remove the same-sex rule or any ruleset rule (CLAUDE.md s5: a fighter is legal for his ruleset).

## Acceptance (one new test, blind to the implementation)
`tests/first_fight_for_every_fighter_test.gd`: a new empty-gym career (as the game does: GameState.empty_gym_start() is false
under --script, so build the empty roster yourself - clear roster/staff after finalize_new_career), sign a 0-0 FEMALE boxer and,
in a second career, a 0-0 MALE boxer from the scouting pool; advance weeks with the real week tick; each has >= 1 bookable bout
(book_fight returns ok) within 3 weeks; every offer for her names a female opponent; the offer count Home shows equals the
bookable count. Mutant: revert step 1 -> the female arm must fail. Population: name both fighters (sex, class, record) in output.

## Owned files
`Godot/scripts/GameState.gd` (17,956 lines - NEVER read whole: sed -n windows at 200-215, 7837-7905, 8660-8800, the amateur
calendar functions you find by grep), `Godot/scripts/ScheduleHubPanel.gd` (3,477 lines, ~1070-1110 offers lead), the home/office
count source (grep "offers waiting"). New: the test.

## Gates
Parse: `python Godot/tools/check_scripts.py <touched .gd>`. The test: `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot
--script tests/first_fight_for_every_fighter_test.gd`. Then `python Godot/tools/run_tests.py --only booking,offer,amateur,fight_gate,career,contract --jobs 2`.
Watchdog -Once before every Godot run (RED = 84 C sustained 10 s; AMBER passes); one Godot at a time; if RED wait, never quit.

## Prior research
PLAYTEST_S144_PASS1.md (the evidence); G98_AMATEUR_POPULATION.md (real amateur scenes, novice classes, registrations).

## What would a human do?
Make sure the first thing a new manager can do after signing anyone is book them a small fight.

## Prefab check
n/a (our own matchmaking).

## The one trap
A male-only rng stream that moves breaks every existing seeded test and save - draw the women's offers from their own seed.
Never open a viewer or window. Never edit HANDOFF.md. git add by explicit path, commit, push -u origin codex/c243-fight-for-every-fighter.

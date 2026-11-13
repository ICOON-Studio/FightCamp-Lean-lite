# TASK OFFICE1 - GROK DEV - the club office as a full-screen computer desktop (screen 1 of 7: the frame + Desktop)

Status: OPEN (S450, Claude main). Discipline: boxing (demo). Model: Grok Dev (own Linux box, Godot 4.7.2).
Mechanic: the office computer, operator Q-S294-210 "Yes, that order" (2nd after the fight week) and Q-S294-213 "A, full screen".
Spec: docs/mockups/s449/office/office_a.png (THE PICTURE - its structure, words and layout are the spec) + office_a.html (the same as
HTML, sizes in px) + ops/research/OFFICE_BOOKING_S448.md sections 1-2. Later tasks bring Mail, Schedule, Fighters, Staff into the
frame one by one; THIS task builds the frame and the Desktop app only.

## Contract
OWNS: scripts/ui/areas/Office.gd (new, under 400 lines), scripts/ui/OfficeDesk.gd (new, pure read of the Career for the desktop's
rows, under 300 lines), scenes/areas/Office.tscn (new), scripts/ui/Shell.gd:12-19 (AREA_SCENES: add "office"),
scripts/ui/GymHub.gd:134-135 (the "office" pin opens the new area), scripts/ui/Routes.gd (the "office" area's tabs only),
tests/office_desk_test.gd (new), tests/office_screen_test.gd (new)
RED_TEST: tests/office_desk_test.gd -> OFFICE_DESK failures=0
REGRESSION: golden_path_test, first_week_test, words_on_screens_test, no_pronoun_test, file_limits_test, hover_label_test, pulse_test, home_look_test
VISUAL: yes - Claude renders the real screen on the PC (tools/layout_snapshot.gd on the hidden desktop) and puts it on the review board; the operator closes it
NOT YOURS: every other file (Money.gd, Fights.gd, Fighters.gd, Needs.gd, HomeNeeds.gd, GymBills.gd, CoachCheck.gd: read and CALL them,
never edit). Never edit scripts/rules or scripts/state: the office only READS the career.

## What to build
1. A new area "office" (Shell.AREA_SCENES, scenes/areas/Office.tscn -> scripts/ui/areas/Office.gd). The hub's "Club office" pin
   (GymHub._go "office") opens it instead of the Money page. Full screen inside the game shell, as the picture: a dark desktop with
   the gym photo dimmed behind, the club name + date + week + cash in its own top line, a left column of 7 app buttons
   (Desktop, Mail, Schedule, Fighters, Staff, Finance, Records; Lucide-style icons from KitIcon where one exists), unread badges on
   Mail (news unread count) and Fighters (fighters with a red flag).
2. Until their own tasks land, the app buttons open the existing pages: Mail -> the news list the game already has (Home's news, or
   leave Mail as the Desktop's mail panel scrolled, your call - say which), Schedule -> area fights, Fighters -> area fighters,
   Staff -> money tab 1 (People), Finance -> money tab 0, Records -> money tab 2. Desktop is this task.
3. THE DESKTOP (the picture's window "THIS WEEK AT THE CLUB"), five panels, every number from the career (no stand-in numbers):
   - NEEDS YOU: the three most urgent from HomeNeeds.ranked(c) / Needs.needs(c), each with its icon, a one-line reason and ONE
     button that does the thing (the same action Home's note runs). Only the FIRST (the decision due first) pulses
     (the game's Pulse); the others are plain. (Operator S442: one pulsing critical button a screen.)
   - NEXT FOUR WEEKS: a Mon-Sun calendar from today's week, 4 rows. Chips: a booked bout (red, "Bout: <class word>"), the 7 days
     before it ("fight week", gold), an offer's last day ("offer ends"), rent day and dues day and the England Boxing fee day
     (GymBills), the hosted show if any. Today's cell outlined. Read the same data Fights._calendar reads.
   - MAIL: the 3 newest news items, unread first, sender in bold, one line each.
   - FIGHTERS: one card per fighter (four at the start): class + kg chip, the CoachCheck flag word (Offer / Sharp / Mood low /
     Building ...), the portrait the roster uses, rank line ("#4 regional, 6-2" or the belt for the BJJ fighter), Stamina and Mood
     bars with the numbers, and "Next:" (offer open / bout in n days / no bout booked / open mat date). Clicking a card opens that
     fighter's page. NAMES ONLY IN HEADERS (operator S448): the card shows no name in its rows; the class chip is the card's header.
   - MONEY 8 WEEKS AHEAD: cash now, a line chart of the 8 weeks' cash (GymBills.week per week, the same projection the Money page
     uses - find it, do not invent one), the $0 line dashed, and three rows: dues this month, ticket cuts, rent + coaches + stipends.
   - STAFF strip: the head coach (you) and each coach by ROLE (never a bare surname, S431), pad nights used of their total this week,
     their weekly pay; an empty slot reads what can fill it.
   - The foot line: "Click an app or any card to open it. The one pulsing button is the decision due first."
4. Fonts and sizes as the picture (titles in the game's display font, numbers tabular); every panel's title has its small grey
   sub-line. Hovering any number shows where it comes from (HoverLabel), the game's rule for secondary info.

## The tests (red on main first: the files do not exist)
tests/office_desk_test.gd (pure, OfficeDesk.gd on Career.quick_start()): the needs are at most 3, ranked as HomeNeeds.ranked; the
calendar has 28 days starting on today's Monday and puts a booked bout and its fight week on the right days (book one in the test);
money_ahead returns 8 weeks whose first equals the Money page's next-week projection; fighter cards = c.fighters.size() and carry no
fighter name in any row field; staff rows name roles, never surnames. Prints `OFFICE_DESK failures=<n>`.
tests/office_screen_test.gd (headless UI, the pattern of tests/home_look_test.gd): the hub's office pin opens area "office"; the 7 app
buttons exist with their labels; exactly ONE pulsing control on the desktop; each app button routes as section 2. Prints
`OFFICE_SCREEN failures=<n>`.

## Traps
- Read ops/research/GDSCRIPT_TRAPS.md first (Variant `:=`, Label sizing, `%%`).
- Godot headless only, the plain binary; Dummy audio. Nothing opens on any screen.
- No he / she in game strings (no_pronoun_test); the words test (words_on_screens_test) reads every label: game words, not jargon
  ("Stamina", "Cardio", never "Cond" or "Engine").
- Files under 500 lines. Do not delete or weaken any test. Push grok/office1, open the PR, never merge.

## Prior research
- OFFICE_BOOKING_S448.md (what the game already has for each app), ops/research/OFFICE_HUB_K12.html and OFFICE_K12_*.png (an older
  office concept: for reference only, the S449 picture wins), JOHN_OFFICEPC3_S248.md.

## What would a human do?
A club secretary opens the laptop on Monday: what needs answering, what is on this month, who is fit, will the money last. One look,
one click to the thing.

## Prefab check
None: every number already exists in the career; this is a new view on it (Football Manager's inbox + calendar desktop is the genre's
shape).

Test command: `<godot> --headless --audio-driver Dummy --path . --script res://tests/office_desk_test.gd` and the same for
tests/office_screen_test.gd.
RESULT lines for the PR body: `RESULT: tests/office_desk_test.gd -> OFFICE_DESK failures=0`,
`RESULT: tests/office_screen_test.gd -> OFFICE_SCREEN failures=0`, plus one per REGRESSION test.

# CLAUDE LAND NOTE — J54 (menu architecture survey)

- **Land as:** `research/J54_MENU_ARCHITECTURE_SURVEY.md` (copy of `/workspace/j54/J54_MENU_ARCHITECTURE_SURVEY.md`, unchanged).
- **Scope:** RESEARCH ONLY. No code changes. **Do not edit HANDOFF.** This lands a memo only.
- **Date:** 2026-09-25. Trigger: operator asked to reorganise all menus, "I don't understand what ... is the day", and to decide the main menu from a survey.

## Headline IA (JUDGEMENT on sourced survey)
- **Title screen:** `RESUME CAREER` (only if a save exists) · `NEW CAREER` · `LOAD CAREER` · `SETTINGS` · `QUIT`. The guided first month (J52) is a toggle on the last creation step, on by default.
- **THE DAY → `HOME`.** THE DAY is a time word, not a place or a job. It clashes with CONTINUE, and none of 11 surveyed games names its hub after time. The hub names found were Inbox, Home, Portal, Manager's Office, Main Screen/Office and Career Hub.
- **HOME contents:** `NEEDS YOU` (max 5 rows, blockers red, first) · `NEXT UP` (dated event + countdown, hosts `ENTER FIGHT WEEK`) · `YOUR FIGHTERS` · `MONEY THIS WEEK` · `NEWS & MAIL` (collapsed). This follows the OOTP Manager's Office "task organizer" pattern.
- **Rail (5):** `HOME` · `FIGHTERS` (Roster, Training, Fight Camps, Scouting) · `FIGHTS` (Offers, Calendar, Results, Rankings) · `GYM` (Facilities, Members, Staff) · `MONEY` (Overview, Income, Bills, Sponsors). Save/Load/Settings go to a gear icon.
- **Fold:** THE DAY→HOME · GYM→GYM · STAFF→GYM›Staff · TRAINING→FIGHTERS›Training/Fight Camps · SCHEDULE→FIGHTS›Calendar(+Offers) · SCOUTING→FIGHTERS›Scouting (opponent reports on the bout page) · RANKINGS→FIGHTS›Rankings · OFFICE→MONEY (mail→HOME, system→gear).
- **Time control:** one green `CONTINUE` at bottom right that never moves. It runs day by day until the next stop (blocker, camp milestone, weigh-in, fight day, 1st of month). The sub-line names the stop. When blocked, the label becomes `NEEDS YOU (n)` and jumps to the first blocker. On fight day it becomes `GO TO FIGHT NIGHT`. Space = CONTINUE. Precedents: FM24 Continue label change, Motorsport Manager blocking emails, OOTP Game Flow.

## Key counts
- Boot → first bout: **~21 clicks** quick path, **~24** with the guided month (PROXY). For comparison, FM24 takes 4 clicks from the start screen to the hub (SOURCED). No game publishes a first-match count (NOT FOUND).
- Rail: **8 → 5** items, nothing deleted, every old screen ≤ 2 clicks away.
- FM26 Steam reviews: **25 of 7,113** English reviews sampled mention "portal" (COUNT). SI's studio director admitted on 2026-05-11 that "many were frustrated by the changes to navigation".

## Before implementing
- Check what today's SCOUTING (talent or opponents) and OFFICE screens actually contain. The code was not inspected in J54.
- Update J52 tutorial step text to the new labels (HOME, FIGHTS › Offers, FIGHTERS › Fight Camps).

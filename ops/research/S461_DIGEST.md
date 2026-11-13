# S461 digest (2026-11-13) - INTEGRATE1: the towel, the plan grade, the coach's read in; three probes briefed

Operator in session: "how many sessions approximately until mechanics are in ?"; "mechanics first is the right order, how pro game
studios do it ?"; "Greybox mechanics go on existing screens first, with the final menus locked afterward. do that , we kind of doing
this now ?" (answered: yes, that is INTEGRATE1's rule).

## Wired this session (each with a test that plays it)
- #4 TOWEL (TowelWire.gd, new): Towel's state after every round (m.towel); the corner card on BOTH corners (TowelStrip.gd: 2D
  FightNight and the 3D CornerOverlay); "|towel=pull|box_safe|one_more" on the corner action. Pull = RTD (a loss), 14 days out, morale
  -4, loyalty logged (Loyalty.commit), no injury roll (Injuries skips RTD). Box safe = the next round on Hands up at Save pace
  (PlanFile.pace_for reads bout.towel_safe). SKIP BOUT = the coach pulls at the line by himself. The line (Careful 12 / Normal 20 /
  Brave 33 in 100) on Fight prep's camp card. towel_wire_test (6 checks + controls).
  TRAP FOUND AND FIXED: an empty corner call ("corner:" = the plan's default) opened no round -> plan_file_test hung 10 min. The round
  now opens unless stopped(m); towel_wire_test check 2 guards it.
- #2 LINEGRADE: GRADE1 (Qwen) collected by hand (BoutRead merged beside S460's PlanPhase line); arm H Good 1.15 / OK 0.99 / Poor 0.90.
  The grade word + its two attributes on every plan line (GamePlanRows.grade_tag). grade_wire_test.
  DESIGN CALL: fight_why's good-plan bar 9 in 10 -> 2 in 3 (FIRELEVEL3 fires Usable lines half the time; 375/540 now); the bad-plan
  bar is unchanged. Reason written in the test.
- #8 TRAINREAD: the roster Coach cell, when every check is green, says the coach's read (what to build next + the session; the sums
  on hover; no names) - RosterRow.green_cell. train_wire_test.
- result_defects_test point 2 TRACED: its fixture plan (1-2, 1-2-3) never fired since S450 (combos at 0 < Usable 30), so the Why had
  no line to replace. tools/result_dump.gd gives the plan's combos at Sharp. result_tabs_test then needs a look (see below).

## Probes (seat work, measured before wiring)
- READ1 (Antigravity) DONE but its result page was NOT reproducible: Claude's rerun of the same probe gave A 29.3% (page: 44.8%) and
  the probe's own line pass=no. docs/READ1_RESULT.md rewritten from the rerun: READ_EDGE = 6 passes the map's wording (careless -5.8,
  plan changed 0); a split or feint covers only part (2.5 / 3.3 lost) - a design-loop finding. LESSON: rerun a seat's probe before
  trusting its page (a perfectly linear table was the tell).
- LOYAL1 (SHORTWEEK1 + LOYAL1) briefed, queued on Qwen: Loyalty + ClubDeal wire together after it.
- KNOWBOTS1 briefed, queued on Antigravity: Knowledge's bots test (reader vs blind vs bad signer, 60 worlds) before wiring.
- CoachMarket waits COACHFIT1 (coach design at the critics); TellWorth waits LEVERS1.

## Open at the end
- plan_bout_test RED on main BEFORE S461 (control on 3d0cc9b3 code: branch arrows thrown 1 time in 80 bouts) - not traced; suspect a
  fixture whose combos never fire since S450 (as result_defects 2 was).
- result_tabs_test: DONE - re-pinned to FixLab's rule (a full plan replaces a never-fired line; none when all fired); green.

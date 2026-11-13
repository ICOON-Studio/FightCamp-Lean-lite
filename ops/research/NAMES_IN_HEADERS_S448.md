# Names only in headers (S448)

Operator (S448): "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule".

Decision: below the header the text says the ROLE, never the name and never she/her - "your boxer" / "your fighter"
(BJJ) / "the opponent" / "your coach"; side-by-side numbers say "yours / theirs" or use the corner colour. Pronouns
were not used: the S354 rule ("use names or do not use it if it is not necessary") and `tests/no_pronoun_test.gd`
forbid she/her in game text, so roles satisfy both rules.

Grep (`["name"]`, `.get("name"`, `names[`, `["first"]`, `first_name`) over scripts/ui, fight3d, rules (+ the fight-text
paths in state/BoutNight and state/RingDuel): 523 + ~170 `first` hits. Most are moves, sessions, items, sponsors, opens or
data keys (not people). About 230 name a person: ~150 rewritten, ~80 kept as headers or list rows.

## KEPT (header, name plate, versus line, list row, notification)
- Page/card titles and plates: AreaHead, FighterPage/GrapplerPage/Fighters display names, Camp "X VS Y, date", ProOffer
  "TURN X PRO?", GoalTalk, Trial/Interview name, FightNight "X'S ROUND", FightView bell banner, CornerStats.head,
  ResultCause/ResultTabs panel titles ("WHAT IT COST X", "THE PLAN X WALKED OUT WITH"), MatchStats "X'S GAME",
  GamePlan "WHAT THE TAPE FOUND ON X", ComboBuilder/ComboStrip "vs X", Playbook/MatMap "X'S MOVES/GAME", RecruitPanel
  "WHO X IS", WeekTwist ask titles ("X asks for a day off"), Headline.title, NationalsView card title.
- Versus pictures and corner plates: VersusPanel, TapeVersus, HeadlineCard, FightPoster, HomeMatch, TapeCard, HudBars
  name plates, CornerRest/CornerOverlay column heads, FightCast ring-announcer intros, DrillTray/MatTree opponent chips.
- "vs X, date" booked lines (Fighters, Fights, FighterTile, RosterTable/RosterCards next column, HomeRows, HomeCorners).
- Rows whose row IS the person: roster/find-a-fighter/staff/rankings/ladder rows, Fights.next_offer_line (one line per
  fighter), RosterTable flag chips, StaffCard boxer lines, ProFights pro summary + ranking rows, MatOpens.link row.
- Cross-roster notifications: toasts (BoutActs, RosterActs, Main, ComboBuilder, TapeRoom, StrikeBrowser), news
  (DrillWeek, Region, Roster, FirstWeek, StripeCall line/news), Home events, Fixtures, CashForecast, Needs.
- Guide strip (FirstWeekStrip, GuideLines, FirstHour): it speaks across screens, no header names the person. UNSURE.

## REWRITTEN (old -> new)
- fight3d/RoundBoard.gd:96 `"%s  head %d  body %d" % [me, ...]` x2 -> red "YOURS  head 4  body 1" / blue "THEIRS ...".
- fight3d/CornerRest.gd:60 "LUCY FRESHER" -> "YOUR BOXER FRESHER" / "OPPONENT FRESHER".
- fight3d/FightHud.gd:104 "MARIA LEADS 1-0" -> "OPPONENT LEADS 1-0" / "YOUR BOXER LEADS".
- fight3d/HudBars.gd:213/215 "LUCY IS WINNING THIS ROUND", tooltip with names -> "YOUR BOXER/THE OPPONENT IS WINNING...".
- fight3d/FightCalls.gd:125 call strip name -> "YOUR BOXER" / "OPPONENT" (colour says the corner).
- fight3d/ReactionBubbles.gd:66 "exchange to Priya" -> "exchange to your boxer / the opponent".
- fight3d/ExchangeBeats.gd:91,139,294 set-up / read captions, habit captions -> roles.
- fight3d/ShoutBar.gd:53,114 "WHAT DO YOU SHOUT TO X?" -> "WHAT DO YOU SHOUT?"; shout note -> "Your boxer takes in...".
- fight3d/CornerBar.gd:305 _opp -> "the opponent".
- rules/Exchanges.gd named()/verdict(): {her}/{opp} -> "your boxer"/"the opponent" (capitalised at a sentence start);
  every call tooltip, clue, grade line and the 30-second verdicts.
- rules/CornerCard.gd:67-81 worked/hurt/why -> "Your boxer landed...", "The opponent landed...", "Keep the opponent...".
- rules/HabitFix.gd line()/result(), rules/ClinchRest.gd line(), state/RingDuel.gd duel/round/perk lines,
  rules/ComboWords.gd ring captions, rules/RoundScript.gd call captions, state/BoutNight.gd + rules/FightWords.gd round
  lines, rules/CallEvidence.gd evidence lines, rules/FightWhy.gd read(), rules/Judges.gd reasons, rules/PlanFight.gd
  arrow line, rules/BjjClash.gd reasons -> roles.
- rules/RankLine.gd "Passed Lucy and Maria." -> "Passed 2 boxers." (the ladder lists them).
- ui/CallButtons.gd, ui/CornerJobsRow.gd, ui/modals/FightNight.gd (punches landed, energy rows, level line, corner
  question, skipped-round lines), ui/ResultPage.gd, ui/ResultCause.gd, ui/ResultTabs.gd, ui/MatchStats.gd,
  ui/JudgeCards.gd -> roles / "yours, theirs".
- ui/BoutCompare.gd legend "Lucy" / "Priya, estimate" -> "Yours" / "Theirs, estimate"; rank rows "Yours now", "Theirs";
  tape/wins lines and chip tooltips -> "the opponent".
- ui/areas/BoutPage.gd:145 weight warning, ui/OfferCard.gd:35 "Not safe" line, ui/modals/Camp.gd:184 "Film on the
  opponent", 223 tooltip, ui/modals/ProOffer.gd sub-line, licence row, "Turn pro" button, ui/modals/Trial.gd coach line
  ("Your coach:") and "Sign" buttons, ui/modals/Interview.gd "Pass" / "Sign" buttons.
- Buttons: "Talk to X" -> "Talk about the next goal" (FighterPage, DarkOverview); "Enter X for the nationals" -> "Enter
  for the nationals" (NationalsView x2, Fights); "Book X" -> "Book this fight" (ProFights); MatOpens "Enter",
  "Opens on Fights"; GrapplerPage "Your fighter teaches"; WeekTwist "Give Saturday off".
- ui/GamePlan.gd, ui/StrikeBrowser.gd, ui/PlanPanel.gd, ui/TapeRoom.gd, ui/GamePlanRows.gd, ui/MoveTipInfo.gd,
  ui/CampMatch.gd, ui/StaffCard.gd hire tooltip, ui/TwistCard.gd mood line, ui/areas/GrapplerPage.gd, ui/areas/Playbook.gd
  body lines -> roles.
- rules/Aftermath.gd (tiles), rules/Headline.gd cause, rules/StripeCall.gd coach's why, rules/CoachNotes.gd {name}
  notes, rules/CoachCheck.gd next fight, rules/ReviewReveal.gd reveals, ui/modals/WeekReview.gd open results -> no names.

## Not done (out of the grep's reach or not on a screen)
- rules/AskBout.gd and rules/TrainRead.gd closed/coach lines name the fighter but nothing on screen calls them yet.
- assets/data/*.json lines whose {her} is filled by news/region builders (news keeps names).

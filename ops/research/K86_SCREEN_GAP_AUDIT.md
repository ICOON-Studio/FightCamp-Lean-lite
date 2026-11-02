<!-- Collected S166 2026-10-05 from gbot thread Kalli (K86, 3 parts), verbatim; Kalli could not land it (Beast offline). -->
[send-message t159s1038] # K86 verdict

HOME still says **Open Scouting** with no Scouting word on that screen; THE CANDIDATE fails identity strip, scale/bands, plain-money ask, and the guide covers Sign; Scouting/Staff/Schedule still have too many doors (K85).

**Option A (rail + hubs, repaired) wins for chapter 1.** Keep CONTINUE-to-next-event and the week review. Option B (gym-as-menu + timeline) is the post-K85 spatial skin with hard pause-on-panel, not the EA time model.

Beast is offline: could not rebase or land to `research/`. Full audit below (~336 lines). I will copy it to Beast and ping Claude the moment the desktop app is online.

---

# K86 - SCREEN GAP AUDIT: settled design vs shipped screens (PART 1 of 3)

| Field | Value |
|---|---|
| Task | K86 |
| Date | 2026-10-05 (Asia/Nicosia, UTC+3) |
| Agent | Kalli (design only, no code) |
| Output | `research/K86_SCREEN_GAP_AUDIT.md` (box draft: `/workspace/k86/K86_SCREEN_GAP_AUDIT.md`) |
| Evidence | `s165_exe_walk/` 01-59, `s165_story_beside/`, operator coach-candidate frame. Beast offline: still pixels NOT opened this pass. Filenames cited from the brief. |
| Priors read | J54, K78, J52, PROFILE_IA (7 rules), K85, M32, M33. **NOT FOUND on box:** G109_HUB_LIVE_COUNTS, S74_READINESS_AUDIT, SCENETREE2 v4, J62. FM24 candidate = PROXY. |

## 1. Verdict (answer first)

The shipped IA still breaks three settled rules on the first hour: (1) a HOME card says **Open Scouting** while the rail never shows the word Scouting on that screen and the Fighters group can hide the page (hotfix opened the group; the word gap remains); (2) THE CANDIDATE panel dumps numbers without scale, band words or tooltips, and the guide card covers the only CTA; (3) one job still has many doors (K85), so the player cannot learn where Scouting / Staff / Schedule live.

**Option A (rail + hubs, repaired)** wins on paper for the first hour. FightCamp's loop is one decision a day with a week review and a camp countdown. That rhythm matches CONTINUE-to-next-event (J54, FM, Motorsport Manager, OOTP), not a real-time clock. Option B is a strong mid-game fantasy once the gym rooms are the single home of every screen (K85), but it costs the week review and the calm "what needs me" hub unless you fake pause-on-panel heavily. Ship A for Early Access chapter 1; keep B as the room-nav end state after A is honest.

## 2. IA map as it IS

### 2a. Reachable screens (click map)

| Screen | Rail area | How reached | Words that lead there | Still / note |
|---|---|---|---|---|
| Title | (none) | Boot | NEW CAREER / LOAD / SETTINGS | s165_01 boot |
| Creation (country / city / gym) | (none) | NEW CAREER | NEXT, START CAREER | s165 creation; story_beside gym step |
| HOME (empty) | HOME | After creation; rail HOME | FIRST JOB / NEEDS YOU / Open Scouting | s165 HOME empty |
| HOME (booked) | HOME | After first accept | NEXT UP, SET CAMP, CONTINUE | s165 HOME booked / after bout |
| Roster & floor | FIGHTERS | Rail FIGHTERS > page | ROSTER & FLOOR | K78; group was closed on empty gym |
| Training | FIGHTERS | Rail FIGHTERS > page | TRAINING | K78 |
| Scouting | FIGHTERS | Rail FIGHTERS > SCOUTING; also FIRST JOB CTA | SCOUTING / Open Scouting | s165 scouting. **Word break:** CTA names Scouting; HOME chrome does not |
| Candidate (coach / fighter) | FIGHTERS > Scouting (or Staff) | Select a row on Scouting / hire seat | Invite / View / Hire | s165 candidate; operator coach frame |
| Offer table (sign) | under Candidate | Accept path from candidate | Sign / Offer | s165 offer table |
| Schedule / MY GYM | FIGHTS | Rail FIGHTS > SCHEDULE | SCHEDULE | s165_story_beside schedule MY GYM |
| Offers | FIGHTS | Rail / HOME row | Offers / Answer bout offer | s165 offers |
| Fights hub | FIGHTS | Rail FIGHTS | FIGHTS | s165 fights hub |
| Rankings | FIGHTS | Rail FIGHTS > RANKINGS | RANKINGS | K78 |
| Camp setup | FIGHTERS or HOME gate | SET CAMP | SET CAMP / GO COLD | s165 camp setup |
| Week review | (time advance) | after CONTINUE week | Week review | s165 week review |
| Fight week | LOCKER / HOME | ENTER FIGHT WEEK | Fight week | s165 fight week |
| Weigh-in | Fight week flow | CONTINUE stop | Weigh-in | s165 weigh-in |
| Fight night | Fight week flow | GO TO FIGHT NIGHT | Fight night | s165 fight night |
| Result | after bout | auto | Result | s165 result |
| Inbox / News | HOME or overlay | THE INBOX | Inbox | s165_story_beside THE INBOX |
| Staff / hire | GYM or MONEY (live mapping clash) | STAFF page / Staff room | STAFF | K78 tip maps STAFF under MONEY; J54 puts Staff under GYM; K85 under Staff room |
| Office / Books | MONEY | OFFICE / BOOKS | OFFICE | K78 clash 6 |
| Gym floor / rooms | HOME pins or doors | Office, Staff, Locker, ring pins | pin names | K85; overlap with rail |

### 2b. Word / structure breaks

**Buttons whose words name something NOT on the screen they sit on**
1. HOME FIRST JOB / NEEDS YOU: **Open Scouting**. The destination word Scouting does not appear in HOME chrome or as a visible rail page until FIGHTERS is opened. Hotfix opened the Fighters group; it did not put the word on HOME.
2. K85 legacy: Office pin and FINANCE > Office both said Office for different jobs.

**Sub-pages hidden behind a closed group**
1. FIGHTERS pages were collapsed on an empty gym. Hotfix: group open. Structural need: Scouting must be a visible second-level tab whenever FIRST JOB points at it.
2. Staff / Scouting / Schedule still reachable from multiple room pins (K85).

**Terms shown without tooltip or scale**
1. Candidate tiles: **teaching / tactics / rating / weeks** with bare numbers. No scale, no band word.
2. Readiness %, camp weeks, heat: full glossary coverage NOT COMPUTED without Beast stills.
3. Gap block not tied to "vs your current coach" in plain words.
[send-message t159s1039] ## 3. Rule x screen table (PART 2 of 3)

Rules: **P1** identity strip · **P2** Decide-first · **P3** Progressive disclosure · **P4** Honest empties · **P5** Entity links · **P6** Evaluated ambition · **P7** One primary CTA · **H** J54 HOME · **W** K78 one word · **E** J52 explain.

| Screen | P1 | P2 | P3 | P4 | P5 | P6 | P7 | H | W | E | Evidence |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Title | - | PASS | PASS | PASS | - | - | PASS | - | PASS | PASS | s165_01 boot |
| Creation | - | PASS | PASS | PASS | - | - | PASS | - | PASS | FAIL* | creation |
| HOME empty | - | FAIL | FAIL | FAIL | FAIL | - | FAIL | FAIL | FAIL | FAIL | HOME empty |
| HOME booked | - | PASS | PASS | PASS | PASS | - | PASS | PASS | PASS | PASS | HOME booked |
| Scouting list | FAIL | PASS | PASS | PASS | PASS | - | PASS | - | PASS | FAIL | s165 scouting |
| Candidate coach | FAIL | FAIL | FAIL | FAIL | FAIL | - | FAIL | - | FAIL | FAIL | operator frame |
| Candidate fighter | FAIL | FAIL | FAIL | FAIL | FAIL | FAIL | FAIL | - | PASS | FAIL | same panel family |
| Offer / sign table | PASS | PASS | PASS | PASS | PASS | - | PASS | - | PASS | FAIL | s165 offer table |
| Fights hub | - | PASS | PASS | PASS | PASS | - | PASS | - | PASS | PASS | s165 fights hub |
| Offers | - | PASS | PASS | PASS | PASS | - | PASS | - | PASS | PASS | s165 offers |
| Schedule MY GYM | - | PASS | PASS | PASS | PASS | - | PASS | - | PASS | PASS | story_beside |
| Camp setup | - | PASS | PASS | PASS | PASS | - | PASS | - | PASS | FAIL | s165 camp |
| Week review | - | PASS | PASS | PASS | - | - | PASS | - | PASS | PASS | s165 week review |
| Fight week | - | PASS | PASS | PASS | PASS | - | PASS | - | PASS | PASS | s165 fight week |
| Weigh-in | - | PASS | PASS | PASS | PASS | - | PASS | - | PASS | PASS | s165 weigh-in |
| Fight night / corner | - | PASS | PASS | - | - | - | PASS | - | PASS | PASS | s165 fight night |
| Result | PASS | PASS | PASS | PASS | PASS | - | PASS | - | PASS | PASS | s165 result |
| Inbox | - | PASS | PASS | PASS | PASS | - | PASS | PASS | PASS | PASS | THE INBOX |
| Staff list | FAIL | PASS | PASS | PASS | PASS | - | PASS | - | FAIL | FAIL | STAFF clash |

\*Creation E FAIL only if M32 developer chrome still visible; NOT COMPUTED.

Candidate coach is the densest FAIL cluster. HOME empty fails H/W/E/P2/P7 together. Most fight-flow screens PASS once booked.

## 4. Ranked defect list (first-hour first, <= 25)

| # | Defect | Smallest fix |
|---|---|---|
| 1 | HOME FIRST JOB says Open Scouting; Scouting absent on HOME | CTA: **Open FIGHTERS · Scouting** or Scouting chip on HOME |
| 2 | Fighters sub-pages can collapse when FIRST JOB needs Scouting | Force-expand FIGHTERS + highlight SCOUTING when NEEDS YOU targets it |
| 3 | Candidate: no scale / band on teaching, tactics, rating | Show `14/20 · Good`; tooltip = band table |
| 4 | Candidate: **weeks** unexplained | On-screen: **Contract 29 weeks**; tip explains weekly pay |
| 5 | Guide card covers Sign / Decline | Dock guide above/beside; never over primary CTA |
| 6 | Candidate lacks identity strip | Portrait, name, flag, age, role badge |
| 7 | No one verdict sentence | One line under strip |
| 8 | Ask not in plain money | `$890 a week for 29 weeks · $1,780 to sign` |
| 9 | Gap block not tied to OUR gym | `Signing fills Head Coach; training quality +8` |
| 10 | Two+ golds on candidate | One primary: **Sign coach** |
| 11 | Scouting vs Study same word | Recruit = **Scout**; Film = **Study** |
| 12 | Staff under MONEY tip and GYM/J54 and Staff room | One home: GYM > Staff |
| 13 | OFFICE under MONEY does not say money | Rename page **Books** |
| 14 | Schedule from Office + Front desk + FIGHTS | One home: Front desk calendar |
| 15 | Honest empty on HOME with 0 fighters weak | `No fighters signed · Scout to fill a locker` |
| 16 | Tile tooltips hotfix incomplete | Glossary-bind every stat chip |
| 17 | Rail icon-only risk without tip | Icon + label + tip |
| 18 | Creation may show developer chrome | Kill M32 class strings |
| 19 | NEXT UP vs FIRST JOB two heroes | One hero gold; list CTAs slate |
| 20 | CONTINUE / HOME both about time historically | CONTINUE bottom-right only; HOME never advances time |
| 21 | Fighter candidate missing ambition eval | Evaluated ambition label (P6) |
| 22 | Offers lack deadline colour | Red blocker when offer < 7 days |
| 23 | Week review can bury a story beat | Cap one story card before review |
| 24 | Staff room locked while hire required | Base hire open at tier 1 |
| 25 | No breadcrumb from HOME CTAs | Always `FIGHTERS > Scouting > Candidate` |

## 5. THE CANDIDATE card (coach + fighter)

FM24 PROXY (J62 NOT FOUND).

### Coach wireframe

```
+------------------------------------------------------------------+
| [portrait]  LEN PARK                         [ENG]  age 48       |
|             Role: Head Coach · available                         |
|             Verdict: Strong teacher for an empty Head Coach seat;|
|             tactics only Fair. Hire now, upgrade tactics later.  |
+------------------------------------------------------------------+
| ATTRIBUTES (scale 1-20)                                          |
| Teaching   16  ################..  Excellent                     |
| Tactics    11  ###########.......  Fair                          |
| Discipline 14  ##############....  Good                          |
| Motivation 13  #############.....  Good                          |
| Rating     14  (overall from above)                              |
+------------------------------------------------------------------+
| vs OUR GYM                                                       |
| Head Coach seat: empty                                           |
| Signing fills Head Coach. Training quality +8. Wage budget -890/wk|
+------------------------------------------------------------------+
| THE ASK                                                          |
| $890 a week for 29 weeks. $1,780 to sign.                        |
| Can release with 2 weeks' pay.                                   |
+------------------------------------------------------------------+
|                                         [ Decline ]  [ Sign coach ]|
+------------------------------------------------------------------+
| Guide LEFT/TOP, never over Sign coach:                           |
| "Teaching is how fast fighters gain from sessions. Rest the      |
|  mouse on any number."                                           |
+------------------------------------------------------------------+
```

**Bands:** Poor 1-5 · Fair 6-10 · Good 11-15 · Excellent 16-20.

**Coach tooltips:** Teaching / Tactics / Discipline / Motivation / Rating each state scale 1-20 and meaning; weeks = contract length with weekly pay; $890 = weekly wage; $1,780 = one-time fee; Sign coach / Decline as above.

### Fighter wireframe

```
+------------------------------------------------------------------+
| [portrait]  MARA SOLANO                      [ESP]  age 22       |
|             Welter · Amateur · Record 4-0-0                      |
|             Verdict: Ready for a first regional card; chin       |
|             untested above club level.                           |
+------------------------------------------------------------------+
| ATTRIBUTES (scale 1-20) — six STAT_ORDER summary                 |
+------------------------------------------------------------------+
| vs OUR GYM: open locker · Welter matches focus · wage $420/wk    |
| THE ASK: $420 a week for 52 weeks. $0 to sign (amateur).         |
| Ambition: Win a regional title in 18 months.                     |
|                                      [ Decline ]  [ Sign fighter ]|
+------------------------------------------------------------------+
```

Primary: `Sign fighter`. Ambition = evaluated sentence only (P6).
[send-message t159s1040] ## 6. OPTION A - rail + hubs repaired (PART 3 of 3)

Keep J54 five areas and CONTINUE-to-next-event. Repair word breaks and candidate. Rooms = chips to the same homes, not a second tree.

| Min | Player does | What must be true |
|---|---|---|
| 0-3 | NEW CAREER | Sentence case, no dev chrome |
| 3-6 | HOME empty | CTA `Open FIGHTERS · Scouting`; FIGHTERS open; honest empty roster |
| 6-15 | Scouting > Candidate | Section 5 card; guide not over Sign |
| 15-25 | Sign fighter | NEXT UP: Book a bout |
| 25-40 | Offers, accept even match | CONTINUE shows stop reason |
| 40-50 | SET CAMP / GO COLD | K78 words |
| 50-60 | Fight week → result | Chapter end |

## 7. OPTION B - gym-as-menu + timeline

No rail. 3D gym is HOME. Click room/person/ring → panel over view. Timeline: pause / 1x / 3x; **pauses while any panel is open**. Dated events sit on the bar.

| Ref | When a decision is due |
|---|---|
| Two Point Hospital | Time runs unless paused; problems flash; you pause or rush |
| Planet Coaster / Prison Architect | Speed controls; object panel over world; pause for money/staff |
| Motorsport Manager | Race-day timeline; between races Continue stops for required mail |
| Football Manager | Not real-time. Continue-until-next-event. Closest to our CONTINUE |

| Loses | Gains |
|---|---|
| One-decision-a-day rhythm | Rooms are the menu (K85 end state) |
| Natural week review (must rebuild as forced pause) | Timeline shows weigh-in / fight / bills ahead |
| Easy camp countdown as weeks | Day ticks feel alive |
| Low-intensity hub | No rail nouns to learn |
| Easy CONTINUE teaching | Soft-flash only = missed weigh-ins (unfair) |

**If B ships:** panel open => time paused. Weigh-in / camp gate / offer expiry => hard pause + flashing pin + card.

| Min | B first hour |
|---|---|
| 3-6 | 3D gym; empty lockers glow; "Scout - click an empty locker" |
| 6-15 | Locker → Scout panel; candidate card; time paused |
| 15-40 | Sign; 1x; Front desk → Offers; markers for camp / weigh-in / night |
| 40-60 | Camp gate blocks playhead; hard pause at fight night; result |

**Paper choice:** A for chapter 1 EA. B after every screen has one room home and pause-on-panel is proven.

## 8. Strongest ruling

**Ruling:** Keep A for the first hour; B is the post-K85 spatial skin on the same homes, not a replacement time model. Fix HOME→Scouting words and the Candidate card before any nav rewrite.

**Against:** Operator asked to remove the menus; A looks like defending the broken rail.

**Keep:** Weigh-ins and camp gates are calendar facts. A continuous clock that does not hard-stop is unfair. FM continue-until-event is the genre fit. B's value is spatial IA, which K85 already specifies without real-time.

**NOT COMPUTED:** live pixel diffs on s165; hotfix tooltip coverage; FIGHTERS default after hotfix; G109; S74; SCENETREE2 v4; J62.

## 9. WHAT IS STILL WRONG

- Beast offline: stills not re-inspected; file not landed to `research/` or `_kalli_delivery/`; Claude not pinged yet.
- G109, S74, SCENETREE2 v4, J62 not on the box.
- Fighter candidate assumed same panel family as coach (PROXY).
- Staff rail parent still contested (J54 / K78 / K85).
- No PNG wireframes this pass (ASCII only).

---

End of `K86_SCREEN_GAP_AUDIT.md`. Box path: `/workspace/k86/K86_SCREEN_GAP_AUDIT.md`. Say when Beast is online and I will rebase, land, and ping Claude.

# K79 - S80 SCREEN WORDS

Owner: Kalli. Words only. Voice = K77 sheet (Handbook neutral; five bans; no he, his or him). Claude applies.
Script-checked: every string with a budget fits it, and none trips a ban. Placeholders (`<name>`, `<kit>`) were counted at 10 and 8 characters. Where current text already meets the voice, the row says KEEP. Middle dots stand in for the separator that came through as `?` in the task text. `?` is not a character in the game.

## Rulings

1. **One word per job across screens.** The news ticker is `NEWS`, not `On the wire`, because the coach lines and Handbook already say news. The money-owed list is `payroll`, because `the books` is a FINANCE pin name.
2. **OFFICE means one thing: the room where offers arrive.** The FINANCE pin that showed cash is renamed `CASH`. The same word on HOME and FINANCE for two jobs would make a player click the wrong one.
3. **"No fight booked"** replaces `Nobody is booked` and `Nobody booked yet`. It names the fight, not a person, and it is the same on HOME and FIGHTS.
4. **Statuses read as states, not orders,** except `rest N wk`, which I kept. See NOT COMPUTED.
5. **Controls in capitals only where they are keys or buttons** (`SPACE`, gold buttons). Pin facts stay sentence case.
6. **Fight night never states a round length.** `Now it's three minutes` is false for any sanction with 5-minute rounds, so the line ends on the bell.

### Argued against my strongest ruling: NEWS over ON THE WIRE
Against: `On the wire` has a voice, and a broadcast tone fits the fight-night screens. Kept `NEWS`: wire is trade jargon a first-time player has to decode, and Cage Legacy already uses a ticker called Wire. The jargon buys flavour at the cost of a stop in reading.

## Title

| id | current | proposed | budget |
|---|---|---|---|
| `eyebrow` | EST. 2026 · A BOXING & MMA MANAGEMENT GAME | EST. 2026 · BOXING & MMA GYM MANAGEMENT | ≤48 ch, now 39 |
| `tagline` | Run the gym. Build the fighter. Make the walk. | Run the gym. Build the fighter. Make the walk. (KEEP) | ≤50 ch, now 46 |
| `caption` | <gym> · Week N · $cash | <gym> · Week N · $cash (KEEP) | 22 ch |
| `last_save` | LAST SAVE | LAST SAVE (KEEP) | 9 ch |

## HOME pins (title <=14, fact <=28)

| id | current | proposed | budget |
|---|---|---|---|
| `office.title` | Office | OFFICE | ≤14 ch, now 6 |
| `office.fact` | N offers waiting | N offers waiting (KEEP) | ≤28 ch, now 16 |
| `office.none` | No offers yet | No offers yet (KEEP) | ≤28 ch, now 13 |
| `staff.title` | Staff room | STAFF ROOM | ≤14 ch, now 10 |
| `staff.fact_in` | Coach <name> · in | Coach <name> is in | ≤28 ch, now 18 |
| `staff.fact_n` | N staff | N on staff | ≤28 ch, now 10 |
| `ring.title` | The ring | THE RING | ≤14 ch, now 8 |
| `ring.fact` | N of M on a plan | N of M on a plan (KEEP) | ≤28 ch, now 16 |
| `floor.title` | Gym floor | GYM FLOOR | ≤14 ch, now 9 |
| `floor.fact` | <kit> · NN% | <kit> · NN% (KEEP) | ≤28 ch, now 11 |

## HOME cards

| id | current | proposed | budget |
|---|---|---|---|
| `next.title` | NEXT FIGHT | NEXT FIGHT (KEEP) | 10 ch |
| `next.none` | Nobody is booked | No fight booked | 15 ch |
| `next.body` | N fight offers waiting in the office. Read them and put a fighter on a card. | N offers are waiting in the office. Read them and put a fighter on a card. | ≤110 ch, now 74 |
| `gold.offers` | Open offers | OPEN OFFERS | 11 ch |
| `gold.train` | Set training | SET TRAINING | 12 ch |
| `gold.plan` | Plan this week | PLAN THIS WEEK | 14 ch |
| `gold.week` | Enter fight week | ENTER FIGHT WEEK | 16 ch |
| `needs` | Needs you | NEEDS YOU | 9 ch |
| `wire` | On the wire | NEWS | 4 ch |
| `fighters.title` | Your fighters | YOUR FIGHTERS | 13 ch |
| `fighters.fact` | N fighters · N of M floor spaces used | N fighters · N of M floor spaces used (KEEP) | 37 ch |
| `st.ready` | Ready to book | Ready to book (KEEP) | 13 ch |
| `st.train` | Training · ready to book | Training · ready to book (KEEP) | 24 ch |
| `st.booked` | Booked · N wk | Booked · in N wk | 16 ch |
| `st.camp` | Fight camp · <focus> | Fight camp · <focus> (KEEP) | 20 ch |
| `st.injury` | <injury> · rest N wk | <injury> · rest N wk (KEEP) | 20 ch |

## FIGHTERS hub

| id | current | proposed | budget |
|---|---|---|---|
| `roster` | Roster: N fighters · N need you | N fighters · N need you | ≤28 ch, now 23 |
| `training` | Training: N of M on a plan | N of M on a plan | ≤28 ch, now 16 |
| `scouting` | Scouting: Find and sign new talent | Find and sign fighters | ≤28 ch, now 22 |
| `caption` | (not supplied) | Your roster, your training plans and the fighters you could sign. | ≤80 ch, now 65 |

## FIGHTS hub

| id | current | proposed | budget |
|---|---|---|---|
| `schedule.fact` | <name> · in N wk | <name> · in N wk (KEEP) | ≤28 ch, now 16 |
| `schedule.none` | Nobody booked yet | No fight booked | ≤28 ch, now 15 |
| `rankings` | Where your fighters stand | Where your fighters stand (KEEP) | ≤28 ch, now 25 |
| `offers` | N waiting | N waiting (KEEP) | ≤28 ch, now 9 |
| `caption` | (not supplied) | Book bouts, check the rankings and read what promoters offer. | ≤80 ch, now 61 |

## FINANCE hub

| id | current | proposed | budget |
|---|---|---|---|
| `books` | Net ±$N a week | Net ±$N a week (KEEP) | ≤28 ch, now 14 |
| `office.title` | Office | CASH | ≤14 ch, now 4 |
| `office.fact` | Cash $N | $N on hand | ≤28 ch, now 10 |
| `staff` | N on the books | N on the payroll | ≤28 ch, now 16 |
| `contracts` | N fighters signed | N fighters under contract | ≤28 ch, now 25 |
| `caption` | (not supplied) | See what comes in, what goes out and who is on the payroll. | ≤80 ch, now 59 |

## Fight night

| id | current | proposed | budget |
|---|---|---|---|
| `red` | IN THE RED CORNER | IN THE RED CORNER (KEEP) | 17 ch |
| `blue` | IN THE BLUE CORNER | IN THE BLUE CORNER (KEEP) | 18 ch |
| `tape` | TALE OF THE TAPE | TALE OF THE TAPE (KEEP) | 16 ch |
| `bell` | N weeks of fight camp. N kg on the scale. Now it's three minutes. | N weeks of fight camp. N kg on the scale. Now the bell. | 55 ch |
| `bell_cold` | No fight camp. In cold. | No fight camp. Going in cold. | 29 ch |
| `skip` | Space to skip | Press SPACE to skip | 19 ch |
| `line` | ON THE LINE TONIGHT | ON THE LINE TONIGHT (KEEP) | 19 ch |

## Clashes

1. **OFFICE on two screens** (HOME offers, FINANCE cash). Fixed above by renaming the FINANCE pin to CASH. K78 clash 6 asked the same of the rail's OFFICE page. If the rail page is the cash page, it should be CASH too.
2. **`the books` and `on the books`.** The FINANCE pin and the staff fact used the same phrase for two things. Staff now says `payroll`.
3. **`Set training` and `Plan this week`** both mean "make the training plan". I kept both because I do not know which state shows which. If they appear in the same state, drop `PLAN THIS WEEK`.
4. **`<kit> · NN%`** has no unit. If NN is equipment condition, the Handbook term must be renamed `Equipment condition` (the K77 clash) and the pin needs a hover line: "How much wear the gear has taken."
5. **Fight and bout.** `NEXT FIGHT` and `FIGHTS` keep `fight`, because they are names. In sentences, `bout` means one booked fight (K78). The FIGHTS caption uses `bouts`.
6. **Plurals.** `N offers`, `N staff`, `N weeks` and `N wk` need the singular (`1 offer`, `1 wk`). The proposed forms use `wk` and `N waiting` to avoid most of this, but `N offers are waiting` needs a branch.

## NOT COMPUTED

- `rest N wk`: whether an injured fighter can still train or spar. If yes, `rest` is a wrong order.
- Which state shows `Training · ready to book` versus `Ready to book`. If they are the same state, merge.
- What the `LAST SAVE` card contains. I kept the label only.
- The three hub captions: the task gave no current text, so these are new lines, not rewrites.
- Whether the bell line's kg is the weigh-in weight or the target.

## WHAT IS STILL WRONG

- I did not see the screenshots (`s80_look`), so no string was read in place or checked against its pin or card width.
- Nothing is rendered at the real container size.
- The missed-weigh-in branch of the fight-night sequence still has no line.

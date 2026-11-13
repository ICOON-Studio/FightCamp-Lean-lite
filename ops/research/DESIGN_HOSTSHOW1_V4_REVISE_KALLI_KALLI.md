# DESIGN_HOSTSHOW1_V4_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ83)

Brief: research/DESIGN_HOSTSHOW1_V4_REVISE_KALLI.md
Sent: 2026-11-13 23:11 | collected: 2026-11-13 23:41 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

# HOSTSHOW1 v4: host your own club show (design map, round 4, S459)

Part 1 of 3

**Quoted owner rules carried in this map:**
- **S448 (names only in headers):** a person's name sits in a screen or card header once; options, buttons, rows, lines and tooltips say `your boxer`, `the opponent`, `the No. 2`, `your coach`, or use no pronoun.
- **S412 (sandbox):** the player runs any gym with any boxers, men or women. Never write about one boxer as the story, and never use a fixed `he` or `she` in text or mockups.
- **S425 (menu wiring):** keep the table of every menu the mechanic appears on and what each is wired to.
- **S459 (bar):** must clear 6+ DEPTH and 6+ GENERAL DESIGN with fresh critics; say which numbers are ESTIMATES; keep it buildable from what the game has.
- **Section 7 (actionable info and Look B):** show only what the player can act on; hover explains every number; plain words, one word per concept; Look B whiteboard wall with no flavour text.

**Marks:** **CODE** = in the code today (file and symbol named). **ESTIMATE** = ours, verified by `HOSTPROBE1` (section 9) before any screen shows it. **NEW** = rule added by this map. **[R]** = real-world figure from research (`SCOPE_FOUR_FIGHTERS_S428`, `R37_ASK_FOR_A_FIGHT_MAP_S428`, `HYPE_MAP_S432`, S449 amateur rules).

**Source status note:** Written from the S403 critic pack (including S409, S410, S448, S451 additions), the round 3 map, and John's round 3 critic return (`SQ75`). `CRITIC_ACCESS.md`, the Miro board, and `screen_r3.png` were not opened directly.

---

## 0. Answer to every critic point (`To reach 10/10`, John SQ75)

| Critic point | Change in v4 (or one-line reason why not) |
|---|---|
| 1. Make favours scarce (earn only by service, cap 2, lapse 26 wks; probe 4-6/yr, "as it is" wins >= 1 in 3) | **Done (4.5, 9).** Favours cap at **2**, lapse after **26 weeks** unused (`ESTIMATE`), and earn **+1** only when our boxer fills a club's short-notice slot, boxes an away rematch on their show, or we give that club's boxer a bout on our main card (our bouts or a used reserve, not coach-filled pairs). `HOSTPROBE1` checks 4-6 earned/year and "as it is" best in >= 1 of 3 asks. |
| 2. Price the promise (locks boxer until fought, other club sets date 4-12 wks out, tile states lock) | **Done (4.3).** Promising a return bout locks that boxer against other offers until the rematch is fought; the other club picks the date 4-12 weeks out on their show (`NEW`). Tile shows `"Locks next bout (4-12 wks away); no other offers until fought"`. Breaking it by turning pro or standing down still costs **-2 favours**. |
| 3. Fix the hall maths (reach x0.8 / x1.0 / x1.25, gym floor places x 4 at $25, raffle $5/head, probe across 3 clubs) | **Done (4.2, 6, 9).** Draw multipliers: Gym floor **x0.8**, Community **x1.0**, Town **x1.25** (`ESTIMATE`). Gym floor holds `equipment places x 4` seats (**88** on 22 places) at **$25**. Raffle is **$5 per seat sold** (`ESTIMATE`). `HOSTPROBE1` verifies each hall wins for one of the three test clubs. |
| 4. Fix the goal judge before using it as a price (stat goals at deadline, bout/win goals at bout; use `Stamina`) | **Done (4.3, 6, 8).** Added `GOALFIX1` (`BoutNight` / `FighterGoal`): stat goals judge only at their deadline; only bout/win goals judge on fight night. Goal stat renamed to `Stamina` (`Attrs.gd`, S448). Boxing options now trade taper loss (`Sim.daily_gain`), 6% injury / 30-day stoppage risk, seats, and rank chance. |
| 5. Pull-outs at real rate (25 in 100) with up to 2 standby reserves ($40 standby) | **Done (4.10).** Last-week pull-out rate set to **25 in 100** per invited bout (`[R]` S449, `ESTIMATE`). Host may hold up to **2 standby reserves** (free regional name or outside novice, **$40** standby each, travel/novice fee only if boxed). Short night (< two-thirds of card) costs **-2 reputation** unless a reserve fills it. |
| 6. Weight the England Boxing way (weigh-in on the day; "Ask the other corner" up to +0.5 kg, -1 favour, 7 in 10) | **Done (4.4, 8).** Home shows use a **day-of weigh-in** (`NEW` branch in `Bouts.weigh`, scoped in task 9; `CODE` remains day-before for away bouts). Added fourth answer: **Ask the other corner to accept** (up to **0.5 kg** over, **-1 favour**, **7 in 10** yes, `ESTIMATE`). `Keep the cut` now loses the bout only if over and the corner refuses. |
| 7. Keep a boxer free for the show (hold toggle from booking, passes away offers within 14 days) | **Done (4.1, 7).** Each boxer row gets a **Hold for our show** toggle from booking day (`NEW`), passing away offers landing within **14 days** of our date; offer view notes `"Held for our show"`. |
| 8. One novice rule (fix Liam record / text; clarify Dean v Liam and Danny pool) | **Done (3, 6).** `7-5` (12 bouts) and `8-5` (13 bouts) are both **open** (`CODE` `experience_match_ok` 0-10 = novice). Their visiting pair is legal open-v-open, and the men's 60 kg table holds zero legal novices, so `Outside novice` and `Skills bout` open cleanly. |
| 9. Count the card properly (fix 6.4 and 6.11 visitor/supporter/travel counts) | **Done (4.2, 6).** Explicit bout math everywhere: Community hall 9 bouts = 2 ours + 7 pairs = 16 visitors (48 supporters, $640 travel). Town hall 12 bouts = 2 ours + 10 pairs = 22 visitors (66 supporters, $880 travel). |
| 10. Take every win figure from `BoutRead.band` | **Done (4.3, 6).** All Section 6 odds recalculated from the pack's 5-pt = 72% curve (`BoutRead.band`): -3 pts = **37** (30-44), +1 pt = **54** (47-61). |
| 11. Names in headers only (S448 + S412 everywhere; fix "Ana sells") | **Done (0-12).** People's names sit only in card headers (`Boxer` / `Opponent` / `Assistant` face cards). Rows, Home notes, `NEXT BOUT`, and tiles say `your boxer`, `the opponent`, `the No. 2`, `a no-gi athlete`. `"A no-gi athlete sells"` is available only when a no-gi athlete is signed and priced honestly (-1 mat class: -$75 fee, -1.1 syllabus mastery, -4 morale for +10 seats). |
| 12. Define the rest (swap odds, MOVE DOWN, gym floor space check) | **Done (4.2, 4.8, 4.9).** Swap: each club yes **8 in 10** (`ESTIMATE`), tile prints **64 in 100** joint (if either says no, swap fails and favours return, 3-day window spent). `MOVE DOWN`: keeps advance tickets sold, refunds excess over smaller hall seats, cuts visiting pairs to fit, loses deposit, costs **-2 reputation** (`ESTIMATE`). Gym floor requires `equipment places >= 16` (`CODE` `GymSlots`, else disabled with reason). |
| 13. Rank lines as one number (condition tree on hover) | **Done (4.3, 6, 10).** Tiles print one number (`"No. 3 or better: 55 in 100"`); hovering the number opens the full condition tree (`before` + visiting pairs + region show). |

*Also addressed from John's review:* Added `Play` depth between booking and card opening (hold toggles, 3-week camp timing aligned to card opening at 24 days out, early reserve booking) and made the post-show sheet actionable (`Add places`, `Review pro offer`, `Book next show date`).

---

## 1. The idea in five lines
1. About three times a year (`ClubShow.EVERY_DAYS` 112, **CODE**) the club hosts its own amateur show: you pick the date, the hall, and who is held for it, and you are the matchmaker.
2. For each boxer on the card you choose whom to ask (a name above, a name below, an outside novice, a skills bout, wait, or leave off) and how (as it is, with a scarce favour, or a locked return-bout promise); each tile prints yes chance, win chance (`BoutRead.band`), one combined rank number (condition tree on hover), pro-offer chance, and seats.
3. Your coach fills visiting pairs; pairs with a name above one of ours are **Ladder** pairs, and swapping them costs favours with both clubs; up to 2 standby reserves insure against the 25% final-week pull-out rate.
4. Region shows run around yours: names on our card are held from them, while free rivals can shift the table before our night.
5. On the night, home bouts run with a day-of weigh-in and a post-show sheet comparing net cash to boxing away, itemising reputation and member limits, updating favours, and firing any earned pro offer.

---

## 2. What is built today (**CODE**)
- `ClubShow.gd`: `COST` $3,500, `TICKET` $25, `HALL` 400, `EVERY_DAYS` 112, `LEAD_DAYS` 28, draw = `40 + 0.7×members + 1.0×rep + 2.5×juniors + 25×home_boxers`, `LUCK` 0.70–1.15, `RAFFLE` $600–$1,400, +1 member per 40 tickets on profitable nights.
- `GymSpend.book_show` / `day_events`: pays up front, settles draw, adds members, writes one news line. `ClubSpend._show` on Club > Money.
- Away amateur bout: `$450` ticket cut (`BoutRules.TICKET_CUT` 89); win `+8` members, `+5` reputation; loss `-1, -2`; stoppage `-2, -4` (`BoutRules` 90–99).
- Region shows: every 14 days from day 12 (`Data` 101–102); 2 bouts per division (`Region.SHOW_BOUTS`) among rivals not in `f.bout` (`busy`, 101–106), novice rule (`experience_match_ok`, 0–10 bouts) both ways. `rankings` sorts net wins -> wins -> `rating` (ours sit at `0.0`, losing ties, line 176).
- Pro offer: `Roster.pro_ready` (7 wins + top-3 regional, or 9 wins); `check_pro` runs only when `f.bout == null` (`BoutNight` 459, `Bouts` 413, `Sim` 406).
- Goals: `BoutNight` 426–432 currently judges goals on bout night; `FighterGoal.progress` 96–158 checks targets (`+10` met, `-20` missed).
- Morale (`FighterProfile.MORALE_EVENTS`): win `+8`, loss `-12`, booked `+5`; `month_no_fight -6` has no caller.
- Weight & fatigue: `Sim.weigh_forecast` predicts one weight without future twist cards; `Bouts.weigh` runs day-before (`WEIGH_TOLERANCE 0.05`, miss `$300`). `BoutRules.stale_energy` cuts Energy by 2 per fatigue point > 50 (max 20, camp only). `WeekPlan` 245–263 handles burn (`CUT_DEFICIT 500`).
- Members: `GymSpend.member_target` = `min(natural_members, member_cap)`; `member_limit` names binding cap (`equipment` = `places × 3`, 22 opening places = 66).

## 3. What is thin (and world fixes required)
1. Today's show has no card, no matchmaking, no reputation/rank/pro-offer impact, and sits on one Money row.
2. **World defects fixed first (tasks 1–4):**
   - `RANKTIE1`: ours sit at `0.0` rating and lose every rank tie.
   - `MOODIDLE1`: `month_no_fight -6` has no caller.
   - `DATAFIX1`: some "London" opponents carry non-local club strings (`Data` 66–185).
   - `HOLD1`: `Region.day_events`' `busy` ignores names on our show card.
   - **Novice pool state:** in the sample mid-season state, men's 60 kg contenders with 12–13 bouts (`7-5`, `8-5`) are **open** (`>10` bouts); an open-v-open visiting pair is legal, while a 4-1 boxer has zero legal novice opponents in the pool, legally unlocking `Outside novice` and `Skills bout`.

---

## 4. The mechanics, each a decision with its options and prices

### 4.1 Date and holding boxers (8 weeks out or more)
- **Dates:** pick one of the next four free Saturdays at least **8 weeks out** (`[R]` England Boxing permits 8–12 weeks; `LEAD_DAYS` 28 -> 56, **NEW**).
- **Region clash:** a Saturday matching a region show (`12 + 14k`, **CODE**) cuts draw by **x0.8** (**ESTIMATE**). Screen shows per boxer: free, booked, suspended, or in nationals (`Champs.active`, **CODE**), plus the region show 1 week earlier (4.6).
- **Hold for our show (NEW):** from booking day, each boxer's row has a **Hold for our show** toggle. When ON, away offers landing within **14 days** of our show date pass automatically (`"Held for our show"` on the offer line). Keeps boxers available without locking out earlier tune-ups.

### 4.2 Hall (one choice at booking; price and reach scale with hall)
| Hall | Seats | Rent | Ticket | Card (ours + visiting) | Draw mult | Name above yes (base) | Full (85%+) | Half-empty (<50%) |
|---|---|---|---|---|---|---|---|---|
| The gym floor | `places × 4` (88 on 22) | $300 | $25 | 6 bouts (e.g. 2 + 4 pairs) | **x0.8** | 3 in 10 | +3 rep | -3 rep |
| Community hall | 250 | $1,000 | $25 | 9 bouts (e.g. 2 + 7 pairs) | **x1.0** | 5 in 10 | +4 rep | -3 rep |
| Town hall | 400 | $2,000 | $25 | 12 bouts (e.g. 2 + 10 pairs) | **x1.25** | 7 in 10 | +6 rep | -4 rep |

- **Space check (NEW):** Gym floor requires `equipment places >= 16` (`GymSlots`, so ring + 64+ seats fit); otherwise greyed with `"Needs 16 equipment places for a ring and seats"`.
- **Fixed show costs:** officials, doctor, ambulance **$1,200** + medals **$300** (**CODE** comment split); **30% of hall rent** paid as deposit at booking (**NEW**).
- **Raffle (NEW):** **$5 per seat sold** (**ESTIMATE**, replaces flat $600–$1,400 so small halls do not print free money).
- **Booking preview:** shows per hall: likely net, 1-in-10 bad night net, full chance, half-empty chance, base yes chance (`ClubShow.v2.preview`).
- **Why it binds:** Young clubs / low cash take Gym floor (cheap deposit, guaranteed full +3 rep); mid clubs take Community hall (best cash vs away); grown clubs or desperate title/pro chases take Town hall (unlocks 400 seats and +2 in 10 on names above, risking half-empty -4 rep).

### 4.3 Your boxers on the card (matchmaker choices)
- **Timeline:** Card opens **24 days out** (3+ weeks, aligning with `Set camp` eligibility); posters print and ticket read runs **12 days out**; bout sheet closes **3 days out** (`[R]` R37). One open ask per boxer; opponent answers in **3 days** (**NEW**, **ESTIMATE**). Refused names are spent for this boxer this show.
- **What every tile prints (names in card header only):**
  - Yes chance (`N in 10`)
  - Win chance from `BoutRead.band` (`"Wins N in 100 (band)"`, **CODE**)
  - Single rank number (`"No. 3 or better: N in 100"`, **NEW**; full condition tree on hover from `RankLine.after` using `Region.before`)
  - Pro-offer chance from the show (`"Pro offer: N in 100"`, **CODE** `Roster.pro_ready`)
  - Expected seats and reputation delta
- **Opponent choices:**
  - **A name above:** yes = hall base + `1 in 10` per `2` rating points opponent leads ours (cap `9 in 10`, **ESTIMATE**). Win: `+5` rep, `+8` members (**CODE**). Highest-ranked opponent makes the **Main Event** (4.7).
  - **A name below:** yes `9 in 10` (**ESTIMATE**). Home win over name below: `+3` rep (**ESTIMATE**, `[R]` HYPE_MAP), `+8` members (**CODE**).
  - **Outside novice** *(only when pool holds zero legal regional names)*: always yes, `$80` travel, no tape (`OppFile`), `50 (30-70)` band.
  - **Skills bout** *(only when pool holds zero legal regional names)*: same outside novice, `$80`, 3 rounds, no winner (`[R]` England Boxing skills bout). Runs through `BoutNight` with **no** record, rank, win/loss morale, member, or rep delta (**NEW**); `booked +5` morale applies, zero stoppage/injury-roll risk (**NEW**).
  - **Wait for the region's show:** no ask until Sat show settles (one ask left before sheet closes). Loses main-event poster seats, saves favours, resolves rank uncertainty.
  - **Leave off:** full training weeks (no TAPER loss); away offers continue (**CODE**). Once `MOODIDLE1` lands, `-6` morale if 30+ days idle.
- **How to ask (shown only if it changes yes chance):**
  - **As it is**
  - **With a favour** (`-1` club favour: `+3 in 10`, max `9 in 10`)
  - **Promise a return bout** (`9 in 10`, no favour spent now): **locks your boxer** so no other offers arrive until the rematch is fought (**NEW**); the other club picks the date **4–12 weeks out** away at their show (`$450` cut, **CODE**), written to `f.bout` the Monday after our night so `check_pro` on show night is not blocked (**CODE** `BoutNight` 459). Tile prints `"Locks next bout (4-12 wks away); no other offers until fought"`. Breaking it by turning pro or standing down costs **-2 favours** (`NEW`).
- **Stand down (after yes):** `Bouts.withdraw_bout` (**CODE**) with host news words (**NEW**), drops boxer's seats, costs **-1 favour**.
- **Legality & goal rule:** novice (`0-10` bouts, **CODE**), Supervisor floor (band max `>= 30` both ways, **NEW**), exact kg class (**no catchweights**). **`GOALFIX1` (NEW):** stat goals (`Stamina`, etc.) judge only at their deadline; only bout/win goals judge on bout night.

### 4.4 Weight on our own show (England Boxing day-of rule)
- **Day-of weigh-in (NEW `Bouts.weigh` home-show branch):** home shows weigh in on **show day**, 1 hour before boxing (`[R]` England Boxing rule 7.1.3; away bouts remain day-before **CODE**).
- **Miss chance (`WeighOdds.miss`, NEW pure):** runs `Sim.weigh_forecast` across possible Monday twist weights (`WeekTwist`), counting misses over `limit + 0.05`.
- **Four choices on a close/over forecast:**
  1. **Keep the cut:** only loses the bout on show day if over `limit + 0.05` AND the other corner refuses (`-2` rep, `-1` favour, **NEW/ESTIMATE**).
  2. **Ask the other corner to accept:** valid up to **0.5 kg** over (`ESTIMATE` inside 2.5 kg EB band); costs **-1 club favour**, **7 in 10** yes (**ESTIMATE**). If yes, boxer fights safely at that weight; if no, must make weight on the day or stand down.
  3. **Harder fight week:** two rest mornings become Hard intervals (`-0.17 kg`, `WeekPlan` burn; fatigue ~56 -> **Energy -12** via `stale_energy`, **NEW** fight-week protocol 1, lowers win chance).
  4. **Stand down:** loses boxer + opponent seats and **-1 favour**.

### 4.5 Favours with other clubs (`Career.favours`, NEW, scarce)
- **Range and expiry:** **0 to 2** per club (min `-2` when owed). Any unused favour lapses **26 weeks** after that club's last favour change (**ESTIMATE**). Starts at **1** only with clubs a boxer of ours has already boxed cleanly (up to 3 clubs, **0** with Eastside ABC).
- **Earn (+1, max 2):** only by concrete service (**NEW**):
  1. Our boxer fills a short-notice slot for that club (`Bouts.short_notice`), OR
  2. Our boxer takes a promised return bout or away slot on that club's own show, OR
  3. That club's boxer gets a bout on our show's main card (an opponent for one of our boxers or a called-up standby reserve — **not** coach-filled visiting pairs), with our boxer making weight and not pulling out.
  *(Expected rate: ~4–6 favours earned per year across all clubs.)*
- **Spend:** `-1` for `+3 in 10` on an ask; `-1` per club on a ladder swap; `-1` to ask the other corner on weight; `-1` forced on stand-down or missed weight; `-2` on broken return-bout promise.
- **Owed (`< 0`):** all asks to that club suffer `-2 in 10` until clean service restores 0.

### 4.6 The region's show before our night (HOLD rule)
- **HOLD1 (NEW):** `Region.day_events`' `busy` includes every name on our card (our bouts, visiting pairs, locked standby reserves). Those names do not appear on region shows.
- Remaining free names in our boxers' divisions box normally (`Region.SHOW_BOUTS` 2, **CODE**). The timeline names free contenders and updates every hover condition tree when that show resolves.

### 4.7 Crowd: followings, visitors, main event
- **Home followings:** `10 + 3 × wins` per our boxer on the card (**ESTIMATE**, replaces `PER_HOME_BOXER` 25).
- **Visitors:** `3` supporters per non-novice opponent and visiting boxer; host pays `$40` travel per visitor (**ESTIMATE**). Outside novices bring 0 supporters (`$80` fee).
- **Main event:** highest-ranked opponent on our card closes the night. If settled before posters print (12 days out), adds `+50%` of our boxer's following, `+10` more if a pro offer is on the line (**ESTIMATE**). Win `+3` rep, loss `-3` rep (**ESTIMATE**).

### 4.8 Ladder pairs and swaps
- Coach fills remaining card bouts with legal regional pairs; visiting bouts resolve first on the night via `Region._rival_bout` (**CODE**) so `update_rank` and `check_pro` see them.
- **Ladder pair:** holds a name ranked above one of ours whose loss can lift our boxer. Swap button appears inline when legal swaps exist.
- **Swap rules (NEW):** costs **1 favour with each club** whose boxer moves. Each club says yes **8 in 10** (**ESTIMATE**); the tile prints the joint chance (**64 in 100**). 3-day answer clock; if either club says no, the swap fails, that pair locks, and the favours are not spent.

### 4.9 The ticket read (12 days out; timeline node until then)
Advance luck (`0.70–1.15`) rolls at 12 days out; sold so far = `69%` of projected night (`[R]`). Choices shown with net delta vs Keep:
- **Keep**
- **Door price $15:** walk-up draw **x1.3** on final third (**ESTIMATE**).
- **All boxers sell:** each boxer on our card drops 1 fight-week pad evening (`75 min = ~2.6` mastery on drilled move, `PadWeek` **CODE** rate) for **+10 seats** each.
- **A no-gi athlete sells** *(shown only when a no-gi athlete is on roster)*: cancels 1 mat class (`-1.1` syllabus move mastery, `-4` athlete morale, `-$75` mat fee refund, **NEW/ESTIMATE**) for **+10 seats**.
- **Move down** *(from Town -> Community or Community -> Gym floor if `places >= 16`)*: loses original deposit, cuts excess visiting pairs from bottom of undercard, keeps all tickets sold up to smaller hall capacity (**refunds** any excess over capacity), costs **-2 reputation** (**ESTIMATE**).
- **Cancel:** loses deposit, **-3 reputation**, **-1 favour** with every club on the card.

### 4.10 Pull-outs, standby reserves, the night, the sheet
- **Pull-outs (`ESTIMATE` from `[R]` S449):** each invited bout (ours or visiting) has a **25 in 100** chance to fall over in the final week.
- **Standby reserves (NEW):** host may book up to **2 standby reserves** (free regional name or outside novice) for **$40 standby** each (**ESTIMATE**); `$40` visitor travel (or `$80` novice fee) paid **only if boxed**. A reserve can step into a pulled-out visiting bout OR replace a pulled-out opponent for one of our boxers (if legal).
- **Short night:** if boxed bouts fall below two-thirds of the booked card (`<4` of 6, `<6` of 9, `<8` of 12) after reserves, **-2 reputation** (**ESTIMATE**).
- **The night & actionable sheet:** visiting bouts resolve first, then ours (`Bouts.fighting_today`, **CODE**), main event last (`Sim to result` supported). Post-show sheet prints: cash breakdown vs away (`$450` per legal away boxer), reputation parts, member gain + `member_limit` with **`Add places`** button if capped, rank changes, **`Review pro offer`** button if `check_pro` fired, favours earned/spent, next show crowd carryover (`+15%` full / `-10%` half-empty, **ESTIMATE**), and **`Next show opens in 16 wks`** date.

Part 2 of 3

## 5. Every decision (B before, D during, A after; "Right when" is the probe test, never on screen)

| When | Decision | Options and prices | Right when (never on screen) |
|---|---|---|---|
| B | Date | 4 Saturdays; region clash x0.8; boxer hold toggles | Date most boxers can make unless cash is urgent |
| B | Hall | Gym floor / Community / Town (4.2) | Gym floor: young club or low cash. Community: mid club cash. Town: grown club or desperate for +2 in 10 on a top name |
| B | Hold toggles | Hold for our show ON/OFF per boxer | ON for main-event/booked boxers; OFF for a boxer needing an extra tune-up |
| B | Boxer A route | Name above (as is / favour / promise) / Name below / + swap / Wait | Strong & saving favours: above as it is. Needs certainty & favours spare: name below + swap. Favour saved for later: wait |
| B | Boxer B weight | Keep / Ask corner (-1 fav, 7 in 10, <=0.5 kg) / Harder week (-12 Energy) / Stand down | <=0.3 kg & favour spare: ask corner. 0.1 kg & no favour: harder week. Safe margin: keep. >0.6 kg: stand down |
| B | Boxer C | Outside novice / Skills bout / Leave off | Goal safe & Steady: novice. Goal safe & Flat: skills bout. Goal tight: leave off |
| B | Ladder swap | Keep pair / Swap (-1 fav each club, 64 in 100 joint) | Swap when it raises pro-offer odds sharply and both clubs have a spare favour |
| B | Standby reserves | 0, 1, or 2 reserves ($40 standby each) | 2 reserves on 9-12 bout cards to prevent -2 rep short night; 0-1 on 6-bout gym show |
| B, read | Read choice | Keep / Door $15 / Boxers sell / No-gi sells / Move down / Cancel | Boxers sell when within ~25 seats of Full; No-gi sells only if mat morale/cash can bear -4/-$75; Move down if way under 50% |
| D | Pull-out | Use reserve / Tougher short-notice / Novice / Leave short | Use booked reserve first; tougher short-notice when band max >= 40 |

---

## 6. One show, played (all numbers tagged CODE, ESTIMATE, or NEW; names in card headers only)

*Note on notation: on screen each boxer and opponent appears as a face card with their name once in the card header. Below, `Boxer A/B/C` and `No. 2 / No. 3 / No. 7` show the exact rows and text the player sees (zero names outside headers).*

**Club state, Mon 25 May 2026 (day 140):** 58 members, reputation 24, standard dues ($35), 0 juniors, Unit premises (70), 1 assistant coach (coaching cap 110), 22 equipment places (`member_limit` = `"equipment"` at 66, **CODE**), cash $11,700. Natural members at rep 24: `48 + 0.6×24 = 62` (**CODE**); rep 30 fills 66.
**Favours (`Career.favours`, NEW, cap 2, 26-wk expiry):** Belfast Gloves ABC `1`, Leicester ABC `1`, Islington BC `1`, Dale Youth ABC `0`, Eastside ABC `0`.

**Our roster (card headers hold names on screen):**
- **Boxer A (women's 60 kg):** 6-1, No. 4, novice (7 bouts), fight power `62.5` (`RANKTIE1`), goal met.
- **Boxer B (women's 65 kg):** 4-2, No. 4, novice (6 bouts), forecast `65.05 kg` for `65.0 kg` limit (miss **1 in 3** on twist weeks, **NEW** `WeighOdds`), morale Steady 58.
- **Boxer C (men's 60 kg):** 4-1, No. 4, novice (5 bouts), lost Sat 27 Jun, morale Flat 41, goal `"Stamina for five rounds"` (`Stamina +2.5`, set Mon 29 Jun, deadline Mon 27 Jul; `+1.3` done by Mon 29 Jun->Mon 2 Jul, hits `+2.5` Thu 23 Jul on full weeks, or `+2.25` with fight-week TAPER, **ESTIMATE** from `Sim.daily_gain`).
- **No-gi athlete** *(optional slot)*: off the boxing card; eligible for `"A no-gi athlete sells"` at read if present.

**Regional tables:**
- **Women's 60 kg:** `#1` (14-2, open), `#2` (8-2, `65.5`, Belfast Gloves, novice), `#3` (7-1, `63.5`, Leicester, novice), `#4` (Boxer A, 6-1, `62.5`, novice), `#5` (8-4, open), `#6` (6-3, `60.5`, Dale Youth, novice), `#7` (4-2, `61.5`, novice), `#8` (4-2, novice).
- **Women's 65 kg:** `#1`, `#2` (7-2), `#3` (5-2, `62.0`, Islington, novice), `#4` (Boxer B, 4-2, `58.0`, novice), `#5` (3-1, novice).
- **Men's 60 kg:** `#1` (open), `#2` (10-3, open), `#3` (8-5, 13 bouts, open), `#4` (Boxer C, 4-1, novice), `#5` (7-5, 12 bouts, open). *Note: `#3` and `#5` are both open (`>10` bouts); `#3 v #5` is legal, and 0 legal novices remain in the pool.*

1. **BOOK (Mon 25 May):** Pick Sat 25 Jul (day 201; region shows Sat 18 Jul and Sat 1 Aug, **CODE**).
   - **Hall comparison on booking preview (ESTIMATE):**
     - **Gym floor (88 seats on 22 places, 6 bouts = 2 ours + 4 pairs -> 10 visitors, 30 supporters, $400 travel, $2,200 base costs):** draw `208.6 × 0.8 = 166.9` -> capped **88 seats** (99% Full `+3` rep). Net **+$440** ($2,640 - $2,200; less than $900 away, chosen only if cash < $3,000 or young club).
     - **Community hall (250 seats, 9 bouts = 2 ours + 7 pairs -> 16 visitors, 48 supporters, $640 travel, $3,140 base costs):** draw `226.6 × 1.0 = 226.6`. Likely 208 sold (83%), net **+$3,100**; bad night 170 sold **+$1,960**; good night 238 sold (Full `+4` rep, ~40 in 100).
     - **Town hall (400 seats, 12 bouts = 2 ours + 10 pairs -> 22 visitors, 66 supporters, $880 travel, $4,380 base costs):** draw `244.6 × 1.25 = 305.8` (if main event settled) or `220.6 × 1.25 = 275.8` (without main-event posters). Bad night without posters: `193` sold (48% **Half-empty -4 rep**, net **+$1,410**; with one stand-down drops to **+$630** < $900 away).
   - Pick **Community hall** ($300 deposit paid), toggle **Hold for our show ON** for Boxer A and Boxer B, book **2 standby reserves** ($80 standby total -> `$3,220` base costs).

2. **CARD OPENS (Wed 1 Jul, 24 days out):** Boxer B asks `#3` (`5 + 1 = 6 in 10`); Boxer A asks `#3` (`5 in 10`). Coach sets women's 60 pairs `#2 v #6` (**Ladder** for Boxer A) and `#1 v #5`; men's 60 `#3 v #5`. `HOLD1` holds `#2, #3, #6, #1, #5` (women's 60) and `#3` (women's 65) from region shows.

3. **SAT 4 JUL (answers arrive; `#3` women's 65 YES, `#3` women's 60 NO):**
   - **Boxer A's routes** (win odds from `BoutRead.band` **CODE** curve: `-3 pts = 37`, `+1 pt = 54`; hover shows condition tree):
     - **Ask `#2` (`65.5`) as it is:** yes `6 in 10`, wins `37 in 100 (30-44)`. Win -> 7-1 (passes `#2` 8-3) -> **No. 3 or better: 100 in 100** -> Pro offer! On a no (4 in 10), ask `#7` (`61.5`) after posters. Combined **Pro offer: 33 in 100**. Main event (`+24` poster seats). Keeps Belfast Gloves favour (1).
     - **Ask `#2` with a favour (Belfast Gloves `1 -> 0`):** yes `9 in 10`, **Pro offer: 36 in 100**. Leaves 0 favours with Belfast Gloves (cannot swap).
     - **Ask `#2` with a promise:** yes `9 in 10`, **Pro offer: 36 in 100**. Tile shows `"Locks next bout (4-12 wks away); no other offers until fought"`. Turning pro breaks it (`-2` favours).
     - **Ask `#7` (`61.5`) as it is:** yes `9 in 10`, wins `54 in 100 (47-61)`. On win (7-1), loses tie to `#2` and `#3` unless `#6` beats `#2` (`35 in 100`) or `#3` loses to `#8` on Sat 18 Jul (`30 in 100`). **No. 3 or better: 55 in 100** (`0.35 + 0.65×0.30`). Combined **Pro offer: 29 in 100**; win rep `+3`.
     - **Ask `#7` + Swap `#2 v #3` (`64 in 100` joint yes, Belfast Gloves `1 -> 0`, Leicester `1 -> 0`):** one of `#2/#3` must lose; **No. 3 or better: 84 in 100**, **Pro offer: 43 in 100**. Spends both clubs' favours.
     - **Wait for Sat 18 Jul:** `#3 v #8` meet on region show (`#3` loses `30 in 100` -> ask `#7`; `#3` wins -> ask `#2`). **Pro offer: 29 in 100**, keeps both favours, `-24` poster seats.
   - **Boxer B's weight (miss `1 in 3` on `Keep`):**
     - `Keep the cut`: risks call-off on show day (`-2` rep, `-1` Islington favour).
     - `Ask the other corner to accept` (`<=0.5 kg`, **-1 Islington favour**, **7 in 10** yes): safe if yes, falls back to cut if no.
     - `Harder fight week`: drops `-0.17 kg` to `64.88 kg` (miss **1 in 25**, Energy `-12`, wins `38 -> 33`).
     - `Stand down`: `-25` seats (`22` following + `3` supporters), `-1` Islington favour.
   - **Boxer C (`Stamina +2.5` goal tight on deadline Mon 27 Jul):**
     - `Outside novice`: `+5` booked, wins `50 (30-70)`, **No. 3 or better: 38 in 100** (`#5` beats `#3`), Taper cuts gains to `+2.25` (misses goal at Mon 27 Jul `-20` unless rescued; `6%` injury / `30-day` stoppage risk), `+22` seats.
     - `Skills bout`: `+5` booked, 0 injury/stoppage/record risk, Taper still cuts gains to `+2.25`, `+22` seats, 0 rank.
     - `Leave off`: meets `Stamina` goal Thu 23 Jul (`+10` at next bout), morale holds `41`, `0` seats.
   - **Player picks:** Ask `#2` as it is (saving Belfast Gloves favour), `Harder fight week` for Boxer B (saving Islington favour since win odds are already underdog `38 -> 33`), and `Leave off` for Boxer C to clear the Stamina goal.

4. **FORECAST (Thu 9 Jul, `#2` says YES; `#2 v #6` ends, coach pairs `#6 v #8`):**
   - Draw = `104.6 (club) + 50 (followings) + 24 (posters) + 48 (16 visitors × 3) = 226.6`.
   - Likely sold (`×0.916`): **208 seats** (83%), revenue `208 × $30 = $6,240`, costs `$3,220` (with 2 reserves), net **+$3,020** (vs `$900` away). Full (`213+`): `~40 in 100`. Half-empty: `0 in 100`.

5. **MON 13 JUL (12 days out, TICKET READ):** Advance luck `0.96` -> `150` sold so far, projecting `198–224` on the night. Player keeps (preserves main-event pads; no no-gi class cancelled).
6. **SAT 18 JUL (Region show):** `#3` beats `#7` (both free); Boxer A's `#2` win remains `No. 3 or better: 100 in 100`.
7. **FINAL WEEK PULL-OUTS (25 in 100 per bout):** 2 visiting bouts pull out on Tue 21 Jul and Thu 23 Jul. Both standby reserves step in (`+$80` visitor travel total -> `$3,300` costs); all **9 bouts** stay intact (no `-2` short night).
8. **SAT 25 JUL (Day-of weigh-in + Show night):**
   - 1 hour before bell: Boxer B makes `64.90 kg` (`<=65.05`).
   - Walk-up luck `1.00`: **214 sold** (86%, **Full +4 rep**!).
   - **Cash:** `214 × $30 ($25 + $5 raffle) = $6,420 - $3,300 =` **+$3,120 net** (vs `$900` away).
   - **Bouts:** Visiting pairs settle (`#5` beats `#3` in men's 60). Boxer B loses (`-1` member, `-2` rep; 4-3, No. 5). Boxer A beats `#2` (`+8` members, `+5` rep, `+3` main event) -> `7-1, No. 3` -> **`check_pro` fires Pro offer ($1,500 debut)**!
   - **Reputation & Members:** `24 - 2 + 5 + 3 + 4 (Full) = 34`. Members `58 - 1 + 8 + 5 (214/40) = 70`, capped by `equipment` `66`: sheet highlights **`Add places`** (`equipment places 22 -> 24+`).
   - **Favours:** Belfast Gloves `1 -> 2` (clean bout hosted), Islington `1 -> 2` (clean bout hosted). Next show opens in `16 weeks`. Next night crowd carryover: `+15%` (Full).

Part 3 of 3

## 7. Every menu it appears on, and what each is wired to

*(All UI strings, notes, and rows keep people's names strictly in card headers.)*

| Menu | What it shows (only what the player can act on) | Wired to |
|---|---|---|
| Fights > OUR SHOW (tab beside Bouts) | **PLAN:** 4 Saturdays (free/clash), 3 hall cards (`places >= 16` check for gym floor), **Hold for our show** toggles. **BOOKED:** header (date, hall, seats, price, days); timeline (asks close, posters/read, region show free list, reserves, day-of weigh-in, night); boxer rows (weight/condition/morale/goal chips, hold toggle; opponent card headers + yes, `BoutRead.band` win, single rank number with hover tree, pro offer, seats; how to ask + promise lock note; 4 weight choices; 2 standby reserve slots); ladder pairs with `64 in 100` joint swaps; **THE NIGHT** (seats bar, cash breakdown vs away); **REPUTATION & MEMBERS** (`member_limit` + `Add places`); **FAVOURS** (0–2, 26-wk expiry). **READ** on day 12. **AFTER:** actionable sheet | `ClubShow` v2, `ShowCard`, `HostShow`, `RankLine`, `Favours`, `WeighOdds`, `Region` (`HOLD1`, `RANKTIE1`), `Roster.pro_ready`, `BoutRead.band`, `Sim.weigh_forecast`, `Sim.daily_gain`, `FighterGoal.progress`, `GymSpend.member_target` / `member_limit`, `GymSlots` |
| Club > Money > CLUB SHOW row | Not booked: `"Plan a show"` (opens tab, greyed with next date). Booked: date, hall, deposit, likely net | `ClubSpend._show`, `GymSpend` |
| Club > People (FAVOURS list) | Each club's favour count (0–2), expiry weeks, what earns one | `Favours` |
| Home: notice board + COMING UP | `"The card is open: ask opponents"`; `"An opponent said no: ask again before posters"`; `"Ticket read ready"`; `"Weight check: pick an answer"`; `"Pull-out on the card"`; `"Show night"`. COMING UP: show, read, region show, sheet | `Needs`, `HomeNeeds`, `Career.show` |
| Top bar | Flags `SHOW CARD` / `TICKET READ` / `PULL-OUT` / `SHOW NIGHT`; `NEEDS YOU` while a card boxer has no ask out before posters | `Clock.next_stop`, `Needs.blockers` |
| Fighter > Overview, NEXT BOUT | `"Our show, Sat 25 Jul, main event"` (opponent name in bout card header only) or `"Ask out, answer Sun 12 Jul"`; `"Held for our show"` badge; promised rematch lock line | `Career.show`, `f.bout`, `Sim.goal_read` |
| Fighter > Week | Fight week; harder-week intervals; `TICKETS` evening if chosen at read | `AMATEURWEEK1`, `DrillWeek` |
| Fights > a bout offer | `"Held for our show"` auto-pass indicator; promised rematch badge; `"+1 favour on a clean bout"` when filling a club's short-notice or show slot | `Bouts.day_events`, `Favours` |
| Fight night: tale of the tape | `"Crowd 214, our show, main event"` | `FightNight`, `Attendance.of` |
| Result and the Why: THE CLUB tile | `"Our show: on the night's sheet"` (no $450 away cut); main-event rep; `"No. 3: 7 wins, a pro offer"`; favour earned | `BoutNight`, `RankLine`, `Favours` |
| The night's sheet | Section 4.10 breakdown + **`Add places`**, **`Review pro offer`**, **`Book next show`** buttons | `ClubShow.settle`, `RankLine.after`, `Region`, `GymSpend.member_limit`, `Favours` |
| World > News & Rankings | Visiting results `"on [club] show"`; rank arrows | `Region._rival_bout`, `Region.rankings` |
| Week review (Monday after) | Net cash & rep with causes; members capped/settled; favours updated | `WeekReview`, `Career.show.night` |
| Club > Money: one-offs & forecast | Deposit; show costs; tickets + $5/seat raffle; likely net in `CashForecast` | `Career.pay`, `CashForecast` |
| Handbook | Club show, Hall, Hold toggle, Main event, Posters & read, Ladder pair, Swap, Standby reserve, Favours, Skills bout, Return bout, Short night | `Handbook` |

**GOLDEN-PATH STEP (task 13):** book Community hall with 2 boxers held and 2 standby reserves; ask No. 3 above (answer no), then ask No. 2 as it is (yes); leave boxer with tight Stamina goal off; pick harder fight week for 0.05 kg over boxer; keep at ticket read; fill final-week pull-outs with reserves; pass day-of weigh-in; fight bouts; verify sheet net vs away, $5/seat raffle, `Add places`, pro offer firing on the night, and favours rising `+1` (capped at 2).

---

## 8. Build tasks (under 500 lines each, one owner, red test first)

| # | Task | Owner | Owns | Red test first |
|---|---|---|---|---|
| 1 | `RANKTIE1`: ours use `BoutRules.fight_power` (no camp) as `rating` | Qwen | `Region.gd` (~15), `tests/rank_tie_test.gd` | `"ours with higher power wins rank tie"` |
| 2 | `MOODIDLE1`: `month_no_fight -6` caller on day 30 without bout | Qwen | `Roster.gd` (~15), `tests/mood_idle_test.gd` | `"30 days without bout costs 6 morale"` |
| 3 | `DATAFIX1`: regional opponents use local clubs | Qwen | `Data.gd` 66–185 | `"all London rivals carry regional clubs"` |
| 4 | `HOLD1`: card names + locked reserves busy at region shows | Qwen | `Region.gd` `day_events` (~10) | `"opponent on our card skips Sat region show"` |
| 5 | `GOALFIX1`: stat goals judge at deadline only; rename to `Stamina` | Qwen | `BoutNight.gd`, `FighterGoal.gd` (~35) | `"Stamina goal judges at deadline, not mid-week bout"` |
| 6 | `Favours` + `WeighOdds` (pure: cap 2, 26-wk lapse, service earn; twist weigh roll) | Qwen | `Favours.gd` (~140), `WeighOdds.gd` (~90) | `"cap 2, lapse 26 wks"`, `"65.05 misses on cold twist"` |
| 7 | `ShowCard` + `RankLine` (single rank prob + hover tree, `BoutRead.band`, 64% joint swap, reserve slots) | Qwen | `ShowCard.gd` (~340), `RankLine.gd` (~140) | `"single rank prob matches 1,000 replayed seeds"`, `"joint swap 8x8=64"` |
| 8 | `HOSTPROBE1` (pure, cloud) | Goose | `tools/host_probe.gd`, `ops/research/HOSTPROBE1.md` | Section 9 bars |
| 9 | `ClubShow` v2 (halls `x0.8/1.0/1.25`, `places*4` cap, `$5/head` raffle, reserves, short night, `Move down` refund, `settle`) | Qwen | `ClubShow.gd` (~260) | `"Gym floor <16 places disabled"`, `"Town hall half-empty -4"` |
| 10 | `HostShow` state (asks, 25% pull-out + reserves, day-of weigh-in branch in `Bouts.weigh`, corner accept, rematch lock 4–12 wks, skills bout no-result) | Claude | `HostShow.gd` (~450), small `GymSpend.gd` / `Bouts.gd` edits | `"promised rematch locks offers until fought"`, `"day-of weigh-in runs on show day"` |
| 11 | `OurShow` UI (Look B whiteboard, S448 headers only) | Cursor | `OurShow.gd` (~460), `OurShowTiles.gd` (~320) | `tests/our_show_screen_test.gd` |
| 12 | Needs, top bar, Money row, People favours, NEXT BOUT, Sheet actions, Week review, Handbook | Cursor | `Needs.gd`, `HomeNeeds.gd`, `ClubSpend.gd`, `ShowSheet.gd` (~320) | `tests/host_show_needs_test.gd`, `tests/show_sheet_test.gd` |
| 13 | Golden path (section 7) | Grok Dev | `tests/host_show_golden_test.gd` | Full show flow |

**Order:** 1–5 first (world + goal fixes), 6 + 8 + 7 + 9, then 10, then 11–12, then 13. Ships ON (`GameSwitches.GAME_ON`).

---

## 9. Probe bars (`HOSTPROBE1`, before any screen ships an ESTIMATE)
- **Favours scarcity:** across a full season, club favours earned average **4–6/yr** across all clubs; `"as it is"` beats `"with a favour"` in at least **1 of 3** asks; swap is best in **<= 2 of 3** ladder cases.
- **Hall spread:** across `young (40/10)`, `mid (58/24)`, and `grown (120/60)` clubs, **each hall wins** for at least one club; Gym floor never dominates mid/grown clubs on net cash.
- **Boxer routes:** across `(strong, weak, wants nationals) × (0, 1, 2 favours)`, each route (`above as-is`, `favour`, `promise`, `below`, `below+swap`, `wait`) wins at least once and <= 50%.
- **Weight answers:** across `0.05 / 0.25 / 0.65 kg` over × `(0, 1 favour)`, each of `Keep`, `Ask corner`, `Harder week`, `Stand down` wins at least once.
- **Boxer C:** across `(goal safe Steady) / (goal safe Flat) / (goal tight)`, each of `Novice`, `Skills bout`, `Leave off` wins once.
- **Rank accuracy:** printed `"No. 3 or better: N in 100"` matches `Region.rankings` within 1% across 1,000 seeds.
- **Cut rule:** any choice worth `<$150`, `<1` rep, and `<3 in 100` pro offer is cut.

---

## 10. The 10/10 page at 1920×1080 (`Fights > Our show`, 16 days out, Look B whiteboard)

*(No person's name outside each face card's own header; zero fixed `he`/`she`.)*

- **Shell & header strip (96 px):** dark top bar + left rail (`Fights` active). Look B tan plaster wall, aluminium-framed whiteboard. Club crest, `"Our show"`, circled marker date, hall + seats + ticket price, days out, magnet timeline (`Asks close` · `Posters & Read` · `Region show` · `Day-of weigh-in` · `Show night`).
- **Left column (520 px) — `OUR BOXERS`:**
  - Stacked polaroid/card rows per boxer: face card (**name in header only**), day-of weight forecast vs limit, condition/morale/goal chips, **Hold for our show** toggle.
  - Under each: up to 3 route tiles. Opponent face card (**name in header only**), `Yes`, `Wins N in 100 (band)`, **`No. 3 or better: N in 100`** (hover opens condition tree), `Pro offer: N in 100`, seats. Ask pills inside tile (`As it is` / `Favour` [notes `"also half the swap"` if shared] / `Promise ["Locks next bout (4-12 wks)"]`).
  - Four weight answers on the row with miss odds (`Keep`, `Ask corner`, `Harder week`, `Stand down`).
- **Centre column (840 px) — `THE CARD & LADDER`:**
  - Cream bout sheet: our bouts in red marker, visiting pairs in pencil, main event boxed; **2 Standby reserve slots** (`$40` standby, role/band shown).
  - Division table beside it with movement arrows from our night and the region's show.
  - Highlighted Ladder pairs with inline swap buttons printing **`64 in 100`** joint yes and favour cost (`-1` each club).
- **Right column (560 px) — `THE NIGHT`:**
  - Segmented seats bar (club / followings / posters / visitors) with `Half-empty (50%)` and `Full (85%)` ticks.
  - Net cash vs `$900` away (likely / bad / good night, `$5/seat` raffle shown).
  - Reputation parts + `member_limit` readout with **`Add places`** link when capped.
  - Scarce Favours ledger (`0–2`, expiry weeks, how earned).
- **Bottom strip (120 px):** assistant coach portrait + one-line note (no names, no pronouns), `Back to coach's card`, and **one** pulsing green `Send the asks` (`Continue`) button.

---

## 11. What was rejected, and why
- Unlimited favour gain (`+1` on every clean bout) -> made favours free; replaced by service-only earn + cap 2 + 26-wk lapse.
- Flat `$600–$1,400` raffle and `$35` gym-floor ticket -> made Gym floor dominate mid clubs; replaced by `$5/seat` raffle, `$25` ticket, and `x0.8/1.0/1.25` hall reach.
- Judging stat goals on bout night -> artificial penalty on Boxer C; replaced by `GOALFIX1`.
- `"Ana sells"` -> broke S448/S412; renamed `"A no-gi athlete sells"`, conditional on roster and honestly priced.
- Catchweights, asking two names at once (owned by `R37`), pro cards/belts/TV, BJJ bouts on the boxing show, `$120` travel bribe -> rejected for scope/dominance.

## 12. Risks, said plainly
- **Build weight:** 13 tasks (5 world/goal fixes + 8 show tasks); tasks 1–5 improve the core game independently and should land first.
- **Day-of weigh-in branch (`Bouts.weigh`):** home shows weigh on show day while away offers remain day-before unless away amateur shows later unify under England Boxing 7.1.3.
- **25% pull-out rate + 2 reserves:** makes fight week active rather than automatic, but must be tuned in `HOSTPROBE1` so cards do not collapse unfairly when reserves are used properly.
- **All `ESTIMATE` numbers** (hall multipliers, raffle per head, 26-wk lapse, 7-in-10 corner accept, 8-in-10 swap) remain unverified until `HOSTPROBE1` runs.

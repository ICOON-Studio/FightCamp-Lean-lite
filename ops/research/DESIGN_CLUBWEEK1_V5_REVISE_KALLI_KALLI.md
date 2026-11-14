# DESIGN_CLUBWEEK1_V5_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ87)

Brief: research/DESIGN_CLUBWEEK1_V5_REVISE_KALLI.md
Sent: 2026-11-14 01:11 | collected: 2026-11-14 02:11 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

# CLUBWEEK1 v5: the club week for four, with the fight weeks inside it, and the season around it (S459)

Part 1 of 3

**Quoted owner rules carried in this map:**
- **Q-190 (S434/S435):** `"Just rename it 'gym sponsorship', the club pays."` What earlier drawings called `PAID SEAT` is `GYM SPONSORSHIP` (short: `sponsorship`), never mixed with Sponsor deals (`Club > Money`).
- **S448 (names only in headers):** `"notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule"` — a person's name sits in a card or screen header once; rows, buttons, options, tooltips, Home notes and Why lines say `your boxer`, `the fighter`, `the grappler`, `a team-mate`, `your coach`, or `the opponent`.
- **S412 (sandbox):** `"the player runs any gym with any boxers, men or women."` Never write about one fighter as the story, and never use a fixed `he` or `she` in text or mockups.
- **S425 (menu wiring):** keep the table of every menu the mechanic appears on and what each is wired to.
- **S459 (bar):** must clear 6+ DEPTH and 6+ GENERAL DESIGN with fresh critics; mark which numbers are **ESTIMATE**; stay buildable from what the game has.
- **Owner's line-up & terms kept:** professionals in the line-up with an amateur-to-pro guide; staff named by role (`Coach`, `Coach's evenings`); `Stamina` for the endurance attribute (`Attrs.gd`, S448); amateur weights in **kg** (`57/60/65/75 kg` women, `57.5/60/70/75 kg` men). `"Coach"` is the hired assistant coach; `"You"` is the head coach (the player).

**Marks:** **CODE** = in the code today (file and symbol named). **ESTIMATE** = ours, verified by section 8 probes before UI ships. **NEW** = rule added by this map.

**Source status note:** Revises `CLUBWEEK v4.1` (`S432`) after `LOYAL1_RESULT.md` (`S461` Qwen probe + `S462` Claude rerun & direction), updated against the S403 critic pack (with S409, S410, S448, S451 additions). `CRITIC_ACCESS.md` and the Miro board were not opened directly.

---

## 0. Answer to `LOYAL1_RESULT.md` (S461) and Claude's S462 direction

| Probe finding / suggestion | Change in v5 (or one-line reason why not) |
|---|---|
| **Claude (S462):** `4 starters × 3 pads = 12 asked vs 8 owned` is structurally short every week; split into **NEED = 2** (`short` = under Need), **WANT = 3rd** (decided by deal order), real shortage on fight weeks (`+2`) | **Done (3.1, 3.8, 8).** Every evening slot is unified as an **evening place** (`8` owned: Coach 6 + Head coach 2; pad places for boxers, coached mat places for the grappler). Ordinary week: **Need = 2**, **Want = +1** (`3` asked). `4 × 2 = 8 Need == 8 owned` (0 forced short in ordinary weeks), while `4 × 3 = 12 Asked > 8 owned` (`asked > owned` 100%). Shortage and rotation now happen in **fight weeks (`+2` Need -> 10)**, **Peak camps (`+1` Need -> 9)**, and **class nights (`-2` owned -> 6)**. |
| **Qwen (`SHORTWEEK1`):** reduce `ASK["ordinary"]` to 2, OR raise owned to 12, OR lower holder threshold | **Solved cleanly via Need/Want split (3.1).** `NEED = 2` solves `SHORTWEEK1` (`COACH max run short <= 2`) without losing scarcity (`WANT = +1`, total `12` asked > `8` owned) and without inflating owned to 12 (which would kill the Coach's evenings money tension). |
| **Qwen (`LOYAL1`):** fix pad scarcity OR change `MOVES["short"]` (`-3` to `-1/-2`), `MOVES["full_week"]` (`+1` to `+2/+3`), or `LEAVES_UNDER` (`25` to `15/20`) | **Kept `short -3`, `short_running -6`, `full_week +1` (all Need covered), `LEAVES_UNDER 25`, and added `want_met +1` extra (3.1, 3.8).** With `Need = 2`, ordinary weeks grant `full_week +1` to all 4 fighters so `EVEN` stays `> 60`, `COACH` rotates fight-week shortages (`>= 50`), and `STARVE` drops **only** the starved fighter below 25 (`1` lost per seed, not 4). Re-measured in `LOYAL1` rerun (section 8). |
| **Pack alignment fixes (S412, S448, S450, S451):** remove names outside headers, pro class words on amateurs, `"Cardio"`, stale `"FireLevel switched off"`, and note `4` starter places vs `3` in `GymSlots` | **Done (1, 2, 3–7).** Starter names sit only in Create/Profile card headers; body text uses roles/pronouns; amateurs use kg classes (`57/65/75/60 kg`); `"Cardio"` updated to `Stamina` (`Attrs.gd`); `FireLevel ON` (`S450`) noted; `ClubStart` sets `STARTING_PLACES = 4` (**NEW**) at Unit 1. |

---

## 1. The idea in six lines
1. Four fighters stay at the club you take over in four weight classes: **one professional boxer, two amateur boxers, and one no-gi grappler** (`ClubStart` overrides Unit 1 places to **4**, **NEW**).
2. Every Monday, **Club week** deals three scarce pools across the squad: **evening places** (pad places for boxers, coached mat places for the grappler), **coached mornings**, and **gym sponsorships**; **Asked** (`Need + Want`) is always above **Owned**, and Coach's evenings can be sold as a second beginners' class instead (**the money lever**).
3. A bout stays on the same board: an amateur's **fight week** (`12` days' notice, no camp, `+2` evening Need) and a professional's **camp** (`4` or `6` weeks, `+1` evening Need in Peak) create the real shortages that drive deal-order choices.
4. **Favours** (`0–3`) are the second currency: earned by helping other clubs, spent to bend bout terms (never a win).
5. What lasts past the week (**NEW**): **loyalty** (short weeks under Need, promises, sponsorships), **fans** (home bouts build the crowd that funds the pro debut), and **one season target** per fighter.
6. No Monday repeats: job rotas shift, one club twist lands, a trial prospect visits every 4 weeks, and the opposing corner has had a week too.

---

## 2. The start (`Create, step 2`, names in card headers only)

All six starters sit in different weight classes so no pick blocks another. Each fighter's name appears **once** in their card header; card bodies use role, division, record, and that fighter's own traits.
- **ONE PROFESSIONAL** *(pick 1 of 2; new starter data: 9-win amateur offer cleared, `1-0` pro, licensed, unranked, carried-over amateur fans)*:
  - **Pro slot A:** women's `60 kg`, age 21, out-boxer, potential 84, **34 fans**, full sparring with Amateur slot A & D (**ESTIMATE**).
  - **Pro slot B:** men's `70 kg`, age 23, southpaw pressure fighter, potential 79, discipline 80, **22 fans**, full sparring with Amateur slot C; opens with second pro bout booked `6 weeks` out (**ESTIMATE**).
- **TWO AMATEURS** *(pick 2 of 4; weights in kg)*:
  - **Amateur slot A:** women's `57 kg`, `1-0`, college rota.
  - **Amateur slot B:** women's `65 kg`, `2-1`, shifts rota, loyalty `82`.
  - **Amateur slot C:** women's `75 kg`, `6-4`, office rota, loyalty `66`.
  - **Amateur slot D:** men's `60 kg`, `2-1`, shifts rota, loyalty `58`.
  *(Each card shows job rota, free mornings, sponsorship line, eligible sparring partners, fans, and `Recruit.ambition`.)*
- **THE GRAPPLER:** white belt, 2 stripes, cafe rota; already on roster; first open Sat 7 Feb.
- **Staggered opening:** the unpicked amateurs return on the trial mat; pro opens in camp, one amateur has a bout sheet (Sat 17 Jan), the other has an active goal. Loyalty starts from `Recruit` data (`58–82`).

**THE GUIDE IN WEEKS 1–5** *(step-by-step highlight; skippable; names never used outside headers)*:
1. **MEET THE FOUR:** badge (`PROFESSIONAL` / `AMATEUR` / `GRAPPLER`), season target, one key line.
2. **THE ROAD, AMATEUR TO PROFESSIONAL** *(adds fans + debut ticket forecast)*:
   - `"AMATEUR: 3 rounds, no purse. A home bout pays the club a $450 ticket cut and builds the boxer's own fans."`
   - `"THE OFFER: arrives at 7 wins with a top-3 regional rank, or 9 wins at any rank. A national finalist gets it at once."`
   - `"SAYING NO: returns after 2 wins at 90% terms; second no returns only at No. 1; third never."`
   - `"TURNING PRO: the club pays $1,105 (licence $230, medicals $875). Gym sponsorship stops; amateur bouts end."`
   - `"THE DEBUT: 4 weeks after signing, 4 rounds, paid from tickets: 100 tickets at $50 (20 family + boxer's fans + 25% of club members; under 60 pays nothing; boxer keeps half above 60, club takes 25% of that half)."`
   - `"FROM THE SECOND BOUT: purse ($1,500 unranked + $400 per place from No. 20 up), club keeps 25%; 6 weeks' notice and a camp; promoter brings three offers."`
3. **DEAL THE WEEK:** walks sponsorship -> pulls -> evening places -> bout sheet. 4. **ANSWER THE CALL.** 5. **START WEEK.**
*(After week 1 the guide names the trade, never the answer, and stops after the 3rd fight week.)*

**THE REVEAL ORDER (NEW):**
| Week | Arrives | Guide line |
|---|---|---|
| 1 | Evening places (`Need` vs `Want`), first bout sheet, season strip (locked to ambition) | `"Eight evening places, eight needed, twelve asked."` |
| 2 | Coached mornings; Coach's evenings: training or second class | `"A class pays the rent. Pads and mat work win bouts."` |
| 3 | Club twist, gym sponsorship, sparring setting | `"Hard sparring builds more and cuts more."` |
| 4 | Favours (first earned on sheet); loyalty bar appears and starts moving | `"Whoever goes under their need remembers it."` |
| 5 | Trial mat; season targets unlock; talk card can arrive | `"One target per fighter: the date every Monday works toward."` |

---

## 3. The week, as the player meets it

### 3.1 What is short (counters at top in ONE unit, `fighter-sessions`: `NEED / ASKED / COVERED / SHORT`)
- **EVENING PLACES (pad places for boxers, coached mat places for the grappler; `8` owned):** Coach works `3` evenings (`first hour` = existing `+$350/wk` members' class **CODE**; `second hour` = **2 evening places** OR **second class**, 3.1a). You hold **2** evening places on your own evening (`8` total).
- **NEED vs WANT split (NEW, answering `LOYAL1_RESULT` & S462):**
  - **Ordinary week (`BASE` / `BUILDING`):** **Need = 2**, **Want = +1** (`3` asked). Across 4 starters: **8 Need == 8 Owned** (no forced shortage), **12 Asked > 8 Owned** (`100%` of weeks have real prioritization).
  - **Amateur fight week (`12 days out`):** **Need +2** (total `4` Need, `5` asked). **Total club Need rises to 10+**, creating real shortages!
  - **Pro camp Peak week (week -2):** **Need +1** (total `3` Need, `4` asked).
  - **Trial prospect (`every 4 wks`):** **+1 Want** on the evening pool (doesn't force starter shortage; competes for Wants).
  - **Film evening:** takes **2** places (1 whole Coach evening) when chosen on the fight-week bill.
  - **Talk (`Wants a word`):** takes **1** of your own evening places (except `Tell it straight`).
  - **REST week:** **0 Need, 0 Asked** (frees 2 Need for teammates in fight weeks or class nights!).
- **What Need vs Want buys:**
  - **Meeting Need (`2`):** maintains skills/moves, avoids loyalty penalty (`full_week +1`, **ESTIMATE**).
  - **Going `SHORT` (`covered < Need`):** costs loyalty (`-3`, `-6` running, waived `1 week in 4` if `Loyal 70+`, **ESTIMATE**). Missing a **Want** (`3rd` place) costs **0 loyalty** — its cost is slower mastery/pull progress (`0.7` on 4th, `0.5` on 5th) and missing the `+1` extra loyalty from `want_met`.
  - **Holding pads (`Loyal 70+` & `6+` bouts):** `+1` pad place at `0.7` (`holder` loses own evening, loyalty `+3/wk`, max `4` wks running).
  - **Uncovered evening:** trains alone at mood rate (3.7) unless job rota blocks the evening.
- **COACHED MORNINGS (`6` owned: You 4, Coach 2):** 1 covers 1 fighter in full; 2 fighters on one morning share automatically at `0.8` each (`2` covered, not a choice). Alone trains at mood rate (3.7); discipline `<45` skips `1 in 3` alone mornings unless a teammate trains in the room.
- **GYM SPONSORSHIPS (`Q-190`):** 4-week block, **$1,000**, 6 free mornings/wk, removes job rota, loyalty `+5`. Amateurs & grappler eligible; pros cannot hold one. Block end (**NEW**): `Renew ($1,000, +2 loyalty)`, `Pass on (+5 to receiver, 0 lost)`, or `Let end (0 lost)`. Pulled early: `-8`. Potential `80+` unsponsored for 8 wks asks for one (`-3/wk` until seated or dated promise).

### 3.1a Coach's evenings: training or second class (**NEW**, money lever)
- **Choice:** each of Coach's 3 second-hours switches between **Training (2 evening places)** or **Second class** (`+$117` that night + `~1` new member per `4` weeks taught, **ESTIMATE**). Your own evening can also switch (`2` places <-> `+$117` + members).
- **Why it binds:** Selling 1 class night drops owned evening places from **8 to 6**, turning ordinary `8 Need` into **1 fighter short** unless offset by a `REST` week, a `Loyal` holder, or `COACH` short-rotation. `MONEYFOUR2` tests `1 sponsorship (-$100/wk) + 1 class (+$117/wk)` keeping the bank level.

### 3.2 What is dealt: each fighter's pulls
Priority warnings first: Scale (over limit inside 14 days), Fight (last 7 days), Rest (`tiredness >= 70` or hurt), Punished Habit (`6` of your own places). Then pulls with **size as a range** (**NEW**, measured by probes, colour-coded per currency, never mixed):
- **WEAK SPOT:** lowest of the `14` `Attrs.gd` abilities when `>= 3` below fighter level; from bout 3 opponent exploits it (`+0.25` per point under from round 2, unless covered by a plan line).
- **WEAPON:** stat gating next perk (`"Fast hands at Speed 70: ~4 wks"`).
- **GOAL:** active fighter goal (`+10` met / `-20` missed, **CODE**; bout/win goals judge on fight night, stat goals at deadline per `GOALFIX1`).
- **AHEAD:** next rival up the ladder and answers owned.
*(Pull asks `2` coached mornings, or `2` evening places for Ahead; sponsored holds `2` pulls, day-job holds `1`.)*
Three one-click deal modes: **By hand**, **Keep my changes** (keeps edits, updates rota/twist), **Coach deals it** (prints range delta `"Coach's deal: 2 to 3 in 100 below yours"`).

### 3.3 The rota that moves (dim, 1 line, non-clickable)
- **Shifts** (alternates early/late: earlies lose weekday mornings; lates lose weekday evenings), **College** (Tue/Thu mornings free, exam fortnight 2/wk, holidays all free), **Office** (weekday mornings gone), **Cafe** (every other Saturday). Pro `< top 10` keeps day job (or takes **Camp leave** in 3.9); top 10 trains full-time.

### 3.4 One club twist a week (**NEW**, deck of 12, replaces personal `WeekTwist`)
1 in 4 weeks quiet; never twice running; 2–3 priced answers hitting shared slots/cash/loyalty/favours (`Clock` waits for answer; Monday default = Coach picks):
- Coach off Wed (`-2` places / `$80` cover / senior holds both); Coach stays late Thu (`+2` places for `$60` / pass); Overtime on Sat (take it / ask them to train `-2` loyalty); Visiting pro spar (who gets it); Boiler out Thu (no mornings); Another club asks a kilo; Local paper photo (`+2` members, `1` place); Short-notice call (`+2` favours, no fight week); Sponsor photo (`$150`, `1` pro camp evening); Hall floods (Mon class off, `-$117`); Member's family pad session (`1` place, `+1` member); Quiet week.

### 3.5 Favours, the second currency
`0–3` dots per show club:
- **Earn:** `+1` box on their show / late replacement / sparring trip (`1` of your places) / give a kilo; `+2` 4-day short-notice call.
- **Lose:** `-1` miss weight / pull out (no penalty if *their* boxer pulls).
- **Spend:** `-1` ask a kilo / re-deal sheet / ask named opponent / move bout 1 wk.
- **One kilo rule:** over `1.0 kg` gap on fight day, ask `1` favour (`-1` asker, `+1` giver) for `+2` tank per `0.5 kg` heavier (`WEIGHTGAP1`). Never buys wins, judges, ranks, or places.

### 3.6 The squad changes, sparring and the grappler
- **TRIAL MAT (every 4 wks):** prospect visits 2 wks (`+1` Want evening place/wk). **`Watch`** sits on the trial card only (`2` coached mornings over fortnight -> exact potential, else ranges). Sign (`5th` fighter needs 2nd coach `$280/wk`, bigger unit, or 1 leaves) or Pass.
- **SPARRING (pair picker + setting on Club week, NEW):** `<5 kg` apart full both; `5–10 kg` lighter full / heavier half; `>10 kg` lighter `+10` tiredness. Setting: **Hard** (`×1.3`, `+12` tiredness, `4 in 100` cut), **Technical** (`×1.0`, `+6`, `1 in 100`), **Body only** (`Stamina`/body `×0.8`, `+8`, `0` cut). `SPARSET1` checks Hard `>= +1.5 in 100`.
- **THE GRAPPLER (no-gi, numbers in CODE unless ESTIMATE):** `3` classes/wk on cafe job (`NoGi.CLASSES_PER_WEEK`), `5` on sponsorship (`+6` tiredness each over 3); coached mat places come from the 8-place evening pool (`Need 2, Want 1`). Can give `1` boxer/wk a `0.8` coached `Stamina` morning (`-1` class). **Open division:** enter `White` (`~55 in 100`, gold `+2` no-gi members) or `Promote to Blue first` (`~35 in 100`, owes `BeltRoad.EARLY_DEBT`, `+3` members, unlocks **Teaching** `+$68/wk` + `~1` member/4 wks, `-1` class). Open shows **`Enter / Skip`** card; **`Who corners`** (`You` or `$100` mat coach) shows only if a boxer also fights that Saturday. Stripe calls (`StripeCall`) move loyalty on the shared scale.

### 3.7 Mood with teeth (**ESTIMATE**, `MOODRATE1`)
`Morale` (`0–100`: `Fired up 75+`, `Steady 50+`, `Flat 30+`, `Low <30`, **CODE**). Deal prices move **loyalty**, not mood.
- **Alone rate (no coach / no evening place):** Fired up `0.8` | Steady `0.6` (**CODE** baseline) | Flat `0.4` | Low `0.4` + skips `1 in 2` alone sessions & passes next bout sheet automatically (free, no favour).
- **Fight night corner trust (**CODE**):** `1.05` / `1.0` / `0.85` / `0.7` (Low stops listening).

### 3.8 Loyalty (**NEW**, `0–100`, `Loyalty.gd` + `LOYAL1`)
Bands: `Loyal 70+` (`"Loyal: can hold pads"` + `1` waived short week in `4`), `Settled 50+`, `Wavering 25+`, `Leaving <25`.
- **Moves (ESTIMATE):** `full_week` (all Need covered) `+1` | `want_met` (Need + Want covered) `+1` extra | `short` (covered < Need) `-3` (waived `1/4` if `70+`) | `short_running` (short 2+ wks running) `-6` | promise kept `+5`, broken `-12` | sponsorship given `+5`, renewed `+2`, pulled `-8` | holding pads `+3/wk` (max 4 wks) | ready sheet passed `-2` | target matches ambition `+5`, against `-5` | target met `+10`, missed `-5` | stripe call now `+3`, hold `-5` | overtime refused `-2`.
- **Talk (`<50`, `"Wants a word"`):** max once per 4 wks per fighter; takes `1` of your evening places except `Tell it straight`:
  1. **Give the place back:** dealt first next week, `+4`.
  2. **Dated promise:** pad/mat place, bout, or sponsorship by date (`+5` kept / `-12` broken; listed on `PROMISES OPEN`).
  3. **Tell it straight (free):** coachability roll (`+4` or `-4`, logged in `CoachNotes`; threshold hidden; `8`-wk cooldown).
- **Consequences:** `<25` after 2 talks -> leaves next Monday for Eastside ABC. Turning pro `<50` -> signs with outside manager (`10%` trainer share to club instead of `25%`, **CODE** `GYM_SHARE`).

### 3.9 Season targets & 3.10 Fans (**NEW**)
- **Season target (unlocked week 5):** Amateurs (`Nationals` / `Pro offer` / `Year to grow`), Pro (`Ranked`: 6-wk camp + step-up / `Busy`: 4-wk Light camp + tune-ups; optional **Camp leave** `$120/wk` last 2 wks if job kept `< top 10`), Grappler (`Medal` / `Blue belt`).
- **Fans:** Home win `+4`, home loss `+1`, away `0`, title `+10` (**ESTIMATE**). Debut sells `20 + fans + 25% of club members + 10/title` (`ProDebut` change); carries into pro `Matchmaking.fans` (tens on screen). `FOLLOW1` verifies always-away fails 60-ticket debut while always-home reaches offer 6+ wks later.

---

## 4. The fight week inside the club week
- **Bout sheet (amateur, 12 days out):** `Home` (`$450` cut, `+8` members, `+4` fans, or **Home on our own show** when `ClubShow` is booked — each home boxer brings `PER_HOME_BOXER 25` + fans), `Name above` (away, `-$40` travel, `+1` favour, takes rank up to `3` up), `Unknown` (away, `28`-pt band, opens file). **Pass** holds a name `7` days, costs `-2` loyalty; 2nd pass `-1` favour. **States:** `Ready` (sheets), `Building` (no sheets, `1.1×`), `Rest` (`2` wks post-bout, `0` evening Need, Light mornings, `+4` mood/wk).
- **Scale (4 pm fight day, `1.0 kg` gap):** over gap -> `Eat less` (`-1` tank/`0.1 kg`), `Train off` (no gain, `+5` tiredness/`0.25 kg`), `Ask a kilo` (`1` favour, `+2` tank/`0.5 kg`).
- **Fight-week evenings & bill:** `2` plan lines = `1` place, finish move = `1` per `4.5` mastery short, southpaw rounds = `1`, film = `2`, sharp last 3 days = `1`. **Legs** (`0–100`, tiredness over `50` + weight cut + recent bout, max `-25`). Shapes: `Rest up` / `Tick over` / `Train through`. Bill prints **ONE** range (`"Your week vs Coach's: +2 to +4 in 100"`) + top 3 levers (`Coach runs it` fills Coach's week). Pull-outs (`15 in 100`): replacement, another `Ready` boxer, or home.

*(Pro vs Amateur side-by-side table unchanged in rules from v4.1, using `Stamina`, `kg` classes, `Need +1` Peak camp, `$40` away travel, `+4` home-win fans, `Camp leave`, and `9` expected amateur bouts/yr.)*

---

## 5. Every decision (summary of Section 3 & 4 trades; `"Right when"` stays off UI)
| When | Decision | Options & prices | Probe / Right-when check |
|---|---|---|---|
| Create | Pro (1/2) & Amateurs (2/4) | Weight classes, sparring pairs, fans, ambition | Balanced spar partners & mix of near-pro + high-potential |
| Week 5+ | Season target | Nationals / Pro offer / Grow; Ranked / Busy; Medal / Blue | Matches bout window, bank runway & ambition |
| Monday | Deal mode | By hand / Keep my changes / Coach deals it | Coach deals it when within `1 in 100` |
| Monday | Coach's evenings (`NEW`) | Training (`2` places) vs Second class (`+$117`, `~1` member/4 wks) | Class when runway `<8 wks` or `REST` frees Need |
| Monday | Evening places (`8` vs `8 Need` / `12 Asked`) | `Need (2 / 4 fight wk)` vs `Want (3rd+)`; `Hold pads (70+)` | `COACH` rotates fight-week shortages (`<=2` run) |
| Monday | Sponsorship & block end | `$1,000 / 4 wks`; Renew / Pass on / Let end | Seat on high-potential with bouts; renew/pass by target |
| Monday | Coached mornings (`6`) | `1.0` solo vs `0.8` auto-shared | Solo on fastest-growing or Flat/Low |
| Monday | Pulls, Sparring, Twist, Talk, Trial | Sizes as ranges; `Hard/Tech/Body`; 12 twists; 3 talk answers; `Watch` on trial card | Verified by `WEAKFIND1`, `SPARSET1`, `ROTATWIST1`, `LOYAL1` |
| Sheet / Bill / Open | Home / Away / Rest / Bill / Ana's open | `$450`+fans vs rank+favour; `Enter/Skip`, `White/Blue`, `Who corners` | Verified by `SHEETDEAL1`, `FOLLOW1`, `TANKPRICE1` |

Part 2 of 3

## 6. Every menu it appears on, and what each is wired to (`S425` + `S448` names only in headers)

*(All rows, buttons, tooltips, and Home/Why notes below keep people's names strictly in card headers.)*

| Menu | What it shows (actionable only; names in card headers only) | Wired to |
|---|---|---|
| **Create, step 2** | Pro (1 of 2), Amateurs (2 of 4), Grappler fixed; spar links, job rota, free mornings, sponsorship, fans, ambition | `CreateScreen`, `ClubStart` (`STARTING_PLACES = 4`), `Data`, `Roster.sign_fighter`, `Recruit.ambition` |
| **The guide (wks 1–5)** | 5 steps; road strip with squad's own cards & fans; reveal order (`Need/Want` wk 1, classes wk 2, twist/sparring wk 3, loyalty/favours wk 4, targets/talks wk 5) | `GuideLight`, `GuideLines`, `FirstWeekStrip`, `FirstWeek`, `FirstHour`, `NextStep.STEPS`, `Roster.pro_ready`, `ProDebut` |
| **Fighters > Club week** | `THE SEASON` strip; unified counters (`Need / Asked / Covered / Short` in `fighter-sessions`: evening places, coached mornings, Coach's evenings class switches, sponsorships + block end, favours, trial mat); 4 fighter rows (header name only, badge, mood word, loyalty bar, job/sponsorship, diet Hold/Cut, pulls with range sizes, 7 days + sparring pair/setting); talk card + `PROMISES OPEN`; club twist; top 3 levers + deal delta vs Coach's; 3 deal buttons; `Start week` | `ClubWeek` screen, `ClubDeal` (`NEED`/`WANT`, shared evenings/mornings, class switches), `WeakSpot`, `JobRota`, `ClubTwist`, `Favours`, `TrialMat`, `Loyalty`, `SeasonTarget`, `SparSet`, `LeverSize`, `WeekPlan`, `PadWeek`, `CoachAreas`, `TrainRead`, `WeekPhase`, `GymSpend`, `Attrs`, `FighterProfile.mood`, `DuesLevers.CLASS_WEEKLY`, `SeasonPath`, `BjjSide`, `CoachNotes` |
| **Fighters > Find a fighter (trial)** | Prospect card (name in header only), stat ranges, `Watch` (`2` mornings), Sign / Pass, 5th-fighter requirement | `RecruitPanel`, `Recruit`, `Trial`, `Roster`, `GymSpend.place_blocked`, `TrialMat` |
| **Home** | One row per fighter (card link in name column only, open pull size, days to bout, `"Wants a word"` sticky); call deadline; sponsorship end | `Home`, `HomeRows`, `HomeNeeds`, `Needs`, `Loyalty` |
| **Fighters cards** | Badge (`PRO` / `AMATEUR` / `GRAPPLER`), loyalty word, sponsorship/job status, flag (`Fight week`, `Set camp`, `Wants a word`) | `Fighters`, `RosterCards`, `FighterCard`, `RosterFlag`, `CoachCheck`, `Loyalty` |
| **Fighter > Overview** | Season target + date; pulls (range sizes + buttons); weak-spot cost; `Stamina`; mood (alone rate); loyalty (last 3 moves, `"Loyal: can hold pads"`); fans + debut forecast; road strip | `FighterPage`, `DarkOverview`, `AttrBoard`, `Attrs`, `Duels`, `TrainRead`, `PerkRoad`, `NextStep`, `Loyalty`, `Fans`, `SeasonTarget`, `ProDebut` |
| **Fighter > Training** | Own slots at mood rate; shared slots locked (`"Change on Club week"`) | `WeekBoard`, `WeekEditors`, `WeekDay`, `WeekCards`, `SparSet` |
| **Fighter > Fight prep** | Amateur: fight-week bill with 1 range; Pro: 4-wk Light (`Busy`) / 6-wk (`Ranked`) camp, sparring setting, `Camp leave` | `FightPrep`, `FightWeek`, `LeverSize`, `Camp`, `CampCard`, `PeakCamp`, `CampForecast`, `SparSet`, `SeasonTarget`, `GymSpend` |
| **Grappler page** | 3/5 classes, drills + dates, mat morning, open division (`White`/`Blue` odds), teaching (`$68` + members), stripe loyalty, `Enter / Skip`, `Who corners` (if boxing clash) | `GrapplerPage`, `Grapplers`, `NoGi.win_chance`, `BeltRoad.EARLY_DEBT`, `BjjSide`, `BjjTree`, `BjjOpen`, `StripeCall`, `Loyalty` |
| **Fights (amateur)** | Bout sheet (3 cards: win band, rank, `$450`/fans or `-$40` travel, stoppage risk, file, Legs, kg/bouts); `Home on our own show` when booked; favour dots; `Ready / Building / Rest`; grappler's open card; compare view; `"Ask for this name: 1 favour"` | `Fights`, `OfferCard`, `BoutCompare`, `Bouts`, `Region`, `RankLine`, `OppFile`, `AmateurBooking`, `InjuryRoll`, `BoutSheet`, `Favours`, `Fans`, `ClubShow` |
| **Fights (pro)** | Promoter's 3 offers + ask beside amateur sheets; ticket money from fans | `ProFights`, `ProLadder`, `Matchmaking.pay_of`/`fans`, `StarDeal`, `Fans` |
| **Bout page: the bill** | Scale (`Eat less`, `Train off`, `Ask kilo`), fight-week evenings, `Legs` bars at first bell, bring `4 of 6`, **1** range (`Your week vs Coach's`) + top 3 levers, `Take / Coach runs it / Pass` | `BoutPage`, `FightWeek`, `LeverSize`, `BoutRules`, `BoutRead`, `PadWeek`, `PlanBoard`, `PlanLines`, `TaleOfTape` |
| **Tape room** | Question & answer (`best punch` / `habit` / `their week`); stale mark | `TapeRoom`, `OppFile`, `TapeClips` |
| **Playbook, Game plan** | `"Bring this line"` tick, opponent-seen eye icon, `"2 evening places short"` | `Playbook`, `GamePlan`, `GamePlanRows`, `PlanBoard`, `PlanLines`, `MoveMastery` |
| **Club > People** | Coach card (evenings as training/class, places count); 2nd coach (`"Opens 5th place"`); grappler as beginners' teacher from blue | `Gym`, `StaffCard`, `StaffRoles`, `CoachAreas`, `ClubDeal`, `BjjSide` |
| **Club > Money** | Class nights (`+$117` + members later); sponsorships (`4-wk` blocks); home cut vs away travel; own show `Home` cards; grappler teaching; pro share (`25%` or `10%`), camp bill & `Camp leave` | `Money`, `MoneyPanels`, `GymBills`, `GymSpend.pro_camp`, `CashForecast`, `StarDeal`, `DuesLevers`, `BjjSide`, `ClubShow`, `Membership` |
| **World > Rankings & Champs** | Regional & national ladders lit; club favour dots; nationals as fight weeks | `World`, `WorldLadder`, `Region`, `RankLine`, `ProLadder`, `NationalsView`, `Champs`, `ChampDraw`, `SeasonPath`, `SeasonTarget` |
| **Top bar & Continue** | Flags `FIGHT WEEK`, `SET CAMP` (pro only), `PRO OFFER`, `WANTS A WORD`; stops on pull-out, 4-day call, scale > gap, twist, sponsorship end | `Shell`, `Needs`, `Clock` |
| **Fight night & Why** | Day-of scale + kilo; corner choice; Why sizes (`"Legs: −9 tank"`, `"Give a team-mate the place back"`, `"Rest 2 wks"`), rank, fans, deal delta | `FightNight`, `WeighIn`, `Bouts.weigh`, `BoutNight`, `CornerTrust`, `CornerJobs`, `FightWhy`, `WhyCard`, `AftermathTiles`, `RankLine`, `Fans`, `LeverSize` |
| **Monday Week review** | Shortages vs Need (`loyalty` price + `"Give it back"`); month deal vs Coach's; trial read; targets met/at risk | `WeekReview`, `ReviewReveal`, `WeekActual`, `WeekCause`, `Loyalty`, `SeasonTarget`, `LeverSize` |
| **Pro offer** | Debut ticket forecast from fans, `$1,105`, share (`25%` or `10%` by loyalty), what ends, 3 no answers, road strip | `ProOffer`, `ProDebut`, `Roster`, `Matchmaking.pay_of`, `Fans`, `Loyalty` |

**THE NEW MECHANICS, MENU BY MENU (each verified in golden-path test):**
| Mechanic | Menus | Wired to |
|---|---|---|
| Evening places (`Need` vs `Want`) & Coach's classes | Club week counter; Club > People; Club > Money; Week review | `ClubDeal`, `DuesLevers.CLASS_WEEKLY`, `GymBills`, `CashForecast`, `Membership` |
| Mood with teeth | Club week alone cells; Training; Overview; Fights (`Low` auto-pass); Fight night | `FighterProfile.mood`, `TrainingWeek`, `BoutSheet`, `CornerTrust` |
| Loyalty (`Loyal` holds pads + `1/4` free short; `Tell it straight`; `PROMISES OPEN`) | Club week rows, talk card, `PROMISES OPEN`; Home; Fighters flag; Overview; Week review; Pro offer; Grappler stripe call | `Loyalty`, `FighterProfile`, `StripeCall`, `Roster.GYM_SHARE`, `Region`, `CoachNotes` |
| Season target (`Busy`/`Ranked` + `Camp leave`) | Club week strip; Overview; Championships; Week review; Create; Fight prep; Money | `SeasonTarget`, `SeasonPath`, `Recruit.ambition`, `ClubDeal`, `Camp`, `GymSpend` |
| Fans | Create; Road strip; Bout sheet; Overview; Pro offer; Why; Pro Fights; ClubShow | `Fans`, `ProDebut.tickets_sold`, `Matchmaking.fans`, `Membership`, `ClubShow` |
| Sparring pair & setting | Club week sparring cells; Training; Fight prep | `SparSet`, `SparNights`, `InjuryRoll` |
| Sizes as ranges & 1 bill number | Pull chips; Bill; `Coach deals it`; Week review; Why | `LeverSize`, `BoutRead`, `ClubDeal.coach_deal` |
| Grappler division, `Enter/Skip`, teaching | Club week row; Grappler page; Fights open card; Money | `NoGi.win_chance`, `BeltRoad`, `BjjSide`, `BjjOpen` |
| `Ready / Building / Rest` | Bout sheet; Overview; Why button | `BoutSheet`, `Aftermath` |
| Sponsorship block end | Club week sponsorship counter; Home; Money | `ClubDeal`, `GymSpend`, `Loyalty` |
| `Home` on own show & away travel | Bout sheet; Club > Money | `ClubShow`, `BoutSheet`, `Fans`, `GymBills` |

Part 3 of 3

## 7. The numbers (CODE / MEASURED / ESTIMATE)

- **MEASURED (four amateurs, `AMATEURPROBE1`, `MONEYFOUR1`):** `28` bouts/yr (`37` at 1–2 wk lead), `41` wins/100; gates `$12,600/yr`. Sponsorships over a year: `0` -> `$31k` (`+$270/wk`); `1` -> `1.9–2.9` mos runway; `2` -> `1.2` mos; `4` -> `80%` gyms close. Bout tiredness `45+` (`+10` stoppage, max `95`, `Aftermath.toll`). Planned lines fire `1/2` Usable, `3/4` Sharp, `1/1` Signature (`FireLevel` **ON since S450**). Good plan `59%`, none `45%`, bad `41%`; `+5` stats `~72%`.
- **ESTIMATE FOR THIS START:** 2 amateurs (~`9` bouts/yr each, half home): `~$4,200/yr` ticket cuts; `~6` pro bouts at `25%` of `$1,500` + tickets `- $90` camp bill: `$2,000–$3,000` (~`$6,000/yr` under 4 amateurs). Unsponsored all-training `+$150/wk`; 1 sponsorship `-$100/wk`; 1 class night `+$117/wk` + `~1` member/4 wks; grappler teaching (from blue) `+$68/wk` + members; away travel `-$40/bout`.
- **IN CODE TODAY (`S451`) vs v5:** `DuesLevers.CLASS_WEEKLY +$350/wk` stays as 1st-hour classes; 2nd-hour class (`+$117`) is **NEW**. `CornerTrust` + `NoGi.win_chance` kept; mood alone-rates & `Low` pass **NEW**. `Loyalty` expands from `StripeCall` to all 4 (`ClubDeal` + `GymShare`). `ProDebut.tickets_sold` swaps `2/win` for `fans` and halves member share. `WeekPhase.phase` sets `TAPER` 1 wk out for any booked bout (**CODE**). `ClubStart` overrides Unit 1 places (`3 -> 4`, **NEW**).
- **ESTIMATE status:** all `ClubDeal` Need/Want numbers (`2/1/+2/+1`), `Loyalty.MOVES` (`+1/+1/-3/-6`), mood alone-rates (`0.8/0.6/0.4`), sparring settings, `$117` class night, `$40` travel, `+4` fans, and twist prices are **ESTIMATES** gated behind section 8 probes.

---

## 8. Probes required before the build (on played bouts, never averages; UI waits for tables)

**THE CUT RULE:** any choice worth `<1.5` wins in `100` on a bout AND zero season effect (target weeks, bouts/yr, loyalty, cash) is cut, not drawn.

1. **`SHORTWEEK1` + `LOYAL1` (rerun with `Need = 2, Want = 1, Fight week Need +2`, 40 seeds × 52 wks, S462 Claude spec):**
   - `SHORTWEEK1`: `asked (Need + Want) > owned` in `>= 9/10` weeks (`>= 36/40` seeds); `COACH max run short (covered < Need) <= 2` weeks.
   - `LOYAL1`: `COACH min loyalty >= 50`; `STARVE` loses **1** fighter per seed (not 4); `EVEN min loyalty > 60`; `CLASS` (`1` class night/wk) tests real shortage/rotation pressure (`max run` & cash `+$117/wk`).
2. **`TANKPRICE1`:** best week vs Coach's `4–6` wins in `100`; best vs laziest `10–12`; no single job `>6`. Sizes finish-a-punch & southpaw rounds (kept only at `>=1.5`).
3. **`SEASON1`:** careful player vs `Coach deals it` -> pro offer `6+` wks sooner OR `2+` more wins/yr; fails if biggest-win bot wins the season.
4. **`ROTATWIST1`:** best deal differs from previous week in `>=3/4` weeks; no twist answer wins `>2/3` weeks.
5. **`FOLLOW1`:** always-away amateur reaches pro offer sooner but fails `<60` debut tickets; always-home sells `70+` but arrives `6+` wks later; mix clears both.
6. **`MOODRATE1`:** `0.8 / 0.6 / 0.4` alone rates + `Low` skip shift season training by `>=1` stat point over `4` Flat weeks.
7. **`SPARSET1`:** `Hard` vs `Technical` over 6-wk camp `>= +1.5` wins in `100`, with cuts costing `>= 1 in 20` bouts/yr.
8. **`WEAKFIND1`:** lowest-stat bot cannot beat mixed bot by `>3` wins/100 over a season.
9. **`SHEETDEAL1` / `WEIGHTGAP1` / `HOMELEAN1`:** no sheet card dominates all 5 lines (`1,000` sheets); `+2` tank per `0.5 kg`; close rounds lean home `7 in 10`.
10. **`MONEYFOUR2` + `PROCAMP1`:** `1` sponsorship + `1` class night/wk leaves club cash level over 52 wks; measures 6-wk camp cost on amateurs.

---

## 9. Build order, in small tasks

1. **Probes first (cloud, pure):** rerun **`SHORTWEEK1` + `LOYAL1`** (confirm Need=2 / Want=1 passes S462), then `TANKPRICE1`, `SEASON1`, `ROTATWIST1`, `FOLLOW1`, `MOODRATE1`, `SPARSET1`, `WEAKFIND1`, `SHEETDEAL1`, `MONEYFOUR2` -> emit `LeverSize` tables.
2. **Pure rules + unit tests (1 per task):** `Favours`, `JobRota`, `ClubDeal` (`NEED`/`WANT`, evening places, mornings, Coach's classes), `ClubTwist` (deck of 12), `WeakSpot`, `FightWeek`, `BoutSheet`, `TrialMat`, `Loyalty` (`full_week`/`want_met`/`short`/`short_running`, `Tell it straight`), `SeasonTarget`, `Fans`, `SparSet`, `LeverSize`.
3. **Wire rules & clean amateur camps:** remove amateur camp penalties/flags (`1.5`-pt loss, `Set camp`), align `GOALFIX1` (bout goals at bout, stat goals at deadline), `ClubStart` `4` places at Unit 1, retire `WeekTwist`, wire mood alone-rates.
4. **Start & data:** Pro A/B starter rows (`1-0`, licensed, fans), Amateur A–D kg rows (`57/65/75/60 kg`), `FirstWeek` 5-step reveal, `ProOffer` debut ticket forecast, `3` new rivals/weight, Saturday calendar.
5. **Screens (Look B whiteboard, S448 names only in headers):** `ClubWeek`, `BoutSheet`, `BoutPage` bill, `Fights` (pro + amateur), `Overview` loyalty/fans/target, `Coach` card, `Money`, `Grappler` page, `Why`.
6. **One golden-path test:** Create -> 5-wk reveal -> season target -> sponsorship renew -> class night -> fight-week shortage rotation (`short < Need` vs `Want` skipped) -> talk card (`Tell it straight`) -> Hard spar -> twist -> home/away bout -> bill + `Legs` + `4 pm` scale -> fight -> `Why` -> grappler `White` open -> pro camp + debut forecast.

---

## 10. Risks, said plainly

- **Build size:** 13 new pure rule modules, new start, new board — ships across several weekly milestones, gated on `SHORTWEEK1`/`LOYAL1` passing first.
- **Unifying pad & mat slots (`Need = 2, Want = 1`):** `LOYAL1` must confirm that putting the grappler's coached mat slots into the `8`-place evening pool keeps `COACH`, `EVEN`, `STARVE`, and `CLASS` in sweet-spot balance across all 52 weeks (`Ask = 12 > 8` while `Need = 8 == 8`).
- **Two meters (`Mood` word vs `Loyalty` bar):** keep strict visual separation (`Mood` word only; `Loyalty` bar only; every price names which moves).
- **Pro mid-game:** pro ladder after debut is largely unplaytested by the owner; first hour exposes any rough edges immediately.

## 11. Open for owner & code check
- **OWNER (data scope):** featherweight (`57 kg`) / middleweight (`75 kg`) amateurs turning pro need matching pro tables or starter restriction to `60/70 kg`?
- **OWNER (taste):** confirm pro keeps day job `< top 10` (with `$120/wk` **Camp leave**), cross-gender weight sparring allowed, and `STARTING_PLACES = 4` at Unit 1.
- **CHECK (Claude):** verify `Bouts` / `Aftermath` assume full opponent tank and `FightJudges` close-round home lean (`HOMELEAN1`).

---

## MECHANICS FOR THIS VERSION (closed set; post-probe cuts only)
1. **THE FOUR:** 1 pro (of 2), 2 amateurs (of 4), 1 grappler; `4` starter places at Unit 1.
2. **CLUB WEEK:** Monday board dealing evening places (`Need = 2, Want = 1`, `+2` fight week, `+1` Peak camp; `8` owned), auto-shared coached mornings (`6`), and 4-wk gym sponsorships (Renew / Pass on / Let end); `PROMISES OPEN`, diet Hold/Cut, `By hand / Keep my changes / Coach deals it`.
3. **COACH'S EVENINGS:** each switches between `Training (2 places)` and `Second class (+$117/night, ~1 member/4 wks)`.
4. **PULLS:** Weak spot, Weapon, Goal, Ahead — range sizes, colour per currency.
5. **JOB ROTA:** Shifts, College, Office, Cafe; pro keeps job `< top 10` (with Camp leave).
6. **CLUB TWIST:** 1 card/wk from deck of 12, priced answers.
7. **FAVOURS:** `0–3` per club; service-earned, term-spending, mutual `1.0 kg` kilo rule.
8. **TRIAL MAT:** 2-wk prospect every 4 wks (`+1` Want place/wk); `Watch` on trial card.
9. **SPARRING:** weight-based pair + `Hard / Technical / Body only` setting.
10. **MOOD WITH TEETH:** `0.8 / 0.6 / 0.4` alone rates, `Low` auto-pass, corner uptake (**CODE**).
11. **LOYALTY:** `Loyal 70+` holds pads & gets `1/4` free short week; `Need` met `+1`, `Want` met `+1`, `short (< Need)` `-3/-6`; talk (`Give back / Promise / Tell it straight`); leaves `<25`; `10%` pro share `<50`.
12. **SEASON TARGET:** Nationals / Pro offer / Year to grow; Ranked / Busy; Medal / Blue belt.
13. **FANS:** home bouts build debut & pro crowd (`+4` win, `+1` loss, `0` away, `+10` title).
14. **BOUT SHEET:** Home (local or `ClubShow`), Name above, Unknown (`-$40` travel); `Ready / Building / Rest`; regional rank.
15. **FIGHT WEEK:** `4 pm` scale (`1.0 kg` gap), fight-week evenings, film, 4-line hand, `Legs` bar, 3 shapes, opponent's `Legs`, corner choice, pull-outs, **1** bill range.
16. **GRAPPLER MAT:** 3 or 5 classes, mat morning, `White / Blue` open decision (`Enter/Skip`), teaching from blue (`$68` + members), stripe loyalty, conditional corner.
17. **PRO ROAD:** offer + 3 no answers, `$1,105`, ticket-paid debut, promoter offers, camp + Camp leave.
18. **GUIDE:** 5 steps wk 1, reveal order wks 1–5.

*(Left for later: `RPGLAYER1`, rival gym poaching, `HOSTSHOW1` full card-filling, living world, club season/year review, TV/belts, pro weight tables, show-night conditions, 10 novice bouts.)*

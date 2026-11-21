# TURNPRO1 v13 - a code-checked critic (S536, arena console)

Who I am: a fresh design critic who reads the code. I was asked for the critic brief of S459/S405 (score DEPTH, GENERAL DESIGN
and PLAY; what is missing, what is useless, and what each option changes; end with "To reach 10/10" and the 10/10 page) and for
three things a chat critic cannot do: open every **CODE** line of the map and say TRUE / FALSE / NOT FOUND, check the probe
(`tools/turnprobe13*.gd/.py`) against the map's sections 3 to 5, and check the result's own limits.

What I did: read the whole critic pack and the map (`ops/research/DESIGN_TURNPRO1_V13_CRITIC_JOHN.md`,
`ops/research/DESIGN_TURNPRO1_V13.md`), the probe and its result (`docs/TURNPROBE13_RESULT.md`), the prior two results, and
the game code under `scripts/` line by line for every citation. What I did **not** do: run Godot, re-run the probe, or
recompute the tables (the JSONL the probe writes is not in the repository - see 4.0). What I did **not** touch: any file but
this one. I cite no line number of `LineGrade.gd`, `LiveRound.gd`, `StepWire.gd`, `MHRig.gd`, `Player2.gd` or `BoutPage.gd`;
the map cites none of them either.

---

## 0. The scores, up front

| Axis | Score | Bar (owner S534) | Reads |
|---|---|---|---|
| **DEPTH** | **5 / 10** | 8 | One decision, two options, and the safe one is weakly dominant. The "road of six fights" that is supposed to carry the depth does not carry it: the house picks the kind of every fight. |
| **GENERAL DESIGN** | **7 / 10** | - | The strongest layer of the map: about 80 code citations, 1 false, 4 partial, every screen named against its function, a real cut list. Four definitional holes take it off 8. |
| **PLAY** | **5 / 10** | 8 | The hard road is a 49-in-100 loss of the one night the boxer has, punished three times; the reward is about $48 a week and a name that arrives 30 weeks later and needs room. The safe road's night plays the same as today. |

**Verdict against the owner's rule (a mechanic STAYS only at 8+ DEPTH and 8+ PLAY): v13 does not stay as specified.** This is
not "cut it". The probe proves there is a real trade in there and the code layer is honest enough to build on. It is "not
yet": the list in section 7 is short and buildable, and the same probe can measure it.

The one sentence for the owner: *v13 finds a real trade and then takes the trade away from the player - the promoter decides
which fights make the name, the screen tells the player which house is right, and the tune-up rule pays the hard road by
fining the safe one.*

---

## 1. The checkout I checked against

- This repository is a single-commit import: `ce440f2 "lite: 2552064b"` (21 Nov 2026). `git rev-list --count HEAD` = 1. The
  map's own base commits (`0ea035621`, `65423f4a3`) do not exist here (`fatal: Not a valid object name`), so I cannot check
  that a line was right *at 0ea035621*. I checked every line against this checkout. If the import is the later commit, that is
  the stronger check; if it is the earlier one, a line could have been right there and wrong here.
- **The two files the map says it moved by hand are right.** `rules/Matchmaking.gd` and `state/ProLadder.gd`: every line I was
  asked to check first resolves exactly (ProLadder :23-25, :32, :37, :93-107, :102-104, :175-216, :204-214, :209, :337-368,
  :355, :360-361, :372-378, :377, :407-420, :423-438; Matchmaking :35, :43, :50-53, :56, :68-82, :180-192, :188-189,
  :216-225, :218, :230-270, :236, :242, :245, :252, :283-285, :290-291). Nothing drifted.
- Totals: **~80 citation groups checked in sections 1, 3, 4, 5, 7 and 8: 75 TRUE, 1 FALSE, 4 PARTIAL, 0 NOT FOUND.**
  A map whose code layer is this clean can be built as written - with the five corrections below, none of which is fatal.

---

## 2. The code claims, TRUE / FALSE / NOT FOUND

Legend: **TRUE** = file, function and line are as claimed and the sentence about the code is right. **PARTIAL** = the line is
right, the sentence overstates it. **FALSE** = what the code does is not what the map says. I give the evidence (function,
constant or line) in the last column so the next session can re-open it.

### 2.1 Section 1 - the call

| Cite in the map | Verdict | What the code really does |
|---|---|---|
| `Roster.gd` `check_pro` :200-214, :201-205; `Sim.gd` :415, `Bouts.gd` :457, `BoutFinish.gd` :219, `TestJump.gd` :167, :195 | TRUE | One offer at a time; with one open only the lapse (:202). First ready boxer in roster order, no bout, not in a championship run (:207). All five call sites confirmed, and they are the only callers. |
| `Roster.pro_ready` :186-196 | TRUE | Constants `PRO_WINS` 7 (:34), `PRO_RANK` 3 (:35), `PRO_WINS_ANY_RANK` 9 (:36), `PRO_RETURN_WINS` 2 (:38): 0 declines 7+rank1-3 or 9; 1 decline 9+rank1-3 or 11; 2 declines rank 1 only (:193-194); national finalist with 0 declines any record (:189-190). |
| `ProOfferWire.make` :25-41; `ProCall.calls_open` :331-332, `AGE_STOP` :14 | TRUE | The age gate is skipped when a decline has happened (`declines == 0 and not calls_open`, :27). |
| `ProDebut.tickets_sold` :27-32; `ProOfferWire.forecast` :20-21; `HomeBout.gd` :13, :69 | TRUE | 20 + floor(members/2) + 2 a win + 10 a title + followers, clamped 0-100; `SHOW_FOLLOWERS` 10 (:13) added when our own show is boxed (:69). |
| `ProCall.who_calls` :63-69 | TRUE | break-even 60 ± `BAND` 15: 75+ the ticket house alone, 45 or fewer the guarantee house alone, else both. |
| `ProOfferWire.make` :31-33, `on_decline` :181-183 | TRUE | The house that called last calls again (`pro_last_house` = `offers[0].key`), which is the ticket house whenever both called (:32-33, list order). |
| `ProCall.terms` :73-95 | TRUE | 0.9^declines on purse, step and top, unless a title came since (:79-82). |
| `ProCall.promoters` :35-59 | TRUE | bow 1,500 / break-even 60 / share 0.5 / 4 weeks; hf 1,800 / 70 / 0.3 / 6 weeks. |
| `ProCall.debut_purse` :99-108, `money` :112-139 | TRUE | $25 a seat under 60 with a $500 floor (:107-108); past 60 the ticket share is `above x $50 x 0.5` (:117) = $25 a seat; so $25 a seat across the band. |
| `DebutPick` `AIM` :15, `NOISE` :17, `target` :34-36, `pick` :48-67, `apply` :71-78; called from make :38 | TRUE | Goals 0.60/0.75, ±0.04 misjudgement seeded by boxer/house/day (:35-36); bisection on the shown read (:56-64); keeps `opp_gap`, `opp_target`, `opp_picked`, `opp_day` (:74-77). |
| `DebutRead.card` :17-24, header :5-6 | TRUE | The opponent of the night, the boxer on the usual camp, a 4-round card (:21-22). It never reads `debut_weeks`; the header's "errs low by a point or two" is at :6. |
| `DebutOpp` consts :15-17, `name_for` :22-24, `rating` :32-33, `make` :37-41 | **PARTIAL** | All lines true. But "only the name and the gap differ by house" is not exact: the club line is "<house> stable" (:39), the name list is by sex, and the style/threat/weakness are single constants for both houses (:15-17). The per-house style is a proposal, not code. |
| `BoutRead._read_copy` :272, `_games` :277-280, `_tiring` :301, `_round_edges` :328, :337 | TRUE | Functions at :254, :277, :299, :320; :272 is the coach's plan written against the style; :279 "walks in", :301 "fades", :328 a body threat, :337 the opponent's fade. A different style really does change the bout. |
| `Roster.turn_pro` :305-309, `debut_day` :319-320 | TRUE | The debutant is made at signing, the Saturday `PRO_DEBUT_WEEKS` (4) out, `PRO_ROUNDS` 4. |
| `ProLean` `LEAN_FIGHTS` :7, `LEAN_KIND` :8, `extra` :12-33; `ProLadder` :23-25, :204-214 | TRUE | aim 0.82 (`TUNE_AIM` :25) inside 0.70-0.93 (`TUNE_READ` :24), step 0.5 (`STEP_READ` :23); the rows are appended in `ProLean.extra` :24-32, called at `ProLadder` :213-214. Note `LEAN_FIGHTS` counts the debut (`pro_fights` = pro_w + pro_l + pro_d), so the lean covers 5 offer sets after the debut, not 6. |
| `ProDebut.start_costs` :18-24, `Roster.turn_pro` :275-282 | TRUE | 230 + 875 + 140 = 1,245. |
| `Roster.signing_share` :223-224, `turn_pro` :288-291; `Loyalty.pro_share` :230-233, `MOVES` :61 | TRUE | 25% at `SETTLED_AT` 50+ (:26), trainer's 10% below; +5 loyalty applied at :291 after the share is read at :288. |
| `ProCall.morale` :298-308, `ambition_kind` :312-318; `Recruit.ambition` :122-126; `ProOfferWire.morale_line` :162-170; `Champs.check` :40-41 | TRUE | Ambitions: home-crowd first win (0 bouts, :125), a regional title (pot 78+), a winning record. No ambition contains "pro", so the ±5 branch (:300-301) is dead. The title branch costs 5 only before the nationals (:305-306). |
| `Roster.turn_pro` :301-303, :307; `Bouts.accept` :192-200 | TRUE | The stipend ends and the amateur offers are closed; `f["bout"]` is overwritten without an emptiness check; `Bouts.gd` does not mention `pro_offer` at all. |
| `ProCall.ask_answers` :156-194; `ProOfferWire.ask` :76-90, `back_to_plain` :94-98; `ProOffer._ask` :174-195 | TRUE | Six answers; "won't" is disabled and not spent; one ask per house per offer. |
| Later row: `_apply_later` :197-201 | TRUE | 2/4 weeks, $150/$300 off; nothing reads the weeks in the read. |
| Softer row: `_apply_softer` :204-208; `ProLean.extra` :14-17; `ProLadder.book` :342-343 | TRUE | gap +0.5, free, and the next 2 sets are filtered to tune-ups (`only`), spent by any booking. |
| Split row: `_split_entry` :211-239 | TRUE | over = forecast − break-even: ≥20 takes +10 and gap −0.5; ≥5 counters +5; else won't. The guarantee house is never on an offer above 74 seats, so it never reaches 5. |
| Price row: `_price_entry` :242-260; `ProOfferWire.money` :125 | TRUE | bow only: $40 tickets, +15 tickets sold, free. |
| Costs row: `_costs_entry` :263-283; `money` :122-124, `night` :135-136; `GymBills.runway_weeks` :62-67 | TRUE | hf only: +$100 (+$200 under 8 weeks of runway) off the purse before the split; `maxi(0, …)` is the only floor. |
| `ProOffer.build` :35-45 | TRUE | "A CALL FROM <houses>", "TURN <first> PRO?", then one line: record and rank, days left, age line, declines left. |
| `ProOffer._tickets` :90-106, `ticket_parts` :211-225; :97 | TRUE | One bar, one mark at `ProDebut.BREAK_EVEN` 60. The guarantee house's 70 is not drawn. |
| `ProOffer._house` :110-170; :139-143, :154, :155, :161-163, :165, :167 | TRUE | Badge and name; "VS <debutant>"; debut purse; ticket share and seats today; the picked line with its hover; win chance and draw; "After the debut…"; the three money rows with the assumed $75 (`LOST_CUT_A_WEEK` :13); the pays-back sentence; the asks; the sign button. |
| `ProOffer.build` :56-69, :72-81 (:80) | TRUE | The signing costs itemised; WHAT ENDS; the 10% line under 50 loyalty; the morale line; "Stay amateur" whose tooltip always says "2 more wins, on 0.9x terms". |
| `Needs.needs` :67-70, `blockers` :140-141, `flags` :167-168; `Main.on_go` :195-199; `Clock.stop_now` :79-83 | TRUE | The offer is a red need and a red flag; red needs are blockers; Continue opens the first red need and the clock stops. |
| `ProOfferWire.lapse_if_due` :187-197, `ProCall.expires` :336-337 | TRUE | The only caller is `Roster.check_pro` :202, which runs on a week end or a bout. With a red need blocking time a player cannot reach the 14th day. |
| `Roster.decline_pro` :324-334; `Loyalty.MOVES` :61 | TRUE | +1 decline, the same house saved, morale 0 for every goal that exists, −8 loyalty. |
| `LoyaltyWire.idle_week` :44-53, `IDLE_WEEKS` :19 | TRUE | 3 loyalty every 4 Mondays, and no `pro_offer` check: it does not pause. |
| `FighterProfile.gd` :25 - "month_no_fight: -6 is a table entry; this session did not find a caller" | **FALSE** | The entry is at :25, but it *is* read: `scripts/rules/AskDates.gd` :120 does `absi(int(FighterProfile.MORALE_EVENTS.get("month_no_fight", 0)))` and `wait_words()` prints "A month without a fight costs 6 morale." So the game promises the player a morale cost that nothing applies. The map's "no caller" hides a live text/game mismatch, not a dead constant - and it is a one-line fix the map should own. |
| `BoutFinish.gd` :92, :111-116; `Roster.debut_night` :247-251; `ProOfferWire.night` :133-142; :114-115 | TRUE | The seats are counted on the night; the ledger label prints `int(Roster.GYM_SHARE * 100)` = 25 whatever the real share (10% under 50 loyalty). |
| `BoutFinish` :94-106; `BoutRules` :114-123 | TRUE | +8 members and +5 reputation a win; −1/−2 a loss; −2/−4 stopped. |
| `BoutFinish` :176; `MORALE_EVENTS` :18-20, `apply_morale` :147-170 | TRUE | +8 scaled 0.9-1.1 by confidence; −12 scaled 1.3-0.7 by heart. |
| `BoutFinish` :177-178; `Loyalty.MOVES` :60 | TRUE | +2 / −1 / −3, halved for a Loyal boxer. |
| `BoutFinish` :101-102; `Attrs.wear_stoppage` :127-129, `STOP_DROP` :42 | TRUE | durability ceiling −2 for good, floored at 20, not for an RTD. |
| `Membership.gd` :15-16, :19, :29, `step_members` :45-53 | TRUE | 48 + 0.6 a reputation point; a quarter of the gap, 6 at most, at least 1. |
| `ProLadder.result` :372-378 | TRUE | `join()` :375, then `opp_id == 0` returns at :377-378: the debut puts the boxer on the table and nothing else. |
| `BoutFinish` :117-122; `PURSE_UNRANKED` :50, `pay_of` :216-218; `ProLadder.book` :355, :361; `ProWeekLines.next_line` :46-50 | TRUE | The booked purse comes from `pay_of`; `f["purse"]` steps up after a win (:122) and is never the purse that is paid; the week review promises the step and the top anyway. |
| `ProWeekLines.lines_for` :15-42 | TRUE | 28 days of "amateur cut lost / stipend saved" with the assumed $75; a ledger line in the debut's week. |
| `GymDeals.pro_camp` :22-35 | TRUE | The debut is a ticket night: no camp bill; a cutman on staff is still charged. |
| `BoutFinish.run` :94-106, :110 | TRUE | The debut is booked as any bout's and then `ProLadder.result` (:110). |
| `ProLadder.result` :372-378, `join` :93-107; `Matchmaking.join` :68-82; :377, :102-104 | TRUE | 0 fans, no rebuild key, the debut's record copied at :102-104. A debut loss leaves no mark; a debut win earns nothing there. |
| `Matchmaking.apply_result` :230-270 (fans :242), `loss_fans` :290-291; :245, :252 | TRUE | +1 a win, +1 more for a step up, +1 for a stoppage, −1 for a mismatch 6 under; rebuild cleared :245, set :252. |
| `ProLadder._make_offers` :175-216 (:209), `Matchmaking.ask` :180-192 (:188-189) | TRUE | While rebuilding: no step up, and no ask above the place. |
| `ProLadder._review_streak` :407-420, `REVIEW_WINS` :37 | TRUE | 5 wins and a positive record takes the last ranked seat. |
| `Matchmaking.pay_of` :216-225, constants :50-53 | TRUE | 1,500 unranked; +400 a place above the bottom of 20; +150 a place for a name above; tickets $150 x (fans+5) x closeness; `GYM_SHARE` 0.25 (:56). |
| `ProLadder.book` :337-368 (:360-361), `LEAD_DAYS` :32; `Matchmaking.next_weeks` :283-285 | TRUE | 6 weeks out; 6 / 8 / 12 weeks to the next, +8 after a stopped loss. |
| `ProLean.extra` :12-33, :7, :8 | TRUE | One added row, the nearest read kept even when a row already on the table beats it. |
| `BoutRules` `WIN_MEMBERS` :114, `WIN_REPUTATION` :115; `BoutFinish` :96, :98 | TRUE | 8 and 5, whoever was beaten; only a short-notice win doubles (:98). |
| `ProFights.gd` :161-163; `ProLadder._make_offers` :175-216 | TRUE | The kind chip is drawn on every row from `KIND_WORD[kind]`. |
| `Membership` `natural_members` :38-40, :15, :16, `step_members` :45-53, `settle_week` :90-102, `weekly_dues` :83-84 | TRUE | 48 + 0.6 a point, a quarter of the gap, 6 at most, $35 a month (4.33 weeks), so one point with room is $4.85 a week. |
| `GymSpend.member_cap` :160-161; `GymUpgrades` :27-29 | TRUE | The smallest of the premises' room (70/140/250), the coaches and the floor places, less upgrades' room, plus kit. |
| `GymUpgrades.LOAN` :127, `GymSpend.move` :242-248 | TRUE | $3,000 down, $750 a month for 12. |
| `ClubShow.draw` :26-27, `Grants.chance` :28-29, `CardAsk.chance` :74-75 | TRUE | The name is read in three more places; a name with no room still does those three things. |

### 2.2 Section 3 - the fork

| Cite | Verdict | What the code does |
|---|---|---|
| `DebutPick.AIM` :15 | TRUE | 0.60 / 0.75 today (v13 moves the second to 0.78 - a build, not code). |
| `Matchmaking.pay_of` :218, `BAND_UP` :35 | TRUE | Rank 20 pays 1,500 + 400 = 1,900; asks reach 5 places up. |
| `Matchmaking.loss_fans` :290-291 | TRUE | A favourite who loses costs 2 fans. |
| `BoutRules.WIN_REPUTATION` :115, `BoutFinish` :98 | TRUE | 5, doubled on a short-notice win. |
| The first-night row's "a crowd-pleaser ('Pressure fighter')" / "a cautious 'Out-boxer'" (no code line given) | **PARTIAL** | Today both houses put up `DebutOpp.STYLE` "Boxer-puncher" with "Fades after round 3" (:15-17). The per-house style is a proposal; see 4.4(b) - it is not in the build order and it collides with the owner ruling "the debutant it picks does not change". |

### 2.3 Section 4 - the asks

| Cite | Verdict | What the code does |
|---|---|---|
| `ProCall._apply_later` :197-201 | TRUE | As claimed. |
| `ProCall._apply_softer` :204-208 | TRUE | As claimed. |
| `ProCall._price_entry` :242-260 | TRUE | As claimed. |
| `ProCall._costs_entry` :263-283 | TRUE | As claimed. |

### 2.4 Section 5 - the read, the seats, the hold

| Cite | Verdict | What the code does |
|---|---|---|
| `DebutRead.card` :17-24, header :5-6 | TRUE | It cannot move with the weeks today: the function never reads `debut_weeks`. |
| `DebutPick.AIM` :15 | TRUE | 0.75 for the guarantee house today. |
| "the opponent it picks is the one it picks today" (owner ruling, section 10) | **PARTIAL** | True only at the point the two changes are equal: the lift at a 0.75 read is 0.2 x 0.15 = 0.03, which is exactly the aim move. Because `DebutPick.target` carries ±0.04 of noise (:36), the identity holds only at 0.75: at a 0.71 target the search aims at 0.74 on the lifted card and picks a stronger debutant. It is also void if the styles differ (2.2). The owner's ruling is true on average, not per boxer. |

### 2.5 Section 7 - where it appears

| Menu | Cite | Verdict |
|---|---|---|
| Top bar flag | `Needs.flags` :167-168 | TRUE ("PRO OFFER", red) |
| Continue / clock | `Main.on_go` :195-199, `Clock.stop_now` :79-83, `Needs.blockers` :140-141 | TRUE |
| Home, needs | `Needs.needs` :67-70, `_pro_line` :199-206 | TRUE (house names are in the body - the map says it will fix that) |
| Office desk | `OfficeDesk.gd` :39 | TRUE (`"prooffer": "contract"`) |
| Offer header | `ProOffer.build` :35-45 | TRUE |
| Offer ticket bar | `_tickets` :90-106, `ticket_parts` :211-225 | TRUE |
| Offer house card | `_house` :110-170 | TRUE |
| Offer asks | `_ask` :174-195; `RosterActs` :96-104 | TRUE |
| Offer foot | `ProOffer.build` :56-81; "acts :90-95, :105-108" | **PARTIAL** - the act lines are `RosterActs.gd` :90-95 and :105-108, not `ProOffer.gd`; the map's cell does not name the file it switched to. The facts are right. |
| Fighter, Next Step | `FighterPage` :338, :344, :355-357; `NextStep.road` :50, `pro_line` :73-88 | TRUE (:50 is inside `road`, the pro-offer step; `pro_line` actually runs to :90) |
| Fighter, contract | `FighterPage` :144 | TRUE (a fixed "Club stipend, $250 a week / Until turning pro") |
| Money, stipends | `MoneyPanels` :264, `_stipend_card` :360-367 | TRUE |
| World compare | `WorldCompare` :269 | TRUE |
| Fights (pro) | `ProFights` :117; `ProLean.line` :41-47 | TRUE (house name in the body) |
| Week review | `ProWeekLines` :15-42, :62-75; `Roster.turn_pro` :294-295, `BoutFinish` :123-124 | TRUE |
| History | `BoutHistory` :45, :68 | TRUE ("TURNED PRO WITH …") |
| Debut result | `BoutFinish` :94-116; `Roster.debut_words` :254-261 | TRUE |
| Pro fight result | `BoutFinish` :94-98, :170 | TRUE (the news line says 8 locals, not the name) |
| Game plan / camp | `BoutRead._read_copy` :272 | TRUE |
| Toasts | `RosterActs` :95, :108 | TRUE (toasts a first name in the body) |
| World, the pro table | `ProLadder.road` :423-438 | TRUE |
| Money, members | `Money` :123-124; `GymSpend.member_cap` :160-161 | TRUE |
| Test jump | `TestJump` :195-197 | TRUE |

Section 8's hook: `ProLadder.division_for` :43-49 - TRUE (four tables by the amateur limit, with a fallback for an old world).

### 2.6 The five things to fix in the code layer

1. **The career's only "kind" is lost at booking.** `ProLadder.book` writes `f["bout"]` (:360-362) with no `kind`; `BoutFinish`
   has no kind to read. Build item 6b says the book must keep it - true, but note what it must keep it *from*: an offer row.
   A fight booked by **asking** (`ProLadder.book(..., asked=true)`, the live path on Fights: `ask_rows` :321-333,
   `ProFights` :126, :300) has no row and therefore no kind, so the +2/+5 rule has no defined answer for it.
2. **The rebuild fight's kind is not "rebuild", it is whatever row the promoter happened to keep.** At the ticket house the
   road keeps the tune-up while rebuilding, so the rebuild fight pays +2 - a second punishment on the loss. State it or change it.
3. **The "firm road" fails open.** `turnprobe13_rules.road` keeps an emptied set as it was (:161-162), so a house whose whole
   set is removed silently reverts to the promoter's rows. The rule must have an answer for an empty set (a week's silence, or
   a row with a stated penalty), and a state test for it.
4. **`month_no_fight` is a lie in the interface** (see the FALSE above): `AskDates.wait_words` promises a cost nothing applies.
5. **The map's own numbers drift by one fight.** `LEAN_FIGHTS` counts the debut, so "the first six pro fights" is the debut
   plus five offer sets; the map's "six fights the choice of house shapes" is right, its "first six fights" in section 3 reads
   as six after the debut.

---

## 3. The probe, checked against sections 3 to 5

### 3.0 What I could and could not check

The runner and summariser are readable and I read them line by line; the result's tables cannot be recomputed because the
probe's JSONL is not in the repository (`find . -name "*.jsonl"` is empty). So my check is **the model as written against the
map, and the result's tables against the tool that printed them** - not a re-run. Where the result says a number, I checked
that the tool computes that number from the columns it prints.

### 3.1 Does the probe's v13 do what sections 3 to 5 say?

| Section | What the map says | What `turnprobe13_rules.gd` does | Verdict |
|---|---|---|---|
| 3 | A tune-up win pays +2, "in place of" 5, and **only on rows booked as a tune-up** | `after_fight` (:167-172) takes back 3 after the game paid 5, for `kind == "tune"`, and `st["kind"]` is set from the row the bot booked (:272) and cleared after every fight (:248). | **TRUE**, with one hole: the map's own state test says a short-notice tune-up win pays 4; the probe's flat "take back 3" would pay 7. The probe does not model the map's own edge case. |
| 3 | The ticket house's name by seats, +1 a 4 seats (20 at most), on top of the 5 | `after_debut` (:115-119): `mini(20, sold/4)` for `house == "bow"` on a win. | **TRUE** |
| 3 | The winner takes the table's last seat | `last_seat` (:130-142), without the 5-win gate. | **TRUE** |
| 3 | The table's rebuild flag after a loss | `after_debut` :120-125, both houses. | **TRUE** |
| 3, 7 | The firm road: the ticket house no tune-up unless rebuilding; the guarantee house no payday, no step up before 3 wins | `road` (:147-162), exactly that. | **TRUE**, but it fails open on an emptied set (see 2.6.3). |
| 5 | The card adds a point a camp week past four and 0.2 of every point over 60; the guarantee aim moves to 78 | `card` (:46-57) and `AIM_UP` (:27), `repick` (:61-77). | **TRUE** |
| 5 | "The opponent it picks is the one it picks today" | `repick` searches the **lifted** card, and `card` **also replaces the debutant's style and weakness** (`STYLE` :20, :49-51). | **FALSE** as a description of the probe: the picked gap moves, and the opponent is a different boxer (see 3.4). |
| 9 | The bot books the row read nearest 65, does not read the +2/+5 line | `_nearest` (:276-284) reads only `chance.mid`. | **TRUE** |
| 9 | Flat = v13 with the tune-up rule off, same rolls | `_day` :246-247 applies `after_fight` to `v13` only; flat still gets `V13.sign`, `road` and `after_debut`. | **TRUE** - and this is the cleanest thing in the probe |

### 3.2 Is "flat" a fair control for the tune-up rule?

**Yes**, and it is the only clean control in the whole exercise. One condition differs: `arm == "v13"` in `_day` :246. Same
population, same call weeks, same sign path (`V13.sign`), same road, same debut name by seats, same table marks, same cells,
same bot. Everything downstream of the rule (members, seats, cash, closings) is allowed to move, which is what a control should
do. Two caveats: it was run in **two cells only** (`ctl=56,full`), so bar 10's "every cell with room it is played in" is
**one** cell with room; and the flat arm cannot see the rule's effect on a player who reads the line, because the bot never does.

### 3.3 What the probe makes true by construction

This is the heart of the check. The result reports PASS at 14 of 15. **Only bars 1 and 2 are independent instrument checks**
(does the instrument see a known lever; is its error small) and bar 2 is the one that fails. Everything else is the design
measuring its own assumptions, or - in bar 12 - not causal at all. What is left that is genuinely new information is the
*level* of the cash difference (reputation -> members -> dues is a real model) and the fact that the two roads behave
differently at all.

**Bar 10 and bar 15 are the same arithmetic, and both are true by construction.**
- `road()` makes the guarantee house's sets 68% tune-ups (the result's own column: 32/68/0 step/tune/payday) and its careers
  win **2.41 tune-up fights** (grade table). The rule takes 3 reputation off each: **about 7.2 reputation removed** from that
  road, for every career, whether or not the player wanted it.
- Measured: the lead is +8.4 with the rule on, +2.3 with it off; the rule "adds 6.1". So **73% of "the name stays" is a fine
  on the other road**. The ticket house's own contribution - the thing it is supposed to sell - is the 2.3.
- Bar 15 ("the ticket house ends 4+ ahead") fails on its own terms with the rule off (2.3 < 4). Its PASS is the fine, not the
  ticket house's name. A critic cannot read bar 15 as evidence that the hard road's name lasts; it is evidence that the safe
  road's name was cut.

**Bars 7, 8, 11 are near-vacuous with two options.** With two options, "no option is the one answer in more than 6 of 10
cells" can only fail if one house beats the other in **all** cells - which bar 6 would already catch (bar 6 wants at least
one). "Every option is right in at least one cell" is met by anything that is not dominated everywhere. Bar 11's "right in at
least 2 of 24" is met by a house that is right twice. The result says this in its section 2; the map's header still leads with
"every audit bar", which reads stronger than it is.

**Bars 3 and 4 are one test, twice, on a card fitted to the data.** Bar 3 checks that the played night lands in the band
around the design's own aims (60/78); bar 4 checks the card is within 3 of the play. The card's lift (0.2 over 60) was derived
from probe 12's stage A reading - the same population, the same scratch nights. That is calibration checked against its own
calibration set, and **bar 4 is a group mean over six boxers** (`A[(arm,opt)]["shown"]/["win"]`, `sum.py` :162-169), not a
per-boxer check, while the player sees one boxer. A card honest to 0.7 on the mean can be five points out for one boxer, and
the bar would still pass.

**Bar 14 is the probe's own formula.** The v13 card adds `WEEK_POINT` 0.01 a week past four (:57); Later +2 therefore shows
+2.0 by arithmetic. The bar asks whether a hand-written 0.02 lands between 1 and 4. It cannot fail.

**Bars 5 and 6 are the two aims plus the full cell.** Bar 5 needs cash +$1,000 and 28 wins behind: that is what two hand-set
aims (60 and 78) and the name-by-seats rule produce. Bar 6 needs the guarantee house to beat the ticket house somewhere: that
is the full cell, where the name cannot buy members, which the design says out loud ("a name with no room pays nothing"). Bar 9
passes the moment bar 5 does.

**Bar 13 is the definition of `road()`.** "Step ups are 25+ points more of the ticket house's bookings" is what the keep-lists
:156-159 do. It is a build check, not a finding.

**Bar 12 is not causal and the result says so.** It compares the careers that lost with the careers that won (`sum.py`
:306-313) - different boxers, different records. The number is a selection effect. The map then quotes it as the cost of a
loss ("What a debut loss costs at week 40: $2,287 … today $972"). That sentence cannot be supported by this bar.

**The genuinely independent readings:** bar 1 (the mutant costs ask still reads its known +$909: the instrument sees a known
lever), bar 2 (the error - and it fails at $253), and the *level* of the cash difference, which is a real model result of
reputation -> members -> dues. Everything else is the design describing itself.

### 3.4 Two things the probe builds that the map does not, or will not, build

**(a) The escape hatch the probe does not model: asking.** The probe's bot never asks. In the shipped game a pro can ask for a
name (`ProLadder.ask_rows` :321-333, drawn on Fights at `ProFights` :126, :300; a rank from 15 down is open to an unranked
boxer, `Matchmaking._in_band` :324-331), and an asked fight is **not a row the promoter labelled a tune-up**, so under the
map's own wording it pays +5. A player who wants the name at the guarantee house can ask for #15-20 from the first fight and
earn +5 a win, and the "firm road" gate (:158) does not touch the ask list. The map never mentions this path. So bar 15's +8.4
is the lead of a **passive** player - it is an upper bound, not a floor, and a thinking player closes it. This is the single
most important thing the probe cannot see, and it is in the code today.

**(b) The debutant is a different boxer in the v13 arm.** `STYLE` (:20) gives the bow house "Pressure fighter / Loads up
when hit" and the hf house "Out-boxer / Backs onto the ropes", and `card` (:49-51) and `sign` (:97-99) put both on the booked
opponent. The game has one debutant for both houses: "Boxer-puncher", "Heavy right hand", **"Fades after round 3"**
(`DebutOpp` :15-17). Overwriting `weak` deletes the fade, which is worth `OPP_FADE` **1.5 rating points from round 3**
(`BoutRead` :337-338, `BoutRules` :90) on a four-round card - a third of it. So the v13 arm's night, its card and its aim
search are all measured on an opponent the build order does not list and the owner ruling ("the debutant it picks does not
change") forbids. Either the styles are part of v13 - then the ruling must be rewritten and the build order must say so - or
the probe measured a mechanic nobody will build.

**(c) A smaller one.** The removed style also removes the "walks in" word that `_games` reads (`BoutRead` :279), so the bout
mix changes twice over. The stage A readings (60.3 / 78.1 shown) are correct for the probe's opponent, not for the game's.

### 3.5 One pass-rule nit

`beats` (`sum.py` :73-77) uses `wins > -LINE_WINS` and `cash > -LINE_CASH` (strict), while bar 5's trade test uses
`wins <= -LINE_WINS` (:221). At exactly the line the two disagree. Probe 12's section 4 already recorded a transitivity
problem at $1,000 and v13 did not fix the rule; with the measured margins (-28.2 wins) it does not bite here, but the next
map with closer numbers will read a "trade" where the pass rule says "beaten".

---

## 4. The result's own limits (its section 2), scored

For each: does it lower the score, and does the mechanic the player gets come out as one decision or a road of decisions?

| Limit (result section 2) | Lowers DEPTH? | Lowers PLAY? | What I make of it |
|---|---|---|---|
| **Two options are easier to pass than three** - bars 7, 8 and 11 were written for a screen with asks | **Yes.** The audit bars stop being audits (3.3). The honest size of the mechanic is what the result says: one decision and a real trade. | No | The result is honest; the map's header ("every audit bar") should be. This is why 14 of 15 is worth about 9 of 15 as evidence. |
| **The bot does not read the +2 / +5 line** | **Yes**, in the direction the result does not say: the +8.4 name lead is what a bot that **ignores** the line gets, and a bot that reads it would take more step ups at the guarantee house after 3 wins. The measured lead is the worst case for the hard road's name, not the best. | **Yes.** The play the rule is supposed to create ("an easy win is not news, so take the hard one") is never played by anyone in the probe. | The result calls this "for the critics and the build's play test" - it is the build's whole job, because without it the +2/+5 is a label, not a decision. |
| **The ticket house is never the one answer** | **Yes.** By the pass rule the guarantee house is right in 4 of 4 cells and the ticket in 3 of 4: the safe house is weakly dominant, and it is strictly better in the one cell where the name is worth nothing. A player who reads the numbers never has a cell where the hard road is the best pick - only a cell where it is not beaten. | Yes (mild) | "Never the one answer" plus "right wherever the other is" is the definition of a dominant option. The only reason to pick the hard road is a preference the game's own brief (2.2 in the map: "a coach picks a promoter on who they will put in front of his boxer, not on a few hundred dollars") says a coach does not have. The mechanic rewards thinking like an accountant in a game whose fiction is a coach. |
| **28 debut wins in 100 given away** | No - it is the trade's price, and the price is what makes it a trade. | **Yes, badly.** One career, one debut: 51 vs 79 in 100 is the most load-bearing night in the boxer's life, and the loss is punished three times (no name, no seat, a rebuild fight that itself pays +2). | This is the number that decides the PLAY score. A 49-in-100 loss of the one night the player has been working toward, for about $48 a week over 40 weeks and a name that needs room, is not a fair trade in felt terms. In real boxing a manager protecting a prospect picks the soft touch every time - which is why the guarantee house exists - and no real manager would trade his boxer's 0-0 record for the promoter's gate. |
| **The gyms that close more often** (16-25% against 9-14% with room) | No | No (a bot artefact) | It lowers confidence in the cash *level* (every modelled career ends $6,800-$13,400 down: the cash axis is the difference between two insolvencies) but not in the paired *gap*: the "no gym closed" table is $70-$150 smaller, so the closure inflates the ticket lead by about 5%. The bigger point is the one the result does not draw: the bot does not run the gym, so **the map's premises interconnect is untested**. The ticket house's whole cash lead is $1,900; the move to the bigger unit is $12,000 down and $750 a month. The interconnect cannot pay for itself: "in a full gym it still pays nothing until the player makes room … and that is where it flips" (map section 3) is asserted, not measured, and the arithmetic says the name cannot buy the room. |
| **A debut loss is not paired** | No | No | Already covered: bar 12 cannot support the map's "$2,287 behind". Either pair it (force both outcomes from the same dice at the debut) or drop the sentence. |
| **The debut gap grew** (51/79 in careers against 55/78 in probe 12) | No | No | A warning: the headline lead is driven by the call-day population (36 call days now), and the map quotes the 28-win gap as if it were a property of the houses. It is a property of the houses **and** the boxers the game happens to have. |

**One decision or a road of decisions?** One decision, and the road is not a road of decisions:
- the **kind** of every fight is the house's (`road()` :156-159), not the player's, for the first three pro wins at the
  guarantee house and for every non-rebuild fight at the ticket house;
- so the +2/+5 choice exists only where a guarantee-house set contains both a tune-up and a step up - from the fourth pro
  fight - and never at the ticket house at all;
- the player's remaining pick inside a set is between two rows of the same kind (where the bot's nearest-65 is a fair proxy),
  which is the *existing* pro-ladder choice, not a new one;
- the screen is going to answer the house question anyway: the room line ("your gym is nearly full") is the same information
  the probe uses to decide the flip. A mechanic whose right answer is printed on the card is not a decision.

The map's own section 6 item 3 claims the depth is "in the six fights of the road". It is not. It is in the house.

---

## 5. The options: missing, useless, and what each changes

### 5.1 What each option changes (owner S403)

| Option | What it changes, measured | What the player sees |
|---|---|---|
| The ticket house | Debut 59 in 100 played (card 60); on a win +5 and +1 a 4 seats (up to 20) reputation, and the table's last seat (rank 20, $1,900 purse, may ask 5 up); on a loss a rebuild flag and no name and no seat; the next five sets are step ups and a payday; +$1,812 to $1,976 gym cash and +8.1 to +8.7 reputation by week 40 with room; **-28 debut wins in 100** | A big card number and a big name number, both with the hard night attached |
| The guarantee house | Debut 78.8 played (card 78.1); +5 on the debut; unranked on the table; tune-ups for the first three wins, then a step up; no payday; +$0 cash and +0 reputation relative to itself; the safe night | The same card as today (79.1 played today): no new feel |
| Later +2 | -$150 purse, +2 weeks, card +2.0, played +2.1 / +1.1. It cannot move the fork | "A calendar tool" - the map's words, and right |
| Stay amateur | no change to the road; -8 loyalty; morale 0 for every goal that exists; one more decline; 0.9x terms next time; a higher gate (9 wins + top 3, then rank 1) | An honest hover, for once |

### 5.2 Missing options (in order of what they would add)

1. **The kind of the next fight** - the only +2/+5 decision that would make the road a road. Today the house decides it.
2. **The debut opponent** - the player's own pick between two named debutants (one to test, one to build), which is the one
   lever a real manager holds and the one the probe's per-house styles already assume exists.
3. **A way to spend the name when the gym is full** - otherwise the full cell is "nothing happens" and the flip is a hole.
4. **The ask's place in the new rule** - an asked fight must have a kind (see 3.4a), or the safe road buys the name back.
5. **The terms, not just the house** - one negotiation on the road itself ("three tune-ups, then a step up" against "step ups
   from the first night"), which is what the promoter's identity actually is. This is the natural replacement for Later +2.
6. **The boxer's own money** - the map keeps three club money numbers and never shows what the *boxer* takes; the brief says
   the money is the boxer's. A coach's decision about his boxer's career should carry his boxer's purse on the card.

### 5.3 Useless (or dead) options and ink

| Element | Why it is dead | What to do |
|---|---|---|
| Later +2 as the screen's only ask | Measured at +2.1 / +1.1 played: inside the noise of a calendar tool. It cannot change the fork, and the offer screen cannot even see the injury or the weight it is for | Either give it a visible cause ("out for 3 weeks: the extra 2 weeks puts the debut after it") or cut it and have no ask. "One button" plus dead numbers is worse than no button |
| The `$1,800` guarantee purse against `$1,500` | Probe 11's $104; the map keeps it "because it decides nothing" | That is the argument for making the two purses equal, not for keeping a dead number on the card |
| The dashed "seats on the night" on the guarantee card | It only feeds the ticket house's name | Draw it on the ticket card only |
| "+5 reputation" on every non-tune-up row | True everywhere, so it is noise on 90% of rows | Print the number only where it differs from 5 (the tune-up's +2), and let the header say the rest |
| The three money rows in small type | Both modelled careers end insolvent; the cash axis is $48 a week | Cut the cash line and price the fork in members (see 7.4) |
| The "room line" as proposed | It prints the answer | Print the arithmetic instead ("room for 4 more: +8 reputation brings 5 - 1 will not fit") |

Options correctly **cut** (I agree, with the reason the probes give): Softer (right in 0 of 4 cells; the guarantee house done
worse), own ticket price ($13 at most), costs from the purse (the one answer, so not a decision), better split, Later +4.

---

## 6. What I would tell the owner in one line

*The map is honest and buildable; the mechanic is one decision where the safe house is never wrong, and the tune-up rule pays
the hard road by fining the safe one - put the +2/+5 choice in the player's hands and it becomes a road of decisions.*

---

## 7. To reach 10/10 (most important first)

Each item says what to build, where, and how it is measured. I have kept the order by leverage on DEPTH and PLAY, not by
ease.

1. **Give the player the kind, on every set.** Both houses' first-five sets after the debut carry **a tune-up and a step up**
   (the house sets the aims, the purse, the lead and the purse split; not the kind). `ProLadder.book` writes the kind into
   `f["bout"]`; `BoutFinish` :98 pays 5 or 2 from it; `ProFights` :161-163 row already draws the chip. Keep `road()` only to
   set the aims and to add the lean.
   *Measure:* a probe arm whose bot reads the +2/+5 line (a name-chaser against the win-chaser); bar 13 becomes "inside one
   house, the two players book different kinds". *This is the item that turns the mechanic from one decision into a road of
   decisions, and it costs one field on the bout.*

2. **Let the player pick the debut night.** Two named debutants a house, one picked to build and one picked to test, both
   drawn by `DebutPick`'s own search and both shown with their card; the player picks one. Put the probe's per-house styles in
   `DebutOpp` (:15-17) **or** drop them - they cannot coexist with the owner ruling "the debutant it picks does not change"
   (2.4, 3.4b). *Measure:* DEBUTPICK1's 22 cells again, now per boxer; bar 4 becomes a per-boxer check.

3. **Make the name worth something in a full gym - or make room cheap.** The full cell is the flip, and there the name is
   worth zero. Either show the name's second payout as a number on the card (the club show's gate, `ClubShow.draw` :26-27;
   the grant's odds, `Grants.chance` :28-29; the card ask, `CardAsk.chance` :74-75 - the game already reads reputation in all
   three), or cut the move's price so the $1,900 lead can actually buy room (the move is $12,000; the loan is $3,000 down).
   *Measure:* a new cell at 66/70 members with the move available on the loan; the fork must trade there, not collapse.

4. **Price the fork in the player's currency: members, not dollars.** On each card: "8 reputation = 5 members = $40 a week
   while there is room". Drop the cash line (both modelled careers are insolvent; the cash axis is the bot's, not the player's).
   *Measure:* the same cells; the trade reads in one unit and the player can see the room.

5. **Make the card honest per boxer, not on the mean.** Replace the flat "+0.2 over 60" with a table or a band, and print a
   band ("about 74-82%"); bar 4 must be checked per boxer with a stated tolerance (today it is a mean over six).
   *Measure:* stage A per boxer, shown against played, worst case within 5.

6. **Close the ask loophole in the new rule.** Every booked pro fight carries a kind: an asked ranked name is a step up
   (+5); the guarantee house's 3-win gate applies to asks as well as to rows; and the rule pays 2 **only** for a row the
   promoter labelled a tune-up. *Measure:* a probe arm that asks (the bot takes the best asked name), against the passive bot;
   bar 15 must hold for both, or "the name stays" is not true.

7. **Pair bar 12.** Fork the same career at the debut and force both outcomes on the same dice (the fight is settled by dice;
   you can run the loser's career forward too). Then the loss's cost is causal and the map may quote it.
   *Measure:* bar 12 on paired careers, with the paired error.

8. **Give the road an answer for an empty set.** A set with no legal row is a promoter's silence (call again in a week, with
   a news line) or a row with a stated penalty; never a silent revert. Add the state test ("a ticket-house set with no step up
   and no payday").
   *Measure:* the state test; and a probe check that no career books a kind its house's road removed.

9. **Cut the dead ink and give the one ask a cause.** The $1,800/$1,500 difference, the dashed seats on the guarantee card,
   the "+5" on every row, the three money rows. Later +2 either shows the injury or the weight it fixes, or it goes and the
   screen has no ask at all (with the road term of item 1 as the negotiation).
   *Measure:* the screen shows nothing the player cannot act on (owner C443).

10. **Prove it with the player in the loop.** Three arms on the same rolls (name-chaser, win-chaser, today's bot) and one
    play-test of a single career from the call to the fourth pro fight. The bar to hold: the two players' roads differ, the
    name lead survives the name-chaser, and the hard road is the best pick in at least one cell for a player who wants the
    name.
    *Measure:* the same probe, one new arm; plus the play test (the result's own list of state tests is good and should run).

If items 1, 2, 3, 5 and 6 land, I would expect DEPTH 8 and PLAY 8 on the same probe. Items 4 and 7 are what make the numbers
believable; 9 and 10 are polish and proof.

---

## 8. My 10/10 page at 1920 x 1080

One sheet, no modal stack, warm plaster wall (Look B). Names only in the header. Nothing the player cannot act on. Every
number that is a choice is on the thing it changes.

```
+----------------------------------------------------------------------------------------------- 1920 x 1080 --+
| A CALL FROM BOW LANE AND HARROW & FINCH                     THE OFFER STANDS 9 MORE DAYS   [Stay amateur]        |
| TURN <BOXER> PRO?                                                                                              |
| Amateur 12-1, number 2 in the London rankings.  Declines left: 3.                                              |
+----------------------------------------------------------------------------------------------------------------+
| THE ROAD YOU ARE BUYING        (six boxes across, both cards read the same strip)                              |
|  [ DEBUT ][ FIGHT 2 ][ FIGHT 3 ][ FIGHT 4 ][ FIGHT 5 ][ FIGHT 6 ]                                              |
|  each box: chip STEP UP / TUNE-UP / PAYDAY  +5 or +2 reputation,  the player picks which inside the box        |
+------------------------------------------+----------------------------------+----------------------------------+
| THE TICKET HOUSE                    920  | THE GUARANTEE HOUSE          920 |  (the same card, the same rows)  |
| a hard first night in front of the hall  | a safe first night, then tune-ups|                                  |
| VS <DEBUTANT>  Pressure fighter          | VS <DEBUTANT>  Out-boxer         |                                  |
| Debut, 4 weeks out  [watch him] [build]  | Debut, 6 weeks out [watch][build]|                                  |
| Win chance  about 58% (55-62)            | Win chance  about 78% (75-81)    |                                  |
| A win: +5, and +1 for every 4 seats      | A win: +5 reputation             |                                  |
| Tickets 68 of 100 (break-even 60)        | Tickets 68 of 100 (break-even 70)|                                  |
| A loss: a rebuild fight, 2 fans          | A loss: a rebuild fight, 0 fans  |                                  |
| THE GYM: room for 9 more members         | THE GYM: room for 9 more members |                                  |
| +8 reputation = 5 members = $40 a week   | +0 reputation = 0 members        |                                  |
| What the boxer takes: $1,180             | What the boxer takes: $1,320     |                                  |
| [ Sign with this house ]   [ Later +2 ]  | [ Sign with this house ] [Later+2]|                                 |
+------------------------------------------+----------------------------------+----------------------------------+
| ONE ASK (both houses): Later +2 weeks - it puts the debut after <injury/weight> - $150 off the purse.           |
+----------------------------------------------------------------------------------------------------------------+
```

- **The strip is the page's idea.** The six boxes are the mechanic: every box carries its kind and the name it makes, and the
  player's pick of a box is the +2/+5 decision (item 1). It fixes the map's biggest over-claim by making it true.
- **The two cards are symmetrical and short.** Ten rows each, all of them actionable: the debutant (with "watch him" and
  "build" - item 2), the chance with a band, the win's name, the loss's mark, the room, the reputation in members and weeks,
  the boxer's take. No cash lever, no pays-back sentence, no "$75 a week", no step/top promise, no "+N loyalty".
- **The room row is arithmetic, not an instruction.** "Room for 9 more" and "+8 reputation = 5 members = $40 a week" lets the
  player work out the full-gym case without the screen telling them which house to pick.
- **The one ask** names the cause it fixes. If there is no cause, it is not drawn.
- **What is gone:** the second break-even mark (both marks are on their own card now), the dashed seats on the guarantee card,
  the "+5" on every other row, the "$1,800 guaranteed" as a fake lever, and every name outside the header.

---

## 9. The board line, checked

The map's line for the owner's board: *"Turning pro: room and a big hall - the hard road. Full gym or a fragile record - the
safe one. OK to build?"* It is honest about the fork as measured - with one correction the probe already knows: the hard road
is a **49-in-100** first night, and its cash lead is $48 a week. A board line that says "room and a big hall" makes it sound
like the hard road is the ambitious, high-reward pick. It is the pick for a gym with room and a boxer who can afford to lose
the biggest night of his career. That is a real choice in real boxing and a bad one in this game's reward structure.

---

## 10. The code files I opened

`scripts/state/Roster.gd` · `scripts/state/ProOfferWire.gd` · `scripts/state/ProLadder.gd` · `scripts/state/ProLean.gd` ·
`scripts/state/BoutFinish.gd` · `scripts/state/Bouts.gd` · `scripts/state/Needs.gd` · `scripts/state/Sim.gd` ·
`scripts/state/Clock.gd` · `scripts/state/Champs.gd` · `scripts/state/HomeBout.gd` · `scripts/state/LoyaltyWire.gd` ·
`scripts/state/GymDeals.gd` · `scripts/state/GymSpend.gd` ·
`scripts/rules/ProCall.gd` · `scripts/rules/ProDebut.gd` · `scripts/rules/DebutPick.gd` · `scripts/rules/DebutRead.gd` ·
`scripts/rules/DebutOpp.gd` · `scripts/rules/BoutRead.gd` · `scripts/rules/BoutRules.gd` · `scripts/rules/Matchmaking.gd` ·
`scripts/rules/Membership.gd` · `scripts/rules/Loyalty.gd` · `scripts/rules/FighterProfile.gd` · `scripts/rules/Recruit.gd` ·
`scripts/rules/Attrs.gd` · `scripts/rules/GymBills.gd` · `scripts/rules/GymUpgrades.gd` · `scripts/rules/ClubShow.gd` ·
`scripts/rules/Grants.gd` · `scripts/rules/CardAsk.gd` · `scripts/rules/NextStep.gd` · `scripts/rules/AskDates.gd` ·
`scripts/ui/modals/ProOffer.gd` · `scripts/ui/ProFights.gd` · `scripts/ui/ProWeekLines.gd` · `scripts/ui/RosterActs.gd` ·
`scripts/ui/Main.gd` · `scripts/ui/OfficeDesk.gd` · `scripts/ui/BoutHistory.gd` · `scripts/ui/MoneyPanels.gd` ·
`scripts/ui/WorldCompare.gd` · `scripts/ui/TestJump.gd` · `scripts/ui/areas/FighterPage.gd` · `scripts/ui/areas/Money.gd` ·
`tools/turnprobe13.gd` · `tools/turnprobe13_rules.gd` · `tools/turnprobe13_sum.py`

Read as documents, not code: `ops/research/TASK_TURNPRO13CRIT.md`, `ops/research/DESIGN_TURNPRO1_V13.md`,
`ops/research/DESIGN_TURNPRO1_V13_CRITIC_JOHN.md`, `docs/TURNPROBE13_RESULT.md`, `docs/TURNPROBE12_RESULT.md`.

No file but this one was written. Godot was not run. The probe was not re-run (no JSONL in the repository).

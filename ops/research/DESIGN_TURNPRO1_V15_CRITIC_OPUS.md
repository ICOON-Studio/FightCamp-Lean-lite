# Turning pro v15 - code-checked critic (Opus, S540)

Task: `ops/research/TASK_TURNPRO15CRIT.md`. Read at main `ee2e54762` (23 Nov 2026; the map was written at the S537 tree). Research only:
no game file changed, Godot not run. I opened the brief, the whole map (`ops/research/DESIGN_TURNPRO1_V15.md`), the probe
(`tools/turnprobe15.gd`, `tools/turnprobe15_rules.gd`, `tools/turnprobe15_sum.py`), its result (`docs/TURNPROBE15_RESULT.md`) and every
code file the map cites (list at the end). The task names a v14 critic "`DESIGN_TURNPRO1_V14_CRITIC_FABLE.md`": that file does not
exist. The "one decision and two habits" finding is the v13 critics' (quoted in the map's section 0); v14 had only Kalli's
paper critic (Depth 6 / Design 7 / Play 6, unprobed). I judge v15 against that finding.

SCORE depth=6 play=6 general=6

It fails the 8 / 8 bar. It is better than v13 (5 / 5): there are now three real choices instead of one. But each choice is
only live at one of the two houses or in one size of gym. Everywhere else it is already answered, and the probe's bars could
not have shown that.

## 1. The verdict in five lines
1. **Three decisions, each half alive.** The house is a real trade in a mid-sized gym (46-74 seats). The debut night is a
   real trade only at the ticket house. The kind of each fight is a real trade only at the guarantee house. A player at either
   house meets two real choices and one already answered.
2. **"Do what the house wants" is never wrong.** The favour-keeper bot (follow the house's kind) is "right" in 6 of 6 house
   x gym cells and 35 of 36 boxer cells. At each house it plays the same fights as one of the other two bots, within every
   line. A policy that is never wrong and needs no reading is a habit, not a decision.
3. **Most bars pass by construction.** Bars 13 and 17 are true by definition. Bar 4 compares the engine with itself. Bars 7,
   8 and 11 are kept alive by the record axis, where tune-ups always win (section 4).
4. **The favour has real teeth (stage F) but pulls the wrong way at the ticket house.** There, the step up already wins on
   name, cash and rank, and the favour widens that lead. At the guarantee house it is the true counterweight to the name.
5. **The map is not one document yet.** Sections 3d, 7, 9 and 11 still print v14's "+2", "offers stand 4 days" and "only
   tune-ups under 3", which section 0a cut. The screens would be built from the cut text.

## 2. CODE claims checked (about 95 CODE statements, 183 line citations, every one opened)
Almost every claim is TRUE at `ee2e54762`: the function exists, it does what the map says, and the line is the one cited or
inside the cited function. The exceptions:

### FALSE (3)
| # | Map says (section) | What the code does |
|---|---|---|
| F1 | 1 ("lines v14 builds on"): "`DebutOpp.name_for` :22-24 ... A second debutant for the same house is the next name on the list." | `scripts/rules/DebutOpp.gd` `name_for` :22-24 picks `names[posmod(day + promoter.length(), 4)]`. It takes no index. Two debutants from the same house on the same day get the SAME name. "The next name" is a proposal; the probe's two debutants (`turnprobe15_rules.gd` `read`/`card` through `DebutOpp.make`) also share one name. Build item 2 must add an index argument. |
| F2 | 1 and 11 item 0: "`AskDates.wait_words` :119-122: the asks screen says 'A month without a fight costs 6 morale'" | `scripts/rules/AskDates.gd` :119-122 now returns only "Wait for the sheet: likely in N to M weeks, date unknown." The sentence went in S539 (comment :120, "HOSTPROBE1 + TURNPRO15 step 0"). Build item 0 is DONE. The claim is stale. `FighterProfile.MORALE_EVENTS` still has `month_no_fight: -6` (:25) and nothing applies it. |
| F3 | 3c: "a tune-up is read near 82 in 100, the next fight comes 6 weeks later" | `scripts/rules/Matchmaking.gd` `next_weeks` :283-285: 6 weeks (`QUICK_WEEKS` :32) only when the opponent is 6+ points under (`SOFT_GAP` :43); 12 (`HARD_WEEKS` :33) only when 2+ over; otherwise 8 (`NEXT_WEEKS` :31). A tune-up is picked by read (0.70-0.93, `ProLadder` :24-25), not by gap, so it is usually an 8-week night. |

### PARTLY TRUE (2)
- 3c "a step up ... earns a fan more ... the next fight 12 weeks later": both hold only when the opponent is rated 2+ above
  (`Matchmaking.apply_result` :242, `next_weeks` :284). A step up is chosen by rank and read (nearest 0.50), so usually, not always.
- 1 "`Matchmaking.pay_of` ... a ranked name above adds $150 a place": it adds $150 x (21 - the opponent's rank) (:220-221).
  That grows with how high the name sits, not with how many places above your boxer.

### Lines moved (content TRUE; the map's line numbers are 1-3 off at this commit)
- `scripts/state/BoutFinish.gd`: members/reputation on a win :99/:101 (map :96/:98); `Attrs.wear_stoppage` call :104-105 (map
  :101-102); later pro purse :120-125 (map :117-122); morale :179 (map :176); loyalty :180+ (map :177-178); `check_pro` :222
  (map :219). **Build item 4 "`BoutFinish.gd` :98 pays 2" points at the `pro_w` line. The reputation is :101.**
- `Roster.check_pro` callers: `Sim.gd` :414 (map :415), `Bouts.gd` :466 (map :457). `Bouts.accept` :194-201 (map :192-200).
- `scripts/ui/OfficeDesk.gd` :39 is `const WEEKS := 8`; the pro-offer entry is :42.

### Checked TRUE (selected, the lines v15 leans on)
`ProLadder.book` :337-368 writes no kind (:360-362) and spends a softer-ask set on any booking (:342-343). `_make_offers`
:175-216, with the step up dropped on rebuild or two ducks (:209). `ProLean.LEAN_KIND` :8 / `extra` :12-33 add a row and never
remove one. `Matchmaking.note_choice` :196-201 / `DUCKS_BLOCK` :39. `ask` :188-190. `WorldRank.champion_of` :164-168. `_take_belt`
:303-311. `ROUNDS_TITLE` :36. `ProLadder.result` :372-378 (the debut joins and returns). `MM.join` :68-82 (0 fans, no rebuild).
`_review_streak` :407-420. `DebutPick` :15/:17/:34-36/:48-67/:71-78. `DebutRead.card` :17-24 (the weeks are not read). `ProCall.who_calls`
:63-69, `promoters` :35-59, `debut_purse` :99-108, `terms` :73-95, `morale` :298-308 (no goal holds "pro": `Recruit.ambition` :122-126).
`ProOfferWire.make` :25-41, `lapse_if_due` :187-197. `Roster.pro_ready` :186-196, `turn_pro` :265-315, `decline_pro` :324-334.
`Loyalty.MOVES` :60-61. `LoyaltyWire.idle_week` :44-53. `Needs` :67-70/:140-141/:167-168. `Main.on_go` :195-199. `Clock.stop_now`
:79-83. The `ProOffer` modal (:35-45, :56-81, :97, :139-143, :154-167). `ProFights` :21/:117/:126/:142/:155-163/:300. `ProWeekLines`
:15-50. `Membership` :15-16/:38-53/:83-92. `GymSpend.member_cap` :160-161. `GymUpgrades` :27-29/:127. `GymDeals.pro_camp` :22-35.
`Bouts.can_swap` :261-263.

### The map against itself (not code, but it would be built wrong)
Section 0a says it wins over older lines. The lines it overrides are still the ones a builder would copy:
- "+2" for a tune-up win: 3d ("A tune-up is worth 2 reputation"), 3c last bullet ("+2 against +5"), section 7 (rows, week
  review "Tune-up win: +2 reputation"), section 9 (bots read "the +2 / +5 line"), the golden path ("its '+2' line"), build
  item 4 ("pays 2"). v15 is +1.
- Section 7's favour head: "Favour 2: the house brings only tune-ups until you take one. Offers stand 4 days". Build item 6:
  "under 3 the 4-day set of the house's kind". Both were CUT in 0a, replaced by "dated 3 weeks later".
- Section 7 names no screen for the two v15 rewards: the $250 block (top of the bill) and the late date (bottom of the bill).
  Neither is wired to a menu in the table, which breaks the owner's "wired and shown" rule (S425).
- Section 9 says stage F runs "on 72 rolls"; the result read 36 (6 call weeks x 6 boxers).
- The probe's own comments are stale too (`turnprobe15_rules.gd` `FAV_LOW` "brings only its own kind"; the `road` doc). The code
  does the v15 thing (`booked`: +21 days). Harmless, but say so.

## 3. Does the probe model the map? Mostly yes
- **Rules copy against the map:** the favour start (5), the night pick (+/-1), the booking moves (+1 the house's kind or
  the title; -1 the other kind only when the house's kind was on the table), rebuild and payday moving nothing, top of the
  bill at 8+ ($250 to the gym at booking, +$300 purse at the guarantee house), bottom under 3 (+21 days), the title row (the
  ticket house, favour 8, 4 pro wins, not rebuilding, no belt held), the tune-up name 1, the test night's seat name (1 a 4 /
  1 a 8, max 20), the ticket house's last seat, the debut on the table (fans, rebuild): all as the map says.
- **The duck count sleeps** on the road: the probe zeroes `ducks` every road set. Good.
- **The fill-in rows** (`_candidates`) copy `_make_offers`' search with the tune band widened. Good. With that rule, "both
  kinds on the table" was 100% at both houses.
- **The card's own nights:** `_own` plays the signed boxer to the morning of the debut, camp included, and fights 500
  scratch nights against debutants read 0.72 and 0.50 (scratch days from 1,000 on). Stage A then plays the same boxer, same
  call day, same engine, on scratch days 0-999. So the card is a Monte Carlo of the bout it is checked against. Only the
  straight line between two debutants and the dice are under test. That is honest by construction, which is the design's
  point, and fine. But bar 4 can only fail through noise or a bad line, and stage A is one call day per boxer (6 cards).
  The real open question is the one the map leaves as CHECK: the cost of 2,000 hidden bouts when the call arrives. No bar
  measures it.
- **Not modelled:** a player who reads the boxer's form, the gym's room or a title two wins away. The map's own depth claim
  in 3d ("a boxer coming off a hard night, a gym with no room, a title shot two wins away: each changes which kind is right")
  is never measured. Every bot is a fixed rule.
- **The background:** every option ends $6,000 to $13,000 below its $12,000 start by week 40, and 7-24% of gyms close in the
  48 and 64 cells. The cells force members down to make 48 / 64 seats, and the bot does not run the gym. The mechanic's
  $1,000-2,000 differences sit inside that loss. The closure rate also differs by option (cell 48: 11% for the ticket test +
  step ups against 23% for the guarantee build + tune-ups), and no bar reads it. Either that is the mechanic's biggest effect
  or it is the probe's leak. Measure against a no-pro control before quoting it.

## 4. Which bars could pass while the mechanic stays shallow
| Bar | Why it passes | Shallow anyway? |
|---|---|---|
| 13 (two bots book different kinds) | The bots are defined by kind ("name" books step ups, "win" tune-ups). With bar 17's fill-in rule, 86 points apart is guaranteed. | Yes: true by definition. Measures the bots, not the player. |
| 17 (both kinds on 80%+ of sets) | The fill-in rule adds the missing kind whenever the table holds one. Read 100%. | Yes: it measures the rule, not the choice. Keep it as an instrument bar. |
| 4 (card honest) | The card is the same engine's own nights (section 3). | Yes, in the good sense: it can't really fail. The cost is unmeasured. |
| 7, 8, 11 (no road the one answer; every road right) | "Right" = beaten by nobody on cash / name / record, with a line of 1 win less loss. Tune-ups are read ~82, step ups ~50, so the tune-up bot ALWAYS leads the record by 1.1-2.4. The step-up bot always leads the name by 5-8 because a tune-up pays 1 and a step up 5. Neither can be "beaten", whatever else happens. | Yes. At the ticket house the tune-up road is $2,000 and 8 name behind, and 27 points less often ranked (67% vs 94%). Only the record keeps it "right", and the record buys nothing the probe can see. Drop the record axis, or replace it with what the record buys (rank, the ranked purse), and bar 7 likely fails at the ticket house. |
| 10 (the name is the kind's) | Part two follows from TUNE_NAME 1 against 5. | Partly. Part one (the rule takes 13-16 name from the tune-up road) is a real size. |
| 15 (the favour moves the result) | A bonus only at 8+ and a penalty only under 3, with "keeper" and "rebel" defined to sit there, give the sign by construction. | The sizes are real and good: keeper +$1,300 to +$3,200 over 80 weeks, rebel -$1,400 to -$2,200 and 57-73% of fights dated late. But on against off for the SAME bot does not show that the favour changes WHICH road is best. That is the bar that matters, and it was not run. |
| 16 (the night is a trade) | Passes on the ticket house. | At the guarantee house build beats test in 2 of 3 cells, and the 64 cell's "trade" is +3.0 name on a 3.0 line (error 0.4). The guarantee test night is a dead button. |
| 5, 6, 9 (the house) | Real: +$1,900 to +$2,000 and +13 name against -23 debut wins in 48/64; the guarantee house wins in a full gym. | But in a full gym 142 of 216 calls were skipped because only the ticket house called (75+ seats). The winning club, the one most players will run, mostly gets no house choice. |

**What I would measure instead:** (a) a READER bot (tune-up after a stoppage or a loss, step up when fit and on a win streak,
the title when it is open) against the best fixed bot, on the same rolls. Depth = the reader beats every fixed policy by a
line in at least half the cells. (b) Bar 7 with cash, name and RANK (no record). (c) Stage F as keeper against name-chaser at
the guarantee house over 80 weeks, favour ON and OFF: does the favour flip the best road anywhere? (d) The share of real calls
(the bot's own road, no forced members) where both houses call.

## 5. "One decision and two habits": fixed?
**Partly.** v13: the player chose the house, and the house played the road. v15, from the probe:

| Decision | Live (a trade on the probe's lines) | Already answered |
|---|---|---|
| The house | 48 and 64 seats: the ticket test + keeper is +$1,900 to +$2,160 and +13 name for -23 debut wins | A full gym: the guarantee house beats it. 75+ seats: only the ticket house calls (2 of 3 full-gym calls) |
| The debut night | The ticket house: test is +$1,250, +7 name for -10 debut wins | The guarantee house: build beats test (cash 0 to -$630, name +2.5 to +3.0 for -8 to -11 wins) |
| The kind of each fight | The guarantee house: step ups +6.9 name and +22 points ranked, for -1.9 wins less losses and the favour (2.6 at week 40, so bottom of the bill later) | The ticket house: step ups win on cash (+$2,000), name (+8.3) and rank (94% vs 67%). Tune-ups lead only the record. The favour adds to the step up's lead |

So a career now has two real decisions and one habit, at either house. The keeper bot is the habit: it plays the same
fights as the name-chaser at the ticket house (75% vs 86% step ups; cash within $130, name within 0.4) and as the
win-chaser at the guarantee house (cash within $140, name 2.2, record 0.3, all inside the lines). "Book what the house
prefers" is never beaten anywhere. That is the core reason DEPTH is not 8.

## 6. Scores
**DEPTH 6.** Up from 5. Three trades exist and the favour has real weight (stage F: about $2,500 a career between keeping and
rebelling). But each trade lives in one house or one gym size, the house's preferred road is never wrong, the payday row is
booked by no bot (0% everywhere), and nothing shows that reading the boxer's state beats a fixed rule.
**PLAY 6.** The new moments are good: picking the night with two named debutants, the "+1 / +5" on every row, "2 more step
ups open the title shot". The rewards are thin or rare: the title shot comes 0.2-0.4 times a career in 80 weeks and never in
the first 40 for most. Top of the bill is $250 a fight with no screen named for it. Bottom of the bill is a wait. A 0-10
meter that only goes up by obeying is a chore, not a lever.
**GENERAL 6.** Buildable from what the game has, and honest about it (CODE / ESTIMATE / CUT). Three false code claims and
moved lines. The map contradicts itself on the numbers a builder copies (+2, the 4-day set). Two v15 rewards have no menu.
The 2,000-bout card is an open cost.

## 7. Options: missing, useless, and what each changes
| Option | What it changes (measured) | Verdict |
|---|---|---|
| Pick the house | Cash ±$2,000, name ±13, 23 debut wins; the door at favour 8 (a title or money) | Keep. Missing: a choice when the gym is big (75+ seats calls one house) |
| Pick the night (ticket house) | +$1,250 and +7 name against -10 debut wins | Keep |
| Pick the night (guarantee house) | Mostly nothing (build beats test in 2 of 3 cells) | Useless as built: give it a reward or cut the second card there |
| Tune-up / step up (guarantee house) | Name +6.9 against the favour and the record | Keep: the real road decision |
| Tune-up / step up (ticket house) | Step up wins on cash, name and rank | Solved: needs a reason to take the tune-up |
| Payday row | Booked 0% by every bot | Useless on the road: unmeasured, unused |
| Later +2 weeks | +1.2 to +2.8 debut wins, $150 off, drawn only with a cause | Fine as a calendar tool; it is not depth |
| Name your opponent | Counts as a step up | Keep. It reads the same as the offered step up, so it adds no choice of its own |
| **Missing:** spend the favour | - | Today favour only piles up. A spend (pull the title shot forward, lift the late date, ask a name outside the band) makes "when to cash in" a decision and ends "obey forever" |
| **Missing:** the house asks YOU | - | A promoter's request (a short-notice slot on its card, the favour +2 or -2) is the classic moment where keeping the house sweet costs something |
| **Missing:** a reason to read the boxer | - | Nothing in the road reads morale, a recent stoppage or an injury when the kind is chosen. A step up after a stoppage loss should carry a visible extra risk; a tune-up when the boxer is flat should lift morale |

Real-world check: promoters do reward a trainer who takes their fights (house fighters get the TV slots, the co-feature, the
mandatory). "Keep busy" against "test your boxer" is the true early-pro question. Real managers also cash in favour ("you owe
us one, give us the co-feature"), and promoters ask favours back (the late replacement, the opponent nobody wants). v15 has
the first half and not the second.

## To reach 10/10 (most important first)
1. **Break "obey the house is never wrong".** Make favour spendable: at 8+ the player may spend 3 favour on one of (a) the
   title shot now, without the 4-win gate; (b) a named opponent one band higher; (c) the top-of-bill slot for one fight below
   8. Under 3, one booking of the house's kind clears the late date for that fight only. New bot "spender": keeps to 8, spends
   on the title. Bar: at each house the keeper and the spender differ by a line, and neither is the one answer in more than 6
   of 10 cells.
2. **Give the ticket house's tune-up a reason** (today it is dominated except on the record). Proposal: the ticket house
   hates a step-up LOSS on its posters, so a step-up loss costs 2 favour, not 0. Or a ticket-house tune-up after a stoppage
   counts as the house's kind (it protects the house's investment). Bar: at the ticket house the tune-up road is "right" on a
   line other than the record in at least 2 of 3 gyms.
3. **Give the guarantee house's test night a reward or cut it.** For example the table's last seat on a test win (as at the
   ticket house), or a guarantee-house test win counting as a step up for the favour. Bar 16 must pass at each house
   separately, not on the pool.
4. **Re-run bars 7, 8 and 11 without the record axis** (cash, name, rank share). If a road is then the one answer, the map
   is not 8 yet. Add the READER bot (section 4a) and require it to beat every fixed bot by a line in half the cells: that is
   the depth bar.
5. **Run stage F as keeper against name-chaser at the guarantee house** (same night, 80 weeks), favour on and off. The favour
   earns its place only if it flips the best road in at least one cell.
6. **Give the big gym a choice.** 75+ seats: the guarantee house counter-calls with a better split or the $300 at signing
   (a bidding moment), so the winning club meets the fork too. Measure the share of real calls with both houses.
7. **Show the two v15 rewards on screens and wire them:** the bill position as a poster on the fight's row and on the result
   ("Top of the bill: the house gave the club 25 tickets, +$250"); the late date as the row's day struck through with "+3
   weeks: bottom of the bill". Add both to section 7's table.
8. **One document:** replace every "+2" with "+1", cut the 4-day / only-tune-ups text from section 7 and build item 6, fix F1
   to F3 and the moved lines, mark build item 0 done.
9. **Price the card:** time one hidden bout and give the 2,000-bout budget (or cache the own-nights line per boxer per stats
   hash and refresh it weekly). It is a design constraint, not a CHECK.
10. **Measure against a no-pro control:** report each option's gym closure and cash relative to the same gym that keeps the
    boxer amateur, so a $2,000 gap is read against the background leak, not inside it.
11. **The payday row on the road:** let a bot take it (a "money" bot), or cut it for the first six fights.

## My 10/10, as a 1920x1080 page
```html
<!doctype html>
<html><head><meta charset="utf-8"><title>Turning pro 10/10 - the road with the house</title>
<style>
body{margin:0;width:1920px;height:1080px;background:#1b1a17;color:#efe8da;font:18px/1.35 Georgia,serif;overflow:hidden}
.top{height:84px;display:flex;align-items:center;padding:0 48px;background:#26241f;border-bottom:2px solid #c9a24a}
.top h1{font:700 30px Arial,sans-serif;letter-spacing:2px;margin:0;color:#f3d37a}
.top .sub{margin-left:28px;color:#b9ad95}
.wrap{display:grid;grid-template-columns:560px 1fr 420px;gap:28px;padding:28px 48px}
.card{background:#24221d;border:1px solid #4a4436;border-radius:10px;padding:20px}
h2{font:700 18px Arial,sans-serif;letter-spacing:2px;color:#c9a24a;margin:0 0 12px}
.pips{display:flex;gap:6px;margin:8px 0}.pip{width:30px;height:14px;border-radius:3px;background:#3a352b}
.pip.on{background:#c9a24a}.pip.top{outline:2px solid #7fd08a}
.line{color:#cfc4ad;margin:6px 0}.good{color:#7fd08a}.bad{color:#e57b6b}.gold{color:#f3d37a}
.spend{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-top:14px}
.btn{background:#2f2b23;border:1px solid #c9a24a;border-radius:8px;padding:12px;font:15px Arial,sans-serif}
.btn b{display:block;color:#f3d37a;font-size:16px}
.row{display:grid;grid-template-columns:120px 1fr 150px 160px 150px;align-items:center;gap:12px;padding:14px;border-bottom:1px solid #3a352b}
.chip{font:700 13px Arial,sans-serif;padding:5px 10px;border-radius:12px;text-align:center}
.tune{background:#2e5a37}.step{background:#6b5520}.title{background:#7a2e2e}.reb{background:#3d3d55}
.poster{display:flex;gap:10px;margin-top:10px}.slot{flex:1;border:1px dashed #6d6450;border-radius:6px;padding:8px;text-align:center;font:14px Arial}
.slot.you{border:2px solid #7fd08a;color:#7fd08a}
.ask{border-left:4px solid #e0a33a;padding-left:14px}
.small{font-size:15px;color:#a99f8a}
</style></head><body>
<div class="top"><h1>NEXT FIGHT</h1><span class="sub">Pro fight 3 of the road &middot; record 2-0 &middot; ranked #18 &middot; fans 4</span></div>
<div class="wrap">
 <div class="card">
  <h2>THE HOUSE (header: its name)</h2>
  <div class="line">Prefers <b>step ups</b>. Hates a step-up loss on its posters.</div>
  <div class="pips"><span class="pip on"></span><span class="pip on"></span><span class="pip on"></span><span class="pip on"></span><span class="pip on"></span><span class="pip on"></span><span class="pip on"></span><span class="pip on top"></span><span class="pip"></span><span class="pip"></span></div>
  <div class="line gold">Favour 8 of 10: TOP OF THE BILL. The club gets 25 tickets (+$250) every fight.</div>
  <div class="poster"><div class="slot you">MAIN EVENT<br>your boxer</div><div class="slot">Co-feature</div><div class="slot">Undercard</div></div>
  <h2 style="margin-top:22px">SPEND THE FAVOUR</h2>
  <div class="spend">
   <div class="btn"><b>Title shot now (-3)</b>Skips the 4-win gate. Area champion, 10 rounds, read 41%.</div>
   <div class="btn"><b>A name one band up (-3)</b>Ask #11, not #13. Ranked purse +$1,200.</div>
   <div class="btn"><b>Keep it</b>Stay on top of the bill; the title opens free at 4 wins (2 to go).</div>
   <div class="btn"><b>Lend it back</b>Take the house's request (right) and earn +2.</div>
  </div>
  <div class="small" style="margin-top:12px">Under 3: bottom of the bill, every fight 3 weeks later. One fight of the house's kind lifts it for that night.</div>
 </div>
 <div class="card">
  <h2>THIS WEEK'S FIGHTS (offer stands 7 days)</h2>
  <div class="row"><span class="chip tune">TUNE-UP</span><span>Unranked, 6-3 &middot; read 81%<br><span class="small">Your boxer was stopped 8 weeks ago: a safe night lifts morale +4</span></span><span>+1 name</span><span class="bad">favour -1</span><span>8 weeks to the next</span></div>
  <div class="row"><span class="chip step">STEP UP</span><span>#16, 11-2 &middot; read 52%<br><span class="small">A loss here costs the house's favour 2</span></span><span>+5 name, takes #16</span><span class="good">favour +1</span><span>12 weeks to the next</span></div>
  <div class="row"><span class="chip title">TITLE</span><span>Area champion &middot; read 41%<br><span class="small">Opens free after 2 more wins, or spend 3 favour now</span></span><span>+5 name, the belt</span><span class="good">favour +1</span><span>10 rounds</span></div>
  <div class="row"><span class="chip reb">PAYDAY</span><span>#7 &middot; read 28%<br><span class="small">Ranked purse $4,700; the club keeps a quarter</span></span><span>+5 name</span><span>favour 0</span><span>12 weeks</span></div>
  <div class="line ask" style="margin-top:18px"><b class="gold">THE HOUSE ASKS:</b> its co-feature lost an opponent. Take an unranked late replacement in 3 weeks (read 70%, no full camp). Yes: favour +2. No: favour -1.</div>
  <div class="small" style="margin-top:14px">Hover any number: why it moves (an easy win is not news; the house wants names on its posters; a stoppage needs rest).</div>
 </div>
 <div class="card">
  <h2>THE ROAD SO FAR</h2>
  <div class="line">Debut: TEST night, won. +11 name (44 seats), took the table's last seat.</div>
  <div class="line">Fight 2: step up, won. +5, favour 7 to 8.</div>
  <div class="line gold">Now: top of the bill.</div>
  <h2 style="margin-top:22px">WHAT EACH ROAD HAS DONE FOR THE CLUB</h2>
  <div class="line">Name +16 &middot; members +11 &middot; club cash +$1,180</div>
  <div class="line">Against staying amateur: +$640</div>
  <h2 style="margin-top:22px">YOUR BOXER</h2>
  <div class="line">Morale Steady &middot; no injury &middot; last fight 6 weeks ago</div>
  <div class="line small">The house does not read this. You do.</div>
 </div>
</div>
</body></html>
```

## Code files opened (at `ee2e54762`)
scripts/state/ProLadder.gd, scripts/state/ProLean.gd, scripts/rules/Matchmaking.gd, scripts/world/WorldRank.gd,
scripts/state/BoutFinish.gd, scripts/rules/BoutRules.gd, scripts/rules/DebutPick.gd, scripts/rules/DebutRead.gd,
scripts/rules/DebutOpp.gd, scripts/rules/ProCall.gd, scripts/state/ProOfferWire.gd, scripts/rules/ProDebut.gd,
scripts/state/Roster.gd, scripts/rules/Recruit.gd, scripts/state/Champs.gd, scripts/rules/Loyalty.gd,
scripts/state/LoyaltyWire.gd, scripts/ui/ProFights.gd, scripts/ui/modals/ProOffer.gd, scripts/state/Bouts.gd,
scripts/rules/AskDates.gd, scripts/rules/FighterProfile.gd, scripts/state/Needs.gd, scripts/ui/Main.gd, scripts/state/Clock.gd,
scripts/ui/ProWeekLines.gd, scripts/ui/areas/FighterPage.gd, scripts/rules/NextStep.gd, scripts/rules/Membership.gd,
scripts/state/GymSpend.gd, scripts/rules/GymUpgrades.gd, scripts/state/GymDeals.gd, scripts/rules/ClubShow.gd,
scripts/rules/Grants.gd, scripts/rules/CardAsk.gd, scripts/ui/RosterActs.gd, scripts/ui/BoutActs.gd, scripts/ui/TestJump.gd,
scripts/rules/Attrs.gd, scripts/state/HomeBout.gd, scripts/rules/BoutRead.gd, scripts/rules/GymBills.gd,
scripts/ui/MoneyPanels.gd, scripts/ui/WorldCompare.gd, scripts/ui/OfficeDesk.gd, scripts/ui/BoutHistory.gd, scripts/state/Sim.gd
(grep). Probe: tools/turnprobe15.gd, tools/turnprobe15_rules.gd, tools/turnprobe15_sum.py, docs/TURNPROBE15_RESULT.md.

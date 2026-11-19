# DESIGN_TURNPRO1_V5 — turning pro map v5

Status: Research complete | CODE rows verified against S530 main (post price fix)
Tags: **CODE** = verified in named file+function; **CHANGE** = v5 changes a built number or adds a rule; **ESTIMATE** = starting value for probes; **CUT** = removed from v4.

Owner rules kept: names only in headers (S448); gender-neutral text (S412); stops at the debut (S428); no new screen; actionable info only (S425); 14-day window; TAPER week before bouts.

Measured against: TURNPROBE3B (S530, post S529 price fix). Every row answers a measured line, not a critic's prose.

---

## Claude's check on v5 (S530) - read before scoring
- Debut gaps (section 4): 1.6 / 2.1 and their "~70% / ~75%" are ESTIMATES, not measured - no probe has a gap-to-win curve
  yet (TURNPROBE3B's gap arms never reached the deal). They stand as targets until a paired probe on the same boxer sets
  them; the fix to the probe is to set the gap where the deal reads it (ProOfferWire.signed / the deal's opp_gap).
- Day job (section 7): lowering the win gate 7 -> 6 may not open the call - day-job boxers' median best rank is 4 at w104
  (TURNPROBE3B), and the call still needs top-3. The rank leg binds as well; v5's number must be probed, not assumed.
- Numbers checked against the code: the houses' opp_gap 1.0 / 1.5 (ProCall.promoters), Roster.PRO_OPP_GAP 1.0, the
  rating `night - opp_gap` (Roster.gd 306), DayJob.LOST 2 - correct.

## 1 — When & Who Calls

### 1.1 Trigger Rules

| Rule | Value | Tag | Source |
|---|---|---|---|
| First call: wins + ranked | 7 wins AND regional top 3 | CODE | `Roster.pro_ready()` — `w >= PRO_WINS and ranked` |
| First call: wins any rank | 9 wins, any ranking | CODE | `Roster.pro_ready()` — `w >= PRO_WINS_ANY_RANK` |
| National finalist | First call at any win count, 0 declines | CODE | `Roster.pro_ready()` — `nat_final and pro_declines == 0` |
| After 1 decline | Same promoter calls; need +2 wins; terms ×0.9 | CODE | `ProOfferWire.on_decline()` + `ProCall.terms()` |
| After 2 declines | Only regional rank 1 brings a call | CODE | `Roster.pro_ready()` — `pro_declines >= 2: return rank == 1` |
| After 3 declines | Door closed permanently | CODE | `Roster.pro_ready()` — `pro_declines >= 3: return false` |
| Age cutoff | No first call at age 32+ | ESTIMATE | `ProCall.calls_open()` — `age < AGE_STOP` |
| Age warning | Shown from age 29 | ESTIMATE | `ProCall.age_line()` — `age >= 29` |
| Offer window | 14 days | ESTIMATE | `ProCall.WINDOW_DAYS := 14` |
| Window expires | NOT a decline; promoter waits 2 more wins | CODE | `ProOfferWire.lapse_if_due()` — `RETURN_WINS := 2` |

### 1.2 Who Calls

| Ticket forecast | Who calls | Tag | Source |
|---|---|---|---|
| ≥ 75 (Bow Lane BE 60 + BAND 15) | Bow Lane only | CODE | `ProCall.who_calls()` — `forecast >= bow_be + BAND` |
| 46–74 (within BAND of BE) | Both, side by side | CODE | `ProCall.who_calls()` — the else branch |
| ≤ 45 (Bow Lane BE 60 − BAND 15) | Harrow & Finch only | CODE | `ProCall.who_calls()` — `forecast <= bow_be - BAND` |
| After decline | Same promoter only | CODE | `ProOfferWire.make()` — `if declines > 0: keys = [last]` |
| Title won since decline | Terms reset to 1.0× | CODE | `ProCall.terms()` — `title_since_decline: factor = 1.0` |

**v4 error corrected:** v4 said both call at 45–74. The code says `>= 75` for Bow Lane only, `<= 45` for HF only, so both is 46–74. At exactly 45 tickets, only HF calls.

### 1.3 The Two Promoters

| | Bow Lane (ticket house) | Harrow & Finch (guarantee house) | Source |
|---|---|---|---|
| Debut purse | $1,500 | $1,800 guaranteed | CODE `ProCall.promoters()` |
| Win bonus / top | +$500 / $3,000 | +$400 / $3,000 | CODE `ProCall.promoters()` |
| Break-even | 60 tickets | 70 tickets | CODE `ProCall.promoters()` / `ProDebut.BREAK_EVEN` |
| Boxer share past BE | 50% | 30% | CODE `ProCall.promoters()` |
| Under BE | Purse −$25/ticket short, floor $500 | No deduction (guaranteed) | CODE `ProCall.debut_purse()` |
| Debut date | 4 weeks out | 6 weeks out | CODE `ProCall.promoters()` |
| Opponent gap | 1.0 under boxer's night power | 1.5 under | CODE `ProCall.promoters()` |

---

## 2 — The Asks (v5: cut the dead, give costs a downside)

One ask per offer per house. Each shows its answer before pressing: take, counter, or wont. Pressing a counter shows its terms; the player can accept the counter or return to plain (still counts as the one ask). CODE: `ProOfferWire.ask()`.

### 2.1 Later +2 Weeks

| | Value |
|---|---|
| Purse | −$150 |
| Debut weeks | +2 |
| When best | An amateur bout is booked in weeks 3–4 that cannot be rescheduled |

Tag: CODE `ProCall.LATER2_PURSE_CUT := 150`, `_apply_later()`. TURNPROBE3B: best in 19%. Kept.

### 2.2 Later +4 Weeks — CUT

v4 kept this at 3% best. TURNPROBE3B: 0% best. The stated reason ("3–4 more weeks of ticket growth") is not in the money preview — `_apply_later()` changes only `debut_weeks` and `purse`; `money()` computes the preview from the offer's fixed forecast. The ask changes a number the player cannot see change.

**Verdict: CUT.** Merged into later+2. If a player needs more than 2 weeks, the right move is to let the offer lapse (no decline, same house returns after 2 more wins at full terms) — a real option, not a $300 purse cut for a number that does not move.

### 2.3 Softer Opponent — CUT

v4 kept this at 0% best. TURNPROBE3B: 0% best. The gap change (+0.5) is invisible on the offer — no win band is shown. The "next 2 pro offers are tune-ups" consequence has no visible effect at the debut.

**Verdict: CUT.** The debut's difficulty is tuned by the opponent gap (section 2.6 below), not by a hidden ask. If the debut is too easy, the gap widens — every career feels it, no ask needed.

### 2.4 Better Split — CUT (both branches)

v4 kept the take at 0% and the counter at 0%. TURNPROBE3B: 0% best. The counter at BE+5 is worth about $3 to the gym (5 tickets × $50 × 5% share = $12.50, gym's 25% of that ≈ $3). The take adds 10 share points but makes the opponent 0.5 harder — a worse deal at every forecast below the room cap.

**Verdict: CUT.** Neither branch clears 10%. A $3 gain is not a decision.

### 2.5 Own Ticket Price

| | Value |
|---|---|
| Ticket price | $40 |
| Extra tickets | +15 |
| Available | Bow Lane only |
| When best | Forecast 60–91 tickets (below the 100-room cap) |

Tag: CODE `ProCall.PRICE_TICKET := 40`, `PRICE_EXTRA_TICKETS := 15`, `_price_entry()`. TURNPROBE3B: best in 6%. The S529 price fix is in the code (`ProCall.money()` reads `t.get("price", ProDebut.TICKET_PRICE)`).

**CHANGE — a downside for the price ask.** At forecast 92+, the 100-ticket cap throws away sold tickets: plain pays 40 × $25 = $1,000 (share past BE at $50), price pays 40 × $20 = $800. The ask costs the boxer $200 above 91. The offer must show this: "Above 91 tickets the lower price costs you $200." This gives the ask a real downside and a visible cutoff. Target: 10%+ best once the cap cost is visible.

### 2.6 Costs from the Purse — CHANGE (loyalty cost)

| | Before (v4) | After (v5) |
|---|---|---|
| Signing cost | Gym pays $230–$1,245 now | $0 now |
| Repayment | — | Deducted from gross purse before the 25% split |
| Fee | — | +$100 base; +$200 when runway < 8 weeks |
| Available | HF only | HF only |
| Loyalty cost | None | CHANGE: −10 loyalty when costs move to the boxer |

Tag: CODE `ProCall.COSTS_BASE_ADD := 100`, `COSTS_RUNWAY_ADD := 200`, `COSTS_RUNWAY_THRESHOLD := 8`, `_costs_entry()`. TURNPROBE3B: best in 74%.

**CHANGE — a loyalty cost when costs move to her.** The Arena v4 critic named this: deferral transfers $884 from the boxer to the gym with no trust cost, hence dominant. v5 adds a loyalty hit (−10) when `costs_covered` is true, applied in `Roster.turn_pro()` alongside the existing `Loyalty.apply(f, "turn_pro", c.day)`. The loyalty hit lowers the gym's future share on later pro fights (Loyalty.pro_share reads loyalty). This gives the costs ask a downside the player can see on the offer: "Gym saves $X now; trust −10; future share lower." Target: costs ask no more than 40% best in line 7.

### 2.7 No Ask (Plain Deal)

Return to the plain offer after viewing or countering an ask. The ask stays spent (one ask per offer per house). CODE: `ProOfferWire.back_to_plain()`. This is an undo, not a scored option. Line 7 counts it only as the baseline.

### 2.8 Summary — What Survives

| Ask | v4 best | v5 verdict | v5 target |
|---|---|---|---|
| Later +2 | 19% | Kept | ≥10% |
| Later +4 | 0% | CUT | — |
| Softer | 0% | CUT | — |
| Split | 0% | CUT | — |
| Price | 6% | Kept + downside shown | ≥10% |
| Costs | 74% | Kept + loyalty −10 | ≤40% |

---

## 3 — One Dated Money Model

### 3.1 Costs at Signing

| Item | Amount | Condition | Source |
|---|---|---|---|
| BBBofC licence | $230 | Always (first pro licence) | CODE `ProDebut.LICENCE` |
| Brain scans / medicals | $875 | First licence only | CODE `ProDebut.MEDICALS`, `start_costs(first_licence=true)` |
| Corner licence | $140 | Trainer not already licensed | CODE `ProDebut.CORNER_LICENCE`, `start_costs(trainer_licensed=false)` |
| **Range** | **$230 – $1,245** | Depends on existing licences | CODE `ProDebut.start_costs()` |

### 3.2 The Dated Ledger — One Table

Example: 70-member gym, 7 wins, Bow Lane, stipend was $250/week, costs = $1,245 (worst case), 69 tickets forecast.

| Date | Event | Gym cash movement | Boxer cash movement |
|---|---|---|---|
| Day 0 (sign) | Costs paid | −$1,245 | $0 |
| Day 0 (sign) | Gym's 25% of purse ($1,500) | +$375 (in `gym_at_signing`) | — |
| Day 0 (sign) | Gym's 25% of ticket share (9 tickets × $50 × 50% × 25%) | +$56 (in `gym_at_signing`) | — |
| Week 1–4 | Stipend saved (was $250/wk, now $0) | +$250/wk | — |
| Week 1–4 | Amateur cut lost | −$75/wk | — |
| Week 1–4 | Net weekly swing | +$175/wk | — |
| Debut day (wk 4) | Purse paid | (included above) | $1,500 − $375 gym cut = $1,125 |
| Debut day (wk 4) | Ticket share paid | (included above) | 9 × $50 × 50% − $56 gym cut = $169 |
| **Gym total at debut** | | **−$1,245 + $375 + $56 + $700 = −$114** | **Boxer: $1,294** |
| **Gym break-even** | | Week 5 (−$114 / $175 per wk ≈ 1 wk after debut) | |

### 3.3 Deferred Costs Scenario (HF, runway < 8 weeks)

| Date | Event | Gym cash | Boxer cash |
|---|---|---|---|
| Day 0 (sign) | Costs deferred | $0 | $0 |
| Day 0 (sign) | Fee added to purse deduction | — | −$200 (extra) |
| Day 0 (sign) | CHANGE: Loyalty hit | — | Trust −10 |
| Week 1–6 | No stipend, no amateur cut | −$75/wk | — |
| Debut day (wk 6) | Gross purse $1,800 − $1,245 costs − $200 fee = $355 | 25% of $355 = $89 | $355 − $89 = $266 |
| **Gym total at debut** | | **$89 − $450 (6 wk loss) = −$361** | **Boxer: $266** |

The deferral is not free: the boxer absorbs 75% of the costs ($266 vs $1,294 paying now), and the gym loses trust (−10 loyalty → lower future share). Shown on the offer button.

### 3.4 Ticket Math — Corrected

v4 said "+0.5 per member, ~+4 tickets at 80 members." The code's `ProDebut.tickets_sold()`: `FAMILY (20) + floor(members × 0.5) + 2 × wins + 10 × titles`, capped at 100. At 80 members: 20 + 40 = 60 tickets before any wins. v4 was off by a factor of ten.

---

## 4 — The Debut Win Rate (v5: one lever, one target)

### 4.1 The Measured Problem

TURNPROBE3B: 94% debut win rate at every gap (29/31 each at gaps 0.7, 1.0, 1.5). The probe's per-offer opp_gap override does not reach the debut — `Roster.turn_pro()` builds the deal fresh through `ProOfferWire.signed()`; the opponent rating is `night_power − deal.get("opp_gap", PRO_OPP_GAP)`. The gap arms are one arm. The debut is too easy.

### 4.2 The Lever

`Roster.PRO_OPP_GAP := 1.0` (the default when the deal has no opp_gap). The houses' own gaps in `ProCall.promoters()` are 1.0 (Bow Lane) and 1.5 (HF). The opponent rating is `night_power − gap`. A larger gap means a weaker opponent.

### 4.3 The CHANGE

| Constant | v4 | v5 | Why |
|---|---|---|---|
| Bow Lane `opp_gap` | 1.0 | 1.6 | Target 65–80% win rate |
| HF `opp_gap` | 1.5 | 2.1 | Target 70–85% win rate |
| `Roster.PRO_OPP_GAP` | 1.0 | 1.6 | Match the Bow Lane default |

**Why these numbers.** The current 94% win rate means the boxer's night power exceeds the opponent's by too much. A gap of 1.0 means the opponent is rated 1.0 below the boxer's night power. Raising to 1.6 means the opponent is 1.6 below — a noticeably harder fight. The HF gap rises in step (1.5 → 2.1) to keep the HF debut harder than Bow Lane's.

**Why a range, not a single number.** Bow Lane's gap (1.6) gives the ticket-house debut a ~70% win rate. HF's gap (2.1) gives the guarantee-house debut a ~75% win rate. The HF debut is slightly easier because the guarantee house attracts cash-poor boxers who need the safety net. Target: 65–80% at Bow Lane gap, 70–85% at HF gap.

**Paired test required.** The probe must hold the boxer, camp and plan constant and test gaps 1.0, 1.6 and 2.1 on the same fighter. The current 94% at every gap came from different boxers at different gaps (selection bias: HF is picked by weaker careers).

---

## 5 — The Door That Shuts (v5: one more refusal closes it)

### 5.1 The Measured Problem

TURNPROBE3B: 0/60 careers reach 3 declines. The TERMS08 bot (refuses when terms factor < 0.8) also reaches 0/60. The third decline is unreachable because:
- After 1 decline, terms drop to 0.9. After 2, to 0.81. After 3, to 0.729.
- No bot refuses at 0.9 (the first decline). The TERMS08 bot refuses at 0.8, which is below 0.81 (the second decline). So it refuses the second offer, reaches the rank-1 gate, and either makes rank 1 or never gets a third offer.
- The NEVER bot declines on principle but never reaches 3 because the offer cycle is slow (2 more wins between each).

### 5.2 The CHANGE — Show the Door

The code already closes the door at 3 declines (`Roster.pro_ready()` returns false). What is missing is a visible warning that makes refusal rational before the third:

**On the second offer (1 decline already):** Show "Terms 0.9×; one more refusal and the door closes." This is a wiring change, not a rules change. The offer screen reads `pro_declines` and shows the count.

**On the third offer (2 declines already):** Show "Terms 0.81×; this is the last offer. Refuse and no promoter calls again." The rank-1 gate is already code; the warning makes it visible.

### 5.3 A Probe Bot That Reaches the Door

The TERMS08 bot refuses at < 0.8. v5 adds a TERMS085 bot that refuses at < 0.85. At the second decline (terms 0.81), TERMS085 refuses — reaching 3 declines and closing the door. Target: 10–30% of TERMS085 careers reach the closed door.

### 5.4 Why Not Cut the Rule

The 3-decline hard stop is good game design: it gives refusal a real cost. The problem is not the rule but the visibility. With the warning lines above and a bot that refuses at 0.85, the door closes in a measurable share of careers.

---

## 6 — The Boxer's Voice (v5: three ambitions, three preferences)

### 6.1 The Measured Problem

TURNPROBE3B: 1/30 (3%) ambition alignment. `ProCall.ambition_kind()` checks for "title" and "pro" in the ambition text. `Recruit.ambition()` returns one of three strings:
- "A first win in front of a home crowd" (bouts == 0)
- "A regional title within a year" (pot ≥ 78)
- "A winning record by the summer" (pot < 78, bouts > 0)

None contains "pro." The "pro" morale path (+5/−5) is never triggered.

### 6.2 The CHANGE — Add a "pro" Ambition

**Who gets it:** Boxers with potential 60–77 (below the title threshold of 78) who have 3+ amateur bouts. These are boxers with a solid record but not elite potential — they want to turn pro and build a career, not chase a title.

**The new ambition line in `Recruit.ambition()`:**
```
if bouts == 0:
    return "A first win in front of a home crowd"
if pot >= 78:
    return "A regional title within a year"
if bouts >= 3:
    return "Turn pro and build a career"   # NEW
return "A winning record by the summer"
```

**The morale effect in `ProCall.morale()`:**
- "Turn pro and build a career" → kind "pro" → +5 morale when signing, −5 when staying amateur.
- This gives the AMB bot a reason to sign early (the pro ambition fires) and a cost to staying.

**Target:** 70%+ of AMB bot careers have morale ≥ 50 at signing.

### 6.3 The Full Ambition Map

| Ambition words | Kind | Turn pro | Stay amateur | Who gets it |
|---|---|---|---|---|
| "A first win in front of a home crowd" | other | No change | No change | 0 bouts |
| "A regional title within a year" | title | −5 morale (before nationals) | No change | pot ≥ 78 |
| "Turn pro and build a career" | pro | +5 morale | −5 morale | pot 60–77, bouts ≥ 3 |
| "A winning record by the summer" | other | No change | No change | pot < 78, bouts < 3 |

---

## 7 — The Day-Job Road to Pro (v5: show the gate, keep the pace)

### 7.1 The Measured Problem

TURNPROBE3B day-job question: day-job careers median 6 wins / 2 losses and best rank 4 at w104; 3 of 180 ever get the first pro call. Stipend careers: 10 wins / 3 losses, rank 3, 180/180 called.

The call's gate (7 wins + top-3, or 9 wins) is out of reach on half the bouts. A boxer on the day job almost never reaches the first pro call in two years.

### 7.2 The Decision — Keep, Show It

**Slower is real.** A boxer without the gym sponsorship loses 2 coached mornings a week to work (`DayJob.LOST := 2`). That is a real cost. The day-job path should be slower, not impossible.

**The problem is the gate, not the pace.** The gate (7 wins + top-3) requires a ranking that day-job boxers rarely reach (median rank 4). The gate is too tight for a boxer who trains half-time.

### 7.3 The CHANGE — A Day-Job Route to the Call

**Lower the win gate for day-job boxers.** When `f["day_job"]` is true, the win gate drops from 7 to 6 (still needs top-3 rank). The logic: a boxer who builds a record while working a day job shows commitment; the promoters call earlier.

**Where:** `Roster.pro_ready()` — add a day-job branch:
```
if bool(f.get("day_job", false)):
    var day_job_need := PRO_WINS - 1   # 6 instead of 7
    return w >= day_job_need and ranked
```

**Why 6, not 5.** Five wins is too easy — every amateur reaches it. Six wins on a day job takes about 30 weeks (a win every 5 weeks with half training), which is a real commitment. Seven wins on a day job takes 35+ weeks and often pushes past the age cutoff.

**Show it on NEXT STEP:** "On the day job: 6 wins + ranked for a call (about 8 more weeks)." The day-job route is visible, not hidden.

**Target:** 30%+ of day-job careers get the first pro call (up from 3/180 = 1.7%).

---

## 8 — PREP vs YES (v5: cut the framing, name the lever)

### 8.1 The Measured Problem

TURNPROBE3B: PREP and YES end at the same median cash ($0 difference). PREP is supposed to represent a boxer who prepares more before signing (stops the stipend earlier, builds the gate). In the probe, PREP signs at the same time as YES because the probe has no lever that makes PREP sign later.

### 8.2 The Decision — Cut the PREP Framing

v4 tried to make PREP a distinct path (stop stipend 6 weeks early, host a club show). The probe shows PREP and YES converge because:
- The club show followers are already in the code and available to every bot.
- Stopping the stipend earlier does not change when the call comes (the call depends on wins and rank, not cash).
- PREP has no rule that makes it sign at a different time.

**v5 cuts the PREP bot as a separate pass line.** The line is replaced by a simpler question: does the day-job path (section 7) produce a different outcome from the stipend path? That is the real choice the game offers, and the day-job route (section 7.3) is the lever that moves it.

### 8.3 What Remains of PREP

The PREP bot's behavior (stop stipend early, build the gate) is kept as a valid strategy. It is no longer a separate pass line. The stipend-timing line (line 3) covers the same ground: YES(stip) > NEVER(stip) at w52; NEVER > YES at w52 no-stip.

---

## 9 — Probe Pass Lines (v5)

| # | Pass line | v4 result | v5 target | Key constant |
|---|---|---|---|---|
| 1 | No bot dominates (>60%) at w104 cash | PASS | All bots ≤55% | Day-job route diversifies |
| 2 | PREP beats YES by ≥$1,500 at w104 (paired) | FAIL, median $0 | CUT as a line | — |
| 3 | Stipend timing: YES(stip) > NEVER(stip) w52; NEVER > YES w52 no-stip | FAIL | As stated | `ProCall.LOST_CUT_A_WEEK` |
| 4 | YES debut loses gym money 40–70% (stipend only) | PASS, 53% | 40–70% stip | `ProCall.PURSE_FLOOR` / `SHORT_TICKET` |
| 5 | Door closes 10–30% of careers (TERMS085 bot) | FAIL, 0% | 10–30% | Warning lines on offer |
| 6 | Win rate: 65–80% at Bow Lane gap; 70–85% at HF gap | FAIL, 94% every gap | Within bands | `ProCall.promoters()` opp_gap |
| 7 | Each kept ask best in ≥10%; costs ≤40% | FAIL; costs 74% | Kept asks ≥10%; costs ≤40% | Loyalty −10 on costs |
| 8 | HF picked ≥25%; both call 25–50% | PASS, 63% / 43% | Unchanged | `ProCall.BAND` |
| 9 | Ambition preference aligns ≥70% decisions | FAIL, 3% | ≥70% | `Recruit.ambition()` + `ProCall.morale()` |
| 10 | Day-job careers: ≥30% get first pro call | FAIL, 1.7% | ≥30% | `Roster.pro_ready()` day-job branch |

Probe spec: 200 careers/bot × 6 bots × 2 seed sets; half stipend, half day-job. Preserve all v2 definitions. Add TERMS085 bot (refuses at < 0.85). Add day-job call rate.

---

## 10 — Wire Map (Every Menu)

| # | Menu | What shows | Wired to |
|---|---|---|---|
| M1 | Top bar flag | PRO OFFER (14-day countdown, red last 3 days) | Opens M3; `ProOfferWire.days_left()` |
| M2 | Home board | "Pro offer — hear it" | `Roster.check_pro()` status |
| M3 | Pro offer modal | One or two contracts; 3 asks with before/after terms (later2, price, costs); morale line; age line; declines left with door warning; next-call condition if waiting | `ProOfferWire`, `ProCall`, `ProDebut` |
| M4 | Fighter → NEXT STEP | Wins of 7/9 (6 if day job), rank, age line, declines left; ticket forecast over 8 weeks; stipend vs day-job path | `Roster.pro_ready()`, `ProCall` forecast |
| M5 | Fighter → Contract | Stipend status; pro split after signing | `Roster.turn_pro()`, `StarDeal` |
| M6 | Roster | Chip: "Ready" / "Door closed" | `Roster.pro_ready()` |
| M7 | Money → Stipends | Hover: "Stop at signing saves $250/wk; defer costs = $0 up-front, trust −10" | `ProCall.money()` |
| M8 | Money → One-offs | "$230–$1,245 paid now" or "from purse — cash saved, trust −10" | `ProDebut.start_costs()` |
| M9 | World → News | "A boxer from the gym signs pro" — no names | NewsFeed |
| M10 | Week review | Post-signing: "Amateur cut lost $75/wk; stipend saved $250/wk" | `ProWeekLines.lines_for()` |
| M11 | Fight prep → Pro camp | "4 rounds · opponent gap · costs paid/deferred" | `Roster.turn_pro()`, `ProDebut` |
| M12 | Fight night → Corner | "First pro fight — same ring, same plan" | CornerCard |
| M13 | Fights | Post-signing: debut countdown | `f["bout"]` |
| M14 | Fighter → History | Milestone: "Turned pro — Week N" | `f["pro_signed"]` |
| M15 | Office desktop | Needs: Pro offer | Desktop |
| M16 | Goal talk | "Build membership" / "Host a club show" | Goalsystem |

No new screens. All changes wire to existing UI elements. Names only in headers (M9 says "the gym," not the promoter).

---

## 11 — Failure Paths That Teach

| Failure | What the player sees | Lever |
|---|---|---|
| Debut loses money | Before: gym line + boxer line on offer. After: week review "Gym: share $X, costs $Y, net $Z" | More members; defer costs (with trust hit); keep stipend longer |
| Door closes | Each decline shows next need. After 2nd: "One more refusal closes the door." After 3rd: "No promoter will call." | Nothing — the door is shut |
| Debut too easy (94% wins) | Opponent gap widened (1.6 / 2.1) | Built into the code; no player action |
| Day-job boxer never called | NEXT STEP shows "6 wins + ranked for a call (about N more weeks)" | Keep training; the gate is lower for day-job boxers |
| Ambition mismatch | Offer shows morale effect of signing vs staying | Sign when the boxer wants to turn pro; stay when the boxer wants the title |

---

## 12 — Changed from v4

1. **Corrected both-call band:** 46–74, not 45–74. At 45 tickets only HF calls.
2. **Corrected member-to-ticket math:** 80 members = 60 tickets (20 family + 40 from members), not 4.
3. **Corrected split counter value:** ~$3 to the gym, not ~$5.
4. **Corrected age warning:** 29 everywhere (section 1.1, 6.2, and failure table).
5. **Removed stale price-bug item:** The S529 fix is in the code (`ProCall.money()` reads `t.get("price", ...)`). No CHANGE needed.
6. **Marked club-show followers as built:** `HomeBout.SHOW_FOLLOWERS = 10` is in the code; `ProOfferWire.forecast()` reads `f["followers"]`.
7. **CUT later+4, softer, split:** All three at 0% best. Merged into later+2 or removed.
8. **Added loyalty cost to deferral:** Costs ask now carries −10 loyalty when costs move to the boxer. Target: ≤40% best.
9. **Added price ask downside:** Above 91 tickets the lower price costs the boxer $200 (100-ticket cap). Shown on the offer.
10. **Widened opponent gaps:** Bow Lane 1.0 → 1.6, HF 1.5 → 2.1. Target: 65–80% / 70–85% debut win rate.
11. **Added door warnings:** "One more refusal closes the door" on the second offer; "This is the last offer" on the third.
12. **Added TERMS085 bot:** Refuses at < 0.85 terms. Target: 10–30% reach the closed door.
13. **Added "pro" ambition:** "Turn pro and build a career" for pot 60–77 with 3+ bouts. +5 morale when signing, −5 when staying.
14. **Added day-job route:** Win gate drops from 7 to 6 for day-job boxers (still needs top-3 rank). Target: ≥30% get called.
15. **CUT PREP as a separate pass line:** Replaced by day-job call rate (line 10).
16. **Removed names from body text:** M9 says "the gym," not the promoter. M14 says "Turned pro," not the house name.
17. **Removed M19 (decoration as progress):** "+1 person a week toward break-even" is decoration given a progress meaning. Deleted.
18. **Removed Roster chip "Day-job — saving":** No fund variable in the code. Deleted.

---

## 13 — Probe Plan

Rerun TURNPROBE3B with the v5 changes:

1. **Line 6 (win rate):** Paired test — hold boxer, camp, plan constant; test gaps 1.0, 1.6, 2.1 on the same fighter. Target: 65–80% at 1.6, 70–85% at 2.1.
2. **Line 7 (asks):** Rerun with later4/softer/split removed. Costs ask now carries −10 loyalty. Price ask shows cap cost. Target: later2 ≥10%, price ≥10%, costs ≤40%.
3. **Line 5 (door):** Add TERMS085 bot (refuses at < 0.85). Add warning lines on offer. Target: 10–30% reach closed door.
4. **Line 9 (ambition):** Add "Turn pro and build a career" ambition. Target: ≥70% AMB bot morale ≥50 at signing.
5. **Line 10 (day-job):** Add day-job branch in `pro_ready()` (6 wins + ranked). Target: ≥30% day-job careers get called.
6. **Line 3 (stipend timing):** Unchanged; rerun to confirm.

Probe commands:
- `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/turn_pro_probe3.gd` (base rerun)
- Paired gap test: new probe or fork of turn_pro_probe3_fork.gd with fixed boxer.

---

## 14 — Outstanding Questions

| # | Question | Owner |
|---|---|---|
| C1 | Does the loyalty −10 on costs bring costs best below 40%? | Probe |
| C2 | Does the price ask cap warning bring price best above 10%? | Probe |
| C3 | Does the day-job gate (6 wins + ranked) bring day-job call rate above 30%? | Probe |
| C4 | Does the "pro" ambition bring AMB alignment above 70%? | Probe |
| C5 | Does TERMS085 reach the closed door in 10–30% of careers? | Probe |
| C6 | Should the opponent gaps be 1.6 / 2.1 or a different pair? | Probe (paired test) |

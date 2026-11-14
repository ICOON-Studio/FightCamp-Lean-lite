# DESIGN_HOSTSHOW1_V4_CRITIC_JOHN_JOHN - John answer (seat queue SQ89)

Brief: research/DESIGN_HOSTSHOW1_V4_CRITIC_JOHN.md
Sent: 2026-11-14 01:11 | collected: 2026-11-14 01:41 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading HOSTSHOW1 round 4 against the pack and checking the maths now. The full critic return comes next.

# HOSTSHOW1 v4 (S459): critic

Scores: **depth 7/10, general design 7/10, play 7/10**. That **passes the owner's bar** (6+ on both depth and general design). I couldn't open `CRITIC_ACCESS.md`, the Miro board, or `screen_r3.png`, because your computer is offline, so I judged from the map, the pack, and my S449 boxing sources.

Names and pronouns pass: every person's name stays inside card headers, and the copy avoids a fixed `he` or `she`.

## Logic check

**1. The Gym floor loses money against boxing away, even at a 100% sell-out.**
Section 4.2 says young clubs or low-cash clubs take the Gym floor. Check the ceiling on 22 places (`88` seats at `$25` ticket + `$5` raffle = `$30/seat`):
- **Max revenue (100% full):** `88 × $30 = $2,640`.
- **Base costs:** `$300` rent + `$1,200` officials/doctor/ambulance + `$300` medals + `$400` visitor travel (`10 × $40`) = `$2,200` (or `$2,280` with 2 standby reserves).
- **Best possible net:** **+$440** (or **+$360** with reserves)—and Section 6 itself notes that is **less than the $900** earned by sending two boxers away at `$0` upfront cost and `$0` half-empty risk.
- A low-cash club (`<$3,000`) would never pay `$2,200` upfront to cap its profit below what two free away bouts pay. Either Gym floor needs lower fixed club-show overheads (fewer bouts = smaller officials/doctor share, say `$700` instead of `$1,200`, or `places × 5` = 110 seats) so a full Gym floor beats boxing away (`+$940+`), or Community hall (`+$1,210` likely even at 40 members / 10 rep) dominates it.

**2. The favour ledger has a self-refund loop.**
Under Section 4.5 rule #3, giving a club's boxer a bout on our main card earns `+1` favour at the end of the night if our boxer makes weight and doesn't pull out.
- If you spend **-1 favour** to ask `#2` (`With a favour`) or **-1 favour** to `Ask the other corner to accept` overweight, and the bout takes place cleanly, rule #3 awards **+1 favour** back after the show—making the net cost **0** (for example, in Section 6, Belfast Gloves would drop `1 -> 0` at step 3 and rise `0 -> 1` at step 8).
- Fix: a bout booked using `With a favour` (or settled via `Ask corner`) must **not** also earn the `+1` hosting favour that night. Only clean bouts asked `As it is` (or called-up reserves) should pay `+1`.

**3. Standby reserves and pull-outs have an undefined gap between Section 4.10 and Section 5.**
- Section 5 lists `D | Pull-out` options as **`Use reserve / Tougher short-notice (band max >= 40) / Novice / Leave short`**, but `Tougher short-notice` and post-pull-out `Novice` are never defined in Section 4.10.
- With **25% pull-out** per bout on a 9-bout card (2 ours + 7 visiting pairs across multiple sex/kg divisions), there is a **44% chance** at least one of *our* two boxers loses her opponent in the final week (`1 - 0.75²`). Because Section 4.10 only allows **2 standby reserves** total, the map must state each reserve's **sex, kg class, and novice/open status**—otherwise a reserve booked to insure a men's 60 kg undercard pair cannot legally step in for a women's 60 kg main event, leaving the main event without a reserve.

**4. Minor arithmetic, pack, and rule gaps.**
- **Boxer B's yes chance in step 2:** `#3` (`62.0`) leads Boxer B (`58.0`) by `4` rating points. By Section 4.3 (`+1 in 10 per 2 points`), that is `5 + 2 = 7 in 10`, not `5 + 1 = 6 in 10`. (Wait: `Ask #7 + Swap` in step 3 gives `0.9 × 0.54 × 0.836 = 40.6%` rather than `43 in 100`, and `Ask #7 as it is` gives `0.9 × 0.54 × 0.545 = 26.5%` rather than `29`.)
- **Promised rematch vs stoppage rest (`STOP_REST_WEEKS`):** If a boxer promises a return bout (`4–12 weeks` away) and then loses on our show by **stoppage**, Pack S451 requires a 30-day suspension and 8-week offer delay (`Matchmaking.STOP_REST_WEEKS`). The other club's rematch window must start at **8–12 weeks** after a stoppage loss, and turning pro on show night (`Review pro offer`) must flag the **-2 favours** rematch penalty before confirming.
- **`Move down` at Ticket Read (12 days out):** Cutting excess visiting pairs removes their `3` supporters each (`-18` supporters for 3 cut pairs), which should also reduce the smaller hall's projected night draw and state whether those cut clubs suffer any favour penalty.
- **`A no-gi athlete sells` (`-$75`):** Pack 4.15 has no `$75` per-class figure (it only states a no-gi coach is paid by the class, and `$75/week` in 4.12 is the physio). Mark `-$75` explicitly as `ESTIMATE` tied to `BJJ_CLASS_FEE` or state the real per-class fee in code.
- **Section 6 date framing:** Step 1 opens under `"Club state, Mon 25 May 2026"`, yet Boxer C's row inside that block references a loss on `Sat 27 Jun` and a goal set `Mon 29 Jun`. Label the roster snapshot cleanly as `Card opening (Wed 1 Jul)` vs `Booking (Mon 25 May)`.
- **Split weigh-in model (`Bouts.weigh`) & class limits:** Home shows move to bout-day weigh-ins ([EB rule 7.1.3](https://www.englandboxing.org/wp-content/uploads/2026/01/2026-Rule-Book-Final-01-26.pdf)) while away club shows stay day-before. That works for now, though it creates two weigh-in rules across the same club-show circuit until away shows also adopt day-of weigh-ins. Also note that `Ask corner (+0.5 kg)` is an estimate inside EB's 2.5 kg matching gap rather than a strict EB rule.
- **Section 10 layout width & Continue button:** `520 + 840 + 560 = 1920 px` leaves **zero pixels for the shell's left rail** (`Home, Fighters, Fights, Club, World`), and calling `"Send the asks"` a **green `Continue` button** clashes with the shell's time-advance `CONTINUE` button. Keep green strictly for advancing time (`CONTINUE`) and use a primary whiteboard ink/red button for `"Send the asks"`.

## Depth: 7/10

Every route, weight answer, and timing step now carries real, non-dominated trade-offs:
- **Boxer A's six routes** (`As is`, `With a favour`, `Promise`, `Name below`, `Name below + Swap`, `Wait for region show`) trade immediate pro-offer odds (`29` to `43 in 100`), main-event poster seats (`±24`), scarce favours, and a `4–12 week` rematch lock.
- **Boxer B's four weight options** (`Keep`, `Ask corner`, `Harder week`, `Stand down`) trade favour spend, `-12 Energy` (`stale_energy`), miss risk (`1 in 3`), and `-25` seats.
- **Boxer C's choices** (`Novice`, `Skills bout`, `Leave off`) become genuine once `GOALFIX1` stops punishing mid-week bouts with `-20` on `Stamina`.
- **Community vs Town hall** trades rent (`$1,000` vs `$2,000`), `+2 in 10` yes chance on top names, and `-4` half-empty risk.

What keeps it from 8–9: the Gym floor's `+$440` ceiling loses to `$900` away even at a sell-out, and rule #3's `+1` hosting favour currently refunds `With a favour` and `Ask corner` on show night.

## General design: 7/10

What clears the 6+ bar cleanly:
- **S448 & S412 compliance:** names are strictly confined to card headers, and all copy is sandbox-neutral.
- **Round-3 fixes landed:** `GOALFIX1` fixes the goal-judging bug and switches to `Stamina`; novice rules (`0–10` vs `12–13`) are consistent; card/visitor counts (`2+7`, `2+10`) and `BoutRead.band` probabilities (`37`, `54`) align with the pack; `MOVE DOWN`, `Swap (64 in 100)`, `Hold for our show`, and `Day-of weigh-in` are defined; `HOSTPROBE1` sets clear numeric pass bars; and all 13 tasks are scoped under 500 lines on real code symbols.

What keeps it at 7: the Gym floor ceiling vs away pay, the favour self-refund loop, the undefined `Tougher short-notice` pull-out option in Section 5, missing reserve sex/class matching rules, minor arithmetic/date slips in Section 6, and the 1920 px layout forgetting the shell's left rail.

## Play: 7/10

`Hold for our show` toggles, aligned 3-week camp timing, `TICKET READ` at 12 days out, final-week pull-outs with standby reserves, and the actionable post-show sheet (`Add places`, `Review pro offer`, `Book next show`) turn hosting a show into a multi-beat club event rather than a dead 5-week wait followed by a receipt. Still missing a clear recovery path when one of *our* main bouts pulls out late and the two general reserves are in the wrong weight class.

## Options

| Option | What it changes | Verdict |
|---|---|---|
| Date (4 Saturdays) | Region clash (`×0.8`), boxer availability | Keep. |
| Hold for our show (toggle) | Auto-passes away offers within 14 days of show | Keep. |
| Hall (Gym floor / Community / Town) | Seats, rent, draw (`×0.8/1.0/1.25`), base yes (`3/5/7`), rep | Re-price Gym floor so a full house beats `$900` away. |
| Opponent route (Above / Below / Novice / Skills / Wait / Leave off) | Yes, `BoutRead` win, rank prob, pro offer, seats, taper/injury | Keep. |
| How to ask (As is / Favour / Promise) | Yes chance, `-1` favour, or `4–12 wk` rematch lock | Fix rule #3 so `With a favour` doesn't self-refund `+1`. |
| Weight (Keep / Ask corner / Harder week / Stand down) | Miss risk, `-1` favour, `-12 Energy`, or `-25` seats | Keep; align `STOP_REST_WEEKS` on promised rematches. |
| Ladder swap (`64 in 100` joint) | Rank path via `-1` favour each club | Keep. |
| Standby reserves (`0–2`, `$40` each) | Insures against 25% pull-out & `-2` short-night rep | Keep; define sex/class/novice match rules. |
| Ticket read (Keep / Door $15 / Boxers sell / No-gi sells / Move down / Cancel) | Seats, pad mastery (`-2.6`), mat class (`-1.1`, `-4` morale), rep | Keep; include cut visitors' lost supporters in `Move down`. |
| Pull-out resolution (`Tougher short-notice` / `Novice`) | Undefined in Section 4.10 | Define in 4.10 or cut from Section 5. |

**Missing:**
- **Reserve class/sex tag and short-notice fallback for our own bouts** (defining `Tougher short-notice` and whether a late opponent pull-out for *our* boxer can pull from a regional pool if the 2 booked reserves are in other divisions).
- **Explicit `-2 favours` warning on `Review pro offer`** when turning pro on show night breaks a promised return bout.
- **No-refund guard on favour-booked bouts** in Section 4.5 rule #3.

## To reach 10/10 (most important first)

1. **Close the favour self-refund loop.** In Section 4.5 rule #3, add: *"Only clean main-card bouts asked `As it is` (or called-up reserves) earn `+1` favour on show night; bouts where the host spent a favour (`With a favour` or `Ask corner`) net `0`."* Otherwise `With a favour` and `Ask corner` remain free whenever the fight happens.
2. **Make the Gym floor beat boxing away on a full house.** Cut Gym floor fixed show overheads from `$1,500` to `$850` (smaller 6-bout amateur club card: `$650` doctor/officials + `$200` medals, `ESTIMATE`) or raise `places × 5` (`110` seats on 22 places), so an 88–110 seat sell-out nets `+$1,090` to `+$1,100` instead of capping at `+$440` below two away bouts (`$900`). Also add `Gym floor beats $900 away on young (40/10)` to `HOSTPROBE1`.
3. **Define reserve class matching and Section 5's pull-out options.**
   - State each standby reserve's sex, kg class, and novice/open status when booked (preferring the weight classes of our own main-card boxers).
   - Define `Tougher short-notice` (a free higher-rated regional name within legal class/novice rules who takes `+$40` extra travel) and `Outside novice` (`$80`) inside Section 4.10, or cut them from Section 5.
4. **Fix the Section 6 arithmetic and timeline slips.**
   - Boxer B asking `#3` (`62.0` vs `58.0`, +4 pts): `5 + 2 = 7 in 10` (not `6 in 10`).
   - Recalculate `Ask #7 as it is` (`27 in 100`) and `Ask #7 + Swap` (`41 in 100`) or print the exact tie-break assumptions behind `29` / `43`.
   - Separate the `Mon 25 May` club snapshot from Boxer C's `Wed 1 Jul` card-opening state (`lost Sat 27 Jun`, `goal Mon 29 Jun`).
5. **Tie up the three edge rules.**
   - **Rematch floor after a stoppage:** if a boxer with a promised return bout loses by stoppage, the other club's rematch window shifts from `4–12 weeks` to `8–12 weeks` to respect `Matchmaking.STOP_REST_WEEKS`. Show a `-2 favours` warning inside `Review pro offer` when turning pro breaks an active promise.
   - **`Move down` draw update:** subtract `3 × cut_visitors` from the smaller hall's projected draw and state that cutting visiting pairs 12 days out costs `0` favours (or `-1` if kept strict).
   - **`A no-gi athlete sells`:** tag `-$75` as `ESTIMATE` (or bind it to the real per-class no-gi coach cost in `GymSpend` / `BJJ`, which the pack currently leaves unstated).
6. **Unify amateur weigh-ins across the circuit (post-v4 follow-up).** Keep the home-show day-of branch in `Bouts.weigh` for task 10, and queue a clean follow-up task to move away club shows onto the same England Boxing rule 7.1.3 day-of weigh-in.
7. **Fix the 1920×1080 shell widths and button colour.** Fit the three columns inside the `~1760 px` content area beside the `160 px` left rail, and reserve green strictly for the shell's `CONTINUE` button (`Send the asks` uses primary whiteboard ink/red).

## The 10/10 page at 1920×1080 (`Fights > Our show`, 16 days out, Look B whiteboard)

- **Shell:** existing dark top bar (`64 px`) and left rail (`160 px`, `Fights` active), leaving **`1760 × 1016 px`** for the tan plaster wall and aluminium-framed whiteboard.
- **Header strip (`1760 × 96 px`):** club crest, `"Our show"`, circled marker date, hall + seats + `$25` ticket, days out, magnet timeline (`Asks close` · `Posters & Read` · `Region show` · `Day-of weigh-in` · `Show night`).
- **Left column (`480 px`) — `OUR BOXERS`:**
  - Stacked boxer rows: face card (**name in header only**), day-of weight vs limit, condition/morale/goal chips, **Hold for our show** toggle.
  - Up to 3 route tiles per boxer: opponent face card (**name in header only**), `Yes`, `Wins N in 100 (band)`, **`No. 3 or better: N in 100`** (hover opens condition tree), `Pro offer: N in 100`, seats, and ask pills (`As it is` · `Favour` · `Promise ["Locks next bout (4-12 wks)"]`).
  - Four weight options on the row (`Keep`, `Ask corner`, `Harder week`, `Stand down`) with miss odds.
- **Centre column (`760 px`) — `THE CARD & LADDER`:**
  - Cream bout sheet: our bouts in red marker, visiting pairs in pencil, main event boxed; **2 Standby reserve slots** showing sex, kg class, novice/open tag, and `$40` standby fee.
  - Division table beside it with movement arrows from our night and the region's show; Ladder pairs highlighted with inline swap buttons (`64 in 100` joint yes, `-1` favour each club).
- **Right column (`520 px`) — `THE NIGHT`:**
  - Segmented seats bar (club / followings / posters / visitors) with `Half-empty (50%)` and `Full (85%)` ticks.
  - Net cash vs `$900` away (likely / bad / good night, `$5/seat` raffle shown).
  - Reputation parts + `member_limit` readout with **`Add places`** link when capped; Scarce Favours ledger (`0–2`, expiry weeks, what earns `+1`).
- **Bottom strip (`1760 × 120 px`):** assistant coach portrait + one-line note (no names, no pronouns), `Back to coach's card`, and one primary red-ink **`Send the asks`** button (keeping green solely for the shell's `CONTINUE`).

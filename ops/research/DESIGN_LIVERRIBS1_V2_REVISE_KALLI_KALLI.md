# DESIGN_LIVERRIBS1_V2_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ85)

Brief: research/DESIGN_LIVERRIBS1_V2_REVISE_KALLI.md
Sent: 2026-11-14 00:11 | collected: 2026-11-14 00:41 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

# LIVERRIBS1 v2: the liver and the ribs do different things (design map, round 2, S460)

Part 1 of 3

**Quoted owner rules carried in this map:**
- **Q-S294-219 (S460 board):** `"Yes: liver = stamina drain + a knockdown chance when hurt, ribs = the injury place (cracked rib, weeks out). Design map + critics first."`
- **S448 (names only in headers):** a person's name sits in the screen or card header once; options, buttons, rows, lines and tooltips say `your boxer`, `the opponent`, `your coach`, or use no fixed pronoun.
- **S412 (sandbox):** the player runs any gym with any boxers, men or women. Never write about one boxer as the story, and never use a fixed `he` or `she` in text or mockups.
- **S425 (menu wiring):** keep the map's table of every menu the mechanic appears on and what each is wired to.
- **S459 (bar & mirrors):** must clear 6+ DEPTH and 6+ GENERAL DESIGN with fresh critics; mirror every fight lever in `BoutRead`; mark which numbers are **ESTIMATE**; stay buildable from what the game has.
- **Section 7 rulings:** only actionable information; plain words, one word per concept; hover explains every number; corner retirement cards sit behind a divider and are never pre-selected.

**Marks:** **CODE** = in the code today (file and symbol named). **ESTIMATE** = ours, verified by `LIVERPROBE1` (section 7) before shipping. **NEW** = rule or move added by this map. **[R]** = real-world source (NHS / boxing rules).

**Source status note:** Written from the S403 critic pack (with S409, S410, S448, S451 additions), LIVERRIBS1 v1, Dola's critic return (`SQ77`), and John's critic return (`SQ78`). `CRITIC_ACCESS.md` and the Miro board were not opened directly.

---

## 0. Answer to every critic point (`To reach 10/10`, Dola SQ77 & John SQ78)

| Critic & point | Change in v2 (or one-line reason why not) |
|---|---|
| **John #1:** Fix anatomy (`BodyMap` put liver on left for southpaws; source cover 30/60) | **Done (2, 3.1).** Liver is always the defender's **right side** (`BodyMap.SIDE_RIGHT`); ribs/spleen are always the defender's **left side** (`BodyMap.SIDE_LEFT`). Attacker's hand sets the side hit; defender's stance sets base cover: lead side `30%`, rear side `60%` (**ESTIMATE**, probed in `LIVERPROBE1`). |
| **John #2:** Add rear-hand body punches (`4b`, `2b`) + combos (`1-2b-3`, `2b-3`, `3b-4b`) | **Done (2).** Added `Rear body hook (4b)` and `Rear straight to the body (2b)` as moves with mastery/drill cards, plus book combinations `1-2b-3`, `2b-3`, `3b-4b`. `Aim Liver` / `Aim Ribs` favours the hand that reaches that side, trading rear-hand reach/energy vs lead speed. |
| **John #3:** Give ribs a payoff tonight (`HURT` drops guard -5 & output x0.85; Playbook line) | **Done (3.6, 5).** At `HURT` (`<=55`) on the left ribs, the defender drops that elbow: left-side head guard **-5** and left-hand punches **x0.85** (**ESTIMATE**). Playbook line `"When opponent's ribs are hurt -> Attack the head"` rates `Beats it`. |
| **John #4:** Injury rule as roll (25% crack at CRITICAL at bell, bruise <50 only, liver never; probe 400 bouts/cell) | **Done (3.8–3.10, 7).** `CRITICAL` on left ribs at final bell rolls crack at **25 in 100** (**ESTIMATE**), not 100%. Bruised ribs trigger only on left ribs `< 50` (removed `"any rib at HURT"`). Liver never causes a weeks-out injury. Added `LIVERPROBE1` targets: `2–4` rib injuries/100 bouts, `<=1` crack/100, `10–20%` body KDs. |
| **John #5:** Print full price on crack card; neutral pronouns; Heart/trust rules | **Done (4.1).** All three corner choices print exact prices (`30-day suspension`, `STOP_REST_WEEKS`, `-4` rep, `-2` members, `-12` morale, `BoutRead` win chance, days out, `1 in 10` worse). High-Heart boxer loses `-3` morale on Pull out; `-2` trust fires only if fighting on ends in stoppage (**ESTIMATE**). Zero fixed `he`/`she`. |
| **John #6:** Opponent-corner retirement rule (40 in 100 at each bell, higher if behind) | **Done (3.7).** Opponent's corner retires a cracked boxer **40 in 100** at each bell (**65 in 100** if behind on scorecards, **ESTIMATE**). Corner read prints `"Opponent's corner is talking about stopping it"`. |
| **John #7:** Defence by side (`Right elbow in` / `Left elbow in` in corner `ONE CHANGE`) | **Done (4.2).** Replaced unbuilt `"Cover up"` shout promise with corner `ONE CHANGE` options **`Right elbow in (guard liver)`** and **`Left elbow in (guard ribs)`**: `+20` side cover, `-10` head guard on that side (**ESTIMATE**). Probed again in `LIVERPROBE1` because body KDs/drops change who wins. |
| **John #8:** Tune fold `p` to target; clamp after x2; use `Strength` + `Explosiveness` + mastery | **Done (3.2).** `attack_power` reads `Attrs.gd` `Strength`, `Explosiveness`, and the landed body move's mastery (no `Power` summary stat). `CRITICAL` doubles `p`, clamped at **16%** max (`1–8%` base at `HURT`, **ESTIMATE**). `LIVERPROBE1` measures hooks landed per hurt round and tunes `BASE_FOLD` to owner's body-KD target. |
| **John #9:** Amateur rules (8-count, RSC 3/4 limit; 35% count-out pro only; energy ceiling -25) | **Done (3.3).** Body knockdown is an 8-count and counts toward amateur RSC (`3` in round, `4` in bout, **CODE**). Pro fights use `35%` count-out share (**ESTIMATE**); amateur body stoppages record as `RSC`. Drop unbuilt `"legs bar"`: use existing `FightMeters` **energy ceiling -25** for the round. |
| **John #10:** Wire scout lines & bruised/cracked offer rules; gate NPC rival calendar | **Done (5, 6, 9).** Scout lines (`"Hunts the liver"` / `"Breaks ribs"`) derive from opponent's real body-shot share. Bruised ribs allow offers (`-5` energy if boxing bruised, **ESTIMATE**); cracked rib blocks offers. Rival missed-bout news is **gated behind living-world NPC injuries (`AGREED, NOT BUILT`)**. |
| **John #11:** Clear Aim labels & numeric tooltips | **Done (6).** Aim buttons read **`Liver (right side)`** and **`Ribs (left side)`** with numeric tooltips (`"Each landed liver shot costs 1.3x body stamina; hurt: fold chance"`). |
| **Dola #1:** AI adapts target after 2 rounds of heavy cover | **Done (4.3).** When one side's cover (`Right/Left elbow in` or high stance cover) blocks most shots over **2 rounds**, `OpponentAI` shifts aim to the other side; corner read prints `"Opponent is targeting your other side now"`. |
| **Dola #2:** Injury risk band on bout offer (`BoutRead`) | **Done (5, 6).** Bout offer / Full report scouting notes show `"Body threat: [Low / Moderate / High] rib injury risk"` from opponent's body-shot share + `Strength`/`Explosiveness` (**NEW**, no exact %). |
| **Dola #3:** Three corner options on crack card (`Pull out`, `Defend only`, `Fight through`) | **Done (4.1).** Added **`Defend the side`**: `0` punches from cracked side, `-4` guard on that side, normal power on good side, heals **63 days** (**ESTIMATE**). All three print `BoutRead` win odds and full consequences. |
| **Dola #4:** One-click target switch suggestion on corner card | **Done (4.3).** If `CornerRead` flags heavy cover on one side (`2+` rounds) or `HURT` on left ribs, corner card shows a one-click button (`"Switch Aim to Ribs (left side)"` / `"Target the hurt side's head"`). |
| **Dola #5:** Small living-world reactions on opponent crack | **Gated cleanly (6, 9).** `OpponentCalendar` / rival news (`"Out with cracked rib"`) is **not built in code today (`AGREED, NOT BUILT`)**, so it is wired as a gated hook behind living-world NPC injuries rather than faked; tonight's payoff stands on its own (guard `-5`/`-10`, output `x0.85`/`x0.6`, `40%` corner retirement). |

*(Also fixed from John's logic check: replaced vague `"her body stat"` with `Attrs.gd` `Durability` + `Stamina`; fixed S412 pronouns everywhere.)*

---

## 1. Today in the code (`S460`) and the change in one line

**Today (CODE):**
- Only `body_hook` (`3b`) reaches the body (`60%` liver side, `40%` other side). `BodyMap.gd:76-83` swaps liver side by defender stance (wrong for southpaws).
- `Exchanges.BODY_COST 1.2` (`Exchanges.gd:35-45`) drains the same stamina on both sides; `FightMeters` caps energy ceiling by `body_taken`.
- `Knockdowns.gd` (`DAMAGE_SCALE`, `KO_DAMAGE`) reads **head** damage only.
- `InjuryRoll.gd` (`BOUT_TYPES`, `RIB_HURT_LINE`) draws one `"Rib injury"` (`weight 10`, `x3` under 35; `21–35` days) identically for both sides.
- `RoundHits.WORDS` already names `"liver"` and `"ribs"`, so the player sees two labels that behave the same.

**The change in one line:**
**LIVER (right side)** wins tonight (faster stamina drain + delayed fold knockdown when `HURT`, never a weeks-out injury); **RIBS (left side)** drop guard/output tonight (`HURT` opens the head, `CRACK` cripples that arm or triggers corner retirement) and cost **2–12 weeks** in recovery after the bell.

---

## 2. Anatomy, punches, and stance cover

### Fixed anatomy (**CODE fix in `BodyMap.gd`**)
- **`BodyMap.SIDE_RIGHT` = Liver:** always the defender's **right side**, orthodox or southpaw.
- **`BodyMap.SIDE_LEFT` = Ribs:** always the defender's **left side** (ribs/spleen), orthodox or southpaw.

### Hand-to-side rule + new rear-hand body punches (**NEW**)
A punch's throwing hand determines which side it hits:
- **Attacker's left hand** hits defender's **right side (Liver)**:
  - Orthodox attacker: `Body hook (3b)` (**CODE**, lead left).
  - Southpaw attacker: `Rear body hook (4b)` / `Rear straight to the body (2b)` (**NEW**, rear left).
- **Attacker's right hand** hits defender's **left side (Ribs)**:
  - Orthodox attacker: `Rear body hook (4b)` / `Rear straight to the body (2b)` (**NEW**, rear right).
  - Southpaw attacker: `Body hook (3b)` (**CODE**, lead right).

**New moves & book combinations (added to `Playbook > Moves / Combos`, `PadWeek` drill cards):**
- **`Rear body hook (4b)`** and **`Rear straight to the body (2b)`** (**NEW**): carry mastery (`New / Raw / Usable 30 / Sharp 60 / Signature 85`). Rear-hand body shots carry **higher energy cost and commitment** than lead `3b` (`ESTIMATE`, probed in `LIVERPROBE1`), giving `Aim Liver` vs `Aim Ribs` a real reach/gas trade in every stance matchup.
- **New book combinations:** `1-2b-3`, `2b-3`, `3b-4b` (**NEW**).

### Base cover by defender stance (**ESTIMATE**, verified in `LIVERPROBE1`)
- **Lead side** = **30%** base cover (left ribs for orthodox; right liver for southpaw).
- **Rear side** = **60%** base cover (right liver for orthodox; left ribs for southpaw).
- **Why both Aims matter:** Against an orthodox defender, `Aim Liver` uses quick left hooks into `60%` rear cover for drain and fold; `Aim Ribs` throws committed right body shots into `30%` lead cover to drop their left guard and open head punches. Against a southpaw, `Liver` sits on their `30%` lead side (exposed to the rear left), while `Aim Ribs` hits their `60%` rear side to take away their rear power hand.

---

## 3. Rules (`CODE` / `NEW` / `ESTIMATE`)

| # | Rule | Numbers (`ESTIMATE` / `TUNE` range) | Real-world basis |
|---|---|---|---|
| 1 | **Stamina drain by side:** landed liver shot costs `BODY_COST × LIVER_DRAIN` scaled by defender `Durability`; rib shot costs `BODY_COST × RIB_DRAIN`. Neutral at 60/40 traffic (`0.6×1.3 + 0.4×0.55 = 1.0`) | `LIVER_DRAIN 1.3` (`1.2–1.5`), `RIB_DRAIN 0.55` (`0.4–0.7`) (**ESTIMATE**) | Liver shot triggers vagal reflex (blood pressure drop); rib shot hurts locally without draining the whole tank |
| 2 | **Liver `HURT` fold:** once defender's right side (Liver) is at `HURT` (`<=55`) or worse (`BodyMap.band`), each landed left-hand body shot rolls a delayed fold. `attack_power` uses `Attrs.gd` `Strength`, `Explosiveness`, and the move's mastery (not `Power`) | `p = clamp(BASE_FOLD × exp((attack_power - defender_durability)/12), 0.01, 0.08)` (**ESTIMATE**, `BASE_FOLD` default `0.03` tuned by `LIVERPROBE1`); `×2` at `CRITICAL` (`<=35`), **capped at 16%**; max `2` per bout | Delayed liver fold; tuned against measured hooks per hurt round to hit `10–20%` body-KD share |
| 3 | **Body knockdown & counts:** body knockdown is an **8-count** and drops defender's `FightMeters` **energy ceiling by −25** for that round (**ESTIMATE**). Counts toward amateur RSC limit (**3 counts/round, 4/bout**, **CODE**). 3D shows a fold, not a fall back | Pro count-out share `35%` (`25–45%`, **ESTIMATE**) vs `15%` head KD; amateur stoppages record as **RSC** | Amateur bouts halt via RSC on counts; pro bouts see more full 10-counts from liver pain |
| 4 | **Fresh liver counter (S437):** stays as `DAMAGE_MAP_S437` row 10 on a landed left-hand body counter | `0.6%` (`×2` on opponent Push, cap `3%`), once per bout (**CODE/S437**) | Timed liver counter |
| 5 | **Ribs `HURT` tonight payoff:** once defender's left ribs reach `HURT` (`<=55`), they drop that elbow to protect the side: left-side head guard **−5** and left-hand punches **×0.85** | Guard `−5` (`3–7`), output `×0.85` (`0.80–0.90`) (**ESTIMATE**) | "Kill the body and the head will follow": protecting sore ribs drops the guard on that side |
| 6 | **Ribs `CRACK` in the bout:** once left ribs are `CRITICAL` (`<=35`), each landed right-hand body shot rolls a crack; on crack, corner read flags holding the side | `4%` (`2–6%`) per landed shot (**ESTIMATE**); unmitigated crack gives left-side punches `×0.6`, left guard `−10` (**ESTIMATE**) | Repeated hooks to already-damaged ribs can crack one mid-fight |
| 7 | **Opponent crack corner rule:** at each bell after an opponent's rib cracks, opponent's corner retires them **40 in 100** (**65 in 100** if trailing on scorecards). Corner read warns before the bell | `40%` base / `65%` behind (**ESTIMATE**) | Corners pull compromised fighters rather than let a cracked rib keep taking shots |
| 8 | **Your boxer cracked (corner card):** between rounds, behind a divider, never pre-selected: **Pull your boxer out** / **Defend the side** / **Fight through** (full prices in 4.1) | Heals: `35` days / `63` days / `84` days (`+28` days `1 in 10`) (**ESTIMATE**, `[R]` NHS 2–6 wks + return-to-sparring) | Real corners choose between retiring, shelling up to survive, or risking a worse break |
| 9 | **Post-bout injury split:** **Liver side never produces a weeks-out injury.** Left ribs only: **Bruised ribs** if left ribs `< 50` without crack; **Cracked rib** if cracked in bout OR **25 in 100** roll at final bell when left ribs are `CRITICAL` | Bruised `10–21` days (sparring locked, pads OK; offers allowed, `−5` energy if fighting bruised); Cracked `35–56` days (offers blocked; no sparring, no pads on left side; roadwork/legs/footwork OK) (**ESTIMATE**) | NHS: bruised/cracked ribs heal in 2–6 weeks; cracked rib adds sparring clearance time |
| 10 | **Training:** body sparring and heavy-bag sessions roll **Bruised ribs** from load (`TRAIN_TYPES` ribs, **CODE**); a cracked rib never occurs in training without sparring | As **CODE** today | Training load bruises, heavy contact fractures |

Part 2 of 3

## 4. Corner card, side defence, and corner adaptation

### 4.1 Your boxer's crack card (between rounds, behind a divider, never pre-selected)
Uses the fighter's dynamic pronoun or `"your boxer"` (zero fixed `he`/`she`, zero names outside the header). Every number comes live from `BoutRead` and `Injuries`:

| Option button | Exact text shown on the card | Mechanical effect |
|---|---|---|
| **Pull your boxer out** | `"Stoppage loss · 30-day suspension · next bout ~8 wks (STOP_REST_WEEKS) · −4 reputation · −2 members · −12 morale · rib heals 35 days"` *(adds `"−3 morale"` if high Heart, **ESTIMATE**)* | Ends bout immediately by retirement (`CODE` stoppage effects + `35` days rib recovery, **ESTIMATE**) |
| **Defend the side** | `"Win chance N in 100 (BoutRead) · 0 punches from cracked side, −4 left guard · heals 63 days"` *(adds `"−2 trust if stopped"`, **ESTIMATE**)* | Good side fights normally; cracked side throws `0` punches; left guard `−4` instead of `−10`; heals `63` days (**ESTIMATE**) |
| **Fight through** | `"Win chance N in 100 (BoutRead) · ×0.6 punches from cracked side, −10 left guard · heals 84 days (1 in 10 worse: +28 days)"` *(adds `"−2 trust if stopped"`, **ESTIMATE**)* | Cracked side punches `×0.6`; left guard `−10`; heals `84` days with `10%` risk of `+28` extra days (**ESTIMATE**) |

### 4.2 Side defence in the corner minute (`ONE CHANGE`, **NEW**)
Replaces the unbuilt `"Cover up"` shout idea. Corner minute `ONE CHANGE` adds two explicit side-guard fixes beside the existing `Elbows in` / `Gloves high` / habit fixes:
- **`Right elbow in (guard liver)`:** right-side (Liver) cover **+20**, right-side head guard **−10** (**ESTIMATE**).
- **`Left elbow in (guard ribs)`:** left-side (Ribs) cover **+20**, left-side head guard **−10** (**ESTIMATE**).
- **Shout bar:** existing `Tie up` continues to cut body punches overall; `Aim` controls offensive side (`Liver (right side)` vs `Ribs (left side)`).

### 4.3 Opponent AI adaptation & corner switch button (**NEW**)
- **Opponent AI switches target:** if `your boxer` heavily covers one side (e.g. via `Right/Left elbow in` or high cover blocking most shots over **2 consecutive rounds**), `OpponentAI` shifts its body aim to the open side (`ESTIMATE`). `CornerRead` prints: `"The opponent is targeting your other side now"`.
- **Corner one-click switch button:** between rounds, if `CornerRead` detects the opponent overworking one side (`2+` rounds) or sees opponent's left ribs at `HURT` (`<=55`), the corner card offers a single-click suggestion button: **`"Switch Aim: Ribs (left side)"`** or **`"Target opponent's hurt side (head)"`**.

---

## 5. Depth and choices across the career

- **Booking (`Bout offer` / `Full report`):**
  - Opponent's file (`Scout lines`) reports `"Hunts the liver"` or `"Breaks ribs"` derived from their real left/right body-shot share (**NEW**, replaces invented labels).
  - `BoutRead` prints `"Body threat: [Low / Moderate / High] rib injury risk"` from opponent's body-shot frequency + `Strength` / `Explosiveness` (**NEW**, no exact percentage).
- **Training & Camp:**
  - `Durability` now protects against two distinct threats (liver fold resistance vs rib damage).
  - Players drill `Rear body hook (4b)`, `Rear straight to the body (2b)`, or `3b` depending on whether their fighter hunts liver or ribs and their stance.
  - Camp partner / sparring choices weigh body-shot preparation against `Bruised ribs` load risk.
- **Playbook:**
  - New situational line: `"When opponent's ribs are hurt -> Attack the head"` (rates `Beats it`, exploiting the `−5` left-side head guard from Rule 5).
- **Live round & Corner minute:**
  - **Aim `Liver (right side)`:** drains stamina faster (`×1.3`) and builds to delayed `HURT` fold (`8`-count / RSC / pro KO); leaves no post-bout injury.
  - **Aim `Ribs (left side)`:** lowers target cover against orthodox (`30%`), opens the opponent's left-side head guard (`−5`) and slows their left hand (`×0.85`) at `HURT`, risks mid-bout `CRACK` (`−10` guard, `×0.6` arm, `40–65%` opponent corner retirement), and inflicts `10–56` day injuries after the bout.
  - **Guard choice (`Right elbow in` vs `Left elbow in`):** save tonight's stamina & fold risk vs save the next 5–12 weeks on the calendar, while trading `-10` head guard on that side and forcing reads when the AI adapts.

---

## 6. Every menu it appears on, what each is wired to, and tests (`S425`)

| Menu | What the player sees / acts on (names in headers only; no fixed `he`/`she`) | Wired to | Test / Probe bar |
|---|---|---|---|
| **Live round: side holos** | `"Liver (right)"` and `"Ribs (left)"` hit/band counts; numeric hover tooltips: `"Each landed liver shot costs 1.3× body stamina; hurt: fold chance"` / `"Hurt: drops left guard −5; critical: can crack, weeks out"` | `BodyLive` + `LiverRibs` (pure) | `holo_live_test`: orthodox & southpaw both map Liver -> `SIDE_RIGHT` |
| **Live round: AIM buttons** | **`Liver (right side)`** / **`Ribs (left side)`** (replacing `"Right/Left ribs"`); effect lines match Rule 1/2/5/6 | `PaceAim` + `Exchanges` (`3b` vs `4b/2b` hand routing) | `pace_aim_test`: orthodox & southpaw aim routes to correct hand & side |
| **Live round: corner read** | `"Opponent's liver is hurt"`; `"Opponent is guarding the left side (head −5)"`; `"Opponent is holding the left side"`; `"Opponent's corner is talking about stopping it"`; `"Opponent is targeting your other side now"` | `CornerRead` + `OpponentAI` | `corner_read_test`: reads fire at `HURT`, `CRACK`, and 2-round AI switch |
| **Live round: knockdown** | 3D fold animation + 8-count; `"Body knockdown (liver)"`; `FightMeters` energy ceiling `−25` for round; amateur RSC counter increments | `Knockdowns` body path + `KnockdownCount` + `FightMeters` | `knockdown_rates_test`: amateur stops by RSC at 3/4 counts; pro 35% count-out |
| **Between rounds: corner minute & crack card** | Side elbow fixes (`Right elbow in` / `Left elbow in`); one-click Aim switch button; behind divider, never pre-selected **CRACK CARD**: `Pull your boxer out` / `Defend the side` / `Fight through` with full prices | `CornerJobs` + `BoutRead` + `Injuries` | `corner_crack_golden_test`: 3 buttons un-selected, full prices match `BoutRead` & `STOP_REST_WEEKS` |
| **Bout offer / Full report (`BoutRead`)** | `"Body threat: [Low/Moderate/High] rib injury risk"`; Aim lever mirrored in `BoutRead` simulation; scout lines `"Hunts the liver"` / `"Breaks ribs"` | `BoutRead` + `Scout` | `bout_read_test`: Aim liver vs Aim ribs produces measurable delta in `BoutRead` |
| **Playbook (`Moves` & `Combos` & `Game plan`)** | `Rear body hook (4b)` & `Rear straight to the body (2b)` drill cards; combos `1-2b-3`, `2b-3`, `3b-4b`; new situation `"When opponent's ribs are hurt"` | `MovesBook` + `PadWeek` + `GamePlan` | `playbook_body_moves_test`: `4b`/`2b` learn & fire in `Exchanges` |
| **Fight result page** | `"Body knockdown (liver), round 2"`; `"Cracked rib (left), fit Mon 2 Mar"` or `"Bruised ribs (left), fit Mon 2 Feb"` | `Aftermath` + `Injuries.line` | `result_defects_test`: liver never prints weeks-out injury |
| **Home: needs & news** | Injury card with weeks out; fought-on note (`"Fought through cracked rib: 12 weeks"`); bruised warning (`"−5 energy if booked while bruised"`) | `Injuries.after_bout` + `HomeNeeds` | `injuries_test`: `2–4` rib injuries/100 bouts, `<=1` crack/100 in probe |
| **Fighter > Week** | Bruised: sparring locked, pads OK; Cracked: `"No sparring or left-side pads until Mon 2 Mar"` (roadwork/footwork OK) | `PadWeek` + `StandDown` locks | `pad_week_test`: cracked blocks offers & left-side pads; bruised allows offers at `-5` energy |
| **World > News / Region *(GATED)*** | *Only once living-world NPC injuries (`AGREED, NOT BUILT`) ship:* `"Opponent out with cracked rib — pulls from regional show"` | `Region` / `OpponentCalendar` *(gated flag)* | Inactive until living-world NPC injury calendar lands |

Part 3 of 3

## 7. Build tasks, `LIVERPROBE1` bars, and Golden Path

### Build tasks (after critics hit 6+ / 6+ and owner approves board)
1. **Fix `BodyMap.gd` anatomy (`SIDE_RIGHT` = Liver always, `SIDE_LEFT` = Ribs always) + add `Rear body hook (4b)`, `Rear straight to body (2b)` and combos `1-2b-3`, `2b-3`, `3b-4b`.** (Qwen)
2. **`LiverRibs.gd` (pure):** `drain(side)`, `liver_fold_chance(strength, explosiveness, mastery, durability, band)`, `ribs_hurt_penalty(band)`, `crack_chance(band)`, `bell_crack_roll(left_rib_value)`, `opponent_corner_retire(crack, score_diff)`, `injury_split(left_rib_value, cracked, choice)` + unit tests. (Qwen)
3. **`LIVERPROBE1` (pure, cloud, 400 bouts per cell):** tune `BASE_FOLD`, rear-hand `4b/2b` gas/reach cost, and `Right/Left elbow in` cover/head-open values against Section 7 bars. (Goose)
4. **Wire combat, corner, & injury systems:** `Exchanges` (hand-to-side + drain + `HURT` guard `-5`/output `×0.85` + `OpponentAI` 2-round switch), `Knockdowns` (body 8-count + `-25` energy ceiling + RSC count), `BodyLive` / `CornerJobs` (3-choice crack card behind divider + side elbow fixes + Aim switch button), `InjuryRoll` (bruised `<50` / cracked 25% roll + `35/63/84` days), `BoutRead` (mirror Aim + `injury_risk_band`), `Scout` lines. (Claude / Cursor)
5. **Golden path test (`tests/liver_ribs_golden_test.gd`):** aim `Liver (right side)` -> verify `1.3×` drain, `HURT` fold 8-count, `-25` energy ceiling, zero post-bout liver injury; aim `Ribs (left side)` -> verify `HURT` `-5` guard / `×0.85` output, `CRACK` card with 3 un-selected full-priced buttons (`35 / 63 / 84` days), and `Fighter > Week` lock enforcement. (Grok Dev)

### `LIVERPROBE1` probe bars (400 bouts per cell, run before UI ships any `ESTIMATE`)
- **Rib injury rate:** **2–4 per 100 bouts** overall; **cracked ribs <= 1 per 100 bouts** (**ESTIMATE**, matching today's ~6% total bout injury × rib share).
- **Body knockdown share:** **10–20% of all knockdowns** (**ESTIMATE**, `BASE_FOLD` tuned from measured hurt-round hooks to hit owner's target).
- **No dominant Aim:** across `(orthodox balanced, orthodox pocket, southpaw, high-guard)`, `Aim Liver` and `Aim Ribs` each win the highest expected edge in at least one matchup (never >75% one-sided).
- **Side elbow fixes:** `Right elbow in` vs `Left elbow in` measurably shift win chance when facing a liver hunter vs rib breaker without dominating head-hunting matchups (`-10` head guard cost bites).
- **Season stability:** average career layoff days from body injuries stay within **+10%** of today's baseline.

---

## 8. The 10/10 page at 1920×1080 (`Fight night`, corner minute after round 2, dark and tight)

*(Names sit once in the two corner headers; zero names and zero fixed `he`/`she` anywhere else.)*

- **Header strip (88 px):** dark fight-night bar — your boxer's name (left header) vs opponent's name (right header), round `2 of 3` (or pro rounds), live scorecard read, 60-second corner clock.
- **Left column (560 px) — `YOUR BOXER`:**
  - Body silhouette with 6 hit zones as marker rings; **Liver (right)** and **Ribs (left)** coloured by damage band (`Fine / Hurt / Critical`), `"CRACKED"` stamped over left ribs when triggered.
  - Existing `FightMeters` below: current energy & energy ceiling (showing `-25` round drop if folded), plus amateur RSC count tally (`1 of 3 this round / 1 of 4 bout`).
- **Centre column (800 px) — `CORNER MINUTE`:**
  - *When your boxer has a cracked rib (behind a divider, never pre-selected):* three cream cards side by side — **`Pull your boxer out`** (`Stoppage loss · 30-day suspension · ~8 wks · −4 rep · −2 members · −12 morale · 35 days`), **`Defend the side`** (`Win N in 100 · 0 left punches · −4 left guard · 63 days`), **`Fight through`** (`Win N in 100 · ×0.6 left punches · −10 left guard · 84 days, 1 in 10 +28d`).
  - *Standard corner minute (no crack):* handwritten coach card, `RECOVER` (3 points), `SET-UP`, `TALK`, and `ONE CHANGE` featuring **`Right elbow in (guard liver)`** / **`Left elbow in (guard ribs)`** (`+20 side cover / −10 head guard`) + one-click **`Switch Aim`** suggestion chip when triggered by `CornerRead`.
- **Right column (560 px) — `THE OPPONENT`:**
  - Opponent silhouette with Liver (right) and Ribs (left) bands.
  - Handwritten `CornerRead` log (`"Left ribs hurt — head guard −5"`, `"Targeting your other side now"`, `"Corner talking about stopping it"`).
  - Live `Aim` selector (**`Liver (right side)`** / **`Ribs (left side)`** / `Head`) with numeric hover tooltips and this round's fold/crack threat indicator.
- **Bottom strip (120 px):** your coach's handwritten one-line note (no names, no fixed pronoun), `Say nothing / No fix`, and the single round-bell button.

---

## 9. Rejected / gated items and risks

- **Rejected / replaced:**
  - `"Cover up"` generic shout -> replaced by `Right elbow in` / `Left elbow in` in corner `ONE CHANGE`.
  - Unbuilt `"legs bar"` -> replaced by existing `FightMeters` energy ceiling (`-25` for the round).
  - Deterministic crack at `CRITICAL` -> replaced by `25 in 100` roll at final bell.
  - Summary `Power` stat in fold formula -> replaced by `Strength` + `Explosiveness` + move mastery.
- **Gated on unbuilt systems:**
  - `World > News` / `OpponentCalendar` (`"Rival out with cracked rib"`) stays inactive behind living-world NPC injuries (`AGREED, NOT BUILT`).
- **Risks, said plainly:**
  - Adding `Rear body hook (4b)` and `Rear straight to body (2b)` requires 2 move definitions + 3 book combo entries + pad drill animation mapping (`Playbook`), though `StrikeMap` / `Exchanges` already support arbitrary move entries.
  - If `LIVERPROBE1` shows rear-hand body shots land too easily at `30%` lead cover, rear-hand reach/energy penalties must carry the balance so `Aim Ribs` does not become free head damage.
  - All `ESTIMATE` numbers (`1.3`/`0.55` drain, `BASE_FOLD`, `25%` bell crack, `35/63/84` days, `40%` opponent retirement, `+20/−10` elbow fixes) remain provisional until `LIVERPROBE1` passes.

**CHECKs:**
- **CHECK (Claude):** verify `PadWeek` / move book slots for adding `4b` and `2b` and confirm `Exchanges.gd` accesses `Strength` + `Explosiveness` + mastery per move rather than `Attrs` summary `Power`.
- **CHECK (John):** confirm owner's target body-KD share (`10–20%` of all knockdowns vs `"2–3 hurt rounds a season"`).

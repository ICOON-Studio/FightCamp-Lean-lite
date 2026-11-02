# S184 UI Tooltips Census & Audit

Audit of interactive controls (`Button`, `UIKit.button`, `UIKit.chip`, `_button`, `_choice_card`) across 11 panel files under `Godot/scripts/` to measure coverage under `UIKit.tip(node, spec)`.

## Summary & Totals

| File | Lines Audited | Controls Found | Covered | Uncovered | Coverage |
| :--- | :--- | :---: | :---: | :---: | :---: |
| `ScoutingHubPanel.gd` | 1–1244 | 8 | 1 | 7 | 12.5% |
| `StaffHubPanel.gd` | 1–627 | 3 | 1 | 2 | 33.3% |
| `TrainingHubPanel.gd` | 1–1783 | 10 | 3 | 7 | 30.0% |
| `ScheduleHubPanel.gd` | 1–4025 | 29 | 4 | 25 | 13.8% |
| `RankingsHubPanel.gd` | 1–1268 | 4 | 0 | 4 | 0.0% |
| `OfficeHubPanel.gd` | 1–1859 | 10 | 2 | 8 | 20.0% |
| `AreaHubScreen.gd` | 1–300 | 1 | 0 | 1 | 0.0% |
| `GymHubPanel.gd` | 1–1015 | 8 | 1 | 7 | 12.5% |
| `DayFeedScreen.gd` (incl. `DayFeedPanel.gd`) | 1–58 (`Screen`), 1–1224 (`Panel`) | 9 | 2 | 7 | 22.2% |
| `InterviewPanel.gd` | 1–300 | 6 | 2 | 4 | 33.3% |
| `GymHallPanel.gd` | 1–427 | 1 | 0 | 1 | 0.0% |
| **TOTAL** | **12,507 lines** | **89** | **16** | **73** | **18.0%** |

> [!NOTE]
> Native Godot `tooltip_text` is wiped by `TipLayer` and does not count as covered. Only `UIKit.tip(...)` or helpers that call `UIKit.tip(...)` internally (such as `G156Wire.icon_button`) provide working tooltips.

### Double-Tip Trap Analysis
No controls were observed receiving duplicate `UIKit.tip` calls on the same node instance. However, native `tooltip_text` calls were identified in `StaffHubPanel.gd` (L210), `TrainingHubPanel.gd` (L260), `DayFeedPanel.gd` (L480, L639, L731), and `GymHallPanel.gd` (L84); these are effectively wiped at runtime by `TipLayer` and require migration to `UIKit.tip`.

---

## 10 Worst Offenders

These represent critical user interactions or major actions with missing tooltips:

1. **`ScheduleHubPanel.gd:2675` — `OpenAgreement` ("OPEN BOUT AGREEMENT")**: Primary entry into bout contract negotiation lacks any tooltip explaining purse, clauses, or fight commitment.
2. **`ScheduleHubPanel.gd:1242` — `BookSelected` ("BOOK SELECTED" / "CANNOT BOOK")**: Main matchmaker booking trigger lacks tooltip explaining roster eligibility or booking requirements.
3. **`ScheduleHubPanel.gd:428` — `SkipToDecision` ("SKIP TO NEXT DECISION")**: Calendar simulation leap button has no tooltip clarifying stopping conditions or fast-forward risks.
4. **`GymHallPanel.gd:81` — `EndDay` ("END DAY")**: Primary day advancement button in the 3D hall uses native `tooltip_text` (L84), leaving the core loop action completely silent.
5. **`StaffHubPanel.gd:208` — `HireCoach` ("HIRE A COACH")**: Main coach recruitment CTA relies on native `tooltip_text` (L210), which is erased at runtime.
6. **`TrainingHubPanel.gd:258` — `OpenFloor` ("WATCH THE FLOOR")**: Gym floor 3D viewer transition relies on native `tooltip_text` (L260) and is silent.
7. **`TrainingHubPanel.gd:775` — `Clear` ("CLEAR THE WEEK")**: Destructive week wipe action lacks tooltip warning that all fighter workouts will reset to rest.
8. **`ScoutingHubPanel.gd:573` — `MakeOffer` ("SIGN CONTRACT" / "MAKE OFFER")**: Primary prospect signing button lacks explanation of negotiation terms and minimum asks.
9. **`OfficeHubPanel.gd:1213` — `CancelMove` ("CANCEL THE MOVE")**: Critical weight change abort button provides no explanation of weight cut progress lost.
10. **`OfficeHubPanel.gd:880` — `AcceptSponsor` ("ACCEPT")**: Binding sponsorship contract commitment lacks tooltip detailing weekly payment terms and obligations.

---

## Per-File Census Tables

### 1. ScoutingHubPanel.gd
*File range audited: lines 1–1244*

| Line | Control / Purpose | Covered | Proposed Tip (<=12 words, starts with verb) |
| :--- | :--- | :---: | :--- |
| L314 | `ClearFilter` (`SHOW EVERYONE`) | No | Reset active filter to show all available candidates. |
| L555 | `_side_pair` (`UIKit.pair`) in Candidate Side | Yes | Backed by UIKit.tip at L555. |
| L573 | `MakeOffer` (`SIGN CONTRACT` / `MAKE OFFER`) | No | Open contract negotiations with this candidate. |
| L580 | `PinButton` (`UNPIN` / `SHORTLIST`) | No | Toggle shortlist bookmark for this prospect. |
| L698 | `Down` (`-` in wage/term stepper) | No | Decrease contract offer amount or length. |
| L710 | `Up` (`+` in wage/term stepper) | No | Increase contract offer amount or length. |
| L728 | `SendOffer` (`SIGN CONTRACT` / `SEND OFFER`) | No | Submit formal contract proposal to candidate. |
| L735 | `WalkAway` (`WALK AWAY`) | No | Withdraw from negotiations and close offer dialog. |

---

### 2. StaffHubPanel.gd
*File range audited: lines 1–627*

| Line | Control / Purpose | Covered | Proposed Tip (<=12 words, starts with verb) |
| :--- | :--- | :---: | :--- |
| L208 | `HireCoach` (`HIRE A COACH`) | No | Browse free-agent coaches in the scouting hub. |
| L284 | `Flag` (`UIKit.chip` EXPIRED/EXPIRING) | No | Review contract expiration timeline for this coach. |
| L361 | `ReleaseCoach` (`G156.icon_button`) | Yes | Backed by G156Wire.icon_button calling UIKit.tip. |

---

### 3. TrainingHubPanel.gd
*File range audited: lines 1–1783*

| Line | Control / Purpose | Covered | Proposed Tip (<=12 words, starts with verb) |
| :--- | :--- | :---: | :--- |
| L258 | `OpenFloor` (`WATCH THE FLOOR`) | No | Watch live 3D workout stations across the gym. |
| L661 | `Hit` (`_hit` on workout impact row) | No | Select this workout session for the day. |
| L753 | `Development` (`DEVELOPMENT · THE MOVE LAB`) | No | Open fighter move catalog and skill progression. |
| L760 | `Copy` (`COPY THIS DAY` / `COPY ARMED...`) | No | Copy selected day's training program to clipboard. |
| L768 | `Paste` (`PASTE WORKOUT`) | No | Paste copied workout into selected day. |
| L775 | `Clear` (`CLEAR THE WEEK`) | No | Reset all days in the week to rest. |
| L843 | `OpenCamp` (`OPEN THE CAMP`) | No | Configure dedicated camp schedule and sparring focus. |
| L904 | `Booked_<n>` (Bout selector buttons) | No | Select this scheduled bout to prepare camp. |
| L1229 | `Preset_<id>` (Preset tray buttons) | Yes | Backed by UIKit.tip at L1235. |
| L1403 | `Tile_<focus>` (Focus selection tiles) | Yes | Backed by UIKit.tip at L1424. |

---

### 4. ScheduleHubPanel.gd
*File range audited: lines 1–4025*

| Line | Control / Purpose | Covered | Proposed Tip (<=12 words, starts with verb) |
| :--- | :--- | :---: | :--- |
| L421 | `NextUpGo` (Lead card action button) | No | Jump directly to the next scheduled event. |
| L428 | `SkipToDecision` (`SKIP TO NEXT DECISION`) | No | Simulate forward until next required management decision. |
| L499 | `Go` (Action button on MyGymRow) | No | Navigate to this scheduled event or obligation. |
| L954 | `PrevMonth` (`‹ PREVIOUS`) | No | View schedule for the previous calendar month. |
| L965 | `NextMonth` (`NEXT ›`) | No | View schedule for the next calendar month. |
| L1143 | `OpenOnCards` (`OPEN ON THE CARDS`) | No | Inspect full event fight card in world schedule. |
| L1234 | `OpenEvent` (`OPEN EVENT`) | No | View bouts and details for this event. |
| L1242 | `BookSelected` (`BOOK SELECTED` / `CANNOT BOOK`) | No | Book an eligible fighter onto this event card. |
| L1649 | `CancelBooking` (`G156.icon_button`) | Yes | Backed by G156Wire.icon_button calling UIKit.tip. |
| L2103 | `PassShortNotice` (`PASS` offer button) | No | Decline short-notice fight replacement opportunity. |
| L2121 | `AcceptShortNotice` (`ACCEPT AND CONFIRM`) | No | Accept emergency bout substitution and confirm fighter. |
| L2138 | `AcceptSigning` (`SIGN EXCLUSIVE`) | No | Sign exclusive promotion agreement with this organization. |
| L2166 | `AcceptContender` (`ACCEPT BOUT`) | No | Enter Contender Series bout to pursue promotional contract. |
| L2181 | `DeclinePromo` (`DECLINE`) | No | Decline promotional bout offered by organization matchmaker. |
| L2183 | `AcceptPromo` (`ACCEPT BOUT`) | No | Accept bout offer and lock date on schedule. |
| L2211 | `MatchPoach` (`MATCH SALARY`) | No | Match competing gym's salary offer to retain fighter. |
| L2214 | `AcceptRenewal` (`ACCEPT TERMS`) | No | Accept athlete's contract renewal terms. |
| L2217 | `DeclineRetention` (`DECLINE`) | No | Reject contract renewal terms and risk departure. |
| L2234 | `AcceptSponsor` (`ACCEPT PARTNER`) | No | Sign sponsorship agreement for recurring weekly income. |
| L2423 | `GradeChip` (`UIKit.chip` for division grade) | Yes | Backed by UIKit.tip at L2427. |
| L2541 | `Hit` (Amateur matchup selection hit) | No | Select this amateur matchup for tournament entry. |
| L2550 | `CardPress` (Amateur card hit button) | Yes | Backed by UIKit.tip at L2555. |
| L2675 | `OpenAgreement` (`OPEN BOUT AGREEMENT`) | No | Open bout agreement to negotiate purse and clauses. |
| L2707 | `EnterCard` (`ENTER CARD`) | No | Confirm fighter entry into amateur event bracket. |
| L2839 | `BackToCards` (`‹ THE CARDS`) | No | Return to the full event cards schedule. |
| L3377 | `Hit` (Grand Prix event row press) | No | Select this Grand Prix tournament to inspect. |
| L3421 | `SEAT` (`UIKit.chip` on GP invite row) | No | Indicate reserved seat invitation for this tournament. |
| L3462 | `Hit` (Grand Prix invite row press) | No | Select this open tournament invitation seat. |
| L3519 | `TakeSeat` (`TAKE SEAT` / `NO SEAT`) | No | Commit eligible fighter to this tournament bracket seat. |

---

### 5. RankingsHubPanel.gd
*File range audited: lines 1–1268*

| Line | Control / Purpose | Covered | Proposed Tip (<=12 words, starts with verb) |
| :--- | :--- | :---: | :--- |
| L501 | `FindOurs` (Division table scroll button) | No | Scroll to highest-ranked fighter from your gym. |
| L562 | `FindOurs` (P4P table scroll button) | No | Scroll to highest pound-for-pound fighter from your gym. |
| L607 | `OpenHolder` (Reigning titleholder button) | No | Open profile card of reigning titleholder. |
| L683 | `Unsourced` (`UIKit.chip("UNSOURCED")`) | No | Highlight ranking policy lacking confirmed source documentation. |

---

### 6. OfficeHubPanel.gd
*File range audited: lines 1–1859*

| Line | Control / Purpose | Covered | Proposed Tip (<=12 words, starts with verb) |
| :--- | :--- | :---: | :--- |
| L344 | `OpenBooks` (`OPEN THE BOOKS`) | No | Switch to contracts and weekly financial books. |
| L653 | `_source_pill` (Provenance status pills) | Yes | Backed by UIKit.tip at L660, L662, L664. |
| L880 | `AcceptSponsor` (`ACCEPT`) | No | Sign sponsorship agreement for recurring weekly income. |
| L931 | `CabinetTile%d` (Trophy cabinet medal tiles) | Yes | Backed by UIKit.tip at L939. |
| L1101 | `WeekPrev` (`PREV` week stepper) | No | Step backwards to view previous week ledger. |
| L1113 | `WeekNext` (`NEXT` week stepper) | No | Step forward to view next week ledger. |
| L1213 | `CancelMove` (`CANCEL THE MOVE`) | No | Cancel active weight class transition. |
| L1491 | `OpenProfile` (Retired fighter row hit) | No | View career record and history for retired fighter. |
| L1520 | `Hire` (`OFFER WAGE` on former fighter) | No | Hire former fighter as coach on weekly salary. |
| L1526 | `HireCut` (`OFFER CUT` on former fighter) | No | Hire former fighter as coach for purse percentage. |

---

### 7. AreaHubScreen.gd
*File range audited: lines 1–300*

| Line | Control / Purpose | Covered | Proposed Tip (<=12 words, starts with verb) |
| :--- | :--- | :---: | :--- |
| L247 | `Open` (`_pin` destination button) | No | Navigate to this section of the gym. |

---

### 8. GymHubPanel.gd
*File range audited: lines 1–1015*

| Line | Control / Purpose | Covered | Proposed Tip (<=12 words, starts with verb) |
| :--- | :--- | :---: | :--- |
| L449 | `TeamSlotEvening` (`EVENING WITH MEMBERS`) | No | Schedule team training alongside gym members. |
| L455 | `TeamSlotDay` (`DAYTIME APART`) | No | Schedule separate daytime training slot for team. |
| L594 | `Repair` (`REPAIR`) | No | Restore station condition to full working order. |
| L601 | `Rotate` (`ROTATE`) | No | Rotate station footprint ninety degrees. |
| L607 | `Move` (`MOVE` / `MOVE · PICK A CELL`) | No | Arm station repositioning across gym floor. |
| L641 | `Expand` (`EXPAND TRAINING ROOM`) | No | Enlarge gym training floor to fit more equipment. |
| L857 | `Buy` (`BUY` in decor rows) | No | Purchase and mount this decor piece on gym walls. |
| L879 | `MoveDecor` (`G156.icon_button`) | Yes | Backed by G156Wire.icon_button calling UIKit.tip. |

---

### 9. DayFeedScreen.gd / DayFeedPanel.gd
*File range audited: lines 1–58 (`DayFeedScreen.gd`), lines 1–1224 (`DayFeedPanel.gd`)*
*Note: `DayFeedScreen.gd` is an outer shell host containing 0 interactive buttons; all day feed briefing controls are rendered by `DayFeedPanel.gd`.*

| Line | Control / Purpose | Covered | Proposed Tip (<=12 words, starts with verb) |
| :--- | :--- | :---: | :--- |
| L305 / L479 | `Open` (Home pin buttons in `_pin`) | No | Open this room or station in the gym. |
| L576 | `EnterFightWeek` / `PlanWeek` (`_gold_button`) | No | Advance to fight week preparations or open athlete schedule. |
| L607 | `PlanWeek` (Empty next bout `_gold_button`) | No | View incoming fight offers or configure gym training. |
| L637 | `FirstJob` (`_gold_button` in `_first_job_card`) | No | Browse free-agent fighters or available coaching staff. |
| L728 | `FirstJob` (`_gold_button` in `_build_coach_at_door`) | No | Go to the indicated room to address urgent job. |
| L971 | `Open` (Row hit button in `_need_row`) | No | Address urgent issue or fighter request. |
| L1019 | `MediaAnswer_<id>` (`G156.icon_button`) | Yes | Backed by G156Wire.icon_button calling UIKit.tip. |
| L1089 | `OpenFighter` (Fighter card hit button) | No | Open fighter card to manage training and career. |
| L1163 | `GoCold` (`GO COLD` camp gate button) | Yes | Backed by UIKit.tip at L1169. |

---

### 10. InterviewPanel.gd
*File range audited: lines 1–300*

| Line | Control / Purpose | Covered | Proposed Tip (<=12 words, starts with verb) |
| :--- | :--- | :---: | :--- |
| L125 | `Decline` (`DECLINE` in fighter interview) | No | Decline signing this fighter candidate. |
| L130 | `Sign` (`SIGN - PICK 3 CARDS`) | Yes | Backed by CandidateCard.UIKit.tip at L158. |
| L137 | `Card_<id>` (Card selection chips) | Yes | Backed by CandidateCard.UIKit.tip at L144. |
| L174 | `Hire` (`HIRE - PICK ONE` in coach hire) | No | Hire selected coach with chosen coaching specialty. |
| L180 | `Tag_<tag>` (Coach tag option chips) | No | Select this coaching specialty for your gym. |
| L197 | `Decline` (`NOT NOW` in coach hire) | No | Pass on hiring this coach candidate. |

---

### 11. GymHallPanel.gd
*File range audited: lines 1–427*

| Line | Control / Purpose | Covered | Proposed Tip (<=12 words, starts with verb) |
| :--- | :--- | :---: | :--- |
| L81 | `EndDay` (`END DAY` button) | No | Simulate overnight progression and advance to next day. |

<!-- Dola (Cici app), collected verbatim by Claude S81 2026-09-26 via Tools/cici/cici.py read; sent with fight_week.png, weigh_in.png, road_sheet.jpg attached. -->
# D25_FRESH_EYES_FIGHT_WEEK

---

## 1. Screen purpose & primary action
| Screen | Purpose | One thing I’d click |
|---|---|---|
| **Fight Week** | Overview of the upcoming bout, weight status, and daily schedule leading to fight night | *To the weigh-in →* button |
| **Weigh-In** | Official weight verification screen showing if both fighters meet the division limit | *To fight night →* button |

---

## 2. Reading order & visibility
### Fight Week
1. **FIGHT WEEK** header → immediately know where I am
2. **VARGAS vs REYES** + records → who is fighting
3. **Weight Today 76.3 kg / Limit 72.6 kg / To Lose 3.7 kg** → most urgent number
4. Day-by-day row (Mon–Sat) → what happens each day
5. *What’s too small/missing:* "CAMP WEEKS: 0" and "The fight is this week – too late for a camp" are easy to overlook; no explicit explanation of what happens if weight isn’t made; no time-of-day or water-cut timeline.

### Weigh-In
1. **BRUNO VARGAS 76.3 kg / +3.7 kg over the limit** → stands out dramatically
2. **BASTIEN REYES 72.6 kg** → opponent made weight cleanly
3. **WEIGH-IN** header + 72.6 kg top limit → confirms requirement
4. *What’s too small/missing:* "not on the scale yet" phrasing is confusing—this *is* the weigh-in screen; no indicator of how much time is left or what steps I can take right now; "0% of the purse" is clear but the consequence "forfeits the contract fine; failed cut cancels bout" is buried in small text.

---

## 3. Confusions
- **Fight Week:** "DAY -6 TO BELL" → negative number reads like a bug; unclear what "Bell" means. "CAMP WEEKS / 0" → is this a counter, a status, or a mistake? "The fight is this week – too late for a camp" → why show a camp plan section if I can’t use it?
- **Weigh-In:** Bruno shows 76.3 kg *and* "not on the scale yet" → contradiction—either he’s weighed or not. "STEPS ON: Week 2, day 5" → fight is days away, why Week 2? "CUT: Standard" → what does standard mean vs other types? "same scale, same morning" → informational but feels out of place, not actionable.

---

## 4. Visual consistency vs road sheet
### Matches new style (brass/leather):
- `20_until_enter_fight_week.png` → Fight Week layout matches
- `28_bell.png` → Fight Night header/typography aligns
- `29_round1.png` → Fight Night UI theme consistent

### Looks older/different:
- `06_home.png` / `10_offers.png` / `13_entered.png` → lighter green/beige UI, different font, no gold accents—distinct visual family
- `15_camp_setup.png` / `19_camp_started.png` → darker boxed panels, less refined borders, mismatched button style
- `25_fight_week.png` / `26_fight_camp.png` → transitional; closer but still not matching the new brass/gold polish

---

## 5. Three concrete fixes (priority order)
1. **Fix contradictory weight text:** On Weigh-In, remove "not on the scale yet" if the number is already displayed; replace with a clear status like *"OVER LIMIT — Must cut 3.7 kg"* and make the consequence text prominent, not fine print.
2. **Clarify countdown & camp labels:** Change "DAY -6 TO BELL" to *"6 DAYS TO FIGHT NIGHT"*; replace "CAMP WEEKS / 0" + the dead camp-plan section with a concise banner: *"Fight this week — camp phase complete"* so the empty area doesn’t look like broken UI.
3. **Unify visual language across all screens:** Update home, schedule, and camp-setup screens to match the brass/gold header style, button shape, and dark background palette; align text sizing so critical warnings (weight miss) always use the same bold treatment across Fight Week → Weigh-In → Fight Night.

---




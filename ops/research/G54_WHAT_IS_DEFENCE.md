# G54 — WHAT IS DEFENCE, MEASURABLY?

Agent: Grok (Expert tier). Sent and answered 2026-09-11. 141 sources.
Captured from the Grok tab and committed by Claude — Grok has no checkout.
Research only: no code, no module, no test.

Commissioned by `TASK_G54.md` to inform **R102 channels 3 and 4** (the
defender's ability, and footwork that reads the other man). It does **not**
gate channel 1 — Hristovski's scaled distance already settled that shape.

---

## THE HEADLINE, AND IT IS A REFUSAL

> **Kiting is the same class of thing as pressure: not a published column.**
> Official systems record what happened to the incoming strike, never the
> defender's chosen action. **Dodge / slip / block / kite as agency is authored
> game feel.**

G50 refused *pressure* as a predictor of round scores. G54 was asked the
different question — is movement MEASURED AT ALL — and the answer is still no,
for a different reason: it was measured internally by one vendor in 2015 and
never published. **Channel 4 is therefore explicitly AUTHORED**, and must be
labelled that way in the code. That is a result, not a blocker.

---

## 1. IS DEFENCE COUNTED AT ALL? — NO OFFICIAL SYSTEM RECORDS A DEFENSIVE ACTION

Commissions do not. Olympic / World Boxing 10-point-must scores "quality blows
landed", domination and competitiveness; defence appears as a **judging
criterion** ("blocking, slipping, parrying and good footwork") but is **not a
logged event**.

### MMA — the UFC Stats / FightMetric columns that actually exist

- Significant strikes landed / attempted — **by target** (head, body, leg) and
  **by position** (distance, clinch, ground)
- Total strikes landed / attempted
- SLpM, SApM
- `Str. Acc.` = landed ÷ own significant attempts
- `Str. Def.` = opponent significant **misses** ÷ opponent significant attempts
- TD landed / attempted, TD Acc., TD Def. (same structure)

**No slip, block, parry, check, shoulder-roll or dodge column.** A miss and a
blocked shot are the same non-land.

### Boxing — the CompuBox columns that actually exist

- Jab thrown / landed
- Power thrown / landed
- Total thrown / landed
- Connect % = landed ÷ thrown (own punches)
- **OTC%** (opponent total connect %) and **OPC%** (opponent power connect %) —
  the defensive mirrors
- Opponent landed per round

CompuBox is **four operator keys**: jab connect, jab miss, power connect, power
miss. It explicitly does not code defensive manoeuvres. **A punch that hits the
guard is a miss if the operator does not call it landed.**

> **For R102: our six contact words are finer than any published system.**
> `blocked`, `absorbed` and `slipped` are all one bucket — "did not land" — in
> both official systems. That is not a reason to collapse them; it is a reason
> to grade the ENGINE on the coarse published quantity and treat the fine split
> as authored presentation.

---

## 2. "STRIKING DEFENCE %" — MOSTLY AN ARTEFACT

`Str. Def.` = 1 − opponent significant-strike accuracy. **The denominator is the
opponent's significant attempts, not the defender's actions.**

UFC does not adjust for opponent accuracy, stance, reach, target mix or
position mix. **Low incoming volume inflates the rate**; a ground-heavy opponent
changes the mix. Career `Str. Def.` is unadjusted and hides style change.

It is *somewhat* stable at the extremes — GSP 73.1%, Davis 72.3% on the Record
Book floor of 5 fights / 500 opponent significant attempts — but that is elite,
not typical, and it still says "opponents missed a lot against this man", not
"this man slips well". Same problem as CompuBox OTC%: Mayweather's opponents
landing ~17% of total punches is a real pattern across a sample, not a coded
defence.

> **Treat it as an opponent-accuracy inverse, not a fighter property you can
> port across matchups.** R102 must not model `Str. Def.` as a stat a fighter
> carries. It is an OUTPUT to grade against, never an input.

---

## 3. CAN A SLIP BE TOLD FROM A BLOCK?

**Official systems: NO.** Still one miss bucket, in both. Unchanged from G51.

**Research-grade notational datasets — boxing only, small samples, not
commercial products:**

- **Thomson & Lamb** amateur template: slip left / slip right, duck,
  block/parry lead, block/parry rear, foot defence — **coded separately**.
  Intra-observer agreement high, inter-observer weaker. A research instrument,
  not a stats product.
- **Davis et al.**, elite amateur: defence split **hand / trunk / foot**, at
  **~3.6 defensive movements per minute against ~21 punches per minute**. Not
  slip-vs-block at punch resolution.
- **2023 IBA women's finals** (12 bouts): shifting back, pivoting, ducking,
  trunk-twist slip, parrying coded separately. **Winners associated with
  pivoting and shifting back; parrying associated with losers.** n = 12.
- **ML sets** (BoxMAC, Olympic punch clips): labels include slip, block, duck,
  guard as video classes. Lab annotation, not a fight-stat pipeline.

**MMA: NOT PUBLISHED.** No research-grade public dataset codes avoided vs
blocked vs parried for UFC/MMA strikes. FightMetric classifies strike outcome as
landed or not, full stop.

**The distinction is a coaching one. It is not a column.**

> **The one number here worth having: ~3.6 defensive movements per minute
> against ~21 punches per minute** (Davis, elite amateur boxing). That is a
> defensive-action RATE with a named denominator, and it is the closest thing
> to a magnitude for channel 3.

---

## 4. FOOTWORK: IS MOVEMENT MEASURED?

**Published product columns: NO.** Distance covered, direction changes, time on
the back foot, circling vs squared — **NOT PUBLISHED** as recurring UFC Stats or
CompuBox fields.

What does exist:

- **FightMetric 2015 prototype heatmaps** — one MMA Fighting piece. Location was
  tracked *internally*; one round example gives Johnson 57% centre time vs
  Dariush 4%, advance 29% vs 14%, combined distance in a high-movement round
  3,036 ft against a low-movement complete round at 186 ft. **It never became a
  public per-fight column.** Same vendor G50 already found movement-for-score
  worthless. Measurement existed; publication did not.
- **MMA time-motion research** (Miarka et al.): time in keeping-distance /
  clinch / ground, high vs low intensity. Not metres, not heading, not a
  back-foot clock. Research coding, not a product.
- **Boxing GPS / sparring** (Thomson PhD): after bias correction, ~35.9 m·min⁻¹
  at ~0.6 m·s⁻¹ in open sparring. Not official-bout data; GPS is poor for the
  short steps boxing actually uses.
- **Amateur notational**: vertical hip movements ~56/min; foot-defence counts;
  winners in some samples use more ring movement after the 2013 rule change.
  Counts of actions, not tracking.

Broadcast "octagon control" remains a phrase. **Kiting has no published
quantity.**

---

## 5. DOES DEFENCE COST ANYTHING, MEASURABLY? — NO ISOLATED FIGURE

**No published joule-per-slip or VO₂-per-block for live opponents.** Energetics
papers treat the bout as one mix — punches plus defensive movements plus short
locomotion, ~70–86% aerobic in amateur boxing — and do not isolate slip vs block
vs retreat.

Closest fragments, all lab or style work rather than fight stats:

- Sparring / pads ~41–43 ml·kg⁻¹·min⁻¹ (~70% VO₂peak); bag work lower.
  Whole-session cost.
- **One 2025 style paper** (peek-a-boo vs Philly shell, simulated): peek-a-boo
  higher VO₂ (~52 vs ~49 ml·kg⁻¹·min⁻¹) and lactate (~13.5 vs ~11.6). Small, not
  official. **A weak signal that high-guard/close defence costs more than
  shell/roll — not a constant to ship.**
- Korean lab: weaving / ducking costed separately from punches in novices; skill
  lowered kcal/min. Not fight data.

> "Your engine already taxing movement and throwing is as grounded as the
> literature gets. **A separate defence stamina tax would be authored.**"

---

## 6. STYLE AND OUTCOME — RESEARCH, NOT THE SAYING

**Boxing amateur notational (measured):** winning tracks **punches landed and
accuracy**, not defensive frequency. Across several studies winners throw more
and land more, and **total defensive actions are similar or lower in winners**.
**Foot defence is more successful when used** — ~70% of foot defences
"successful" against staying in range for arm/trunk defence. After the 2013
change (no headgear, 10-point-must) movement and defence counts rose
league-wide and the winner/loser defence-count gap shrank.

**2023 IBA women's finals:** pivoting and shifting-back associated with winners,
parrying with losers. n = 12.

**Style labels** (out-boxer / swarmer / slugger) are a coaching taxonomy. One
secondary summary of title-fight win rates by BoxRec style tag — outfighters
54.2%, boxer-punchers 52.3%, infighters 51.6%, brawlers 48.5% — is small-gap and
classification-noisy, **not a finding to design around**. Fight length by style
is received wisdom; no clean published table survives opponent-quality control.

**MMA:** no official defensive-style field at all. Outcome research uses SLpM,
accuracy, vigour (attempts/sec) and TD rates — never high-guard / back-foot
tags.

**"Styles make fights" stays lore.**

---

## 7. THE ONE CHECK — USE THE OFFICIAL INVERSE-ACCURACY NUMBER

**Nothing finer exists.**

### MMA

| field | value |
|---|---|
| quantity | `Str. Def.` |
| source | UFC Stats / FightMetric |
| denominator | **opponent significant-strike attempts** |
| formula | opponent significant misses ÷ opponent significant attempts |
| typical roster band | **~50–62%** |
| Record Book elite | ~69–73% (GSP 73.1%), floor 5 fights / 500 opponent significant attempts |
| leaky tail | sub-50% |

**Pair it with SApM** so low-volume artefacts do not look elite: elite SApM is
often < 2.5; 4+ is a beating.

### Boxing

| field | value |
|---|---|
| quantity | 1 − OTC% (or raw OTC% / opponent landed per round) |
| source | CompuBox |
| denominator | **opponent total punches thrown** |
| league band | connect ~30–35% total, so "defence" ~**65–70%** non-connect |
| elite defenders | hold opponents near **16–22% OTC** (Lomachenko / Rigondeaux territory) |
| ordinary title level | mid-20s to low-30s OTC |

Power connect against (OPC%) runs **higher** than total.

> "If the defensive read cannot move `Str. Def.` / OTC% in-band against known
> opponent accuracy, it is not checking against a published quantity.
> **Slip-vs-block and kite-metres have no published quantity.**"

---

## WHAT THIS DOES TO R102

1. **Channel 3 has a grading target and channel 4 does not.** The defender's
   ability is graded on `Str. Def.` / OTC%. Footwork is graded on nothing, and
   must carry an AUTHORED label in the code.
2. **Our accuracy of 57.1% implies `Str. Def.` = 42.9% — BELOW the leaky tail.**
   The typical roster band is 50–62%. R102's miss channel must move accuracy
   down into roughly **38–50%** for MMA to reach it. Boxing is harder still:
   CompuBox league connect is **~30–35% of total punches thrown**.
3. **`Str. Def.` is an OUTPUT, never an input.** Do not give a fighter a
   "striking defence" stat. It is what the matchup produces.
4. **~3.6 defensive movements per minute against ~21 punches per minute** is the
   only defensive-action rate with a denominator. Our defender will act far more
   often than that if his roll fires on every incoming blow — name that gap
   rather than hiding it.
5. **Do not build a defence stamina tax and call it grounded.** It is authored.
6. **Do not model a defensive style as a win-rate modifier.** Measured research
   says winners land more; it does not say defensive fighters win.

## THE DENOMINATOR WARNING, RESTATED

Every band above carries its denominator in the same row. MMA `Str. Def.` is
over **significant** attempts; boxing OTC% is over **total** punches thrown.
They are not comparable and must never be averaged together.

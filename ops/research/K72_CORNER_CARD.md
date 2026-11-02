# K72_CORNER_CARD.md

**Job:** Between rounds, tell the manager what just happened and what to say — honestly, from quantities the engine already has.  
**Not the job:** Layout, pixels, consoling copy, or inventing stats. Unit = **sentences ≤60 characters**. Card ≤ **12 lines**.  
**Sibling:** K71 = post-fight WHY. This = between-round WHAT + instruction. G65 owns the box; this owns the words.

**Assumption (J36):** Reporting objects exist. A slot with no computed source is marked **NOT COMPUTED**, never invented.

---

## Labels

| Label | Meaning |
|---|---|
| **COMPUTED** | Named key exists today (J36 / scripts cited) |
| **NOT COMPUTED** | No key; do not write the bullet as if it existed |
| **INFERENCE** | Design rule for the card, not an engine claim |

Script names as on disk (J36 inventory): `RealtimeRoundStats`, `RoundScoring`, `FightStoppageRead`, `FightTrauma`, `CornerAdvice`, `FightPlans`.

---

## 1. THE SKELETON

Always present after a completed round, always in this order. Names are labels (words only).

| # | Slot | Always? | Filled from | Label |
|---|---|---|---|---|
| 1 | **ROUND** | Yes | Round index just scored + `RoundScoring.card` 10-point line (or even) | **COMPUTED** — `RoundScoring.card` / ten-point must |
| 2 | **WENT RIGHT** | Yes (1–2 bullets) | Best edges for *our* man from `RealtimeRoundStats` (zone lands, control, knockdowns) | **COMPUTED** — `lands` / zone hits / `control` / `knockdowns_round` |
| 3 | **WENT WRONG** | Yes (1–2 bullets) | Worst edges against us from same + trauma/stoppage if any | **COMPUTED** — same + `FightTrauma.worst` + `FightStoppageRead` fields when open |
| 4 | **MARK** | Only if trauma pips ≥ 1 | `FightTrauma.worst` → site, kind, pips → `FightTrauma.words` | **COMPUTED** — `FightTrauma` |
| 5 | **ASK** | Only if stoppage read open | `FightStoppageRead.may_ask` / `severity` / `reason` | **COMPUTED** — `FightStoppageRead` (READ; does not end fight — K64) |
| 6 | **SAY** | Yes | Instruction line: manager pick or `CornerAdvice.advise` default | **COMPUTED** as speech — see §3 for behaviour wiring |

### 1.1 ROUND — templates (≤60 chars)

Won 10–9:  
`R{n} 10-9 {Us}.`  

Won 10–8:  
`R{n} 10-8 {Us} — wide.`  

Lost 9–10:  
`R{n} 9-10 {Us}.`  

Lost 8–10:  
`R{n} 8-10 {Us} — wide.`  

Even (if `even_round` allowed):  
`R{n} 10-10. Even.`  

If per-judge triples not retained this minute:  
`R{n} — {Us} on the card.`  
(**NOT COMPUTED** as three-judge split between rounds unless `ScorecardRead` already holds the round — do not invent 29–28 mid-fight.)

### 1.2 What is never in the skeleton

Odds, attribute dumps, training grades, purse, fan noise, “stay focused,” “dig deep.” No pixels.

---

## 2. THE BULLET GRAMMAR

### 2.1 Template (locked)

> **{Actor}** {verb} {quantity} — {consequence}.

Rules:
- Actor = our man, the opponent, or “Both.”
- Verb from the allowed set below.
- Quantity = integer, ratio, or named event (rock, KD, cut pip).
- Consequence = what it means for the next round or the cards — not a pep talk.
- One mechanism per bullet. ≤60 characters including spaces.

### 2.2 Allowed verbs

`led` · `trailed` · `landed` · `ate` · `held` · `lost` · `dropped` · `rocked` · `faded` · `opened` · `missed`

### 2.3 Five bullets — round we **won**

Fighters: **Rios** (ours) vs **Kane**. Char count in `(n)`.

1. `Rios led 18-11 head — he owned the range.` (46)  
2. `Rios held 0:42 control — Kane’s entries died.` (47)  
3. `Kane ate 9 body — his exits got shorter.` (42)  
4. `Rios rocked him once — judges saw the 10-8 shape.` (51)  
5. `Rios landed 24-14 overall — clean round.` (42)

Sources: **COMPUTED** `RealtimeRoundStats` zone/head/body lands, `control`, `knockdowns_round` / shock flags; margin via **COMPUTED** `RoundScoring`.

### 2.4 Five bullets — round we **lost** (no consolation)

1. `Rios trailed 9-17 head — Kane’s jab ruled.` (45)  
2. `Rios missed 0/3 takedowns — no control banked.` (48)  
3. `Rios ate 2 rocks — chin is on the card now.` (46)  
4. `Kane held 1:05 control — Rios stuck on the fence.` (51)  
5. `Rios faded late — 4 lands in the last minute.` (47)

Same sources. Losing bullets name **our failure** with a number. Forbidden: “tough round,” “stay in it,” “you’re fine.”

### 2.5 Empty-round / uneventful fill

If differentials are tiny (INFERENCE threshold: sig-strike gap ≤3 and no KD/rock/control ≥20s and no trauma):

WENT RIGHT: `Even work — no edge bigger than three.`  
WENT WRONG: `Nothing decisive — don’t invent a story.`  

Still better than consoling fiction.

---

## 3. THE INSTRUCTION LINE (SAY)

### 3.1 Two layers (do not confuse them)

| Layer | What it is | Behaviour next round? |
|---|---|---|
| **A. `CornerAdvice.focus`** | `breathe` / `defence` / `close_it` / `body` / `output` (+ `cut_work`) | **Speech only today.** `FightRealtime._corner_read` stores `line`/`focus`; it does **not** push focus into the action chooser. **COMPUTED** as utterance; **NOT COMPUTED** as fight-behaviour change. |
| **B. `FightPlans.PACES`** | `cautious` / `balanced` / `aggressive` (+ emphasis / range calls in beat options) | **Wired.** Pace changes urgency/stamina cost and option weighting (`FightPlans`, `FightBeatAdapter`, move costs). **COMPUTED** consequence. |

K70’s dishonesty trap: a corner that says “work the body” while nothing changes. **Today that trap is live for Layer A.** Spec below still names the honest sentence *and* the quantity that justifies it; it marks consequence status plainly so a build task can wire A→B without inventing new advice.

### 3.2 Layer A — `CornerAdvice` focuses (speech; precedence already in script)

| Focus | When (COMPUTED gates) | Corner says (≤60) | Qty that justified it | Next-round behaviour |
|---|---|---|---|---|
| `breathe` | `cardio_zone==redline` OR stamina ≤25 | `Breathe. Hands up. Box off the back foot.` (45) | zone / stamina | **NOT COMPUTED** unless manager also sets `cautious` |
| `defence` | head_condition ≤28 | `Chin in, hands high — head is in danger.` (46) | head_condition | **NOT COMPUTED** as auto-defence |
| `close_it` | losing_on_cards AND last round | `Last round. Let both hands go.` (33) | cards behind | **NOT COMPUTED** unless `aggressive` set |
| `body` | body ≤40 AND body < head | `Go to the body — his tank is the soft end.` (48) | body_condition | **NOT COMPUTED** as body-target bias |
| `output` | default | `Keep the jab long — nothing forces a change.` (49) | none of the above | **NOT COMPUTED** |
| + `cut_work` | worst trauma pips ≥2 | Append / swap: `Stay long — cut work between rounds.` (45) | `FightTrauma` pips | Cutman is stool work (**COMPUTED** trauma); fighting long is still speech-only unless pace/range set |

Existing `CornerAdvice._line_for` strings that console without quantity (`Keep working. You are in this.`) **fail this card** — replace with the rows above when the card ships.

### 3.3 Layer B — pace verbs the manager can choose (wired)

| Pace | Corner says (≤60) | Justify with | Consequence |
|---|---|---|---|
| `cautious` | `Slow the pace — tank is paying interest.` (45) | stamina / redline / after rocks | **COMPUTED** — lower urgency, conserve stamina |
| `balanced` | `Hold centre — no change of gear.` (36) | default / even round | **COMPUTED** — default weighting |
| `aggressive` | `Push the pace — you need this round.` (42) | behind on cards / close_it | **COMPUTED** — higher urgency, higher cost |

Emphasis / range options (when present on beat options): `focus_striking`, `focus_grappling`, stay_long / get_inside — **COMPUTED** as instruction fields in plan/beat paths; only print a SAY line if that option is actually selectable this stool. If not selectable: **NOT COMPUTED** for this card instance.

### 3.4 One rule for SAY

SAY must either:
1. Match a **wired** pace/emphasis the manager just set, or  
2. Be marked as **advice-only** (Layer A) in the data (`consequence: "speech"`), never implied as a sim change.

INFERENCE for builders: cheapest honesty fix is map `breathe`→`cautious`, `close_it`→`aggressive`, `defence`→`cautious`+stay_long when those options exist — that is a **wire**, not new simulation math.

---

## 4. THE PRIORITY STACK (60 seconds / ≤12 lines)

Read order = write order. Drop from the bottom when the round is quiet or the budget is tight.

| Priority | Slot | Drop when? |
|---|---|---|
| **Never drop** | ROUND | — |
| **Never drop** | SAY | — |
| **Never drop if open** | ASK | Only absent when `may_ask` false |
| **Never drop if pips ≥ 2** | MARK | Drop only if pips == 0 |
| **Drop 2nd first** | WENT RIGHT (keep 1) | Uneventful: keep one even-work line |
| **Drop 2nd first** | WENT WRONG (keep 1) | Uneventful: keep one “nothing decisive” |
| **Drop entirely** | Second RIGHT/WRONG | First thing cut when quiet |
| **Drop entirely** | Flavour / second trauma site | Never promote over ASK |

Uneventful minimum (still honest) = **4 lines**: ROUND + 1 RIGHT + 1 WRONG + SAY.  
Danger open = ASK never yields to colour commentary.

---

## 5. THE DANGER CARD

When `FightStoppageRead.may_ask` is true for **our** man (severity ≥ ASK_THRESHOLD 0.45) between rounds, replace the normal colour of WENT RIGHT/WRONG with this stack. ROUND and SAY remain.

### 5.1 Order (fixed)

1. ROUND  
2. **ASK** — towel language (below)  
3. WENT WRONG — the stoppage evidence (`reason` + counts)  
4. MARK — if trauma pips ≥ 1  
5. WENT RIGHT — at most one line (what still works), never optimism  
6. SAY — must be `breathe` or `defence` class; never `close_it` / `aggressive` while ASK is open unless the manager overrides

### 5.2 The towel sentence (does not decide)

Pick one; all ≤60:

- `Towel is on the table — your call.` (38)  
- `He is taking it unanswered — consider the towel.` (50)  
- `Two shocks in a minute — towel is available.` (47)  

Fill the middle with **COMPUTED** `FightStoppageRead.reason` text when non-empty (e.g. `two shocks in the last minute`). The card **puts the towel on the table**; it never throws it. Stoppage authority remains referee/physician per `CornerRulesRead` (**COMPUTED** authored rule).

### 5.3 Evidence bullets under ASK (examples)

- `Kane landed unanswered — 6 more than Rios.` (46) — `unanswered`  
- `Rios took two shocks in sixty seconds.` (41) — `shocks_in_window`  
- `Head is at 24 — amplifier is live.` (36) — `head_condition`  
- `One KD this window — still standing.` (38) — `knockdowns_in_window`

No “he’s a warrior.” No auto-stop.

---

## 6. WORKED FULL CARDS (with counts)

### 6.1 Quiet won round (4 lines — minimum honest)

```
R2 10-9 Rios.
Rios led 16-12 — small but clean.
Kane had no KD, no rock.
SAY: Hold centre — no change of gear.
```
Chars/line: 12 / 36 / 28 / 40. Lines: 4.

### 6.2 Lost round (honest, no hug)

```
R3 9-10 Rios.
Rios trailed 8-19 head — jab lost the round.
Rios missed 0/2 TDs — wrestling empty.
Rios ate one rock at 2:14.
SAY: Slow the pace — tank is paying interest.
```
Chars: 12 / 48 / 42 / 28 / 45. Lines: 5.

### 6.3 Danger card

```
R4 8-10 Rios — wide.
ASK: Towel is on the table — your call.
Rios took two shocks in sixty seconds.
Unanswered: Kane +5 in the window.
MARK: CUT · right_brow · 2.
SAY: Chin in, hands high — head is in danger.
```
Chars: 22 / 38 / 41 / 34 / 28 / 46. Lines: 6.

---

## 7. CHARACTER BUDGET (contract with G65)

| Rule | Cap |
|---|---|
| Any single sentence | **60 characters** |
| Whole card | **12 lines** |
| Prefer | **≤8 lines** when ASK closed |
| ROUND + SAY | always present |
| Digits | use digits (`18-11`), not words, for counts |

If G65’s box is tighter, drop in §4 order — never truncate mid-quantity (don’t show `18-` ).

---

## 8. ENGINE RETENTION (between-round card)

Must still be available at the stool (end of round N):

| Quantity | Key / module | Need |
|---|---|---|
| Round score 10-x | `RoundScoring.card` | ROUND |
| Sig / zone lands this round | `RealtimeRoundStats` head/body/legs (+ hand/foot splits) | RIGHT/WRONG |
| Control seconds this round | `RealtimeRoundStats.control` | RIGHT/WRONG |
| KD / rock this round | `knockdowns_round` / shock flags | RIGHT/WRONG |
| TD attempts/lands this round | `takedowns_round` | WRONG empty wrestling |
| Worst trauma | `FightTrauma.worst` + words | MARK |
| Stoppage fold | `FightStoppageRead.fold` / `may_ask` / `reason` | ASK |
| Stamina, head/body bars, cardio zone | fighter body_condition + Cardio | SAY gates |
| Behind on cards? | scoreboard aggregate | `close_it` |
| Round index / rounds total | fight state | last-round gate |
| Current pace options | `FightPlans.PACES` (+ beat options) | SAY wired verbs |

**NOT COMPUTED for stool (do not print as fact):** three-judge mid-fight split if not stored; “momentum” meters; opponent’s private plan; any probability.

---

## 9. THE ONE JUDGEMENT — three-line card

**Minimum honest card after any round:**

```
R{n} {score} {Us}.
{One quantity bullet — the largest edge, either way}.
SAY: {wired pace line OR advice-only line tagged speech}.
```

### Can three lines stay honest on a **lost** round?

**Yes**, if the middle line is the loss edge with a number:

```
R3 9-10 Rios.
Rios trailed 8-19 head — jab lost the round.
SAY: Slow the pace — tank is paying interest.
```

**No**, if you need both “what we failed” and “towel/ASK” or a mark — then use **four lines**:

```
R4 8-10 Rios — wide.
ASK: Towel is on the table — your call.
Rios took two shocks in sixty seconds.
SAY: Chin in, hands high — head is in danger.
```

INFERENCE: three lines are enough for a normal lost round; four are the floor once ASK or MARK (pips ≥2) is live. Consolation is never the fourth line.

---

## 10. Acceptance check

Ships only if:

1. Skeleton order matches §1.  
2. Every RIGHT/WRONG bullet matches `{Actor} {verb} {qty} — {consequence}` and ≤60 chars.  
3. No consoling zero-quantity lines.  
4. ASK present iff `may_ask`; towel sentence never auto-stops.  
5. SAY marks speech-only vs wired pace correctly (§3).  
6. Card ≤12 lines; drop order follows §4.  
7. No pixels, no probabilities, no invented keys.

---

## Sources (this pass)

1. J36_WHAT_THE_ENGINE_KNOWS.md — inventory: RealtimeRoundStats, RoundScoring, FightStoppageRead, FightTrauma, PostFightRead.  
2. `RealtimeRoundStats.gd` — zone lands, control, KD, TD.  
3. `RoundScoring.gd` — ten-point must, margin_wide, even_round, damage/control.  
4. `FightStoppageRead.gd` — severity, may_ask, reason, unanswered/shocks/KD window.  
5. `FightTrauma.gd` — sites, cut/swelling pips, words.  
6. `CornerAdvice.gd` — focus precedence breathe→defence→close_it→body→output.  
7. `FightRealtime.gd` `_corner_read` — stores advice as utterance; no focus→chooser wire.  
8. `FightPlans.gd` PACES — cautious/balanced/aggressive (wired).  
9. K70 / K71 — honesty = explicability; Causation Card sibling.  
10. K64 — may_ask is READ without fight-ending consumer.

---

**K72 complete.** Between-round honesty is ROUND + quantity bullets + a SAY that does not lie about wiring. The towel is offered, never thrown.

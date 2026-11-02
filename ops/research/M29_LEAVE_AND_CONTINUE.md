# M29 — LEAVE AND CONTINUE

Maria Art Director · 2026-09-22 · **LOOK only** (no `.gd` / `.tscn` / `HANDOFF.md`)

Boards the two moments the player actually loses: **fight over → how back to THE DAY**, and **two Continues on one screen**. Gym Floor keep direction from M28 pass 3 **waits**. Blood §4 **ACCEPTED (fallback)** 2026-09-22 — doctor/stoppage only; not boarded this pass.

| Field | Value |
|---|---|
| Pass | **M29** |
| Prior | M28 pass 3 (self-attack + Kalli FLOW convergence); `FLOW_PASS1_SCREEN_MAP.md`; `FLOW_PASS2_ROUTE_WORDS.md` |
| Honesty | `COMPUTED` = Kalli Beast-verified / quoted. `NOT COMPUTED` where wiring or live chrome reachability unclear. `NEEDS WORDS` = Kalli owns copy. |
| Out of scope | Implementation, HANDOFF edit, doctor/stoppage blood board, Gym Floor landscape spend |

---

## Three lines first

1. **Leave:** Empty-card result must put the eye on **one** exit control in a reserved **eye-slot** (`nav_fight_out`). It must not wear the same weight family as card Continues. Label = **`NEEDS WORDS`** on the board (Kalli proposed `BACK TO THE DAY ▸` in FLOW pass 2 — **DEPENDS ON KALLI**; Maria does not freeze her string).
2. **Continue:** Art **one** Shell Continue (day clock). A weekly jump, if it still exists until week-stop merges, must use a **different label and shape** — never a second button saying CONTINUE.
3. **Reject arms:** Same-word Continues at equal weight (leave), and “two Continues, prettier” (chrome) are both **WRONG**.

**Correction 2026-09-22 (late Beast/GH read):** Body primary is left-foot GO Continue (not bottom-right). Chrome has a separate slate **WAY OUT**. No rematch/share/TALLY on `FightResultPanel`. Spec + leave keep board updated.

---

## Sources (COMPUTED this pass)

From Kalli `FLOW_PASS2_ROUTE_WORDS.md` (Beast-read):

| Fact | Status |
|---|---|
| Result labels today: `CONTINUE TO CARD ▸` / `CONTINUE TO NEXT CARD ▸` / `CONTINUE TO OFFICE ▸` | COMPUTED |
| Empty-card branch routes to `office_menu` | COMPUTED — wrong land |
| `SetpieceRoot.leave()` fallback `back_or("calendar")` → SCHEDULE | COMPUTED — wrong land |
| Kalli words decision empty-card: `BACK TO THE DAY ▸` → `day_feed` | COMPUTED (words); wire **out of Maria scope** |
| Shell Continue: `CONTINUE →` + subcopy `N MUST ANSWER FIRST` / `ALL CLEAR · NEXT DAY` | COMPUTED |
| ManagementChrome header: `CONTINUE ▸` (week / schedule walk) | COMPUTED — dual Continue |
| Keep SceneRouter + ShellChrome + hosted panels; kill player DIRECT_SCENES DayFeed remount | COMPUTED (Kalli) |
| Dual Continue merge blocked until week-stop lives on one Continue | COMPUTED (Kalli) |
| Live reachability of ManagementChrome header in normal boot | **NOT COMPUTED** (no play trace) |
| Body primary Continue layout | COMPUTED — left foot `Vector2(VERDICT_X=96, 776)`, size `460×56`, `UIKit.button(..., "go")` — **THE ONE GREEN**; does **not** call `SetpieceRoot.leave()` / does **not** advance day |
| Chrome leave | COMPUTED — `UIKit.way_out_strip` label **`WAY OUT`**, top-left band, slate (not GO); `leave()` → `back_or("calendar")` (SCHEDULE) today |
| Other body controls on FightResultPanel | COMPUTED — Verdict, Description, DecisionStamp, THE CARDS, Ledger, optional BeltNotOnTheLine / RangeCard / BroadcastCard / Aftermath / Silhouette, Continue. **No** rematch / share / TALLY |
| Empty-card Continue label literals | COMPUTED — `CONTINUE TO OFFICE  ▸` / `CONTINUE TO CARD  ▸` / `CONTINUE TO NEXT CARD  ▸` (two spaces before ▸) |

Prior Maria: M28 `nav_fight_out` = eye on leave CTA; do not art two clocks; Gym Floor waits.

---

## A. FIGHT RESULT — LEAVE CTA (KEEP)

**Board:** `M29_board_leave_keep.png`

### Job

After RESULT (and optional crowning), the player who is done with tonight’s card must find **the one way back to THE DAY** without reading route ids.

### Look rules

| Rule | Spec |
|---|---|
| Eye-slot | The body **ONE GREEN** Continue — COMPUTED seat left foot (`VERDICT_X=96`, y `776`, `460×56`). That is the reserved eye-slot for `nav_fight_out`. Do not invent a second primary bottom-right. |
| Weight | Empty-card case: same GO control, destination must mean THE DAY (words/wire = Kalli). Card-still-working cases keep the same seat/weight as destination Continues — honesty is in the **label + route**, not a second button. |
| Colour | Kit `GO` `#22c55e` once on that body Continue. Gold stays on verdict/winner language only. Never gold the exit. |
| Label | Board paints **`NEEDS WORDS`** on the GO seat for empty-card. Kalli proposed `BACK TO THE DAY ▸` — DEPENDS ON KALLI; Maria does not freeze the string. |
| Chrome **WAY OUT** | Stays slate / secondary (COMPUTED). Today it pops to SCHEDULE — wrong land. Look: do **not** promote WAY OUT to GO twin; do **not** bury THE DAY return only there. After wire fix, WAY OUT should agree with day_feed or stay a quiet back — **NOT COMPUTED** final chrome words. |
| Secondaries | No rematch / share / TALLY on this panel (COMPUTED). Do not board invented secondaries. Scorecard content is **on** the body (THE CARDS), not a rival CTA. |
| Card-still-working | Same GO seat; COMPUTED labels `CONTINUE TO CARD  ▸` / `CONTINUE TO NEXT CARD  ▸` toward events. |
| Never | Hue-only twin; continuous throb; three equal Continues; promoting chrome WAY OUT as a second green; settings-modal dissolve for fight-out. |

### States (few)

1. **Card still working** — mid-weight destination Continue(s) toward card/events.  
2. **Empty card / leave** — eye-slot primary exit to THE DAY (words + wire = Kalli / implementer).  
3. **Pending crowning** — same Continue path into crowning (Kalli: keep routing). Look: do not invent a fourth chrome.

---

## B. FIGHT RESULT — LEAVE CTA (REJECT)

**Board:** `M29_board_leave_reject.png`

| Wrong | Why |
|---|---|
| Three identical Continues (CARD / NEXT CARD / OFFICE) same size/weight | Same word, no eye-slot — player cannot tell which returns to the career day |
| Gold on all three | Gold ×1 rule broken (verdict only) |
| Continuous glow / throb | Forbidden |
| Tiny buried `leave()` / only chrome WAY OUT knows the exit | Discoverability fail — body must carry THE DAY return |
| Promoting chrome WAY OUT to a second green twin | Two primaries; fights “ONE GREEN” |
| Hue-only “leave is greener” | Never hue-only |

---

## C. ONE CONTINUE (KEEP)

**Board:** `M29_board_one_continue_keep.png`

### Job

Career shell shows **one** time-advance control the player can trust.

### Look rules

| Control | Look |
|---|---|
| **Shell Continue** (keep) | Single `CONTINUE →` (COMPUTED label family) + muted subcopy (`ALL CLEAR · NEXT DAY` / gate copy). GO fill once. Callout: day clock → `GameState.advance_day`. |
| **Week jump** (until merge) | **Different label · different shape** (pill / chevron strip / schedule chip). Muted panel, not GO. Board label = **`NEEDS WORDS`**. Never wears the word CONTINUE. |
| ManagementChrome header `CONTINUE ▸` | **Do not art.** Kalli: dies for players once week-stop lives on one Continue; until then dual is a **defect**, not a second premium skin. |
| Dual map | One shell language (SceneRouter + ShellChrome). Do not paint DIRECT_SCENES remount as alternate chrome. |

Reachability of the dual header in normal boot remains **NOT COMPUTED** — look rule still stands: if both appear, presentation treats that as a bug, not a composition to polish.

---

## D. TWO CONTINUES (REJECT)

**Board:** `M29_board_two_continues_reject.png`

**Reject arm title:** “Two Continues, prettier — still wrong.”

| Wrong | Why |
|---|---|
| Header `CONTINUE ▸` + footer `CONTINUE →` both visible | Same word, two clocks (day vs week) |
| Green vs gold as the only difference | Hue/skin only |
| Framing dual chrome as “premium” | Arts the defect |
| Matching arrow glyphs with different meanings | Player reads twin siblings |

---

## E. TOKEN / WEIGHT MAP (Cage Desk)

| Role | Look | Tokens |
|---|---|---|
| Ground / panel / hairline | M22 desk | `M22_GROUND` / `M22_PANEL` / `M22_HAIRLINE` (or kit GROUND / PANEL / LINE) |
| Verdict word | Gold ×1 | `GOLD` / `M22_VERDICT` family — stamp only |
| Empty-card leave (eye-slot) | GO once | kit `GO` / positive — **not** gold |
| Shell Continue | GO once on career shell | same GO — **one** time control |
| Week jump (if present) | Muted chip / different shape | `M22_PANEL` / secondary text — **no** CONTINUE label |
| Secondary result actions | Ghost hairline | `M22_TEXT_SECONDARY` |

Transition weights (from M28, unchanged): `nav_fight_out` lands eye on leave; `nav_week` = short dim on the **one** Continue — never two.

---

## F. ARGUE AGAINST YOURSELF — leave CTA needs no art

**Strongest case that boarding leave is art looking for a job:**

1. **Kalli already solved it in words.** FLOW pass 2 names the empty-card string (`BACK TO THE DAY ▸`) and the route (`day_feed`), and flags the Setpiece leave fallback. Placement is a one-line footer primary in existing FightResultPanel chrome. That is wiring + copy, not a style pass.  
2. **The hole is semantic, not visual.** Players fail because the button says OFFICE / routes to SCHEDULE — not because the button is the wrong height. Fixing the string and the push target removes the bug even if the button stays mid-weight beside card Continues.  
3. **Eye-slot rhetoric can inflate spend.** Reserving a taller band, annotations, and a reject board risks treating a labels bug like a brand system. M28 self-attack already warned against expense without new verbs; leave art is the same trap one notch cheaper.  
4. **Card Continues already teach “Continue means go somewhere.”** Distinguishing leave by weight may be unnecessary once the destination is honest — the word carries the job.

**Where I land after attacking it:**  
Kalli owns the **words and route**. Maria still owes the **LOOK rule**: empty-card leave must not share equal weight with card Continues, must not spend gold, must not throb, and must occupy a single obvious primary slot so `nav_fight_out` has somewhere to point. That is a thin presentation contract, not a landscape. **Board the slot; do not invent the sentence.** If implementers only swap string + route and keep equal-weight triple Continues, the semantic fix still helps — but the reject board stays true: same-word same-weight remains a presentation defect.

---

## G. BLOOD

**ACCEPTED (fallback)** — operator 2026-09-22. Blood only at doctor/stoppage class; no per-punch blood; readout > meat; §5 free-camera binds the stoppage cue. **Not boarded this pass** (M29 leave/Continue). Next fight-surface pass: one KEEP+REJECT blood board only.

---

## WHAT IS STILL WRONG

1. Leave board label is **`NEEDS WORDS`** — Kalli’s proposed string is FLOW-side; wire not landed.  
2. First keep board invented SCORECARD/REMATCH and sat the eye-slot bottom-right — **corrected** this pass to COMPUTED left-foot GO + chrome WAY OUT.  
3. Dual Continue live reachability still **NOT COMPUTED**.  
4. Week-jump replacement label/shape = **`NEEDS WORDS`** until Kalli/product names the non-CONTINUE control.  
5. Week-stop merge into one Continue still blocked (Kalli) — look cannot delete week behaviour, only refuse to twin the label.  
6. Gym Floor establishing keep waits (operator).  
7. Blood **ACCEPTED (fallback)** — doctor/stoppage board deferred to next fight-surface pass.  
8. No live fight-result capture for side-by-side with boards.

---

## Files to land (name every one)

Under `_maria_delivery/` and `research/`:

- `M29_LEAVE_AND_CONTINUE.md`
- `CLAUDE_LAND_NOTE_M29.md`
- `M29_board_leave_keep.png`
- `M29_board_leave_reject.png`
- `M29_board_one_continue_keep.png`
- `M29_board_two_continues_reject.png`

Claude writes HANDOFF; Maria does not edit `HANDOFF.md`.

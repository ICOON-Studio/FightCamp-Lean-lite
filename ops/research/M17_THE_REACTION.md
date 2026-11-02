# M17 — THE REACTION (spend M16 freed slots)

Maria Art Director · 2026-09-10 · art only (no `.gd` / `.tscn` / `HANDOFF.md` / assets/data)

Cage Desk continuity. **Spend the slots M16 freed** (jab-as-duplicate / optional skip of second straight) on **reaction clips** that out-read the thrower’s arm at M14 HOME. Grounded in measured presentation shares + J17 reaction craft (far fewer reaction SKUs than strikes; head+body enough to read; block/slip not purchased). M15 owns knockdown ceremony — this pack does **not** buy KD.

## DECISIONS

1. **BUY COUNT: 2 core reaction clips** — `react_head_clean`, `react_body_clean`. Covers measured honest space ≈ clean×(head+torso) ≈ **92.7% × (65.3%+28.2%) ≈ 86.6%** of presented contacts. Ranked candidates: (1) head_clean (2) body_clean (3) glancing-as-scale on those two — **not** a third SKU (4) optional later `react_*_hurt_stumble` only if badly-hurt needs a different silhouette. **Reject 4-way clean/glancing × region matrix** unless boards prove glance has a distinct HOME path (they do not — see Q5).
2. **WHAT REACTION MUST SHOW AT HOME (receiving body):** **Head shot** = lateral/rear **head snap + neck + upper-torso follow** (guard break optional). **Body shot** = **torso fold / crunch + hip sink** (arms drop protectively). Surviving cues from M16: whole-body silhouette path of the *receiver*, not face/glove micro. Faces deferred.
3. **Q3 one-liner:** **partial YES** — at HOME, reaction can carry punch **family** (hook lateral turn/whip vs straight linear snap-back vs uppercut chin-lift) enough to justify spending the freed slot here rather than a 4th punch; **NOT** enough for jab≠cross. Type feeling lives **partly in reaction**; thrower arc still primary for hooks/uppercut. *(Invented visual judgment.)*
4. **SEVERITY:** cheapest = **one clip per region + amplitude/speed scale + procedural lean** tied to force/shock. Do **not** buy 3× severity tiers × region. Optional second silhouette (badly-hurt stumble) ranked as **later buy #4**, not core.
5. **Q5 one-liner:** glancing @ **5.6% measured** → **same clip, smaller / lower amplitude / shorter** — **not** a third purchase unless invent proves distinct silhouette path at 10 m (boards: partial turn vs full snap is amplitude, not a new SKU).
6. **NOT BUY:** `react_arm`, `react_leg` (boxing — engine ~3.2% legs is picker defect, not art), blocked (0.2%), slipped (0.1%), miss theatrical, face-close reactions, per-punch-type×region matrix, clean+glance as 4 SKUs if scale works, twelve severity grades, KD (M15 owns).
7. **OPEN / INVENTED:** board silhouettes = art invent under M14 geometry. Type-in-reaction (hook/straight/upper) = **invented** HOME judgment. Glancing-as-scale = invent stress-test of held lean (boards agree — no distinct postage-stamp path). Severity-as-scale = craft lean compatible with J17/Sherr blend language — not a mocap census.
8. Art only — no animation graph, no enums, no `.gd`.

---

## Boards

| Board | Answers |
| --- | --- |
| `m17_01_space.png` | Honest reaction space from measured shares |
| `m17_02_head_vs_body.png` | HOME read of receiving body (M16 cues) |
| `m17_03_clean_grid.png` | Clean head / clean body mid-impact |
| `m17_04_type_in_reaction.png` | Does hook/straight/upper show in reaction |
| `m17_05_severity.png` | Levels cheapest path |
| `m17_06_glancing.png` | Own clip vs smaller clean |
| `m17_07_buy_rank.png` | Ranked buy list |
| `m17_08_rejects.png` | Must not buy |
| `m17_09_verdict.png` | Typeable buy count + Q3/Q5 one-liners |

---

## §1 — How many reaction clips, which? (Q1)

**Measured shares (cite as measured):**

| Axis | Share |
| --- | --- |
| Regions presented | head_neck **65.3%**, torso_core **28.2%**, legs **3.2%**, arms **0%** |
| Contacts | clean **92.7%**, glancing **5.6%**, absorbed 0.8%, blocked **0.2%**, slipped 0.1%, missed 0.5% |

**Honest reaction space:** **head or torso × clean or glancing**, plus KD (already M15). Do **not** board blocked/slipped as buys. Do **not** board leg reaction for boxing.

### Candidate ranking (2 vs 4 clean/glancing split)

| Rank | Candidate | Coverage logic | Buy? |
| --- | --- | --- | --- |
| **1** | `react_head_clean` | ~65% region × ~93% clean | **YES — core** |
| **2** | `react_body_clean` | ~28% region × ~93% clean | **YES — core** |
| **3** | glancing playback on #1/#2 | 5.6% contact — amplitude/duration scale | **Playback, not SKU** |
| **4** | `react_*_hurt_stumble` | Badly-hurt different silhouette | **Later optional** |
| — | clean_head + glance_head + clean_body + glance_body (4) | Same 4 cells as 2 clips × scale | **REJECT as SKUs** |
| — | react_leg / react_arm / blocked / slipped | legs ~3% defect; arms 0%; block/slip ~0.3% | **REJECT** |

**Verdict:** buy **2**. The 4-way split wastes two SKUs for a contact class that is 5.6% and reads as smaller clean at HOME.

Boards: `m17_01_space.png`, `m17_07_buy_rank.png`

---

## §2 — What must reaction SHOW at HOME? (Q2)

Receiving body at postage-stamp scale (M16 surviving cues: silhouette path + reaction mass; face/glove dead).

| Shot | Must show (HOME) | Must not rely on |
| --- | --- | --- |
| **Head** | Head snap / whip (lateral or rear), neck, upper-torso follow; optional guard break | Face grimace, eye, cheek deformation |
| **Body** | Torso fold / crunch, hip sink, protective arm drop | Abs detail, belt micro, face looking down |

**Mid-impact invent (boards):** clean head = receiver mass rotates off the line; clean body = receiver compresses vertically / folds forward. Both readable at 9–11 m OVER ropes.

Board: `m17_02_head_vs_body.png`, `m17_03_clean_grid.png`

---

## §3 — Does reaction carry punch TYPE? (Q3) — load-bearing

| Punch family | Reaction tell at HOME | Enough to buy type-feeling in reaction? |
| --- | --- | --- |
| **Hook** | Lateral turn / whip of head-torso off the arc | **YES — partial** |
| **Straight** (jab/cross collapsed) | Linear snap-back / recoil on the punch axis | **YES — family** (not jab≠cross) |
| **Uppercut** | Chin-up / lift / vertical open | **YES — partial** |
| **Jab ≠ cross** | — | **NO** — reaction cannot split what thrower arm already collapses |

**DECISION 3 / Q3 one-liner:** partial YES at HOME for hook vs straight vs uppercut family tells in the receiver; type lives **partly** in reaction (enough to spend freed slot here); jab≠cross stays closed (M16 collapse holds).

*Mark: **invented** visual judgment under M14 HOME — not mocap vendor truth.*

Board: `m17_04_type_in_reaction.png`

---

## §4 — Severity levels (Q4)

| Approach | Cost | Verdict |
| --- | --- | --- |
| Buy took-well / hurt / badly-hurt × head × body (6) | High SKU | **REJECT** |
| Buy light + heavy × region (4) | Medium | Prefer scale first |
| **One clip × amplitude/speed + procedural lean** | Lowest | **HOLD — cheapest** |
| Second silhouette only for stumble/badly-hurt | +1 later | Rank #4 optional |

Compatible with J17 / Sherr craft: few reactions, many looks via blend / mask / physics. Amplitude tied to force/shock; procedural lean sells “took well → hurt” without new purchases.

Board: `m17_05_severity.png`

---

## §5 — glancing @ 5.6% (Q5)

| Option | At HOME | Verdict |
| --- | --- | --- |
| Own `react_*_glance` SKUs | Partial turn vs full snap | **Looks like amplitude** at stamp scale — not a new silhouette family |
| **Same clean clip, smaller / lower amp / shorter** | Covers 5.6% | **HOLD — cheapest** |
| Ignore glancing | Misses rare but visible grazes | Worse than scale |

**Q5 one-liner:** glancing = **playback scale on the clean clip**, not a third purchase, unless invent later proves a distinct 10 m path (current boards: no).

Board: `m17_06_glancing.png`

---

## §6 — What we must NOT buy (Q6)

Waste that looks reasonable:

- `react_arm` — arms **0%** measured presented
- `react_leg` (boxing) — ~3.2% legs = engine/picker defect being fixed — **not art**
- Blocked / slipped clips — **0.2% / 0.1%**; J17: not purchased roles
- Miss theatrical reactions — miss is 0.5%; don’t dramatize absence
- Face-close / CLAIM-TIGHT reaction inserts for type — faces deferred; CLAIM stays claim-quality
- Per-punch-type × region matrix (hook_head, cross_body, …) — type feeling is partial family tell, not SKU grid
- Clean + glance as **4 SKUs** if scale works
- Twelve severity grades / 3 severity × 2 region as purchases
- KD reaction/ceremony — **M15 owns**
- Third live camera to “sell” reaction — M14 fixed HOME; no third exit

Board: `m17_08_rejects.png`

---

## Verdict (buy sheet)

| Buy | Name | Why |
| --- | --- | --- |
| 1 | `react_head_clean` | 65.3% region × clean majority — primary HOME read |
| 2 | `react_body_clean` | 28.2% region × clean — second HOME read |

| Playback (not SKU) | How |
| --- | --- |
| Glancing | Lower amplitude / shorter on #1/#2 |
| Severity took-well → hurt | Amplitude / speed + procedural lean |

| Later optional | When |
| --- | --- |
| #3/#4 stumble / badly-hurt silhouette | Only if scale cannot sell “badly hurt” without a different path |

| Do not buy | Why |
| --- | --- |
| react_arm / react_leg / blocked / slipped / miss theatre / face-close / type×region matrix / 4 glance SKUs / severity tiers × region / KD | Measured waste or owned elsewhere |

**Q3:** partial YES — hook/straight/upper family in reaction; not jab≠cross.  
**Q5:** glancing = smaller clean, not own clip.

Board: `m17_09_verdict.png`

---

## Anchors

- M14 — HOME typed; fixed live; only CLAIM-TIGHT + KD leave
- M15 — KD ceremony owns knockdown reaction
- M16 — buy 3 punches (+ optional 1 straight); jab+cross collapse; reactions out-read arm; freed slots → here
- J17 — type not target; fewer reaction SKUs; head+body; block/slip not purchased; no react_leg boxing
- G43 — permission to stay

---

## Invented vs referenced / measured

| Item | Mark |
| --- | --- |
| Region shares 65.3 / 28.2 / 3.2 / 0 | **Measured** (cited) |
| Contact shares clean 92.7 / glancing 5.6 / blocked 0.2 / slipped 0.1 / … | **Measured** (cited) |
| M14 HOME numbers | **Referenced** M14 |
| M15 KD ownership | **Referenced** M15 |
| M16 buy-3 + reaction out-reads arm + freed slots | **Referenced** M16 |
| J17 fewer reacts; head+body; no block/slip buy; no react_leg boxing | **Referenced** J17 |
| Board silhouette poses | **Invented** (art under HOME) |
| Type-in-reaction partial YES (hook/straight/upper) | **Invented** visual judgment |
| Glancing-as-scale (not SKU) | **Invented** stress-test of held lean; boards agree |
| Severity-as-amplitude + procedural lean | **Invented** spend advice; craft-compatible with J17/Sherr language |
| Optional later stumble SKU | **Invented** rank-#4 advice |

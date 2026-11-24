# BOXCARDS2 — independent, code-checked critic

## Verdict

**Do not call this ready for a playable page.** REAL BOUT **6/10**: V2 has fixed the one-answer-for-a-whole-combination problem, and the immediate slip-and-counter is a better boxing-shaped choice than V1's banked bonus. But there is no range, no way to advance or cut off a retreat, and several card outcomes are unconditional physical facts rather than plausible chances. DEPTH **5/10**: per-punch choices and conservation are real decisions, but the only serious opponent is a short-horizon heuristic; I found no >60% blind exploit, which is not proof that skill beats draw. PLAY **7/10**: 17.4 instrumented decisions per boxer is compact; fixed slots are not a timed round, and no human bout was timed. The keep bar is **8 depth / 8 play: fail both**. Do not infer five minutes from the probe.

Method: I read ten complete `walk=1` transcripts, seeds 1–10, before looking at aggregate probe output. I then read the v2 design page, rules, bot, probe, tests, `CARDBOX_SCOPE_S549.md`, `CARDBOX1_BREAKDOWN.md`, and only then the v1 critic. I did not play human hands. References are line numbers in the checked-out files; the design page is the `main` version. All bot percentages below are one deterministic 400-bout sample per seat, not confidence bounds or human evidence.

## Ten-walk coach's ledger

Most named actions (a jab being slipped, a hook being blocked, a boxer taking a punch) can happen. The issue is the engine making the result automatic, with no range, timing or opponent reaction. These are the repeated exchanges I would mark as unlike a ring **as resolved here**:

| Walked exchange(s) | What the transcript does | What would happen instead / why it matters |
|---|---|---|
| **Feint then clinch before the first real punch:** 1 R3.3; 2 R2.2; 3 R1.3; 7 R1.2, R2.4, R3.2; 10 R1.1, R2.2, R2.6 | A feint is card index 0; because clinch is allowed at `i > 0`, defender clinches the hidden next card before the first actual punch. | A feint is not a physical entry. In a ring the defender must read/close distance and may tie up, miss the entry, or eat the shot. Treating a feint as “he has come in” is a loophole in the rule's first-card restriction. |
| **Blind step/block after feint, then a deterministic miss or hit:** 1 R1.1, R1.3, R2.6; 2 R1.4, R3.3; 3 R2.2; 4 R1.4; 5 R2.4, R2.6; 6 R1.3, R1.4, R1.5, R3.1; 7 R2.5, R3.4; 8 R1.3; 9 R1.2; 10 R3.2 | The defender commits while the attack is literally “hidden”; a blind step can make a body hook or cross fall short, or be wasted on a jab, and a blind block may be wasted on body work. | Guessing after a feint is plausible. What is not a ring event is a card-name reveal standing in for visible shoulder/hip/foot cues, with no range or follow-through. An uppercut/body shot is not made unreachable merely by one generic “step” at an untracked distance. |
| **Slip-and-counter repeatedly awards a guaranteed clean return and terminates the volley:** 1 R1.3–4, R2.1, R3.2, R3.5; 2 R1.2, R1.5–6, R2.6; 3 R1.5–6, R2.4; 4 R2.3; 5 R1.4; 6 R1.5, R2.2, R2.6, R3.5; 7 R1.4, R1.6, R2.2, R3.1, R3.6; 9 R1.1; 10 R3.1, R3.3, R3.5 | Twenty-seven printed answers say “slips … counters” and then award the counter clean, including counters with a body hook or jab. | A slip-counter is recognisable boxing; the guaranteed clean landing is not. The attacker can recover, smother, or counter back; the counter can miss. Here the card pays two cards and wind, but turns a tactical opening into certainty. |
| **Empty lead becomes a scored breather:** 2 R2.5; 4 R3.3; 5 R1.3 and R3.6; 6 R1.6 and R3.3; 7 R2.6; 10 R2.3–5 (three consecutive empty slots) | The leader gives up the action, gets wind and a fresh hand, and awards the other boxer two points. | A boxer can coast or take a breath, but three no-punch slots in one round are not a clocked three-minute exchange. Two points for not throwing is a game penalty, not a boxing scoring event. Seed 10 R2.3–5 is the clearest artificial lull. |
| **Threshold knockdown/count/stoppage:** 3 R2.4–5; 4 R3.6; 6 R3.6; 7 R1.6; 8 R1.4–5; 9 R1.4–5 | A clean power card reaching a numeric head total causes a knockdown; a second/third down or short cap ends the bout. Seed 8 has a count loss then a second down/stoppage; seed 9 has two knockdowns in consecutive exchanges. | The cumulative hurt model is useful shorthand, but it cannot represent a count, a fighter recovering, referee judgement, or a corner/towel. “Wind bar 3” is actually maximum cap in code, not current wind. These are deterministic thresholds, not realistic count sequences. |
| **A turned punch can count as thrown after the clinch smothers it:** especially 1 R1.5/R1.6, 2 R1.3 and R3.1–2, 4 R1.1–2, 6 R1.1–2, 7 R3.5 | The walk says “ties him up before [the punch] lands,” yet the punch's `thrown` counter was incremented when its card turned. That counter breaks a round tie. | In a real scorecard, a smothered, never-attempted follow-up is not a punch thrown. V2 improves on V1's counting every committed card, but the proxy still lets a card turn masquerade as a punch. |

I do **not** claim ordinary blocks, missed jabs, or clinches never happen. The failure is that range, distance, visible cues and the referee are absent, so several of these outcomes are mandatory. All ten logs include repeated body/head work without a distance state; “Body hook” can be launched from any unspecified range, and “Step back” does not create a long-range state or let the attacker follow/cut off.

## Design page against executable

`T` means the rule/number is reproduced at defaults. `F` means false, misleading, or a promise not enforced by this engine. The card rows cover every printed card count, wind cost and effect, not just the examples.

| Page claim | Check against code | File / lines |
|---|---|---|
| Face-down volley, up to 3, one card revealed/answered at a time; stopped cards return free | **T** for simulation; no actual table/UI enforces what a human can see. The engine spends each turned card, then keeps unturned cards. | `rules2.mjs:38–42,71–105`; page `:9–11,57` |
| 3 rounds, 3 leads each, alternating; later cards leader is behind | **T** for the 6 alternating slots and behind-on-scorecards. **F** for “a coin”: `newBout` defaults first to seat 0; probe uses deterministic parity, not a coin toss. A skipped lead can reduce the six. | `rules2.mjs:28–32,125,129–141`; `probe2.mjs:13,27–28` |
| Each boxer has a 28-card deck, 5-card hand/refill; fresh hand at bell | **T**: each gets its own deck; the pile reshuffles when empty; unused hand is discarded at the bell and refilled next tick. | `rules2.mjs:23–35,115–116,126` |
| Hidden hand / face-down cards; only draw is chance | **T** as a paper rule, **not an engine boundary**. Every pilot is passed the full mutable `S`, including both hands, decks, piles and RNG; custom code can cheat. `reader` itself does not directly pick the opponent's hand, but `leadBot` samples from the hidden `deck + hand` pool. | `rules2.mjs:127–139`; `bot2.mjs:43–50` |
| Wind 6, +3 before exchanges, full at bell; body work permanently lowers cap to floor 2 | **T**, except “wind bar 4 or less” is ambiguous: the tired slip cost keys off **cap** (`m.cap <= 4`), not current wind. The first exchange does not tick, but begins full. | `rules2.mjs:5–9,36,60,115–126`; page `:34–36,51` |
| Head bar 0–8; clean head damage; fade 1 each exchange and at bell | **F** as a hard 0–8 bar: `daze` is not clamped. Jab and blocked-power damage can exceed the knockdown line without a knockdown. Hurt prevents per-exchange fade until bell. | `rules2.mjs:12–16,61–64,115,126`; page `:36,60–62` |
| Card table: Jab 5/1/1/1 long; Cross and Lead hook 3/2/3/2; Body hook 3/2/1; Uppercut 2/3/4/2; Feint 2/1; Block/Slip 3/1; Step and Clinch 2/1 | **T** for counts, costs, damage/points, zones, unblockable uppercut, and feint hiding the next punch. The next *actual punch* remains blind through intervening feints. | `rules2.mjs:11–23,60–64,82–87`; page `:38–55` |
| Block stops one head punch (power leaks 1); body/uppercut bypass; slip misses; tired slip costs +1 | **T** except the tired-cost wording: code tests shortened maximum cap, not current wind. A blocked power adds daze but cannot knock down. | `rules2.mjs:36,47,50–52,61,89–92`; page `:50–52` |
| Slip-and-counter uses Slip + any punch, not against jab or blind; Trade is Cross/Hook on lead punch only | **T**. A counter lands clean and ends the volley; a Trade lands both unless the original hit itself downs the defender. Neither answer is offered against a jab; only the visible opening punch may be traded. | `rules2.mjs:51–54,91–100`; page `:52,55` |
| Step back makes a non-jab fall short and ends the volley; clinch is barred on first card, later smothers and ends it; third hold costs a point | **T** as card-index mechanics, with two important qualifications: a blind step can be chosen against an actual jab and is then wasted; a feint at index 0 makes a clinch legal at index 1, before any real punch. A clinch's leader cost is clamped at 0, so it is free if the leader has no wind. | `rules2.mjs:47–49,93–104`; page `:53–55` |
| Knockdown when a clean Cross/Hook/Uppercut reaches 8; head reset to 6; loses next lead; 2 in a round / 3 in bout stops; wind ≤3 count-out | **F** in two material details. The count-out tests `cap <= 3`, not current wind. `skip` is cleared at the bell, so a knockdown in the final exchange of a round does **not** cost the next round's first lead. Otherwise threshold, reset, stop counts and KO precedence match. | `rules2.mjs:63–67,115–116,134–141`; page `:60–62` |
| Knockdown scorer takes 10–8; ordinary bell scoring is clean points, then thrown count, else 10–10; total cards, then total points | **Mostly T**. The code gives the KD scorer the round, then subtracts the KD margin; holding penalties come off after. But “thrown” means “card turned,” including a card clinched before impact; it is not a measure of punches actually landed or attempted. | `rules2.mjs:83,95–102,107–123`; page `:63` |
| Breather: +2 wind, fresh hand, +2 points to opponent | **T** on top of the normal +3 recovery tick. It can also clear the opponent's “held” status. | `rules2.mjs:7,76,126`; page `:25` |
| Probe metrics and published base numbers | **T** on rerun (tables below), but some names are easy to misread: “real choice” is `legal.length > 1`; “card used” is pooled bout presence, not use per legal opportunity; per-man decisions include lead choices plus answer windows with >1 legal option. | `probe2.mjs:24–64`; page `:65–83` |

Rules in code not stated fully on the page: the first lead is supplied by a seed/seat, not randomized by an engine coin; reshuffling can erase pile history; a feint itself costs wind/card but is not a punch or answer window; the first punch after one or more feints is hidden; a clinch costs the leader 1 only if wind remains; ropes is a one-bit restriction on the next step, not a ring position; `daze` is unbounded; KO depends on shortened **cap**; a last-slot knockdown's lost-lead flag is cleared at bell. No range, style, ring-corner, corner-choice, clock, count duration, or independent judge model exists.

## Rerun and blind pilots

`node proto/boxcards/probe2.mjs` reproduced the page: 400 `reader v reader`; cards (decision, decision-on-punches or draw) **79.3%**; first leader wins **53.0%**; combinations in **87.5%**; **17.4 decisions per boxer** (34.8 combined); empty leads **7.8%**; knockdown in **45.0%** of bouts (**0.73 per bout**); stoppage **19.0%**, count-out **2.0%**. Answer distribution: takes **27.5%**, block **20.3%**, slip **14.8%**, clinch **12.8%**, step **12.0%**, slip-counter **8.4%**, trade **4.1%**. Choice exists at **73.0%** of answer windows. Openers: Jab 54.2%, Feint 25.0%, power 19.0%, Body 1.9%.

| Built-in blind pilot vs reader | Pilot wins as A / as B | Page's rounded claim | Rerun |
|---|---:|---:|---|
| same jab–cross–hook | 17.5 / 20.0% | 17.5 / 20% | matches |
| jabs only | 8.0 / 9.1% | 8 / 9% | matches |
| never leads | 0 / 0% | 0 / 0% | matches |
| always clinch when legal | 48.5 / 48.6% | 48.5 / 48.6% | matches |
| always step when legal | 48.5 / 47.5% | 48.5 / 47.5% | matches |
| take every answer | 3.8 / 1.2% | 4 / 1% | matches |
| first legal answer | 31.9 / 34.9% | 32 / 35% | matches |
| slugger | 0.5 / 0.7% | 0.5 / 0.7% | matches |

### Five scratch pilots; 400 bouts from each seat

Scratch-only file: `/tmp/boxcards2-critic-pilots.mjs`; no repo code changed. Every policy used `reader` for other decisions, did not read the opponent's hand, and used the same seeds/alternating first seat. Shares include half a draw.

| My pilot | A / B win share | Result |
|---|---:|---|
| Hold Slip for the biggest visible power/body punch; counter with highest-damage available punch | 50.0 / 47.9% | Best of the tested candidates; no >60 exploit. |
| Never answer a visible Jab (take it); ordinary answer policy otherwise | 46.0 / 45.9% | A jab is not counterable anyway; ignoring it is still costly over a bout. |
| Lead one card only, strongest available single punch | 2.5 / 5.6% | One-card simplicity loses badly to the reader's sequence search. |
| Always Feint first when a legal feint-led volley exists; strongest follow-up | 3.5 / 2.5% | Blindness alone is not an advantage if the reader prices it. |
| Exploit attempt: Feint then Uppercut whenever possible; otherwise feint + best follow-up, take highest-score volley if no Feint | 28.0 / 25.1% | Better than naïve attacks, still nowhere near the threshold. |

Best overall custom policy was holding Slip for the biggest shot; the most direct attack-side exploit (Feint→Uppercut) won only 28.0/25.1%. **No custom pilot exceeded 60%** in either seat. This is a short search, not a theorem. 400 bouts per seat around a 50% rate still has roughly ±5 percentage points of sampling noise.

What the reader cannot see/does not value (code-checked): `worth` (`bot2.mjs:9–13`) is an immediate weighted difference of points, daze, cap, knockdowns, next-recovered wind, busy sign and holding penalty. It has no remaining-round/round-scorecard model, no future sequence or hand value, and no score-aware risk policy. `answerBot` (`:26–42`) scores each answer against the visible punch, or for a hidden punch averages `DECK - leader.pile` counts; that estimate omits the leader's current hand and the just-spent hidden card is already in the pile. It adds a flat `W.unseen * left` for ending a volley. `leadBot` (`:43–52`) tries all legal volleys but averages only **six** sampled hands from the unseen `deck + hand` pool, using the same answer model and immediate `worth`. The bot sees only one exchange ahead, not the bout. The pilot API itself does not enforce blindness: it passes the full state to every bot.

### Fourteen-part boxing checklist (CARDBOX1_BREAKDOWN.md)

| # | Part | V2 coverage |
|---:|---|---|
| 1 | Range and who sets it | **Missing**; only a temporary step/ropes flag. |
| 2 | Jab as score, blind, measure, setup | **Partial**; scores, has reach and cannot be countered; no measure/setup/range. |
| 3 | Lead against counter | **Partial**; trade and slip-counter exist, but are fixed outcomes and no wait/position game. |
| 4 | Combinations | **Present but abstract**; ordered cards, sequential answers and multi-hit volleys. |
| 5 | Head against body | **Partial**; body shrinks cap and scores, but no modeled range/foot speed or cumulative round-to-round fatigue beyond cap. |
| 6 | Defence: block, parry, slip, roll, step, clinch | **Partial**; block/slip/step/clinch only; no parry/roll, and counters are automatic. |
| 7 | Feints | **Partial**; hides next punch, but a feint can unlock a pre-punch clinch. |
| 8 | Ropes and corner | **Missing**; no cut-off, corner, exit or range state. |
| 9 | Tiredness and pacing | **Partial**; wind renews +3 every exchange and resets to cap at bell; body wear shortens cap. No corner-rest choice or pace debt. |
| 10 | Hurt, knockdown, count, survival | **Partial**; deterministic head threshold, skip and stoppage; no count or survival decision. |
| 11 | Bell | **Partial**; ends fixed slots and fades daze; no clock or press-before-bell choice. |
| 12 | Corner's minute | **Missing**; new hand only. |
| 13 | Judges / stealing a round | **Partial**; one shared deterministic scorecard, no three judges or quality/generalship. |
| 14 | Referee stoppage | **Partial**; fixed KD thresholds/holding point, no referee assessment or towel. |

## Sensitivity sweep (400 reader mirrors per row)

Every run used the probe's standard seed schedule. “Cards” includes decisions on punches and draws; first-lead win gives half credit to a draw; empty is per non-skipped exchange; decisions/boxer uses the probe's `r.dec` definition. Values are one run, not calibrated rates. `D.feint=3` adds a card (29-card deck), it is not a 28-card substitution.

| Override | To cards | First wins | KD bouts (KD/bout) | Decisions / boxer | Empty leads | Combos / bouts | Read |
|---|---:|---:|---:|---:|---:|---:|---|
| default | 79.3% | 53.0% | 45.0% (0.73) | 17.4 | 7.8% | 87.5% | misses cards and per-boxer decision bars |
| `kdAt=9` | 86.3% | 51.1% | 31.8% (0.48) | 18.2 | 7.2% | 88.3% | fewer KDs, more decisions; still about one bout in three down |
| `restPts=0` | 84.0% | 47.3% | 39.3% (0.59) | 16.5 | 22.1% | 94.0% | rest is attractive; empties fail badly |
| `restPts=1` | 82.3% | 50.0% | 40.3% (0.65) | 17.0 | 13.8% | 90.3% | still exceeds 10% empty bar |
| `restPts=2` | 79.3% | 53.0% | 45.0% (0.73) | 17.4 | 7.8% | 87.5% | current; deterrence keeps empties under 10% |
| `restPts=3` | 76.8% | 51.0% | 51.5% (0.85) | 17.5 | 3.6% | 88.0% | over-punishes rest; KDs rise |
| `slip.w=2` | 78.8% | 49.8% | 42.8% (0.70) | 17.7 | 5.8% | 87.0% | modest aggregate change; counter used 7.6% vs 8.4% baseline |
| `upper.w=4` | 87.0% | 50.2% | 33.3% (0.49) | 18.1 | 7.5% | 86.5% | notably fewer KDs; deck/choice pattern shifts |
| `leads=4` | 65.5% | 50.7% | 58.0% (0.98) | 21.2 | 8.3% | 95.8% | cards bar passes; decisions still below 22 per boxer |
| `rounds=4` | 72.0% | 53.4% | 57.8% (0.95) | 22.1 | 7.9% | 94.0% | reaches 22 decisions, but adds a third more slots and more KDs |
| `D.feint=3` | 77.8% | 51.5% | 49.0% (0.78) | 17.0 | 6.0% | 92.3% | more feints do not fix decisions/KDs |
| `blockLeak=0` | 80.3% | 51.4% | 43.8% (0.70) | 17.5 | 7.6% | 86.8% | little movement |
| `blockLeak=2` | 79.0% | 54.0% | 48.3% (0.78) | 17.4 | 7.7% | 86.8% | more KDs and first-seat edge near bar |

I also made two **scratch-only** two-line patches and reran the same probe. “Smothered” moves the attacker's `thrown++` until after the answer and does not count a punch clinched before it can be attempted; “skip” preserves a knockdown's lost lead across the bell. Neither patch changed the repository.

| Scratch patch | To cards | First wins | KD bouts | Decisions / boxer | Empty leads | Combos / bouts |
|---|---:|---:|---:|---:|---:|---:|
| default | 79.3% | 53.0% | 45.0% | 17.4 | 7.8% | 87.5% |
| smothered punch not thrown | 78.8% | 54.4% | 46.5% | 17.3 | 7.7% | 88.5% |
| carry skip over bell | 79.8% | 52.0% | 45.0% | 17.3 | 7.7% | 87.3% |
| both patches | 79.0% | 53.4% | 46.5% | 17.3 | 7.6% | 88.3% |

The main fragile result is not the first-seat bar (50–54% in these sweeps); it is the knockdown/card mix and inactivity when the rest penalty changes. One-parameter tuning does not fix the missing range, scoring model or playtime evidence.

## Version 1 findings: fixed, still open, and regressed

After forming the view above, I checked `BOXCARDS1_CRITIC_ARENA.md`:

- **Fixed materially:** answerer no longer sees a whole volley and spends one defence on it; block covers one punch rather than all heads; step ends the volley and keeps unturned cards; counter is now immediate slip-counter vs opening trade rather than mandatory trade; no banked slip bonus; legal volleys/answers are checked; breather is no longer free; knockdown normally awards the scorer 10–8. Those address the v1 clairvoyance/blanket-defence/phantom-commitment findings directly.
- **Not fixed:** no range/footwork/pressure, no actual three-minute clock or human-time evidence, no corner choice or three judges, no engine boundary that hides state from an adversarial pilot, and `worth`/`answerBot` still use a shallow and approximate one-exchange model. A card turned and clinched is still credited as thrown, so the old “phantom busyness” concern is narrowed, not eliminated.
- **What V1 had right that V2 broke:** V1 had a single response window, so a small hand did not require selecting a defence separately for every card; that was fast (though wrong because the answerer saw the whole volley). V2 now has 73% of answer windows with an option and only 17.4 measured decisions per boxer overall, but the extra per-punch interaction and face-down volley require more explanation and timing. V1's explicit separate head/body tracks and 10-point round framing were closer to the sport's vocabulary; V2's “points” plus deterministic threshold damage and busyness tiebreak still conflate scoring, hurt and activity. V2 did fix V1's unfair one-block answer; it did not preserve the old ability to understand the round at a glance.

## Five open points (two lines each)

1. **KD at 45%?** Yes, high enough to question: `kdAt=9` lowers KD bouts to **31.8%** (0.73→0.48 KD/bout), but still about one in three; cards rise **79.3→86.3%**.  
   It is a measured trade, not calibration: collect a comparable three-round cohort before selecting a threshold; the 40–70% card bar is not itself a boxing fact.
2. **Slip-counter too cheap at 3 wind / two cards?** It is powerful and broadly used (8.4% of answers; appears in 92% of baseline bouts), but costs a Slip plus punch and ends the volley; that is a meaningful exchange, not free defence.  
   `slip.w=2` moves use to 7.6%, KD bouts 45.0→42.8%, cards 79.3→78.8%; not a decisive fix, so keep 1 pending human play.
3. **Breather at 2 points?** The sweep says 2 is the only tested value that keeps empty leads below 10%: 0→22.1%, 1→13.8%, 2→7.8%, 3→3.6%.  
   Two points is blunt but functional; three over-punishes rest and raises KD bouts to 51.5%, while zero/one invites inactivity.
4. **More exchanges or 17 decisions per boxer?** Four leads gives 21.2 decisions/boxer and 65.5% cards; four rounds gives 22.1 and 72.0%, with KD bouts ~58% in either sweep.  
   Four rounds adds 33% more slots and is not a five-minute fix; keep 3 rounds until people time it, rather than tune to the inherited 22–45 bar.
5. **Corner minute, styles, range, three judges?** None is implemented; `CARDBOX1_BREAKDOWN.md` items 1, 8, 12–14 are absent or only threshold stubs. No probe sweep can measure an unimplemented choice.  
   Add no feature by guess: first test real hands; then prototype range/corner/judge options separately with bounded effects and compare both seats. The engine currently caps body wear at 2, holds after two free holds, and stoppages at 2/round or 3/bout, but has no cap for movement because it has no range loop.

## TO REACH 10/10

1. **Fix the stated contract before tuning:** clarify in the page that slip premium and count-out use *cap*, not current wind; test/correct “clinch after first card” so a feint cannot unlock a clinch before the first real punch; carry a last-slot knockdown's skip across the bell; and either count smothered cards as attempts explicitly or do not let them win the busy tiebreak. Regression tests: feint→clinch, cap 3/current wind 6 count-out boundary, knockdown on final slot, and jab→clinch `thrown` count. The scratch metrics show why this is a semantics fix, not a balance miracle (79.3% cards baseline vs 78.8% with smother patch / 79.8% with skip patch). **Loops/caps:** knockdown→lost lead can compound, capped at one skip per down and existing 2/round/3/bout stoppage; clinch spam is currently capped by `held` and the third-hold point, but that point triggered 0 times in 400 mirrors.
2. **Keep the knockdown threshold provisional, not “fixed” at 9:** table-test `kdAt=8` vs 9 with held-out seeds and a defined real-bout distribution. The measured row is 45.0% vs 31.8% KD bouts, 79.3% vs 86.3% cards, 17.4 vs 18.2 decisions/boxer. **Loop/cap:** damage→down→reset to 6→repeat is capped by one lost lead, bell fade, and two downs/round or three/bout; the sweep shows that is not enough evidence to call the frequency right.
3. **Retain `restPts=2` for now; do not reward a no-lead turn more.** Re-run 0/1/2/3 on held-out seeds after step 1; current rows are 22.1/13.8/7.8/3.6% empty, and 84.0/82.3/79.3/76.8% to cards. **Loop/cap:** empty lead→+2 wind/fresh hand can repeat; the opponent's 2-point award is the current deterrent, while exactly one rest action per scheduled exchange and cap 6 bound recovery.
4. **Do not add a fourth round just to hit 22 decisions.** If the owner prioritizes more choices, test `leads=4` separately first (21.2 decisions/boxer, 65.5% cards) against `rounds=4` (22.1, 72.0%, +33% slots) with measured human time. **Loop/cap:** more slots→more attempts, knockdowns and fatigue; rounds cap exposure but 4 rounds already raises KD bouts to 57.8%.
5. **Do not award 10/10 without an actual table and a bounded range/corner/judge prototype.** Run 20 human hands and time at least 20 bouts; add one mechanic at a time and publish both-seat outcomes before adding styles. **Loop/cap:** movement can create retreat→more retreat, so cap step/advance to one range shift per exchange; corner recovery can create safe-rest loops, so cap it to once per bell and no more than +1 wind; judge variants can reward camping, so score clean work each round and test coast/press pilots. No numbers are claimed for these unimplemented proposals.

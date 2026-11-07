# BJJ fight design v4 (S397, Qwen) — the 8/10 version

Design target: 8/10 from both blind critics (black-belt coach + match-engine designer; sim-engine veteran + purple belt). Fixes every fault both named, resolves conflicts. Each part: rule with numbers ([R] real with source, [G] ours), what the player sees and decides, the bars (measurable by headless probe), and which module it lives in. BjjWalk.gd (447) and BjjTree.gd (451) near 500-line cap: new rules go to new small modules. One match fast (hundreds a second). No new art. IBJJF adult no-gi. No he/she in player text.

---

## A. What a belt means

**Rule:** Every athlete has a hidden skill rating, seeded from belt + stripe + noise [G]. Belt = noisy band: white 800-1000, blue 1000-1200, purple 1200-1400, brown 1400-1600, black 1600-1800 [G; R: nogiratings.com 200 gap = 76%, 400+ = 90-93%]. A 4-stripe blue is ~100-200 above a fresh blue = 66-76% [R proxy]. Mat time stays [G: white 0, blue 1.0, purple 1.8, brown 2.4, black 2.9 + 0.4 over first 300 classes] but is read ONCE (odds only, not finish gate — v3 double-counted). The finish gate uses the rating gap: escape_chance = base x (1 - rating_gap / 1000), so the senior's sub rate RISES with the gap [R: favourite submits 53% at 200, 76% at 500+, nogiratings.com]. Belt composure (v3: white -6 .. black +7) folds into the rating. Mastery bands (BjjOpp.OWNED_BAND) stay but narrow. Per-pair bands: fresh vs 4-stripe same belt 62-70%; one belt 70-80%; two 85-95%; three+ 95-99%; never above 99%.

**Player sees:** scouting card names the gap in words; result card names whose rating decided it.

**Bars:** probe (n >= 2,000/cell) hits every band; 4-stripe blue beats fresh blue 66-76%; senior's sub share in mismatches 60-75%; black loses to white <= 1%.

**Module:** BjjRating.gd (new, ~120 lines): hidden rating, belt bands, rating-gap win table, finish gate from rating gap.

---

## B. The grappler

**Rule:** Six attributes 0-100 (strength, cardio, flexibility, explosiveness, composure, aggression) [G]. Each attribute leads at most 3 move kinds (v3 had explosiveness on both sides of almost every arrow; now cut). READS table trimmed: standing = explosiveness + strength; pass = strength + composure; sweep = explosiveness + flexibility; escape = flexibility + composure; back_take = explosiveness + composure; choke = composure + strength; arm = explosiveness + flexibility; leg = flexibility + composure (leg-lock defence is mostly the answer's mastery: knowledge). Aggression now read by the chooser AND by the grip exchange (new: aggression + explosiveness vs the same). Height/limb length added as a body fact [G: light / mid / heavy; light = +5 flexibility -5 strength; heavy = +5 strength -5 cardio; R: heavier wins 60.5%, nogiratings.com]. Wrestling background = starting mastery of the standing lanes (double_leg, single_leg_shoot, snap_down at 20-30), not a body offset [G]. Hand fighting and frames get a cost curve (half pace): drilling one from 30 to 60 costs the same as one move, so a week on a line never beats a week on the best lane. Each attribute 30 -> 70 moves the win <= 8 points. Every attribute named in a result line at least once per 20 matches.

**Player sees:** grappler card shows six bars + weight + height; Week screen shows training focus; result card names every attribute that weighed.

**Bars:** best vs worst body draw <= 20 points at equal belt; drilling a line 30->60 moves its arrows 6-10 points; a week on hand fighting never beats the best lane by > 2 points; every attribute shows once per 20 matches.

**Module:** BjjBody.gd (trim READS, add height/weight, wrestling background as starting mastery); BjjTree.gd (hand fighting and frames as technique lines with cost curve).

---

## C. The games (archetypes)

**Rule:** Each athlete has THREE labels, not one: a standing plan, a top game, a bottom game [G; R: real players have all three, every match forces both]. Six games, each label independent. Wrestler: standing = shoot first, top = hold top, bottom = scramble up. Guard player: standing = pull guard, top = pass with frames, bottom = retain guard + submit. Leg locker: standing = enter early, top = pass to legs, bottom = leg entanglement from guard (straight ankle locks at white/blue; heel hooks only at brown/black [R IBJJF]). Back-taker distinct from Wrestler: standing = front headlock off the shot, top = turtle attacks + seatbelt, bottom = scramble to back [G; R: RNC 21-22% of no-gi black finishes, BJJ Heroes]. Matchup wheel emerges from the reads and lanes, not from a table. Per belt band: each style's mean vs the other five 0.45-0.55; worst matchup 8-15 points off even.

**Player sees:** scouting card names three labels + two tells + matchup edge; result card names which game won.

**Bars:** 6x6 matrix (>= 2,000 seeds/cell/belt) each cell 0.40-0.60; Back-taker ~15% of brown/black opens; classifier on result lines names style 80%.

**Module:** BjjOpp.gd (three labels per athlete, style shapes split into standing/top/bottom).

---

## D. The standing exchange and grips

**Rule:** A match opens (and every stand-up restarts) with a GRIP beat: hand fighting (aggression + explosiveness + grip mastery) vs the same [G]. The grip winner gets the initiative and a grip edge (+0.15 on the logit, not +0.3 — v3 handed the match to the grip winner; R: first scorer wins 80-87% but the grip is only one reason) on the first shot or pull. The grip edge decays after the first attempt (-0.05 per restart), so the grip is not re-rolled for free. From the grip: shoot (double / single / snap down, answered by sprawl and guillotine), pull guard (needs a grip: grip mastery / 30 on the logit; a failed pull is punished — the opponent gets a takedown opportunity, +2 points if it lands [R: 27% of takedown points at Worlds/Pans came from punished pulls]), or a front headlock (snap down -> front headlock / turtle on the graph) [R]. Double pull: both athletes pull, the referee starts a 20-second count; if neither attacks, both are penalised [R IBJJF].

**Player sees:** result card says "won the grip exchange"; "punished for a failed pull"; "double pull, penalised".

**Bars:** +10 grip mastery wins first exchange 55-62%; grip winner scores first 55-62%; pulls land 70-80%; takedowns 25-40%; completed takedowns 0.17-0.25/athlete/10 min [R: ADCC 2019].

**Module:** BjjGrip.gd (new, ~150 lines): grip beat, grip mastery, grip edge decay, double pull rule, punished pull.

---

## E. Guard vs pass, scrambles

**Rule:** Most beats are NOT attempts: a match has ~3.5 attempts per athlete per 10 min [R: ADCC 2019 Lamas], not 18. A beat with no attempt is a HOLD: grip fighting, retention, circling. A retention beat: the bottom player's missed sweep keeps the pressure, a landed sweep or escape clears it, a bottom hold with the initiative is a retention roll (frames vs pass mastery). A pass is a multi-beat contest: a failed pass builds PRESSURE (+0.35 on the logit to the next pass, one stack max — v3 had two stacks that never came into play); a sweep, an escape or a retention beat clears it. Frames read on every pass defence. A miss that slides to the scramble position starts a scramble: explosiveness + composure decide who comes up on top. A Leg locker can answer a pass with a leg entanglement (leg_lock_escape mastery reads on the pass defence).

**Player sees:** result card says "retained guard", "built pressure", "scramble won", "leg entanglement stopped the pass".

**Bars:** completed passes 0.17-0.25/athlete/10 min [R: ADCC 2019]; pass takes 1.8-3 attempts; scrambles go to explosive side 58-65%.

**Module:** BjjPass.gd (new, ~130 lines): multi-beat pass, pressure stacks, retention beat, scramble node, leg entanglement answer.

---

## F. Submissions and defence

**Rule:** The finish gate uses the rating gap (part A), not mat time. An escaped submission is a near submission: an advantage [R IBJJF]. Each escaped submission has a LAND POSITION: triangle escaped -> stacked pass (defender ends on top); heel hook escaped -> on top (defender scrambled free); armbar escaped -> guard retained [G; R: the escape costs something, not just an advantage]. The gate does not double-count: the real per-move base rates are attempt-to-tap (OVERRIDES in BjjTree already are), so landed-sub probability = base_rate x (1 - escape_chance). Leg-lock defence: answer's mastery x0.7, flexibility x0.2, composure x0.1 (knowledge dominates). Heel hooks at brown/black only [R IBJJF]: landed heel hook has 15% injury chance (DQ) when defender's leg_lock_escape < 20; "tapped to a heel hook" vs "injured - knee gave way".

**Player sees:** result card names submission + finished/escaped + land position; "nearly finished with a triangle, escaped into a stacked pass"; scouting card says "leg-lock specialist".

**Bars:** sub attempts ~1.0/athlete/10 min [R: ADCC 2019]; advantage-decided 2-8% [R]; back take -> finish 45-61% [R: Lamas]; RNC and heel hook top two finishes 17-25% each [R]; heel hook finishes 60-70% when landed; injury < 20%.

**Module:** BjjRating.gd (finish gate from rating gap); BjjPass.gd (escape land positions).

---

## G. Fatigue and pace

**Rule:** A tank per side: every attempt costs gas by its kind x (1.5 - cardio/100), a miss more, a hold breathes. The tank carries across a 3-5 match day in an open: recovery by minutes of rest (3 min rest = +0.2 gas, 5 min = +0.35). Being pinned / carrying weight costs gas: the bottom player under a pin drains 0.02 per beat. Gassed (< 0.3): frames and hand fighting fall first (grip mastery -10, frame mastery -10), top position given up more readily (pass defence -0.1 logit), fewer marginal shots. GAS_W set from the harness (v3: ~0.13 logit late, likely missed).

**Player sees:** corner card shows "tiring" at gas < 0.4, "gassed" at < 0.2; result card says "gassed in the last third".

**Bars:** cardio-70 beats cardio-40 60-68% in 10 min; cardio-40 odds drop 20-30% in last third; 30 vs 70 gap >= 6 pts in 10 min, <= 3 in 5 min.

**Module:** BjjBody.gd (gas carries across open, pin drain, gassed effects); BjjWalk.gd (recovery between matches).

---

## H. The referee

**Rule:** Bell order [R IBJJF]: points, advantages, fewer penalties, then the referee's decision. Stalling: a hold off a pin (no attempt for a beat) is a stall; every 2nd one a penalty. Exemption list FIXED: only defending under mount / back / side control / north-south, and holding mount or back properly, are exempt [R IBJJF 2021]; holding side control without trying to advance IS stalling (v3 exempted it). Ladder: 1st marked, 2nd an advantage to the other side, 3rd two points [R IBJJF 2021]. Double pull: both on 20-s count, both penalised; both on 3 penalties = restart standing [R IBJJF]. Decision: takedown attempts first (2 even on a miss; R: more takedown attempts won 85% of real decisions, BJJ Heroes), time on top while improving (0.5 per beat), near-subs (3), then sub attempts (3); a miss counts half. Inside 5% of even it is a judgement call: the share is the weighted tally, and the call is "judgement" when |share - 0.5| < 0.05. "Even" = a pre-match chance 40-60% (rating gap < 50 points).

**Player sees:** result card shows "penalised for stalling at 4:10"; "referee decision: more offensive (62%)"; "double pull, both penalised".

**Bars:** decisions 2-10% of even matches [R: 7% at black]; stalling on holder 85%+; no pin penalised; advantages decide 3-8%; penalties <= 3%.

**Module:** BjjRef.gd (fix exemption list, decision weights, double pull rule, judgement call threshold).

---

## I. The coach's part

**Rule:** Scouting card only for round 1 of an open (the only opponent known in advance), or for a rival / superfight [G; R: in a single-elimination open, between rounds only a short card, no drilling time]. The scouting card shows: the three labels (standing / top / bottom game), two tells with confidence that grows with films watched ("probably a wrestler" at 60%, "definitely a wrestler" at 90%), the matchup edge, the go-to route. Between rounds: a short card (belt, name, one tell), no counter drilling. The counter drill: pick one lane the opponent's go-to route uses; the answers of that lane get a one-week +5 bonus, but it costs that week's progress on the player's own game (bar: gain < lost growth over 4 weeks, 4-6 points). Posture: Hunt (aggression +25: takes marginal shots, never sits on a lead; price: a miss hands over initiative and burns gas) / Steady / Hold (-20: starts holding a lead twice as early; price: the stall count climbs). No posture best against more than 3 of 6 styles. Live: 3 calls on heavy settles. After: the result card names the deciding duels in plain words.

**Player sees:** scouting card before round 1; short card between rounds; counter-drill prompt after loss; 3 live calls; result card duel line.

**Bars:** different posture/counter best vs each style; no posture beats alternative by > 5 pts over all styles; counter-drill week moves bout 8+ pts; gain < lost growth (4-6 pts); tells > 80% confidence correct 80%+.

**Module:** BjjOpp.gd (scouting card, short card, tells with confidence); BjjBody.gd (posture prices); BjjWalk.gd (counter drill bonus, cost).

---

## Conflicts resolved

1. **A: which two of three belt counts to keep?** Kept mat time (core mechanic) and mastery bands (narrowed). Dropped belt composure as a separate lever (folded into the hidden rating).
2. **D: grip edge too strong or too weak?** Both critics said +0.3 was too much. Lowered to +0.15 with decay after the first attempt. Bar: grip winner scores first 55-62% (not 60-70%).
3. **E: action density vs the 33-s beat.** Both critics said one attempt per beat is too many (ADCC 2019: ~3.5/athlete/10 min). Solution: most beats are holds (grip fighting, retention), not attempts. The 33-s beat stays; a beat with no attempt is a hold.
4. **F: escape costs nothing vs escape double-counts.** Both critics said the gate double-counted. Solution: gate uses the rating gap (not mat time), and each escape has a land position (the escape costs something: triangle escaped -> stacked pass).

---

## Module map

| Module | Lines | Role |
|---|---|---|
| BjjRating.gd | ~120 (new) | Hidden skill rating, belt bands, rating-gap win table, finish gate from rating gap |
| BjjGrip.gd | ~150 (new) | Grip beat, grip mastery, grip edge decay, double pull rule, punished pull |
| BjjPass.gd | ~130 (new) | Multi-beat pass, pressure stacks, retention beat, scramble node, leg entanglement, escape land positions |
| BjjBody.gd | ~350 (trim) | READS trimmed, height/weight, wrestling background, gas carries, pin drain, gassed effects, posture prices |
| BjjTree.gd | ~450 (stable) | Hand fighting and frames as technique lines with cost curve, base rates verified as attempt-to-tap |
| BjjOpp.gd | ~350 (grow) | Three labels per athlete, style shapes split standing/top/bottom, scouting card, short card, tells with confidence |
| BjjRef.gd | ~150 (trim) | Fix exemption list, decision weights, double pull rule, judgement call threshold |
| BjjWalk.gd | ~450 (stable) | Recovery between matches, counter drill bonus/cost, most beats are holds |

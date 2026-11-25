# ALLPLAY1 - antigravity (played by message, driver ops/Tools/play_by_message.mjs, S558)

# ALLPLAY1_ANTIGRAVITY.md

## Verdict

**A genuinely clever, tense boxing puzzle trapped inside two exploitable loops and a few half-wired systems.** I went **3–0** (Round 3 beat 3 stoppage vs The Jabber; 29–28 vs The Slugger; 30–28 vs The Body Snatcher), and at its best—when speed interrupts, moment-order guard windows, and permanent stamina-bar erosion collided—Ring Switches felt like real chess-in-gloves. The problem is that once you discover the two-beat Mid/Inside engine (`1 Step in, 2 Feint, 3 Cross/Overhand` into next-beat `clinch`), you can bypass half the guard-reading game, farm free stamina, and skip Long range altogether. Tighten `clinch`, add counterplay to `Feint`, give `Long` and the ropes teeth, and clean up the AI's wasted beats, and this has clear 9–10/10 potential.

---

## NOT SURE

- **`guard 6/6`:** Printed on every fighter on every one of the 51 beats I played, never changed once, and is not mentioned in the help text. I do not know if it is unimplemented, broken, or triggered by a condition I never hit.
- **The ropes (`ground given 2/2`):** Neither fighter ever reached `2/2` across all three bouts, so I cannot judge what the penalty for being on the ropes feels like in play.
- **10–8 rounds:** In Bout 1 Round 2 (points 7–4 with a knockdown) and Bout 2 Round 3 (points 2–10 with a knockdown), the judges still scored `10-9` / `9-10`. I am not sure whether 10–8 rounds exist at all or require a two-knockdown round.
- **AI Push-off frequency and seed variance:** With only one bout per opponent (seeds 61, 62, 63), I cannot tell whether The Slugger literally cannot/never throws `Push off` (0 times against 5 clinches) or just rolled low on it, nor how representative The Body Snatcher's two anti-clinch Push-offs were.
- **Clinch-break guard rule:** Whenever I was shoved off a clinch (Bout 1 R2 B5; Bout 3 R2 B6, R3 B2), the log said my lead or rear hand was held high. I am not sure whether shoved-off clinches always force high/high guard by design or inherit a default state.
- **Visual/browser feel:** Playing by text makes exact stamina arithmetic and round-history counting effortless; a live browser UI with pacing pressure might make reading lines feel sharper or clinch loops feel less obvious.

---

## 2. Judging It on FUN

### Three Best Moments
1. **Bout 2, Round 3, Beat 1 — Getting blown up for getting greedy:** The Slugger was at 4/21 health, so I went for the clean `1 Step in, 2 Feint, 3 Overhand` finish from Long. He matched my step-in to Inside, smashed a 4-damage `Rear uppercut` under my high rear hand in moment 2, and then his faster moment-3 `Lead hook` landed first for -3 and *stopped* my Overhand. In a single beat a cruising 2–0 lead turned into a 4/18-health survival scramble. Best shock of the playtest.
2. **Bout 3, Round 2, Beat 6 — Punished for autopiloting clinch:** Up 4–2 on the final beat of Round 2, I lazily pressed `clinch` expecting a free 10–9. The Body Snatcher fired `1 Push off, 2 Step in, 3 Rear uppercut`—shoved my clinch off to Mid, immediately marched back Inside, and cracked me for -4 to steal a `10-10` round at the bell. That single beat instantly made the whole bout feel dangerous.
3. **Bout 2, Round 2, Beat 5 — Every mechanic clicking in one sequence:** From Mid I threw `1 Step in, 2 Feint, 3 Cross` against his `1 Step in, 2 Lead hook`. Because my Cross was scheduled for moment 3, my rear hand stayed home in moment 2 during my Feint, blocking his Lead hook and turning my uncoverable moment-3 Cross into a `-4` counter. That is Ring Switches at its absolute peak: footwork, moment order, active-hand guard, feint, and counter bonus all resolving cleanly in three lines.

### Three Dullest Moments
1. **Bout 2, Round 2, Beats 4 & 6 (and Round 3, Beats 3 & 5) — Uncontested clinch farming:** Clicking `clinch` at Inside against The Slugger gave me `+2` stamina, zero risk, zero ground given, and a reset to Mid every single time (5 for 5 in Bout 2). By the second half of Bout 2, Inside stopped feeling scary and started feeling like a free pit stop.
2. **Bout 1, Round 1, Beat 1 & Bout 3, Round 1, Beat 1 — The dead Long-range opener:** Both bouts started with me stepping in to throw a rear punch and the opponent firing `1 Jab, 2 Back off`, so my punch whiffed at Long and beat 2 started right back at Long with nothing meaningfully moved forward.
3. **Bout 2, Round 1, Beat 5 & Bout 3, Round 2, Beat 5 — Single punch into a static rest:** Throwing one punch (`Lead uppercut` / `Lead hook`) into `1 Step in - lead low, rear low` or `no action - lead high, rear high`, getting cleanly blocked, and watching the opponent refill stamina with zero counterplay or guard chip. One dry line of output and a wasted beat.

### Beats That Felt Unfair or Could Not Be Explained from What Was Shown
- **The Feint contradiction (Bout 1, R3 B1 & Bout 3, R1 B2):** In Bout 1 R3 B1, The Jabber threw `1 Feint, 2 Step in, 3 Cross`. The combat log explicitly printed `moment 1 HE: feints - the next punch cannot be covered`, yet in moment 3 his Cross was **blocked** by my returning lead hand. The exact same thing happened to The Body Snatcher in Bout 3 R1 B2 (`1 Feint, 2 Step in, 3 Body cross`—blocked by my lead hand held low). The help text says *"the punch you throw in the next moment cannot be covered"*, whereas the log says *"the next punch"*, and the AI itself keeps burning stamina on `1 Feint, 2 Step in, 3 Punch` as if it thinks Feint lasts until moment 3.
- **Undocumented shoved-off guard (Bout 1, R2 B5; Bout 3, R2 B6 & R3 B2):** When `Push off` broke my clinch, my hands were silently locked to high/high (`your lead hand was held high` / `your rear hand was held high`), eating clean Body crosses and a Rear uppercut without the help text ever saying what guard a broken clinch leaves you in.
- **No 10–8 on knockdowns (Bout 1, R2; Bout 2, R3 B6):** In Bout 2 R3 B6 I got knocked down by a 1-damage Body jab and lost the round points `2-10`, yet the judges still scored it `9-10`, handing me a 29–28 win. Nothing in the help explains how round points map to 10-point-must cards, and a knockdown not swinging a round to 10–8 robbed Round 3 of real scorecard peril once I was up 20–18.
- **Phantom `guard 6/6` (all 51 beats):** Shown every beat, never explained, never moved.

### Is "Which Line Is Open" a READ Now, or Still a Coin Flip?
**Half-read, half-coin-flip—and the real reads come from stamina and active-hand timing, not static guard history.**
- **Where the new history/round counts genuinely paid off:**
  - *Reading active hands and speed windows:* Seeing The Jabber repeatedly lead with his rear hand (`Cross`) let me call `1 Lead hook - rear high` on Bout 1 R1 B5 and R1 B6, beating and stopping his Cross twice in a row into his busy rear hand. Seeing The Body Snatcher hold `lead low` behind `1 Step in, 2 Body cross` let me punish his straight line twice in Bout 3 R1 B3–B4.
  - *Reading rest habits and low stamina:* Knowing an opponent had only 1–2 stamina let me mathematically rule out heavy bursts (Bout 1 R1 B4; Bout 2 R2 B3; Bout 3 R3 B3 & B6). In Bout 2 R2 B3, The Slugger had rested `low/low` twice earlier in the bout, so calling `1 Lead hook` into his 2-stamina rest beat cashed in cleanly for -3.
- **Where it stayed a coin flip:** When an opponent actually parked a hand on guard, their high-vs-low choice repeatedly flipped right against long samples: The Jabber held lead high **0 times in 11 beats**, then suddenly held `lead high` to block my Cross in Bout 1 R2 B4; The Slugger held lead high **0 times in 13 beats**, then held `lead high` to block my Cross in Bout 2 R3 B2; The Body Snatcher held rear high **0 times in 10 beats**, then rested `high/high` to block my Lead hook in Bout 3 R2 B5.
- **The hidden structural read:** A punching hand automatically returns to **high** guard on non-punch moments (`his rear hand was back up` in Bout 1 R1 B2; `his lead hand was back up` in Bout 3 R1 B2). That means body shots (`bjab`, `lbody`, `rbody`) and uppercuts (`lup`, `rup`) reliably slip under active hands without guessing, while `Feint` lets you skip reading lines entirely.

### A Plan That Is Right Almost Every Beat / Switches Never Wanted / Range Worth Nothing
- **The "always right" plan:** From Mid (with 4+ stamina), **`1 Step in, 2 Feint, 3 Cross` (or `Overhand` for lethal)** followed on the next beat by **`clinch`** from Inside.
  - Moment 1 `Step in` beats `Back off` (guaranteeing range) while keeping *both* hands high to block openers and earn a +1 counter. Moment 2 `Feint` keeps your rear hand high against moment-2 hooks/overhands (Bout 2 R2 B5; Bout 3 R2 B2) while making moment 3 uncoverable. Then Inside `clinch` refills `+2` stamina, avoids guard guesses, drains whatever stamina the opponent spent (Bout 3 R2 B3: he dropped 4→3 while I rose 4→6), and resets to Mid so `"not twice running"` never even slows you down (used repeatedly in Bout 2 R2 B4–B6, R3 B3–B5 and Bout 3 R2 B2–B6).
  - At Inside when short on stamina (2–3 stam), **`1 Lead hook - rear high`** is the stamina-neutral default bully: fast enough to stop Cross/Body cross/Overhand (Bout 1 R1 B5–B6, R2 B6), reaches Mid if he backs off, and protects the side line.
- **Switches I never wanted:**
  - `jab` (**0 uses in 51 beats**): Costs the same 1 stamina and scores the same 1 damage / 1 point as `bjab`, except `jab` hits the straight line that every active lead hand defaults to guarding, while `bjab` went 3-for-3 (Bout 1 R1 B2, R2 B1, R3 B1).
  - `push` (**0 uses in 51 beats**): None of the three opponents clinched once, and for resetting Inside to Mid, `clinch` stops all punches *and* gives +2 stamina instead of costing 1.
  - `rup` (**1 use, blocked in Bout 2 R1 B2**): Slow, 3 stamina, Inside-only—too easy to whiff or get interrupted compared to `Overhand` (Mid+Inside, same cost/damage) or `Feint + Cross` (Mid+Inside, medium speed, uncoverable). `lup` (2 uses, 0 hits: Bout 2 R1 B5, R2 B1) suffers the same Inside-only fragility next to `hook`.
  - `feet=back` (**only 3 uses**, all in Round 3 clock-killing: Bout 2 R3 B6; Bout 3 R3 B4 & B6): Because `Step in` overrides `Back off` and still closes a range step (Bout 1 R2 B4; Bout 3 R3 B4) while `Back off` ticks ground toward the ropes, backing off never felt like a real boxing tool—only a last-beat stall.
- **Range where nothing is worth doing:** **Long.** Only 1-damage jabs reach, knockdowns cannot be threatened, and every round's beat 1 is just a stamina tax to leave Long (Bout 1 R1 B1, R2 B1, R3 B1; Bout 2 R1 B1, R2 B1, R3 B1; Bout 3 R1 B1, R2 B1, R3 B1). Even The Jabber stepped out of Long on beat 1 of Rounds 2 and 3.

### Each Opponent: Different Men? Difficulty? Does Reading Pay?
- **The Jabber (16 HP) — Too easy, ~65% on-archetype:** He did back off far more than the others (7 times in 15 beats) and poked with Jabs/Crosses, so reading his rear-hand Crosses in Bout 1 R1 B5–B6 paid handsomely. Yet he broke character repeatedly—stepping in from Long to throw an Overhand (R1 B2), brawling Inside with `Body hook + Body cross` (R2 B1), and firing a `Lead uppercut` Inside (R2 B2)—and wasted stamina on punchless/broken Feints (R1 B3, R3 B1, R3 B3). At 16 HP, once cornered by `Feint + Overhand`, he folded by R3 B3.
- **The Slugger (21 HP) — Most distinct, scary burst, but too abusable:** He genuinely felt like a heavy-handed stalker—marching forward 9 times in 18 beats, tanking shots with 21 HP, and nearly turning Bout 2 around with his ferocious `1 Step in, 2 Rear uppercut, 3 Lead hook` (R3 B1). Reading his stamina crashes paid off (R2 B3). Still, he never threw `Push off` once against 5 clinches, wasted stamina on `1 Step in` while already Inside with no punch three times (R1 B2, R1 B5, R3 B2), threw a punchless `2 Feint` (R3 B5), and weirdly ran `1 Body jab, 2 Back off` on R3 B6 (accidentally scoring a hilarious 1-HP knockdown).
- **The Body Snatcher (18 HP) — Best tactical threat once Inside, slightly muddled opener:** He was the toughest and most interesting test because his `Body cross` crushed my stamina cap down to the 4/4 floor by Bout 3 R3 B2, and his two anti-clinch `Push off` sequences (R2 B6, R3 B2) actually punished my clinch habit! Reading his low-lead Body cross pattern paid in R1 B3–B4. Still, he opened Bout 3 R1 B1 with The Jabber's exact `1 Jab, 2 Back off`, never once threw a `Body hook` (`lbody`), and fired a broken `1 Feint, 2 Step in, 3 Body cross` in R1 B2.

### Rounds 2–3 vs Round 1, Knockdowns, the Ropes, and the Stamina Bar
- **Rounds 2 & 3 vs Round 1:** **Big yes—this is one of the game's best qualities.** Carry-over health and shortened stamina caps give each bout a genuine 3-act arc. Round 1 is probing and body investment; Round 2 is knockdown math (`4/16` HP -> hunt `Overhand` in Bout 1 R2 B2); Round 3 becomes either a stoppage chase (Bout 1 R3 B1–B3) or white-knuckle 1-HP survival (Bout 2 R3 B4–B6; Bout 3 R3 B2–B6).
- **The stamina bar:** **MVP mechanic.** Permanent body-shot shortening completely changed my legal move tree—by Bout 3 R3 B2 my `4/4` cap locked me out of `1 Step in, 2 Feint, 3 Overhand` (cost 5) and forced pure defense. Beat-to-beat stamina tracking was also the sharpest, fairest read in the game (Bout 1 R1 B4; Bout 2 R3 B2; Bout 3 R3 B3 & B6).
- **Knockdowns:** **Half-working.** Chasing or preventing the 3rd knockdown (Bout 1 R3 B2–B3) and surviving at 1 HP to avoid a round-swinging knockdown (Bout 3 R3 B2–B6) created peak tension, but without 10–8 rounds, taking a knockdown in Bout 2 R3 B6 still didn't cost me the decision.
- **The ropes:** **Zero impact.** Ground given reset on step-ins and between rounds and never hit `2/2` once in 51 beats.

---

## 3. SCORES

FUN: 7/10 — Strong boxing tension, speed interrupts, and Round 3 drama, dragged down by repeatable `Feint -> clinch` looping and dead Long-range beats.
DEPTH: 7/10 — Stamina counting, permanent stamina erosion, and moment-order guard windows are legitimately deep, but `clinch` and `Feint` bypass guard reads while several switches and the ropes stay inert.
CLARITY: 6/10 — The new history strip, round hand counts, and point/stamina callouts help a lot, but `guard 6/6` is unexplained and dead, Feint's log contradicts its rule, and broken-clinch guard / card math are hidden.
VARIETY: 6/10 — Attrition creates great round-to-round arcs, yet Long range is a throwaway beat, opponents share generic wasted habits, and the same Mid/Inside gameplan beat all three.

**What I could NOT judge from words:**
- Tactile feel, switch-selection speed, and whether choosing three switches plus an order feels snappy or fiddly in the browser UI.
- Visual telegraphing and impact juice (whether speed-stops, blocks, feints, and knockdowns *feel* visceral in motion, and whether body/under vs straight/side lines read intuitively on silhouettes).
- Time pressure and cognitive load on a live player—playing turn-by-turn in text let me run exact stamina-and-guard math every beat, which makes optimal loops easier to spot and exploit than they might be at real play speed.

---

## 4. TO REACH 10/10

1. **Rebalance `clinch` so it is emergency survival, not a stamina-positive reset engine** *(tied to Bout 2 R1 B3/B6, R2 B4/B6, R3 B3/B5 vs Bout 3 R2 B6 & R3 B2)*:
   - Make `clinch` net **0 stamina** (or grant `+1` to *both* fighters and refund any punch stamina the opponent didn't get to throw) instead of giving you `+2` while draining his committed beat.
   - Add a **referee warning / point penalty** (e.g., 2nd clinch in a round gets a warning, 3rd costs 1 point or 1 ground given), and widen anti-clinch AI weights so every opponent—especially The Slugger—starts throwing `Push off` once you clinch twice.
2. **Add real counterplay to `Feint` and fix the Feint log + AI bug** *(tied to Bout 1 R1 B3, R3 B1, R3 B3; Bout 2 R2 B5, R3 B4–B5; Bout 3 R1 B2, R2 B4)*:
   - If the opponent lands a punch during your `Feint` moment (like Body Snatcher's moment-2 Body cross in Bout 3 R2 B4 or Slugger's moment-2 Cross in Bout 2 R3 B4), **interrupt and cancel the Feint** (`feint stuffed!`) so `1 Step in, 2 Feint, 3 Bomb` cannot blindly trade through pressure for guaranteed uncoverable damage.
   - Change the combat log text from *"the next punch cannot be covered"* to *"your punch in moment X cannot be covered"* and patch the AI so it never queues a Feint without an immediately following punch in moment+1.
3. **Make `Long` range, `Back off`, `Jab`, and the ropes actually matter** *(tied to Bout 1 R1 B1, R2 B4; Bout 2 R3 B6; Bout 3 R1 B1, R3 B4)*:
   - When one fighter chooses `Step in` and the other chooses `Back off` in the same moment, **cancel into the current range** (hold distance) instead of still closing a step, and make `ground given` carry over across the beat cleanly so backing off twice actually puts you on the ropes (`2/2` = cannot back off, take +1 damage on landed hits).
   - Give `Jab` a distinct Long/Mid identity over `Body jab`: e.g., a landed `Jab` **halts a same-moment `Step in`** (stick-and-move!) or cancels a `Feint`. Suddenly Long range is a real fight to enter, `Jab` beats `Body jab` in a real job, and The Jabber feels like a true out-boxer.
4. **Either wire `guard 6/6` into a real guard-break mechanic or remove it from the HUD** *(tied to all 51 beats, especially zero-value block beats like Bout 2 R1 B5 and Bout 3 R2 B5)*:
   - Recommended: make blocked heavy punches (`Overhand`, `Rear uppercut`, `Cross`, `Lead hook`) chip `guard` by 1–2 (refilling slowly on rest/rounds). At `0/6` guard, the next blocked punch breaks through for half damage or +1 stun—instantly making static resting risky and rewarding pressure even on a blocked read. If not desired, delete `guard 6/6` from the display.
5. **Make knockdowns score 10–8 rounds and document hidden rules** *(tied to Bout 1 R2, R2 B5; Bout 2 R3 B6; Bout 3 R2 B6, R3 B2)*:
   - Award a **10–8 round** whenever a fighter wins the round *and* scores a knockdown (or wins by 5+ points), so a 20–18 leader going into Round 3 can still lose the decision if dropped at the bell (instead of winning 29–28 after getting knocked down in Bout 2 R3 B6).
   - Add one line to the help text explaining 10-point-must scoring, what guard a shoved-off clinch leaves you in, and that an active punching hand defaults to high guard on its non-punch moments.
6. **Clean up AI waste beats and sharpen opponent guard/style tells** *(tied to Bout 1 R2 B1–B2, R2 B4; Bout 2 R1 B2, R1 B5, R3 B2; Bout 3 R1 B1, R2 B5)*:
   - Ban illegal/pointless AI plans: never `Step in` while already Inside with no punch, never `Feint` without an immediate follow-up punch, and stop giving The Body Snatcher The Jabber's Long opener (and give him `Body hook` in his mix!).
   - Give each opponent a stronger, readable resting-guard bias (e.g., Jabber favors high/high, Body Snatcher favors low/high, Slugger favors aggressive two-handed beats and leaves straight/under open) rather than flipping arbitrarily on beat 11+, and let at least one opponent clinch when hurt so player `Push off` has a reason to exist.
7. **Give `rup`, `lup`, and `push` payoffs worthy of their constraints** *(tied to Bout 2 R1 B2, R1 B5, R2 B1; 0 `push` uses across all 3 bouts)*:
   - Give `Rear uppercut` a true Inside haymaker payoff (e.g., 5 damage, or +2 guard chip / ignores counter penalty) so it beats `Overhand` Inside; let `Push off` also **shove back and disrupt a slower moment-1 punch** (or drain 1 opponent stamina) so it earns a slot even when the AI isn't clinching.

REPORT END

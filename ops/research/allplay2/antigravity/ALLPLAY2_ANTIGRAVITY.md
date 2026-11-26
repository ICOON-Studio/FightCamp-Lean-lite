# ALLPLAY2 - antigravity (played by message, driver ops/Tools/play_by_message.mjs, S558)

# ALLPLAY2_ANTIGRAVITY.md

## VERDICT

**Show ONE physical body tell before each beat (Option B) — NOT the opponent's full plan (Option A), and NOT nothing (Option C) — but fix the lie frequency, AI tell-awareness, and `Feint -> Overhand` before shipping it.**

Ring Switches has a genuinely clever boxing core: choosing *moment order* (1, 2, 3) alongside hand lines and footwork creates awesome tactical puzzles where a waiting hand blocks moment 1 before punching in moment 2. I went **4–0** across the playtest (Bout 1: Jabber no tells, 28–27 decision; Bout 2: Body Snatcher no tells, R3B6 stoppage; Bout 3: Jabber tells on, R3B1 stoppage; Bout 4: Body Snatcher tells on, R3B2 stoppage).

Without tells, guessing *which of 4 guard lines* is open on any given beat felt too often like a coin flip — pushing me to bypass the guard puzzle altogether with `Step in -> Feint -> Overhand` (which landed **12 of 13 times** across all four bouts and scored all three knockouts). With tells ON, the game immediately felt more like real boxing — reading a dropped rear shoulder or bent knees to time a fast hook, uppercut, or pull-counter was a blast — **except 26 of 27 tells were true (0 fakes in Bout 3, 1 fake in Bout 4)** and the AI did not know I could see them, turning both tells-on bouts into quick, solvable blowouts. Keep the single body tell, make each fighter lie often enough to learn and bait the player (~25–30%), and nerf `Feint` so you actually have to play the guard game.

---

## NOT SURE

- **The Slugger (Opponent 1):** My 4-bout chat playtest matched me only against The Jabber and The Body Snatcher. I cannot say whether The Slugger's 21 health and two-handed aggression punish `Feint -> Overhand` or make Guard breakage matter.
- **The Jabber's fixed lie rule:** All 13 tells in Bout 3 were true (0 fakes), so I never saw his lie trigger and cannot judge how fun or readable his rule is.
- **The Body Snatcher's exact lie rule:** I saw only one fake in 14 beats (Bout 4 R2B1 at Long: `"knees bend"` faking `"front foot creeps"` on `1 Step in, 2 Lead hook`). One data point is not enough to know whether his rule is "Beat 1 of Round 2+", "at Long", "whenever throwing Lead hook", or "when behind on cards".
- **What `ON THE ROPES` actually does mechanically:** Fighters hit `ground given 2/2 ON THE ROPES` multiple times (Bout 1 R1B5–6, R3B5–6; Bout 2 R3B3), yet no movement lock, damage penalty, or guard penalty ever appeared in the logs.
- **Whether Guard 6/6 can ever break:** Guard stayed `6/6` for both fighters across all 63 beats because blocking a big punch costs 1 guard and +1 regenerates every beat; I am not sure if any opponent ever throws double big punches into a double block often enough to drain it.
- **How tells feel visually vs. as text:** Reading `"his rear shoulder drops back"` in plain English is effortless; spotting an animated posture tell on a live fighter could make even an 85%-true tell feel much tighter and less "solved" than it did in text.

---

## 2. JUDGING IT ON FUN

### Three best moments, three dullest moments, and one unfair/unexplainable beat

**Three best moments:**
1. **Bout 2, R3B6 (Walk-off pull-counter KO):** At Inside on the final beat with 4/18 health against Body Snatcher (down 2x, 4/18 health), I read his Inside offense and called `1 Back off, 2 Feint, 3 Overhand`. His `1 Lead uppercut` fell short at Mid, I ate a moment-2 Body cross during the feint, and my moment-3 Overhand landed as both a counter and a pull-counter for **-6 health** and the stoppage.
2. **Bout 1, R1B2 (The waiting-hand trap):** At Inside, I queued `1 Feint, 2 Overhand`. Because my Overhand waited until moment 2, my rear hand stayed high in moment 1 to **block his moment-1 Overhand**, unlocking the counter bonus so my feint-drawn Overhand smashed his back-off at Mid for **-5 health**. Discovering that punch order is also defensive timing was the highlight of the ruleset.
3. **Bout 3, R2B6 (Clean tell-read counter knockdown):** With Jabber at 3/16 health showing `"his rear shoulder drops back"`, I deduced his rear hand had to throw (leaving `under` open) and called `1 Rear uppercut - lead hand high`. My lead hand cleanly blocked his moment-1 Cross and my Rear uppercut countered for **-5 health** and a knockdown at the bell to lock in a 10–8 round. (Close runner-up: **Bout 4, R3B1**, both fighters at 2/18 health at Long, reading his shoulder drop and calling `1 Step in, 2 Lead hook - rear hand high` to beat his moment-2 Cross to the punch for a 0-damage knockdown.)

**Three dullest moments:**
1. **Bout 1, R3B3–R3B6 (Stalling out the clock):** Up 20–17 on the cards with 4/18 health and a shortened 4/4 stamina bar, the winning line was four straight beats of doing nothing and backing away (`no action` vs `no action` in R3B3, `Back off` vs `Back off` in R3B4, `Body jab, Back off` already at Long in R3B5, `no action` double-high in R3B6) to coast to a 28–27 decision.
2. **Bout 2, R3B1–R3B2 (AI whiffing at Long):** Body Snatcher threw `1 Back off, 2 Body cross, 3 Body jab` at Long (backing off into nothing, whiffing Body cross at Long, tapping my low guard) and then `1 Body cross, 2 Back off, 3 Body jab` — burning 6 stamina across two beats for 0–0 points.
3. **Bout 4, R1B4–R1B5 (Dead beats Inside):** In R1B4 he showed `"front foot creeps"` while already Inside and threw a lone `1 Step in` into nothing while I rested; in R1B5 my Lead hook hit his waiting rear hand and his Cross hit my returned lead hand — two consecutive beats with zero damage and zero drama.

**Unfair / unexplainable beat:**
- **Bout 1, R3B2:** At Inside with 1/4 stamina, I chose `clinch`. Jabber queued `1 Body cross, 2 Back off, 3 Push off`. The game resolved: `YOU: tries to clinch - shoved off`, then let his moment-1 Body cross hit me clean for -2 health, then he backed off to Mid in moment 2, and then in **moment 3** logged `HE: pushes off - a shove at nothing: it only works chest to chest, and you were not Inside`. A moment-3 Push off that *whiffed at nothing* retroactively cancelled my clinch before moment 1 and left me standing defenseless. Nothing in the rules or timeline explains how a move that never happened in moment 3 stopped a clinch in moment 1.

### Is "which line is open" a READ or a coin flip?

- **Without tells: mostly a coin flip on any single beat, with a thin macro read.** You can read stamina caps reliably (e.g., Bout 2 R2B3 & R2B5 when he sat at 1/7 stamina) and occasionally exploit persistent guard habits (in Bout 2, noticing Body Snatcher held `lead high` 0 times in 15 beats let me land Crosses in R2B5 and R3B4, and holding `lead=low` blanked his body shots in R1B1, R1B2, R2B1, R3B1–2). But on a normal 4+ stamina beat, guessing the exact line is a blind guess: in **Bout 2 R2B4**, Body Snatcher had 4 stamina Inside, I guarded double-low against his body/uppercut pattern, and he threw `1 Lead hook, 2 Cross` to hit both of my open lines for -6 health. In **Bout 1 R2B2**, my Lead hook hit his waiting rear hand while his moment-3 Lead uppercut nailed my open `under` line for -4. Because single-beat line guessing is so noisy without tells, the optimal play is to stop guessing lines and spam `Feint` to erase his guard.
- **With tells: a genuine READ — often too clean of one.** Seeing `"his rear shoulder drops back"` tells you his rear hand is punching (so `side` or `under` will be open unless it waits in moment 1, as in Bout 4 R1B5), and seeing `"he bends his knees"` lets you shut down both body and uppercut lines with `Back off` + `lead=low` (Bout 3 R1B3; Bout 4 R1B2, R1B6) or double-low rest (Bout 4 R2B5). Because the tell does *not* reveal moment order or the other hand, it stays a read rather than a full spoiler — *when* lies exist to keep you honest.

### A plan right almost every beat, switches never wanted, and a dead range

- **Plan right almost every beat:** `Step in -> Feint -> Overhand` (with `Feint -> Cross` when at 3–4 stamina, or `Back off -> Feint -> Overhand` as an Inside closer). Across all 4 bouts I used a Feint-into-Rear-Punch plan **13 times and it landed 12 times (92.3%)** — scoring the fight-ending KO in every single stoppage win (**Bout 2 R3B6, Bout 3 R3B1, Bout 4 R3B2**) and huge damage throughout (**Bout 1 R1B2–3, Bout 2 R2B3 & R3B3, Bout 3 R1B1, R1B4, R2B1–2, Bout 4 R1B3 & R2B6**). The only time it failed was **Bout 1 R3B1** when I entered the beat on 3 health and got knocked down before moment 3 fired. `Step in` beats `Back off` while keeping both waiting hands high to snag counter bonuses; `Feint` costs only 1 stamina and deletes the 4-line guard puzzle completely (even if you get punched *during* the feint, as in Bout 3 R1B1, R2B1, R3B1 and Bout 4 R2B6); and `Overhand`/`Cross` reaches both Mid and Inside. Rotating between `Overhand` and `Cross` or resting once easily dodges the habit reader.
- **Switches I never wanted (0 uses in 63 beats):**
  - `jab` (0 uses): 1 stamina for 1 damage/1 point, blocked by default high guard, smothered Inside. For the exact same 1 stamina, `feint` guarantees a 4-damage Overhand.
  - `lbody` / Body hook (0 uses): identical cost, damage, speed, reach, and bar-shortening effect as `rbody` (Body cross), except throwing `lbody` ties up your lead hand (which you want holding `low` against body shots or throwing fast `hook`/`feint`).
  - `push` / Push off (0 uses): Inside only, 1 stamina, 0 damage, 0 points, consumes your lead hand. `Back off` works at any range, leaves both hands free, and adds +1 pull-counter damage.
- **Range where nothing is worth doing:** **Long range.** Only `jab` and `bjab` reach (1 damage, 1 point), so nobody can threaten knockdowns or body-bar damage. Almost every Round 1/2/3 opener immediately `Step in`s out of Long (Bout 1 R1B1, Bout 2 R1B1/R2B1, Bout 3 R2B1/R3B1, Bout 4 R1B1/R3B1), and Long is otherwise only useful for stalling out a card lead (Bout 1 R3B4–6).

### Each opponent: different men? Too hard/easy? Does reading pay?

- **Different men? Only faintly.** The Jabber's description promises `"Stays at Long behind the jab and backs off when you come in."` Yet in **Bout 1 R1B1** at Long he immediately did `1 Step in, 2 Body hook, 3 Cross`, threw only **2 Jabs** in 18 beats (R3B5–6), and landed so many body hooks/crosses that he chopped my stamina bar all the way down to **4/4**! In **Bout 3**, he threw only 2 Jabs (R1B1, R1B4) and brawled Inside with Crosses and Lead uppercuts. The Body Snatcher matched his identity much better in **Bout 2** (11 body punches in 18 beats, consistent `lead low` rest guards), but in **Bout 4** he threw Lead hooks, Rear uppercuts, Crosses, and even a naked `Step in, Feint` (R3B2) and landed only 1 body punch all fight (R2B6).
- **Difficulty:** **Too easy** once you learn stamina tracking and `Feint -> Overhand/Cross`, especially with tells ON (4–0 overall; never knocked down once in Bouts 2, 3, or 4). Both opponents also undermined themselves with illegal/wasted AI beats: `Back off` followed by `Push off` at Mid (Bout 1 R3B2, Bout 2 R1B6, Bout 3 R1B3 & R2B3), `Step in` while already Inside (Bout 2 R2B5, Bout 3 R2B2, Bout 4 R1B4–5 & R3B2), `Back off` at Long (Bout 2 R3B1), and `Feint` with no follow-up punch (Bout 4 R3B2).
- **Does reading pay?** Reading **stamina** pays enormously (Bout 1 R1B3, Bout 2 R2B3/R2B5/R3B3, Bout 4 R3B2). Reading **round hand tendencies** paid strongly in Bout 2 (catching Body Snatcher's zero `lead high` usage in R2B5 and R3B4). Reading **tells** paid *too* reliably in Bouts 3 and 4.

### Rounds 2 & 3 vs. Round 1; knockdowns, ropes, stamina bar

- **Rounds 2 & 3 play meaningfully differently from Round 1:** Round 1 is stamina-bar investment and card-building; Round 2 is converting damaged health pools into 1st/2nd knockdowns; Round 3 splits cleanly into either a sudden-death KO hunt when he is down 2x on 4 health (Bout 3 R3B1, Bout 4 R3B1–2) or pure defensive card protection (Bout 1 R3B3–6).
- **Knockdowns:** Huge, great impact. Coming up on 6 then 4 health with a 3rd-knockdown stoppage rule completely reshapes beat selection (hunting a single 4-damage Overhand on Bout 3 R3B1 and Bout 4 R3B2; instantly flipping from aggressor to survivor after getting dropped in Bout 1 R3B1).
- **Stamina bar:** Huge, great impact. Permanent bar shortening from body shots changed entire fights — getting chopped to 4/4 in Bout 1 locked me out of 5-stamina `Step in -> Feint -> Overhand` combos in Round 3, while protecting my 8/8 bar in Bout 2 gave me total tempo control.
- **The Ropes (`2/2 ON THE ROPES`):** Zero noticeable effect. Being on the ropes in Bout 1 R1B5–6, R3B5–6 and Bout 2 R3B3 never prevented a play or changed my decision.
- **Guard (`6/6`):** Zero effect. Never dropped below 6/6 in 63 beats.

### WITH TELLS: follow them? Find each man's lie? Good feeling or solved sum?

- **Did I follow them?** Constantly — almost every beat in Bouts 3 and 4 pivoted on the tell (staying put at Long on `"front foot creeps"` in Bout 3 R1B1; backing off behind `lead=low` on `"knees bend"` in Bout 3 R1B3 and Bout 4 R1B2/R1B6; interrupting `"rear shoulder drops"` with fast `Lead hook` in Bout 3 R1B5/R2B5 and Bout 4 R3B1 or sneaking an uppercut under his thrown rear hand in Bout 3 R2B6 and Bout 4 R2B4; resting double-low on `"knees bend"` in Bout 4 R2B5).
- **Did I find each man's lie?**
  - **The Jabber (Bout 3): NO.** All **13 of 13 tells were true (0 fakes)** before the R3B1 stoppage.
  - **The Body Snatcher (Bout 4): CAUGHT 1 FAKE, NOT ENOUGH TO PROVE THE RULE.** In **Bout 4, R2B1 (at Long)**, he showed `"he bends his knees and his level drops"` and actually threw `1 Step in, 2 Lead hook - rear hand low` (true tell: `"front foot creeps"`), stopping my Body cross for -3 health. The other 13 beats of Bout 4 were all true.
- **Did catching a lie feel good, or did tells turn a beat into a sum with one right answer?** Both — and that contrast tells you everything. On **Bout 4 R2B1**, getting burned by the fake level-drop felt awesome and immediately made **R2B2–R2B6** far more tense because I had to hedge against *both* his true tell and his `Step in -> Lead hook` lie (see my hedged `Back off, Lead hook, Body cross` in R2B2 and `Step in, Lead hook - rear hand high` in R3B1). Every other beat across Bouts 3 and 4, however, leaned toward a **one-answer math sum** because 26/27 tells were true (96.3%) and the AI never reacted to me exploiting them.

---

## 3. THE OWNER'S QUESTION: SHOULD THE GAME SHOW THE OPPONENT'S INTENTION?

### (a) His whole plan shown before you choose (Slay the Spire style) — NO
- **Beat that proves it:** Look at **Bout 3 R2B6** (`HE: 1 Cross - lead hand low`) or **Bout 4 R2B5** (`HE: 1 Body cross, 2 Push off`). Even with just a partial tell, I neutralized both beats cleanly. If I saw his exact full sequence before choosing (including **Bout 4 R2B1** `1 Step in, 2 Lead hook - rear hand low`), every beat would become a 100% solved deterministic check: block his exact punch moments, hit his exact open lines, take 0 damage, win effortlessly. Card games can show full enemy intent because a random hand of cards restricts what answers you hold. In Ring Switches, you have your **entire moveset** every beat; full intent removes all bluffing, reading, and boxing feel.

### (b) One body tell, usually true (as in tells-on) — YES, PICK THIS ONE
- **Beats that prove it:** **Bout 4 R1B2** (reading `"knees bend"` Inside to pull-counter his whiffed Rear uppercut with a -4 Body cross), **Bout 4 R1B5** (his `"rear shoulder drops"` was true, `1 Step in, 2 Cross`, yet his moment-1 waiting rear hand *still* blocked my moment-1 Lead hook — proving a body tell informs your read without spoiling his moment timing!), and **Bout 4 R2B1–R2B2** (getting caught by his fake level-drop on R2B1 and having to hedge on R2B2).
- **Why this wins:** A real boxer doesn't read a spreadsheet of the opponent's full 3-beat script, and he doesn't box blindfolded either — he watches the shoulder dip, the knees bend, the front foot creep, and knows the opponent can feint those cues. One physical tell shrinks a chaotic 4-line × 3-moment × 3-range coin flip into a real boxing read while preserving hidden moment order, hidden second hand, and mind-games.
- **What must change for (b) to work:**
  1. **Raise the lie rate to ~25–30% on clear, learnable rules** so a player actually encounters 2–4 lies inside an 18-beat bout (unlike 0/13 in Bout 3 and 1/14 in Bout 4).
  2. **Close the feedback loop:** Make the AI aware of its own tells and of your responses — if you repeatedly fast-hook his shoulder drop (Bout 3 R1B5 & R2B5), he should either delay the Cross to moment 2 behind a waiting rear guard (as accidentally worked in Bout 4 R1B5) or flash his fake tell to trap your hook.
  3. **Fix impossible tells:** Never show `"his front foot creeps forward"` when he is already Inside and stepping into air (Bout 4 R1B4 & R3B2).

### (c) As it is now (last 3 beats + round hand counts, nothing about the beat to come) — SECOND PLACE, NOT ENOUGH
- **Beat that proves it:** **Bout 2 R2B4** (Body Snatcher at Inside with 4 stamina; his prior beats pointed to body/uppercut, so I guarded double-low and ate `1 Lead hook, 2 Cross` for -6 health) and **Bout 1 R2B2** (eating a moment-3 Lead uppercut for -4 after guessing rear-high). Without any cue about the incoming beat, past-beat history isn't predictive enough on individual lines, which nudges smart players away from reading guards and straight into `Feint -> Overhand` spam.

---

## 4. SCORES (1 TO 10)

**NO TELLS (Bouts 1 & 2):**
- FUN: 7/10 — Moment-order mind-games and waiting-hand blocks feel great (Bout 1 R1B2, Bout 2 R3B6), held back by blind line guesses and late-round stalling.
- DEPTH: 7/10 — Strong tactical bones (order, speed interrupts, pull-counters, stamina-bar shortening), undercut by `Feint -> Overhand` dominance and dead Guard/Ropes mechanics.
- CLARITY: 6/10 — Moment logs explain blocks and counters well, but moment-3 Push off cancelling a clinch (Bout 1 R3B2) and inert Guard/Ropes stats confuse what matters.
- VARIETY: 5/10 — Both tested opponents felt too alike (Jabber brawling Inside with body shots), Long range is empty, and `jab`, `lbody`, and `push` had zero use.

**WITH TELLS (Bouts 3 & 4):**
- FUN: 7.5/10 — Making real boxing reads off shoulder/knee cues feels awesome (Bout 3 R2B6, Bout 4 R1B2 & R3B1), though 26/27 true tells made both fights too quick and easy.
- DEPTH: 6.5/10 — Tells turn coin flips into real reads, but at 96% honesty with an oblivious AI too many beats collapse into a solved sum; proper lie rates and adaptation would push this past 8.5.
- CLARITY: 8/10 — The four physical tells and post-beat/bell feedback are crisp and intuitive, aside from wasted `"front foot creeps"` tells at Inside (Bout 4 R1B4).
- VARIETY: 5.5/10 — Tells rewarded dusting off `Lead uppercut`, `Rear uppercut`, and `Back off`, yet `Feint -> Overhand` still closed both bouts and fighter identities remained blurry.

**What I could NOT judge from words:**
- Visual readability and animation craft: whether a player can actually spot a subtle shoulder drop, knee bend, or foot creep on a live fighter (which could naturally balance tells without needing text).
- Hit feel, audio, pacing, turn timer tension, and UI ergonomics of setting 3 switches + moment order with clicks/keys.
- **The Slugger** (Opponent 1), who was not in my 4-bout slate.

---

## 5. TO REACH 10/10

1. **Add real counterplay to `Feint` (stop `Step in -> Feint -> Overhand` from bypassing the guard game).**
   - *Beats:* Landed 12/13 times across all 4 bouts, ended all three stoppages (**Bout 2 R3B6, Bout 3 R3B1, Bout 4 R3B2**), and still worked even when I got punched right in the face during the feint moment (**Bout 3 R1B1, R2B1, R3B1; Bout 4 R2B6**).
   - *Build change:* Any punch that lands on a fighter during their `Feint` moment **cancels the feint** (and deals +1 counter damage). Optionally also make `Feint` draw only **held** guards (not a waiting/returned hand) or cost 2 stamina. Now `Feint -> Overhand` punishes passive shells instead of trading cleanly through active offense.

2. **Tune Body Tells to ~25–30% learnable lies and give the AI tell-awareness.**
   - *Beats:* **Bout 3** (13/13 true tells, 0 fakes -> 13-beat blowout), **Bout 4** (13/14 true tells; the single fake in **R2B1** was the best tension spike of the tells-on set), and **Bout 4 R1B4 & R3B2** (useless `"front foot creeps"` tells while already Inside).
   - *Build change:* (a) Guarantee each fighter's fixed lie rule triggers cleanly ~25–30% of beats (e.g., Jabber fakes shoulder-drop when backing off or throwing a fast Lead hook; Body Snatcher fakes knees-bend whenever he opens with `Step in -> Lead hook` or on Beats 1 & 4) so the player sees 2–4 fakes per bout and actually solves the tell by Round 2; (b) let the AI track when the player exploits the same tell twice (e.g., fast `Lead hook` into shoulder-drop in **Bout 3 R1B5 & R2B5**) and deliberately delay the punch to moment 2 behind a waiting guard or trigger its lie; (c) never emit `"front foot creeps"` when already Inside.

3. **Make Guard, `ON THE ROPES`, and Clinch-vs-Push-off actually work.**
   - *Beats:* Guard stayed `6/6` for all 63 beats (even after blocking Overhands/Crosses in **Bout 1 R1B2–3, Bout 2 R2B1, Bout 4 R1B5**); `ON THE ROPES` had no effect in **Bout 1 R1B5–6, R3B5–6 & Bout 2 R3B3**; a whiffed moment-3 `Push off` cancelled my clinch before moment 1 in **Bout 1 R3B2**.
   - *Build change:* (a) Lower Guard max to **4**, make blocking a big punch cost **2 guard** (small punch 1), and regenerate **+1 guard only on beats where you did not block a big punch** — so heavy combos crack shells and passive stalling breaks down; (b) while `ON THE ROPES` (2/2 ground), disable `Back off` and give the attacker **+1 damage (or -1 extra guard on block)** so ring control matters; (c) only let `Push off` stop `clinch` if `Push off` is in **moment 1** (never retroactively from moment 3).

4. **Eliminate nonsense AI plans and sharpen fighter personas (make The Jabber actually jab).**
   - *Beats:* Jabber opening R1B1 with `Step in, Body hook, Cross` and throwing only 2 Jabs vs. 7 body hooks/crosses in **Bout 1**; AI queuing `Back off -> Push off` (**Bout 1 R3B2, Bout 2 R1B6, Bout 3 R1B3 & R2B3**), `Step in` while Inside (**Bout 2 R2B5, Bout 3 R2B2, Bout 4 R1B4–5 & R3B2**), `Back off` at Long (**Bout 2 R3B1**), and naked `Step in, Feint` with no punch (**Bout 4 R3B2**).
   - *Build change:* Add hard legality filters to AI beat selection (forbid `Step in` at Inside, `Back off` at Long, `Push off` after `Back off`, and `Feint` without a punch in the immediately following moment). Rebuild **The Jabber** to actually fight behind `jab`/`bjab` + `Back off` pull-counters at Long/Mid rather than wading Inside to throw body hooks.

5. **Give Long range and the dead switches (`jab`, `lbody`, `push`) real tactical jobs.**
   - *Beats:* 0 uses of `jab`, `lbody`, and `push` across all 63 beats; Long range bypassed on Beat 1 of nearly every round (**Bout 1 R1B1, Bout 2 R1B1/R2B1, Bout 3 R2B1/R3B1, Bout 4 R1B1/R3B1**).
   - *Build change:* (a) Make a landed `jab` **stop a `Step in` in the same moment** (keeping the range at Long!) OR grant **+1 damage to your next punch that beat** (a true 1–2 setup) — instantly making Long range and The Jabber dangerous; (b) make `lbody` (Body hook) **fast** (or 1 stamina Inside) so it isn't strictly dominated by `rbody`; (c) make `push` cost **0 stamina** or drain **1 opponent stamina** on contact so it competes with `Back off`.

6. **Prevent passive clock-running when ahead on the cards.**
   - *Beats:* **Bout 1 R3B3–R3B6**, where holding `no action` / `Back off` at Long for four straight beats safely sealed a 28–27 win with zero interaction.
   - *Build change:* Pairing the Guard-break and Ropes fixes above with a **passivity rule** (two consecutive beats of `no action` or `Back off` without throwing gives the active fighter 1 ring-control point, or strips +1 guard) forces a leader to stay sharp and box through the final bell.

REPORT END

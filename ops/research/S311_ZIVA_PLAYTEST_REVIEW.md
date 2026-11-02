# S311 playtest review — FightCamp lean, updates 12 and 13 (Ziva, 2026-10-30)

Played `res://scenes/dev/JumpFight.tscn` (update 12) and `res://scenes/dev/JumpCorner.tscn` (update 13) live in this
editor with `run_scene`, one run at a time. Screenshots in `docs/ziva/shots/`. No game file was changed (housekeeping at
the bottom). The bout every run replays is the same one on every run — and it replayed identically every time: day 33,
Lucy Jackson (out-boxer, 3-1) vs **Maria Ortega** (southpaw, *Pressure fighter*, threat "left hook to the body", weak
"fades after round 2", rating 61.5), camp conditioning + film study, depth 3 of 3.

## 0. The run I got, and the run I could not get (read this first)

- `run_scene` kills a run at ~30 s of wall (27.4 s passed; 27.9 s, 28.4 s and 29.0 s returned
  "Playtest timed out after 30 seconds: ... the viewport never produced a frame to capture" and no screenshot).
- A played round is 180 s of ring + five 10 s shout windows = 230 s at 1x, 140 s at 2x; the intro is 18.5 s (9.3 s at 2x)
  and the corner minute is 58 s (29 s at 2x). **No single run can hold two rounds.** So the early moments were played
  live, and the later ones (a round's bars 2-5, the body-call payoffs, the gold NOW on screen) were reproduced on the
  identical rules path headless — same jump, same seeds, same picks — and every number below that I could not screenshot
  is marked "(headless log)". That is an instrument limit, not a game limit (the build on his PC has no such cap), but
  the next playtest brief should know it.
- Timing traps that cost runs (worth knowing for the next pass):
  1. Buttons activate on **release** (~0.2 s after the press).
  2. Clicking **Begin fight** starts a **3.4-5.5 s main-thread stall** while the ring's bodies load. Clicks sent inside
     the stall all arrive on one frame and are processed in list order — a Skip scheduled in the same frame as the intro
     skip's release is eaten (happened once, cost a run).
  3. The corner card's buttons exist in the tree but the card is **invisible until t=9.0 of the corner** (4.5 s wall at
     2x, 9 s at 1x). A click before that is swallowed (happened once, cost a run).
  4. `Space` toggles the fight speed; during the intro it is ignored, and one press in the same frame as the intro's
     finish is ignored too (measured).
- To reach the corner inside the cap I used the game's own buttons: **SKIP TO THE BELL** on the intro, then **Skip round**
  (round 1 settles instantly, no shouts), then the corner; **SKIP TO THE BELL** again to start round 2.

## 1. What I did (the runs that matter)

| # | scene | dur | inputs (at_ms) | result |
|---|-------|-----|----------------|--------|
| 1 | JumpFight | 8.0 s | none | 2D tale of the tape → `12_01_tape_2d.png` |
| 2 | JumpFight | 10.5 s | Begin@3500 | 3D tale of the tape, both corners, coaches → `12_02_intro_tape_3d.png` |
| 3 | JumpFight | 24.0 s | Begin@4000, SkipCorner@7500, Space@8500 (2x) | round 1, first shout bar + fight display after 0:30 → `12_03_round1_bar1.png` |
| 4 | JumpFight | 27.0 s | Begin@2400, SkipCorner@4600, SkipRound@5000 | SkipRound was eaten (same frame as the intro skip's release); 1x round, display at its start state → `12_04_round1_guard_1x.png` (a second 1x guard framing is `12_04b_round1_guard_side.png`) |
| 5 | JumpFight | 26.5 s | Begin@4000, SkipCorner@5000, Space@10000 (2x), Shout_long@25800 | bar 1 picked: "Jab and move" → caption "Corner: \"Turn her! Jab and move!\"" → `12_05_round1_pick_heard.png` |
| 6 | JumpCorner | 27.4 s | Begin@2000, SkipCorner@3800, Space@6700 (eaten), SkipRound@7000, job clicks@13600-15200 | corner card before any click (the clicks were before the card appeared) → `13_01_corner_card_defaults.png` |
| 7 | JumpCorner | 27.4 s | Begin@2000, SkipCorner@3800, Space@6900 (2x), SkipRound@7000, Setup_1-2@11700, Gap_press@11800 (dropped), Corner_lead@11900 (clicked before the card), SkipCorner@12000 | corner skipped with the default plan; round 2 playing at 2x, its plan exchange won → `13_02_round2_live_2x.png` |
| 8 | JumpCorner | 27.4 s | Begin@2000, SkipCorner@3800, SkipRound@7000 (1x), Rec_minus_water@17400, Rec_plus_ice@17800, Setup_1-2@18200, Gap_press@18600, Talk_calm@19000 | corner card with all four jobs used → `13_03_corner_card_jobs.png` |

Headless replays (same jump, driven through `Bouts.fight_step`, i.e. the exact calls the 3D view makes): two full rounds
of JumpFight with the picks the live runs made, and a JumpCorner run that arms 1-2 on "when she presses", talks calm,
spends the recover points, plays round 2, waits for the gold NOW and fires it. Their numbers are quoted below.

## 2. Update 12 (JumpFight) — what I saw

**Worked**

- The tale of the tape reads well in both forms. 3D (`12_02`): the two in their corners with their teams, the card
  between them — LUCY JACKSON 21, 169 cm, 61.1 kg, 3-1, orthodox, out-boxer, Anvil Street Gym vs MARIA ORTEGA 23, 165,
  "made weight", 4-2, southpaw, pressure fighter, Guadalajara. One wording wart: the opponent's WEIGHT row shows
  "made weight" instead of a number.
- The shout bar (`12_03`, 2x, bar 1): "ROUND 1  2:30 LEFT  WHAT DO YOU SHOUT TO LUCY?", the clue
  "You see: Maria keeps coming forward, chin down.", three calls with a use-when line and a grade line
  ("Jab and move — coach's pick (from film) / Use when Maria presses / Lucy is good at this", "Hands up, move your
  head / Use when Maria loads up / Lucy can do this", "Let your hands go / Use when Maria tires / Lucy is good at
  this"), "Say nothing", the shout-budget note ("Lucy takes in 2 more shouts this round") and the 10 s countdown.
  It is legible at 2x and it says exactly what it should. Picking one (`12_05`) the ring drops into the exchange with
  the corner's line captioned — "Corner: \"Turn her! Jab and move!\"" — a clean, audible feedback loop.
- The fight display reads at a glance: two rows under the scorebug, `LUCY JACKSON` / `MARIA ORTEGA`, an energy bar with
  the number, BODY HITS, HURT. It moves when the ring crosses each 30 s line and matches the settled data exactly:
  at its start state both ENERGY 100 / BODY HITS 0 (`12_04`), after the first exchanged 30 s Lucy 94, Maria 95,
  Lucy's BODY HITS 1 (`12_03`) — the machine's own after-exchange snapshot is a 94.0 b 94.9 body [1,0] (headless log).
  During round 2 (`13_02`) Lucy 82 / Maria 75 with body 4 and 3 after the rec was applied. The bars' colour bands and
  the HURT tag do the work of drawing the eye.

**Did not work / defects**

1. **"Go to the body" cannot be called at all in round 1 against this opponent.** All six round-1 situations were
   "press", whose offers are [Jab and move, Hands up, Let your hands go]; the clue for all five bars was one of the
   three press lines, and the film mark pointed at "Jab and move" every time. Body only becomes offerable when Maria
   loads up — as the **wrong** call — or tires (round 2 onwards). The brief's "at least three times Go to the body" is
   therefore impossible in the first two rounds here; body work is a round-2+ tool (4 body calls were offered in
   round 2: three as the wrong call, one as ok — headless log). If body work is meant to be a strategy a player can
   choose, it needs to be offerable somewhere in the first round (e.g. "body" as *ok* against a presser), otherwise
   the mechanic is gated behind the opponent's mood.
2. **BODY HITS counts hits TAKEN, and reads as hits landed.** Verified: Maria's threat is the left hook to the body;
   after the first 30 s her work put "BODY HITS 1" under **Lucy** (`12_03`), and the round-2 capture has Lucy 4 /
   Maria 3 (`13_02`) after Lucy's body shots. Under a boxer's name the number is what she has absorbed. It reads
   backwards at a glance; "TOOK" or "BODY TAKEN" would fix it, or put the number under the fighter who landed it.
3. **The scorebug lags the caption by a boundary.** In `13_02` the caption "It worked: \"Jab and move\" won Lucy those
   30 seconds." is up while the score still reads "EXCHANGES WON 0-0"; the counter moves only when the ring reaches
   the next 30 s line (by design — the display never runs ahead — but for ~2.4 s the screen says the round was won
   while the counter says nothing happened).
4. **The plan and the set-up can fight each other (update 13, but it bites here too).** With the corner plan on the
   coach's own read ("Jab and move"), the 30 s Maria fights on it leaves her hurt, so the **first** bar of round 2
   shows her hurt game ([Let your hands go, Breathe, Go get her]) and a set-up armed on "when she presses" cannot
   fire there; it only becomes available later in the round (headless log). Following the coach's advice costs the
   set-up its window.
5. **Round 1 is one decision five times.** Six press situations, the same three offers, the same green mark, the same
   three clues rotating. The rule that "green means she does this well, not that it is right" is sound, but with only
   one opponent game in round 1 the tactical layer is a metronome; the fight is watchable but the bar is a formality
   (4 of 5 "Jab and move" calls won their 30 s — headless log). The variety the code already has (eight situations,
   24 clue lines) does not appear until later rounds or other styles.
6. **Body shots landing/folding: not verifiable on screen inside the cap.** The settled data counts body shots every
   exchange (Lucy took 6 in round 1, 9 by the end of round 2; with four body calls Maria ends round 2 at 31 energy on
   the display with 14 body hits against her — headless log), and the ring's fold reaction is wired
   (`ExchangeBeats._body` → `HitSnap.fold`), but no run under ~27.5 s can contain a landed body call. A "body fight"
   fixture (or a longer allowance in the harness) is needed to see the fold on screen.
7. **The Begin-fight stall.** Clicking Begin freezes the last frame for 3.4-5.5 s (measured frame gaps of 1.3-1.4 s
   while the two boxers and the crew load). On his PC that is a visible hitch at the most dramatic moment; a loading
   state (or preloading the ring on the tape screen) would hide it.
8. **Lucy's back.** The broadcast framing never shows her back square-on (both boxers are seen from the pair's side;
   `12_03`, `12_04`, `12_04b`, `12_05`). In profile her guard is believable — knees bent, chin down, hands up, spine
   leaned forward — and I could not reproduce a "flat back" defect from these angles. What is still flat is the back
   *surface*: no scapular ridge, no spine groove, a smooth plane on the side turning away from us (`12_05` shows
   Maria's back the same). If the complaint is shading/relief, cloth normals were only half of it; if it is posture,
   I could not see it from the broadcast camera and he should point at the view he means.

## 3. Update 13 (JumpCorner) — what I saw

**Worked**

- The corner minute is a good moment. `13_01` (no clicks yet) and `13_03` (all four jobs used) show the whole card in
  one screen: `IN THE CORNER: WHAT DO YOU TELL LUCY?`, WORKED "Lucy landed 1 clean jab.", HURT "Maria landed 2 clean
  jabs.", COACH "Maria was pressing at the end of that round. Jab and move: win it from range and save your legs.",
  then FIX ONE HABIT (optional, "Chases the stoppage", "No fix"), RECOVER 3/3 with "− Water and breathing 2 +" and
  "− Ice on the ribs 1 +" chips, SET-UP with her two drilled combinations and, once a combo is picked, the gap buttons
  ("when Maria presses / loads up / tires"), TALK calm / fire up / truth, and the eight-call grid with "coach's pick"
  and each call's use-when and grade line. The letterbox, the crew, the clock ("CORNER 0:40  ROUND 2 NEXT") and
  "Skip to the bell" all behave. It is readable in the minute — comfortably at 1x (40 s left when I had finished in
  `13_01`), and workably at 2x (the card is up for ~24.5 s of wall then).
- The four jobs all do something, and the +/− spend works exactly as advertised: `− Water` then `+ Ice` gives
  RECOVER 3/3 with water 1 / ice 2 (`13_03`) — "−6 body hits, +3 energy" — and the round-2 start indeed has Lucy's
  body hits cut (belt 6 taken → 3 at her next bell, headless log).
- TALK is real: for Lucy (temper 72, confidence 51, discipline 69) "Calm her down" pays (+1.0 edge a 30 s, hurt risk
  ×0.6) and "Fire her up" is a trap on her (−0.5 edge, hurt ×1.6) — the brief's "depends on who she is" is true and
  the right answer is discoverable. THE PLAN's eight calls and the habit fix all land.

**Did not work / the honest limits**

9. **The gold NOW was not reachable on screen inside the cap.** Arithmetic of the fastest legal route at 2x: skip the
   intro (+ the load stall) lands the corner at ~7-9 s; the card opens at +4.5 s; arming the set-up, picking a plan
   and skipping to the bell costs ~1.5 s more; round 2's **first** bar then opens at ~27.5-30 s of wall — past the
   27.4 s that is provably allowed — and every later bar is +25 s beyond that. So the button, its firing and its
   payoff were verified on the rules path instead (below), and the round-2 play that fits was captured (`13_02`).
10. **What the NOW does (headless log, set-up = 1-2, gap = "when she presses").** Round 2 with the corner plan on
    the coach's read ("long"): bar 1 shows her hurt game — no gold. Plan on something that does not leave her hurt
    ("Make her lead"): bar 1 shows "Maria keeps coming forward, chin down." with the gold **"NOW! Jab-Cross!"** first
    in the row; fired into that gap the ring captions "Corner: \"NOW!\" - Maria walks into the set-up!", the 30 s is
    won by 41, +30 head damage goes onto the knockdown roll and Maria ends it hurt. Fired into a game she is not in it
    costs −9 (not reachable in this jump: with film study on, the button cannot appear when the game is wrong — the
    "costs Lucy" case needs the no-film jump, `JumpFightNofilm`).
11. **One set-up a round is only enforced by the button** — after the fire the gold is gone for the rest of the round
    (correct), but the card gives no line saying the set-up was spent or whether it landed ("walks into the set-up"
    is only a ring caption). A line on the next corner card ("your 1-2 landed in the gap") would close the loop.
12. **Job order is a trap the card never states.** Pick THE PLAN before the other jobs and the jobs and the fix row
    disappear (`picked()` hides them) — the call must be last. Nothing on screen says so.
13. **RECOVER is pre-spent.** The second's defaults already spend all 3 points (water 2 + ice 1 as soon as she has
    taken 6 body hits), so doing nothing costs nothing and the only decision is the mix; "clear her head" only shows
    when she ends the round hurt. Fine, but it is one click, not a job.

## 4. The brief's questions, as a player

- **Does the fight display read at a glance? Do body shots feel like they matter?** The display reads (energy number
  + bar colour, body hits, HURT) and it matches what the ring showed, boundary for boundary. Body shots *count* — her
  energy sinks for the rest of the fight and the clue turns to "Maria has stopped throwing combinations." after four
  body calls (31 energy on the display, 14 body hits against her, headless log) — but on screen I could never *call*
  one in the first two rounds (finding 1) and never saw the fold (finding 6), so as a player body work feels like a
  late-round button I can't reach, not yet a plan.
- **Is the corner minute enough, too much, or too little? Is any job pointless?** Enough at 1x (I finished the four
  jobs and reading with 40 s left); at 2x it is tight but fine. Nothing is pointless; RECOVER is the thin one (one
  click, pre-spent — finding 13) and the fix row only ever had one habit to offer. The dense card is the best thing in
  either update.
- **Does the NOW button feel like a moment (gap seen → fire → payoff)?** The design is right — the gold button in a
  row of grey cells is a jolt, and firing it produces a ring caption, a won exchange and a hurt opponent in one
  package (headless log) — but I could not feel it live under the run cap, and with the coach's own plan the first
  window never comes (finding 4). The gap must actually show for it to exist, which the rules do correctly; the risk
  is the player waiting a whole round for it while following the coach.

## 5. The three player actions I would add next (Q-S294-18), each tied to training

1. **Ring cut — "Take the outside"** (trained: footwork + a new gym move). A corner job and an in-round shout: she
   circles away from the opponent's lead side for the next 30 s. With the move learned on the pads (like combos, data
   `moves`), a presser's step-ins stop landing cleanly (press edge reduced); without it, the shout is a normal call.
   It gives footwork — a stat with no fight-visible action today — a thing to spend, and it uses the footwork the
   guard/steps work already measured.
2. **Range plan from the camp focus — "Keep it long" / "Get inside"** (trained: the camp). The camp focus currently
   feeds only numbers. Let the chosen focus set a *range plan* for the bout that the corner can switch once a round;
   the ring's own gap (S310's gaps doc) and the reach work decide what she can throw from there. It wires camp →
   fight visibly, and it is a second lever in the minute that is not a call.
3. **Slip-and-counter — "Slip and counter"** (trained: a defensive gym drill). A shout unlocked by her defense drill
   level: if the opponent is loading up or pressing, the next exchange becomes a counter window (her slip, their miss,
   her shot; knockdown chance up). It gives defense — currently an invisible number — a fight moment, and it builds
   directly on the guard work in S274/S275.

## 6. Ranked findings (defects first, then feel)

1. "Go to the body" is un-offerable in round 1 vs a presser; body work is gated behind the opponent's later games (12).
2. BODY HITS counts hits taken and reads as hits landed (12).
3. THE PLAN can kill the SET-UP's first window: the coach's own read leaves her hurt, and the hurt state replaces the
   gap at round 2's first bar (13).
4. The gold NOW and the body-shot fold cannot be verified on screen inside the editor's ~27.5 s run cap — the next
   playtest needs a per-moment jump (start in the corner, or start armed at round 2) or a longer allowance (13).
5. The scorebug lags the verdict caption by one 30 s boundary (12).
6. Round 1 vs a single-game opponent is five identical decisions; the tactical variety only starts in round 2 (12).
7. Begin-fight stall of 3.4-5.5 s with the tape frozen on screen (12).
8. The corner card does not say the plan is picked last, nor whether the set-up landed when the next card opens (13).
9. RECOVER is pre-spent by the defaults — one click, no risk, no decision beyond the mix (13).
10. The 3D tape's WEIGHT row prints "made weight" for the opponent (12).
11. Lucy's back reads as a smooth, relief-less surface from the only angles the broadcast camera gives; no view
    reproduces the "too flat back" posture — point at the camera view you mean (12).

## 7. Housekeeping (what I did NOT do)

- No game file changed. `git status` shows only pre-existing editor churn (the `*.import` uid rewrites and
  `project.godot`'s header — the working copy already lacked `[gui]`/`rendering_method` before the first run) plus my
  two additions: `docs/ziva/shots/*` and this review.
- The operator's career saves were not touched (`career_slot_*.json` mtimes unchanged, Oct 22-23); the jump uses its
  own `user://test_jump_save.json` and never wrote it.
- Console during every run: only the editor's GDScript reload lint warnings (e.g. `UI.gd:36 The local variable "mono"
  is shadowing...`, `ShoutBar.gd:37 Integer division. Decimal part will be discarded.`, `BoutActs.gd:47 Values of the
  ternary operator are not mutually compatible.`); no runtime errors, no crashes, in any run.
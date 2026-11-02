# S139 - THE BOXING CLINCH, PROPERLY: who ties up, why, what happens inside, the referee, the penalties (Claude, design)

Operator 2026-10-02, verbatim: "keep working on this and maybe put a threshold when the distance is too close to
clinch ?" then "do a proper intergration of the clinch, who initates it, why , what are the penalties etc".
Sources already in the repo (primary, read S139): `K38_THE_CLINCH_BY_SPORT.md`, `Q174_DIGEST.md` (+ its never-merged
engine commit `fb58fb93`), `J14_THE_REFEREE.md` (ABC Unified Rules of Boxing 2016 + ABC Referee Manual), `J38_THE_CLINCH_BREAK.md`,
`topics/clinch.md`, `Q93_WHY_BOXERS_NEVER_CLINCH.md`. Where a number is NOT FOUND it is marked PROXY and bounded.

## Today (the defect)
Boxing on master has ZERO clinches: Q174's hold model (fb58fb93, 2026-09-25) measured in band but was never merged, and
the engine's R92 clinch is a grapple path boxing does not use. When the men walk chest to chest, nothing ties them up,
so the room shows two bodies inside each other (C237 live video, C223 `body_overlap` on every reaction row).

## 1. Who initiates, and why (a hold is CAUSED by need - never a flat rate; Q174)
A decision tick's hold chance for each man = base + the sum of his needs (Q174's model, revived and extended):
| need | why a real boxer holds | engine input |
|---|---|---|
| HURT | a rocked man ties up to buy seconds and clear his head (the most-seen clinch on TV) | recent damage / a knockdown this round / wobbled state |
| TIRED | the tired man rests on the other man (Davis 2015: clinches 2.5 -> 3.2 -> 4.8 a round R1->R3, rising with fatigue ratings) | stamina / fatigue |
| SMOTHERED | an out-boxer caught by a pressure fighter who cannot get out holds to stop the barrage | being out-landed over the last 10 s + the gap closed |
| TOO CLOSE | chest to chest after an exchange - someone grabs (the operator's threshold) | the engine gap below CLINCH_GAP_M for > CLINCH_DWELL_S; the man with the higher need ties up |
| TACTICAL | protecting a lead late; a veteran/"dirty" personality smothers a puncher's power; the CORNER says so | personality, plan, round + score state, the corner instruction |
Who does NOT hold: a fresh, undamaged, even-worked man almost never does (Q174: p ~0.0005 a tick). The pressure fighter
usually wants to WORK inside, not hold.

## 2. Inside the clinch (boxing, not MMA)
- The holder ties the arms (overhook) and leans; the other man may work SHORT body shots at a low rate, or try to free
  an arm and push off. No head shots, no throws, no knees (boxing).
- The holder recovers a little stamina; LEANING costs the other man stamina (real: "make him carry your weight").
- Judges: clinch time scores nothing; excessive holding counts against ring generalship / effective aggression
  (10-point must, J1). Winners and losers clinch about the same (Davis/Dunn) - a hold does not decide fights.

## 3. How it ends - the referee
- The referee calls STOP - BREAK; both step straight back to range (ABC Referee Manual, J14 s1.3). No fixed seconds in
  the rules (J38): use the measured duration, 4-6 s (Davis 2015 ~5-6 s; Martusciello 2025 4.06 +- 2.27 s) - drawn,
  seeded, PROXY bounds 2-8 s. A man can also break free himself (arm freed + push off) before the call.
- The referee does not always stop the action for a minor violation; he may talk at the bell (ABC manual).

## 4. Penalties (ABC Unified Rules of Boxing + Referee Manual via J14 s1.4)
| offence | sequence | engine |
|---|---|---|
| Excessive / persistent HOLDING | soft warning (signal) -> hard warning (time called, told) -> point deduction (1, referee's discretion) -> further deductions -> disqualification is possible but rare ("not honestly competing", NAC 467.723) | per-man holding count + held seconds per round; thresholds PROXY (e.g. warn after the 3rd hold in a round or > 15 s held; deduct after a hard warning + another excess) |
| HITTING ON THE BREAK | a foul (Ontario 8.14, NAC 467.675(16), BBBofC 3.38(j)): warning, then deduction | a "dirty" personality has a small chance to throw as the break is called |
| Deduction bookkeeping | announced to boxers, judges, commission; taken off THAT round's card (NAC 467.688(3)) | a score event on the round's three cards |
| Intentional foul causing injury | mandatory 2-point deduction (ABC 12.A.2) | out of scope here (no cut-from-foul model yet) |
Deductions must be RARE: no published pro rate for holding deductions (NOT FOUND) - PROXY ceiling: fewer than 1 bout in
10 with any deduction across the booked census; warnings common (most bouts with a heavy holder see one).

## 5. What the player sees and controls
- Corner instructions (the existing corner order): "TIE HIM UP WHEN HURT" (raises the hurt need weight) and "WORK
  INSIDE" (the pressure man stays in and works instead of letting the other hold). Icons with tooltips.
- Scorebug (K83): a "WARNING - HOLDING" strip under the man's row; a deduction shows as "-1" beside his record for the
  round and on the between-rounds card; the referee's "BREAK" as a short call at top centre.
- Stats: clinches and clinch seconds per man per round on the between-rounds card; holding warnings/deductions on the
  result screen and in the fight log; the scorecards carry the deduction.
- Fighter identity: personality (dirty/clean, disciplined) and plan (out-boxer holds when smothered, pressure fighter
  works inside) make two different men clinch differently - the operator's "every system means something".

## 6. Bands the census must hit (booked population, as_game, both arms)
- Holds 2.5-4.8 per round rising with rounds (amateur 3-round anchor; pro 12-round NOT FOUND -> report per round);
  4-6 s mean each; ~10% of round time (K38).
- KO+TKO 40-55% and thrown 45-56 per man-round unchanged in band.
- Warnings in most bouts with a heavy holder; deductions in < 10% of bouts (PROXY ceiling); DQ ~0.
- Overlap (G147: torso > 2 cm for >= 3 frames, head > 1 cm for 1 frame) at least halved in the live room.

## The split (who builds what)
- ENGINE - TASK_Q233 (Qwen engine seat): revive fb58fb93 on today's FightRealtime + the proximity trigger, initiator
  choice, inside work, stamina transfer, the referee break, holding warnings/deductions, hitting on the break, corner
  orders, scoring + stats, the log events the room and the HUD read (`hold_engage`, `hold_break`, `hold_warning`,
  `point_deduction`, `foul_on_break`).
- ROOM/ANIMATION - TASK_C240 (Codex): the paired clinch hold film, entry/exit blends, the step back on the break, the
  overlap census in the live room - driven by Q233's events.
- HUD - Claude: the K83 scorebug carries BREAK / WARNING / deduction (BroadcastScorebug.gd).

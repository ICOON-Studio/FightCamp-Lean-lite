# S536 digest (2026-11-21 evening, Opus)

## The Godot queue (owner: "how many godot tasks qeued ? can you speed them up ?", "cpu looks normal to me")
- Found: 16 jobs (4 running, 12 waiting). The governor paused jobs whenever CPU passed 80 % while the CPU sat at 50 C, so most of
  the time one job worked; "normal" CPU = jobs frozen. Three finished Fable consoles held ~1 GB (owner "Yes, close them").
- Owner "92%": watchdog CPU RED line 80 -> 92 (heat limits unchanged). Owner "Yes, use 8": Godot jobs on 8 threads (CPUs 4-11)
  instead of 6 - and the watchdog (0-5 every 5 s) and the governor (4-9) had pinned DIFFERENT cores; both now 0xFF0.
  Owner "can you get more going in parallel ?": GREEN slots 4 -> 6; waiters had imported SLOTS once, now read live each poll.
- After: 4 running / 6-9 waiting, CPU 18-48 %, 50-57 C, GREEN.
- Owner "how many godot tasks working at the same time": still 4 at 6 slots - the waiters queued before the change kept their
  imported 4 and blocked the line. godot_slot tickets now carry "v": 2; a newer waiter counts the old ones ahead of it only as
  far as their own limit lets them start. My two jobs re-queued started at once (5 running).
- Tape tests (tape_versus, tape_rows, tape_form) PASS; d08d94421.

## Weight (WEIGHT2R3 read -> WEIGHT2R4)
- Round 3 "PASS, weak": 0 of 10 cells clear of the noise, CUT harder in the leading group of all 10. Causes in its own table:
  the amateur CUT (+2 kg flat) sat under John's free first 2 % (Stamina cost 0.0-0.5 %); the pro regain 7.2 % left "dry at
  the bell" 0.0 % in every pro cell. WEIGHT2R4 (Fable): cuts sized as a share of body, pro regain tied to the cut, 40 seeds,
  bar = 4+ clear cells and CUT leading at most 6. Code-checked critic waits for it.
- DMGCLASS v3 chat critics (SQ275 Kalli, SQ276 John): 5/6/5 both, "the class is never a choice" - matches the S535 merge into weight.

## The owner's review notes (C450-C458), all acted on
- Tape (C451-C453 "wtf is that doing on the tail of tape", "highlight who has the edge"): the camp / film / scouting lines left
  the tape (TapeVersus); Last 5 and Streak go green on the better side (TapeRows._form_better / _run_better); tape_versus_test
  now requires the lines gone.
- C454 + C458 (blue cross legs and gaze; "looks like a weak 12 year old kid") -> FP2POSE1 (Fable, fight player v2 only).
- C447 + C456 (glove into the cheek; dark skin lost on the dark crowd) -> GLOVEFACE1 (Fable: glove shape + ring key/rim light).
- C455 textures -> BODYTEX2 (running); C457 "after looks better" -> correctives kept; C450 offer "ok" -> OFFERBUILD1 continues.
- Arms by Strength 40 vs 80 stills (rendered S535 after "make it stronger") on the review board and sent.

## Board
- 11 finished / superseded runs marked (TURNPROBE11, DEPTHPRICE1A, GUARDPROBE6, KNOWMISREAD1, ARMPAINT1, ARMBUILD1; guard v6 and
  pro v10 critic jobs superseded). Map: S536 rolled, done / now cards current.

## Running at this point
Fable consoles: WEIGHT2R4, FP2POSE1, GLOVEFACE1 (this session); BODYTEX2, OFFERBUILD1, TURNPRO12, GUARDPROBE8, STEPPAY2,
DEPTHPRICE1B (S534-S535). Godot queue: the tape tests and the s535/dmgfix branch tests (its worktree).

## Weight v2 chat critic (SQ279 Kalli): 6 / 7 / 5 - fails the 8 bar
Top fault = WEIGHT2R4's target (water free under 2 %: always Light). After R4: probe the deep parts (growth, tolerance shrinking with age, the diet's coach slot) and give the week a reason to come back (Kalli Play 5).

## Later in S536
- dmgfix branch tests 10/10 PASS in its worktree (merge waits for the probes that read fight code).
- Tape still (ops/previews/s536_tape/18_tape_real.png): film line gone, rows clean. DEFECT seen: an empty grey rounded bar over Lucy's left hip (x 185-330, y 665-693) - not in any of her 8 paintings, not a Label/Button in the layout map: a hover/tooltip panel or a stray Control. Card on the map; trace it with a control dump at that rect.
- TURNPRO12 = FAIL 10/15 (2nd): house fork real (ticket +$1.5-1.7k for -23 debut wins in 100 with room, +$619 full gym); Softer right in 0 of 4 cells. FREE HAND -> v13 drops Softer, the name lasts (TURNPRO13, Fable).

- DEPTHPRICE1B (36ed76a9f): class nights PASS; stipend 2nd price PASS thin; loan FAIL at both sizes (the sponsor's timing is the lever - next a timing probe, not a price); diet switch a no-op -> folded into WEIGHT2's Monday diet. Passing prices go to two critics at 8 before any build (DEPTH_SCOPE step 2).

- WEIGHT2R4 PASS (cd9a84dbe): 7 of 10 cells clear (r3: 0); STAY 4 CUT 4 UP 2 DOWN 0; CUT leads 5; CUT clearly worse than STAY in all 5 amateur cells - but through missed scales (miss slope = estimate), DOWN never best, inside one scale CUT has one answer. Critics: WEIGHT2V2CRIT (Fable, code-checked) + SQ280 John.

- BODYTEX2 landed (in 33d0f8d0d by accident, note e0384940e): Epic muscle skin on all 19 boxers (Chr0023 men, 0035 man 03, 0012 women; dark skin relief x1.25), the shoulder seam (NeckSeam.gd); shape measured, not changed.
- GUARDPROBE8 (9c7d18540) FAIL: a guard WHEN-line costs no punch line - the slot is free, so guard v7's lines are never a trade. Under FREE HAND this goes to STANCEPROBE1's merge question (stance + guard = how he stands).
- Owner 'yes both': STANCEPROBE1 (Fable) + SQ281 John card-game study. Weight critics running (Fable code-checked + SQ280).

- WEIGHT2V2CRIT (71e1175f0, code-checked): 6/7/6 - code claims sound (1 false); the probe never ran diet against water; frame erased so DOWN can never win; the hybrid scale; drained cutter's CUT = her STAY. -> WEIGHT2R5 (Fable) on its items 1-4 + Kalli's Monday point.

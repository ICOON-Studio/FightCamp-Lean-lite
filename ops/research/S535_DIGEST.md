# S535 digest (2026-11-21 ~16:05 -> evening, Opus, main session)

Opened on S534's six Fable runs (all still in the Godot queue) and three answered board questions. The owner then asked for
class changes, then "Go deep with weight mechanic for 10/10", then pointed at the bodies ("why the bodies look so terrible ?").

## Owner rulings this session (verbatim)
- "The boxer should be able to change weight classes"; "Go deep with weight mechanic for 10/10 it should be manageable to a
  certain point and affect various things about fighters performance,scaling etc".
- Q-292 "Add men's 65 kg"; Q-293 "Yes, he can refuse" (a class move); Q-294 "Yes, after the probe" (3D body by weight);
  Q-295 "Use them anyway" (MetaHuman body maps outside Unreal, licence unread first-hand).
- "can you make the memory checker also consider the free pagefile ?" -> done.
- "why the bodies look so terrible ?", "the stomach goes inside weirdly the chest on the black guy look weird", "there are no abs
  weird shaped bodies".
- Review board: C447 "is the glove normal looking ?", C448 offer "looks too much like the tale of tape", C449 tape "add
  streak/latest results?".

## Collected and decided
- TURNPROBE11 FAIL 4/15 (purse levers inside the noise at a quarter share; debut difficulty, softer and the lean are real) -> TURNPRO12.
- GUARDPROBE6 FAIL (fixed Hands: Normal best 12/12; reading the moment wins 10/12 by 0.5-4) -> FREE HAND: guard = a fight-plan
  WHEN-line action -> GUARDREV7.
- DMGCLASS (critics 6/5): not its own mechanic -> merged into the turn-pro table pick, owned by WEIGHT2.
- WEIGHT2: map from code; probe round 1 FAIL, round 2 PASS (20 seeds x 12 bouts: STAY 5, CUT 2, UP 2, DOWN 1; every lever moves).
  John SQ278 real numbers landed. WEIGHT2R3 (answers + John + round 3 + critic briefs) running.
- DEPTHPRICE1A: flat prices do not make choices (pace, corner, partner FAIL; fight week PASS narrowly). Found 2 defects.
- DEPTHPRICE1B: class nights PASS; stipend weak option is the full stipend; loan 1st price FAIL; the diet switch does nothing
  because the camp cuts automatically (WEIGHT2 removes that). Re-sizes queued.
- MHCORR2 (c18ca201e): the S263 DNA correctives ported into fight player v2 (they never came to the lean repo); the caved
  stomach is the body shape (02, 07). BODYTEX1 (699c265d8): boxer 01 in Epic's athletic detail at 2K; BODYTEX2 running.

## Built (main)
- Watchdog: RAM % counts the pagefile (93% RED only under 12 GB commit free; 97% always RED) - c79a2416a.
- design_loop revise brief names the 8+ bar. Five brief contracts fixed. Body correctives + boxer 01 skin (Fable).

## Built on branch s535/dmgfix (tests partly green; merge after the probes stop reading the fight code)
- Knockdowns pro_rules (no four-count bout limit in pro bouts) - knockdowns_test PASS.
- Towel priced as an ordinary loss (BoutFinish `beaten`) - towel_wire_test queued (first run hit the queue lock).
- Men's 65 kg "mlm" + 6 rivals; male_boxer_test now counts from Data (22).
- LiverRibs.ice (ice reaches the drain tally); Tick over's unwired "+1 line up" no longer promised.

## Lessons
- Edits to fight code while probes run go on a worktree branch (a running probe reads the checkout).
- The PC's RAM, not the CPU, starves the Godot queue: close finished Fable consoles at once (10 GB of claude at one point).
- A probe with 1 seed x 2 bouts is a smoke run: read the header before the verdict.
- Check Data before asking about classes (women's 70 kg was already in).

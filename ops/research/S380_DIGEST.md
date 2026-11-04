# S380 digest (2026-11-04, Claude) - ran beside the still-live S379 session

Split agreed with S379 (local_8da6debf) by message: S379 keeps the TV camera (claude/tvcam -> claude/fight9base),
corner-start films, FIGHT9R10 (held) and PR #32; S380 did everything below.

## Shipped to main
- agy from the scheduled reconcile (3bf18542): agy was installed from inside the Claude desktop app (MSIX), so
  AppData/Local/agy is a folder only processes INSIDE the package see; the real exe is
  Packages/Claude_pzs8sxrjxfjjc/LocalCache/Local/agy/bin/agy.exe. find_agy() checks both at call time (verified from a
  one-shot scheduled task: old path False, new path found); a run whose agy is still missing gets status `requeue` and
  resume_requeued() restarts its runner on the next cycle (used for BJJ9R12).
- agy prompt (83d3676d): reads only inside its worktree - BJJ9R12's first round ended at step 16 on a soft-denied read
  of E:/FightCamp/ops/seat_dispatch.py, because ITS BRIEF named seat_dispatch. Never name tooling in a seat brief.
- CAMPPROTO1 (1c20b825): Light / Standard / Hard differ. The protocol sets the camp's evenings (BoutRules.camp_evening:
  pads drill the camp stat at 0 / 0.05 / 0.09 of a session, evening load x0.75 / 1.0 / 1.2); the week-end training roll
  reads the week's peak fatigue (InjuryRoll.fatigue_mult: x2 at 76, x3 from 80 - Aubry 2014); camp fatigue still in her
  on fight night costs energy at the first bell (BoutRules.stale_energy: 2 a point over 50, max 20, only after a camp -
  Halperin 2016). Mornings and the weigh-in unchanged. Lucy's 25-day power camp: +1.1 / +2.0 / +2.9 power, fight night
  41 / 48 / 53, heavy legs 0 / 0 / -6, injury 2.7 / 3.1 / 4.8 %. Camp modal shows each protocol's night + injury; the
  whiteboard injury row shows the hot week. A 4-agent review workflow found 7 real issues, all fixed (PlanTest used
  today's heavy legs, forecast missed the push-through double roll, planner week lacked the camp multiplier...).
  tests/camp_protocol_test.gd new; weigh_forecast_test pinned to seed 1 (1-in-40 random-seed injury flake).
- Men's training-station pictures (590cbc76): mh_boxer_01/02/03/07/08 baked (bare-chested, trunks, boots); the bake's
  `stems=` used to wipe the other bodies from session_pics.json - now merges.
- PROMO1 (beba8db6, 6f2e2239): operator "THIS DOESNT LOOK LIKE A PLAYER PROFILE PICTURE ... make the fighters pose like
  ufc fighters pose". tools/bake_promo.gd: dark studio, red/blue rims, body squared to the lens, arms folded with gloves,
  chin up 24 deg, belt to crown, all 19 bodies -> assets/ui/face/*.jpg (+ promo_face.json: each body's eyes/nose for the
  head close-up and its cut/swelling marks). Camp panel picture 298x200 -> 298x300. docs/mockups/S380_promo_portraits.png.
- bjj9base: main merged (5a73e9af) + no-pronoun fix (405c0989); BJJ9R12 brief (85761759) and launched on agy.
- Update 75 exported (Builds/FightCamp.pck 07:36, 138/138 tests): camp protocol, men's pictures, promo portraits.
  The board Test button "men" shows both (accept Danny's offer -> SET CAMP).
- PRs #33 (LOCOWALK2) and #34 (FIGHT9R9, real 4/10) closed with reasons; LOCOWALK4 queued on cursor.

## Later in S380
- PROMO1 pass 2 (39e79277): portraits WITHOUT gloves (operator: "make them pose without gloves on") - bare hands,
  arms folded, all 19; the head close-up's marks follow promo_face.json.
- Gemini judge blind (HTTP 402, prepay dry at Google ~$33 while our brake sat at $48): operator "Judge by Claude's eyes".
  Tools/claude_judge.py (b8fb5eab) = automatic fallback in seat_dispatch.judge: eyes sheets (3 s every 10 s + three
  tight 0.5 s sheets for trembling) -> standalone `claude -p` (opus, Read only, outside the repo) on gemini_judge's own
  prompt -> the same verdict file. BJJ9R12 before: 2/10 then 3/10 (merged bodies at 0:09-0:12, confirmed by eye).
  After a top-up: set gemini_budget.json budget_usd to the amount LOADED (not 48).
- Ropes (operator: "i thought you fixed the ropes, why old problems appear again?", then "its quite clear my picture is
  from when the fighter enters the ring"): the S347 inside-the-ropes rule never reached two shot lists. Corner minute
  (2f7edd99): low_out 0.69 m / part 0.54 m / side2 0.31 m OUTSIDE -> inside + CornerShots.inside() guard. Ring entry
  (6880aaf7): wide / wide_out 7.2 m and tape 8.4 m out, seeing the entering boxer THROUGH the ropes 100 % of frames ->
  high over the neutral corner inside the ropes (as S379's fight9base intro). tools/corner_film.gd now checks every
  intro + corner shot each frame (lens past the rope line, sight line to head/hips through the ropes): 22 shots, 0 %.
  I first blamed the corner minute - the operator corrected me. Any new camera module gets that bar the day it lands.
- Update 75 re-exported 08:56 (138/138): camp protocol, men's pictures, gloveless promo portraits, corner + entry ropes.
- C: drive (operator "why is c full"): iCloud photo folders are cloud-only (0 GB); real use = apps + leftovers; the
  operator cleaned 14 -> 88 GB free himself (Claude may not delete files). His `OneDrive/Documents/ChatGPT/Game` (old
  pre-Lean FightCamp copy) was HALF deleted by an interrupted command (140,731 -> 68,697 files, .git + Builds gone);
  PDFit.tools and his other projects are intact. OneDrive was not running: the cloud copy may still be whole - he
  should check onedrive.live.com before starting OneDrive. D: (GTA) is not connected.
- In flight at hand-over: BJJ9R12 PR #36 (rejudge by Claude's eyes running), LOCOWALK4 PR #35 (3/3 checks, collect
  with eyes on the clips), PR #32 (S379's).

## Blocked / open
- Gemini API prepay DEPLETED (HTTP 402): Claude's eyes judge instead (automatic). After a top-up, ask how much was loaded
  and set AgentComms/gemini_budget.json budget_usd to it.
- HANDOFF: next = read BJJ9R12's verdict + collect PR #36; collect LOCOWALK4 PR #35 (eyes on every clip); S379's TV camera
  -> rope bar -> fight9base -> FIGHT9R10; the operator's verdict on update 75.

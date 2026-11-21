# S534 digest (2026-11-21 ~13:15 -> ~14:20, Opus, main session)

The session opened on five owner review comments from the morning (C442-C446) that S533 had seen but not acted on, plus
his film 15 note (C435). All were acted on; three Fable consoles wrote maps / critics from the code; the build was exported.
Owner mid-session: "keep going dont wait on arena".

## Owner notes acted on (all on main, in the 14:09 .exe)
- C442 "what opponent was picked": VS <debutant> on each house's header (each house its own debutant: DebutOpp.name_for
  takes the promoter); the Debut row says why the house picked them. First put in a row - against S448 names-only-in-headers
  - moved to the header the same hour.
- C442 "why morale drops": "(morale -5)" off the buttons; one MORALE line with the boxer's goal (ProOfferWire.morale_line).
- C443 "can he do anything about them?": no rating gap on the card, no aim number on the hover; the hover = what the
  debutant brings + "Spend the ask on a softer opponent."
- C446 "can the background be transparent?": tooltip card 86% opaque (TipParts.CARD_BG). His call if lighter / darker.
- Feedback 2026-11-21-05 point 1 "remove": no trainer face on the clipboard.
- C445 "texted more careful": the last 3 broken tooltips fixed; tooltip_standard / tooltip_rest ratchets locked at 0.
- C435 on film 15 "reds hands are not moving with the reaction": Fable ANIMHANDS1 - GuardHold holds both hands through a
  reaction (player2_test HANDS 336/710 -> 0/710), film 16 on the review board; Claude opened the hit still: gloves at the face.

## Found and fixed
- F13 (code-checked critic): a towel / cracked-rib retirement (RTD) wore the chin against Towel's own "wear": false.
  BoutFinish skips wear_stoppage on RTD; towel_wire_test red (cap 100 -> 97) -> green.
- palette_guard red since S531 (RingTopDown's 4 raw colours) -> Palette.RING_CANVAS / RING_ROPE.

## Collected
- LOANPROBE1 (Grok Dev PR #435, CI check = GitHub 429): the fit-out loan grows a careful gym (26/28 loan-takers 130-153
  members), never a trap in 2 years. The "8 weeks banked" bar that held most careers back is the probe's player, not a rule.
- Seat answers: guard v5 Kalli 6/7/5 (the guard acts after settle - METHOD line), DMGCLASS v2 Dola, turning pro v9 John.

## Design loop (maps from the code on Fable consoles, 6-9 min each)
- Turning pro v10 (cc5f67341): critics John SQ271 + Kalli SQ272 sent.
- Guard v6 (b471c59f4): Hands High / Normal / Loose join the exchange edge before settle; critics SQ273 + SQ274 queued.
- DMGCLASS v2 code-checked critic: 5 / 6 / 4, 13 false CODE claims -> v3 from the code in flight.

## Housekeeping
- live_runs: 70 landed / merged runs archived; finished briefs marked Status DONE; WHAT_TO_TRY's S533 section rescued into
  docs/ (export.sh copies docs/ over Builds/).

## Left for S535
STEPPAY2 phases 3-4 (uncommitted, gate run in flight) + its BoutRead recalibration (debut_read_test 2 lines); DMGCLASS v3 ->
critics; act on the v10 / v6 scores; the owner plays the S534 build.

## Stage 2 (14:15 -> 15:05): painted bodies (owner Q-S294-289 "Keep painted", then "can you switch them on the fight too ?")
- His question "is it good choice?": yes for every 2D screen (one style ends the photo-next-to-painting mix); the 3D fight
  stays MetaHuman; told him the two risks (face drift, the live 3D shadowboxing becomes a painted still).
- Ludo image edit x152 (76 credits; two prompt tests 3 credits): each body's own render + its own painted portrait as the
  reference. First prompt came out semi-3D (gloss) -> the "flat matte, thick ink" prompt matched. Upload rate limit 60/5 min:
  four chunks of 45. tools/fit_painted_bodies.py fits each onto the render canvas (Ludo returns 576x800 and shifts the figure).
  Glove colour vs render checked on all 152 (one false alarm: red shorts in the crop). Contact sheets read by Claude.
- Wired: RosterCards.body_path (painted when ui_art "b"), VersusPanel (painted pose instead of VersusLive), FaceFrame +
  face_frame_test (style_b/fullbody uses the fullbody head boxes). 7 screen tests PASS. Build 15:02.
- Tried and reverted: painted portraits on the fight poster - the halftone turned their grey backdrop to dots and lost
  dark-skinned faces; the poster keeps its keyed press photos.
- Also: DMGCLASS v3 landed (Fable) + critics queued; Arena GUARD6CRIT (code-checked guard v6 critic) running.

## Stage 3 (15:05 -> 16:00): depth (owner "how strategically deep is our game")
- DEPTH_AUDIT_S534 (Fable): wide not deep, 5 of 23 measured decisions real. Owner: "Yes, that plan" (DEPTH_SCOPE_S534);
  "mechanics need an 8 critic's to stay in the game for depth and fun" (bar 8+ DEPTH and PLAY); "you can remove,add from
  scratch or interconnect current and current with needed mechanics" (FREE HAND). All three in CLAUDE.md + METHOD lines.
- Probes before critics: TURNPROBE11, DEPTHPRICE1A/1B, GUARDPROBE6 running; KNOWMISREAD1 building (Fable consoles).
- Critics in: turning pro v10 John 6/7/7, Kalli 6/7/6 (v11 written); guard v6 Arena 6/7/5 + live defect FIXED (tie-up
  guard on all three routes, Sharp +13); DMGCLASS v3 code-checked 6 (class never a choice).
- Arms: owner "too skiny" -> Q-290 "Follow Strength" -> ArmBuild.gd (3D, width only), then "make it stronger" (80 -> 1.24);
  152 bodies repainted with athletic arms (76 credits), import + commit in flight at the handover.
- Godot slots GREEN 3 -> 4 (owner). Handover at 680k context.

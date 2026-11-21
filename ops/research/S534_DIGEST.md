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

# S535 handover (written 2026-11-21 ~14:15, end of S534 - Opus)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. S534 is in roadmap `now`.
FIRST: `python ops/Tools/godot_slot.py status` (the owner may be playing a game - RAM was 86% at 14:09).

## METHOD lines - quote all of them in your first message
- FOOTWORK (S533, STEPS_PAYOFF_SCOPE_S533.md, owner Q-285 "Yes"): a step must pay where it takes you. STEPPAY2 phase 2 built
  PlaceEdge (ropes +5.0, corner +6.5, own ropes -5.0). No StepEffect TABLE sizing until phase 4's re-gate of all 10 steps is read.
- GUARD (S534, Kalli on v5): every guard rule acted AFTER the exchange was settled, so covering never changed who wins a round.
  Map v6 puts Hands High / Normal / Loose into the exchange edge BEFORE settle. No guard build until v6 passes 7+ and its probe.
- DESIGN MAPS are written FROM THE CODE (a Fable console in this checkout - Arena only when it is free; owner S534 "dont wait
  on arena"), never by a chat seat; a code-checked critic finds real defects (S534: the towel chin bug, F13).
- Fight animation (owner S510): fight player v2 only (scripts/fight3d/v2). The mocap pack is his money call at the END OF
  NOVEMBER - do not ask before.
- BOARD QUESTIONS (owner S533): 20 words max, options 5 words; detail goes in --attach.
- NAMES ONLY IN HEADERS (owner S448): S534 almost broke it (the debutant's name in a row) - the name goes on the card's
  header / versus line, rows say why.

## Running when S534 ended - collect, do not relaunch
- Fable STEPPAY2 (its own terminal from S533): phase 3 code UNCOMMITTED in LineGrade.gd, LiveRound.gd, StepWire.gd (+ tools
  place_value_probe / treevalue_*); a treevalue_probe gate run was 95 min in at 14:05. Then phase 4 (re-gate 10 steps) and
  the BoutRead recalibration: tests/debut_read_test.gd fails 2 Lucy gap -2 lines (read 0.617 vs played 0.540).
  NEVER stage those files; never `git pull --rebase --autostash` while they are dirty (S534 did once - it applied clean).
- Fable DMGCLASS v3 (terminal "Fable DMGCLASS v3"): writes ops/research/DESIGN_DMGCLASS1_V3.md; then two critics
  (`python ops/Tools/design_loop.py critic DMGCLASS1_V3 <map> --seat kalli|john`).
- Seat queue: SQ271 John + SQ272 Kalli on turning pro v10; SQ273 Kalli + SQ274 John on guard v6 (the 30-min job sends them).
  Dola's app is closed (no CDP on 9333): she gets nothing until it is open.

## Built in S534 (all on main, build exported 14:09)
- Pro offer: VS <debutant> on each house header (each house its own name), the Debut row = why picked, no rating gap; hover =
  what the debutant brings + the softer-opponent ask; MORALE line (ProOfferWire.morale_line) instead of "(morale -5)".
- Tooltip card 86% opaque (TipParts.CARD_BG); clipboard face removed; tooltip tests at 0 broken (ratchets locked at 0).
- BoutFinish: an RTD (towel / cracked rib) wears no chin (towel_wire_test red -> green).
- Fight player v2: GuardHold holds both hands through a reaction (film 16, player2_test HANDS 336/710 -> 0/710).
- LOANPROBE1 collected (docs/LOANPROBE1_RESULT.md): the loan grows the gym, never a trap; the "8 weeks banked" bar was the
  probe's player, not a game rule.
- Palette guard green (RingTopDown colours into Palette).

## Next, in order
1. Collect STEPPAY2 + DMGCLASS v3. 2. Act on the critics' scores (v10 pro, v6 guard). 3. The owner plays the S534 build
   (Builds/FightCamp.exe, WHAT_TO_TRY.txt top section): act on his notes and review-board comments.

# S570 digest (2026-11-27, Opus 5.5)

## What now works
- ONE RULES CORE (owner S569 "how it knows the current changes ?"): kick.html, head.html, one.html are BUILT from
  order.html (make_kick.py / make_head.py + s558_balance/kick_page.json, head_page.json). v0.570.1 / .3.
- The strip shows the guard you hold on every still moment, with its picture (owner: "doesnt guard high count as a beat
  ?"); a shared frame canvas was being stolen between boxes. v0.570.2. A drop onto slot 2 with slot 1 empty now says why
  it goes first. v0.570.4.
- LAYERS0 DONE (he bought Cascadeur Indie + the Animo pack): one man per picture cut from the existing frames by their
  part masks (layers_cut.py), layers_ui.js behind ?layers=1 with a clip blend; the jab + holds family: 0 jumps over 4 px
  (base 33). Phase 1 = every family re-rendered with masks (docs/LAYERS0_RESULT.md). Animo pack catalogued (121 takes).
- OCTAGON TACTICS (the owner's own design, two PDFs + a 52-card CSV): a boxing engine (proto/octagon), cups between the
  agents and Claude, v1 -> v2 -> v3 (his CSV cards) -> v3.1 -> v4 (ATTRIBUTES + WEIGHT CLASSES + a draft). Fun by cup:
  v1 6.4, v2 6.5, v3 7.0 (depth 7.25 - at target). Target FUN 8 / DEPTH 7 (owner: "keep playing until you reach").
  v4: seven attributes, four classes with caps / punch weight / health / stamina (J20 corpus), eight middleweights
  balanced on bots 42-59%; draft: John Ghost, Claude Iron, Kalli Body Shop, Maria Snapshot. Round 1: Maria beat Claude
  28-27, Kalli KO'd John in round 3.

## Evidence
page_play_test 4 (order, head, one, kick, mmc), head_test 11, kick_test 12, rules_test 37, anim_check 160/160; bot runs
in docs/OCTAGON1_RESULT.md and docs/OCTAGON_ATTRIBUTES_SPEC.md; every cup log + verdict in ops/research/octagon/cup*.

## Not done / broken
- Octagon stamina: at 0 stamina every card is unaffordable -> "dead hand" swap -> the reshuffle costs 2 -> both men
  locked at 0 for a whole round (Claude v Maria R3). Fix first: the swap counts RANGE only, no reshuffle penalty on a
  swap, a spent man (< 3) gets +1 for an exchange he does not attack.
- Workers: KICKFIX6 and RULES569 PAUSED (suspended node runs 63064, 6436, 60420 - resume with ops/Tools/proc_pause.ps1
  -Id <pid> -Action resume) while the owner played ArcheAge; BUILD1 running (round 3 of its probe).
- No Godot game script changed: no export this session (tools/pics2d_anim.gd layers=1 is a tool).

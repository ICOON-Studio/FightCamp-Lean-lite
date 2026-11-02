---
name: project-live-limb-damage
description: Operator 2026-09-27 wants per-limb damage LIVE in the fight (limb turns red, pain/limp reaction, body figure pointing at it) tied to corner duties/options; surveys G132+D44 first, build = S97
metadata:
  type: project
---
Operator 2026-09-27, verbatim: "the limbs need to have some kind of threshold when for example fighters get kicked really hard on one of their legs limb go to red and animations play someone who is in pain on his red leg for a bit" and "i want this to be live on the fight pointing damage, need proper survey how to make it engaging and linked to the corner duties and options".

**Why:** the body map only showed injuries on the profile; in-fight damage was only per-bout totals (head/body/leg), no per-limb state, no limp, no corner action per region.

**How to apply:** surveys first - G132 (Grok: real corner playbook per region, how games/broadcasts show limb damage, thresholds + rates, interesting vs busywork decisions) and D44 (Dola: corner minute from the player's chair); collect in S96, build S97: (1) per-limb state behind a switch + census before default-on (Q183 lesson); (2) a BODY FIGURE pointing at the limb - the operator's ask overrides M23's letter-chip choice unless surveys give a strong reason (then both); procedural limp + ~1 s stung reaction; (3) corner actions per region wired to K72/K73 words and C31 legality, each paying off next round; (4) targeting AI, scouting, post-fight injury -> body map. Existing pieces: M23_REGION_READOUT, K72_CORNER_CARD, K73_REGION_SENTENCES, C31_THE_CORNER, C162 CornerPanel, BodyMapFigure.gd. See [[project-session-S95-2026-09-27]].

## S96 update - surveys COLLECTED, design DECIDED
G132, D44 (second send), G133 all in research. The operator added (2026-09-27, verbatim): "in between the rounds i want the corner to be presented (visually indicators,text wtc) with the problems and be able to understand them and be able to address them against the limited time" and the dilemma "do not blow the nose in danger of the eye swalling or risk blowing it for some benefit ?".
Decision: LIVE = on-fighter cues (limp, stung ~1 s) + small colour chips, NO full-body HUD live (G132, D44). The operator's BODY FIGURE lives in the CORNER screen, which is Motorsport Manager's pit stop: silhouette with 1-3 hotspots, severity WORD, ~45 s usable bar (G133: 45-50 s of the 60), 2-3 cards Benefit|Risk|seconds, cutman + chief second in parallel lanes, careful/normal/rushed pace (rushed = mistake pip), nose-blow card first (orbital emphysema risk), payoff shown at the next bell; decidable in 5 s. Fight-plan-as-MM-setup is a LATER stage. See [[project-session-S96-2026-09-27]], [[reference-motorsport-manager-install]].

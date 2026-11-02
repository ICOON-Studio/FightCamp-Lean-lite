# C57 digest — selection pathways

Research-only result, 2026-09-08. Two files were written; no code, test, or
HANDOFF file was changed.

## Finding

The task says six disciplines, but current [tournaments.json](../assets/data/tournaments.json#L11-L12)
contains nine: kickboxing, karate, judo, wrestling, Brazilian jiu-jitsu,
taekwondo, muaythai, sambo, and MMA. The full record covers all nine and labels
the mismatch rather than silently inventing a six-item scope.

## Mechanism map

| Discipline | Who controls world entry | Quota / ladder | Result effect | Paid open entry |
|---|---|---|---|---|
| WAKO kickboxing | WAKO-recognized national team; internal selection UNKNOWN | Numeric quota UNKNOWN; national/continental prerequisite UNKNOWN | Placing recorded; future entry/seed UNKNOWN | No; price UNKNOWN |
| WKF karate | National federation; senior final phase one per category | Fixed one per NF/category; qualification and final phases; prior continental requirement UNKNOWN | Same-event qualification-phase advancement; future entry UNKNOWN | Karate 1 is open, Worlds are not; price UNKNOWN |
| IJF judo | Ranking-gated eligibility, then National Federation entry | Up to 9 per sex, max 2/category; lower-rung bypass is supported | Ranking eligibility/seeding; next-world entry UNKNOWN | No; price UNKNOWN |
| UWW wrestling | Affiliated National Federation | One per NF/weight; same-age continental participation required | Olympic NOC quota is separate; next-world entry UNKNOWN | No; price UNKNOWN |
| IBJJF BJJ | Athlete paid registration with membership, subject to capacity | No national quota stated; no ladder | Ranking/seeding direction; guaranteed future entry UNKNOWN | **Yes; World No-Gi 2026: $119/$133 USD** |
| WT taekwondo | MNA national-team entry; ranking seeds | One per MNA/weight; continental route shown for Olympics, not Worlds | Ranking/seeding; future entry UNKNOWN | No; numeric price UNKNOWN |
| IFMA muaythai | National Association entry | World quota UNKNOWN; continental prerequisite UNKNOWN | World Games ranking/confirmation route; next Worlds UNKNOWN | No; price UNKNOWN |
| FIAS sambo | National federation/database entry | One per country/weight; continental prerequisite UNKNOWN | Ranking/draw seeding; future entry UNKNOWN | No; price UNKNOWN |
| IMMAF MMA | National team/federation; current internal selection UNKNOWN | Current quota UNKNOWN; continental event can be bypassed, priority route | Ranking points can buy priority entry/seeding, not guaranteed seat | No; price UNKNOWN |

Governing documents: [WAKO rules](https://wakousa.org/wp-content/uploads/2025/05/WAKO-Rules-25.10.2022.pdf),
[WKF 2026 rules](https://www.wkf.net/files/pdf/documents/WKF%202026%20Kumite%20Competition%20Rules%20MASTER%20COPY_V11.pdf),
[IJF World Championship notice](https://www.ijf.org/news/show/the-list),
[UWW regulations](https://uww.org/sites/default/files/media/document/gen_reg_for_int_champs_compets_a.pdf),
[IBJJF World No-Gi event](https://ibjjf.com/events/world-ibjjf-jiu-jitsu-no-gi-championship-2026),
[WT 2025 outline](https://www.worldtaekwondo.org/att_file/news/%28v3%29%20Event%20Outline_Wuxi%202025%20World%20Taekwondo%20Championships_4%20August%202025.pdf),
[IFMA Constitution](https://muaythai.sport/wp-content/uploads/2024/11/IFMA_Constitution_JUNE2024.pdf),
[FIAS ranking regulations](https://sambo.sport/upload/iblock/cfd/cfde08adbf6a0353c628c9a59ac54f8a.pdf),
and [IMMAF eligibility/entry material](https://immaf.org/athletes/athlete-eligibility/).

## Game seams

* `invite_min_fame: 40` and Grand Prix seating are authored simulation rules,
  not evidence of national selection ([tournaments.json](../assets/data/tournaments.json#L3-L12);
  [GameState.gd](../scripts/GameState.gd#L8469-L8472)).
* `EventResult.selection_effect` defaults to `"none"` and is validated, but no
  named producer sets it ([EventResult.gd](../scripts/EventResult.gd#L7-L24)).
* `national_selection` remains an evidence-gated pure cost with no purse, ever;
  `pays_purse` is true only for signing ([EntityPathway.gd](../scripts/EntityPathway.gd#L19-L23);
  [EntityPathway.gd](../scripts/EntityPathway.gd#L180-L184)). C54 is not reopened.
* The player owns a gym, while federation/NOC systems own national entries and
  quotas. The ownership bridge is **UNKNOWN**; no fix is proposed.
* `_turn_pro` records a one-way marker/cause, but the discipline-specific
  mapping is **UNKNOWN** ([GameState.gd](../scripts/GameState.gd#L5499-L5505)).


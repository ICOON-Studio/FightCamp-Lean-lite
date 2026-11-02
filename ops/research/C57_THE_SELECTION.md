# C57 — The selection: how an athlete gets into a championship

Research record for C57. Sources were checked on 2026-09-08. “World
championship” means the senior world championship or the flagship world-level
championship named by the governing body; Olympic qualification is called out
separately. Where the governing document does not establish a rule, the result
is **UNKNOWN**, not an inferred open field or quota.

## Scope correction: the game currently names nine disciplines

The task brief says “six event disciplines,” but the current authored tournament
data names nine: kickboxing, karate, judo, wrestling, Brazilian jiu-jitsu,
taekwondo, muay thai, sambo, and MMA. This is a source-backed count from the
current [tournaments.json](../assets/data/tournaments.json#L11-L12), not a
design choice. The report therefore covers all nine so that the three entries
present in the data are not silently omitted. The word “authored” is important:
the same file describes its tournament numbers as authored simulation values
([tournaments.json](../assets/data/tournaments.json#L3-L3)).

The current model also has an explicit invite gate: `invite_min_fame` is 40
([tournaments.json](../assets/data/tournaments.json#L11-L12)). `_announce_grand_prix`
chooses a host’s first tournament discipline and a class a qualifying roster
fighter can enter, or the deepest class ([GameState.gd](../scripts/GameState.gd#L8469-L8472)).
That is an authored event-seat rule, not evidence of a real federation
selection process.

## Executive finding

The nine published systems do not collapse into one universal “qualification”
mechanic. They divide into four evidence-backed patterns:

1. national-federation entry is the controlling gate (WAKO kickboxing, WT
   taekwondo, IFMA muaythai, FIAS sambo, and IMMAF MMA; WKF karate and UWW
   wrestling also use national bodies for the actual entry);
2. a ranking gate controls eligibility or priority, while the national body
   still submits the athlete (IJF judo; also ranking is used for seeding in
   WT and FIAS);
3. a qualification phase or continental participation rule can constrain the
   route (WKF’s senior qualification/final phases; UWW’s mandatory continental
   participation; IMMAF’s historical priority system); and
4. paid open entry is real for IBJJF Brazilian jiu-jitsu, but that is not the
   same as a national-team world championship.

No source found here proves that a placing at an ordinary event automatically
grants entry to the next edition of a world championship. The safe result
effect is therefore usually “ranking/seeding only,” “same-event advancement,”
or **UNKNOWN**—not an invented future quota.

## 1–4. Who picks, quota, ladder, and what a result buys

### Kickboxing — WAKO

**Governing body/document.** World Association of Kickboxing Organizations
(WAKO), [Rules Overview](https://www.wako.sport/rules-overview), and [WAKO
Rules v17.4](https://wakousa.org/wp-content/uploads/2025/05/WAKO-Rules-25.10.2022.pdf),
especially the general competition rules and world/continental championship
structure.

**Who picks.** WAKO’s world championship is restricted to WAKO-recognized
national teams/national-federation members; the federation or association
submits the athlete. The WAKO rules require valid WAKO membership and
registration through the WAKO systems, and state that only recognized national
teams participate in world championships ([WAKO Rules v17.4](https://wakousa.org/wp-content/uploads/2025/05/WAKO-Rules-25.10.2022.pdf)).
The athlete’s name-selection criteria inside each national federation are
**UNKNOWN** from the international rule found.

**Quota.** A fixed per-country-per-division quota is **UNKNOWN** in the cited
WAKO rules. Do not turn the existence of national teams into a numeric quota.

**Ladder.** WAKO publishes world championships, continental championships,
world cups, and national competitions, but the cited rules do not say that an
athlete must win or attend the national or continental rung before the world
championship ([WAKO Rules v17.4](https://wakousa.org/wp-content/uploads/2025/05/WAKO-Rules-25.10.2022.pdf)).
The ladder exists as a calendar; a compulsory national → continental → world
route is **UNKNOWN**.

**Result effect.** A WAKO result establishes placing/achievement at that
competition. An automatic next-world entry, next-world seed, or carried quota
is **UNKNOWN** in the cited rules. `selection_effect` should not be treated as
an automatic carry-over merely because a result exists.

**Open entry and price.** WAKO has open tournaments in its calendar, but the
world championship rule is national-team based, so WAKO world championship is
not an IBJJF-style paid open entry. A world-championship athlete price is
**UNKNOWN** from the cited governing document.

**Amateur/pro door.** Whether a WAKO world entry or fee interacts with the
game’s one-way professional marker is **UNKNOWN**. The international WAKO
rule does not establish the game’s transition semantics.

### Karate — WKF

**Governing body/document.** World Karate Federation (WKF), [2026 Kumite
Competition Rules](https://www.wkf.net/files/pdf/documents/WKF%202026%20Kumite%20Competition%20Rules%20MASTER%20COPY_V11.pdf)
and [2026 Kata Competition Rules](https://www.wkf.net/files/pdf/documents/WKF%20Kata%20Competition%20Rules%202026%20MASTER%20COPY_V2.pdf).

**Who picks.** WKF requires athletes at official world championships to
represent a recognized national federation. The federation submits the
athlete; the rules do not make the international ranking itself the final
selector of the named athlete ([WKF 2026 Kumite Competition Rules](https://www.wkf.net/files/pdf/documents/WKF%202026%20Kumite%20Competition%20Rules%20MASTER%20COPY_V11.pdf),
eligibility and nationality provisions).

**Quota.** For the senior individual world championship final phase, each
national federation is limited to one athlete per category. The qualification
phase has specific limitations, including a bar on registering another athlete
in a category when that federation already has a final-phase qualifier ([WKF
2026 Kumite Competition Rules](https://www.wkf.net/files/pdf/documents/WKF%202026%20Kumite%20Competition%20Rules%20MASTER%20COPY_V11.pdf),
Article 16.2; the kata rules carry the same one-per-category structure).
This is a fixed one-per-country-per-category limit for the final phase, not an
earned quota.

**Ladder.** WKF explicitly distinguishes a senior qualification phase and a
final phase. That is a qualification event/phase inside the world-championship
format, not evidence that a national or continental championship is always a
required prior rung. A compulsory national → continental → world route is
**UNKNOWN** for the senior world championship ([WKF 2026 Kumite Competition
Rules](https://www.wkf.net/files/pdf/documents/WKF%202026%20Kumite%20Competition%20Rules%20MASTER%20COPY_V11.pdf)).

**Result effect.** A qualification-phase placing can advance an athlete to the
final phase of that championship where the event rules provide that phase; that
is same-event advancement, not a next-edition entitlement. A placing at an
ordinary WKF event automatically granting world-championship entry or quota is
**UNKNOWN**. `Karate 1` open-event ranking/entry must not be conflated with
senior World Championship qualification ([WKF 2026 Kumite Competition Rules](https://www.wkf.net/files/pdf/documents/WKF%202026%20Kumite%20Competition%20Rules%20MASTER%20COPY_V11.pdf)).

**Open entry and price.** WKF says Karate 1 events are open to WKF members,
but that is an open-series exception, not an open senior World Championship.
No senior World Championship athlete price is established in the cited rules
([WKF 2026 Kumite Competition Rules](https://www.wkf.net/files/pdf/documents/WKF%202026%20Kumite%20Competition%20Rules%20MASTER%20COPY_V11.pdf)).

**Amateur/pro door.** A WKF rule linking payment or world selection to the
game’s `_turn_pro` marker is **UNKNOWN**.

### Judo — IJF

**Governing body/document.** International Judo Federation (IJF), [World Judo
Championships eligible-athlete notice](https://www.ijf.org/news/show/the-list)
and [IJF regulations/documents index](https://www.ijf.org/ijf/documents).

**Who picks.** IJF publishes an eligibility ranking gate: for the cited Doha
2023 senior world championship, only athletes ranked 1–100 in the senior World
Ranking List could take part, after which each National Federation submitted its
entries ([The List — IJF](https://www.ijf.org/news/show/the-list)). Thus this is
ranking-gated national-federation entry, not a pure “the ranking names the
athlete” mechanism.

**Quota.** The cited IJF notice permits each national federation up to nine
entries per sex, with a maximum of two athletes per category; the host has a
separate provision ([The List — IJF](https://www.ijf.org/news/show/the-list)).
The per-country cap is fixed by the event rules, while the ranking threshold is
an eligibility gate. It is not an earned continental quota.

**Ladder.** The cited World Championship rule uses the IJF world ranking and
national-federation entry. It does not require an athlete to pass national and
continental championships first. National → continental → world as a
mandatory ladder is **UNKNOWN**; the evidence supports a ranking route that can
bypass those lower events ([The List — IJF](https://www.ijf.org/news/show/the-list)).

**Result effect.** Judo results feed the ranking system and can affect future
eligibility and seeding. A placing at one ordinary event automatically granting
the next World Championship entry or a nation’s quota is **UNKNOWN** in the
cited notice. The existing `ranking_points` field is a better-supported
description than an automatic `selection_effect`.

**Open entry and price.** IJF senior World Championships are federation-entry
events, not paid open entry. An athlete-facing World Championship price is
**UNKNOWN** in the cited IJF document.

**Amateur/pro door.** The cited IJF documents do not establish an interaction
with the game’s `_turn_pro` one-way marker; that interaction is **UNKNOWN**.

### Wrestling — UWW

**Governing body/document.** United World Wrestling (UWW), [General
Regulations for Championships and International Competitions](https://uww.org/sites/default/files/media/document/gen_reg_for_int_champs_compets_a.pdf).

**Who picks.** UWW places entry with the affiliated National Federation. A
federation registers its wrestlers and must satisfy licensing, medical, and
financial conditions ([UWW General Regulations](https://uww.org/sites/default/files/media/document/gen_reg_for_int_champs_compets_a.pdf),
Articles 26–27). The document does not prescribe the internal national
selection trial or ranking used to choose the named wrestler; that part is
**UNKNOWN**.

**Quota.** Each National Federation may enter a maximum of one wrestler per
weight category ([UWW General Regulations](https://uww.org/sites/default/files/media/document/gen_reg_for_int_champs_compets_a.pdf),
Article 27). This is a fixed one-per-country-per-weight limit.

**Ladder.** UWW requires a national federation entering a cadet, junior, or
senior World Championship to have participated in the same-age-group
Continental Championship with at least as many participants, except for the
host-federation exception ([UWW General Regulations](https://uww.org/sites/default/files/media/document/gen_reg_for_int_champs_compets_a.pdf),
Article 27). Here continental participation is a requirement, not merely a
helpful qualifier. The rule does not require a national championship.

**Result effect.** For the World Championship itself, a placing does not prove
automatic entry to the next UWW World Championship; that is **UNKNOWN**. For
Olympic qualification, UWW separately allocates quotas through World
Championships, ranking series, continental qualifiers, and a world qualifier
([UWW LA28 qualification announcement](https://cms.uww.org/article/uww-announces-la-2028-olympic-qualification-calendar?base_route_name=entity.node.canonical&overridden_route_name=entity.node.canonical&page_manager_page_variant=panels_variant-7&page_manager_page_variant_weight=-4)).
That is an Olympic NOC quota, not a personal next-world entry and not a gym
roster right.

**Open entry and price.** UWW World Championships are National Federation
entries, not paid open entry. The cited governing regulation does not publish an
athlete world-entry price; **UNKNOWN**.

**Amateur/pro door.** The cited UWW championship regulation does not define an
interaction with `_turn_pro`; **UNKNOWN**.

### Brazilian jiu-jitsu — IBJJF

**Governing body/document.** International Brazilian Jiu-Jitsu Federation
(IBJJF), [IBJJF membership](https://ibjjf.com/athletes/become-a-member) and
[2026 World IBJJF Jiu-Jitsu No-Gi Championship event page](https://ibjjf.com/events/world-ibjjf-jiu-jitsu-no-gi-championship-2026).

**Who picks.** IBJJF’s paid event model is open registration subject to active
membership, belt/age/weight eligibility, deadlines, and capacity. The athlete
registers; a national federation does not select a national team for the
ordinary IBJJF championship ([IBJJF membership](https://ibjjf.com/athletes/become-a-member);
[IBJJF event registration terms](https://ibjjf.com/events/world-ibjjf-jiu-jitsu-no-gi-championship-2026)).

**Quota.** No per-nation cap is stated on the cited event page. Capacity can
close registration, but that is venue/event capacity, not a one-per-country
quota ([IBJJF event registration terms](https://ibjjf.com/events/world-ibjjf-jiu-jitsu-no-gi-championship-2026)).

**Ladder.** There is no national → continental → world requirement for this
paid open-entry event. The athlete needs membership and event eligibility; a
lower championship is not shown as a prerequisite ([IBJJF membership](https://ibjjf.com/athletes/become-a-member)).

**Result effect.** Results contribute to IBJJF rankings; a placing does not,
in the cited entry material, automatically grant a next-event seat or national
quota. `selection_effect` is therefore **UNKNOWN** for a future World
Championship, while ranking/seeding is the supported direction ([IBJJF athlete
ranking information](https://ibjjf.com/athlete-ranking-info)).

**Open entry and price.** This is the clear paid open-entry exception. The
2026 World No-Gi event page publishes athlete registration prices of **$119 USD
until 11 November 2026 and $133 USD until 29 November 2026**, alongside the
membership and deadline conditions ([IBJJF World No-Gi 2026](https://ibjjf.com/events/world-ibjjf-jiu-jitsu-no-gi-championship-2026)).
Prices are event- and deadline-specific, not a universal IBJJF tariff.

**Amateur/pro door.** Paying IBJJF entry does not, in the cited IBJJF material,
turn an athlete professional. IBJJF does apply belt/eligibility restrictions
to athletes with proven judo, professional MMA, amateur MMA, or wrestling
experience ([IBJJF event eligibility](https://ibjjf.com/events/fortaleza-winter-international-open-ibjjf-jiu-jitsu-championship-2026)).
That is not the same rule as the game’s `_turn_pro`; interaction with the
game’s one-way door is **UNKNOWN**.

### Taekwondo — WT

**Governing body/document.** World Taekwondo (WT), [Wuxi 2025 World Taekwondo
Championships Event Outline](https://www.worldtaekwondo.org/att_file/news/%28v3%29%20Event%20Outline_Wuxi%202025%20World%20Taekwondo%20Championships_4%20August%202025.pdf)
and [WT Event Operations Rules](https://www.worldtaekwondo.org/att_file/documents/WT%20Event%20Operations%20Rules%20as%20of%20May%2012%2C%202024.pdf).

**Who picks.** WT accepts National Team entry through the Member National
Association’s online registration system. The 2025 outline requires a valid
WT Global Athlete Licence and a “Country Name National Team” entry ([WT Wuxi
2025 Event Outline](https://www.worldtaekwondo.org/att_file/news/%28v3%29%20Event%20Outline_Wuxi%202025%20World%20Taekwondo%20Championships_4%20August%202025.pdf)).
The outline seeds athletes by WT World Ranking, but ranking is not stated to
replace the MNA’s choice of athlete.

**Quota.** The 2025 senior World Championship outline sets a maximum of one
athlete per weight category per MNA ([WT Wuxi 2025 Event Outline](https://www.worldtaekwondo.org/att_file/news/%28v3%29%20Event%20Outline_Wuxi%202025%20World%20Taekwondo%20Championships_4%20August%202025.pdf)).
This is fixed, not an earned quota.

**Ladder.** The cited World Championship outline does not require a national
or continental championship first. WT separately recognizes Continental
Qualification Tournaments for the Olympic Games ([WT Event Operations Rules](https://www.worldtaekwondo.org/att_file/documents/WT%20Event%20Operations%20Rules%20as%20of%20May%2012%2C%202024.pdf)),
so Olympic qualification must not be mistaken for the senior World
Championship entry ladder. A mandatory national → continental → world route is
**UNKNOWN**.

**Result effect.** World Ranking is used for World Championship seeding, but an
automatic next-world entry, seeding guarantee, or carried quota from a placing
is **UNKNOWN** in the cited outline. `ranking_points`/seeding is supported;
future `selection_effect` is not.

**Open entry and price.** The World Championship is a national-team entry, not
paid open entry. The 2025 outline does not publish a numeric athlete price;
**UNKNOWN**. An older WT outline confirms that the organizing committee may
collect an entry fee from participating national teams, but that is not an
athlete-paid open-entry price ([Manchester 2019 WT Outline](https://www.worldtaekwondo.org/att_file/news/Outline_Manchester-2019-WTC_20190425.pdf)).

**Amateur/pro door.** Interaction with `_turn_pro` is **UNKNOWN**. WT national
team entry and a WT licence do not, by themselves, document the game’s
professional transition.

### Muaythai — IFMA

**Governing body/document.** International Federation of Muaythai Associations
(IFMA), [IFMA Constitution](https://muaythai.sport/wp-content/uploads/2024/11/IFMA_Constitution_JUNE2024.pdf)
and [IFMA International Competition Rules & Regulations](https://muaythai.sport/wp-content/uploads/2026/05/IFMA-Rules-and-Regulations-v3.057_110526.pdf).

**Who picks.** IFMA’s Constitution describes World Championships as being on a
National entry basis, and the competition rules require the athlete to belong
to an IFMA member National Association and represent that nationality
([IFMA Constitution](https://muaythai.sport/wp-content/uploads/2024/11/IFMA_Constitution_JUNE2024.pdf);
[IFMA Rules & Regulations](https://muaythai.sport/wp-content/uploads/2026/05/IFMA-Rules-and-Regulations-v3.057_110526.pdf)).
The international documents do not specify how each National Association
selects its athlete; that internal choice is **UNKNOWN**.

**Quota.** A numeric per-country-per-division quota for the IFMA World
Championship is **UNKNOWN** in the cited documents. IFMA’s separate 2025 World
Games notice allows a maximum of three athletes per National Federation (six
for host China), but that is a World Games quota and must not be copied onto
World Championships ([IFMA World Games qualification](https://muaythai.sport/ifmas-global-ranking-system-for-2025-world-games-qualification/)).

**Ladder.** IFMA runs national associations, continental championships, and
World Championships, but the cited documents do not establish that the
continental event is a compulsory prerequisite for Worlds. National →
continental → world as a requirement is **UNKNOWN**.

**Result effect.** IFMA ranking results can contribute to a later multi-sport
qualification route: the World Games system uses IFMA global ranking and then
requires National Federations to confirm selected athletes ([IFMA World Games
qualification](https://muaythai.sport/ifmas-global-ranking-system-for-2025-world-games-qualification/)).
That supports ranking/selection priority for the World Games, not automatic
entry to the next IFMA World Championship. The latter is **UNKNOWN**.

**Open entry and price.** IFMA World Championships are national-entry events,
not IBJJF-style paid open entry. No athlete-facing World Championship price is
published in the cited documents; **UNKNOWN**.

**Amateur/pro door.** The cited IFMA rules do not map World Championship entry
or payment to the game’s `_turn_pro` transition; **UNKNOWN**.

### Sambo — FIAS

**Governing body/document.** International SAMBO Federation (FIAS), [FIAS
documents index](https://www.sambo.sport/en/fias/documents/) and [FIAS World
Ranking List Regulations](https://sambo.sport/upload/iblock/cfd/cfde08adbf6a0353c628c9a59ac54f8a.pdf).

**Who picks.** World Championship registration is handled through the FIAS
database by national SAMBO federations; the athlete therefore enters through
the national federation. The international rule does not state the internal
national trial or appointment method; **UNKNOWN** ([FIAS 2026 World
Championships notice](https://new.sambo.sport/en/news/opublikovan-reglament-chempionata-mira-po-sambo-2026-goda/)).

**Quota.** FIAS states that World Championships and Continental Championships
allow one athlete per country in each weight category ([FIAS World Ranking List
Regulations](https://sambo.sport/upload/iblock/cfd/cfde08adbf6a0353c628c9a59ac54f8a.pdf)).
This is a fixed one-per-country-per-weight limit. Ranking is separately used in
the ranking system and can influence draws/seeding; it is not shown as the
sole selector of the national entrant ([FIAS ranking announcement](https://sambo.sport/en/news/obnovleno-polozhenie-o-reytinge-fias/)).

**Ladder.** FIAS recognizes continental championships and World Championships,
but the cited rules do not prove that a continental result or appearance is
mandatory before Worlds. The requirement is **UNKNOWN**.

**Result effect.** FIAS ranking points influence the ranking list and draw
seeding ([FIAS ranking announcement](https://sambo.sport/en/news/obnovleno-polozhenie-o-reytinge-fias/)).
Automatic next-world entry or a carried quota is **UNKNOWN**.

**Open entry and price.** World Championship registration is through national
federations/database, not paid open entry. A numeric athlete entry price is
**UNKNOWN** in the cited documents.

**Amateur/pro door.** Interaction with `_turn_pro` is **UNKNOWN**; the cited
FIAS documents do not establish the game’s career-status transition.

### MMA — IMMAF

**Governing body/document.** International Mixed Martial Arts Federation
(IMMAF), [Athlete Eligibility](https://immaf.org/athletes/athlete-eligibility/),
[2021 amateur/pro eligibility document](https://immaf.org/wp-content/uploads/2021/03/2021-Amateur-MMA-Eligibility-to-Compete.pdf),
and [2017 World Championship entry-criteria notice](https://immaf.org/2017/01/16/registration-opens-for-the-2017-immaf-european-open-championships-2/).

**Who picks.** IMMAF championship athletes operate through national teams and
national federations; athletes are directed to their national federation for
selection and entry criteria ([IMMAF registration/entry notice](https://immaf.org/2017/01/16/registration-opens-for-the-2017-immaf-european-open-championships-2/)).
The exact current internal selection process is **UNKNOWN**.

**Quota.** A current per-nation quota for the World Championships is
**UNKNOWN**. The 2017 notice used staged capacity rules and, at the final
all-federation stage, a maximum of two entries per weight division; that is a
dated event policy, not safe evidence of today’s quota ([IMMAF 2017 entry
criteria](https://immaf.org/2017/01/16/registration-opens-for-the-2017-immaf-european-open-championships-2/)).

**Ladder.** The 2017 IMMAF notice expressly changed the rule so that athletes
did not have to participate in a continental event in the same year to enter
Worlds. Continental championships nevertheless produce ranking points that can
give priority entry and seeding at the flagship World Championships ([IMMAF
2017 entry criteria](https://immaf.org/2017/01/16/registration-opens-for-the-2017-immaf-european-open-championships-2/);
[IMMAF continental-championship report](https://immaf.org/2020/02/25/immaf-unveils-athletes-teams-for-the-oceania-mma-championships-watch-on-immaf-tv/)).
Thus continental is a useful qualifier/priority route, not a proven universal
requirement.

**Result effect.** Continental results grant ranking points and can produce
priority entry and seeding opportunities at Worlds ([IMMAF continental
championship report](https://immaf.org/2020/02/25/immaf-unveils-athletes-teams-for-the-oceania-mma-championships-watch-on-immaf-tv/)).
This is the clearest evidence for a `selection_effect` beyond “none,” but it
still does not prove a guaranteed next-world seat. Guaranteed entry/quota is
**UNKNOWN**.

**Open entry and price.** IMMAF Worlds are national-team/capacity-controlled
championship entries, not a general paid open-entry event. The cited notice
does not publish a current athlete world-entry price; **UNKNOWN**.

**Amateur/pro door.** IMMAF is explicit that championship competitions are for
amateur athletes and excludes athletes who have competed professionally; its
eligibility page also treats receiving a contracted purse as professional
([IMMAF Athlete Eligibility](https://immaf.org/athletes/athlete-eligibility/)).
That is an actual one-way eligibility boundary in the sport. It still does not
prove how the game should call `_turn_pro`; the game interaction is **UNKNOWN**.

## 5. The open-entry exception

The evidence-backed paid open-entry case among the nine current tournament
disciplines is IBJJF Brazilian jiu-jitsu. IBJJF requires active membership and
accepts registration/payment until a deadline or capacity closure; its 2026
World No-Gi page publishes the two deadline prices listed above ([IBJJF
membership](https://ibjjf.com/athletes/become-a-member); [IBJJF World No-Gi
2026](https://ibjjf.com/events/world-ibjjf-jiu-jitsu-no-gi-championship-2026)).

The other eight are not evidenced as paid open world-championship entry in the
governing material used here. They use a national federation/team, a
ranking-gated federation entry, or a federation/capacity process. Where an
entry fee exists at team or federation level, the athlete-facing amount is
**UNKNOWN** unless the governing event page publishes it. “Pays an entry fee”
therefore cannot be used as a generic `open_entry` classifier.

Payment does not itself establish the game’s amateur/professional transition.
IBJJF’s restrictions and IMMAF’s professional-athlete exclusion are separate
eligibility rules ([IBJJF event eligibility](https://ibjjf.com/events/fortaleza-winter-international-open-ibjjf-jiu-jitsu-championship-2026);
[IMMAF Athlete Eligibility](https://immaf.org/athletes/athlete-eligibility/)).
For the game’s one-way door, a paid open entry is not evidence of `_turn_pro`.

## 6. Gap against the current game model

### Fame is standing in for every real entry mechanism

The current authored tournament rule sets `invite_min_fame` to 40 and the
Grand Prix announcer seats a qualifying roster fighter or uses the deepest class
([tournaments.json](../assets/data/tournaments.json#L11-L12);
[GameState.gd](../scripts/GameState.gd#L8469-L8472)). Real systems above also
need, depending on discipline, national-body submission, an IJF ranking
eligibility gate, WKF phase eligibility, a UWW continental-participation
requirement, fixed country caps, or paid IBJJF membership/registration. Fame is
therefore an authored invitation proxy, not a sourced selection explanation.

### A seated fighter is not automatically a national-team athlete

The player manages a gym. Most world systems above are entered by a national
federation or national team, while UWW explicitly treats an Olympic quota as
belonging to the NOC/country rather than to the individual wrestler ([UWW
Olympic qualification announcement](https://cms.uww.org/article/uww-announces-la-2028-olympic-qualification-calendar)).
The current Grand Prix seat logic has no sourced national-team owner in the
allowed seam. That ownership/authorization gap is **UNKNOWN**; this record does
not design a fix.

### `selection_effect` is structurally present but behaviorally unpopulated

`EventResult.make` copies `selection_effect` and defaults it to `"none"`
([EventResult.gd](../scripts/EventResult.gd#L7-L24)); validation requires the
field ([EventResult.gd](../scripts/EventResult.gd#L27-L51)), but the named
source gives no producer that assigns a non-default effect. The research answer
is not “every placing buys a world seat.” Supported effects are limited to
same-event advancement, ranking/seeding, or an explicitly sourced competition
quota; future-world entry is **UNKNOWN** for most disciplines.

### The ledger seam must retain C54’s ruling

The pathway source defines `national_selection` as a federation path with “No
purse, ever” ([EntityPathway.gd](../scripts/EntityPathway.gd#L19-L23)) and
`pays_purse` returns true only for the signing pathway
([EntityPathway.gd](../scripts/EntityPathway.gd#L180-L184)). Its fee logic is
also absent-aware: an un-authored fee is `FEE_UNKNOWN`, not silently free
([EntityPathway.gd](../scripts/EntityPathway.gd#L211-L219)). This report found
no evidence that contradicts C54. **C54 stands: `national_selection` is an
evidence-gated pure cost and pays no purse, ever.** The international
federation facts above do not reopen that money ruling; a team entry fee,
membership fee, or paid IBJJF registration is not a purse.

### The amateur/pro seam is not a selection shortcut

The named `_turn_pro` window records the one-way marker and cause when called
([GameState.gd](../scripts/GameState.gd#L5499-L5505)). The research sources show
that IMMAF has an amateur-only gate and IBJJF has sport-specific belt/eligibility
restrictions, but they do not specify the game’s cause mapping. That mapping is
**UNKNOWN**. No code change or transition rule is approved by this research.

## Evidence limits and authored inventions

* **Authored invention:** the nine-discipline tournament list, fame threshold,
  seat-held/deepest-class Grand Prix behavior, bracket size, purse, fame, and
  reputation values in `tournaments.json` are simulation values, not governing
  body rules ([tournaments.json](../assets/data/tournaments.json#L3-L23)).
* **UNKNOWN:** a universal six-discipline scope, current internal national
  selection trials for every federation, current numeric quotas where the
  governing document did not state one, athlete-facing prices outside the
  cited IBJJF event, and automatic next-world entry from a placing.
* **Not reopened:** C54’s `national_selection` money ruling remains in force.

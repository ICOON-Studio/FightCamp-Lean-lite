# COUNTRYDATA1 - Grok (grok.com SuperGrok, Expert mode), S228 2026-10-16

Brief: research/TASK_COUNTRYDATA1.md (operator S227 "use grok too"). Chat: https://grok.com/c/38143caa-f654-4156-868a-80f53e7f26d6
Two answers, ~150 + ~140 sources. Rows below are Grok's, verbatim in substance (schema of real_organizations.json); NOT yet merged.

## Verdict (Claude)
- 31 REAL boxing bodies with evidence grades and source URLs, 23 markets. Merge into Godot/assets/data/real_organizations.json
  (+ market_assignments) after a spot-check of 5 official_url links (next session, COUNTRYDATA1B).
- Sport culture: Grok returned UNKNOWN for almost every country (no source for shares summing to 100) - correct per our rule:
  the market card keeps hiding the culture block for non-curated markets (S227 profile_generated).
- talent_depth / combat_popularity: only 7 sourced from BoxRec-active counts (July 2025): Mexico ~4,192 active (98/95), USA ~3,478
  (95/92), Japan ~1,309 (88/80), UK ~1,068 (82/78), Argentina ~834 (70/65), Thailand / Philippines ~770-800 (65-68 / ~70).
- NOT sourced (amateur-only INHERITED at best, no national pro body confirmed): Ukraine, Ireland, Belgium, Sweden, Denmark, Hungary,
  Georgia, Puerto Rico, Dominican Republic, Cuba, Colombia, Venezuela, Nicaragua, Panama, China, South Korea, Indonesia, India,
  Nigeria, Ghana, Kenya, New Zealand, Turkey -> those markets show no federations block until sourced.

## Rows (id | name | country | role | evidence | official_url)
| id | name | country | role | evidence | url |
|---|---|---|---|---|---|
| bbbofc | British Boxing Board of Control | United Kingdom | pro regulator since 1929 (~2,500 licence holders, ~1,100 active) | DIRECT | https://bbbofc.com/ |
| england_boxing | England Boxing | United Kingdom | amateur, World Boxing from 1 Aug 2025 | INHERITED | https://www.englandboxing.org/ |
| usa_boxing | USA Boxing | United States | amateur NGB, World Boxing | DIRECT | https://www.usaboxing.org/ |
| abc | Association of Boxing Commissions | United States | pro: coordinates state/provincial/tribal commissions (no single national board) | DIRECT | https://www.abcboxing.com/ |
| fecombox | Federacion de Comisiones de Box Profesional de la Republica Mexicana | Mexico | pro commissions federation (1997) | DIRECT | https://www.fecombox.com.mx/ |
| fmb_mexico | Federacion Mexicana de Boxeo | Mexico | amateur, World Boxing (May 2025) | DIRECT | https://femebox.com/ |
| jbc | Japan Boxing Commission | Japan | pro commission since 21 Apr 1952 | DIRECT | https://jbc.or.jp/ |
| jbf | Japan Boxing Federation | Japan | amateur (1926), World Boxing | DIRECT | https://jabf-revival.com/ |
| gab_ph | Games and Amusements Board | Philippines | government pro regulator (1951) | DIRECT | https://gab.gov.ph/ |
| pbf | Philippine Boxing Federation | Philippines | pro organisation accredited under GAB | INHERITED | (facebook page; philboxing.com reporting) |
| bsa | Boxing South Africa | South Africa | statutory pro authority (Boxing Act 11 of 2001) | DIRECT | https://boxingsa.co.za/ |
| boxing_australia | Boxing Australia Limited | Australia | amateur NSO, World Boxing (pro: state level + ANBF) | DIRECT | https://www.boxing.org.au/ |
| fab_argentina | Federacion Argentina de Boxeo | Argentina | amateur + pro fiscalisation (1920) | DIRECT | https://fabox.com.ar/ |
| thailand_boxing_assoc | Thailand Boxing Association | Thailand | amateur (pro: multi-actor, PAT) | INHERITED | https://thailandboxing.or.th/ |
| rbf | Boxing Federation of Russia | Russia | amateur + pro since 1992 | DIRECT | https://rusboxing.ru/ |
| kfb_kz | Kazakhstan Boxing Federation | Kazakhstan | amateur, World Boxing | DIRECT | http://kfb.kz/ |
| kfpb | Kazakhstan Professional Boxing Federation | Kazakhstan | pro | DIRECT | https://profiboxing.kz/ |
| uzbf | Uzbekistan Boxing Federation | Uzbekistan | amateur (1992), World Boxing | DIRECT | http://www.olympicboxing.uz/ |
| upbf | Uzbekistan Professional Boxing Federation | Uzbekistan | pro | DIRECT | https://profboks.uz/ |
| dbv | Deutscher Boxsport-Verband | Germany | amateur, ~80,000 members / 900 clubs | DIRECT | https://www.boxverband.de/ |
| bdb | Bund Deutscher Berufsboxer | Germany | pro umbrella since 1949 | DIRECT | https://www.bund-deutscher-berufsboxer.de/ |
| ffboxe | Federation Francaise de Boxe | France | amateur + pro (LNBP), 1903 | DIRECT | https://www.ffboxe.com/ |
| fpi | Federazione Pugilistica Italiana | Italy | amateur + pro, 1916, CONI | DIRECT | https://www.fpi.it/ |
| rfebox | Real Federacion Espanola de Boxeo | Spain | amateur + pro (Comite de Boxeo Profesional) | DIRECT | https://feboxeo.es/ |
| pzb | Polski Zwiazek Bokserski | Poland | amateur + pro department, 1923 | DIRECT | https://pzb.com.pl/ |
| boxing_canada | Boxing Canada | Canada | amateur NGB (pro: provincial commissions) | DIRECT | https://boxingcanada.org/ |
| cbboxe | Confederacao Brasileira de Boxe | Brazil | amateur (1933), World Boxing | DIRECT | https://cbboxe.org.br/ |
| cbbp | Confederacao Brasileira de Boxe Profissional | Brazil | pro (1994) | DIRECT | https://cbbproboxe.com.br/ |
| nbb | Nederlandse Boksbond | Netherlands | amateur, NOC*NSF, World Boxing | DIRECT | https://www.boksen.nl/ |
| cyabf | Cyprus Amateur Boxing Federation | Cyprus | amateur (registered 1995); pro rules UNKNOWN | DIRECT | https://www.cyabf.com/ |

All rows: entity_type "federation", disciplines ["boxing"], discipline_weights {"boxing": 100}, regulator_kind "national_sport_authority",
verified_date 2026-10-16; tier/reputation values are Grok's proposals (A/B/C, 58-88) - treat as game scale, not fact.

## market_assignments (Grok)
United Kingdom [bbbofc, england_boxing]; United States [abc, usa_boxing]; Mexico [fecombox, fmb_mexico]; Japan [jbc, jbf];
Philippines [gab_ph, pbf]; South Africa [bsa]; Australia [boxing_australia]; Argentina [fab_argentina]; Thailand [thailand_boxing_assoc];
Russia [rbf]; Kazakhstan [kfb_kz, kfpb]; Uzbekistan [uzbf, upbf]; Germany [dbv, bdb]; France [ffboxe]; Italy [fpi]; Spain [rfebox];
Poland [pzb]; Canada [boxing_canada]; Brazil [cbboxe, cbbp]; Netherlands [nbb]; Cyprus [cyabf]

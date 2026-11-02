# COUNTRYDATA1 (S227) - real boxing bodies + sourced sport culture for the 40 biggest boxing markets

FightCamp is a PC boxing-gym management sim. On New Career the player picks a country (market); its card shows COMBAT POPULARITY,
TALENT DEPTH, ECONOMY (0-100), the SPORT CULTURE (share per combat sport) and the FEDERATIONS. House rule: organisations are REAL,
fighters fictional; never invent a number, a fee or a body.

## Prior research - BUILD ON IT, do not redo it (operator S227: "check existing research first")
- `Godot/assets/data/real_organizations.json` (snapshot 2026-09-01): 18 REAL bodies already sourced - UFC, PFL, ONE, RIZIN, GLORY,
  Karate Combat, Cyprus MMAF, Jungle Fight, IBJJF, Rajadamnern WS, LUX, ROAD FC, Kunlun, UWW, IJF, World Taekwondo, ARES, URCC - with
  `market_assignments` for 12 countries. It has NO boxing body at all (no BBBofC, no England Boxing, no commission). Your new rows use
  ITS schema exactly: id, name, short_name, entity_type (promotion | federation | tournament_operator), headquarters_country,
  disciplines, discipline_weights, tier, reputation, official_url, evidence (DIRECT | INHERITED | UNKNOWN), authority, regulator_kind,
  note, source {url, verified_date, facts}. Example row: the cyprus_mmaf entry in that file.
- `J1_ORGANIZATION_RULES_AND_JUDGES.md` and `J2_THE_FEDERATION_PATHWAY.md`: the grade vocabulary (DIRECT / INHERITED / UNKNOWN) and
  the UNKNOWN policy - if a primary page does not state it, it is UNKNOWN. Follow them; cite, do not restate.
- `Godot/assets/data/gym_distribution.json`: population, gdp_per_capita_usd, culture_tier, gym_count for all 175 countries - ALREADY
  the economy inputs; do not re-research population or GDP.
- `J8_THE_MEMBERS.md` N15: the culture / combat_popularity / talent_depth fields are INVENTED game fields today. This task replaces them
  with sourced values where a source exists.
- `GLOBEREVIEW1_JOHN_XAI.md`: already sourced for the UK - British Boxing Board of Control (since 1929; ~2,500 licence holders, ~1,100
  active boxers) and England Boxing (aligned with World Boxing from 1 Aug 2025). Reuse, do not re-search.
- `world_population_profiles.json` `countries`: 12 curated profiles (Mexico, USA, Japan, Philippines, Thailand, Brazil, China, South
  Korea, Netherlands, France, Georgia, Cyprus) - same scale; correct them only with a source.

## Deliver (the longest complete answer you can give)
1. **Boxing bodies** for the 40 countries with the most active professional boxers (rank by BoxRec-active pros or licence counts -
   name source and year): per country the PRO commission/board and the national AMATEUR federation, as `real_organizations.json` rows
   (entity_type "federation", disciplines ["boxing"], evidence graded), plus the `market_assignments` lines. One ```json block.
2. **Sport culture** per country: {boxing, wrestling, kickboxing, muay_thai, mma, brazilian_jiu_jitsu, judo, taekwondo, sambo} shares
   summing to 100 (omit zeros) with `culture_basis` (federation membership counts, licensed athletes, participation surveys) and an
   evidence grade per country; a country with no source for a share gets `"culture": "UNKNOWN"` - we would rather hide it than guess.
3. **talent_depth / combat_popularity** 0-100 relative to the 40, each with a one-line sourced basis (active pros, amateur members,
   world-title holders in the last 10 years, PPV/TV market) or UNKNOWN.
4. One paragraph: what could not be sourced.

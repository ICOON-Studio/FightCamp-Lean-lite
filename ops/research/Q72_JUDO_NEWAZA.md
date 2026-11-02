# Q72 - Judo's ground is held out of S1d: the rules and the seats it needs

## Part 1 - The rules, from what is already on disk

### IJF newaza rules that matter here

**1. Osaekomi (pin) scoring - G38:59-60, COMPETITION_RULESET_RESEARCH.md:567-570**

- Pin 10-19 seconds = waza-ari
- Pin 20 seconds = ippon (ends the match)
- Source: `G38_THE_GROUND_FIGHT_READ.md:59-60` and `COMPETITION_RULESET_RESEARCH.md:567-570`
- The scoreboard shows a separate osaekomi clock that starts when the referee calls "osaekomi" and stops on "toketa" (pin broken) or "matte" (stoppage).

**2. Golden score osaekomi - COMPETITION_RULESET_RESEARCH.md:567**

- Automatic waza-ari after 10 seconds of osaekomi during golden score specifically.
- Source: `COMPETITION_RULESET_RESEARCH.md:567`

**3. Shime-waza and kansetsu-waza (chokes and armlocks)**

- No progress graphic; tap, referee stop, or nothing.
- Source: `G38_THE_GROUND_FIGHT_READ.md:62`
- These are legal in judo (unlike MMA/IBJJF where some are restricted).

**4. Matte (stoppage) - NOT ON DISK**

- How quickly the referee calls "matte" to stand the fighters up after unproductive newaza is NOT ON DISK.
- G38:63 is explicit that osaekomi is not an MMA or IBJJF rule, but does not say how long a referee allows unproductive ground work before standing it up.

### What those rules are in exchanges at 14 s each

- AVG_SECONDS_PER_EXCHANGE = 14.0 (FightSimulation.gd:105)
- A 20-second osaekomi = 20/14 = **~1.4 exchanges**
- A 10-second osaekomi = 10/14 = **~0.7 exchanges**
- A 10-second golden-score osaekomi = 10/14 = **~0.7 exchanges** (but awards waza-ari, not ippon)

### Proposed judo matte and osaekomi mapping for the exchange model

**Osaekomi mapping:**

- A pin that lasts 1.4 exchanges (20 seconds) = ippon.
- A pin that lasts 0.7 exchanges (10 seconds) = waza-ari.
- A pin that lasts 0.7 exchanges in golden score = waza-ari (automatic).
- **Must NOT apply to:** MMA, IBJJF, karate, kickboxing, wrestling (G38:63 is explicit that osaekomi is not an MMA or IBJJF rule; wrestling has its own pin rules).

**Matte mapping:**

- **NOT ON DISK** how quickly matte is called. The engine currently has no matte mechanism; the only road back to standing is an escape.
- Proposed: after N exchanges of unproductive newaza (no scoring action, no advancement), the referee calls matte and the fight stands up. N is NOT ON DISK and must be tuned.
- **Must NOT apply to:** BJJ (IBJJF allows indefinite guard pulling and stalling has different rules), MMA (Unified Rules allow extended ground work), wrestling (no matte, only pin or stalling calls).

**What the engine currently lacks:**

- No matte call. Before S1d, the man underneath had nothing eligible, so the engine's fallback escape stood the fight up constantly - an accidental matte. With seats he has moves, so nobody stands up. This is why judo with seats produced 77% ground exchanges instead of 55%.
- No osaekomi ippon. A judo pin earns `position_points.control = 1.0` per landed control (combat_rulesets.json, judo scoring_profile), never an ippon. The IJF rule (pin 20 s = ippon) is not implemented.

## Part 2 - The seats

See `Q72_judo_seats.json` for the full list of 33 nodes.

Summary of decisions:

**Pins (osaekomi-waza) - 13 nodes, all ground_top:**

All pins are applied from on top. The attacker holds the defender down. Rule B agrees on all of these.

- judo_kesagatame, judo_kuzurekesagatame, judo_ushirokesagatame, judo_katagatame, judo_kamishihogatame, judo_kuzurekamishihogatame, judo_yokoshihogatame, judo_tateshihogatame, judo_ukigatame, judo_uragatame, judo_sankaku (when used as a pin), judo_osaekomi_chain, judo_jujigatame (when used as a pin)

**Rear chokes - 3 nodes, ground_top only:**

Applied from behind, which in a two-seat model is the top seat. Rule B says both seats; I override to ground_top because these are applied from behind/above.

- judo_hadakajime (rear naked choke) - applied from behind
- judo_okurierijime (sliding collar choke) - applied from behind/above
- judo_katahajime (single wing choke) - applied from behind/above

**Other chokes - 7 nodes, both seats:**

These can be applied from various positions. Some are more common from top, but can be finished from bottom. Rule B says both seats; I agree.

- judo_namijujijime, judo_gyakujujijime, judo_katajujijime, judo_katatejime, judo_ryotejime, judo_sodegurumajime, judo_tsukkomijime

**Leg choke - 1 node, both seats:**

- judo_dojime (body scissors) - a leg choke that can be applied from various positions

**Arm locks - 9 nodes, both seats:**

These can be applied from above (mount/side control) or from underneath (guard). Rule B says both seats; I agree.

- judo_udegarami, judo_udehishigiudegatame, judo_udehishigihizagatame, judo_udehishigiwakigatame, judo_udehishigiharagatame, judo_udehishigiashigatame, judo_udehishigitegatame, judo_udehishigisankakugatame, judo_ashigarami

**Total: 33 nodes**

- 13 pins: ground_top only
- 3 rear chokes: ground_top only (override rule B)
- 7 other chokes: both seats (agree with rule B)
- 1 leg choke: both seats (agree with rule B)
- 9 arm locks: both seats (agree with rule B)

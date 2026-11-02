# M37 DRESSING THE GENERATED FIGHTER, PER RULESET

Done by Claude, S98 2026-09-27 (Maria's Grok Bot is at its weekly limit; the operator said "u take all their tasks").
Task: `TASK_M37_DRESSING_THE_GENERATED_FIGHTER.md`. For the S100 "dress the generator fighters" stage (the MPFB
pilot is an unclothed base mesh).

## 1. Required kit per ruleset

| Ruleset | Must wear (pro) | Amateur adds | Silhouette that reads at 3/4 camera |
|---|---|---|---|
| Boxing | trunks, belt at or below the waist, not past the knee; cup; gloves; mouthpiece; boots | vest/singlet, headguard in many amateur codes; red or blue kit by corner | long, loose, high-waisted satin trunks with a wide waistband; bare torso (men); high boxing boots |
| Kickboxing (K-1 / Glory) | shorts; gloves; cup; mouthpiece; barefoot | shin + instep guards, headgear (WAKO K-1) | short loose shorts or long kick pants; bare shins (pro) or shin guards (amateur); barefoot |
| Muay Thai | Thai shorts (short, wide legs, big waistband); gloves; cup | shin guards, body protector, headgear in IFMA amateur | very short, flared satin shorts with a big printed waistband; mongkol headband + prajiad armbands for the walkout and wai kru |
| MMA (Unified Rules) | men: trunks, no upper-body clothing, hem not below the knee, no exposed velcro, pockets or zips; women: short-sleeve or sleeveless form-fitting rash guard and/or sports bra; 4-6 oz open-finger gloves; cup; mouthpiece | shin guards and rash guards in IMMAF amateur | board-style or vale-tudo shorts; small open-finger gloves; barefoot |
| Judo | judogi (jacket, trousers, belt); one athlete in WHITE, the other in BLUE in official IJF events; reversible gi not allowed | same | the gi shape dominates; the belt colour gives rank |

Sources: ABC Unified Rules of MMA (https://www.abcboxing.com/wp-content/uploads/2024/07/unified-mma-rules-rev-july-2024.pdf);
IMMAF amateur rules (https://immaf.org/wp-content/uploads/2020/02/IMMAF-Rules-Document-as-of-March-2017.pdf);
WAKO K-1 rules (https://www.wako.sport/post/wako-k1-rules); boxing equipment rules, NC 14B NCAC 10.0502
(https://law.cornell.edu/regulations/north-carolina/14B-N-C-Admin-Code-10-0502) and USA Boxing uniform list;
IJF judogi rules (https://www.ijf.org/news/show/the-new-refereeing-rules-point-by-point, https://en.wikipedia.org/wiki/Judogi);
corner colours (https://en.wikipedia.org/wiki/Boxing_ring).

## 2. Minimum garment set (model once, recolour)

| # | Garment | Used by | Variants by shape key / texture only |
|---|---|---|---|
| 1 | Fight shorts, one mesh with a leg-length shape key | boxing (long + high waist), kickboxing, Muay Thai (short + flared), MMA | waistband height, leg length, flare |
| 2 | Gloves: one boxing-glove mesh + one open-finger MMA glove | boxing / kickboxing / Muay Thai share the boxing glove; MMA the open-finger | colour, cuff trim |
| 3 | Top: sports bra + rash guard, one mesh with a sleeve shape key | women in every ruleset; amateur MMA | sleeve length |
| 4 | Judogi (jacket + trousers + belt) | judo | white / blue; belt colour |
| 5 | Protective add-ons: shin guard, headgear | amateur kickboxing / Muay Thai / MMA, amateur boxing headgear | colour |
| 6 | Boxing boots | boxing only; every other ruleset is barefoot | colour |
| 7 | Mongkol + prajiad | Muay Thai walkout only | colour |

Items 1-3 cover every professional bout in four of the five rulesets.

## 3. Variation system

- **Corner colour first:** red corner vs blue corner, as boxing and judo do (judo mandates white/blue). The engine
  already has sides a and b; give the side's colour to gloves (boxing, kickboxing, Muay Thai) or to the gi (judo). In
  MMA, where gloves are usually one colour, the colour goes on the shorts.
- **Fighter's own colours:** each fighter owns a primary + trim pair (2 of ~10 palette entries). The shorts carry them.
  When both men's primaries are too close, the blue-corner man switches to his trim colour (a lightness check, not a hue
  check - colour-blind safe).
- **Touches that read from the ring camera:** waistband text (the fighter's fictional nickname), a gym crest on the leg
  (our player's gym, which also sells the gym), boot colour, tape on the wrists. Everything smaller than that is lost at
  game distance.

## 4. Never ship / may ship

- **Never:** real brand logos (Venum, Fairtex, Everlast...), real sponsor marks, real org logos (the org-names ruling
  allows NAMES only), real fighters' signature kit.
- **May:** plain patches, invented sponsors (these can later become the visible face of the Sponsors system; see the
  deck), the player's gym crest, Thai-style patterns that are generic ornament, not a brand's trade dress.

## 5. First three garments to make

1. **Fight shorts with the leg-length shape key.** One mesh dresses boxing, kickboxing, Muay Thai and MMA men.
2. **Boxing glove.** Covers three rulesets and carries the corner colour, the most visible colour on screen.
3. **Sports bra / rash guard top.** Without it no female fighter can be dressed legally in any ruleset.

Open-finger MMA gloves are fourth, the judogi fifth.

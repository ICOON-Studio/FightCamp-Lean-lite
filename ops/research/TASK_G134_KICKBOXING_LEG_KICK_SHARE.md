# TASK G134 - GROK - HOW MANY LEG KICKS LAND IN A KICKBOXING FIGHT (S97)
Owner: grok (Research / Expert mode, never Build). Assigned 2026-09-27 (S97). No shell, no repo: answer in the chat.

## Why
Our kickboxing engine lands ~2.3 leg strikes per fighter per 3x3-min bout (~8% of landed strikes). Cursor (U189) is
raising it against a PROXY band of 14-20%. We need the real number to pin that band, and the limb-damage feature needs
to know how many clean low kicks it takes before a real fighter visibly limps.

## What would a human do?
A kickboxing analyst counts strikes on fight film by target (head / body / legs) and by landed vs thrown, per fighter
per round - the way CompuStrike / FightMetric count, or the way a coach reviews tape.

## Questions (cite every number with its source; mark PROXY where it is not a direct count)
1. Glory / K-1 / ONE kickboxing (3x3 min): landed strikes per fighter per fight, split head / body / legs. Leg share of
   landed strikes. Any published strike-count study (e.g. the K-1 hitting-actions study, Glory stat broadcasts, academic
   time-motion analyses of kickboxing or Muay Thai).
2. Low kicks specifically: thrown and landed per fighter per round; land rate. Difference between a low-kick specialist
   (Dutch style) and a counter/boxing-first kickboxer.
3. The damage curve: documented fights where a leg was compromised (limp, switch stance, cannot check, TKO by leg
   kicks) - how many landed low kicks before the visible limp, and before the stoppage (e.g. Gaethje, Aldo-Faber style
   MMA examples are acceptable if kickboxing ones are missing, labelled MMA).
4. Calf kick vs thigh kick: does the calf kick compromise the leg in fewer strikes? Any count.

## Deliver
One answer, headed `# G134 KICKBOXING LEG KICK SHARE`, sections 1-4, a table per section, sources as URLs, and a final
line: `RECOMMENDED BAND: leg share of landed strikes X-Y% (kicker), A-B% (counter striker); limp after N clean low kicks`.

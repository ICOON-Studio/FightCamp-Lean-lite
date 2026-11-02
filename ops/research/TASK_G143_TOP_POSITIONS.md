# TASK G143 - GROK - MOUNT, SIDE CONTROL, HALF GUARD, GUARD: THE REST OF THE GROUND (S112)
Owner: grok (Expert mode, never Build). Assigned 2026-09-27 (S112). Deliverable: one markdown answer, which Claude saves
as `research/G143_TOP_POSITIONS.md`. Fresh chat.

## Why
G139-G142 calibrated the fence, the knockdown aftermath, the front headlock / turtle and back control. G142 ended in a
per-second hazard table with acceptance bands, and it is being built. The other ground seats our engine already has
(mount, side control, half guard, full guard - top and bottom) were never checked the same way: how long a man holds
each, how he loses it, how often ground-and-pound or a submission ends the fight from it. Without them the back seat is
calibrated and every seat it exits into is not.

## What would a human do?
A BJJ black belt who coaches MMA, and a FightMetric coder, know these seats. The top man in mount postures up and
punches, or isolates an arm; in side control he knees, cross-faces, walks to mount; in half guard he flattens and
passes or strikes; in full guard he postures and punches or stands out. The bottom man bridges and shrimps, recovers
guard, sweeps, stands up on the fence, or attacks a submission from guard. The referee stands them up only if nothing
happens. Answer as that coach and coder would.

## Prefab check
Name any dataset that tags these positions, their duration or their transitions (UFCStats ground strikes and control
time, Sportradar position fields such as mount / sideControl / halfGuard / guard and their control times, BJJ positional
studies, ADCC / BJJ Heroes transition data, academic MMA ground-strike and submission studies), its licence, and
whether the numbers are public.

## Questions (tables; grade every figure S sourced / P proxy / J judgement; cite)
1. Entries: where each seat comes from in MMA (takedown landing, pass, sweep, scramble, off the back), with shares.
2. Duration: median and spread of a visit to each seat in UFC.
3. Exits per seat with shares and median seconds: pass / advance (guard -> half -> side -> mount), bottom recovers guard,
   sweep / reversal, stand-up (incl. walking up the fence), submission attempt and finish-given-attempt (arm triangle,
   armbar, kimura, triangle and armbar from guard, guillotine), GnP stoppage, referee stand-up, round end.
4. Strikes: what the top man lands per 10 s in each seat (and elbows), and how often GnP stops a fight from each.
5. Weight class and sex: what changes materially.
6. For a simulation: the smallest per-second hazard table per seat, in G142's format, that reproduces 1-4 and plugs
   into G142's back table (to_mount, esc_guard, esc_top) - so the whole ground graph closes. Name the acceptance
   numbers a census should hit, the implied fight-level checks (ground time share, GnP KO/TKO share of all finishes,
   submission shares by technique), and what can be deferred.

Return the whole answer as ONE markdown artifact file named G143_TOP_POSITIONS.md.

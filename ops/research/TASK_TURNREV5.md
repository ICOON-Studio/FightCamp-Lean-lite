# TASK TURNREV5 - write the turning pro map v5 (TURNPRO1_V5) from the code, against the measured lines

Status: OPEN (S530, Claude main). Discipline: boxing. Model: Goose (cloud), default. RESEARCH ONLY - no game code changes.

## Why
v4 (`ops/research/DESIGN_TURNPRO1_V4.md`) was critiqued against numbers measured before the S529 price fix. Two reruns on
today's code are in: read `ops/research/TURNPROBE3_READ_S530.md` FIRST (Claude's reading of docs/TURNPROBE3_RESULT.md and
docs/TURNPROBE3B_RESULT.md, with the probe defects named). v5 answers those measured lines - not the critics' prose. The
Arena v4 critic (`ops/research/DESIGN_TURNPRO1_V4_CRITIC_ARENA.md`) lists number errors in v4 (both-call band is 46-74 not
45-74, split counter ~$3, the age warning 29, the stale price-bug item): fix them.

## Your job
Write `ops/research/DESIGN_TURNPRO1_V5.md`: the whole map again, every row CODE (file + function), ESTIMATE (a target a
probe checks) or CUT. READ scripts/rules/ProCall.gd, scripts/state/ProOfferWire.gd, scripts/state/Roster.gd (pro_ready,
turn_pro, PRO_OPP_GAP), scripts/rules/ProDebut.gd, scripts/rules/Recruit.gd (ambition), scripts/rules/DayJob.gd. Then, for
each measured problem, ONE change with its lever and the line it must move:
1. Debuts won 94% (target 65-80%): which number (PRO_OPP_GAP, the houses' opp_gap) and to what, and why that range.
2. Four asks never best (later4, softer, split, no ask): cut each, or give it a case where it is best (name the case the
   probe can build); "costs" best 74% needs a downside (Arena v4 item 5: a loyalty or morale cost when costs move to her).
3. The door never shuts (0/60): either make the third decline reachable (show "one more refusal closes the door"; a terms
   floor) or cut the rule - say which and why.
4. The "pro" ambition never fires (Recruit.ambition never says it; 1/30): the ambition line that adds it, and who gets it.
5. Day-job boxers: 6 wins / rank 4 in two years, 3/180 get a call. Decide: keep (slower is real) and SHOW it on the
   NEXT STEP ("on the day job: about N more wins before a call"), or a day-job route to the call - one, with its reason.
6. PREP == YES (median $0): cut the PREP framing or name what makes preparing worth it.
Keep: the wire map table (every menu, what it shows, what it opens - owner S425), plain words, names only in headers (owner
S448), no critic scores in the map. End with "Changed from v4" and a short probe plan (which lines to rerun).

## Deliverable
ONE new file `ops/research/DESIGN_TURNPRO1_V5.md`. A PR that adds only that file. Do not edit any other file. Do not run
Godot. Under 450 lines.

## Contract
OWNS: ops/research/DESIGN_TURNPRO1_V5.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
TURNPROBE3_READ_S530.md, TURNPROBE2/3/3B results, DESIGN_TURNPRO1_V4.md + its Arena critic, CRITIC_PACK.md.
## What would a human do?
A manager reads the last two years of debuts before changing the contract: too many easy wins means the matchmaker is
too kind, and a boxer with a day job gets the call later, not never.
## Prefab check
None: a design document on our own code.

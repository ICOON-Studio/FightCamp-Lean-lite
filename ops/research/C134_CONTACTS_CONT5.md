# C134 continuation 5: contact remeasurement

Seed 77321, current repaired runtime, f05/f06 in both assignments. No live binding relaxed.
Higgsfield: no callable MCP tool exposed; zero jobs and credits.

Measured every 30 Hz sample: 135 armbar frames and 181 strangle frames per assignment.
CSV files in C134_EVIDENCE/cont5-*-contacts.csv contain frame, seconds, local grip coordinates,
distance and residual, all in metres. Grip is the midpoint of attacker hand joints; target is
victim RightHand for armbar, Neck for strangle. Local axes are the victim joint's orthonormal
world basis. Residual is distance from the mean local vector over the stated contact window.
It measures fixed-relationship drift, not skin penetration. Entry/release are included in the
CSV but deliberately excluded from the lock-window summary.

| Film / attacker | Contact window | Distance m | Local residual RMS / peak m |
|---|---|---|---|
| Armbar / f05 | 1.4-2.4 s | .068052-.178377 | .085739 / .160632 |
| Armbar / f06 | 1.4-2.4 s | .128674-.229267 | .072969 / .159216 |
| Strangle / f05 | 1-5 s | .179439-.206941 | .025695 / .062844 |
| Strangle / f06 | 1-5 s | .191354-.222337 | .030318 / .073350 |

Opened fresh four-angle f05 attack sheets at .8/2/3.8 s and 1/3/5 s respectively.
Armbar grip and body intersections remain; strangle remains a mounted hands-to-neck squeeze
without verified sporting choke/tap/release. Both remain audition-only.

The repaired hip trajectory is present. Remaining retarget policy preserves target limb lengths,
uses independently scaled hip displacement and rotation tracks, and has no paired contact solve.
Thus preserving pelvis travel does not constrain a target wrist to the other rig's hands.
This identifies the remaining unconstrained relationship, not a quantified attribution of every
centimetre to a particular bone. No further engine or retarget repair is claimed.

Reproduce using c134_armbar_measure.gd, tag=cont5-armbar-local-a, turn, top=a (then b).
For strangle use role=grapple_submission_finish, tag=cont5-strangle-local-a, no turn override:
the room applies its existing -0.12 m / 180 degree placement. Run c134_contact_report.py afterward.
The measurement now samples the correct source window for trimmed films and includes Neck.
Parse: CHECK total=1 fails=0. No full suite.

## Step 2: transition refusals re-tested

Fresh raw auditions use c134_action_review.gd with `raw turn travel`, seed 77321,
f05 attacker/f06 victim. `travel` invokes the existing paired-travel restoration;
it is an audition comparison, not a new live policy or engine change.
Opened all four 12-image sheets (four views x start/middle/end) in C134_EVIDENCE.

| Role | Repaired-travel film and samples | Current engine requirement | Verdict |
|---|---|---|---|
| clinch break | PushOff, 0/1.3/2.6 s: mount, seated separation, both standing | standing clinch -> standing | wrong start; refused |
| sweep | Reversal, 0/.9/1.8 s: mount, roll attempt, same attacker back on top | half -> guard, top swaps | wrong seats and observed endpoint; refused |
| escape | PushOff, 0/1.3/2.6 s: mount -> both standing | non-guard/non-half ground seat -> guard, top retained | wrong destination; refused |
| stand-up | BodyLock_End trimmed window, 0/1.25/2.49 s: mount -> standing | guard -> standing | wrong source; refused |

Engine evidence is the current FightRealtime.gd ground escape branch at 4057-4075,
read-only. Film samples establish these mismatches without claiming every intervening frame
has acceptable skin contact. The ordinary room does not yet opt these films into source travel;
this trial restores it for the audition and still cannot make their seats match the event.
No production binding, engine file, schedule, or live room changed in this continuation.

## Current engine-only replay, exact live-room fixture

c134_engine_review.gd uses FightWorldLiveScreen.demo_fighter and its ruleset lookup with the
room's begin options (one round, ruleset duration/rest, one tick per beat, grapple beats on).
It does not instantiate a rendered match and is NOT footage/coverage evidence.
Both results are DECISION: BJJ B 4-3 positional points; MMA A unanimous 10-8.
The earlier BJJ KO again does not reproduce; no general engine-fix claim follows.

BJJ: 144 action records, including 59 unnamed head_neck actions with positive wear, summing
83.856219 wear across those records. Grapple events 78, selected grapple beats 71.
Four action-selected beat windows contain four grapple events. The other three unselected
grapple events are not attributed to action priority by this count.
MMA: 27 grapple events, 22 selected; three action windows contain three grapple events.
Full example records and results: C134_EVIDENCE/cont5-engine-summary.json.
No engine file changed. The engine probe parse passed; process exit was 1 with the known
host certificate/logger errors, no SCRIPT ERROR or Parse Error. Outputs completed both routes.

# G143 - Mount, side control, half guard, guard: the rest of the ground (Grok, collected S113)

Source: Grok Expert, grok.com/c/734c118e-dd4a-4a06-b099-31a4d757feb9 (27.7 KB artifact, 107 sources), condensed by
Claude. Grades: S sourced, P proxy, J judgement. Companion to G139 fence, G140 one down, G141 turtle, G142 back.

## Disposition (Claude, S113)

**ADOPT section 7 (Stage A / Stage B tables, flags, G142 wiring, acceptance bands) as the spec for the four ground seats.**
It becomes Q209 for the engine agent after Q208 (back control) lands: same two-stage pattern as Q208, one Stage A table
per seat, one Stage B lock chain, the flag multipliers, and the census against 7.5. Rule carried from G142: **miss a
band -> retune a lambda, never add a state.** Deferred as Grok says (7.6): crucifix/truck/saddle, open-guard taxonomy,
knee-on-belly seat, era drift, referee identity. **`idle_top` (no strike / no pass for 6 s) is the stand-up rule** - Q208
should use the same flag on the back. Caveat: every visit-level number is J; no public UFC per-visit census exists.
Sportradar's per-seat control seconds (commercial) is the first census that could promote J rows to S.

## Coach picture (section 0, condensed)
Guard top: posture or get submitted; punch/elbow, stand out, or pass; hugging legs earns a stand-up. Guard bottom:
frames, break posture, technical stand-up on the fence, sweep on a posted punch, triangle/armbar/guillotine on a dropped
head. Half top: flatten, cross-face, free the leg, knee-cut to side. Half bottom: underhook or die - recover guard,
sweep, or wrestle up. Side top: cross-face, hip block, elbows, walk to mount, take the back if he turns; kimura and
arm-triangle live here. Side bottom: frame, shrimp to half/guard, or knees-and-fence. Mount top: highest GnP seat;
arm-triangle, armbar; go with an upa to the back rather than lose to guard. Mount bottom: upa, elbow escape, give the
back only if the punches are already a stoppage. Referee (ABC 2025-26): position alone is not immunity; stand-ups
happen from every seat.

## Prefab check (datasets)
UFCStats (round totals, one control bucket, no seat clock); Sportradar UFC (per-seat control SECONDS per fight and
`endingPosition` - commercial, schema public); SportsDataIO (advances, counts); Bloody Elbow x FightMetric 2014 (idle vs
active); Miarka/Del Vecchio/Kirk time-motion (frequencies); Almeida et al. 2026 (906 bouts, finish position, CC BY 4.0);
GrapplerHQ UFC-DataLab (8,591 bouts, MIT wrapper); FightAlpha (8,745 fights, 1,695 subs). None publishes visit-level
seat durations.

## Entries (share of visits into the seat, J unless noted)
Guard: takedown landing 62 (P), bottom recovered 14, pass failure 12, off the back 6 (P), scramble/KD/turtle 6 (P).
Half: pass in progress 38, takedown 28, bottom recovered 18, scramble 10, off the back 6 (P).
Side: pass from half 42, pass from guard 18, scramble/turtle 16 (P), mount lost 10, takedown direct 10, off back 4.
Mount: walk-up from side 48, pass from half 18, scramble 12, off the back 12 (P), takedown direct 6, guard skipped 4.
Takedown -> first seat guard or half 75-85% of TDs; direct-to-mount <8%.

## Visit length (J/P; outputs of the lambdas, never stored as constants)
Guard median 14 s (IQR 7-28), half 11 s (5-22), side 16 s (8-32), mount 12 s (6-24). Ground-with-a-named-seat share of
fight time 20-26% (P; 2014 FM 38.1% S, LW snapshot ~17% S).

## Exits (share of visits)
Guard: pass->half 26, pass->side 7, sweep 9, stand-up 24, sub lock 11 (P), GnP stop 2.0 (P), ref stand 10, round end 7,
bottom takes back 4. Half: pass->side 32, ->mount 6, recover guard 18, sweep 12, stand 14, sub lock 5, GnP 1.5, ref 5,
round end 5, to back 1.5. Side: ->mount 28, ->back 10, recover half 16, recover guard 6, sweep 4, stand 10, sub lock 8
(P), GnP 4 (P), ref 6, round end 8. Mount: ->back 14, escape->half 18, escape->guard 6, sweep 3, stand 4, sub lock 16
(P), GnP 18 (P), ref 4, round end 7.
Lock mixes (finish given lock): guard triangle 34%/0.18, armbar 28%/0.22, guillotine 22%/0.26, other 16%/0.10; side
arm-triangle 45%/0.28, kimura 25%/0.16, americana 12%/0.12, other 18%/0.10; mount arm-triangle 40%/0.32, armbar
30%/0.24, mounted triangle 15%/0.20, other 15%/0.10.
Submission position order (three sources agree): back >> mount ~ guard-bottom > side > half. GnP order: mount > side >
half ~ guard.

## Strikes (top man, landed per 10 s, J)
Guard 1.6 (elbows 0.25), half 2.2 (0.40), side 2.4 (0.70), mount 3.6 (1.10). Bottom 0.2-0.6. Ground target ~4/5 head
(S). KO/TKO = 32.6% of UFC bouts (S); 22-30% of those are GnP (P). Idle half/back time does not raise TKO odds; idle
half/side/mount time does raise sub completion (FM 2014, S).

## Weight class and sex (flags, not per-division lambdas)
HW finish rate 66.1% (S), WSW 32.8% (S); men and women submit at the same rate (S, p=0.853). Heavy: gnp x1.6-2.0,
lock x0.7, stand x0.75. Light: stand x1.2, sweep x1.25. Women: gnp x0.55-0.70, stand x1.15.

## Section 7 - the table
Stage A, lambda per second (guard / half / side / mount):
pass_half 0.0160/-/-/-; pass_side 0.0040/0.0220/-/-; pass_mount 0.0008/0.0040/0.0140/-; to_back 0.0022/0.0010/0.0050/
0.0090; bot_rec_guard -/0.0120/0.0030/0.0040; bot_rec_half -/-/0.0080/0.0120; sweep_rev 0.0055/0.0080/0.0020/0.0020;
stand 0.0140/0.0100/0.0050/0.0025; ref_stand 0.0055/0.0035/0.0030/0.0025; gnp_stop 0.0012/0.0010/0.0020/0.0120;
lock_sub 0.0065/0.0035/0.0040/0.0100; round_end 0.0030/0.0030/0.0035/0.0040. Totals 0.0587/0.0680/0.0495/0.0580;
implied medians 11.8/10.2/14.0/11.9 s.
Stage B (locked): lambda_finish 0.040/0.030/0.045/0.055, lambda_peel 0.140/0.150/0.120/0.100 (peel returns to Stage A of
the SAME seat, never to standing); finish given lock ~0.22/0.17/0.27/0.35.
Flags on Stage A (pass / to_back / recover-sweep-stand / gnp / lock, finish* / ref):
hw_power 0.90/0.90/0.80/1.80/0.70,0.85*/0.85; light_pace 1.05/1.00/1.25/0.75/1.15,1.05*/1.10; women 1.00/0.95/1.15/
0.60/1.10,1.00*/1.10; fence 0.85/1.15/1.40 stand/0.90/0.90/0.70; hurt_bottom 1.20/1.10/0.55/2.20/1.30,1.40*/0.60;
posture_broken (guard) 0.50/0.70/0.70 stand/0.40/1.80,1.30*/0.80; crossface_on (side/half) 1.25/0.70/0.55 recover/
1.20/1.15/0.85; high_mount -/1.30/0.70/1.40/1.25,1.20*/0.90; active_gnp 0.80/0.85/0.75 recover/1.60/0.70/0.50;
idle_top 0.70/0.80/1.00/0.40/0.80/2.20.
G142 wiring: back to_mount -> mount Stage A; esc_guard -> guard Stage A; esc_top -> 50% half / 35% side / 15% mount.
Every to_back row here enters G142. Turtle (G141) is not side.

## Acceptance bands (7.5)
Visit level (10k per seat, clock off): guard median 10-15 s, mount 10-15, side 12-18, half 8-13; mount GnP stop
0.18-0.23; guard GnP <0.03; guard stand + ref 0.30-0.38; side -> mount 0.25-0.32; Stage B finish|lock mount > side >
guard > half.
Fight level (whole ground graph with G141 + G142, 10k fights): named-seat ground share of fight time 0.18-0.28;
subs 0.17-0.21 of fights (S 19.3%); KO/TKO 0.30-0.35 (S 32.6%); GnP KO/TKO 0.07-0.10 of fights; RNC 0.36-0.42 of subs;
guillotine 0.16-0.19; armbar 0.10-0.13; arm-triangle 0.06-0.09; triangle 0.05-0.08; kimura 0.02-0.035; sub position
back 0.40-0.50, mount 0.04-0.08, guard 0.08-0.14, side 0.015-0.04. If RNC overshoots cut G142's finish lambda, not this
file; if arm-triangle undershoots raise side/mount lock_sub before touching Stage B.

## Builder notes (section 8)
One visit = one Stage A run; a pass starts a new visit and resets idle. Top and bottom share one clock. Landed strikes
feed the existing body-region damage; lambda_gnp is only the referee-stop overlay, so a damage KO and a ref stop cannot
both fire. round_end is a placeholder until FightClock drives the graph.

## Sources (keyed, short)
UFCStats/FightMetric; Sportradar UFC schemas; Bloody Elbow x FightMetric 2014; GrapplerHQ 8,591-bout census;
FightAlpha 8,745-bout submission table; Almeida et al. Appl. Sci. 2026; Miarka / Del Vecchio / Kirk time-motion; JCM
2025 control time by weight and sex; ESPN LW control snapshot; ABC / Herb Dean stand-up rule 2025-26; UFCPI
position-of-submission graphic (secondary, P).

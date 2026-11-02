# G144 - How a grappling skill gap moves the ground (Grok, collected S114)

Source: Grok Expert, chat grok.com/c/26a11869-183b-45b0-906a-e564372bdb46, artifact G144_GROUND_SKILL_GAPS.md.
Condensed by Claude; figures verbatim. Grades: S sourced, P proxy, J judgement. Most multipliers are P/J; gates S/P.

## Disposition (Claude, S114)
FEEDS Q209 (the rest of the ground, G143 section 7) as its skill scaling. Adopt the shape as written: skill power
first, style second, clip to the caps, the 55% seat-mass rule, finish-given-lock as a SECOND roll. Regression test:
an equal 50/50 pair with neutral style must reproduce G142/G143 Stage A exactly. Delta20 comes from the existing
grappling rating on the card - no new "ground IQ" stat. Style = one primary identity flag (bjj / wrestler / striker).

## Convention
`d20 = (actor_grapple - opponent_grapple) / 20`; `mult = clamp(base ^ d20, cap_lo, cap_hi)`; style factors multiply after.

## 1. Skill multipliers per +20 for the ACTOR of the row
| Row (G143 guard/half/side/mount) | actor | x per +20 | cap | grade |
|---|---|---|---|---|
| pass_half | top | 1.55 | 0.30-3.2 | P |
| pass_side | top | 1.50 | 0.30-3.0 | P |
| pass_mount | top | 1.45 | 0.35-2.8 | P |
| to_back | top | 1.60 | 0.28-3.4 | P |
| bot_rec_guard | bottom | 1.50 | 0.30-3.0 | P |
| bot_rec_half | bottom | 1.30 | 0.40-2.2 | J |
| sweep_rev | bottom | 1.70 | 0.22-3.6 | P |
| stand | bottom | 1.25 | 0.45-2.0 | J |
| ref_stand | clock (inverse of top skill) | 0.85 | 0.55-1.15 | P |
| gnp_stop | top | 1.20 | 0.50-2.0 | J |
| lock_sub | either | 1.65 | 0.25-3.5 | P |
| round_end | clock | 1.00 | - | S |

Seat sensitivity high->low: guard, half, side (sweep dies; bot_rec and lock_sub still move), mount (lock_sub, to_back).

| Row (G142 back) | actor | x per +20 | cap | grade |
|---|---|---|---|---|
| rnc_lock | top | 1.55 | 0.30-3.2 | P |
| other_choke_lock | top | 1.45 | 0.35-2.8 | J |
| gnp_tko | top | 1.15 | 0.55-1.8 | J |
| esc_guard | bottom | 1.50 | 0.30-3.0 | P |
| esc_top | bottom | 1.35 | 0.40-2.4 | J |
| esc_stand | bottom | 1.30 | 0.40-2.2 | J |
| to_mount | top | 1.25 | 0.50-2.0 | J |
| ref_stand | clock | 0.80 | 0.50-1.10 | P |

## 2. Style factors (after the skill power)
Bottom identity (G143 Stage A):
| identity | sweep_rev | stand | lock_sub | bot_rec_guard | bot_rec_half | grade |
|---|---|---|---|---|---|---|
| BJJ | 1.55 | 0.70 | 1.70 | 1.35 | 1.15 | P |
| Wrestler | 0.65 | 1.70 | 0.55 | 0.75 | 0.90 | P |
| Striker | 0.45 | 1.45 | 0.35 | 0.55 | 0.70 | J |

Top identity:
| identity | pass_* | to_back | lock_sub | gnp_stop | grade |
|---|---|---|---|---|---|
| BJJ | 1.10 | 1.25 | 1.40 | 0.85 | J |
| Wrestler | 1.15 | 1.05 | 0.75 | 1.25 | P |
| Striker | 0.80 | 0.70 | 0.55 | 1.15 | J |

## 3. Finish given a locked submission (second roll)
`p_finish = base_hold * 1.40^((atk-50)/20) * 0.78^((def-50)/20)`, clipped to the hold's cap.
| hold | base | cap | grade |
|---|---|---|---|
| RNC (both hooks, arm under chin) | 0.62 | 0.28-0.88 | P |
| other back choke | 0.48 | 0.22-0.78 | J |
| arm-triangle | 0.50 | 0.22-0.80 | P |
| armbar | 0.42 | 0.18-0.75 | P |
| triangle | 0.38 | 0.15-0.70 | P |
| guillotine | 0.28 | 0.12-0.55 | P |
| kimura / americana | 0.32 | 0.14-0.60 | J |
| leg lock (if legal) | 0.40 | 0.15-0.72 | J |
Worked: 90 BJJ locks a 30 striker, RNC ~0.86; two 80s ~0.71.

## 4. Caps and the seat-mass rule
Floors/ceilings: first pass 0.25-3.2x; later passes/to_back 0.25-3.4x; sweep_rev 0.20-3.6x; lock_sub/rnc_lock
0.22-3.5x; finish-given-lock 0.12-0.88; stand 0.40-2.2x; esc_* 0.22-3.0x; gnp_stop 0.45-2.0x; ref_stand 0.50-1.15.
**If one exit would take >55% of a seat's per-second mass, bleed the excess into round_end / residual control.**

## 5. Acceptance for a MIXED-pair census (never identical fighters)
| gate | target | grade |
|---|---|---|
| UFC sub share of all bouts | 18-21% | S (Fares 2025, UFCStats) |
| sub share of finishes | ~33-38% | S |
| choke : joint | ~65 : 35 | S |
| grappler beats striker, mixed pairs | 64-72% | P |
| BJJ-primary winners, share by sub | 35-55% (mean ~40%) | P |
| wrestler-primary winners, share by sub | 8-18% (mean ~12%) | P |
| wrestler on top, control in a 3x5 he wins | 6-12 min | P |
| two average grapplers, combined control | 3-6 min | P |
| sub attempts / 15 min | median 0.3-0.6; BJJ 1.6-2.6; wrestler 0.2-0.8 | S |
| BJJ bottom vs wrestler top | sweeps + guard subs > stand-ups | P |
| wrestler bottom | stand-ups > sweeps > subs | P |
| locked RNC conversion | 0.55-0.75 | J |
Diagnostics: 40% sub rate = lock/finish too hot; 12% = specialists not hunting; wrestler bottoms sweeping as often
as standing = style table not wired.

## Prefab check (Grok)
No public table splits UFC ground hazards by pedigree. Used: UFCStats per-fighter densities (proprietary, cite only),
BJJ Heroes IBJJF/ADCC logs (editorial, public), IBJJF belt sub rates (compiled), Fares 2025, Stellpflug 2022,
Lamas 2024 (back-take->sub 0.45), BMC SSMR 2026, Varghese 2023 and FightAlpha 2026 (proxies).

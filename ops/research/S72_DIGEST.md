# S72 DIGEST - A RETIRED FIGHTER STAYS ON AS COACH; U170 / C197 / G92 collected; agents back in their lane (2026-09-25)

## Built: retiree -> coach (`679f7e74`), J11 P1 + G91 section 5 + J48 section 6 - live, no switch
- `RetireeCoach.gd` (pure, zero preloads). TIER: a title or fame >= 300 = featured, >= 100 midcard, else journeyman
  (thresholds INVENTED). ODDS he says yes (J48 counted, any coaching): featured boxing 0.61 (19/31), featured MMA 0.69
  (22/32), journeyman 0.34 (11/32); midcard 0.45 JUDGEMENT (J48 row 7, no mid-tier sample).
- SHEET FROM KNOWLEDGE (G91): tactical = 40 + 0.5 x (fight_iq - 50); technical = 35 + 0.2 x (technique - 50) +
  6 per teaching year (cap 30); youth 5; capacity 3 + 1 per 3 camp years (cap +2). Teaching years = veteran years
  (past the Aging peak window) spent at THIS gym - the pad-holder of J11 D8, a JUDGEMENT proxy. All weights INVENTED,
  directions SOURCED. `seed_sheet` takes no titles, fame or record: pedigree cannot reach the skills.
- FAME PULL: peak 0.08/title + 0.0002/fame, cap 0.25, halves every 3 weeks, gone after 12 (INVENTED; Wild Card +300 is
  the only hard figure, an upper bound). Added to the membership attractiveness multiplier beside the title spike and
  reported apart (`get_membership_market().fame_pull`).
- PAY: a weekly wage (the existing staff quote) OR a CUT - no wage; 10% of the pupil's purse+win bonus after a full
  camp, 5% corner-only, capped at $50,000 (percentages SOURCED as practice, cap INVENTED). Taken from the pupil's
  wallet at settlement, never below what he was paid; `staff.earnings` records it.
- FLOW: `_retire_athlete` opens `career.retiree_offers[id]` + a news line; the Office FORMER tab shows TACTICS /
  TEACHING / wage-or-cut with OFFER WAGE and OFFER CUT. `hire_former_fighter(id, quote, pay, overrides)` checks money
  first (a broke gym never spends his answer), then his FIXED roll (hash of id; asking twice never re-rolls); a no
  leaves him retired and closes the offer. Pre-S72 retirements build their offer lazily.
- Test `retiree_coach_test.gd` 40/40; 8/8 mutants caught (tactics ignore iq, teaching years ignored, no capacity
  bump, pull never decays, cut uncapped, answer ignores odds, fame leaks into teaching, settlement takes no cut). The
  decay check was first too weak ("smaller than week 1") and missed its mutant; it now bounds week 7 at <= 30% of peak.
  Render: `docs/previews/s72/s72_former_row.png` (`tools/s72_former_row_render.gd`).
- NOT in slice one: the good-fighter curse, licence gates on youth classes, a delay before he can start, coaching income
  beyond the cut, quit rate. Grok G93 is researching pay and quit rates.

## Collected
- **U170 (Cursor)** merged with two fixes. (1) Its weigh-in change made production weigh a fighter at his OWN class when
  booked into another class - it accommodated a fixture that books straight onto a card bout in the wrong class and
  discipline. Reverted; `weight_cut_test` now books a paid BOXING open slot and takes its division (0 failures, no
  production special case). (2) The floor band's why-line overprinted the load line; the success status rendered in
  error red. Re-walked and looked at.
- **C197 (Codex)** blind market-two test: 52 checks, 0 failures on master, five mutants caught; title fixture passes
  through `_apply_fight_result` - S71's title hook holds.
- **G92 (Grok)** saved verbatim. **Q168's instrument printed per-BOUT attempts as "per fighter-fight".** Q170's 1.65
  is 0.83 per fighter-fight - inside J20 D6's 0.5-1.0 - and inside G92's grappler-v-striker sample per bout (grappler
  mean 1.48, striker ~0). Not a defect; nothing to Qwen. Tool now prints both units.

## The lane split, re-applied (operator 2026-09-25)
"i thought we agreed on spliting the agents by keeping some on constand 3d animation work ? why you use codex for
research ?" - S71 had put Codex (C197) and Cursor (U170) on management/GUI. Now: **Codex C198 STANDING motion**
(gpt-6-astra medium, web ON via the new `CODEX_WEB=live` launcher switch - its config had search disabled) and
**Cursor U171 STANDING clinch/ground holds**. Web access: Grok/John/Kalli/Maria/Dola yes; Cursor yes; Codex from now
on; Qwen can fetch a given URL but has no search provider configured.

## Suite
SUITE total=402 fails=9 (`--jobs 4`, after every S72 merge): athlete_development, capsule_coverage_contract,
fight_body_overlap, fight_metres (contention hang), fight_pace_anchor (Qwen Q171 in flight), fight_pair_live (PARKED),
fight_scoring, fight_stage_realism, fighter_reachability_contract - S71's ten minus weight_cut (fixed here). No new red.

## Also decided this session
- GROUND PRESENTATION: stay full 3D; on the ground the camera eases to ONE high broadcast angle (~60-70 deg) -
  Cursor U171 pass 2, switch `ground_camera`, A/B video for the operator.
- The suit route's UNBUILT link (2D segments -> two-body 3D on our rig) is Codex C199, fitted first on the clips on
  disk and judged from the ground-camera angle. The operator was not told of that gap before the suit clips were
  paid for - a lead failure, now a memory rule: every spend shows the whole chain with UNBUILT links named.
- CODEX CREDIT GRANT, verbatim: "i want codex to be able to spend credits , limit codex to 150 credits without
  asking". Enforced in `Tools/higgsfield/budget.py` (grant S72-codex-150, ceiling 150, tested); running total:
  `python -m Tools.higgsfield.budget --estimate 0`.
- No deadline exists; EA-level grappling fidelity is data-limited, not time-limited.

## Running at handover
Codex C198 (standing motion) + C199 (suit clips -> 3D), Cursor U171 (holds; ground camera next), Qwen Q171 (pace D1),
Grok G93 (coach pay and quits, chat 9a4f859d). Dola D17, John, Kalli, Maria hold their standing tasks. Next: S73 gym
heat + a gate that reads hype.

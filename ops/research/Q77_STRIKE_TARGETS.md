# Q77 Strike Targets

Catalogue commit: `d1c12c0`

**Strike criterion:** A technique is a strike if it delivers a blow (punch, kick, elbow, knee, headbutt, or a chain of these). Footwork, feints, distance reads, sweeps, catches, dumps and throws are not strikes even when their role is counter or their effects carry generic damage. A counter that hits is a strike; a catch that returns a blow is a strike.

## Per-discipline summary

| Discipline | Total | Strikes | Non-strikes | Head | Body | Leg | Spread |
|---|---|---|---|---|---|---|---|
| boxing | 37 | 27 | 10 | 14 | 5 | 0 | 8 |
| capoeira | 3 | 1 | 2 | 0 | 1 | 0 | 0 |
| karate | 70 | 63 | 7 | 61 | 0 | 0 | 2 |
| kickboxing | 3 | 1 | 2 | 0 | 1 | 0 | 0 |
| mma | 9 | 2 | 7 | 2 | 0 | 0 | 0 |
| muay_thai | 50 | 45 | 5 | 26 | 14 | 0 | 5 |
| pencak_silat | 10 | 3 | 7 | 3 | 0 | 0 | 0 |
| sanda | 12 | 2 | 10 | 0 | 1 | 0 | 1 |
| savate | 3 | 2 | 1 | 1 | 1 | 0 | 0 |
| taekwondo | 3 | 2 | 1 | 0 | 0 | 2 | 0 |
| **TOTAL** | 200 | 148 | 52 | 107 | 23 | 2 | 16 |

## SEQUENCES

Rule: a sequence's target is judged by the blow that finishes the chain, unless the chain is built to attack one target throughout (a liver combination is body).

- **boxing_counter_combination** (punch, head): counter combination of straight punches finishing at the head Rule: finishing blow.
- **boxing_jab_body_head** (punch, spread): sequence that explicitly alternates body and head targets Rule: explicitly alternates targets (body then head = spread).
- **boxing_liver_combo** (punch, body): jab-cross-hook combination built entirely to attack the liver Rule: unified target (liver = body throughout).
- **boxing_one_two** (punch, spread): jab-cross combination that goes to head and body Rule: chain attacks both head and body = spread.
- **boxing_one_two_hook** (punch, head): jab-cross-hook sequence finishing with the hook at the head Rule: finishing blow.
- **boxing_six_punch_combo** (punch, spread): long punch combination that attacks both body and head Rule: chain attacks both head and body = spread.
- **karate_ageuke_gyakuzuki_combo** (punch, head): block then reverse punch finishing at the head Rule: finishing blow.
- **karate_ashibarai_gyaku_combo** (punch, head): leg sweep then reverse punch the finishing blow is a punch to the head Rule: finishing blow.
- **karate_counter_gyaku** (punch, head): body shift then reverse punch counter finishing at the head Rule: finishing blow.
- **karate_kizami_gyaku** (punch, head): lead punch then reverse punch finishing at the head Rule: finishing blow.
- **karate_sanbon_chain** (punch, head): three-punch consecutive chain finishing at the head Rule: finishing blow.
- **karate_shutouke_nukite_combo** (punch, head): knife-hand block then spear-hand counter to the head Rule: finishing blow.
- **karate_sotouke_empi_uraken_gyaku_combo** (punch, head): block elbow and back-fist chain finishing with a reverse punch to the head Rule: finishing blow.
- **karate_sweep_finish** (punch, head): leg sweep then strike to a grounded opponent the finishing blow is a punch likely to the head Rule: finishing blow.
- **mma_jab_levelchange** (punch, head): jab that feints a level change the jab itself is a punch to the head Rule: finishing blow.
- **muay_thai_clinch_knees** (knee, body): clinch knee series a chain of knees to the torso Rule: finishing blow.
- **muay_thai_eight_limb_chain** (mixed, spread): teep-round kick-clinch knee-elbow chain that attacks multiple targets with multiple limbs Rule: multi-limb chain (teep-kick-knee-elbow) attacks multiple targets = spread.
- **muay_thai_jab_cross_hook** (punch, head): jab-cross-hook punch combination finishing at the head Rule: finishing blow.
- **muay_thai_jab_cross_sok_klap** (mixed, head): jab-cross-spinning elbow chain finishing with the elbow at the head Rule: finishing blow.
- **muay_thai_kick_knee_combo** (mixed, body): kick then knee both aimed at the body Rule: finishing blow.
- **muay_thai_slip_sok_klap** (elbow, head): slip then spinning elbow finishing at the head Rule: finishing blow.
- **muay_thai_sok_clinch_combo** (elbow, head): clinch elbow combination aimed at the head Rule: finishing blow.
- **muay_thai_superman_knee_punch** (mixed, head): Superman knee then punch both aimed at the head Rule: finishing blow.
- **muay_thai_switch_cross** (mixed, spread): switch kick then cross the kick goes to the body the cross to the head Rule: finishing blow.
- **muay_thai_teep_knee_chain** (mixed, body): teep then knee both can target the body Rule: finishing blow.
- **muay_thai_thip_clinch_knee** (mixed, spread): push kick then clinch knee entry that attacks multiple targets Rule: finishing blow.
- **sanda_straights** (punch, spread): lead-rear straight punch combination that goes to head and body Rule: finishing blow.
- **silat_elbow_counter** (elbow, head): parry then elbow counter aimed at the head Rule: finishing blow.

## DISAGREES WITH ITS KEY

These strikes carry a locational effect key whose target differs from the Q77 adjudication:

- **boxing_inside_uppercut**: key `clinch_damage` says body, Q77 target is **head**. uppercut on the inside lands primarily on the chin though the node carries clinch_damage
- **boxing_jab_body_head**: key `body_damage, head_damage` says body, Q77 target is **spread**. sequence that explicitly alternates body and head targets
- **boxing_shovel_hook**: key `body_damage` says body, Q77 target is **spread**. short uppercut-hook hybrid primarily to the body but can reach the head
- **boxing_six_punch_combo**: key `body_damage` says body, Q77 target is **spread**. long punch combination that attacks both body and head
- **mma_dirty_boxing**: key `clinch_damage` says body, Q77 target is **head**. short punches in the cage clinch aimed at the head though the node carries clinch_damage
- **muay_thai_switch_cross**: key `body_damage` says body, Q77 target is **spread**. switch kick then cross the kick goes to the body the cross to the head

## Q70 census corrections

Q70's census ruled these two techniques not-a-kick. Both ARE kicks:

- **karate_kizami_maegeri**: lead front snap kick (maegeri) to the head. Q70 missed this; it is a kick.
- **taekwondo_back_kick_counter**: back kick intercept aimed at the kicking leg. Q70 missed this; it is a kick.

## Low confidence entries

- **capoeira_ginga_flow_chain** (kick, body): ginga deception chain that delivers strikes through deceptive movement predominantly kicks to the body
- **karate_sweep_finish** (punch, head): leg sweep then strike to a grounded opponent the finishing blow is a punch likely to the head
- **muay_thai_full_spectacle** (mixed, spread): multi-phase spectacular chain of strikes across multiple targets

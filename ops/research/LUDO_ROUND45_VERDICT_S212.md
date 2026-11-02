# LUDO ROUND 45 - VERDICT (S212): how the gym grows when you buy equipment (slots, catalog, shop)

Operator question S212: "is there a set number of each equipment that can be build on the gym ? i am worried about of option later
buying more equipment where it will be shown it seems packed. is this balanced on the floor ?" - Claude proposed authored slots per zone;
operator: "i agree but ask ludo too". Ask `LUDO_ROUND45_ASK_S212.txt` (+ floor plan + game still); reply verbatim
`LUDO_ROUND45_S212_reply.txt` (22,400 chars, complete A-F).

## The defect behind it (found S212)
`GameState.purchase_equipment` places a bought item on an abstract tile grid (`_find_first_fit`); the 3D club (GymClub3D + the S206
layout) only draws its 19 authored places. A bought bag costs money and never appears. Reachable: dock -> gym hub -> floor tab -> buy.

## TAKEN (build to this)
1. AUTHORED SLOTS, no free grid: every zone has fixed slots (transform, footprint + clearance, category). Buying mounts the item into a
   slot; "if it is simulated, it exists on the floor". The abstract grid goes.
2. Empty slots look finished: an empty bag hook = a steel eye-bolt + shackle on the beam (no dangling chain); an empty floor slot = clean
   floor with a small stencil number ("03", #64748B) - never a grey box or wireframe.
3. Build mode only: opening the equipment panel shows valid empty slots as a pulsing cyan footprint, occupied ones a muted outline,
   incompatible zones dimmed; a ghost of the item snaps to the nearest valid slot; click = buy + mount.
4. Zone full: buy is greyed with "ZONE FULL (CARDIO 4/4) - replace a station or move to the bigger gym (T2)". REPLACE swaps in the same
   slot (old one sold at condition x 50%). Items move freely between compatible empty slots of a zone.
5. Slots per zone, T1 (start filled): west bag beam 5 (4), east bag beam 3 (0), east bag wall 3 (0), boxing floor OPEN (pads + slip
   rope only), cardio 4 (2), timing 4 (2), footwork 2 (1), stretch 3 (2), strength 5 (3), ring 1 (1) = 30 slots, 15 filled (Ludo
   says 27/16 - its table adds to 30; the build counts from the slot data). T2/T3 grow per Ludo's table (bags 8/14 west, cardio 8/14,
   strength 8/14, a second ring at T3). The open boxing floor stays open at every tier.
6. Catalog for a BOXING club: no bodybuilding isolation machines (pec deck, preacher, leg extension/curl, calf, smith, hack squat, ab
   machine, isolated benches); 10 bench types -> 1 adjustable bench; free weights, racks, platforms, cables, bags, timing, cardio,
   footwork, stretch. Judo tatami, grappling dummy, octagon etc. are kept for the MMA update; cryo/rehab pool/sports-medicine room at T2/T3.
7. Why buy (mechanic): stations are used by members AND fighters; at peak hours (07-09, 17-20) a full zone makes a visible QUEUE; a
   fighter whose drill station is taken loses training quality and gains stress; members who queue too often grow unhappy and cancel.
   Diminishing returns per extra station of the same kind (1/sqrt(k)) so nobody builds 10 treadmills; extras still serve member
   throughput and still cost upkeep.
8. Shop screen: catalog drawer on the left, the 3D floor stays live on the right (no store page), header shows tier, stations used/total,
   members, cash; click an owned item = a small dock with INSPECT / MAINTAIN / MOVE / SELL.
9. Traps (binding): bags only on beams/walls, never on mid-floor stands; 1.2-1.5 m aisles; ring apron clear on all sides; tall kit at
   the walls, low kit toward the camera; equipment in neutral industrial colours - zone colour comes from the floor mat only.

## CHANGED / REFUSED (Claude)
- Ludo's prices, upkeep, stat gains (+0.4 power...), wear numbers and queue numbers (frustration +25%/day, churn +12%/month) are NOT
  data: costs stay in equipment_catalog.json, gains in our training rules, members in Members.gd/FrontDoor maths. The queue + diminishing
  returns are built on our existing station capacity and member numbers, tuned later with tests.
- No brand names in the game (Ludo wrote "Concept2", "SkiErg"): generic names (rowing ergometer, ski ergometer).
- Cut items are HIDDEN from the shop (store_available false or an MMA/T2 tag), never deleted from the catalog data.
- The invented fighter name and the audio click are ignored (no sound work now).
- Every slot is checked by a geometry test against the zone rectangles and aisles before anything is drawn (Ludo's 5th west hook
  "on the wall offset" must actually fit 1.8 m spacing - the test decides).

## NEXT
Board question (operator approves the verdict) -> TASK_EQUIPSLOTS1 (Codex): slot data in the S206 layout, GymSlot mounting in GymClub3D,
purchase_equipment -> slot, build-mode overlay, zone-full / replace / move, shop catalog filter; then stills -> Ludo -> operator.

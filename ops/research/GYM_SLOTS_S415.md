# The gym you buy up (S415, 2026-11-09)

Operator: "Yes, start small"; "use this one it has full equipment now ?" (Downloads/Modern MMA Gym Facility Layout.png, now assets/ui/art/gym_main.jpg, with the lettering retouched off the 15 bags); Q-157 "keep the cage but make it looked like it is under repair"; "make the red marked are a bit smaller to fit more things".

## How it is built
His picture, the same picture with the hall emptied by Ludo (assets/ui/art/gym_empty.jpg), and 55 pieces (assets/ui/art/gym_slots). tools/gym_slots_diff.py lines the edit up and finds the pieces; tools/gym_slots_bake.py cuts them and writes assets/data/gym_slots.json. Inputs are in E:/FightCamp/tmp/s415_full, not the repo: copy them somewhere safe before the art is redone. The cage is painted under repair into the empty room: it stands there, not for sale.
The kit his picture still lacked (scales, mirrors, treatment table, tape screen, plyo boxes and medicine balls, timer and stool, bucket) was added by one whole-picture Ludo edit. Masked edits of a small rectangle failed: they fill the rectangle with a close-up, whatever the prompt says.
The red floor is two tile rows shorter (90 px). Its width stays: seven bags and the rail fill it. The kit stands along the front wall either side of a clear aisle to the doors (his "these items are out of position at the entrance"), at 75% of the size Ludo painted it. gym_slots_test holds the aisle.

## The rule
Three members fit per place (GymPlaces.MEMBERS_PER_PLACE). The floor's room is one more limit in GymSpend.member_cap, beside the premises and the coaches. A piece counts once the fitters have had their week (7 days, as upgrades). rows empty = a save from before: the whole gym stands.

## Numbers, worked out, not played
Start: ring 10, floor 3, seven bags 7, two treadmills 2 = 22 places = room for 66 members. Everything bought: 127 places = 381, far above the top premises (250).
Today natural members = 48 + 0.6 x reputation on standard dues: 54 at the opening reputation of 10. The floor binds at reputation 30 (66), just under the unit's 70. So the first buys matter little until the club moves up; a move to 140 members needs 47 places, 25 more than it opens with.
One place = 3 members = about $24 a week in dues at the standard $35 a month. Payback: mats $130 a place, 5 weeks; heavy bag $570, 24 weeks; power rack $325 a place, 14 weeks; bench $200 a place, 8 weeks; treadmill $3,200, 133 weeks; bike $2,300, 96 weeks.
OPEN: on capacity alone cardio never pays back, so it is a fake buy until each kind builds something (S414's "kind decides what it builds"), measured on the balance harness first. No bot buys equipment yet, so the harness has not played this rule. 127 places is more than any tier needs: a cap by premises is a likely next rule.

## Prices, retail snapshots
Ring $3,500, heavy bag $570, dumbbell set $1,050, bench $400, mat $390: GYM_PLANNER_SITES_S414.md.
Treadmill $3,200: remanufactured Life Fitness 97ti $3,199, https://fitnesssuperstore.com/Life-Fitness-97te-Treadmill-p/97te.htm
Power rack $1,300: Body-Solid SPR1000 $1,295.99, https://www.dickssportinggoods.com/a/commercial-power-rack-0rtz01b.html
Exercise bike $2,300: refurbished Lifecycle 95Ci $2,275, https://reach.dog/shop/global-fitness/products/refurbished-life-fitness-lifecycle-95ci-upright-bike
Reflex bag $240: priced as a speed bag platform, Ringside adjustable $239.99, https://www.dickssportinggoods.com/o/boxing-equipment/speed-bag-training
Teardrop bag $155: priced as a double-end bag, Ringside Heritage $154.99, https://www.walmart.com/c/kp/speed-bag
Tall mirrors $800 for four 4x6 ft panels at $203: https://www.kijiji.ca/v-exercise-equipment/barrie/discount-oversized-mirror-walls-4x6ft-203-each-volume-discounts-wholesale-prices/cas_3582493 (a wholesale offer, thin)
Punching dummy $420 (S416): Century BOB XL $419.99 at Walmart, https://www.walmart.com/ip/Century-Bob-Body-Opponent-Bag/15077552
Turf strip $1,400 (S416, was a $600 guess): GymTurf 5 x 25 ft roll $1,380 plus freight, https://theamericangym.com/gymturf.asp
Conditioning set $550 (S416): Body-Solid steel plyo boxes, set of three, $329.99, https://reach.dog/shop/buy-sell-fitness/products/body-solid-tools-steel-plyo-box-set-3 plus four medicine balls at most $56.55 each (one 20 lb listing, https://tigermedical.com/products/rubber-medicine-ball-fei10-3146, so the balls are an estimate, thin).
Places of cardio (1), mirrors (4), conditioning and turf (4), and the red floor's 3, are Claude's calls.
Comes with the club, free: scales, timer and stool, treatment table, tape screen, bucket.

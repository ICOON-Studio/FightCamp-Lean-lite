# Player critic: the isometric gym as the main menu (S411)

Read: CRITIC_PACK, CRITIC_ACCESS, FACTS, and all seven pictures. Judged from the pictures only. Comparisons are ideas only (Two Point Hospital/Museum, Football Manager's hub, Prison Architect, Kairosoft's Game Dev Story, Big Ambitions).

## Scores
- PRESENTATION: 5/10 (capped by a hard fail: World does not belong where it is drawn; Playbook is borderline). Without the cap I would say 7.
- OPTIONS: 5/10.

Hard fails named:
1. World is drawn on a crate at the end of the bag wall. "World" is not a place in a gym; it sits inside the Fighters zone, 60 px from the Fighters bubble, and a player will misclick one for the other. It does not belong where it is drawn.
2. Playbook (borderline) sits on the stretching mats and uses a mat/bed icon. A game plan is not a mat. A new player will not guess that the planning book is "the blue mats".
Not a hard fail: it does not look like a website, and the picture does read as a boxing gym.

## Answers, plainly
**First impression.** Pleasant, bright, readable, and clearly a boxing gym in about two seconds: ring, bag wall, weights, lockers, office, reception door. The small walking boxers are the best thing in the picture. Warm, alive, Two Point-like cutaway. But it is a tiny gym: one ring, a row of bags, three dumbbell racks, two lockers, one desk. It reads as a diorama, not as the club I own and am growing. The paper-wash background in A gives it no place (it floats in a pastel cloud); B puts it in front of a dark real-gym photo, which has mood, but the clean cartoon iso on a photographic background clashes in style (two art styles on one screen, which the owner has already complained about).

**Does it feel like a gym I run?** Half. I feel I am looking at a gym. I do not feel it is mine: nothing shows my fighters' state (who is tired, hurt, over weight, has an offer), no sign over the door, nothing changes after I act, and I cannot touch a thing except six labels. In Football Manager terms it is the hub photo; in Two Point terms it is the building without the tycoon bit. The pleasure comes only when the floor reacts to play (a boxer with a red flag on his head, the ring with a poster when a bout is booked, a new bag when a sponsor pays).

**Does each clickable place belong where it is?**
- Fights on the ring: yes, best one in the picture.
- Club office on the desk in the walled room: yes.
- Reception on the front desk and door: yes, but the label sits across the door and its arrow, hiding the door. Drop the arrow, nudge the label.
- Fighters on the bag wall: acceptable (that is where the boxers work). Better would be the boxers themselves being the click (see below).
- Playbook on the mats: weak. A whiteboard or a coach's corner with a clipboard would be right. It is also the one place not on the top bar, so it is the least discoverable and most important training mechanic (the owner calls it really fun).
- World on a crate at the bag wall end: wrong. Put it on a noticeboard or a TV/laptop in the office wall, or a window/door to the street. It must not share a zone with Fighters.

The labels are far bigger than the objects they name (the bubble plus dark label is about the size of the desk). They cover the thing they point at. A bubble that small icon-only until hover, with the name on hover, would let the room be seen.

**Which Home layout is better?** B, narrowly, and only as a base. One screen, no scroll, the gym stays the hero, and the needs sit beside it like a real office wall. A pushes everything that makes Home useful (the job, needs, last Monday) under the fold, so the first screen is a pretty picture and a red button at the top. A new player in A sees no needs at all without scrolling (the top bar red button is the only hint). B's faults: the sticky notes have no titles (known), the right side has a lone floating boxer with a "Find a bout" button that is unclear (whose boxer? why is she alone?), the bottom portrait strip repeats the same face with a yellow OFFER bubble (test data, but the row is unlabelled and tiny), and the bottom-right tiles (members, reputation, cash, bills, mail) repeat cash which is already in the top bar. The dark photo behind it also makes the scene muddier than the bright paper wash. Best answer: B's one-screen arrangement, A's clean light background, fewer pieces.

**Choose your building page.** The four thumbnails look nearly the same at card size: the same room with a bag wall or a second ring. The player cannot tell "Front of house" from "Conditioning floor" without reading. The edge text is good (one plain number each). The page is a form with painted cards: it works, but the pictures are too small. Make the thumbnails larger and give each building a distinct silhouette and a colour accent, and show the exact thing that makes it different (a second ring is obvious; "front of house" is not).

## What the pictures show about the rest
- The fighters page and versus page are the standard: big pictures, few words, a clear single action. The gym should match them. Fighters page shows seven identical Lucy cards (test data). The painted concepts are too text-dense, as the facts file says.
- Top bar plus in-room bubbles duplicate navigation (Home, Fighters, Fights, Club, World both ways). Fine as a start, but the room bubbles must do something the top bar cannot: show state.

## Presentation detail
Good: bright, tidy, consistent perspective, little people animate, stylised enough to be forgiving, one angle, readable at 1920.
Bad: floating without a street or building outside; no light/shadow variation; floor items of the same scale and spacing (flat rows); labels too large; no sign of the club's name or members (30 members but ~9 people); nothing on the walls (posters, belts, the fight date); dark photo background in B clashes; A below the fold is a normal web page again (the "job" card and the news column are exactly the form look the owner banned).

## Options (what each place changes in the game)
- Reception: members, walk-ins, signing. Useful. Needs a visible "someone is waiting" state (a figure at the door).
- Fighters: roster, find a fighter. Useful, central.
- Playbook: game plans, moves, combos. Useful but needs a fighter chosen; opens "the fighter's" book, so which fighter? A pick is missing.
- Fights: offers and the booked bout. Useful; the red badge on the top bar handles state, the ring bubble should too.
- Club office: money, staff. Useful.
- World: rankings, other gyms, news. Useful but placed wrongly; low urgency.
Missing: Training week (the main weekly mechanic) has no place in the gym: it is reached only via a fighter. A place for it is missing (a whiteboard on the wall, or the boxers on the floor). Records/history has no place. Settings/Menu is on the top bar, fine. The "needs you" list is not on the map at all in A; in B it is a whiteboard whose notes are empty.
Useless: duplicate cash/stat tiles in B; the lone boxer plus "Find a bout" button in B; the mail tile if the top bar Menu has Mail; the portrait strip as drawn.
Real amateur gyms hold: a ring (often 16-18 ft), 6-12 heavy bags, a couple of speed bags and double-end bags, a skipping/shadow-box area with a mirror, a small weights corner, a wipe-down mat, changing room/lockers, a small office or desk, a water bottle and a notice board. The game has most of these but no mirror/shadow space, no speed bags, and no noticeboard, which is where World and the fight date naturally live.

## To reach 10/10
1. Fix the places that do not belong. Move World to a noticeboard or TV on a wall (or the street door) away from Fighters. Move Playbook to a coach's whiteboard/corner with a clipboard (a drawn board at the ring side or on the office wall), not the mats; change its icon from a bed to a clipboard/whiteboard. Add a small "Training week" place, or make clicking a boxer on the floor open that fighter (see 3).
2. Make the floor show state, so the picture is the menu. A red flag or small bubble above the specific boxer who needs you (over weight, hurt, offer, low mood); a poster on the wall with the fight date and opponent when a bout is booked; a person waiting at the door when a walk-in exists; the ring lit when fight night is today. Needs should live on the objects they belong to, not only in a list.
3. Make people clickable: click a boxer to open his or her page (this uses the roster and removes the need for a "Fighters" bubble on the bag wall). Members stay decoration but must be clearly different from the club's fighters (outfit colour, name on hover for fighters).
4. Shrink the labels. Icon-only bubbles at about half the current size, the name on hover, so the objects are visible. Remove the arrow on Reception. Keep one label style.
5. Choose one layout: B's one screen with A's light background. Put the needs board beside the gym with titled, readable notes (fix the missing titles), the next-fight card, and the one big button. Remove the duplicated cash/stat tiles, the lone boxer and the OFFER portrait strip, or label and wire the strip as a real roster row. Nothing important below the fold on first open.
6. One art style. The clean cartoon iso on a dark photograph (B) clashes. Either paint a matching backdrop (a street front, a brick wall, the same painted look as the Fighters and versus pages) or put the gym on the same warm paper as the rest of the shell, with a soft drop shadow and ground plane so it sits somewhere.
7. Give the gym more life at the first screen. 30 members should look like 30: more people near equipment at all times, speed bags and double-end bags, a mirror/shadow-boxing area, posters and belts on the walls, a club sign with the gym name over the door, a window with the street. Day and evening lighting change with the game clock.
8. Make the four buildings different at card size: bigger thumbnails, distinct silhouettes and colour, the edge drawn on the picture (a second ring, a longer bag wall, a bigger conditioning floor), the label beside it.
9. Show the building's growth. When premises move up, the plan changes size; when an upgrade is bought, the object appears (a new bag, the matted floor). This is what makes it a gym I run and not a poster. Rooms stay empty until I buy, per the owner's old rule; the starter gym should be visibly small and then fill.
10. Make the first-hour guide point at the gym: a pulsing ring on the next place ("Reception: Lucy is waiting"), so the picture teaches the loop.
11. Keep the Playbook one click from the top bar too (currently it is the only place missing from it), or state in the picture why not.
12. Later, as agreed: let the player place items on the plan with the same rules (zones first, then items), and add a pan/zoom only if the gym grows past one screen.

## My 10/10, drawn
E:/FightCamp/Lean/docs/mockups/s411/gym_10/player.png (source: player.html beside it). One screen, light backdrop, Playbook as a whiteboard and World as a noticeboard on the walls, a flag on the boxer who needs you, a walk-in at the door, the booked bout as a wall poster, a Training week place. Warning triangles mark what is not in the game yet. Known flaws of the drawing: the wall boards are skewed text with some overlap, and the ring sprite is not matched to the zone drawn under it.

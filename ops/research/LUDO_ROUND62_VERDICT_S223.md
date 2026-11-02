# LUDO ROUND 62 VERDICT (S223) - the boxers' kits (Maria M43) + the first corner (Kalli K87)

Ask `LUDO_ROUND62_ASK_S223.txt` (Maria's kit board uploaded); reply verbatim `LUDO_ROUND62_REPLY_S223.txt` (24,622 chars), Ludo
scores A 9.3 / B 9.6 / C 9.7. Sources: Maria `M43_MARIA_REPLY.md` (12 kits, colour-blind contrast computed), Kalli `K87_KALLI_REPLY.md`
(design review critical finding 2: the corner is never played). Nothing below is built until you OK it.

## A. Kits - TAKE Ludo's 10 kits
- Each boxer fights in his own colours (pro rule, Nevada/ABC); red and blue stay on the scorebug, stool and corner jackets only.
- 10 kits: Crimson, Royal Blue, White, Black (gold trim), Gold, Imperial Purple, Kelly Green, Hunter Orange, Steel Charcoal (gold
  trim), Maroon. CUT: Magenta (reads as Crimson under the warm ring light) and Silver (disappears on the light canvas).
- Every kit = trunk base + trim + waistband (light trunks get a dark waistband, dark trunks a light one) + gloves + white tape.
- Boots (the Epic MetaHuman Hightops you claimed): black or white, the kit colour ONLY on laces, ankle strap and heel. Same-colour
  boots made the legs look short on the wide shot.
- When two boxers' kits clash, the away boxer switches to his alternate kit; if that clashes too, he wears White (Black against White).
- Claude's corrections: (1) the clash list comes from Maria's COMPUTED contrast table (normal + colour-blind + warm light) plus
  Ludo's 6 warm-light pairs - not a hand-typed list alone; (2) a test proves no booked pair ever shows two kits closer than the
  threshold, for every pair of the 10; (3) no shader rewrite: the existing MetaHuman material tints take the colours.

## B. The first corner - TAKE Ludo's corner card
- After round 1 the camera cuts to the stool and a card slides up from the bottom (980 x 340): round verdict, stamina, body tags,
  the timer; one line from the chief second; three call cards. The CAMP's plan is already selected: gold rail on the left and a
  "CAMP DIRECTIVE: BODY" badge (hover: which camp week set it and what it gives).
- Click another card = it is selected at once; the badge turns amber ("CORNER CALL") - gold means "my preparation", amber means
  "changed in the fight". SEND IT (Space/Enter) sends; at 45 s the selected call goes by itself ("PLAN CONFIRMED").
- Timer amber at 30 s, red in the last seconds. Corners 2+: an "auto-send" switch sits on the card itself, no pop-up. A knockdown
  always stops auto-send.
- Round 2 must SHOW the call: the scorebug says "CALL: GO TO THE BODY - FROM CAMP" for 8 s and the boxer visibly does it.
- Claude's corrections: (1) the call's effect uses the corner instructions the engine already has and is MEASURED like CAMPPAY1
  (seeded bouts, called vs not) - not Ludo's "+35%" number; (2) sounds (towel slap, bell, whistle) wait for the audio pass;
  (3) names and lines come from our staff and the existing corner text, not invented ones.

## B2. How the corner minute works in full (added S223 after the operator asked: "what happens in the last 30s ... is there any other
## option for the corner ? choices on the cuts , recovery etc ? how are all these handled from the camp ? what if there is no camp ?")
- Clock: the rest is 60 s, ~45 s usable. 0-30 s normal; at 30 s the bar only turns amber (a warning); red in the last ~5 s; at 45 s the
  selected call is sent by itself. SEND IT ends the corner at once.
- Every job costs time (the existing pit-stop rules, ludo_corner.json / CornerPitStop.gd): the three lanes work AT THE SAME TIME; each
  lane has room for about two jobs; a rushed third job in the last 15 s has a 35% chance to go wrong (e.g. the ice slips, swelling worse).
- The three lanes that already exist in the game:
  CUTMAN - ice/enswell (swelling down), adrenaline swab (bleeding down, less doctor risk), Vaseline (fewer new cuts), deep coagulant
  (double job, bleeding down two steps). SECOND (recovery) - water rinse, ice collar on the neck, torso aeration (stamina up, heart rate
  down), deep rehydrate (double job, big stamina). CHIEF - the tone (calm / fire / the truth; its effect depends on whether the fighter
  sits groggy, panicked, complacent or steady), point out the opponent's tell, an exit plan vs traps and clinches, a full tactical change
  (double job).
- Kalli's card = the chief's CALL on top. The cutman and second rows open only when needed (a cut, swelling, a knockdown, low stamina),
  each with its own default (ice for swelling, swab for a cut, water when tired), so a quiet corner is one click.
- From the camp: the default CALL (camp focus -> call table in K87 s2) and, if scouting found it, the opponent's tell line. NOT from the
  camp: cuts and recovery - they come from the fighter's state at the bell, worst problem first; the cutman's skill sets the mistake chance.
- No camp: the default call is "Hold the centre", tagged "COACH'S CALL" instead of "FROM CAMP"; no tell line; cuts and recovery the same.
- Auto-send (later fights): the card shows 3 s with the call it sends, then the fight goes on. It switches itself off (you play the
  corner) on a knockdown, a cut or swelling, the doctor, two lost rounds in a row, or the last round of a close fight.

## Build order if you approve
1 kit data + clash resolver + test (Arena, pure) -> 2 kits on the MetaHuman boxers + boots (Codex, PC, with WARDROBE1/MH5)
-> 3 the corner card + timer + camp default (cloud Cursor) -> 4 the call's measured effect in round 2 (Codex/Grok Dev).
Every piece ships ON and comes back to you as a still or a short clip.

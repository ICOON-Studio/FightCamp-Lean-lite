# LUDO ROUND 61 VERDICT (S223) - the globe country picker + the day strip in the top bar

Your notes it answers, verbatim: C67 "ask ludo to use a 3d rotating globe to pick a country"; C66 "when i said turn things on i meant
the things that we use in the game is the calendar strip in the game ?"; S223 "are we using the calendar strip or no , what ludo says ?".
Ask `LUDO_ROUND61_ASK_S223.txt` (one image uploaded: today's country screen + today's floor with the top bar); reply verbatim
`LUDO_ROUND61_REPLY_S223.txt` (21,437 chars). Ludo scores itself A 9.4 / B 9.7 / C 9.8. Nothing below is built until you OK it.

## A. The globe (New Career step 1) - TAKE, the cheap version Ludo recommends
- A slowly spinning 3D globe on the left/centre over our gym backdrop; a 480 px panel on the right shows the picked country's numbers
  and CONFIRM COUNTRY (Enter).
- One sphere (about 4,000 triangles) with a painted map: dark charcoal sea with faint latitude/longitude lines, warm dark stone land,
  thin borders; the picked country fills gold with a glowing gold edge; a brass pin with a red head on the capital; a soft amber glow
  round the edge of the globe.
- Drag to spin (it keeps turning a little after you let go), the mouse wheel zooms, a search box (top left) flies the globe to the
  typed country in under half a second. The search box is also the keyboard/accessibility path.
- Country shapes from Natural Earth (public domain, free to ship, no credit line needed). The click finds the country from a hidden
  colour-coded map, so we build no per-country meshes. Ludo's cost estimate is 3.5 days of code and 1 day of art.
- Claude's corrections: (1) only countries that are boxing markets in OUR data light up and can be picked; the rest stay dark stone
  and say "not in the game yet" on hover. (2) The right panel shows OUR market numbers (the ones today's country cards show), not
  Ludo's invented ones ("active gyms", "combat tradition"). (3) Small markets (Puerto Rico, the Philippines) get a pin you can click
  even where the land is a few pixels. (4) Ludo names a "Godot-Globe-3D (MIT)" addon: not verified. Our build checks the Godot Asset
  Library and GitHub for a real licensed one first and uses it if it fits; otherwise it builds the ~160-line version Ludo describes.

## B. The day strip - TAKE: it leaves the top bar
- Ludo's ruling: remove the 12 day tiles ("Mo 9 ... Fr 20") from the top bar. At 1280 wide each day is about 22 px, too small for an
  icon, and it crowds the bar. The days live in the right-edge calendar tab: a click (or the C key) slides out a 4-week drawer with
  big day tiles and icons: bout (red), weigh-in (gold scale), medical (white cross), travel (blue arrow), payroll (amber coin).
- The top bar keeps three blocks: money + runway on the left; in the centre the speed buttons, the date (MON 9 FEB / WEEK 6) and the
  day's line with STEP IN (your round-31 rule, already approved); the bout card on the right (NO BOUT BOOKED / FIND A FIGHT, or
  "vs NAME - IN 12 DAYS" when a bout is booked).
- Claude's corrections: keep our real speed set (pause / play / fast) and our day line + STEP IN as they work today; Ludo's
  "session progress bar with 08:00-20:00 blocks" is new design - it comes later as its own round, not in this change.
- This changes D37's timeline bar (your S166 "a timeline bar on top"): the bar stays, only the row of 12 days goes into the drawer.

## C. Ludo's 7 defects on the floor screen - Claude's sorting
1. Crowded top bar -> fixed by B.
2. "DEV JUMP 303" over the ring -> NOT a defect: it is the gym's name on the back wall; that still uses the developer test career
   ("Dev Jump"). A real career shows the player's gym name there.
3. "Stamina above 30 at the bell" floats bottom-left with no fighter attached -> TAKE: the day goal sits on the fighter's card.
4. News lines at the bottom in a cut-off box -> TAKE: one thin bar along the bottom edge, results as chips (KO R4, DEC 3-0).
5. Left icon column has no labels -> TAKE: dark square tiles, hover tooltip with the name + the F-key.
6. Black void outside the walls (and the big white band across the bottom) -> TAKE: a low-poly street outside (brick neighbours,
   alley, city skyline) so the camera never shows black.
7. "GUIDE - Hire a coach" floats bottom-right -> TAKE with the reveal schedule you approved (Q-S221-2): one objective card top-right
   under the bout card, "STEP 1/4: HIRE A COACH".

## If you approve
A goes to Cursor (a Godot UI build) with Arena writing the pure country-lookup module + test. B goes to cloud Cursor (the timeline
bar + drawer). C3-C7 go to the queue as one HUD pass. Each ships ON (CLAUDE.md s10) and comes back to you as a still.

# RESTYLE1 - a style sheet + three screen mockups for FightCamp (S540, owner Q-S294-309 "Yes, start")

You are a senior game UI designer. FightCamp is a boxing-gym management sim for PC (1920x1080, mouse). The owner played a
rival demo and said our menus should look "much more polished". Your job: draw that polish for OUR game, in OUR palette.
Do not copy any other game's layout, names or art; take only the general craft listed below.

## What "polished" means here (read from the rival demo, our words)
1. Every block is a CARD: rounded corners (8-10 px), a 1 px border a little lighter than the card, a very soft inner glow on
   the active card. Cards sit on a darker page with 24 px gaps. Nothing floats on a photo.
2. Section labels are SMALL CAPS, letter-spaced, in the accent colour (11-12 px); the content under them is plain and larger.
3. One BIG headline per screen (the person or the night), with a quiet sub-line under it.
4. KEY-VALUE TILES: three or four small cards in a row, each with a tiny label on top and one bold value (e.g. RESULT / Win,
   METHOD / Points, ROUNDS / 3).
5. Tags as PILLS (rounded, outlined, small) in the top-right of a card.
6. Comparisons as TWO-COLOUR BARS meeting in the middle with the numbers at the ends.
7. Exactly ONE primary button per screen, filled with the accent, everything else outlined or plain text.
8. Tables with roomy rows (56-64 px), a portrait at the left of each row, muted column heads in small caps.

## Our palette and type (decided by the owner, keep it)
- Warm dark brown page (#1c1712), cards a step lighter (#262019), borders (#3a3127); text cream (#efe6d6), muted (#a89a86).
- Accent YELLOW/amber (#e8b54a) for labels, the primary button and highlights. Green (#3fb27f) = good, red (#d0503c) = bad.
  Blue (#4a7fd0) only for "your boxer" in two-colour bars; the opponent's side is the red.
- Font: a clean sans (Barlow or Inter from Google Fonts); the gym name in our hand-lettered display style may stay as plain
  bold italic.
- Words: plain game words, no jargon. Names appear only in headers; body text says "your boxer", "the opponent".

## What to draw (each a complete, self-contained HTML page, 1920x1080, inline CSS, Google Fonts allowed, no scripts)
A. STYLE SHEET page: colour swatches with hex, the type scale (headline, sub-line, label, body, small), a card, a tile row,
   pills, the two-colour bar, primary / secondary / plain buttons, a table row with a portrait placeholder, a chip that warns
   ("Leans on one answer: an opponent reads it after three uses a round").
B. PLAYBOOK > GAME PLAN for one boxer. Top bar on every game screen: back/forward, gym name "Anvil Street Gym", date
   "Mon 5 Jan 2026 / Week 1", buttons Gym, Mail (2 new), cash "$17,200" with "running -$628 a week", the primary button
   "CONTINUE to Mon 12 Jan, week review", Menu. Header: portrait, boxer name, "Lightweight, 21, orthodox, amateur 3-1",
   tabs Overview / Fight prep / Playbook / History, sub-tabs Moves / Game plan / Combos / Escapes. Left card: the next
   opponent ("waits to counter") and what film found (GAME, BEST WEAPON, HABIT, WEAKNESS - found or not yet). Middle card:
   the plan as "IF the opponent does this -> THEN do that" lines (3 lines, each answer graded Strong / OK / Bad and a drill
   state LEARNING / SHARP), plus "At the bell" defaults by range (outside, long, mid, inside, clinch, ropes, corner).
   Right card: "Set it up: four clicks a line" help in 4 numbered steps. Actions: Use a preset, Test it on a spar night,
   Your coach rewrites it, Open the move map, Save / Load.
C. FIGHTERS > ROSTER: a table of 6 boxers (name, weight class, age, record, form, morale, next bout, goal) with portraits,
   a filter row, and a detail card at the right for the selected boxer (record, ladder rank, three key stats as bars,
   buttons: Open, Book a fight, Train).
D. FIGHT RESULT: headline "Win on points" with the two boxers, tiles (RESULT, METHOD, ROUNDS, RANK EARNED e.g. "Regional
   #14 -> #11"), a round-by-round card (who won each round, the corner's call), "The plan your boxer walked out with"
   (6 lines, each with its grade and "won 2 of 3" / "never used" and, on one, "read after 3 uses in round 1: paid 30% less"),
   a WHY card (your plan, against you, next), two-colour bars for punches landed / body / head, and one primary button
   "Back to the gym".

## Return
The four HTML pages, each in its own code block, in the order A B C D. Under each, three lines: what you changed from a
plain dark-panel UI and why it reads better. Then **To reach 10/10** for the set (owner rule): what would make it better still.

## THIS REQUEST: draw ONLY page C (one complete HTML code block, 1920x1080, from <!DOCTYPE html> to </html>), then its three lines and To reach 10/10. Use exactly the colours, type scale and components of your style sheet A (already drawn: rounded 10px cards, small-caps amber labels, tiles, pills, two-colour bars, one primary amber button). Keep the page under 250 lines of HTML so it is not cut off.

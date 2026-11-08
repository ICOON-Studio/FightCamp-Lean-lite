# Rules for every menu mockup (S403)

Operator: "use 8 mma fighters with different skillsets to populate menus so that everything is predicted before the mma release, everything not working can be greyd out or labeled with an under construcion icon".

## Populate with the eight
Use `roster_mma8.json` in this folder: a boxer learning MMA, a BJJ specialist, a wrestler, a Muay Thai fighter, a young all-rounder, a kickboxer, a one-punch knockout artist and a fading veteran. Women and men, flyweight to heavyweight, one of them injured, one in camp, one booked, one with an offer, one with a contract ending, one a bigger gym wants, one thinking of retiring, one with nothing on.
A page that lists fighters shows all eight. A page about one fighter uses whichever of the eight tests it hardest, and must still work with each of the others: the grappler with no real striking, the striker with no ground game, the veteran with no room to grow, the prospect with everything still low.
Show the agreed 10 primary attributes. The 12 skills in the file are agreed (S404); a sport shows only its own. Moves stay in the Playbook, not on the attribute bars.

## What does not work yet
Everything MMA needs is on the page now, so nothing has to be redesigned at release.
- Something built but not usable right now (needs a coach, a date, a level): greyed out, with the reason on it.
- Something not built yet (MMA rules, the cage, the kicks in the fight): full colour, drawn exactly as it will work, with the under construction mark. A whole table or panel gets one mark on its header, not one per row. Do not grey it (round 2 critics: grey hid the design).

Paste this once into the page's style, then add class `uc` to the element:

```css
.uc{position:relative;pointer-events:none}
.uc::after{content:"";position:absolute;top:4px;right:4px;width:30px;height:30px;background:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Cpath d='M12 2 2 21h20z' fill='%23ffd54a' stroke='%2322262e' stroke-width='1.6' stroke-linejoin='round'/%3E%3Cpath d='M12 9v6M12 18v.5' stroke='%2322262e' stroke-width='2.2' stroke-linecap='round'/%3E%3C/svg%3E") center/contain no-repeat}
```

The game uses the same two states when screens are built.

## Icons and tooltips
Operator: "try to use icond and toolitps instead of plain text , people can understand some things".
Use an icon wherever a player understands it without words: stamina, money, injury, weight, time, a locked option. Put the explanation in a tooltip. Keep words where an icon would be guessed wrong: names, numbers, decisions and the buttons that commit to them.
Draw them as simple inline SVG line icons, the Lucide style (24 by 24, stroke 2, round joins, no fill), one consistent set across the pages.
A still cannot hover: give every icon a `title` with its tooltip text, and draw one or two tooltips open on a page so the style can be judged.

## Shared parts (round 4)
Every page loads `facts.js` and `kit.js` at the end of body and takes its top bar, rail, icons and every shared fact from them (usage in the head of kit.js, the icons in `icon_sheet.png`). Change a fact in `facts.json`. `python tools/check_mockups.py` must print MOCKUPS OK. `python tools/render_mockup.py <page.html>` draws one page at a time and waits if the PC is short of memory.

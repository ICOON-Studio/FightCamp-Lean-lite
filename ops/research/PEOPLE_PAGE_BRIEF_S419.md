# Club > People with ten coaches: open brief (S419)

The operator on the Club > People page, 2026-11-10: "the people screen look very poorly , can you show it to me if it is populated with 10 coaches ?"
His standing rulings: no spreadsheet of label and value rows ("panels look excel board"): an icon, a number or a shape and a short caption, words in tooltips; show only what the player can act on; "your fonts are small"; "all designs look similar" (so each designer starts from a different idea and must not look at the page as built).

Do NOT read scripts/ or any still of the page that exists today, and do not read the other designer's files.

## Read first
- `ops/research/CRITIC_PACK.md`: the whole game. Read the staff and money sections closely (the head coach and their one edge, assistants, training quality, the coach factor 0.5 + rating x 0.7 per cent, no coach = 60%, plan lines a coach can teach, evening classes +$350 a week with a coach, strength coach, physio, cutman, wages).
- The settled look: `docs/mockups/s416/overview_painted_ludo.png` (dark slate boards in wooden frames with brass corners, wooden tabs and buttons, chalk and gold lettering). Pieces: `assets/ui/wood/*.png`. Painted faces you may use as portraits: `assets/ui/style_b/portraits/*.png` (mh_staff_coach, mh_staff_coach_2, mh_staff_trainer, mh_staff_cutman_1 and the mh_boxer_NN files; reuse faces, it is a mockup).

## The situation to draw
A club some years in: the player (head coach Sam Carter, edge "Easier weight cuts") has TEN coaches and staff to look at on one screen: some hired, some on offer. Use these people so both designs can be compared:
Hired: Luke Reid (pads, part-time, $450 a week), Marcus Hale (conditioning, full-time, $1,090), Dee Okafor (strength coach, $100), Priya Shah (physio, $75), Tom Byrne (cutman, $150 a pro night).
On offer: Rosa Vidal (sparring and ring craft, $900), Ken Adeyemi (bag and power, $620), Ilse Brandt (defence and footwork, $780), Joe Marsh (youth and evening classes, $380), Ana Costa (ex-pro, fight plans: teaches 9 plan lines, $1,400).
Every coach has five training areas rated 0 to 100: Pads, Bag, Sparring, Conditioning, Strength. Invent believable ratings that fit each person. The club has two boxers in camp: Lucy Jackson and Ana Reyes. Money: $18,700 in the bank, the club runs at -$600 a week.

## What the player does here (the whole job of the screen)
1. See at a glance who covers what, and where the gap is (for example: nobody good at sparring).
2. Compare a coach on offer against the gap: what would change for MY boxers (a real number: Lucy's pad work 24 to 31 a week), what it costs a week, and whether the club can carry it.
3. Hire, let go, or move a coach between part-time and full-time.
4. See the specialists (strength, physio, cutman) as slots that are filled or empty, each with its one effect.

## Hard rules
- 1920x1080, one self-contained HTML file (images by relative path), rendered with `python tools/render_mockup.py <your html>` run from the repo root; OPEN the PNG with your file tool, fix what is cut, overlapping or cramped, render again.
- Type: nothing under 20 px; names and numbers the player acts on 26 px or more; headings 40 px or more.
- At most 90 words on the screen, not counting people's names and numbers. No sentence over 6 words.
- Ten people must be on screen at once without scrolling, and it must not look like a table.
- Never "he" or "she": the name, or "the coach".
- Nothing opens on a monitor: file tools only. Write only your own files in `docs/mockups/s419/`.

## Hand back
The PNG path; the idea in two sentences; where the eye goes first, second, third; what each control changes; the word count; the smallest type; what you would cut next.

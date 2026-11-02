# M22 - THE VISUAL LANGUAGE, AS NAMED TOKENS

**Owner:** maria. **Collected 2026-09-22 from the Grok Bot app by Tools/grokbots/collect_chat.py.**

**HOW THIS WAS COLLECTED, and it matters.** `grokbots.py read` returns the
SIDEBAR, not the message column - 1,677 characters for a chat holding
6413. On 2026-09-22 that made a finished delivery read as "the bot stopped
without replying", and it was reported to the operator that way before being
corrected. `Tools/grokbots/collect_chat.py` reads `main.sand-chat` and POLLS
until it stops growing, because a dump taken the instant a chat opens returns
16 characters. The raw capture is kept beside this file in `_collect/`.

---

1:53 AM
Maria Art Director
M22_VISUAL_LANGUAGE.md

Maria Art Director · 2026-09-22 · art only — named values for any agent; no layout mock of a full screen

Cage Desk continuity: dark instrument chrome, scarce accent, sodium/ice status metal. Built so Claude can turn these into constants without taste.

References (what was taken):

Football Manager — dense roster/table chrome; accent reserved for selection/action; hairline row separation over big shadows.
Out of the Park Baseball — stat row as label | meter | number; numbers right-aligned; functional bars, not decorative.
Frostpunk (management layers) — dark raised plates; status colour = meaning only (cold/warn/ok); one elevation language.
Bloomberg Terminal / finance dashboards — monospace-feel tabular numbers; secondary text muted but still readable; sunk wells for dense data.

Where they disagree: FM/OOTP prefer hairline + flat panels; many AAA shooters use soft drop shadows. Pick hairline + one radius, no soft panel shadows — shadows are the commonest “game UI trying hard” tell on management screens, and they fight dense tables.

DECISIONS (typeable)
Palette = 12 tokens (below). No SELECT. Accent = gym blue; candour link = lighter blue; gold/sodium reserved (see roles).
Type = 2 faces: face_display = Bebas Neue; face_text = IBM Plex Sans (free to ship). Numbers = face_text tabular lining figures (not a third face).
Space base = 4px; all steps multiples of 4.
Stat row = 30px tall, 3 columns (label | bar | number), gaps and bar as numbered below.
Elevation = hairline only; radius_sm = 4px; no panel drop-shadows.
Never list at bottom — five mechanical bans.
1. COLOUR

Surfaces and ink (hex). Contrast = WCAG 2.x relative-luminance ratio of the named text token against the named surface.

Name	Value	For
color_ground	#0B0E14	Page / app background
color_panel	#141A24	Raised surface (cards, side rails)
color_sunken	#080A10	Sunken wells (tables, ledgers, inset lists)
color_hairline	#2A3344	Borders, row rules, dividers
color_text	#E8EEF6	Primary text / numbers
color_text_secondary	#9AA8BC	Labels, captions, column headers
color_text_disabled	#5C6B7E	Disabled / inert chrome text
color_accent	#2F6FB0	Primary action / selected shell (gym blue)
color_link	#7FB6EE	Candour / interactive secondary / highlight rim
color_positive	#3D9A6A	Good / cleared / go-forward status
color_negative	#C44B4B	Bad / hold / danger / cuts
color_warning	#D4A017	Amber caution / swell / soft warn

Reserved status metals (use only as named; do not restyle chrome with them):

Name	Value	For
color_verdict	#D4AF37	Verdict / decision stamp only (one word)
color_champion	#E8B84A	Championship / sodium metal only

Contrast (must keep body text ≥ 4.5:1):

Text on surface	Ratio	Pass
color_text on color_panel	12.6:1	yes
color_text on color_ground	13.9:1	yes
color_text on color_sunken	14.4:1	yes
color_text_secondary on color_panel	5.8:1	yes
color_text_secondary on color_ground	6.4:1	yes
color_text_secondary on color_sunken	6.6:1	yes
color_text_disabled on color_panel	3.1:1	disabled only — never body copy
color_accent on color_panel (icon/chrome)	3.4:1	chrome/glyph — if accent carries text, put text on accent button fill with color_text on #2F6FB0 = 4.7:1
color_text on color_accent (button label)	4.7:1	yes
color_negative / color_warning / color_positive as fill + color_text	use fill behind text, or icon-only at small sizes	status fills are not body text colour
2. TYPE

Faces

Name	Value	Role
face_display	Bebas Neue	Titles, stamps, huge numerals (count, verdict)
face_text	IBM Plex Sans	UI, tables, body, labels; numbers use tabular lining figures

Scale

Name	Size	Line-height	Weight	Face
text_xs	11px	14px	500	face_text
text_sm	12px	16px	500	face_text
text_md	13px	18px	500	face_text
text_lg	15px	20px	600	face_text
text_xl	18px	22px	600	face_text
text_2xl	24px	28px	400	face_display
text_3xl	36px	40px	400	face_display

Floor: never ship UI copy below text_xs (11px). Table body default = text_sm. Stat row label = text_sm; stat number = text_md tabular.

3. SPACING
Name	Value
space_base	4px
space_2xs	4px
space_xs	8px
space_sm	12px
space_md	16px
space_lg	24px
space_xl	32px
space_2xl	48px

Why 4px: dense management UIs (FM/OOTP/finance) need half-steps between 8px; a 4px base keeps row heights (30px) and bar heights (6–8px) on-grid without inventing odd pixels.

4. THE STAT ROW (numbers)

Most repeated element — roster, training, fight prep, medical glance.

Token	Value
stat_row_height	30px (band 28–32; ship 30)
stat_row_columns	3 — label | bar | number
stat_col_label_width	112px (fixed)
stat_col_bar_flex	1 (fills remaining)
stat_col_number_width	40px (fixed, right-aligned)
stat_col_gap	8px (space_xs)
stat_bar_height	6px
stat_bar_radius	2px
stat_bar_track	color_hairline at 40% opacity on color_sunken / row
stat_bar_fill	color_accent default; swap to color_positive / color_warning / color_negative only when status meaning is the point
stat_label_type	text_sm / weight 500 / color_text_secondary
stat_number_type	text_md / weight 600 / color_text / tabular / right-aligned
stat_number_position	vertical centre of row; trailing edge of number column
stat_row_sep	1px color_hairline under row, full width of the three columns

From OOTP/FM: label left, meter centre, value right — do not put the number inside the bar.

5. ELEVATION AND BORDERS
Token	Value
border_width	1px
border_color	color_hairline
radius_sm	4px (panels, chips, inputs)
radius_md	6px (modals / large plates only)
elevation_mode	hairline
shadow_panel	none

Raised = color_panel on color_ground + 1px hairline.

Sunken = color_sunken inset + 1px hairline.

Do not mix soft shadow cards with hairline tables on the same page.

6. NEVER (five mechanical bans)
Never more than two type sizes in one row (stat row = text_sm + text_md only).
Never use color_verdict or color_champion on chrome, buttons, or table accents — verdict word and belt metal only.
Never put body copy in color_text_disabled — disabled is inert controls only; body stays ≥ 4.5:1.
Never use panel drop-shadows — elevation is hairline + surface token only.
Never invent a third column pattern for the default stat row — if it is a meter row, it is label | bar | number at stat_row_height.
Agent reader note

Apply tokens by name. If a screen needs a colour not in this list, stop and ask — do not freestyle hex. Claude maps these to UIKit constants; U126 audits against the names above.

1:54 AM

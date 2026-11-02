# K83 - the live fight's broadcast look: scorebug, between-rounds card, end card (Kalli, Grok Bot)

Brief: research/bots_s138/kalli.txt (TASK K83, S138). Collected by Claude S139 2026-10-02 from Kalli's chat with
Tools/grokbots/dump_full.py; the text below is Kalli's answer, unedited (NOT COMPUTED marks what needs a game model).
Kalli's mock image did not export (tainted canvas). Operator 2026-10-02: "use a new chat for kalli !!!!!" - the next
Kalli task goes out with `grokbots.py send --to Kalli --new`.

K83: live fight scorebug (the earlier send didn't deliver, so this is the full answer)
The mock uses a stand-in font and shows empty pip slots for review only. The real build uses Bebas Neue and IBM Plex Mono, and empty pip slots never ship.
The look I copy: the two-row lower-left bug that DAZN and Sky Sports boxing use, with a coloured corner bar, surname, record and a clock block. That is from memory, not checked this session. I draw it as flat panels with no logos.
1. Scorebug (1920x1080)
Placement: x 96 (the 5% safe margin), y 900, 760 wide by 96 high, which leaves 84 px above the bottom edge. It clears the top bar and the ring's centre.
Rows (each 48 high):
Element	Position in row	Size and style	Colour
Corner bar	x 0	10 wide, full row height	red #C8302E, blue #2D6EC8, must match the fighter's corner and trunks
Surname	x 24	Bebas Neue 28, caps	#F5F0E8
Record W-L-D	x 330	Plex Mono 22	#BEB8AE
Country code	x 470	Plex Mono 22	#BEB8AE
Knockdown pips	x 560, 16 px circles, 10 px gap	filled only	#E04A3F
Clock block: 150 wide by 96 high at the right end. "R2" is Bebas 30 in #F5F0E8. The clock is Plex Mono 34 in gold #E9B84A, the only gold on screen. Block panel #28221E, rows on #14100E at 92% opacity.
What animates:
Round change: a "ROUND 3" strip (Bebas 48) fades in at top centre for 1.5 s, with 0.25 s fades. The clock block flashes once.
Knockdown: the pip fills with a pop (scale 1 to 1.4 to 1 in 0.3 s). A "KNOCKDOWN" strip (Bebas 24, 28 px high) slides under that fighter's row for 2 s.
Big shot: the hit fighter's row nudges 6 px for 0.15 s, with no text. What counts as big is NOT COMPUTED and must come from the fight model.
Rules: no running score on the bug, since TV boxing shows scorecards between rounds. Pips appear only after a fighter's first knockdown. The pip limit comes from the sanction's rules (NOT COMPUTED).
2. Between-rounds card and end-of-fight card
Between rounds (panel 560 x 360 at x 1264, y 160):
Header "END OF ROUND 3" in Bebas 36, with the two corner colours as bars.
Three columns: left fighter, stat, right fighter, in Plex Mono 22.
Rows: punches landed/thrown, landing percentage, power shots landed, jabs landed, knockdowns.
A judges' round score (10-9) only if a scoring model exists (NOT COMPUTED).
It stays 8 s after the bell, then collapses to a stats icon. The corner card (K72) owns the rest of the break, and it wins if the two overlap.
End of fight (panel 760 x 480, centred):
Appears 2 s after the final bell, matching the footer line.
Top: winner, method and round, for example "LARKIN · KO · ROUND 3 1:42".
Below: full-fight totals using the same stat rows.
Stays until the player presses CONTINUE.
Method wording follows the fight result model (NOT COMPUTED).
3. Keep, move or drop
Element	Ruling	Why
Old round clock box (top-left)	MOVE into the bug's clock block	one clock, where the viewer reads
Corner instruction line	KEEP, MOVE to a 28 px chip under the bug at y 1000, grey #BDB6A8, with a clipboard icon	it's the manager's order, not the viewer's, and it's no longer a second gold item
Speed buttons	KEEP, shrink to icons	they're controls, not broadcast content
"ROUND 1 LIVE" box in the top bar	DROP	the clock says it
Fighter names in the top bar	DROP	the bug carries them with corner colours
"LIVE ROUND" in the footer	DROP	the clock says it
"THE RESULT FOLLOWS THE FINAL BELL"	KEEP	it tells the player why no result shows
Self-argue on placement: I argued for the top-left, where the old clock sits and the eye already goes. I kept lower-left because the top is full with the title bar and speed buttons, and boxing bugs traditionally sit low.
4. Icons that replace words
Word	Icon	Tooltip (max 60 chars)
1X / 2X / 4X	one, two and three play triangles	"Normal speed" / "Double speed" / "Four times speed"
SIM TO RESULT	skip-forward bar	"Skip to the result."
Knockdown	filled red pip	"Knockdown. Counts toward the limit."
Cut	red droplet beside the name	"Cut. Can stop the fight." (NOT COMPUTED, needs a cut model)
Stamina	lightning bolt, shown only when low	"Stamina is low. Punches slow down." (threshold NOT COMPUTED)
Corner order	clipboard	"Your instruction for the next round."
Trunk and bar mismatch. The still shows green and blue trunks, but the bars are red and blue. Either change the trunks to red and blue, or colour each bar from its fighter's trunks. I recommend the bars follow the trunks.
Which fighter is which. Nothing tells the viewer who stands where. Bar colour beside the surname plus matching trunks fixes it.
NOT COMPUTED: the knockdown limit, the judges' scoring, the cut model, the stamina threshold and the big-shot rule.
Still wrong: nothing has been checked against the real top bar and footer heights or at 380 px.
1:23 AM

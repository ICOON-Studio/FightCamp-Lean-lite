/* PUNCHER'S CHANCE (the game's name; "Ring Switches" was a working name, retired S565) - WHICH VERSION IS RUNNING, AND WHAT CHANGED (S565, the owner: "maybe add a changelog with every fix
   showing which version we running"). One file, loaded by every page and by changelog.html.
   THE RULE: every change a player can see or feel on a page gets ONE line here, newest first, in plain words, and a new
   number: 0.<session>.<n> (n counts up inside the session). The top entry is the version the page shows beside the
   sound button. A measure that changed nothing on a page is not an entry. */
window.RS_CHANGES = [
  { v: '0.568.9', date: '2026-11-27', items: [
    'A hand of cards replaces clicking your boxer: two guard switches on top (lead arm and rear arm, High or Low), then your moves as cards - blue for the lead arm, red for the rear arm, green for the feet. Click a card or drag it onto a moment under the ring. Moves that cannot reach fold away under "Doesn’t reach", so the hand stays small when kicks and knees arrive. The old body view is still there with ?ui=body.'] },
  { v: '0.568.8', date: '2026-11-27', items: [
    'The strip lights up what you are choosing: open a hand or the feet, or point at one of its moves, and that part glows gold on the strip - its card, or its words in every moment (rear low, stay put). A pick flashes once and stays lit until you fight the beat.',
    'A back off at Long (no room to move) now says "stay put (no room)" on the strip, not "backed off".'] },
  { v: '0.568.7', date: '2026-11-27', items: [
    'On the strip, a moment with no action now reads in bold "Guarding", with your hands and "stay put" when you hold your ground, so every choice you made shows there.'] },
  { v: '0.568.6', date: '2026-11-27', items: [
    'The strip shows your whole boxer in each of the three moments: a moment with no action reads "guarding" with where your hands are and that your feet stay still, and an action card also lists your other hand and feet. Point at a slot to see what each held hand stops.'] },
  { v: '0.568.5', date: '2026-11-27', items: [
    'Play a local AI live: Gemma, a model running on this PC, waits on the match server. Open Play online, type your name, Find an opponent. It answers a beat in about 1.5 seconds. Add ?clock=5 to the address for the 5-second clock (the round clock stays off online: the server runs the rounds).'] },
  { v: '0.568.4', date: '2026-11-27', items: [
    'A round clock on the one-action page: 1 minute a round in real time, shown at the top. At 0 the bell rings - straight away if you are still choosing, or as soon as the beat being played ends. Think slowly and fewer beats get thrown. The Clock button switches both clocks off; any page can have it with ?round=60.'] },
  { v: '0.568.3', date: '2026-11-27', items: [
    'A decision clock on the one-action trial page (one.html): 5 seconds a beat, counted down on the Fight button; at 0 the beat is fought with what you chose. Switch it off with the Clock button at the top. Any page can have it with ?clock=5 in its address.'] },
  { v: '0.568.2', date: '2026-11-27', items: [
    'Your very first beat is guided: three short steps (a jab, your feet, fight), each lighting the one thing to click next. Shown once.'] },
  { v: '0.568.1', date: '2026-11-27', items: [
    'The range is named in big letters in the corner of the ring (LONG, MID, INSIDE), so you always see where you stand before you choose.'] },
  { v: '0.567.9', date: '2026-11-27', items: [
    'The strip under the ring has two sides now: your three moments on the left, his three on the right. His stay hidden until the beat is fought, then each one fills in as its moment plays, and every slot shows its result (lands, blocked, missed) at the instant the picture shows it. While you plan, his side shows what he did last beat, dimmed.' ] },
  { v: '0.567.8', date: '2026-11-27', items: [
    'Choosing a second move is clear now: after you pick a move the list of all your parts comes back, with the move in its row, so the next click is another hand or the feet. Each hand does one thing a beat, and the page says so.',
    'A move can be dragged from its list straight onto one of the three slots under the ring: it is chosen and put at that moment.',
    'The row of the part you just set lights up, and the feet card that means no step says so: Stay put (no step).' ] },
  { v: '0.567.7', date: '2026-11-27', items: [
    'A new page, Play online (online.html): type a name, find an opponent, and fight another player or an agent. Each beat you both choose before either sees the other.' ] },
  { v: '0.567.6', date: '2026-11-27', items: [
    'Every move name in the commentary is a link now: hover it for the facts of the card, click it to open that card (in your hand, or in his when the line is about him).' ] },
  { v: '0.567.5', date: '2026-11-27', items: [
    'Health, stamina, guard and ground are round gauges now, each with its icon and number: the lit arc is what is left, the gold part of stamina is what this beat will cost. A gauge that is low pulses.' ] },
  { v: '0.567.4', date: '2026-11-27', items: [
    'A new page, Famous exchanges (scene.html): four famous moments set with our switches and fought on the rules of the game itself - the counter right as he steps in, covering on the ropes, the feint that hides the right hand, the check hook. Each one then plays straight through.' ] },
  { v: '0.567.3', date: '2026-11-26', items: [
    'At the bell a new button, Replay round, plays the whole round again: every beat back to back with no planning pauses. Skip it at any time. It is there after the last round and after a stoppage too.' ] },
  { v: '0.567.2', date: '2026-11-26', items: [
    'His punches show the same three ranges when you mouse over one of his hands: lit where the punch reaches, framed where you both stand now.' ] },
  { v: '0.567.1', date: '2026-11-26', items: [
    'Every punch card now shows the three ranges (Inside, Mid, Long): the lit ones are where it reaches, the framed one is where you will be when it goes. Beside them its damage in red; its stamina cost stays in green.' ] },
  { v: '0.566.3', date: '2026-11-26', items: [
    'The dashed line from a limb to its panel no longer jiggles while the men bounce: it stays still, only the glow follows the limb.' ] },
  { v: '0.566.2', date: '2026-11-26', items: [
    'A held hand now says what it stops, in green under it (lead high: his jab and cross; lead low: his body punches; rear high: his hook and overhand; rear low: his uppercuts). Hover it for the whole rule.' ] },
  { v: '0.566.1', date: '2026-11-26', items: [
    'Under the ring: a strip with three numbered slots, one for each moment of the beat. Each card says what the move does and what it leaves open. Drag a card to another slot to change the order.',
    'A see-through blue copy of your boxer plays the moves you chose, in order, after every change and while the mouse is on the strip.',
    'The help box says in plain words how to choose moves: click a part of your boxer, then click the move.' ] },
  { v: '0.565.5', date: '2026-11-26', items: [
    'The game is called Puncher\'s chance on every page (it said Ring Switches).',
    'The comeback switch that carried the game\'s name by mistake is called "All in" and sits on its own trial page.' ] },
  { v: '0.565.4', date: '2026-11-26', items: [
    'Never still: while you plan, both men bounce lightly on the spot (feet where they stand, guard where it is); Fight stops it at once.' ] },
  { v: '0.565.3', date: '2026-11-26', items: [
    'Pick your moment: the opponent on that page now thinks ahead with a table made for the late step (it used the main page\'s).' ] },
  { v: '0.565.2', date: '2026-11-26', items: [
    'Every page: with three actions set, the last line under the ring ran off the bottom of the screen. The lines now sit in one row.',
    'Every page: this version number and the changelog.' ] },
  { v: '0.565.1', date: '2026-11-26', items: [
    'New page "Pick your moment": your step can come one moment later (a switch beside your order). Measured: the bouts stay balanced with it; a free wait anywhere did not.' ] },
  { v: '0.564.1', date: '2026-11-26', items: [
    'Inside is a real inside-fighting distance now (0.55 m, was 0.71 m): every picture at Inside was made again.',
    'Head moves and kicks keep the men at their distance at Long and Mid (43 jumps between pictures down to 8).' ] },
  { v: '0.562.1', date: '2026-11-25', items: [
    'The body view is the main page: point at a limb of your man to set it, at his to see what he can do.',
    'Punches, feints and the push off start and end where the men stand (33 jumps between pictures down to 2).',
    'Nothing is drawn on or near the fighters: readouts sit in the ring\'s corner badge and the side panels.' ] },
  { v: '0.561.1', date: '2026-11-25', items: [
    'A trial page with a comeback switch beside the clinch (now called "All in").',
    'Head movement page: its own pictures - the glove goes through the place the head was.' ] },
  { v: '0.559.1', date: '2026-11-24', items: [
    'Every picture is taken from your ring camera (one fixed camera, you in blue on the near side).' ] },
];
window.RS_VERSION = window.RS_CHANGES[0].v;
(function () { if (typeof document === 'undefined' || !document.getElementById) return;
  var put = function () { var b = document.getElementById('mute'); if (!b || !b.insertAdjacentHTML || document.getElementById('rsver')) return;
    b.insertAdjacentHTML('beforebegin', '<a id="rsver" href="changelog.html" target="_blank" rel="noopener" title="What changed in each version" style="margin-right:.6rem;font-size:.8rem;color:var(--muted,#9a9184);text-decoration:none;border-bottom:1px dotted currentColor">v' + window.RS_VERSION + '</a>'); };
  if (document.readyState === 'loading' && document.addEventListener) document.addEventListener('DOMContentLoaded', put); else put(); })();

/* RING SWITCHES - WHICH VERSION IS RUNNING, AND WHAT CHANGED (S565, the owner: "maybe add a changelog with every fix
   showing which version we running"). One file, loaded by every page and by changelog.html.
   THE RULE: every change a player can see or feel on a page gets ONE line here, newest first, in plain words, and a new
   number: 0.<session>.<n> (n counts up inside the session). The top entry is the version the page shows beside the
   sound button. A measure that changed nothing on a page is not an entry. */
window.RS_CHANGES = [
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
    'New page "Puncher\'s chance": the comeback switch beside the clinch.',
    'Head movement page: its own pictures - the glove goes through the place the head was.' ] },
  { v: '0.559.1', date: '2026-11-24', items: [
    'Every picture is taken from your ring camera (one fixed camera, you in blue on the near side).' ] },
];
window.RS_VERSION = window.RS_CHANGES[0].v;
(function () { if (typeof document === 'undefined' || !document.getElementById) return;
  var put = function () { var b = document.getElementById('mute'); if (!b || !b.insertAdjacentHTML || document.getElementById('rsver')) return;
    b.insertAdjacentHTML('beforebegin', '<a id="rsver" href="changelog.html" target="_blank" rel="noopener" title="What changed in each version" style="margin-right:.6rem;font-size:.8rem;color:var(--muted,#9a9184);text-decoration:none;border-bottom:1px dotted currentColor">v' + window.RS_VERSION + '</a>'); };
  if (document.readyState === 'loading' && document.addEventListener) document.addEventListener('DOMContentLoaded', put); else put(); })();

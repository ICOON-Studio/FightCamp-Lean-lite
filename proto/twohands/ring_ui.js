// RINGUI1 (S559): two things the owner asked for, on top of the page (the rules are not touched):
// 1. "can you make those ranges geometrically correct in comparison to the ground distance and display that to the player
//    with visual effect": the range strip's three equal pills are replaced by plates ON THE FLOOR between the men's front
//    feet, each as long as the real gap at that range. Measured on the pictures (S559, img/anim/blue_both_high_high*_6):
//    the front toes stand 113 px apart at Long, 46 at Mid and meet Inside, in the 480 px picture; a range step is the step
//    take's 0.355 m and closes 67 px, so 189 px a metre. The plate of the range they are at glows; hover a switch and the
//    plates it reaches light green, the others red. A range change flashes the new plate.
// 2. "make the commentators react to each beat": after every beat one of the three (our own crew on the desk picture:
//    Rita Vance calls it, Hank Brody explains it, Leo Marsh feels it) says one line about the beat's biggest moment, and
//    that commentator lights up on the desk.
(() => {
  const st = $('stage'), im = $('pic'), tell = document.querySelector('.tell');
  // ---- 0. RENDERFIT1 (S559): the owner's ring camera. Every picture is now in RING coordinates (one fixed camera,
  // tools/pics2d_camera.json), so a picture is drawn SLID along the red -> blue line by where the men really stand:
  // a hold, a guard or a blue run is made with red on his spot (blue stood in), so it slides by red's metres in;
  // a red run (his punch, his step) is made with blue on his spot, so it slides back by blue's metres in. The page keeps
  // the two counts (steps of 0.355 m) from the step runs it plays; red's + blue's = the range's (Long 0, Mid 1, Inside 2).
  // Without it a red step snapped a whole step (RINGCAM1: 87 px of the render, 54 of the page picture).
  // The ring itself (img/ring_bg.webp, tools/pics2d_ring_bg.gd: the same camera, 4 times as wide) does NOT slide.
  const STEP_M = 0.355; let CAM = null, redIn = 0, blueIn = 0, SX = 0, SY = 0;
  fetch('img/anim/frames.json').then((r) => r.json()).then((j) => { CAM = j.camera || null; slide(); }).catch(() => {});
  const css = document.createElement('style');
  css.textContent = '.stage{background:#0f1013}.stage:before,.stage:after{display:none}.stage img#ringbg{z-index:0;filter:none;pointer-events:none}';
  document.head.appendChild(css);
  const bg = document.createElement('img'); bg.id = 'ringbg'; bg.alt = ''; bg.src = 'img/ring_bg.webp'; st.insertBefore(bg, st.firstChild);
  const metresOf = (src) => { const f = (src || '').split('/').pop(); return (/^red_/.test(f) ? -blueIn : redIn) * STEP_M; };
  function slide() { if (!CAM || !CAM.axis_px) { SX = SY = 0; im.style.translate = ''; return; }
    const k = st.clientHeight * 1.26 / (CAM.render_px || 768), m = metresOf(im.getAttribute('src'));
    SX = -m * CAM.axis_px[0] * k; SY = m * CAM.axis_px[1] * k;   /* the picture is drawn mirrored: its +x is the screen's -x */
    im.style.translate = SX || SY ? `${SX.toFixed(1)}px ${SY.toFixed(1)}px` : ''; }
  const holdSlide = () => { if (!CAM || !CAM.axis_px) return [0, 0]; const k = st.clientHeight * 1.26 / (CAM.render_px || 768), m = redIn * STEP_M; return [-m * CAM.axis_px[0] * k, m * CAM.axis_px[1] * k]; };
  new MutationObserver(slide).observe(im, { attributes: true, attributeFilter: ['src'] });   /* runs before the frame is painted */
  const fit = () => { const t = 3 - (range || 3); redIn = Math.max(-2, Math.min(2, redIn)); blueIn = t - redIn; };   /* the range is the truth: blue takes up what the counts missed */
  const run0 = playRun; playRun = function (run, big, onHit, done, cut) {
    const m = /^(red|blue)_(step_in|back_off)/.exec(run || ''), move = () => { if (!m) return; const d = m[2] === 'step_in' ? 1 : -1; if (m[1] === 'red') redIn += d; else blueIn += d; };
    const ok = run0(run, big, onHit, () => { move(); slide(); done(); }, cut); if (!ok) move(); return ok; };
  const hit0 = hitAt; hitAt = function (run) { const a = hit0(run); return a ? [a[0] + SX, a[1] + SY] : a; };   /* the burst sits on the slid glove */
  const setup0 = setup; setup = function () { redIn = blueIn = 0; setup0(); slide(); };
  const bell0 = bell; bell = function () { redIn = blueIn = 0; bell0(); slide(); };   /* a new round starts at Long, both on their spots */
  const plan0r = plan; plan = function () { fit(); plan0r(); slide(); };
  window.ringSlide = () => ({ redIn, blueIn, range, sx: SX, sy: SY, pic: (im.getAttribute('src') || '').split('/').pop() });   // read by the browser check
  // ---- 1. the distance on the floor (S559 v2, owner on the nested plates: "idonot understand this ,it is not symmetrical"):
  // ONE bar between the two men's front toes at the range they are at, ticks at both toes, its length the real gap, the
  // label in words. A range change slides it and flashes. Hover a switch: green if it reaches at this range, red if not.
  // RENDERFIT1 (S559) re-measured on the owner's camera (raised 31 deg, 3.149 m wide; blue_both_high_high*_6, the lead
  // boots' inner ends): red's front toe stays at 231 (red on his spot), blue's comes in one step (0.355 m = 54 px) a range;
  // Inside the lead boots pass each other (they stand at different depths), so the gap is 0. 152.4 px a metre (the
  // camera's axis_px 243.85 of the 768 render). The front toes sit at y 318 (red's) and 331 (blue's): the bar at 324.
  const TOES = { 3: [231, 318], 2: [231, 264], 1: [231, 231] };   // [red front toe, blue front toe], x in the 480 px picture
  const PX_M = 152.4, FLOOR = 324 / 480;
  const ruler = document.createElement('div'); ruler.id = 'ruler'; st.appendChild(ruler);
  ruler.innerHTML = '<div class="gap"><i></i><i></i></div><div class="plabel"></div>';
  const X = (u) => st.clientWidth / 2 + (0.5 - u) * st.clientHeight * 1.26 + holdSlide()[0];   /* RENDERFIT1: u in square-picture widths from its middle (a wide picture has the same middle and scale); TOES are the hold pictures', so the bar takes the HOLD's slide (red's metres in) whatever picture is up */
  const cm = (r) => Math.max(0, Math.round((TOES[r][1] - TOES[r][0]) / PX_M * 100));
  let shown = 0, hoverReach = null, hoverName = '';
  function place() { if (!st.clientHeight || !range) return; const y = st.clientHeight * -0.17 + FLOOR * st.clientHeight * 1.26 + holdSlide()[1];
    const x1 = X(TOES[range][1] / 480), x2 = X(TOES[range][0] / 480), w = Math.max(18, Math.abs(x2 - x1)), mid = (x1 + x2) / 2, gap = ruler.querySelector('.gap');
    gap.style.left = (mid - w / 2) + 'px'; gap.style.width = w + 'px'; gap.style.top = (y - 4) + 'px';
    const reach = hoverReach ? hoverReach.includes(range) : null; gap.className = 'gap' + (reach === true ? ' ok' : reach === false ? ' no' : '');
    const lab = ruler.querySelector('.plabel'); lab.style.top = (y + (range === 1 ? 46 : 12)) + 'px';   /* S560 (owner C515: no overlaps on the fighters): UNDER the bar, on the canvas in front of the boots - above it the words sat on the shins and the boots; Inside the boots pass each other, so lower still */ lab.style.left = mid + 'px';
    lab.innerHTML = hoverReach ? `${hoverName} ${reach ? 'reaches' : '<u>does not reach</u>'} at ${RNG[range]}` : `<b>${RNG[range]}</b> ${range === 1 ? 'toe to toe' : cm(range) + ' cm'}`;
    if (range !== shown) { if (shown) { gap.classList.remove('flash'); void gap.offsetWidth; gap.classList.add('flash'); } shown = range; } }
  document.addEventListener('mouseover', (e) => { const b = e.target.closest ? e.target.closest('.sw') : null, g = b && b.dataset.g, id = b && b.dataset.id;
    const a = !b ? null : g === 'lead' || g === 'rear' ? (id === 'high' || id === 'low' ? null : ACT[id]) : g === 'feet' ? ACT[id] : null;   // a hand's 'low' hold is not the low kick
    const r = a && a.reach ? a.reach : null; if (String(r) !== String(hoverReach)) { hoverReach = r; hoverName = a ? a.n : ''; place(); } });
  const draw0 = draw; draw = function () { draw0(); place(); };
  addEventListener('resize', place); im.addEventListener('load', place);
  // A picture that is not on disk (the kicks have none yet) must never leave the ring empty (owner S559: "both fighters
  // disappeared when istarted the beat"): show the men held at the range they are at instead.
  im.addEventListener('error', () => { const hold = `img/anim/blue_both_high_high${range === 3 ? '' : '_r' + range}_6.webp`; if (!im.src.endsWith(hold)) im.src = hold; });
  // ---- 2. the commentators
  const CREW = [{ n: 'Rita Vance', at: 20 }, { n: 'Hank Brody', at: 50 }, { n: 'Leo Marsh', at: 80 }];   // where each sits on the desk picture (%)
  const light = document.createElement('div'); light.id = 'desklight'; tell.appendChild(light);
  const call = document.createElement('div'); call.id = 'call'; tell.appendChild(call);
  let liveEv = null, said = 0;
  const res0 = resolve; resolve = function (S, P2) { const ev = res0(S, P2); if (S.f === F) liveEv = ev; return ev; };   // only the beat that is fought, never the machine's look-ahead
  const nm = (k) => (k === 0 ? 'Blue' : OPP.n.replace(/^The /, 'the '));
  const pick = (arr) => arr[said++ % arr.length];
  function line(ev) { const hits = ev.filter((e) => e.t === 'hit'), blocks = ev.filter((e) => e.t === 'block'), miss = ev.filter((e) => e.t === 'miss');
    const down = ev.find((e) => e.down), big = hits.slice().sort((a, b) => b.dmg - a.dmg)[0];
    if (down) return [2, pick([`DOWN GOES ${nm(1 - down.k).toUpperCase()}! That ${down.a.toLowerCase()} came out of nowhere!`, `Oh, he's hurt! ${nm(down.k)} puts him on the canvas with the ${down.a.toLowerCase()}!`])];
    if (ev.some((e) => e.t === 'clinch')) return [0, pick([`They're tied up. Nothing lands, and the referee breaks them at Mid.`, `Into the clinch. A breather for the man who grabbed.`])];
    const caught = blocks.find((e) => /CAUGHT/.test(e.o || '')); if (caught) return [1, `${nm(1 - caught.k)} catches the ${caught.a.toLowerCase()}! You cannot leave a leg hanging out there.`];
    const chk = blocks.find((e) => /checked/.test(e.o || '')); if (chk) return [1, pick([`Checked! ${nm(1 - chk.k)} lifted the shin and ${nm(chk.k)} pays for that low kick.`, `Shin on shin. That one hurt the kicker more.`])];
    if (big && big.dmg >= 4) return [2, pick([`What a ${big.a.toLowerCase()} from ${nm(big.k)}! ${big.dmg} off the health bar!`, `Oh, he felt THAT! ${nm(big.k)} lands the ${big.a.toLowerCase()} clean.`])];
    const ctr = hits.find((e) => /as a counter/.test(e.o || '')); if (ctr) return [1, `That's the counter. ${nm(1 - ctr.k)} came up empty and ${nm(ctr.k)} made him pay.`];
    const feint = hits.find((e) => /feint drew/.test(e.o || '')); if (feint) return [1, `He bit on the feint, and the ${feint.a.toLowerCase()} walked right in.`];
    const limp = hits.find((e) => /LIMPING/.test(e.o || '')); if (limp) return [2, `${nm(1 - limp.k)} is limping! Those low kicks are adding up.`];
    const dropped = hits.find((e) => /dropped as/.test(e.o || '')); if (dropped) return [1, `He kicked and dropped the rear hand, and ${nm(dropped.k)} was waiting for it.`];
    if (hits.length >= 2 && hits.some((e) => e.k === 0) && hits.some((e) => e.k === 1)) return [2, pick([`They're trading in there! Both men landing.`, `Toe to toe! Neither one wants to give an inch.`])];
    if (big) return [0, pick([`${nm(big.k)} lands the ${big.a.toLowerCase()}.`, `Clean ${big.a.toLowerCase()} from ${nm(big.k)}, ${big.dmg} off.`])];
    if (blocks.length) { const b = blocks[0]; return [1, pick([`Good defence. ${nm(1 - b.k)} had the hand right where the ${b.a.toLowerCase()} was going.`, `Blocked. ${nm(b.k)} is going to have to find another way in.`])]; }
    if (miss.length) { const m = miss[0]; return [0, /short/.test(m.o || '') ? `${nm(m.k)} falls short with the ${m.a.toLowerCase()}. Wrong range for it.` : `Too close for the ${m.a.toLowerCase()}, smothered.`]; }
    if (ev.some((e) => e.t === 'range')) return [0, pick([`Footwork now. They're at ${RNG[range]}.`, `Feeling each other out, ${RNG[range]} range.`])];
    return [2, pick([`Both men waiting. Somebody has to let his hands go.`, `A lot of looking, not a lot of punching.`])]; }
  function say(who, text) { call.innerHTML = `<b>${CREW[who].n}</b> ${text}`; call.className = 'w' + who + ' on'; light.style.setProperty('--x', CREW[who].at + '%'); light.className = 'on'; }
  function quiet() { call.className = ''; light.className = ''; }
  const plan1 = plan; plan = function () { plan1(); if (liveEv) { const [w, t] = line(liveEv); liveEv = null; say(w, t); } };
  const go1 = go; go = function () { quiet(); return go1(); };
  const bell1 = bell; bell = function () { const ev = liveEv; liveEv = null; bell1(); const c = cards[cards.length - 1]; if (c) say(1, `End of the round. I have it ${c[0]}-${c[1]}${c[0] === c[1] ? ', dead even' : c[0] > c[1] ? ' for Blue' : ' for ' + nm(1)}. ${ev && ev.some((e) => e.down) ? 'And that knockdown was the difference.' : 'Corners have work to do.'}`); };
  const over1 = over; over = function (text) { liveEv = null; over1(text); say(2, /YOU WIN/.test(text) ? `It's over! Blue gets it done tonight!` : /DRAW/.test(text) ? `A draw! Nobody goes home happy.` : `It's over. ${nm(1)} takes this one.`); };
  place();
})();

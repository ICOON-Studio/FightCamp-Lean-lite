// HAND_UI (S568, owner: "we need to fix the limb selection it is kind of confusing for the player what other option do we
// have", then "you need to take consideration tht we will add a lot more options with kicks etc" and "i like the B"):
// THE HAND OF CARDS. The page's own move buttons (#board .sw - every rule, cost, reach and drag onto the strip stays theirs)
// are laid out as a hand instead of being picked by clicking a limb of the boxer:
//  - the GUARD bar on top: lead arm High / Low, rear arm High / Low (posture, not a card: it takes no moment);
//  - the CARDS: colour = the limb that plays it (blue lead arm, red rear arm, green legs and head - steps, kicks, head moves);
//    a limb does one thing a beat, so a second card of the same colour replaces the first (the page's own rule);
//  - what does not reach at this range folds away under "Doesn't reach here (n)", so the hand stays small as kicks, knees
//    and elbows are added.
// Click a card, or drag it onto a moment of the strip. ?ui=body brings back the body view (body_ui.js) for comparison.
(function () {
  if (/[?&]ui=body\b/.test(location.search)) return;
  const COL = { lead: '#378ADD', rear: '#D85A30', feet: '#1D9E75', clinch: '#888780' };
  let farOpen = false;
  /* S568 (owner: "both hands have the same options"): the two arms' High / Low block different punches - each button says which (the page's own COVER / THREAT tables, so kicks pages stay right) */
  const stops = (g, h) => { try { return 'stops ' + THREAT[COVER[h][g === 'lead' ? 0 : 1]].replace(/^His /, ''); } catch (e) { return ''; } };
  const css = document.createElement('style');
  css.textContent = 'body.ui-cards #side>.hd,body.ui-cards #sum,body.ui-cards #his,body.ui-cards #board .grp{display:none!important}' +
    'body.ui-cards #board{display:flex!important;flex-direction:column;gap:.25rem}' +
    '#guardbar{display:grid;grid-template-columns:auto 1fr 1fr;gap:.2rem .4rem;align-items:center;font-size:.8rem}#guardbar .gl{color:var(--muted);white-space:nowrap}' +
    '#guardbar .sw{display:flex!important;justify-content:center;min-height:1.7rem;padding:.1rem .3rem}#guardbar .sw .c,#guardbar .sw .ic,#guardbar .sw .n,#guardbar .sw .flag{display:none}#guardbar .sw{min-height:2.35rem!important}#guardbar .sw b{display:flex!important;flex-direction:column;align-items:center;line-height:1.1;white-space:normal!important;overflow:visible!important;text-overflow:clip!important;max-height:none!important}#guardbar .sw b small{display:block!important}#guardbar .sw b small{font-weight:400;font-size:.68rem;color:#d8cfc2}' +
    '#cards,#farcards{display:grid;grid-template-columns:1fr 1fr;gap:.25rem}' +
    '#cards .sw,#farcards .sw{display:grid!important;min-height:2.25rem;padding:.1rem .45rem;border-top-width:4px;align-content:center}#cards .sw b,#farcards .sw b{font-size:.86rem;line-height:1.1}' +
    '#cards .rg i:not(.y),#farcards .rg i:not(.y){display:none}#cards .rg i,#farcards .rg i{padding:0 .22rem;font-size:.62rem}#cards .rg em,#farcards .rg em{font-size:.64rem;white-space:nowrap}' +   /* on a card: only the ranges it reaches, so the row fits */
    '#farbox summary{cursor:pointer;color:var(--muted);font-size:.82rem;margin:.2rem 0 .35rem}#farbox .sw{opacity:.55}' +
    '#handhd{font-size:.78rem;color:var(--muted);letter-spacing:.06em;text-transform:uppercase}#handhd span{color:#d8cfc2}';
  document.head.appendChild(css);
  function lay() { const brd = document.getElementById('board'); if (!brd || phase !== 'plan') return; document.body.classList.add('ui-cards');
    const all = [...brd.querySelectorAll('.sw')]; if (!all.length) return;
    for (const id of ['handhd', 'guardbar', 'cards', 'farbox', 'handgrid']) { const old = document.getElementById(id); if (old) old.remove(); }
    const hd = document.createElement('div'); hd.id = 'handhd'; hd.textContent = 'Your hand'; hd.title = 'Click a card, or drag it onto a moment under the ring. The guard switches take no moment.';
    const gb = document.createElement('div'); gb.id = 'guardbar';
    for (const g of ['lead', 'rear']) { const lab = document.createElement('span'); lab.className = 'gl'; lab.textContent = g === 'lead' ? 'Lead arm guard' : 'Rear arm guard'; gb.appendChild(lab);
      for (const h of ['high', 'low']) { const b = all.find((x) => x.dataset.g === g && x.dataset.id === h); if (b) { b.querySelector('b').innerHTML = `${h === 'high' ? 'High' : 'Low'}<small>${stops(g, h)}</small>`; gb.appendChild(b); } } }
    const cards = document.createElement('div'); cards.id = 'cards'; const far = document.createElement('div'); far.id = 'farcards';
    for (const b of all) { if (b.classList.contains('home')) continue; b.style.borderTopColor = COL[b.dataset.g] || COL.clinch; (b.classList.contains('far') || (b.dataset.g === 'clinch' && range > 1) ? far : cards).appendChild(b); }   /* the clinch works Inside only */
    brd.prepend(hd, gb, cards);
    { const hb = cards.querySelector('.sw[data-g="feet"][data-id="hold"]'); if (hb && P.feet === 'hold' && !P.clinch && !hb.querySelector('.n')) hb.insertAdjacentHTML('beforeend', `<span class="n">${P.ord.length + 1}</span>`); }   /* S569: Stay put carries the number of its strip slot, like every picked card */
    if (far.children.length) { const fb = document.createElement('details'); fb.id = 'farbox'; fb.open = farOpen; fb.innerHTML = `<summary>Doesn't reach (${far.children.length})</summary>`; fb.appendChild(far); fb.ontoggle = () => { farOpen = fb.open; }; brd.appendChild(fb); } }
  function init() { const plan0 = plan; plan = function () { plan0(); lay(); }; if (phase === 'plan') lay(); }
  if (document.readyState === 'complete') init(); else addEventListener('load', init);
  /* S569 PICTURE CARDS (owner: "remove the buttons and replace with the decribed action with a single fighter , do not
     draw both of them , it has to be like a card and make them smaller so all can fit"; "make the cards loop their
     animaitons while thei are on the panel and of course remove the animation from the tooltip and use it as descriptor"):
     every move card in the hand is a small picture card that loops its own frame run - your boxer (blue) doing it at the
     range you stand at (out of reach: its nearest range); the tooltip is the page's own words. Until runs of blue alone
     exist, the picture is cropped on blue (img/anim/card_crop.json, tools/card_crop.py) and fades out before the other man. */
  let CROP = {}; fetch('img/anim/card_crop.json').then((r) => r.json()).then((j) => { CROP = j || {}; }).catch(() => {});
  const pcss = document.createElement('style');
  pcss.textContent = '#handgrid{display:grid;grid-template-columns:repeat(4,1fr);gap:.22rem}#handgrid>#cards,#handgrid>#farcards{display:contents!important}#farcards .sw.pc{border-style:dashed}' +
    '#cards .sw.pc,#farcards .sw.pc{display:flex!important;flex-direction:column;align-items:stretch;padding:0!important;min-height:0!important;height:4.85rem;border-radius:.45rem;overflow:hidden;position:relative}.sw.pc>*:not(.cpic):not(b):not(.c):not(.rg):not(.n){display:none!important}' +
    '.sw.pc .cpic{position:relative;height:3.25rem;overflow:hidden;background:radial-gradient(ellipse at 45% 65%,#2b3550,#15161b)}' +
    '.sw.pc .cpic canvas{position:absolute;pointer-events:none}' +
    '.sw.pc>b{font-size:.66rem!important;line-height:1.05;padding:.1rem .25rem 0;white-space:nowrap!important;overflow:hidden!important;text-overflow:ellipsis!important;max-height:none!important}' +
    '.sw.pc .ic,.sw.pc .rg i:not(.y){display:none!important}.sw.pc .c{position:absolute;top:.1rem;right:.2rem;font-size:.66rem;background:#000a;border-radius:.3rem;padding:0 .18rem;z-index:2}' +
    '.sw.pc .rg{padding:0 .2rem .08rem;font-size:.52rem;display:flex;gap:0 .15rem;white-space:nowrap;overflow:hidden}.sw.pc .rg em{position:absolute;left:.2rem;top:2.35rem;font-size:.6rem!important;background:#000b;border-radius:.3rem;padding:0 .2rem;z-index:2}.sw.pc .rg i{padding:0 .12rem!important;font-size:.52rem!important}' +
    '#farlab{font-size:.7rem;color:var(--muted);margin:.2rem 0 .05rem}#farcards .sw.pc{opacity:.5}';
  document.head.appendChild(pcss);
  const suf = (r) => (r === 3 ? '' : '_r' + r), has = (n) => typeof ANIM !== 'undefined' && ANIM[n] && ANIM[n].files && ANIM[n].files.length;
  const first = (...ns) => ns.find(has) || '';
  function runFor(b) { const g = b.dataset.g, id = b.dataset.id, r = typeof range === 'number' ? range : 3;
    if (g === 'clinch') return first('blue_clinch');
    if (g === 'feet') { if (id === 'in' || id === 'slipin') { const k = id === 'in' ? 'step_in' : 'slip_in'; return r > 1 ? first(`blue_${k}_r${r - 1}`) : first(`blue_${k}_r2`); }
      if (id === 'back') return first(r === 3 ? 'blue_back_off' : `blue_back_off_r${r + 1}`); if (id === 'hold') return first(`blue_guard_bob${suf(r)}`, `blue_guard${suf(r)}`); return ''; }
    if (id === 'feint') return first(`blue_feint${suf(r)}`, 'blue_feint'); if (id === 'push') return first('blue_push');
    const a = typeof ACT !== 'undefined' && ACT[id]; if (!a || !a.reach) return '';
    const p = a.run || a.pic, at = a.reach.includes(r) ? r : a.reach.reduce((x, y) => (Math.abs(y - r) < Math.abs(x - r) ? y : x));
    return first(`blue_${p}_landed${suf(at)}`, `blue_${p}_landed`, `blue_${p}_blocked${suf(at)}`); }
  const S = 0.18;   // a 480 px frame drawn at 106 px: the whole man fits the card's height
  /* ONE MAN: each frame is drawn small once and cached; on the other man's side of blue (unmirrored: x left of blue's
     shorts) only blue's own colours stay - his blue shorts and gloves, pale skin, white wraps - so the red man's brown skin,
     red gloves and shorts and grey boots are cut away; blue's own reaching arm keeps its glove and skin. */
  const FR = new Map();
  function blueOnly(file, cx, k) { const key = file + '@' + k; if (FR.has(key)) return FR.get(key);
    const cv = document.createElement('canvas'); FR.set(key, cv); const im = new Image();
    im.onload = () => { const w = Math.round(im.naturalWidth * k), h = Math.round(im.naturalHeight * k); cv.width = w; cv.height = h; const x = cv.getContext('2d'); x.translate(w, 0); x.scale(-1, 1); x.drawImage(im, 0, 0, w, h); x.setTransform(1, 0, 0, 1, 0, 0);   /* drawn mirrored, as the ring shows him */
      const d = x.getImageData(0, 0, w, h), p = d.data, cut = w - Math.round(cx * k) + 3;   /* mirrored: the other man is RIGHT of blue */
      for (let yy = 0; yy < h; yy++) for (let xx = Math.max(0, cut); xx < w; xx++) { const o = (yy * w + xx) * 4, r = p[o], g = p[o + 1], b = p[o + 2];
        const keep = (b > r + 30 && b > g) || (r > 165 && g > 120 && b > 85 && r - b < 120 && !(r > 205 && g > 205 && b > 205));   /* white wraps out: at this size they were the red man's specks */
        if (!keep || xx > cut + Math.round(122 * k)) p[o + 3] = 0; }   /* past his longest reach nothing of his is left */
      x.putImageData(d, 0, 0); cv.dataset.ok = '1'; };
    im.src = 'img/anim/' + file; return cv; }
  const loops = [];
  function picCards() { loops.length = 0;
    for (const b of document.querySelectorAll('#cards .sw, #farcards .sw')) { const run = runFor(b); if (!run) continue;
      b.classList.add('pc'); let box = b.querySelector('.cpic');
      if (!box) { box = document.createElement('div'); box.className = 'cpic'; b.prepend(box); }
      const R = ANIM[run], c = CROP[run] || [300, 200, 480], fw = c[2] || 480, k = S * 480 / fw, W = b.clientWidth || 98;
      for (const f of R.files) blueOnly(f, c[0], k);
      loops.push({ box, R, c, k, W, i: 0, next: 0 }); } }
  setInterval(() => { const now = performance.now(); for (const L of loops) { if (now < L.next) continue; const n = L.R.files.length, cv = blueOnly(L.R.files[L.i], L.c[0], L.k);
      if (cv.dataset.ok) { if (L.box.firstChild !== cv) { L.box.replaceChildren(cv); } cv.style.left = Math.round(L.W * 0.26 - ((L.c[2] || 480) - L.c[0]) * L.k) + 'px'; cv.style.top = Math.round(3 - 84 * L.k) + 'px'; }
      const w = L.i + 1 < n ? Math.max(60, Math.min(260, (L.R.offs ? L.R.offs[L.i + 1] - L.R.offs[L.i] : 0.08) * 1000)) : 650; L.i = (L.i + 1) % n; L.next = now + w; } }, 40);
  const lay0 = lay; lay = function () { lay0(); const fb = document.getElementById('farbox');
    { const cards = document.getElementById('cards'); if (cards) { const g = document.createElement('div'); g.id = 'handgrid'; cards.before(g); g.appendChild(cards); if (fb) { const far = fb.querySelector('#farcards'); fb.remove(); if (far) g.appendChild(far); } } }   /* all cards in ONE grid, small: no fold; the ones that do not reach here are dimmed at the end */
    picCards(); if (!Object.keys(CROP).length || !has('blue_guard')) setTimeout(() => { if (phase === 'plan') picCards(); }, 900); };
  window.picCardState = () => [...document.querySelectorAll('.sw.pc')].map((b) => b.dataset.g + ':' + b.dataset.id + '=' + (b.querySelector('.cpic canvas') ? 'canvas' : 'none'));   /* read by the browser check */
  window.handState = () => ({ cards: [...document.querySelectorAll('#cards .sw')].map((b) => b.dataset.g + ':' + b.dataset.id), far: [...document.querySelectorAll('#farcards .sw')].map((b) => b.dataset.g + ':' + b.dataset.id), guard: [...document.querySelectorAll('#guardbar .sw')].map((b) => b.dataset.g + ':' + b.dataset.id + (b.classList.contains('on') ? '*' : '')) });
})();

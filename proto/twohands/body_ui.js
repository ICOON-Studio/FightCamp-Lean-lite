// BODYUI1 (S559) - the owner's idea, built as a toy on a copy of the page (body.html; the rules are order.html's, untouched):
// "what if we map the available options for the player (cards, switches) on the opponents body and your own fighters body.
// Lets say i move my mouse on the left hand of my fighter and the available switches appear like tooltip. if i click the same
// hand the tooltip stays and i can make my selection ... then that selection goes into a strip ... decides and explains the order"
// Hover a glove, the boots or the body of YOUR man = that part's switches; click = they stay; a pick goes into the order strip,
// which says in words what each moment does. Hover HIS glove = what that hand did in his last beats and what it shuts.
// The spots follow the picture: each time a picture is shown, the gloves and boots are found by their colour.
(() => {
  const stage = $('stage'), im = $('pic'), brd = $('board');
  const layer = document.createElement('div'); layer.id = 'spots'; stage.appendChild(layer);
  let pinned = null, hover = null, hideT = 0, spots = {};
  const SPOT = { lead: 'Lead hand', rear: 'Rear hand', feet: 'Feet', clinch: 'Clinch', hlead: 'His lead', hrear: 'His rear' };
  // ---- find the parts on the picture (the picture is 480x480, drawn mirrored: blue = you on the left)
  const cv = document.createElement('canvas'), cx = cv.getContext('2d', { willReadFrequently: true });
  function find() {
    if (!im.naturalWidth) return null; const w = 160, h = 160; cv.width = w; cv.height = h;
    try { cx.clearRect(0, 0, w, h); cx.drawImage(im, 0, 0, w, h); } catch (e) { return null; }
    let d; try { d = cx.getImageData(0, 0, w, h).data; } catch (e) { return null; }
    const blueG = [], redG = [], boots = [], shorts = [];
    for (let y = 0; y < h; y++) for (let x = 0; x < w; x++) { const i = (y * w + x) * 4, r = d[i], g = d[i + 1], b = d[i + 2], a = d[i + 3]; if (a < 128) continue;
      if (y < h * 0.5 && b > 120 && b > r * 1.7 && b > g * 1.35) blueG.push([x, y]);
      else if (y < h * 0.5 && r > 140 && r > g * 2.2 && r > b * 2.2) redG.push([x, y]);
      else if (y > h * 0.74 && r > 60 && r > g * 2 && r > b * 2) boots.push([x, y]);
      else if (y >= h * 0.5 && y < h * 0.7 && b > 120 && b > r * 1.7 && b > g * 1.35) shorts.push([x, y]); }
    const two = (pts, leadIsLeft) => { if (pts.length < 6) return null; let xs = pts.map((p) => p[0]); let a = pts[xs.indexOf(Math.min(...xs))], b = pts[xs.indexOf(Math.max(...xs))];
      for (let k = 0; k < 6; k++) { const A = [], B = []; for (const p of pts) ((p[0] - a[0]) ** 2 + (p[1] - a[1]) ** 2 <= (p[0] - b[0]) ** 2 + (p[1] - b[1]) ** 2 ? A : B).push(p);
        const m = (s, o) => (s.length ? [s.reduce((t, p) => t + p[0], 0) / s.length, s.reduce((t, p) => t + p[1], 0) / s.length] : o); a = m(A, a); b = m(B, b); }
      return leadIsLeft ? { lead: a, rear: b } : { lead: b, rear: a }; };
    const mean = (pts) => (pts.length ? [pts.reduce((t, p) => t + p[0], 0) / pts.length, pts.reduce((t, p) => t + p[1], 0) / pts.length] : null);
    // in the file blue stands on the right facing left, so his lead glove is the LEFT one; red faces right, his lead is the RIGHT one
    const B = two(blueG, true), R = two(redG, false), ft = mean(boots), sh = mean(shorts), u = (p) => p && [p[0] / w, p[1] / h];
    return { lead: B && u(B.lead), rear: B && u(B.rear), hlead: R && u(R.lead), hrear: R && u(R.rear), feet: u(ft), clinch: sh ? [sh[0] / w, 0.37] : null }; }
  const toStage = (p) => { const H = stage.clientHeight * 1.26, W = H * (im.naturalWidth / im.naturalHeight || 1); return [stage.clientWidth / 2 + (0.5 - p[0]) * W, stage.clientHeight * -0.17 + p[1] * H]; };
  // ---- the spots
  function place() { if (phase !== 'plan') { layer.innerHTML = ''; spots = {}; return; } const f = find(); if (!f) return;
    for (const k of Object.keys(SPOT)) { let el = spots[k]; if (!f[k]) { if (el) el.style.display = 'none'; continue; }
      if (!el) { el = spots[k] = document.createElement('button'); el.className = 'spot ' + (k[0] === 'h' ? 'his' : 'mine') + ' s-' + k; el.dataset.k = k; layer.appendChild(el);
        el.onmouseenter = () => open(k, false); el.onmouseleave = () => leave(); el.onclick = (e) => { e.stopPropagation(); if (k[0] === 'h') return open(k); pinned = pinned === k ? null : k; if (pinned) open(k, true); else close(); mark(); }; }
      let [x, y] = toStage(f[k]); if (k === 'lead' || k === 'rear') { const o = f.lead && f.rear && Math.hypot(f.lead[0] - f.rear[0], f.lead[1] - f.rear[1]) < 0.05 ? (k === 'lead' ? 11 : -11) : 0; x += o; }   // gloves on top of each other: side by side
      if (k === 'hlead' || k === 'hrear') { const o = f.hlead && f.hrear && Math.hypot(f.hlead[0] - f.hrear[0], f.hlead[1] - f.hrear[1]) < 0.05 ? (k === 'hlead' ? -11 : 11) : 0; x += o; }
      el.style.display = ''; el.style.left = x + 'px'; el.style.top = y + 'px'; }
    mark(); }
  function mark() { const first = round === 1 && beat === 0 && !pinned && !P.lead && !P.rear && P.feet === 'hold';
    for (const k in spots) { const el = spots[k], sl = k === 'clinch' ? null : k; let lab = SPOT[k], n = '';
      if (sl === 'lead' || sl === 'rear') { if (P[sl]) { lab = ACT[P[sl]].n; n = P.ord.indexOf(sl) + 1; } else lab = (sl === 'lead' ? 'Lead' : 'Rear') + ' held ' + (sl === 'lead' ? P.hl : P.hr); }
      else if (sl === 'feet' && P.feet !== 'hold') { lab = FEET[P.feet].n; n = P.ord.indexOf('feet') + 1; } else if (k === 'clinch' && P.clinch) lab = 'Clinch';
      el.innerHTML = (n ? `<b>${n}</b>` : '') + `<span>${lab}</span>`; el.classList.toggle('set', !!n || (k === 'clinch' && P.clinch)); el.classList.toggle('pin', pinned === k); el.classList.toggle('pulse', first && k === 'lead');
      el.classList.toggle('off', P.clinch && k !== 'clinch' && k[0] !== 'h'); } }
  // ---- the panel: the page's own switch column for that part (the same buttons, the same rules)
  function open(k, pin) { clearTimeout(hideT); if (k[0] === 'h') { const t = $('histip'); t.innerHTML = hisHand(k === 'hlead' ? 'lead' : 'rear'); t.style.display = 'block'; posAt(t, spots[k].getBoundingClientRect()); return; }   // his hand: a tooltip only, your panel stays
    hover = k; if (pinned && pinned !== k && !pin) return; show(k); }
  function leave() { $('histip').style.display = 'none'; hideT = setTimeout(() => { if (!pinned && !brd.matches(':hover')) close(); }, 260); }
  function close() { hover = null; brd.className = 'board float'; brd.style.display = 'none'; $('histip').style.display = 'none'; mark(); }
  function show(k) { const sp = spots[k]; if (!sp) return; const r = sp.getBoundingClientRect();
    if (k[0] === 'h') { brd.style.display = 'none'; const t = $('histip'); t.innerHTML = hisHand(k === 'hlead' ? 'lead' : 'rear'); t.style.display = 'block'; posAt(t, r); return; }
    $('histip').style.display = 'none'; const gi = k === 'lead' ? 0 : k === 'rear' ? 1 : 2; brd.className = 'board float show' + gi + (k === 'feet' ? ' only-feet' : k === 'clinch' ? ' only-clinch' : ''); brd.style.display = 'block'; for (const b of brd.querySelectorAll('.sw')) { const sm = b.querySelector('small:not(.why):not(.hab)'); if (sm && !b.dataset.tip) b.dataset.tip = sm.textContent; } posAt(brd, r, true); }
  function posAt(el, r, mine) { const w = el.offsetWidth, h = el.offsetHeight, right = mine ? r.left - w - 14 < 8 : r.left + r.width / 2 < innerWidth / 2;   // your man's switches open on his own side, away from the other man
    let x = right ? r.right + 14 : r.left - w - 14; x = Math.max(8, Math.min(x, innerWidth - w - 8)); let y = r.top - h / 3; y = Math.max(8, Math.min(y, innerHeight - h - 8)); el.style.left = x + 'px'; el.style.top = y + 'px'; }
  function hisHand(sl) { const H = sl === 'lead' ? 0 : 1, nm = sl === 'lead' ? 'His lead hand' : 'His rear hand';
    const rows = seen.length ? [...seen].reverse().map((p, i) => { const did = p.clinch ? 'clinched' : p[sl] ? 'threw his ' + ACT[p[sl]].n.toLowerCase() : 'held ' + (sl === 'lead' ? p.hl : p.hr) + ' - it shut ' + STOPS[COVER[sl === 'lead' ? p.hl : p.hr][H]];
      return `<div><i>${['Last beat', 'Before that', 'And before'][i]}</i> ${did}</div>`; }).join('') : '<div>Nothing seen of him yet.</div>';
    return `<b>${nm}</b>${rows}<div class="hint">Held high it shuts ${STOPS[COVER.high[H]]}; held low, ${STOPS[COVER.low[H]]}.</div>`; }
  document.addEventListener('click', (e) => { if (!e.target.isConnected) return;   /* a switch re-draws the panel: its button is gone by now */
    if (pinned && !brd.contains(e.target) && !e.target.closest('.spot') && !e.target.closest('#seqwords') && !e.target.closest('.seq')) { pinned = null; close(); } });
  brd.addEventListener('mouseleave', () => { if (!pinned) leave(); }); brd.addEventListener('mouseenter', () => clearTimeout(hideT));
  // ---- the strip says what each moment does
  function words() { const el = $('seqwords'); if (phase !== 'plan') { el.innerHTML = ''; return; }
    if (P.clinch) { el.innerHTML = '<span>You tie him up: nothing lands either way this beat, you get 2 stamina back.</span>'; return; }
    let r = range; const out = P.ord.map((sl, i) => { const m = `<b>${i + 1}</b>`;
      if (sl === 'feet') { r = Math.max(1, Math.min(3, r + (P.feet === 'in' ? -1 : 1))); return `${m} you ${P.feet === 'in' ? 'step in' : 'back off'} - now at ${RNG[r]}`; }
      const a = ACT[P[sl]]; if (!a.d) return `${m} ${a.n.toLowerCase()} with your ${sl} hand`;
      const reach = a.reach.includes(r); return `${m} your ${a.n.toLowerCase()} ${reach ? 'reaches' : '<u>will not reach</u>'} at ${RNG[r]}; your ${sl} hand is out, ${THREAT[COVER[sl === 'lead' ? P.hl : P.hr][sl === 'lead' ? 0 : 1]].toLowerCase()} can get in`; });
    el.innerHTML = out.length ? out.map((s) => `<span>${s}</span>`).join('') + '<span class="meet">Your moment 1 meets his moment 1, 2 meets 2, 3 meets 3.</span>' : '<span>No action: both hands held. Hover your man\'s gloves, boots or body to pick.</span>'; }
  // ---- wrap the page's own drawing
  const board0 = board, plan0b = plan; let seenAt = 0;
  board = function () { board0(); if (phase === 'plan') { if (!brd.classList.contains('float')) brd.className = 'board float'; if (pinned) show(pinned); else if (!hover) brd.style.display = 'none'; } else { brd.className = 'board'; brd.style.display = ''; } words(); mark(); };
  plan = function () { plan0b(); place(); };
  im.addEventListener('load', () => { if (phase === 'plan') place(); else if (layer.innerHTML) place(); });
  addEventListener('resize', () => { place(); if (pinned) show(pinned); });
  const t = document.createElement('div'); t.id = 'histip'; document.body.appendChild(t);
  const sw = document.createElement('div'); sw.id = 'seqwords'; $('lines').parentNode.parentNode.insertBefore(sw, $('lines').parentNode.nextSibling);
  // phase leaves 'plan' when the beat is fought: hide the spots and the panel
  setInterval(() => { if (phase !== 'plan' && layer.innerHTML) { layer.innerHTML = ''; spots = {}; pinned = null; close(); brd.className = 'board'; brd.style.display = ''; words(); } }, 200);
})();

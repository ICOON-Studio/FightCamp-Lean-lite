// BODYUI1 + MASK1 (S559) - the owner's body toy on the REAL body (body.html = order.html's page and rules, plus this file).
// BODYUI1, the owner: "what if we map the available options for the player (cards, switches) on the opponents body and your
// own fighters body. Lets say i move my mouse on the left hand of my fighter and the available switches appear ..."
// MASK1, the owner: "you break down the body to each limb (feet can be one option when it is boxing match for movement
// options), so when i say you highlight the arm i move my mouse on i do not want text near the fighters (tubes or circles
// on the fighters are forbidden) make a pointer outlining to the available options menu".
// How: every picture shown while he plans has a part mask beside it (<frame>_mask.png, rendered from the 3D in the same
// frame by tools/pics2d_mask.gd: one flat colour per part). The pixel under the mouse names the part; that part glows (its
// outline, 3 px out from the mask's edge, 60%, in its corner's colour) on a canvas over the picture. Its switches open in
// ONE fixed panel left of the ring, and a thin line runs from the lit limb to the panel, drawn BEHIND the men. Click = the
// part stays open. His parts light too: the panel then says what that limb did in his last three beats.
// Parts: lead arm, rear arm, legs (= feet: step in, back off), torso (= the clinch). No circle, no label on a man.
(() => {
  const stage = $('stage'), im = $('pic'), brd = $('board'), side = $('side');
  // [r, g, b, who (0 you = blue, 1 him = red), part] - tools/pics2d_mask.gd PART, snapped exactly by anim_web.py
  const PARTS = [[255, 0, 0, 0, 'lead'], [0, 255, 0, 0, 'rear'], [0, 0, 255, 0, 'feet'], [255, 255, 0, 0, 'clinch'],
    [255, 0, 255, 1, 'lead'], [0, 255, 255, 1, 'rear'], [255, 128, 0, 1, 'feet'], [128, 0, 255, 1, 'clinch']];
  const GLOW = [[143, 192, 255], [255, 138, 128]];
  const NAME = { lead: 'Lead hand', rear: 'Rear hand', feet: 'Feet', clinch: 'Body' };
  const SUB = { lead: 'your front hand, nearer him', rear: 'your back hand, the power hand', feet: 'step in, back off, or stand', clinch: 'tie him up (Inside only)' };
  const glow = document.createElement('canvas'); glow.id = 'glow'; stage.appendChild(glow);
  const NS = 'http://www.w3.org/2000/svg', svg = document.createElementNS(NS, 'svg'); svg.id = 'pointer'; document.body.appendChild(svg);
  const line = document.createElementNS(NS, 'polyline'); line.setAttribute('fill', 'none'); line.setAttribute('stroke-width', '2'); line.setAttribute('stroke-linejoin', 'round'); line.setAttribute('stroke-dasharray', '7 4');   // dashed: never read as a rope svg.appendChild(line);
  const head = document.createElement('div'); head.className = 'hd'; side.insertBefore(head, brd);
  const his = document.createElement('div'); his.id = 'his'; side.appendChild(his);
  let mask = null, maskFor = '', hover = null, pinned = null, drawn = '';
  const MASKS = {}, RING = {};
  // ---- the mask of the picture on screen
  let byFile = null, nRuns = 0;
  function maskUrl() { const m = /img\/anim\/([^/?#]+\.webp)/.exec(im.src); if (!m) return null;
    if (!byFile || Object.keys(ANIM).length !== nRuns) { byFile = {}; nRuns = Object.keys(ANIM).length; for (const n in ANIM) { const r = ANIM[n]; if (r.masks) r.files.forEach((f, i) => { byFile[f] = r.masks[i]; }); } }
    return byFile[m[1]] ? 'img/anim/' + byFile[m[1]] : null; }
  function loadMask(url) {
    if (!MASKS[url]) MASKS[url] = new Promise((ok) => { const m = new Image(); m.onerror = () => ok(null);
      m.onload = () => { const c = document.createElement('canvas'), W = c.width = m.naturalWidth, H = c.height = m.naturalHeight, x = c.getContext('2d', { willReadFrequently: true }); x.drawImage(m, 0, 0);
        const d = x.getImageData(0, 0, W, H).data, id = new Uint8Array(W * H);
        for (let i = 0; i < id.length; i++) { if (d[i * 4 + 3] < 128) continue; let best = 0, bd = 1e9;
          for (let k = 0; k < PARTS.length; k++) { const p = PARTS[k], e = (d[i * 4] - p[0]) ** 2 + (d[i * 4 + 1] - p[1]) ** 2 + (d[i * 4 + 2] - p[2]) ** 2; if (e < bd) { bd = e; best = k + 1; } }
          id[i] = best; }
        ok({ url, W, H, id }); };
      m.src = url; });
    return MASKS[url]; }
  // every picture change (a cached picture set again fires no load in some browsers): the mask of that picture
  function follow() { if (maskFor === im.src) return; const u = maskUrl(); maskFor = im.src; if (!u) { mask = null; return redraw(); } loadMask(u).then((m) => { if (maskFor === im.src) { mask = m; redraw(); } }); }
  im.addEventListener('load', follow); new MutationObserver(follow).observe(im, { attributes: true, attributeFilter: ['src'] });
  const mirrored = () => { const m = /matrix\(([^,]+)/.exec(getComputedStyle(im).transform); return m ? parseFloat(m[1]) < 0 : false; };
  // ---- which part is under the mouse (the pixel, else the nearest part pixel within 3 px: a forgiving edge)
  function partAt(e) { if (!mask || phase !== 'plan') return 0; const r = im.getBoundingClientRect(); let u = (e.clientX - r.left) / r.width; const v = (e.clientY - r.top) / r.height;
    if (mirrored()) u = 1 - u; if (u < 0 || u >= 1 || v < 0 || v >= 1) return 0; const x = Math.floor(u * mask.W), y = Math.floor(v * mask.H);
    if (mask.id[y * mask.W + x]) return mask.id[y * mask.W + x];
    for (let rr = 1; rr <= 3; rr++) for (let dy = -rr; dy <= rr; dy++) for (let dx = -rr; dx <= rr; dx++) { const X = x + dx, Y = y + dy; if (X >= 0 && Y >= 0 && X < mask.W && Y < mask.H && mask.id[Y * mask.W + X]) return mask.id[Y * mask.W + X]; }
    return 0; }
  const keyOf = (k) => (k ? PARTS[k - 1][3] + ':' + PARTS[k - 1][4] : null);
  const idxOf = (key) => PARTS.findIndex((p) => p[3] + ':' + p[4] === key) + 1;
  stage.addEventListener('mousemove', (e) => { const key = keyOf(partAt(e)); stage.classList.toggle('over', !!key); if (key !== hover) { hover = key; show(); } });
  stage.addEventListener('mouseleave', () => { stage.classList.remove('over'); if (hover) { hover = null; show(); } });
  stage.addEventListener('click', (e) => { if (phase !== 'plan') return; const key = keyOf(partAt(e)); pinned = key && pinned !== key ? key : null; show(); });
  // ---- the glow: the part's outline, from the mask
  function ring(key) { const ck = mask.url + '|' + key; if (RING[ck]) return RING[ck];
    const n = idxOf(key), W = mask.W, H = mask.H, inn = new Uint8Array(W * H); let any = 0;
    for (let i = 0; i < inn.length; i++) if (mask.id[i] === n) { inn[i] = 1; any = 1; }
    if (!any) return (RING[ck] = null);
    const R = 3, a = new Uint8Array(W * H), dil = new Uint8Array(W * H);   // square dilation, rows then columns
    for (let y = 0; y < H; y++) { let last = -99; for (let x = 0; x < W; x++) { if (inn[y * W + x]) last = x; if (x - last <= R) a[y * W + x] = 1; } last = 99999; for (let x = W - 1; x >= 0; x--) { if (inn[y * W + x]) last = x; if (last - x <= R) a[y * W + x] = 1; } }
    for (let x = 0; x < W; x++) { let last = -99; for (let y = 0; y < H; y++) { if (a[y * W + x]) last = y; if (y - last <= R) dil[y * W + x] = 1; } last = 99999; for (let y = H - 1; y >= 0; y--) { if (a[y * W + x]) last = y; if (last - y <= R) dil[y * W + x] = 1; } }
    const pts = []; for (let i = 0; i < dil.length; i++) if (dil[i] && !inn[i]) pts.push(i);
    return (RING[ck] = { pts, W, H }); }
  const tmp = document.createElement('canvas');
  function redraw() {
    const s = stage.getBoundingClientRect(), r = im.getBoundingClientRect(), x = glow.getContext('2d');
    glow.style.left = (r.left - s.left - stage.clientLeft) + 'px'; glow.style.top = (r.top - s.top - stage.clientTop) + 'px'; glow.style.width = r.width + 'px'; glow.style.height = r.height + 'px'; glow.style.transform = mirrored() ? 'scaleX(-1)' : '';
    const keys = phase === 'plan' && mask ? [...new Set([pinned, hover].filter(Boolean))] : [], sig = (mask ? mask.url : '') + keys.join() + r.width + r.left;
    if (sig === drawn) return; drawn = sig;
    if (!mask || !keys.length) { x.clearRect(0, 0, glow.width, glow.height); line.setAttribute('points', ''); return; }
    if (glow.width !== mask.W || glow.height !== mask.H) { glow.width = tmp.width = mask.W; glow.height = tmp.height = mask.H; }
    x.clearRect(0, 0, glow.width, glow.height);
    for (const k of keys) { const g = ring(k); if (!g) continue; const t = tmp.getContext('2d'), img = t.createImageData(g.W, g.H), c = GLOW[+k[0]], al = Math.round(255 * 0.6 * (k === hover || !hover ? 1 : 0.6));
      for (const i of g.pts) { img.data[i * 4] = c[0]; img.data[i * 4 + 1] = c[1]; img.data[i * 4 + 2] = c[2]; img.data[i * 4 + 3] = al; }
      t.putImageData(img, 0, 0); x.save(); x.filter = 'blur(3px)'; x.drawImage(tmp, 0, 0); x.drawImage(tmp, 0, 0); x.restore(); x.drawImage(tmp, 0, 0); }
    pointer(hover || pinned, r); }
  // ---- the pointer: from the lit limb's edge nearest the panel to the panel, behind the men (#pointer sits under the picture)
  function pointer(key, r) { const g = key && ring(key); if (!g || !g.pts.length) { line.setAttribute('points', ''); return; }
    const p = side.getBoundingClientRect(), mir = mirrored(), ax = p.right + 1; let best = null, bd = 1e12;
    for (let j = 0; j < g.pts.length; j += 3) { const i = g.pts[j], px = i % g.W, py = (i - px) / g.W, sx = r.left + ((mir ? g.W - px - 0.5 : px + 0.5) / g.W) * r.width, sy = r.top + ((py + 0.5) / g.H) * r.height;
      const ay = Math.max(p.top + 18, Math.min(p.bottom - 18, sy)), d = (sx - ax) ** 2 + (sy - ay) ** 2; if (d < bd) { bd = d; best = [sx, sy, ay]; } }
    const c = GLOW[+key[0]], col = `rgb(${c[0]},${c[1]},${c[2]})`, sr = stage.getBoundingClientRect(), mx = sr.left - 2;
    line.setAttribute('stroke', col); line.setAttribute('opacity', '0.85'); line.style.filter = `drop-shadow(0 0 3px ${col})`;
    line.setAttribute('points', `${best[0]},${best[1]} ${mx},${best[2]} ${ax},${best[2]}`); }
  // ---- the panel: the page's own switch group for that part (the same buttons, the same rules); his part: what it did
  function show() { redraw(); panel(); }
  function panel() { const k = hover || pinned; side.className = 'side' + (k ? ' w' + k[0] : '');
    if (!k) { const first = round === 1 && beat === 0 && phase === 'plan';
      head.className = 'hd' + (first ? ' hint' : ''); head.innerHTML = '<b>Point at your man</b><small>an arm, the legs or the body - click it to keep its switches open. Point at him to see what that limb did.</small>';
      brd.style.display = 'none'; his.style.display = 'none'; return; }
    head.className = 'hd'; const [w, part] = k.split(':');
    if (w === '1') { brd.style.display = 'none'; his.style.display = 'block'; head.innerHTML = `<b>His ${NAME[part].toLowerCase()}</b>${pinned === k ? '<small>kept open: click it again to let go</small>' : ''}`; his.innerHTML = hisPart(part); return; }
    his.style.display = 'none'; brd.style.display = ''; head.innerHTML = `<b>${NAME[part]}</b><small>${pinned === k ? 'kept open: click it again to let go' : SUB[part]}</small>`;
    brd.className = 'board show' + (part === 'lead' ? 0 : part === 'rear' ? 1 : 2) + (part === 'feet' ? ' only-feet' : part === 'clinch' ? ' only-clinch' : ''); }
  const BEATS = ['Last beat', 'Before that', 'And before'];
  function hisPart(part) { const rows = (f) => (seen.length ? [...seen].reverse().map((p, i) => `<div><i>${BEATS[i]}</i> ${f(p)}</div>`).join('') : '<div>Nothing seen of him yet.</div>');
    if (part === 'feet') return rows((p) => (p.clinch ? 'tied you up' : p.feet === 'in' ? 'stepped in' : p.feet === 'back' ? 'backed off' : 'stood his ground')) + '<div class="hint">A step in beats a back off in the same moment.</div>';
    if (part === 'clinch') return rows((p) => (p.clinch ? 'clinched' : 'did not clinch')) + '<div class="hint">The clinch works Inside only, and not twice running.</div>';
    const H = part === 'lead' ? 0 : 1, sl = part;
    return rows((p) => (p.clinch ? 'clinched' : p[sl] ? 'threw his ' + ACT[p[sl]].n.toLowerCase() : 'held ' + (sl === 'lead' ? p.hl : p.hr) + ' - it shut ' + STOPS[COVER[sl === 'lead' ? p.hl : p.hr][H]]))
      + `<div class="hint">Held high it shuts ${STOPS[COVER.high[H]]}; held low, ${STOPS[COVER.low[H]]}.</div>`; }
  // ---- the strip says what each moment does
  function words() { const el = $('seqwords'); if (phase !== 'plan') { el.innerHTML = ''; return; }
    if (P.clinch) { el.innerHTML = '<span>You tie him up: nothing lands either way this beat, you get 2 stamina back.</span>'; return; }
    let r = range; const out = P.ord.map((sl, i) => { const m = `<b>${i + 1}</b>`;
      if (sl === 'feet') { r = Math.max(1, Math.min(3, r + (P.feet === 'in' ? -1 : 1))); return `${m} you ${P.feet === 'in' ? 'step in' : 'back off'} - now at ${RNG[r]}`; }
      const a = ACT[P[sl]]; if (!a.d) return `${m} ${a.n.toLowerCase()} with your ${sl} hand`;
      return `${m} your ${a.n.toLowerCase()} ${a.reach.includes(r) ? 'reaches' : '<u>will not reach</u>'} at ${RNG[r]}; your ${sl} hand is out, ${THREAT[COVER[sl === 'lead' ? P.hl : P.hr][sl === 'lead' ? 0 : 1]].toLowerCase()} can get in`; });
    el.innerHTML = out.length ? out.map((s) => `<span>${s}</span>`).join('') + '<span class="meet">Your moment 1 meets his moment 1, 2 meets 2, 3 meets 3.</span>' : ''; }
  // ---- wrap the page's own drawing
  const board0 = board, plan0b = plan;
  board = function () { board0(); panel(); words(); };
  plan = function () { plan0b(); show(); };
  addEventListener('resize', () => { drawn = ''; redraw(); });
  const sw = document.createElement('div'); sw.id = 'seqwords'; $('lines').parentNode.parentNode.insertBefore(sw, $('lines').parentNode.nextSibling);
  // the beat is fought: nothing glows (the switches that act are marked in the panel by the page)
  setInterval(() => { if (phase !== 'plan' && (hover || drawn)) { hover = null; drawn = ''; redraw(); words(); } if (phase === 'plan' && !drawn && (pinned || hover)) redraw(); }, 200);
  panel();
  window.bodyMask = () => ({ pic: im.src.split('/').pop(), mask: mask ? mask.url.split('/').pop() : null, hover, pinned });   // read by tools/mask_shots.mjs
})();

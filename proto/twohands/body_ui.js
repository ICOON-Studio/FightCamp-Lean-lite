// BODYUI2 (S562): the body view IS how you pick switches - on order.html (the main page), punch.html and head.html.
// BODYUI1 (S559), the owner: "what if we map the available options for the player (cards, switches) on the opponents body
// and your own fighters body. Lets say i move my mouse on the left hand of my fighter and the available switches appear ..."
// MASK1 (S559): "i do not want text near the fighters (tubes or circles on the fighters are forbidden) make a pointer
// outlining to the available options menu". S562: Q-343 "make it how you pick switches on the main page?" - "Yes, replace
// the board"; Q-338 (his limb) - "Show what it can do"; Q-339 "head opens slip, roll, lean back; torso the clinch; legs the
// steps?" - "Yes".
// How: every picture shown while he plans has a part mask beside it (<frame>_mask.png, rendered from the 3D in the same
// frame by tools/pics2d_mask.gd: one flat colour per part). The pixel under the mouse names the part; that part glows (its
// outline, 3 px out from the mask's edge, in its corner's colour) on a canvas over the picture. ONE fixed panel left of the
// ring shows that part: YOUR part = the page's own switch buttons for it (the same buttons, the same rules - this file only
// chooses which are shown); HIS part = what it can do to you at the range you stand at, from the page's ACT / COVER / STOPS
// tables. A thin line runs from the lit limb to the panel, drawn BEHIND the men. Click = the part stays open.
// Parts: lead arm, rear arm, legs (the steps), torso (the clinch; the All in switch on punch.html), head (the head moves
// on head.html; the hands held high elsewhere). No circle, no label on a man.
(() => {
  const stage = $('stage'), im = $('pic'), brd = $('board'), side = $('side');
  // [r, g, b, who (0 you = blue, 1 him = red), part] - tools/pics2d_mask.gd PART, snapped exactly by anim_web.py
  const PARTS = [[255, 0, 0, 0, 'lead'], [0, 255, 0, 0, 'rear'], [0, 0, 255, 0, 'feet'], [255, 255, 0, 0, 'clinch'], [0, 128, 255, 0, 'head'],
    [255, 0, 255, 1, 'lead'], [0, 255, 255, 1, 'rear'], [255, 128, 0, 1, 'feet'], [128, 0, 255, 1, 'clinch'], [255, 0, 128, 1, 'head']];
  const GLOW = [[143, 192, 255], [255, 138, 128]];
  const HM = ['slip', 'roll', 'pull', 'slipin'].filter((id) => FEET[id]);   // the head moves this page has (head.html: all four; order.html: none)
  const PCH = typeof pcOpen === 'function';   // punch.html: the All in switch (Puncher's chance is the GAME's name, S565)
  const NAME = { lead: 'Lead hand', rear: 'Rear hand', feet: 'Feet', clinch: 'Body', head: 'Head' };
  const SUB = { lead: 'your front hand: punch, or hold it high or low', rear: 'your back hand, the power hand', feet: Object.keys(FEET).some((id) => !['in', 'hold', 'back', ...HM].includes(id)) ? 'the steps, the kicks and the check' : 'step in, back off, or hold your ground',
    clinch: PCH ? "the clinch (Inside only) and All in" : 'tie him up (Inside only)', head: HM.length ? 'slip, roll, lean back, slip in' : 'the hands held high keep it safe' };
  const glow = document.createElement('canvas'); glow.id = 'glow'; stage.appendChild(glow);
  const NS = 'http://www.w3.org/2000/svg', svg = document.createElementNS(NS, 'svg'); svg.id = 'pointer'; document.body.appendChild(svg);
  const line = document.createElementNS(NS, 'polyline'); line.setAttribute('fill', 'none'); line.setAttribute('stroke-width', '2'); line.setAttribute('stroke-linejoin', 'round'); line.setAttribute('stroke-dasharray', '7 4');   // dashed: never read as a rope
  svg.appendChild(line);
  const head = document.createElement('div'); head.className = 'hd'; side.insertBefore(head, brd);
  const sum = document.createElement('div'); sum.id = 'sum'; side.insertBefore(sum, brd);
  const his = document.createElement('div'); his.id = 'his'; side.appendChild(his);
  let mask = null, maskFor = '', hover = null, pinned = null, peek = null, drawn = '';
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
  function ring(key) { const ck = mask.url + '|' + key; if (RING[ck] !== undefined) return RING[ck];
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
    const keys = phase === 'plan' && mask ? [...new Set([pinned, hover, peek].filter(Boolean))] : [], sig = (mask ? mask.url : '') + keys.join() + r.width + r.left;
    if (sig === drawn) return; drawn = sig;
    if (!mask || !keys.length) { x.clearRect(0, 0, glow.width, glow.height); line.setAttribute('points', ''); return; }
    if (glow.width !== mask.W || glow.height !== mask.H) { glow.width = tmp.width = mask.W; glow.height = tmp.height = mask.H; }
    x.clearRect(0, 0, glow.width, glow.height); const lead = hover || peek || pinned;
    for (const k of keys) { const g = ring(k); if (!g) continue; const t = tmp.getContext('2d'), img = t.createImageData(g.W, g.H), c = GLOW[+k[0]], al = Math.round(255 * 0.6 * (k === lead ? 1 : 0.6));
      for (const i of g.pts) { img.data[i * 4] = c[0]; img.data[i * 4 + 1] = c[1]; img.data[i * 4 + 2] = c[2]; img.data[i * 4 + 3] = al; }
      t.putImageData(img, 0, 0); x.save(); x.filter = 'blur(3px)'; x.drawImage(tmp, 0, 0); x.drawImage(tmp, 0, 0); x.restore(); x.drawImage(tmp, 0, 0); }
    pointer(lead, r); }
  // ---- the pointer: from the lit limb's edge nearest the panel to the panel, behind the men (#pointer sits under the picture)
  let ptFor = '';   /* S566, owner: "the intermittent lines move along with the bouncing and it is very annoying" - while the men bounce (the _bob pictures) the dashed line keeps the place it had on the still picture; only the limb's glow follows the limb */
  function pointer(key, r) { const g = key && ring(key); if (!g || !g.pts.length) { line.setAttribute('points', ''); ptFor = ''; return; }
    const sig = key + '|' + Math.round(r.width) + '|' + Math.round(r.left) + '|' + Math.round(r.top) + '|' + range; if (/_bob(_r[123])?_\d+\.webp/.test(im.src) && ptFor === sig && line.getAttribute('points')) return; ptFor = sig;
    const p = side.getBoundingClientRect(), mir = mirrored(), ax = p.right + 1; let best = null, bd = 1e12;
    for (let j = 0; j < g.pts.length; j += 3) { const i = g.pts[j], px = i % g.W, py = (i - px) / g.W, sx = r.left + ((mir ? g.W - px - 0.5 : px + 0.5) / g.W) * r.width, sy = r.top + ((py + 0.5) / g.H) * r.height;
      const ay = Math.max(p.top + 18, Math.min(p.bottom - 18, sy)), d = (sx - ax) ** 2 + (sy - ay) ** 2; if (d < bd) { bd = d; best = [sx, sy, ay]; } }
    const c = GLOW[+key[0]], col = `rgb(${c[0]},${c[1]},${c[2]})`, sr = stage.getBoundingClientRect(), mx = sr.left - 2;
    line.setAttribute('stroke', col); line.setAttribute('opacity', '0.85'); line.style.filter = `drop-shadow(0 0 3px ${col})`;
    line.setAttribute('points', `${best[0]},${best[1]} ${mx},${best[2]} ${ax},${best[2]}`); }
  // ---- which of the page's own buttons belong to a part of YOUR man
  function inPart(b, part) { const g = b.dataset.g, id = b.dataset.id;
    if (part === 'lead' || part === 'rear') return g === part;
    if (part === 'feet') return g === 'feet' && !HM.includes(id);
    if (part === 'clinch') return g === 'clinch' || g === 'pch';
    if (part === 'head') return HM.length ? g === 'feet' && (HM.includes(id) || id === 'hold') : (g === 'lead' || g === 'rear') && id === 'high';
    return false; }
  function filter(test) { brd.classList.toggle('part', !!test);
    for (const b of brd.querySelectorAll('.sw')) b.style.display = !test || test(b) ? '' : 'none';
    for (const g of brd.querySelectorAll('.grp')) g.style.display = !test || [...g.querySelectorAll('.sw')].some((b) => b.style.display !== 'none') ? '' : 'none'; }
  // ---- the panel
  function show() { redraw(); panel(); }
  const T = (s) => tipAttr(s);
  function panel() { const k = phase === 'plan' ? hover || pinned : null; side.className = 'side' + (k ? ' w' + k[0] : '');
    his.style.display = 'none'; sum.style.display = 'none'; brd.style.display = '';
    if (phase === 'setup') { head.className = 'hd'; head.innerHTML = '<b>Pick your man</b><small>then Fight. In the bout, click your boxer to choose his moves.</small>'; filter(null); return; }
    if (phase === 'over') { head.className = 'hd'; head.innerHTML = '<b>The bout is over</b>'; filter(null); return; }
    if (phase !== 'plan') { head.className = 'hd'; head.innerHTML = '<b>This beat</b><small>your switches, lit as they act</small>'; filter((b) => b.classList.contains('on') && !b.classList.contains('home')); return; }
    if (!k) { const first = round === 1 && beat === 0;
      head.className = 'hd' + (first ? ' hint' : ''); head.innerHTML = '<b>Choose your moves</b><small>1. Click a part of your boxer (the blue one): an arm, the legs, the body.<br>2. Its moves show here: click the one you want.<br>Mouse over the red boxer to see what he can hit you with.</small>';   /* S566 C521, owner: "i do not understand what it does, maybe reoharse and use basic terminology" */
      brd.style.display = 'none'; sum.style.display = 'flex'; sum.innerHTML = summary(); for (const b of sum.querySelectorAll('button')) { b.onclick = () => { pinned = b.dataset.k; peek = null; show(); }; b.onmouseenter = () => { peek = b.dataset.k; redraw(); }; b.onmouseleave = () => { peek = null; redraw(); }; } return; }
    head.className = 'hd'; const [w, part] = k.split(':'), kept = pinned === k ? 'kept open: click it again to let go' : '';
    if (w === '1') { brd.style.display = 'none'; his.style.display = 'flex'; head.innerHTML = `<b>His ${NAME[part].toLowerCase()}</b><small>${kept || 'what it can do to you at ' + RNG[range]}</small>`; his.innerHTML = hisPart(part); return; }
    const hm = part === 'head' && !HM.length;
    head.innerHTML = `<b>${NAME[part]}</b><small${hm ? T('Slip, roll, lean back and slip in are on head.html (the head-movement page). Here a hand held high keeps the head safe: the lead hand high stops straight punches to the head, the rear hand high stops hooks.') : ''}>${kept || SUB[part] + (hm ? ' - head moves: head.html' : '')}</small>`;
    filter((b) => inPart(b, part)); }
  // what you have set, part by part (a click opens that part)
  const GUARDTIP = 'Each hand guards its own two things; high or low picks which one.\nLead hand: high stops his jab and cross, low stops his body punches.\nRear hand: high stops his hook and overhand, low stops his uppercuts.\nA hand that punches is away only in the moment it throws.';
  function summary() { const stops = (sl) => THREAT[COVER[sl === 'lead' ? P.hl : P.hr][sl === 'lead' ? 0 : 1]].replace(/^His /, 'his '), h = (sl) => (P.clinch ? 'clinch' : P[sl] ? ACT[P[sl]].n : 'held ' + (sl === 'lead' ? P.hl : P.hr) + `<small class="stops"> stops ${stops(sl)}</small>`),   /* S566, owner: "it is confusing to me if it matters which hand of the 2 is up , if it does when and how" - a held hand says what it stops */ n = (sl) => (P.ord.indexOf(sl) >= 0 ? ` - ${['1st', '2nd', '3rd'][P.ord.indexOf(sl)] || P.ord.indexOf(sl) + 1}` : '');   /* S563 ALLPLAY2: "Feint (2)" read as a cost; the order says 1st / 2nd / 3rd */
    const ft = HM.includes(P.feet) ? FEET.hold.n : FEET[P.feet].n, hd = HM.length ? (HM.includes(P.feet) ? FEET[P.feet].n + n('feet') : 'no head move') : [!P.lead && P.hl === 'high' && 'lead high', !P.rear && P.hr === 'high' && 'rear high'].filter(Boolean).join(', ') || 'no hand held high';
    const rows = [['lead', h('lead') + n('lead')], ['rear', h('rear') + n('rear')], ['feet', ft + (HM.includes(P.feet) ? '' : n('feet'))], ['head', hd], ['clinch', P.clinch ? 'clinch' : PCH && P.pch ? "All in" : '-']];
    return rows.map(([p, v]) => `<button data-k="0:${p}"${p === 'lead' || p === 'rear' ? T(GUARDTIP) : ''}><i>${NAME[p]}</i><b>${v}</b></button>`).join(''); }
  // HIS PART (Q-338 "Show what it can do"): one line each, the rest in the tooltip
  const hand = (sl, hold) => `your ${sl} hand ${hold}`;
  function stopOf(a) { return [slotOf(a.line), COVER.high.includes(a.line) ? 'high' : 'low']; }
  function hisPart(part) { const cv = covers(F[0], P), R = RNG[range];
    if (part === 'lead' || part === 'rear') { const H = part === 'lead' ? 0 : 1;
      return Object.keys(ACT).filter((id) => ACT[id].h === H).map((id) => { const a = ACT[id];
        if (!a.d) return `<div class="row"${T(a.n + ': ' + (a.t || ''))}><b>${a.n}</b><em>no damage</em><u class="far">${a.push ? 'Inside' : 'any range'}</u></div>`;
        const reach = a.reach.includes(range), [ss, sh] = stopOf(a), cov = cv[a.line];
        const tip = `${a.n}: ${a.d} health, ${SPEED[a.sp]}, ${LINE[a.line].toLowerCase()}. Reaches ${a.reach.map((r) => RNG[r]).join(', ')}${reach ? '' : ' - not at ' + R + ', unless the range closes first'}.\nStopped by ${hand(ss, sh)}${cov ? ' - as you have it set now.' : '. You have not set that: it is open.'}${a.x ? '\n' + a.x : ''}`;
        return `<div class="row${reach ? '' : ' far'}"${T(tip)}><b>${a.n}</b><em>${a.d} dmg, ${SPEED[a.sp]}</em><u class="${!reach ? 'far' : cov ? 'ok' : 'open'}">${!reach ? 'short' : cov ? 'stopped' : 'open'}</u><small>stopped by ${ss} ${sh}</small></div>`; }).join(''); }
    if (part === 'feet') { const f = F[1];
      return ['in', 'hold', 'back'].map((id) => { const to = clamp(range + (id === 'in' ? -1 : id === 'back' ? 1 : 0), 1, 3), no = (id === 'back' && f.ropes >= 2) || (id === 'in' && f.kept);
        return `<div class="row${no ? ' far' : ''}"${T(FEET[id].n + ': ' + FEET[id].t)}><b>${FEET[id].n}</b><em>${id === 'hold' ? 'stays at ' + R : R + ' to ' + RNG[to]}</em><u class="far">${no ? (id === 'back' ? 'on the ropes' : 'kept out') : to === range && id !== 'hold' ? 'no room' : 'can'}</u></div>`; }).join('')
        + `<div class="note2">A step in beats a back off in the same moment.</div>`; }
    if (part === 'clinch') { const can = range === 1 && !F[1].held;
      return `<div class="row${can ? '' : ' far'}"${T('The clinch: Inside only, 1 stamina. No punch lands for either man, he gets 2 stamina back, the referee breaks you at Mid. Not twice running; a push stops it.')}><b>Clinch</b><em>Inside only</em><u class="${can ? 'open' : 'far'}">${can ? 'he can' : 'not at ' + R}</u></div>`
        + (PCH ? (() => { const o = pcOpen({ f: F }, 1); return `<div class="row${o ? '' : ' far'}"${T("His All in: open only when he is " + N.pcGap + ' or more health behind, once a round. One power punch of his is all in: double damage, and you go down if it lands. Block it or be out of reach and he is wide open.')}><b>All in</b><em>double or wide open</em><u class="${o ? 'open' : 'far'}">${o ? 'open' : 'shut'}</u></div>`; })() : ''); }
    if (part === 'head') {
      const ids = Object.keys(ACT).filter((id) => ACT[id].d && !ACT[id].body && ACT[id].line !== 'body');
      return ids.map((id) => { const a = ACT[id], reach = a.reach.includes(range), [ss, sh] = stopOf(a);
        return `<div class="row${reach ? '' : ' far'}"${T(a.n + ': ' + a.d + ' health to his head, ' + SPEED[a.sp] + '. Reaches ' + a.reach.map((r) => RNG[r]).join(', ') + '.\nHe stops it with his ' + ss + ' hand held ' + sh + (HM.length ? '; a ' + (a.line === 'straight' ? 'slip' : a.line === 'side' ? 'roll' : 'head move does not save him from an uppercut - a roll even walks into it') + (a.line === 'under' ? '' : ' makes it miss') : '') + '.')}><b>${a.n}</b><em>${a.d} dmg</em><u class="${reach ? 'ok' : 'far'}">${reach ? 'lands at ' + R : 'short'}</u><small>he stops it with his ${ss} ${sh}</small></div>`; }).join(''); }
    return ''; }
  // ---- the strip says what each moment does
  function words() { const el = $('seqwords'); if (phase !== 'plan') { el.innerHTML = ''; return; }
    if (P.clinch) { el.innerHTML = '<span>You tie him up: nothing lands either way this beat, you get 2 stamina back.</span>'; return; }
    let r = range; const out = P.ord.map((sl, i) => { const m = `<b>${i + 1}</b>`;
      if (sl === 'feet') { const d = P.feet === 'in' || P.feet === 'slipin' ? -1 : P.feet === 'back' ? 1 : 0; r = Math.max(1, Math.min(3, r + d)); return d ? `${m} you ${FEET[P.feet].n.toLowerCase()} - now at ${RNG[r]}` : `${m} you ${FEET[P.feet].n.toLowerCase()}`; }
      if (sl === 'wait') return `${m} you wait: both hands are home, your step comes next`;   /* wait.html (S565 MOMENTGAP1 B): an empty moment before a late step */
      const a = ACT[P[sl]]; if (!a.d) return `${m} ${a.n.toLowerCase()} with your ${sl} hand`;
      return `${m} your ${a.n.toLowerCase()} ${a.reach.includes(r) ? 'reaches' : '<u>will not reach</u>'} at ${RNG[r]}; your ${sl} hand is out, ${THREAT[COVER[sl === 'lead' ? P.hl : P.hr][sl === 'lead' ? 0 : 1]].toLowerCase()} can get in`; });
    el.innerHTML = out.length ? out.map((s) => `<span>${s}</span>`).join('') + '<span class="meet">Your moment 1 meets his moment 1, 2 meets 2, 3 meets 3.</span>' : ''; }
  // ---- wrap the page's own drawing (board() fills #board, now inside the panel)
  const board0 = board, plan0b = plan, go0 = go, over0 = over, setup0 = setup;
  board = function () { board0(); panel(); words(); };
  plan = function () { plan0b(); show(); };
  go = function () { go0(); hover = null; pinned = null; peek = null; drawn = ''; redraw(); panel(); words(); };
  over = function (t) { over0(t); panel(); words(); };
  setup = function () { setup0(); hover = pinned = peek = null; panel(); };
  addEventListener('resize', () => { drawn = ''; redraw(); });
  const sw = document.createElement('div'); sw.id = 'seqwords'; $('lines').parentNode.parentNode.insertBefore(sw, $('lines').parentNode.nextSibling);
  setInterval(() => { if (phase !== 'plan' && (hover || drawn)) { hover = null; drawn = ''; redraw(); words(); } if (phase === 'plan' && !drawn && (pinned || hover || peek)) redraw(); }, 200);
  panel();
  window.bodyMask = () => ({ pic: im.src.split('/').pop(), mask: mask ? mask.url.split('/').pop() : null, hover, pinned, parts: PARTS.map((p) => p.slice()) });   // read by tools/mask_shots.mjs
})();

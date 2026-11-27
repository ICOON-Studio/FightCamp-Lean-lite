// STRIP1 (S566). The owner, marking the order row of the page (C520): "can you add a strip with slots for each action so
// it is clear what happens when, and player can drage the slot to change the order, also would be nice if a holographic
// preview plays the current sellection".
// 1. THE STRIP: three numbered slots, always there (1st, 2nd, 3rd moment of the beat). A slot holds one action as a card:
//    its name, what it does at the range it happens at, and the line its hand leaves open in that moment. An empty slot
//    says so. A card is dragged to another slot; a click moves it one slot earlier. It replaces the chip row and the
//    sentence row under it (the page's own #lines .seq and body_ui's #seqwords are hidden, their data is what is drawn).
// 2. THE PREVIEW: a see-through blue copy of YOUR man plays the chosen actions in order, in the ring, on top of the men
//    as they stand: once after every change, and again while the mouse is on the strip. The slot whose moment is playing
//    lights up. It is the blue runs the beat itself would play (red is masked away), never a result: no damage, no sound.
// Rules are not touched: this file only sets P.ord (as the old chips did) and calls the page's plan().
(() => {
  const stage = $('stage'), im = $('pic'), lines = $('lines');
  const css = document.createElement('style');
  css.textContent = '#lines .seq,#lines>.lab:has(+ .seq),#seqwords{display:none}' +
    '#strip{display:flex;gap:.45rem;align-items:stretch;flex:none}' +
    '#strip .slot{position:relative;width:14rem;min-height:4.3rem;border-radius:.55rem;border:1px dashed var(--line2);padding:.3rem .55rem .35rem 2rem;display:flex;flex-direction:column;justify-content:center;gap:.08rem;font-size:.82rem;line-height:1.2}' +
    '#strip .slot .no{position:absolute;left:.45rem;top:50%;transform:translateY(-50%);font-size:1.5rem;font-weight:700;color:var(--muted);opacity:.7}' +
    '#strip .slot.full{border:1px solid var(--gold);background:#2a2116;cursor:grab;touch-action:none;user-select:none;-webkit-user-select:none}#strip .slot.full .no{color:var(--gold);opacity:1}' +
    '#strip .slot.wait{border:1px dashed var(--gold);background:none}' +
    '#strip .slot b{font-size:1rem}#strip .slot i{font-style:normal;color:var(--muted)}#strip .slot .ok{color:#bfe6c3}#strip .slot .no2{color:#ffb3ad}' +
    '#strip .slot.empty{color:var(--muted)}' +
    '.stops{display:block;font-weight:400;font-size:.78rem;color:#bfe6c3}' +
    '#strip .slot.drag{cursor:grabbing;z-index:3;opacity:.9;box-shadow:0 .3rem 1rem #000b}#strip .slot.gapL{box-shadow:-.3rem 0 0 var(--gold)}#strip .slot.gapR{box-shadow:.3rem 0 0 var(--gold)}' +
    '#strip .slot.playing{border-color:#7fe9ff;box-shadow:0 0 .7rem rgba(127,233,255,.75)}#strip .slot.playing .no{color:#7fe9ff}' +
    '#strip .hd{writing-mode:vertical-rl;transform:rotate(180deg);font-size:.66rem;letter-spacing:.12em;text-transform:uppercase;color:var(--muted);text-align:center}' +
    '.stage img#ghost{z-index:2;pointer-events:none;opacity:0;transition:opacity .25s;filter:grayscale(1) brightness(1.5) sepia(1) hue-rotate(150deg) saturate(5) drop-shadow(0 0 6px #6ff);' +
    '-webkit-mask-image:repeating-linear-gradient(to bottom,#000 0 3px,rgba(0,0,0,.4) 3px 4px),linear-gradient(to right,transparent 43%,#000 54%);mask-image:repeating-linear-gradient(to bottom,#000 0 3px,rgba(0,0,0,.4) 3px 4px),linear-gradient(to right,transparent 43%,#000 54%);-webkit-mask-composite:source-in;mask-composite:intersect}' +
    '.stage img#ghost.on{opacity:.62}';
  document.head.appendChild(css);
  const ghost = document.createElement('img'); ghost.id = 'ghost'; ghost.alt = ''; stage.appendChild(ghost);
  const NTH = ['1st', '2nd', '3rd', '4th'], clampR = (r) => Math.max(1, Math.min(3, r));
  const feetStep = () => (P.feet === 'in' || P.feet === 'slipin' ? -1 : P.feet === 'back' ? 1 : 0);
  const actOf = (sl) => (sl === 'wait' ? null : sl === 'feet' ? (ACT[P.feet] && ACT[P.feet].d ? ACT[P.feet] : null) : ACT[P[sl]]);
  // what each moment is: its words for the card, and the range it happens at / leaves the men at
  function moments() { let r = range; return P.ord.map((sl) => { const a = actOf(sl), at = r;
      if (sl === 'wait') return { sl, name: 'Wait', line: '<i>nothing yet: your step comes next</i>', at, to: r };
      if (sl === 'feet' && !a) { const d = feetStep(); r = clampR(r + d); return { sl, name: FEET[P.feet].n, line: d ? (r === at ? '<span class="no2">no room to move</span>' : `<span class="ok">${RNG[at]} &rarr; ${RNG[r]}</span>`) : '<i>on the spot</i>', at, to: r }; }
      if (!a.d) return { sl, a, name: a.n, line: `<i>your ${sl} hand, no damage</i>`, at, to: r };
      const hold = sl === 'lead' ? P.hl : sl === 'rear' ? P.hr : null, open = hold ? THREAT[COVER[hold][sl === 'lead' ? 0 : 1]] : '';
      return { sl, a, name: a.n, line: a.reach.includes(r) ? `<span class="ok">reaches at ${RNG[r]}</span>` : `<span class="no2">will not reach at ${RNG[r]}</span>`, open, at, to: r }; }); }
  function strip() { const old = document.getElementById('strip'); if (old) old.remove(); if (phase !== 'plan' || P.clinch) { stop(); return; }
    const ms = moments(), n = Math.max(3, ms.length), el = document.createElement('div'); el.id = 'strip';
    el.innerHTML = '<span class="hd">This beat</span>' + Array.from({ length: n }, (x, i) => { const m = ms[i];
      if (!m) return `<div class="slot empty"><span class="no">${i + 1}</span><i>${ms.length ? 'nothing' : i ? 'nothing' : 'both hands held, feet still'}</i></div>`;
      const tip = m.sl === 'wait' ? 'An empty moment before your step. Switch it off with the button beside the strip.' : `${NTH[i]} moment: ${m.name}. Drag the card to another slot to change when it happens (a click: one slot earlier).\nYour ${NTH[i]} moment meets his ${NTH[i]} moment.`;
      return `<div class="slot full${m.sl === 'wait' ? ' wait' : ''}" data-sl="${m.sl}" data-tip="${tip}"><span class="no">${i + 1}</span><b>${m.name}</b>${m.line}${m.open ? `<span class="no2">open: ${m.open.toLowerCase()}</span>` : ''}</div>`; }).join('');
    lines.insertBefore(el, lines.firstChild);
    for (const c of lines.querySelectorAll(':scope > .ln.open')) if (/open in moment \d/.test(c.textContent)) c.remove();   /* each card says what its own moment leaves open: the chips keep what is open or covered the whole beat */
    const cards = [...el.querySelectorAll('.slot.full')], slots = [...el.querySelectorAll('.slot')];
    for (const b of cards) { let dragged = false;
      b.onclick = () => { if (dragged) return; const i = P.ord.indexOf(b.dataset.sl); if (i > 0) { const o = [...P.ord]; [o[i - 1], o[i]] = [o[i], o[i - 1]]; P.ord = o; plan(); } };
      b.onpointerdown = (e) => { if (cards.length < 2 || e.button > 0) return; const x0 = e.clientX, others = cards.filter((c) => c !== b), mids = others.map((c) => { const r = c.getBoundingClientRect(); return r.left + r.width / 2; });
        const placeAt = (x) => mids.filter((m) => x > m).length, mark = (k) => { for (const c of others) c.classList.remove('gapL', 'gapR'); if (k == null) return; if (others[k]) others[k].classList.add('gapL'); else others[others.length - 1].classList.add('gapR'); };
        try { b.setPointerCapture(e.pointerId); } catch (err) {}
        b.onpointermove = (ev) => { const dx = ev.clientX - x0; if (!dragged && Math.abs(dx) < 6) return; dragged = true; stop(); b.classList.add('drag'); b.style.transform = `translateX(${dx}px)`; mark(placeAt(ev.clientX)); };
        const end = (ev, drop) => { b.onpointermove = b.onpointerup = b.onpointercancel = null; mark(null); if (!dragged) return; if (drop) { const o = P.ord.filter((sl) => sl !== b.dataset.sl); o.splice(placeAt(ev.clientX), 0, b.dataset.sl); P.ord = o; } plan(); };
        b.onpointerup = (ev) => end(ev, true); b.onpointercancel = (ev) => end(ev, false); }; }
    el.onmouseenter = () => { hov = true; if (!playing) preview(0); }; el.onmouseleave = () => { hov = false; };
    const key = JSON.stringify([P.ord, P.lead, P.rear, P.feet, range]); if (key !== lastKey) { lastKey = key; preview(450); } else if (playing) light(slots); }
  // ---- the preview
  let tok = 0, playing = false, hov = false, lastKey = '', nowAt = -1;
  const light = (slots) => { (slots || [...document.querySelectorAll('#strip .slot')]).forEach((s, i) => s.classList.toggle('playing', i === nowAt)); };
  function stop() { tok++; playing = false; nowAt = -1; ghost.classList.remove('on'); light(); }
  const pickRun = (names) => names.find((n) => ANIM[n]) || '';
  function runsOf() { return moments().map((m) => { const sfx = (r) => (r === 3 ? '' : '_r' + r);
      if (m.sl === 'wait') return '';
      if (m.sl === 'feet' && !m.a) { const d = feetStep(), base = P.feet === 'slipin' ? 'blue_slip_in' : d < 0 ? 'blue_step_in' : d > 0 ? 'blue_back_off' : ''; return base && m.to !== m.at ? pickRun([base + '_r' + m.to, base]) : ''; }
      const a = m.a, id = a.run || a.pic; if (!a.d) return /feint/i.test(a.n) ? pickRun(['blue_feint' + sfx(m.at), 'blue_feint']) : /push/i.test(a.n) ? pickRun(['blue_push']) : '';
      const base = `blue_${id}_`, far = m.at > Math.max(...a.reach);
      return a.reach.includes(m.at) ? pickRun([base + 'landed' + sfx(m.at), base + 'landed']) : pickRun([...(far ? [base + 'short' + sfx(m.at), base + 'short'] : []), base + 'missed' + sfx(m.at), base + 'missed', base + 'landed' + sfx(m.at)]); }); }
  function preview(delay) { stop(); if (phase !== 'plan' || P.clinch || !P.ord.length) return; const mine = tok, runs = runsOf(); if (!runs.some(Boolean)) return;
    setTimeout(() => { if (mine !== tok || phase !== 'plan') return; Promise.race([warm(runs.filter(Boolean)), new Promise((ok) => setTimeout(ok, 2500))]).then(() => { if (mine !== tok || phase !== 'plan') return; playing = true;
      ghost.style.translate = im.style.translate; let k = 0;
      const next = () => { if (mine !== tok || phase !== 'plan') return; if (k >= runs.length) { ghost.classList.remove('on'); nowAt = -1; light(); return setTimeout(() => { if (mine !== tok) return; playing = false; if (hov) preview(500); }, 350); }
        nowAt = k; light(); const run = runs[k++], r = run && ANIM[run]; if (!r || !r.files.every((f) => PRE[f] && PRE[f].naturalWidth)) return setTimeout(next, 450);
        let i = 0; const show = () => { if (mine !== tok || phase !== 'plan') return; ghost.src = PRE[r.files[i]].src; ghost.classList.add('on'); if (i >= r.files.length - 1) return setTimeout(next, 260);
          const w = Math.min(MAX_GAP, (r.offs[i + 1] - r.offs[i]) * 1000) + (i === r.contact ? HOLD : 0); i++; setTimeout(show, w); };
        show(); };
      next(); }); }, delay); }
  /* S567, owner: "makeiteasy to drag and rop the items" - a move card of the panel can be dragged onto one of the three slots under the ring: it is chosen AND put at that moment. A plain click still picks it (last in the order). */
  function cardDrag() { for (const b of document.querySelectorAll('#board .sw')) { if (b.disabled || b.classList.contains('home') || b.dataset.g === 'clinch' || (b.dataset.g === 'feet' && b.dataset.id === 'hold')) continue; b.style.touchAction = 'none';
      b.addEventListener('pointerdown', (e) => { if (e.button > 0 || phase !== 'plan') return; const x0 = e.clientX, y0 = e.clientY; let fly = null, moved = false;
        const slotAt = (x, y) => [...document.querySelectorAll('#strip .slot')].findIndex((s) => { const r = s.getBoundingClientRect(); return x >= r.left - 6 && x <= r.right + 6 && y >= r.top - 30 && y <= r.bottom + 30; });
        const mark = (k) => document.querySelectorAll('#strip .slot').forEach((s, i) => { s.style.outline = i === k ? '2px solid #7fe9ff' : ''; s.style.outlineOffset = '2px'; });
        const move = (ev) => { if (!moved && Math.hypot(ev.clientX - x0, ev.clientY - y0) < 8) return; if (!moved) { moved = true; stop(); fly = b.cloneNode(true); const r = b.getBoundingClientRect(); fly.style.cssText = `position:fixed;z-index:9999;pointer-events:none;width:${r.width}px;opacity:.92;box-shadow:0 .4rem 1.2rem #000c;left:0;top:0`; document.body.appendChild(fly); document.getElementById('strip') && (document.getElementById('strip').style.boxShadow = '0 0 0 2px rgba(127,233,255,.35)'); }
          fly.style.transform = `translate(${ev.clientX - fly.offsetWidth / 2}px, ${ev.clientY - 18}px)`; mark(slotAt(ev.clientX, ev.clientY)); };
        const end = (ev) => { removeEventListener('pointermove', move); removeEventListener('pointerup', end); removeEventListener('pointercancel', end); if (fly) fly.remove(); mark(-1); if (!moved) return;
          const kill = (c) => { c.stopPropagation(); c.preventDefault(); }; addEventListener('click', kill, { capture: true, once: true }); setTimeout(() => removeEventListener('click', kill, { capture: true }), 80);   /* the release is not a click on the card */
          const k = ev.type === 'pointerup' ? slotAt(ev.clientX, ev.clientY) : -1; if (k < 0) return plan(); const g = b.dataset.g, id = b.dataset.id; P.clinch = false; if (g === 'feet') P.feet = id; else P[g] = id;
          const o = ordOf(P).filter((sl) => sl !== g); o.splice(Math.min(k, o.length), 0, g); P.ord = o; plan(); if (window.bodyOverview) bodyOverview(); };
        addEventListener('pointermove', move); addEventListener('pointerup', end); addEventListener('pointercancel', end); }); } }
  const board1 = board, go2 = go;
  board = function () { board1(); strip(); cardDrag(); };
  go = function () { stop(); lastKey = ''; const el = document.getElementById('strip'); if (el) el.remove(); return go2(); };
  window.stripState = () => ({ slots: [...document.querySelectorAll('#strip .slot')].map((s) => s.textContent), playing, nowAt, ghost: (ghost.getAttribute('src') || '').split('/').pop(), on: ghost.classList.contains('on'), runs: phase === 'plan' && !P.clinch ? runsOf() : [] });   /* read by the browser check */
  if (typeof phase !== 'undefined' && phase === 'plan') strip();
})();

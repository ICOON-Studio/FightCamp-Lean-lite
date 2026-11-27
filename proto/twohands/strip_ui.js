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
    '#strip .slot .lm{font-size:.72rem;color:var(--muted);line-height:1.15}#strip .slot.empty b{color:#bfe6c3}#strip .ln3{display:flex;align-items:center;gap:.3rem;font-size:.78rem;line-height:1.25;white-space:nowrap}#strip .ln3 i{width:.45rem;height:.45rem;border-radius:50%;flex:none}#strip .ln3 em{font-style:normal;color:var(--muted);width:2.1rem;flex:none;font-size:.72rem}#strip .ln3.act b{font-size:.9rem;color:#fff}#strip .ln3x{font-size:.68rem;line-height:1.15;color:var(--muted);white-space:normal}#strip .slot{justify-content:flex-start}#strip .slot.empty .lm{font-size:.8rem;color:#d8cfc2}#strip .slot.full.sel{box-shadow:0 0 0 2px var(--gold),0 0 .9rem rgba(227,171,69,.55)}#strip .pt.sel{color:var(--gold);font-weight:700}#strip .sel.flash{animation:selflash 1.1s ease-out}@keyframes selflash{0%{filter:brightness(2.2)}100%{filter:none}}' +   /* S568: the whole boxer in each moment */
    /* S567, owner: "make the strip like rune colossieum , left side for left fighter and right side for the right fighter and the fill the slots when the beat is resolved time the actions for the result" */
    '#strip .slot,#strip .hslot{width:11.6rem}#strip .hslot{position:relative;min-height:4.3rem;border-radius:.55rem;border:1px dashed var(--line2);padding:.3rem 2rem .35rem .55rem;display:flex;flex-direction:column;justify-content:center;gap:.08rem;font-size:.82rem;line-height:1.2;text-align:right;color:var(--muted)}' +
    '#strip .hslot .no{position:absolute;right:.45rem;top:50%;transform:translateY(-50%);font-size:1.5rem;font-weight:700;color:var(--muted);opacity:.7}#strip .hslot b{font-size:1rem;color:#ffd0cb}#strip .hslot.shown{border:1px solid var(--red);background:#2a1614;color:#efe4d2}#strip .hslot.shown .no{color:var(--red);opacity:1}#strip .hslot.old{opacity:.5}' +
    '#strip .hslot.playing,#strip .slot.now{border-color:#fff;box-shadow:0 0 .7rem rgba(255,255,255,.6)}#strip .vs{align-self:center;font-weight:800;letter-spacing:.1em;color:var(--muted);padding:0 .35rem;font-size:.8rem;text-align:center;line-height:1.2}#strip .hisrow{display:flex;flex-direction:row;gap:.45rem;align-items:stretch}#strip .res{font-weight:700}#strip .res.good{color:#bfe6c3}#strip .res.bad{color:#ffb3ad}#strip .res.flat{color:var(--muted)}' +
    '#strip .slot.static{cursor:default}' +
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
  /* S568 (owner: "why have 3 actions if only 2 get filled ? the hold ground does not appear on the strip the hands posstion
     same , shouldnt all the selection appear on the strip ?"): a beat is three moments whether you act in them or not - his
     moment 3 meets yours. Each slot now shows the WHOLE boxer in that moment: the limbs that do not act, as they stand then
     (a hand that punches in another moment is held HIGH, the rule; a held hand at its height; the feet still or already
     moved). An empty moment reads "guarding", not "nothing". Its tip says what each held hand stops. (Ludo S567: "what
     each hand blocks or leaves open, per moment".) */
  function limbs(i, actor) { const txt = [], tip = [], hasC = typeof COVER !== 'undefined' && typeof THREAT !== 'undefined';
    for (const h of ['lead', 'rear']) { if (h === actor || P.clinch) continue; const pos = P[h] ? 'high' : h === 'lead' ? P.hl : P.hr; txt.push(`<span class="pt" data-p="${h}">${h} ${pos}</span>`);
      const line = hasC && COVER[pos] ? COVER[pos][h === 'lead' ? 0 : 1] : null; if (line && THREAT[line]) tip.push(`${h === 'lead' ? 'Lead' : 'Rear'} hand ${pos}: stops ${THREAT[line].replace(/^His /, 'his ')}${P[h] ? ` (it punches in moment ${P.ord.indexOf(h) + 1}, and is back up after)` : ''}.`); }
    if (actor !== 'feet') { const at = P.ord.indexOf('feet'), nm = P.feet === 'hold' ? '' : ((FEET[P.feet] || ACT[P.feet] || {}).n || P.feet).toLowerCase(); const moved = clampR(range + feetStep()) !== range;   /* a back off at Long (or a step in Inside) has no room: it did not move */
      txt.push(`<span class="pt" data-p="feet">${at >= 0 && at < i ? (moved ? ({ in: 'stepped in', back: 'backed off' }[P.feet] || nm) : 'stay put (no room)') : 'stay put'}</span>`); }
    return { txt: txt.join(' · '), tip: (tip.join('\n') || 'Both hands held: they block.').replace(/"/g, '') }; }
  const feetStep = () => (P.feet === 'in' || P.feet === 'slipin' ? -1 : P.feet === 'back' ? 1 : 0);
  const actOf = (sl) => (sl === 'wait' ? null : sl === 'feet' ? (ACT[P.feet] && ACT[P.feet].d ? ACT[P.feet] : null) : ACT[P[sl]]);
  // what each moment is: its words for the card, and the range it happens at / leaves the men at
  function moments() { let r = range; return P.ord.map((sl) => { const a = actOf(sl), at = r;
      if (sl === 'wait') return { sl, name: 'Wait', line: '<i>nothing yet: your step comes next</i>', at, to: r };
      if (sl === 'feet' && !a) { const d = feetStep(); r = clampR(r + d); return { sl, name: FEET[P.feet].n, line: d ? (r === at ? '<span class="no2">no room to move</span>' : `<span class="ok">${RNG[at]} &rarr; ${RNG[r]}</span>`) : '<i>on the spot</i>', at, to: r }; }
      if (!a.d) return { sl, a, name: a.n, line: `<i>your ${sl} hand, no damage</i>`, at, to: r };
      const hold = sl === 'lead' ? P.hl : sl === 'rear' ? P.hr : null, open = hold ? THREAT[COVER[hold][sl === 'lead' ? 0 : 1]] : '';
      return { sl, a, name: a.n, line: a.reach.includes(r) ? `<span class="ok">reaches at ${RNG[r]}</span>` : `<span class="no2">will not reach at ${RNG[r]}</span>`, open, at, to: r }; }); }
  /* S568 (owner: "highlight on the strip which action is being selected . try it yourself to put the hold postition and see
     if anything changes" - a hold changed only small grey words): the part you are choosing lights up on the strip - its card,
     or its words in every moment it covers (lead low, stay put). A row opened or a move pointed at lights it; a pick flashes
     it and it stays lit until the next beat. Read in the capture phase, before the click redraws the strip. */
  let focus = null, flashAt = 0, focusBeat = '';
  const partOf = (el) => { const r = el.closest && el.closest('button[data-k^="0:"]'), sw = el.closest && el.closest('.sw[data-g]'), sl = el.closest && el.closest('#strip .slot.full[data-sl]');
    return r ? r.dataset.k.slice(2) : sw ? sw.dataset.g : sl ? sl.dataset.sl : null; };
  document.addEventListener('click', (e) => { const p = partOf(e.target); if (p && ['lead', 'rear', 'feet'].includes(p)) { focus = p; focusBeat = round + ':' + beat; if (e.target.closest('.sw')) flashAt = Date.now(); setTimeout(mark, 0); } }, true);   /* opening a row does not redraw the strip: mark it after the click */
  document.addEventListener('mouseover', (e) => { const sw = e.target.closest && e.target.closest('.sw[data-g]'); if (sw && ['lead', 'rear', 'feet'].includes(sw.dataset.g) && sw.dataset.g !== focus) { focus = sw.dataset.g; focusBeat = round + ':' + beat; mark(); } });
  function mark() { const el = document.getElementById('strip'); if (!el) return; for (const x of el.querySelectorAll('.sel')) x.classList.remove('sel', 'flash');
    if (!focus || focusBeat !== round + ':' + beat) return; const fl = Date.now() - flashAt < 1200;
    for (const x of el.querySelectorAll(`.slot.full[data-sl="${focus}"], .pt[data-p="${focus}"]`)) { x.classList.add('sel'); if (fl) x.classList.add('flash'); } }
  /* S568 THE LANES (owner, with a screenshot: "i select stay put andnothing like thatappears onthe strip i cant understand
     what i am doing wrong"): each moment shows three labelled rows, one per limb, in the hand's card colours - Lead, Rear,
     Feet - so every choice sits on the strip in its own row: the guards, Stay put, and the move in the moment it happens.
     The acting row is bold; under it, whether it reaches and what it leaves open. The .pt parts light up as before. */
  const LANE = { lead: ['Lead', '#378ADD'], rear: ['Rear', '#D85A30'], feet: ['Feet', '#1D9E75'] };
  function lanes(i, m) { const actor = m ? m.sl : null, rows = [];
    for (const h of ['lead', 'rear', 'feet']) { let v;
      if (P.clinch) v = h === 'feet' ? 'clinch' : 'tied up';
      else if (actor === h) v = `<b>${m.name}</b>`;
      else if (h === 'feet') { const at = P.ord.indexOf('feet'), moved = clampR(range + feetStep()) !== range; v = at >= 0 && at < i ? (moved ? ({ in: 'stepped in', back: 'backed off' }[P.feet] || P.feet) : 'stay put (no room)') : 'Stay put'; }
      else if (h === 'lead' && P.lead === 'feint' && P.ord.indexOf('lead') > i) v = '<span class="no2">open - feint coming</span>';   /* S568 G1 (his rule): the feinting hand guards nothing before its feint */
      else { const pos = P[h] ? 'high' : h === 'lead' ? P.hl : P.hr, ln = typeof COVER !== 'undefined' ? COVER[pos][h === 'lead' ? 0 : 1] : ''; v = ln ? 'blocks ' + ({ straight: 'jab/cross', side: 'hooks', under: 'uppercuts', body: 'body' }[ln] || (THREAT[ln] || ln).replace(/^His /, '')) : 'guard ' + pos; }   /* short words: a strip moment is narrow */   /* S568: what the held hand blocks, not just high / low */
      rows.push(`<span class="ln3${actor === h ? ' act' : ''}"><i style="background:${LANE[h][1]}"></i><em>${LANE[h][0]}</em><span class="pt" data-p="${h}">${v}</span></span>`); }
    if (m && m.sl !== 'wait') rows.push(`<span class="ln3x">${m.line}${m.open ? ` <span class="no2">· open: ${m.open.toLowerCase()}</span>` : ''}</span>`);
    return rows.join(''); }
  function strip() { const old = document.getElementById('strip'); if (old) old.remove(); if (phase !== 'plan' || P.clinch) { stop(); return; }
    const ms = moments(), n = Math.max(3, ms.length), el = document.createElement('div'); el.id = 'strip';
    el.innerHTML = '<span class="hd">This beat</span>' + Array.from({ length: n }, (x, i) => { const m = ms[i];
      if (!m) { const L = limbs(i, null); return `<div class="slot empty" data-tip="${L.tip}"><span class="no">${i + 1}</span>${lanes(i, null)}</div>`; }
      const tip = m.sl === 'wait' ? 'An empty moment before your step. Switch it off with the button beside the strip.' : `${NTH[i]} moment: ${m.name}. Drag the card to another slot to change when it happens (a click: one slot earlier).\nYour ${NTH[i]} moment meets his ${NTH[i]} moment.`;
      return `<div class="slot full${m.sl === 'wait' ? ' wait' : ''}" data-sl="${m.sl}" data-tip="${tip}"><span class="no">${i + 1}</span>${lanes(i, m)}</div>`; }).join('');
    el.innerHTML += hisSide(false);
    lines.insertBefore(el, lines.firstChild);
    mark();
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
  // ---- HIS SIDE of the strip, and the strip while a beat is fought
  let lastHis = [], nowHis = [], mineNow = [];
  const hisName = () => (typeof OPP !== 'undefined' && OPP ? OPP.n : 'him');
  function hisSide(live) { const src = live ? nowHis : lastHis, tip = live ? '' : ` data-tip="His three moments. They stay hidden until the beat is fought: what you see here is what he did LAST beat."`;
    return `<span class="vs">${live ? 'NOW' : 'VS'}</span><span class="hisrow"${tip}>` + [0, 1, 2].map((i) => `<div class="hslot${src[i] ? ' shown' + (live ? '' : ' old') : ''}" data-m="${i}"><span class="no">${i + 1}</span>${src[i] || (live ? '<i>?</i>' : `<i>${lastHis.length ? 'nothing' : '?'}</i>`)}</div>`).join('') + '</span>'; }
  // the beat is being fought: your three moments stay (no dragging), his are hidden and fill as each moment plays
  function playStrip() { const old = document.getElementById('strip'); if (old) old.remove(); if (P.clinch) return; const ms = moments(), el = document.createElement('div'); el.id = 'strip'; nowHis = []; mineNow = ms;
    el.innerHTML = '<span class="hd">This beat</span>' + [0, 1, 2].map((i) => { const m = ms[i]; return m ? `<div class="slot full static" data-m="${i}"><span class="no">${i + 1}</span><b>${m.name}</b><span class="res flat">&hellip;</span></div>` : `<div class="slot empty" data-m="${i}"><span class="no">${i + 1}</span><i>nothing</i></div>`; }).join('') + hisSide(true);
    lines.insertBefore(el, lines.firstChild); }
  /* called by the page for every action of the beat: once when it starts (done = false: the slot lights and, for him, shows WHAT he does) and once when its result is known (done = true: lands, blocked, missed - at the moment the picture shows it) */
  window.stripEvent = (e, done) => { const el = document.getElementById('strip'); if (!el || e.m == null) return; const m = e.m, punch = e.t === 'hit' || e.t === 'block' || e.t === 'miss';
    const res = (mine) => (e.t === 'hit' ? `<span class="res ${mine ? 'good' : 'bad'}">lands &minus;${e.dmg}${e.down ? ' - DOWN' : ''}</span>` : e.t === 'block' ? `<span class="res ${mine ? 'bad' : 'good'}">blocked</span>` : e.t === 'miss' ? `<span class="res ${mine ? 'bad' : 'good'}">missed</span>` : `<span class="res flat">${e.t === 'range' ? e.a : (e.o || '').split(' - ')[0]}</span>`);
    const sides = e.t === 'range' ? [/\byou\b/.test(e.o || '') ? 0 : -1, /\bhe\b/.test(e.o || '') ? 1 : -1].filter((k) => k >= 0) : e.k === 0 || e.k === 1 ? [e.k] : [];
    for (const c of el.querySelectorAll('.now,.playing')) c.classList.remove('now', 'playing');
    for (const k of sides) { if (k === 0) { const c = el.querySelector(`.slot[data-m="${m}"]`); if (!c) continue; c.classList.add('now'); if (done) { const r = c.querySelector('.res'); if (r) r.outerHTML = res(true); } }
      else { const c = el.querySelector(`.hslot[data-m="${m}"]`); if (!c) continue; const name = e.t === 'range' ? (/he steps in/.test(e.o) ? 'Step in' : /he backs off/.test(e.o) ? 'Back off' : 'Moves') : punch || e.id ? e.a : (e.a || '').replace(/^./, (x) => x.toUpperCase());
        nowHis[m] = `<b>${name}</b>${done ? res(false) : '<span class="res flat">&hellip;</span>'}`; c.className = 'hslot shown playing'; c.innerHTML = `<span class="no">${m + 1}</span>` + nowHis[m]; } } };
  const board1 = board, go2 = go;
  board = function () { if (nowHis.length || mineNow.length) { lastHis = nowHis.map((h) => h && h.replace('&hellip;', '')); nowHis = []; mineNow = []; } board1(); strip(); cardDrag(); };
  go = function () { stop(); lastKey = ''; if (!busy) playStrip(); return go2(); };   /* S567: the strip stays while the beat is fought */
  window.stripState = () => ({ slots: [...document.querySelectorAll('#strip .slot')].map((s) => s.textContent), playing, nowAt, ghost: (ghost.getAttribute('src') || '').split('/').pop(), on: ghost.classList.contains('on'), runs: phase === 'plan' && !P.clinch ? runsOf() : [] });   /* read by the browser check */
  if (typeof phase !== 'undefined' && phase === 'plan') strip();
})();

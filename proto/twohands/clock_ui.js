// CLOCK_UI (S568, owner: "we can also try limited time decisions (like 5 seconds for the player to think) on the 1 action
// per beat test"). A decision clock: while you plan a beat, the Fight button counts down; at 0 the beat is fought with what
// you have chosen (nothing chosen = both hands held, feet still - as the page's own Fight does).
// On by default on one.html (5 s); any page takes it with ?clock=<seconds> (?clock=0 = off). A "Clock" button in the top bar
// switches it off and on (remembered: localStorage pc_clock). Never on the guided first beat (body_ui.js, pc_guided).
// Loaded by ring_ui.js only when the page asks for it; it reads the page's globals (phase, round, beat, plan, go) and
// changes no rule. Nothing near the fighters: the count is on the Fight button and a thin bar under it.
(function () {
  const q = /[?&]clock=(\d+)/.exec(location.search), SECS = q ? Number(q[1]) : /one\.html$/.test(location.pathname) ? 5 : 0;
  const RQ = /[?&]round=(\d+)/.exec(location.search), RSECS0 = RQ ? Number(RQ[1]) : /one\.html$/.test(location.pathname) ? 60 : 0;
  if (!SECS && !RSECS0) return;
  const KEY = 'pc_clock', on = () => { try { return localStorage.getItem(KEY) !== 'off'; } catch (e) { return true; } };
  const guidedNow = () => { try { return round === 1 && beat === 0 && !localStorage.getItem('pc_guided'); } catch (e) { return false; } };
  let key = '', t0 = 0, timer = null;
  const css = document.createElement('style');
  css.textContent = '#go.clk{position:relative;overflow:hidden}#go.clk .clkbar{position:absolute;left:0;bottom:0;height:4px;background:#1b1209;opacity:.55;transition:width .1s linear}#go.clk.low{animation:pulse .5s infinite}#clockbtn.off{opacity:.55}';
  document.head.appendChild(css);
  let fitTop = () => {};
  const top = document.querySelector('.top'), mute = document.getElementById('mute');
  if (top) { const b = document.createElement('button'); b.className = 'btn'; b.id = 'clockbtn'; b.style.cssText = 'padding:.2rem .6rem;min-height:0;font-size:.85rem;margin-right:.4rem';
    const label = () => { b.textContent = on() ? 'Clock: on' : 'Clock: off'; b.classList.toggle('off', !on()); b.title = `${SECS ? `${SECS} seconds to choose each beat (at 0 it is fought as chosen). ` : ''}${RSECS0 ? `${RSECS0} seconds a round (at 0 the bell rings). ` : ''}Click to switch the clock ${on() ? 'off' : 'on'}.`; };
    b.onclick = () => { try { localStorage.setItem(KEY, on() ? 'off' : 'on'); } catch (e) {} label(); key = ''; if (!on()) stop(); else arm(); if (window.rArmClock) window.rArmClock(); }; label();
    if (mute) top.insertBefore(b, mute); else top.appendChild(b);
    /* the top bar wraps (flex-wrap) and a second line pushes the page off the 1080 screen: if it does, the long hint goes
       (the guided first beat teaches it) and the Clock button takes its place at the right */
    /* run again on every tick: the round time and the round scores grow the bar after the first look. If it still wraps,
       the "trial" label goes too (the ops-board button says it is a trial) */
    const wraps = () => { const kids = [...top.children].filter((c) => c.offsetParent); return kids.length && kids.some((c) => c.offsetTop > kids[0].offsetTop + 8); };
    fitTop = () => { if (!wraps()) return; const labs = [...top.querySelectorAll('.lab')], hint = labs.find((l) => /click your boxer/i.test(l.textContent)), trial = labs.find((l) => /^trial/i.test(l.textContent.trim()));
      if (hint && hint.style.display !== 'none') { hint.style.display = 'none'; b.style.marginLeft = 'auto'; if (!wraps()) return; } if (trial) trial.style.display = 'none'; };
    setTimeout(fitTop, 400); }
  function stop() { clearInterval(timer); timer = null; const g = document.getElementById('go'); if (g) { g.classList.remove('clk', 'low'); const bar = g.querySelector('.clkbar'); if (bar) bar.remove(); } }
  function tick() { fitTop(); const g = document.getElementById('go'); if (phase !== 'plan' || !g) { stop(); return; }
    const left = Math.max(0, SECS - (Date.now() - t0) / 1000), n = Math.ceil(left);
    const txt = `Fight this beat · ${n}`; if (!g.firstChild || g.firstChild.nodeValue !== txt) { g.textContent = txt; }
    g.classList.add('clk'); g.classList.toggle('low', left <= 2); let bar = g.querySelector('.clkbar'); if (!bar) { bar = document.createElement('i'); bar.className = 'clkbar'; g.appendChild(bar); } bar.style.width = (100 * left / SECS) + '%';
    if (left <= 0) { stop(); key = 'fought:' + key; g.click(); } }
  function arm() { if (!SECS || !on() || phase !== 'plan' || guidedNow()) { stop(); return; } const k = round + ':' + beat; if (k === key || key === 'fought:' + k) return; key = k; t0 = Date.now(); stop(); timer = setInterval(tick, 100); tick(); }
  /* S568 THE ROUND CLOCK (owner: "can you maybe add a real timer like 1 minute for the round ?"): real time, pictures
     included, from the round's first plan. At 0 the bell rings: while you choose, at once (that beat is not thrown); while a
     beat plays, as soon as it ends. Fewer beats get thrown when you think slowly, as in a real round. ?round=<s> (default
     60 on one.html, 0 = off); the same Clock button switches it off. The time left sits in the top bar, never in the ring. */
  const RSECS = RSECS0;
  let rT0 = 0, rRound = 0, rDone = 0, rTimer = null; const rEl = document.createElement('b'); rEl.id = 'rclock'; rEl.style.cssText = 'font-variant-numeric:tabular-nums;margin-left:.4rem';
  const where = document.getElementById('where'); if (RSECS && where) where.insertAdjacentElement('afterend', rEl);
  const rLeft = () => Math.max(0, RSECS - (Date.now() - rT0) / 1000);
  function rTick() { fitTop(); if (!rT0 || (phase !== 'plan' && phase !== 'play')) { rEl.textContent = ''; return; } const l = rLeft(), s = Math.ceil(l);
    rEl.textContent = `${Math.floor(s / 60)}:${String(s % 60).padStart(2, '0')}`; rEl.style.color = l <= 10 ? '#ff8f86' : 'var(--gold)'; rEl.title = `Round clock: at 0 the bell rings, whatever beat you are on (${RSECS} s a round). Switch it off with the Clock button.`;
    if (l <= 0 && rDone !== round && phase === 'plan') { rDone = round; stop(); key = 'bell:' + round; bell(); } }   /* in 'play' the beat ends first: plan() below rings it */
  function rArm() { if (!RSECS || !on() || guidedNow()) { rT0 = 0; rTick(); return; } if (rRound !== round || !rT0) { rRound = round; rT0 = Date.now(); } if (!rTimer) rTimer = setInterval(rTick, 200); rTick(); }
  const plan0 = plan; plan = function () { if (RSECS && rT0 && rRound === round && rDone !== round && rLeft() <= 0 && phase === 'play') { rDone = round; stop(); return bell(); } plan0(); rArm(); arm(); };
  window.rArmClock = () => { if (!on()) { rT0 = 0; rTick(); } else rArm(); };
  window.clockState = () => ({ secs: SECS, on: on(), armed: !!timer, left: timer ? Math.max(0, SECS - (Date.now() - t0) / 1000) : null, key, roundSecs: RSECS, roundLeft: rT0 ? rLeft() : null, roundOf: rRound });
})();

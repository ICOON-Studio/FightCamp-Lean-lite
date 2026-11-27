/* LAYERS0 (S570) - ONE MAN PER PICTURE, behind ?layers=1 (ops/research/LAYERS_SCOPE_S569.md, approved S570).
   Owner S569: "the fighter get displaced without moving"; "sohow fighting games cope with distance ? what are we doing
   differently ?". Every two-man frame put BOTH men where its own run placed them and the page slid the whole picture, so
   a run a few px off was a jump. Here each man is his own picture (img/layers/, cut by tools/layers_cut.py from the
   frame's part mask) and the PAGE keeps his spot: red's feet at his guard spot + the metres he has come in (redM), blue's
   at his + blueM - the same numbers the page already keeps. A run only adds its own movement since its first frame
   (root[k] - root[0]), so the next run starts where the last one ended: no jump at a run boundary.
   A run with no layers yet plays the old two-man picture as before. Without ?layers=1 this file does nothing. */
(() => {
  if (!/[?&]layers=1\b/.test(location.search)) return;
  const st = document.getElementById('stage'), im = document.getElementById('pic');
  if (!st || !im) return;
  let L = null, FILE = {}, CANON = null;
  const lay = ['red', 'blue'].map((side) => { const e = document.createElement('img'); e.className = 'lay ' + side; e.alt = ''; e.style.display = 'none'; st.insertBefore(e, im.nextSibling); return e; });
  const css = document.createElement('style'); css.textContent = '.stage img.lay{pointer-events:none}.stage img.pic-off{opacity:0}'; document.head.appendChild(css);
  Promise.all([fetch('img/layers/frames.json').then((r) => r.json()), fetch('img/anim/frames.json').then((r) => r.json())]).then(([lj, aj]) => {
    L = lj;
    for (const [run, row] of Object.entries(aj.runs || {})) (row.files || []).forEach((f, k) => { FILE[f] = [run, k]; });
    /* the guard spots: where blue's own hold at Long puts each man on its first frame (picture metres, +x = blue's side) */
    const h = L.runs['blue_both_high_high_blue'], hr = L.runs['blue_both_high_high_red'];
    CANON = h && hr ? { blue: h.root[0], red: hr.root[0] } : { blue: 1.05, red: -0.68 };
    draw();
  }).catch(() => {});
  /* the page's metres in from each guard spot: ring_ui keeps redM / blueM inside its closure, so read them from the range
     and the slide it applies (a red run slides by -blueM, a blue run by redM) - falls back to the range split evenly */
  const inM = () => { const r = typeof range === 'number' ? range : 3, RM = { 3: 0, 2: 0.355, 1: 0.55 }, tot = RM[r] ?? 0;
    const w = window.__ringM; return w && Number.isFinite(w.redM) ? { red: w.redM, blue: w.blueM } : { red: tot / 2, blue: tot / 2 }; };
  function draw() {
    if (!L || !CANON) return;
    const f = (im.getAttribute('src') || '').split('/').pop(), at = FILE[f];
    const rows = at && ['red', 'blue'].map((s) => L.runs[`${at[0]}_${s}`]);
    if (!rows || !rows[0] || !rows[1]) { for (const e of lay) e.style.display = 'none'; im.classList.remove('pic-off'); return; }
    const k = at[1], ppm = (L.camera.px_per_m || 152.4) * (st.clientHeight * 1.26 / (L.camera.web_px || 480)), m = inM();
    ['red', 'blue'].forEach((side, i) => { const row = rows[i], e = lay[i], r0 = row.root[0], rk = row.root[Math.min(k, row.root.length - 1)];
      if (r0 == null || rk == null) { e.style.display = 'none'; return; }
      const spot = side === 'red' ? CANON.red + m.red : CANON.blue - m.blue;   /* picture metres: red comes in toward +x, blue toward -x */
      const want = spot + (rk - r0), dx = want - rk;                           /* move this layer so his feet stand on `want` */
      e.src = 'img/layers/' + row.files[Math.min(k, row.files.length - 1)];
      e.style.translate = `${(-dx * ppm).toFixed(1)}px 0px`;                   /* the picture is drawn mirrored: its +x is the screen's -x */
      e.style.display = ''; });
    im.classList.add('pic-off');
  }
  new MutationObserver(draw).observe(im, { attributes: true, attributeFilter: ['src'] });
  addEventListener('resize', draw);
  window.layersState = () => ({ on: !!L, canon: CANON, m: inM(), shown: lay.map((e) => e.style.display !== 'none' && e.getAttribute('src')), tr: lay.map((e) => e.style.translate) });
})();

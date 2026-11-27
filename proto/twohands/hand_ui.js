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
    for (const id of ['handhd', 'guardbar', 'cards', 'farbox']) { const old = document.getElementById(id); if (old) old.remove(); }
    const hd = document.createElement('div'); hd.id = 'handhd'; hd.textContent = 'Your hand'; hd.title = 'Click a card, or drag it onto a moment under the ring. The guard switches take no moment.';
    const gb = document.createElement('div'); gb.id = 'guardbar';
    for (const g of ['lead', 'rear']) { const lab = document.createElement('span'); lab.className = 'gl'; lab.textContent = g === 'lead' ? 'Lead arm guard' : 'Rear arm guard'; gb.appendChild(lab);
      for (const h of ['high', 'low']) { const b = all.find((x) => x.dataset.g === g && x.dataset.id === h); if (b) { b.querySelector('b').innerHTML = `${h === 'high' ? 'High' : 'Low'}<small>${stops(g, h)}</small>`; gb.appendChild(b); } } }
    const cards = document.createElement('div'); cards.id = 'cards'; const far = document.createElement('div'); far.id = 'farcards';
    for (const b of all) { if (b.classList.contains('home')) continue; b.style.borderTopColor = COL[b.dataset.g] || COL.clinch; (b.classList.contains('far') || (b.dataset.g === 'clinch' && range > 1) ? far : cards).appendChild(b); }   /* the clinch works Inside only */
    brd.prepend(hd, gb, cards);
    if (far.children.length) { const fb = document.createElement('details'); fb.id = 'farbox'; fb.open = farOpen; fb.innerHTML = `<summary>Doesn't reach (${far.children.length})</summary>`; fb.appendChild(far); fb.ontoggle = () => { farOpen = fb.open; }; brd.appendChild(fb); } }
  function init() { const plan0 = plan; plan = function () { plan0(); lay(); }; if (phase === 'plan') lay(); }
  if (document.readyState === 'complete') init(); else addEventListener('load', init);
  window.handState = () => ({ cards: [...document.querySelectorAll('#cards .sw')].map((b) => b.dataset.g + ':' + b.dataset.id), far: [...document.querySelectorAll('#farcards .sw')].map((b) => b.dataset.g + ':' + b.dataset.id), guard: [...document.querySelectorAll('#guardbar .sw')].map((b) => b.dataset.g + ':' + b.dataset.id + (b.classList.contains('on') ? '*' : '')) });
})();

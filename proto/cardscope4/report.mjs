// CARDSCOPE4: prints the card table as it is sized (markdown), for the scope page. node report.mjs
import { CARDS, N, OWN, STYLES } from './cards.mjs';
const where = (c) => (c.at ? c.at.join(' ').replace(/\bK\b/, 'KICK').replace(/\bP\b/, 'PUNCH').replace(/\bC\b/, 'CLINCH').replace(/\bG\b/, 'GROUND').replace(/T(\d)/g, 'top$1').replace(/\bT\b/, 'top').replace(/B(\d)/g, 'under$1') : 'answer');
const what = (c) => c.k === 'strike' ? `${c.dmg} damage${c.pts ? `, ${c.pts} pt` : ''}${c.kick ? ', a kick' : ''}${c.drain ? ', takes 1 wind' : ''}${c.cripple ? ', hurts the leg (1 wind)' : ''}${c.unblock ? ', cannot be blocked' : ''}${c.enter ? ', steps in from KICK' : ''}${c.blitz ? ', blitz from KICK' : ''}`
  : c.k === 'shot' ? `takedown to rung ${c.to}, ${c.pts} pt${c.gripPts ? ` (+${c.gripPts} behind a grip)` : ''}${c.dmg ? `, ${c.dmg} damage` : ''}${c.needGrip ? ', needs the grip' : ''}${c.cleanIf ? `, clean if ${c.cleanIf}` : ''}`
  : c.k === 'hold' ? `${c.hk === 'sub' ? 'submission' : `pin (+${c.hpts} pt)`}, countdown ${c.count}` : c.k === 'adv' ? `up one rung, ${c.pts} pt` : c.k === 'setup' ? 'set-up: next turn\'s throw or shot is clean' : c.k === 'move' ? 'to the ground, you underneath in guard' : c.vs;
console.log('| Style | Card | In deck | Wind | Where | What it does |\n|---|---|---|---|---|---|');
for (const s of STYLES) for (const [id, n] of Object.entries(OWN[s])) { const c = CARDS[id]; console.log(`| ${s} | ${c.n} | ${n} | ${c.w} | ${where(c)} | ${what(c)} |`); }
for (const id of ['sprawl', 'escape']) console.log(`| every deck | ${CARDS[id].n} | ${id === 'sprawl' ? 2 : 1} | ${CARDS[id].w} | answer | ${CARDS[id].vs} |`);
console.log('\n' + JSON.stringify(N));
